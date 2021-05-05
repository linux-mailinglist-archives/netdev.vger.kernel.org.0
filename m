Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85F0A37334D
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 02:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231608AbhEEAsV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 20:48:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbhEEAsU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 20:48:20 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8E79C061574;
        Tue,  4 May 2021 17:47:24 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id h10so12514881edt.13;
        Tue, 04 May 2021 17:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rfdeL1GSbteQ+uzgalMQNOsi81nM8kSFmgVflJOvjH8=;
        b=J/rWfjl5UiNiwUu040tY5f8mWi8vTsVCZhnZGCMoOyRRcju+C1IsTKRqdrOsAcT6Bf
         r8YlzzzLwzFI74CQDP0VKv8P1vVuKNdRktSWYRZ3xPVwh1bee1kEDv3Vs2etW5tbqq2D
         9DPPy0hGTvb3AhBDLiSoVrHFjbi9VOdVj36q41c+aank8LzmonrhdMtVbfg9ru8WOBI/
         +rdi5UpneXY5pAk0SYUTZixds/BIsBCUA4D/AYwVcwk79xn8U2A37qr3lOPbIs7VJbrk
         YZBoKn+so0XM+gVQabmi9WEdrM2Poxgsrsof2xX7ywYfBbzpCl7VflFmbcoP+D5QEZvr
         h1Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rfdeL1GSbteQ+uzgalMQNOsi81nM8kSFmgVflJOvjH8=;
        b=V7Xku3p5NB6+1NR9sVlRTWPnpgjv7H0Tyj57UBMjlpKE+2Ln8qAhBQzkOOQszLWXqx
         9e1hppyRxDeU/sE9uBx/UgL8jaTKEEQevs4NQ1oopuOWrvdixe2MiOrgQ3cy8Tvy3a44
         Gof+nCd2xAZ3xIlv9M0XHldfdembK15XGSaU3nY/dNGnqAzAnde5QSyIU4sk2pMS53no
         +LySfN6UQyHRxwATTfuS1MstvtBDaGuBQXi9WQvUZIRjjHwU1trBFS52WpIaBLMCn7UH
         yve0EG4mNi6uBN/Pqz7pNoViCNr/C0eLp67D2aEDPte7HXn9PETJLHN24ekoMUO9n9m6
         L55Q==
X-Gm-Message-State: AOAM531j4/6keCrE5T+4HTOoh05+udyR5G/rYuNr7yjsIu0YOCvKwlR+
        oTsxP2pF+IvInfQYzSmHic4=
X-Google-Smtp-Source: ABdhPJy6Re+maeC+RxUSFkAxvZmHXHp1seA+BngZq7W524mzXDEUFba+E/TG7zzmm778eMQWq3XqvQ==
X-Received: by 2002:a50:82e2:: with SMTP id 89mr28729061edg.0.1620175643565;
        Tue, 04 May 2021 17:47:23 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.gmail.com with ESMTPSA id j16sm15447656edr.9.2021.05.04.17.47.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 17:47:23 -0700 (PDT)
Date:   Wed, 5 May 2021 02:47:25 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next v3 06/20] net: dsa: qca8k: handle error with
 qca8k_write operation
Message-ID: <YJHrHV+kSmNxf1GD@Ansuel-xps.localdomain>
References: <20210504222915.17206-1-ansuelsmth@gmail.com>
 <20210504222915.17206-6-ansuelsmth@gmail.com>
 <YJHptHS8eN2gGaRd@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJHptHS8eN2gGaRd@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 05, 2021 at 02:41:24AM +0200, Andrew Lunn wrote:
> > -static void
> > +static int
> >  qca8k_write(struct qca8k_priv *priv, u32 reg, u32 val)
> >  {
> > +	struct mii_bus *bus = priv->bus;
> >  	u16 r1, r2, page;
> >  	int ret;
> >  
> >  	qca8k_split_addr(reg, &r1, &r2, &page);
> >  
> > -	mutex_lock_nested(&priv->bus->mdio_lock, MDIO_MUTEX_NESTED);
> > +	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
> >  
> >  	ret = qca8k_set_page(priv->bus, page);
> >  	if (ret < 0)
> > @@ -183,6 +184,7 @@ qca8k_write(struct qca8k_priv *priv, u32 reg, u32 val)
> >  
> >  exit:
> >  	mutex_unlock(&priv->bus->mdio_lock);
> > +	return ret;
> >  }
> 
> Same comment as read. Maybe put this and the other similar change into one patch.
> 
> > @@ -636,7 +660,9 @@ qca8k_mdio_read(struct qca8k_priv *priv, int port, u32 regnum)
> >  	      QCA8K_MDIO_MASTER_READ | QCA8K_MDIO_MASTER_PHY_ADDR(phy) |
> >  	      QCA8K_MDIO_MASTER_REG_ADDR(regnum);
> >  
> > -	qca8k_write(priv, QCA8K_MDIO_MASTER_CTRL, val);
> > +	ret = qca8k_write(priv, QCA8K_MDIO_MASTER_CTRL, val);
> > +	if (ret)
> > +		return ret;
> >  
> >  	if (qca8k_busy_wait(priv, QCA8K_MDIO_MASTER_CTRL,
> >  			    QCA8K_MDIO_MASTER_BUSY))
> > @@ -767,12 +793,18 @@ qca8k_setup(struct dsa_switch *ds)
> >  		      QCA8K_GLOBAL_FW_CTRL0_CPU_PORT_EN);
> >  
> >  	/* Enable MIB counters */
> > -	qca8k_mib_init(priv);
> > +	ret = qca8k_mib_init(priv);
> > +	if (ret)
> > +		pr_warn("mib init failed");
> 
> Please use dev_warn().
> 
> >  
> >  	/* Enable QCA header mode on the cpu port */
> > -	qca8k_write(priv, QCA8K_REG_PORT_HDR_CTRL(QCA8K_CPU_PORT),
> > -		    QCA8K_PORT_HDR_CTRL_ALL << QCA8K_PORT_HDR_CTRL_TX_S |
> > -		    QCA8K_PORT_HDR_CTRL_ALL << QCA8K_PORT_HDR_CTRL_RX_S);
> > +	ret = qca8k_write(priv, QCA8K_REG_PORT_HDR_CTRL(QCA8K_CPU_PORT),
> > +			  QCA8K_PORT_HDR_CTRL_ALL << QCA8K_PORT_HDR_CTRL_TX_S |
> > +			  QCA8K_PORT_HDR_CTRL_ALL << QCA8K_PORT_HDR_CTRL_RX_S);
> > +	if (ret) {
> > +		pr_err("failed enabling QCA header mode");
> 
> dev_err()
> 
> In general, always use dev_err(), dev_warn(), dev_info() etc, so we
> know which device returned an error.
>

I notice that in the driver we use pr function so I assumed this was the
correct way to report errors with a dsa driver. Will change that.

>      Andrew
