Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BAE826CEEF
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 00:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbgIPWjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 18:39:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726382AbgIPWh4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 18:37:56 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD9D6C061353;
        Wed, 16 Sep 2020 14:22:17 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id g4so8350516wrs.5;
        Wed, 16 Sep 2020 14:22:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rZwJCenpJW1FFkhwXKCJoTS7EbTuiQatdTV3wO3465M=;
        b=lF9NC+kfAULQDzJUeIysMGpU1qmq1uc9cI0WU7ORfR1EU2dLqnh94+0r7StcST6C9p
         br7r/ZmCqXP2ymM4AVq1cinWHtmFK5vh3JULY3m8eB6v/V2CRWr1fL5O9R96OiXUcFEY
         eyFkuJT1gJtJUl0vTpqMzdszq0AMAFJhuNduH4SgHXLhSnJTNS8nVuV9F5+MfurVxEJ/
         G2AlSOMo4/OhGgHvgVKc9ezZwZOknpRQnDxsDCcu9COQpeplvBWnhWOtTF/CS4fmzszO
         xDg4PltxpWlXG2I2IY0Vmx/1agW+6vdK6++hromHbLgQFDnTZ6QKXGtJFu1F6E/QuyL9
         wxdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rZwJCenpJW1FFkhwXKCJoTS7EbTuiQatdTV3wO3465M=;
        b=l9+jjy/NN8ekSqjxwvDSEzbNfBhkwSOAdbtXEnHBT4FVumOQk+3vmxaTHC4Wmq68X0
         ZpXvQu8AUiCg010pN7uM8I1ylRMuYFbanEsjE64Ow3vBz1Lnrel+HIhThSGWsz+85e56
         SxLkR/iypD2MAdMAAgWEDFfke6Hv+pBZrTBTNXLjI9wpLIlyG6OylBcPDGF7TqZuuZcC
         mwJcAFa5EEKDAEvyUTy5uxmMxh4yf6Neb84xuS/LwY8pmvADZhOUihj5jXiMesViQFha
         rgjzD5RRDJLXozrmWI48DeYV3i4wx9xdeeN5NKWaXrdUg5MYR/KzVjHbVgp4ce7yC3wu
         rdsg==
X-Gm-Message-State: AOAM530oIEDElH/oZy0nRBKQbPpiGJ8QPALKzj1vHGKv8DxHG3jsupLh
        vABFhVuo+/b723kPReKW/+M=
X-Google-Smtp-Source: ABdhPJxKuwijj5bY37fOmOmdBmn1qD4Bk+KgvLkkEPSn5wxYikUVEInLjb1qrj8IlMvKQsfEROjXhw==
X-Received: by 2002:adf:ef45:: with SMTP id c5mr6367417wrp.384.1600291336432;
        Wed, 16 Sep 2020 14:22:16 -0700 (PDT)
Received: from lenovo-laptop (cpc83661-brig20-2-0-cust443.3-3.cable.virginm.net. [82.28.105.188])
        by smtp.gmail.com with ESMTPSA id t15sm28380498wrp.20.2020.09.16.14.22.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2020 14:22:15 -0700 (PDT)
From:   Alex Dewar <alex.dewar90@gmail.com>
X-Google-Original-From: Alex Dewar <alex.dewar@gmx.co.uk>
Date:   Wed, 16 Sep 2020 22:22:13 +0100
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     Alex Dewar <alex.dewar90@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Landen Chao <landen.chao@mediatek.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dsa: mt7530: Add some return-value checks
Message-ID: <20200916212213.v2xqqj3ep6v452eh@lenovo-laptop>
References: <20200916195017.34057-1-alex.dewar90@gmail.com>
 <e46ec744-ec6a-e53a-03e8-1c75c910682f@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e46ec744-ec6a-e53a-03e8-1c75c910682f@embeddedor.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[snip] 
> >  
> >  	/* Enable Mediatek header mode on the cpu port */
> >  	mt7530_write(priv, MT7530_PVC_P(port),
> > @@ -2275,7 +2279,7 @@ mt7531_cpu_port_config(struct dsa_switch *ds, int port)
> >  {
> >  	struct mt7530_priv *priv = ds->priv;
> >  	phy_interface_t interface;
> > -	int speed;
> > +	int ret, speed;
> 
> Don't do this. Instead, declare each variable on its own line. In this case,
> speed before ret.

Good point. I'll do this in v2 :-)
> 
> Thanks
> --
> Gustavo
