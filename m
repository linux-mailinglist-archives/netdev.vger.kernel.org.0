Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7405845A236
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 13:08:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234712AbhKWMLn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 07:11:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236957AbhKWMLk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 07:11:40 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72711C061714
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 04:08:29 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id g14so91245308edb.8
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 04:08:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8NMLon2KasEKp2lUjnWpGI4F8VN4RtWFqQEMLQYjQZo=;
        b=bfuKNE9AOEAHdjdlF0qKAYow2qAgAV8ALn8OPC44PYB6ntJHj2/Loetarzsmb5IYw6
         bB8moCtSG7NlRTc4D3MDKTK4QofqPDt2rN1SL5ateKQY3+2pQGfwrrOZRIxZL4fFcvX9
         uTxMX8LxUXe1aogGAa626jsNdyNyrT7//WKgBGO45K3vmP5ncyhbm2R7U1Mvk5rOXpe8
         imG2Fp4VlZ5KBn+eMh+CAxi/2VcZKVoPT4hokI62K7K1OI1F8GrEAywgAnICUUY9cypI
         Qb4y1LwlT2BsMUxteePlISzbtSH+zunIswa9Is40kEtOr1IKR4S6exd5yU6WdpipH3zJ
         FjFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8NMLon2KasEKp2lUjnWpGI4F8VN4RtWFqQEMLQYjQZo=;
        b=QF5AwGTa243tmLlfsHSCfrjrN3P7QGQuNTd/HK1M89D8r6sJXXyrlqHDoQkHyKwFx1
         iB98Nr8pd+1hU9LAkVbxwyS2pNud56oiVYNwms3MGHELTjbCghLGqdzcXx000i6THXfU
         XNF7AQuHiOaKAiE3vCuZUYTmnHvn2c9VW37Z3TNSCHNapMNvRZKzNEh0isySZuWUMDMI
         04LyQicjKoHqRhRahf+TnAB+opX0K7BgY8gMIpEbbWyqqdskc0A6iasKh5Wxj5Uv8sZP
         NV68QhIAr5ekC8Ii62m66TvTm1SgR7RFDjPq2NRNBpQ3dv7YrZ33clzi6o+hKmBEG7jk
         Br8w==
X-Gm-Message-State: AOAM533DbDp92g1KxsZH8+5NLORmLVam8usuDTQRrMvbM2mqUcLnK6gt
        tHmuGG/Eh5YLl4PgRhnTp9c=
X-Google-Smtp-Source: ABdhPJxKXF5oNywtBw4/+rXqCu9WU20aDcML5wwXMeaN8k3e2yGHu+Zjh/6C0H4cxrr9YIKtaPwSpg==
X-Received: by 2002:a05:6402:5206:: with SMTP id s6mr8806194edd.286.1637669307935;
        Tue, 23 Nov 2021 04:08:27 -0800 (PST)
Received: from skbuf ([188.25.163.189])
        by smtp.gmail.com with ESMTPSA id gs15sm5081843ejc.42.2021.11.23.04.08.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 04:08:27 -0800 (PST)
Date:   Tue, 23 Nov 2021 14:08:25 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Chris Snook <chris.snook@gmail.com>, Felix Fietkau <nbd@nbd.name>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Crispin <john@phrozen.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, netdev@vger.kernel.org
Subject: Re: [PATCH RFC net-next 8/8] net: phylink: allow PCS to be removed
Message-ID: <20211123120825.jvuh7444wdxzugbo@skbuf>
References: <YZy59OTNCpKoPZT/@shell.armlinux.org.uk>
 <E1mpSba-00BXp6-9e@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1mpSba-00BXp6-9e@rmk-PC.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 23, 2021 at 10:00:50AM +0000, Russell King (Oracle) wrote:
> Allow phylink_set_pcs() to be called with a NULL pcs argument to remove
> the PCS from phylink. This is only supported on non-legacy drivers
> where doing so will have no effect on the mac_config() calling
> behaviour.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/phy/phylink.c | 20 +++++++++++++++-----
>  1 file changed, 15 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index a935655c39c0..9f0f0e0aad55 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -1196,15 +1196,25 @@ EXPORT_SYMBOL_GPL(phylink_create);
>   * in mac_prepare() or mac_config() methods if it is desired to dynamically
>   * change the PCS.
>   *
> - * Please note that there are behavioural changes with the mac_config()
> - * callback if a PCS is present (denoting a newer setup) so removing a PCS
> - * is not supported, and if a PCS is going to be used, it must be registered
> - * by calling phylink_set_pcs() at the latest in the first mac_config() call.
> + * Please note that for legacy phylink users, there are behavioural changes
> + * with the mac_config() callback if a PCS is present (denoting a newer setup)
> + * so removing a PCS is not supported. If a PCS is going to be used, it must
> + * be registered by calling phylink_set_pcs() at the latest in the first
> + * mac_config() call.
> + *
> + * For modern drivers, this may be called with a NULL pcs argument to
> + * disconnect the PCS from phylink.
>   */
>  void phylink_set_pcs(struct phylink *pl, struct phylink_pcs *pcs)
>  {
> +	if (pl->config->legacy_pre_march2020 && pl->pcs && !pcs) {
> +		phylink_warn(pl,
> +			     "Removing PCS is not supported in a legacy driver");
> +		return;
> +	}
> +
>  	pl->pcs = pcs;
> -	pl->pcs_ops = pcs->ops;
> +	pl->pcs_ops = pcs ? pcs->ops : NULL;
>  }
>  EXPORT_SYMBOL_GPL(phylink_set_pcs);
>  
> -- 
> 2.30.2
> 

I've read the discussion at
https://lore.kernel.org/netdev/cfcb368f-a785-9ea5-c446-1906eacd8c03@seco.com/
and I still am not sure that I understand what is the use case behind
removing a PCS?
