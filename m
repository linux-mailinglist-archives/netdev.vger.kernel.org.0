Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0589284BBB
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 14:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbgJFMhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 08:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726460AbgJFMhK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 08:37:10 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4040C061755;
        Tue,  6 Oct 2020 05:37:09 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id md26so17369063ejb.10;
        Tue, 06 Oct 2020 05:37:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zr+fQKfJH41b+OmkEnAMDd8D3Gr3FwM6XTSvtfE1Tr4=;
        b=FmpVcAMq12e5hWuc/bTAY8dcJpXMlSOCB6kb+9/U9bPX89D8fDkuAEBD7Y6mxTza78
         CjQEdzoxUGU+9UNJYMbG4waBGFxaLDHf6Xd/s2A/Ftc1eK98fdWh4KOdkat9gicdldtU
         OJ4/WpF0VNQa+Nm+3AGo4pV1WuhT2Xk5iZHAQmKtSPxoeFP2RVhMc6Vcx2+PuhVkEQRu
         EUh/SgiH47nhBRQE4piQPVzFNVUzfxVi7EPYp9Pg+IBCJsLipPb8H8k6WH33WHR6C40B
         4GSmFaAwpP+AtViSD/dGGr1wb+1P3MORwaX/cL17Tpg2bmVTg8xRQFbDc3+iD9tk02Fp
         Tl3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zr+fQKfJH41b+OmkEnAMDd8D3Gr3FwM6XTSvtfE1Tr4=;
        b=Fpzv8XGHY2x3RsQ13dsEr+Wv0cai4f9W+lkuRXVm2zgbiu4GY3UusGARJDXdahjWVK
         4IpRswJqMsBg590LPVAAf3nzNk8QpddQznEE5F9idviPLEZpuplCY7QqxPF2tgj3J3mX
         05hxlsgLeSTOBT5Udr0rXPTf/3KGU1ycs51lnW5fxrWPUMVHLFfguw8yVJmoLXo7HuwM
         /eyveSzzlXR3b+9LRMKrh/Ogl6Tlj77YdoS6VwhpKr9yas9Ga1jF3T5g3Ge4Y0stzXyb
         fa8wMZnIOTknTR3Qx5iwadRWmGh5ONcI/sM0YQ2R16NBOZcsWKN9ki8cq37iisQ+5YQw
         bWpA==
X-Gm-Message-State: AOAM533gYXLhYL2tKamoc/+P75YOqJsFIBT1OJVrRsY6bxOy9uTeA5Bj
        2cBZJ+d2CZ2VqseVlMZA9Xc=
X-Google-Smtp-Source: ABdhPJyQO+OnJR1BVsiUMfSD32qkPU11dLARGI4NNYHyS+2Y5bPlr1k9gkKxOWneMHdrc818DeepFQ==
X-Received: by 2002:a17:906:685a:: with SMTP id a26mr5183847ejs.458.1601987827595;
        Tue, 06 Oct 2020 05:37:07 -0700 (PDT)
Received: from skbuf ([188.26.229.171])
        by smtp.gmail.com with ESMTPSA id l26sm2007784ejc.96.2020.10.06.05.37.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2020 05:37:07 -0700 (PDT)
Date:   Tue, 6 Oct 2020 15:37:05 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH net-next v6 2/7] net: dsa: Add DSA driver for Hirschmann
 Hellcreek switches
Message-ID: <20201006123705.bnrborrpms6vaegz@skbuf>
References: <20201004112911.25085-1-kurt@linutronix.de>
 <20201004112911.25085-3-kurt@linutronix.de>
 <20201004125601.aceiu4hdhrawea5z@skbuf>
 <87lfgj997g.fsf@kurt>
 <20201006092017.znfuwvye25vsu4z7@skbuf>
 <878scj8xxr.fsf@kurt>
 <20201006113237.73rzvw34anilqh4d@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201006113237.73rzvw34anilqh4d@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 06, 2020 at 02:32:37PM +0300, Vladimir Oltean wrote:
> - The .port_vlan_add will always install the VLAN to the hardware
>   database, no queuing if there's no reason for it (and I can't see any.
>   Your hardware seems to be sane enough to not drop a VLAN-tagged frame,
>   and forward it correctly on egress, as long as you call
>   hellcreek_setup_ingressflt with enable=false, am I right? or does the
>   VLAN still need to be installed into the egress port?).

I don't know if this goes without saying or not, but of course, if you
can't enforce correct behavior with a vlan_filtering=0 bridge (i.e.
"ingressflt" will only help the VLAN-tagged frames to be accepted on
ingress, but they will be nonetheless dropped on egress due to no valid
destinations), then you should reject that setting in the 2 places where
vlan_filtering can be enabled:

(a) in .port_prechangeupper, you should make sure that if the upper is a
    bridge, then br_vlan_enabled() must be true.
(b) in .port_vlan_filtering, you should reject enabled=false from the
    switchdev_trans_ph_prepare(trans) state.

Again, this isn't about implementing every possible combination, just
about making sure that the user isn't led into believing that a certain
setting works when in reality it doesn't.

> @@ -2006,10 +2006,22 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
>  	switch (event) {
>  	case NETDEV_PRECHANGEUPPER: {
>  		struct netdev_notifier_changeupper_info *info = ptr;
> +		struct dsa_switch *ds;
> +		struct dsa_port *dp;
> +		int err;
>  
>  		if (!dsa_slave_dev_check(dev))
>  			return dsa_prevent_bridging_8021q_upper(dev, ptr);
>  
> +		dp = dsa_slave_to_port(dev);
> +		ds = dp->ds;
> +
> +		if (ds->ops->port_prechangeupper) {
> +			err = ds->ops->port_prechangeupper(ds, dp->index, ptr);
> +			if (err)
> +				return err;

Correction: this should return notifier_from_errno(err).

> +		}
> +
>  		if (is_vlan_dev(info->upper_dev))
>  			return dsa_slave_check_8021q_upper(dev, ptr);
>  		break;
> -- 
> 2.25.1
