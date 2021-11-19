Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3221456803
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 03:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234091AbhKSCXN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 21:23:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234204AbhKSCXM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 21:23:12 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E28FC061574;
        Thu, 18 Nov 2021 18:20:11 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id b15so35976593edd.7;
        Thu, 18 Nov 2021 18:20:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=R8lP8cU//l5r5UCqSj6a7FgqfcQOFaGetV7XjquxapE=;
        b=U6v8tGIg9yobufyaHjicBGSExZX1rhmzWRUrmjf8TWPIv8Wd2hBZ5lyKfw2JHP4PRv
         tJdJc9RiyDLnvzGa4v3R8Al8OkrumiluTIvblD9PxmDEHvJAnmJplyyYlH69ZJA7Mxyq
         tAyJHADELoyP6aWT9LagIt+IcB4HOp9OVFddceE7oUZ6pVoD9AAnr9CAzR6bg7lBNl5+
         5BNHZTFgj2RPr0MQqr9fZje/YqYH8xf2gY+Ysgd6q8vzLQ92CXQ9zSKKsRiQ3N9z9PaT
         vklmU+M4VOosGoWgK+BSoTlmc4IBmkt2Co3L8C+j750fXarrBQSrUeT15emYLG165cx5
         /vew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=R8lP8cU//l5r5UCqSj6a7FgqfcQOFaGetV7XjquxapE=;
        b=k93g/THsHxxJ/WYahdbDz8lg2+3zCRNmlxmchLtmPculYOnn4F+w+fpZk3NwO1gwhF
         tYCRLiNxBWLV/xX7WVmY2+8fKJdlHDOadMVvc6yD2uUr9dTI8WihIAGaAez9S8KTnSg5
         Zzgt7ovWOe3gSuB2qUZhk2ykzv5D59aG88L94RsSb2MsvTb46Exh8e2QTY6Sa6ZQBMMp
         2lvl2ZJBDAiO+7lhOrmJXRiurwuR5dj3woCngU+SKaKpWVUpCjIErH7UAklPYyJ0ZCUL
         Awm1lH/htH8SwIv6sIisj4clzvKFWwOMGke1BtVsjui+MhbeN1icg3RFckBHrKEA2RkR
         BB0A==
X-Gm-Message-State: AOAM532WyMdakRcwrMMR/i2ox3OQy0oCBIZoN3uOrtfQl4BJDJvRPjLN
        I4eXVjFBZC35agUgMFMKWDI=
X-Google-Smtp-Source: ABdhPJyw8DBJkcem5Gaac25pjNGshupXmL4s3G2Fv3jGVMW5wK9womP3aqA+STYbPWOoVO1xSvXN5w==
X-Received: by 2002:a17:906:d20c:: with SMTP id w12mr2719705ejz.521.1637288409869;
        Thu, 18 Nov 2021 18:20:09 -0800 (PST)
Received: from skbuf ([188.25.163.189])
        by smtp.gmail.com with ESMTPSA id h7sm889665ede.40.2021.11.18.18.20.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 18:20:09 -0800 (PST)
Date:   Fri, 19 Nov 2021 04:20:08 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [net-next PATCH 16/19] net: dsa: qca8k: enable
 mtu_enforcement_ingress
Message-ID: <20211119022008.d6nnf4aqnvkaykk3@skbuf>
References: <20211117210451.26415-1-ansuelsmth@gmail.com>
 <20211117210451.26415-17-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211117210451.26415-17-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 17, 2021 at 10:04:48PM +0100, Ansuel Smith wrote:
> qca8k have a global MTU. Inform DSA of this as the change MTU port
> function checks the max MTU across all port and sets the max value
> anyway as this switch doesn't support per port MTU.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>  drivers/net/dsa/qca8k.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index c3234988aabf..cae58753bb1f 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -1315,6 +1315,9 @@ qca8k_setup(struct dsa_switch *ds)
>  	/* Set max number of LAGs supported */
>  	ds->num_lag_ids = QCA8K_NUM_LAGS;
>  
> +	/* Global MTU. Inform dsa that per port MTU is not supported */
> +	ds->mtu_enforcement_ingress = true;
> +
>  	return 0;
>  }
>  
> -- 
> 2.32.0
> 

This doesn't do what you think it does. If you want the dev->mtu of all
interfaces to get updated at once, you need to do that yourself. Setting
ds->mtu_enforcement_ingress will only update the MTU for ports belonging
to the same bridge, and for a different reason. Or I'm missing the
reason why you're making this change now.
