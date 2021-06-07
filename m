Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 607A139E978
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 00:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbhFGWZ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 18:25:59 -0400
Received: from mail-ed1-f46.google.com ([209.85.208.46]:35677 "EHLO
        mail-ed1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbhFGWZ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 18:25:59 -0400
Received: by mail-ed1-f46.google.com with SMTP id ba2so20502591edb.2;
        Mon, 07 Jun 2021 15:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=o6iOgETMfXUBj31Ra6erqsr88eR+5qOCPyNVN7nwtSE=;
        b=SWvBFVxzX2Q8uYwgOhKwx5TsKtWygzkNm4WdpXbvv5DG8+Dn0EJmnmg/tuZK6t3PMy
         QrmUT5oMQkqHMHjY/C8zMRsD//8UU2UTZoXLvMGtqO+1YEfw7vKXMjVtFKpfo+WvMsP9
         yae00d93mZT75xT2X7xhvbyPRVI+Ky0XjNZaezuR2eVUPxuMtB0DBHVrdVW9zdKK0rff
         xtrG7fsXXNKKNvJSAs8VfSIkO/CZcUI00pOwJXxZX603cCOr+bpnN07nYOrn3UJEpoXS
         fOiZ1Xq0uRit/OhjEJpEx7TbosKCvvD9SIfBRJzvGKdK23INaMWPyIZgDs+vuIhuGOR5
         Mxkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=o6iOgETMfXUBj31Ra6erqsr88eR+5qOCPyNVN7nwtSE=;
        b=O9y2sNsLTSwMYmhmznffFrIE1kdcahBhBU996zJ8HLZUlxpOLf+SJ0/sCzze9j/KpY
         vyWxBBo7xDj9nfnLXD+STscVm/UB7HYxwZrxHizMmMnI6TqIY4vx9GZuYyHIp/1xOh5k
         GVz2wNgI2qtQS9kIZTXCM677G8gefwCCVrgFyoodRRLLFrHYQiq40MWch1ot2lDPEo3V
         xbYnAW3C9n/3228fe6JctG6K1N74NSEmKa3Q9i0vPNd4KQwEv7TWD4n6zxvnfFlHZHiC
         /lkU9frsEv0fXslblmXUNAfOdlP+5UaerAgT9l6MErADWCquF+anQdmCq44IR/i2NVnf
         qlKg==
X-Gm-Message-State: AOAM533haZtLX8YuSw4meEmJ0mozekmtsNvAULIK9wbtbByt+mEbsoZ6
        GmsCn1ZKA10mTH2wHOMJ5Eg=
X-Google-Smtp-Source: ABdhPJxIjuBFkp9aXaEJY9LBM3jTLNALlLVxl3E25VJQJS5kic5QvziRDTEo5/6xUrex9G3auxA9Mw==
X-Received: by 2002:a05:6402:51d0:: with SMTP id r16mr13436671edd.138.1623104572259;
        Mon, 07 Jun 2021 15:22:52 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id p10sm6918994ejc.14.2021.06.07.15.22.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jun 2021 15:22:51 -0700 (PDT)
Date:   Tue, 8 Jun 2021 01:22:50 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Matthew Hagan <mnhagan88@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 1/2] net: dsa: b53: Do not force tagging on CPU
 port VLANs
Message-ID: <20210607222250.zxqnwvosqeavhqhi@skbuf>
References: <20210607220843.3799414-1-f.fainelli@gmail.com>
 <20210607220843.3799414-2-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210607220843.3799414-2-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 07, 2021 at 03:08:42PM -0700, Florian Fainelli wrote:
> Commit ca8931948344 ("net: dsa: b53: Keep CPU port as tagged in all
> VLANs") forced the CPU port to be always tagged in any VLAN membership.
> This was necessary back then because we did not support Broadcom tags
> for all configurations so the only way to differentiate tagged and
> untagged traffic while DSA_TAG_PROTO_NONE was used was to force the CPU
> port into being always tagged.
> 
> This is not necessary anymore since 8fab459e69ab ("net: dsa: b53: Enable
> Broadcom tags for 531x5/539x families") and we can simply program what
> we are being told now, regardless of the port being CPU or user-facing.
> 
> Reported-by: Matthew Hagan <mnhagan88@gmail.com>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  drivers/net/dsa/b53/b53_common.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
> index 3ca6b394dd5f..56e3b42ec28c 100644
> --- a/drivers/net/dsa/b53/b53_common.c
> +++ b/drivers/net/dsa/b53/b53_common.c
> @@ -1477,7 +1477,7 @@ int b53_vlan_add(struct dsa_switch *ds, int port,
>  		untagged = true;
>  
>  	vl->members |= BIT(port);
> -	if (untagged && !dsa_is_cpu_port(ds, port))
> +	if (untagged)
>  		vl->untag |= BIT(port);
>  	else
>  		vl->untag &= ~BIT(port);
> @@ -1514,7 +1514,7 @@ int b53_vlan_del(struct dsa_switch *ds, int port,
>  	if (pvid == vlan->vid)
>  		pvid = b53_default_pvid(dev);
>  
> -	if (untagged && !dsa_is_cpu_port(ds, port))
> +	if (untagged)
>  		vl->untag &= ~(BIT(port));
>  
>  	b53_set_vlan_entry(dev, vlan->vid, vl);
> -- 
> 2.25.1
> 

Don't you want to keep this functionality for BCM5325 / BCM5365 and
such, which still use DSA_TAG_PROTO_NONE?
