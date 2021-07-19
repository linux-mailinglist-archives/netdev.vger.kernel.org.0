Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 144193CCE72
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 09:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234823AbhGSHZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 03:25:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234559AbhGSHZz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 03:25:55 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64062C061762
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 00:22:55 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id gb6so26998666ejc.5
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 00:22:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wM1rb/gmdPeOZ6FJpFaplJnOYR4K1cm0jlU1hEXr38s=;
        b=KATtogEFo9OqXImI3C/eS7sxD8mDnUTjCyBuXvJf6hjAcSw+ClT4A2jfaGzJExvEPp
         SzsnIyRLX58g9zPXkg5SRLHfmX0az2cusXDoadf4JjBO93QCysHE2fFHzUg90FYYH80S
         j3arLrmaGV9xPRfxLXrRGFYicOQK6CB4urRCjocPJtIxPg4BfteRRJUn7B4pWxKZHE4/
         w6+I7NY3l+7BbbNv0Xx7gvKXp5GWgjhP1xVShzFsHkrJnum3z7Ral5ARsnCTByYXFhni
         hSl0dPxMls/gKvT1cTeTOAtDEdFMdk008bEQNBDnvtLhfn9mS5VCuOX49Xh4t02Jkzdk
         l52g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wM1rb/gmdPeOZ6FJpFaplJnOYR4K1cm0jlU1hEXr38s=;
        b=foH00svpXWF/JYGb8ss+FvfabaTCClU+QPv696k7eHmubFEV1IMEF96RcYc+YhFLMD
         Ba47g5/ZI+YppGO11P2X6sRKOelUXBFnjhrg1j6K4ut3vMMMAlG9pv59SBamwsn5knay
         jIEXvP38z8Wn607hXFZexLMJfFJaK9Ohg35k+AtIyR683q2bqXPH5+snc2J76s07JbKX
         2lO9rver9PqLGxzoDvUCE8qTleg1fBCOBMuIFJUMXTAbUDoCdQEbCvwIQmF8LtuEL2mn
         J1tA2KrwzcfI+T5IaDZxz/jAG2P96ScdH8qyBkLSJkRJHI1jknk3VOMFE2KZMMrpBWfW
         v1XA==
X-Gm-Message-State: AOAM531FSr1z/VHzy91oGzIceZoaoD179U/INHz++E8CCgXvOYssePnh
        U+RreiRefQDWB4+J47YFS3E=
X-Google-Smtp-Source: ABdhPJyHFNGEZFhOZWQGSJ22fAWK9rbRlAVa4z4iG4bDHvWmi6C+yoYMmZNi5qvyAMwS3H180+PeGQ==
X-Received: by 2002:a17:906:998c:: with SMTP id af12mr25612647ejc.240.1626679374002;
        Mon, 19 Jul 2021 00:22:54 -0700 (PDT)
Received: from skbuf ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id l3sm5561208ejs.78.2021.07.19.00.22.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 00:22:53 -0700 (PDT)
Date:   Mon, 19 Jul 2021 10:22:51 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Re: [PATCH v4 net-next 11/15] net: bridge: switchdev: allow the TX
 data plane forwarding to be offloaded
Message-ID: <20210719072251.encyen5fbln6z6je@skbuf>
References: <20210718214434.3938850-1-vladimir.oltean@nxp.com>
 <20210718214434.3938850-12-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210718214434.3938850-12-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 19, 2021 at 12:44:30AM +0300, Vladimir Oltean wrote:
>  static int nbp_switchdev_add(struct net_bridge_port *p,
>  			     struct netdev_phys_item_id ppid,
> +			     bool tx_fwd_offload,
>  			     struct netlink_ext_ack *extack)
>  {
> +	int err;
> +
>  	if (p->offload_count) {
>  		/* Prevent unsupported configurations such as a bridge port
>  		 * which is a bonding interface, and the member ports are from
> @@ -189,7 +228,16 @@ static int nbp_switchdev_add(struct net_bridge_port *p,
>  	p->ppid = ppid;
>  	p->offload_count = 1;
>  
> -	return nbp_switchdev_hwdom_set(p);
> +	err = nbp_switchdev_hwdom_set(p);
> +	if (err)
> +		return err;
> +
> +	if (tx_fwd_offload) {
> +		p->flags |= BR_TX_FWD_OFFLOAD;
> +		static_branch_inc(&br_switchdev_fwd_offload_used);
> +	}
> +
> +	return 0;
>  }
>  
>  static void nbp_switchdev_del(struct net_bridge_port *p,
> @@ -210,6 +258,8 @@ static void nbp_switchdev_del(struct net_bridge_port *p,
>  
>  	if (p->hwdom)
>  		nbp_switchdev_hwdom_put(p);
> +
> +	p->flags &= ~BR_TX_FWD_OFFLOAD;
>  }

Not the end of the world, but the static_branch_dec(&br_switchdev_fwd_offload_used)
was lost here in a rebase. Not a functional issue per se, but it is on
my list of things I would like to fix when I resend.
