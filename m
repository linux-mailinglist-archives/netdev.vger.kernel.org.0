Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD27A2DC44A
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 17:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgLPQ3l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 11:29:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726805AbgLPQ3l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 11:29:41 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8787C061794
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 08:29:00 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id j16so3045169edr.0
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 08:29:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rKTuqNmZEcQol91pY/a8SjTHUErxmG30wNXRY2P/X9U=;
        b=q9krytKgQvE/HAX1NSHi1eEXLQaRAKRsbDpUT1zS4Ak6QajPelmZuskubYAbMxvZOi
         tnev7G0w2SOLG9tbiGf1lqAf7Q1eSpV83iCyDWEhOcQjWSNFPw988wNQicw9ctclWu5t
         7ytlDiDmOwU42qexPQR4bQL4szTGs0Qpa3VPrf2S50EJKWbTM3/Kd0/Yk6R+gXAcXMiX
         wMGEdMlxmcEUSSaaYQ9kT+9ksSolUNNSbKXM0GQwnXvD2+hbmWeOM90G3RLruzbS/yoM
         noDhu22MQgfP+vHkmEMH++yED4jjX3id5GkQQGhcHz2g5wwmQY7Nvj3X45952y0ORfKW
         UE3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rKTuqNmZEcQol91pY/a8SjTHUErxmG30wNXRY2P/X9U=;
        b=MtQ8oLKB44SmShHigVIKeyHWW/CdOwmTx0ubhVtwtfPoipaUjFc6wSVwIn5ueqDX0a
         o+fk+tv9vLnd2OFVl/BG8e8ugSho6xkRdPUCjZ+3WtkFj1CrP5A2rkZwLriKA0Ca63FM
         k5AYAqFU8eeaMLtD5277PUlxAv9dap1/ExO3FCFFVrWSkQbwbvfdTuoejUXY58aZjk5k
         FiMnanfjYMyITRt2QNETBbmcqBYc+CAGp+Ss9507eHB2T5fu3UatTNe2axL3Gi63FjcQ
         xjhIis7b4ImK2BjHATDUprBl+WPhu7IVV75kczT8MqRO+5abprtsnsc8dZGXQ+hO9c5S
         uwiA==
X-Gm-Message-State: AOAM533KhQEKaK5NxigPv99gyhCIdAq9M+1jnUh1TpyH0YGBLKGDF1In
        COxYq6PKt9+YYjUm19lFHA5lOCHKd2Y=
X-Google-Smtp-Source: ABdhPJww9ADcjQVY9ABdFmGSNE33OS6pREzC+sTXx5AhLLPz488NfFMX9AXupi96S12yE7fvAq/hig==
X-Received: by 2002:aa7:c3d3:: with SMTP id l19mr35351844edr.366.1608136139480;
        Wed, 16 Dec 2020 08:28:59 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id k3sm1788776ejd.36.2020.12.16.08.28.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Dec 2020 08:28:58 -0800 (PST)
Date:   Wed, 16 Dec 2020 18:28:57 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v4 net-next 1/5] net: bonding: Notify ports about their
 initial state
Message-ID: <20201216162857.uqvtfe2womnxreyo@skbuf>
References: <20201216160056.27526-1-tobias@waldekranz.com>
 <20201216160056.27526-2-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201216160056.27526-2-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 16, 2020 at 05:00:52PM +0100, Tobias Waldekranz wrote:
> When creating a static bond (e.g. balance-xor), all ports will always
> be enabled. This is set, and the corresponding notification is sent
> out, before the port is linked to the bond upper.
> 
> In the offloaded case, this ordering is hard to deal with.
> 
> The lower will first see a notification that it can not associate with
> any bond. Then the bond is joined. After that point no more
> notifications are sent, so all ports remain disabled.
> 
> This change simply sends an extra notification once the port has been
> linked to the upper to synchronize the initial state.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>

Tested-by: Vladimir Oltean <olteanv@gmail.com>

> ---
>  drivers/net/bonding/bond_main.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> index 5fe5232cc3f3..ad5192ee1845 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -1922,6 +1922,8 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
>  		goto err_unregister;
>  	}
>  
> +	bond_lower_state_changed(new_slave);
> +
>  	res = bond_sysfs_slave_add(new_slave);
>  	if (res) {
>  		slave_dbg(bond_dev, slave_dev, "Error %d calling bond_sysfs_slave_add\n", res);
> -- 
> 2.17.1
> 
