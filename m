Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D274389B75
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 04:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbhETCkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 22:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbhETCkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 22:40:20 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6194BC06175F;
        Wed, 19 May 2021 19:38:40 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id i5so10844316pgm.0;
        Wed, 19 May 2021 19:38:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=+oDpeZ4j0Q9DFmXNX82+DBFJCZJqLdYMPzNEUa68hdk=;
        b=IOa8K9tVVVxrX/LEDpljs/uhegyaU7VIZuMoaAVZsjDvNrTugxJq9nCTiuCFBEeDd5
         3Y7xjzha2OTsAjBRw5pc7a6InhT3llpfUQiJemcPlQrchkqgC9UINiAob8LgJehEDr9Q
         nmFyzp/SwcJZVNkHQkt2yziclbsRlwso1ofxmByAJcS15BRIANqqokBlgpK4lHAHoquR
         AtiCPZFyfQ7TIzLWLEp3wiv9qdNxAUr4bcnq3S1LIIf+4M5+HkcigdsLrwpCn+fo0lqf
         X5ljjTEcCm6UfcJ2a7UMhZkNb9wlVPYhsg6f46u0EJfEY2QykQptftlowkzjQFtSEfhZ
         eYeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=+oDpeZ4j0Q9DFmXNX82+DBFJCZJqLdYMPzNEUa68hdk=;
        b=IPF3tDje8shPuDQ9lgPYbwhJYw/3yjP4N4BdLBE4ki2xGFA8d795/E1J5iNjRI+MX7
         oqrbYU7aFtVYZkMqCrU1v4IaNtw3zJh4ZUpkuS1PLpntNWB4nuY2oMZyZOAJ1wSkqj6/
         7F1tOB1GA+kQ18MrPuCoubGr/brkGQIxvtvXrOYDVxfdkPnxG5cgfWyVyX9tWH/it3/w
         SqSX+vvltyZjHkL5CFrvqmEJfmOSCvD3aLs3VmcBpeNKI4NnesEgxfkSCMxwy4nKynJt
         wwAXQ9kQHqjWpWeonGaelYWTtvnK9L1T3nBZXFQbCyzYAQcMkzCHcXqUI355H/cb8KIc
         +79A==
X-Gm-Message-State: AOAM531d/Nw7/T0QDmKSf5PV+2ysDWmT7lm416L/2VlDl7zJDpEf+VPr
        uUedMB5SSwzGmyM6mus3CbI=
X-Google-Smtp-Source: ABdhPJyOZjPeKhwYF/NBTz9x78DTVIhWw9ru81FqoCQB8kQAgbM2mwi2ZnccQH72pofVtqTXdW8LxA==
X-Received: by 2002:a63:1e64:: with SMTP id p36mr2226330pgm.105.1621478319924;
        Wed, 19 May 2021 19:38:39 -0700 (PDT)
Received: from localhost.localdomain ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id v9sm3005387pjd.26.2021.05.19.19.38.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 19:38:39 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Wang <sean.wang@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-staging@lists.linux.dev, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, Weijie Gao <weijie.gao@mediatek.com>,
        Chuanhong Guo <gch981213@gmail.com>,
        =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH net-next v2 1/4] net: phy: add MediaTek Gigabit Ethernet PHY driver
Date:   Thu, 20 May 2021 10:38:28 +0800
Message-Id: <20210520023828.3261270-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <YKW0acoyM+5rVp0X@lunn.ch>
References: <20210519033202.3245667-1-dqfext@gmail.com> <20210519033202.3245667-2-dqfext@gmail.com> <YKW0acoyM+5rVp0X@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 20, 2021 at 02:59:21AM +0200, Andrew Lunn wrote:
> > +static void mtk_gephy_config_init(struct phy_device *phydev)
> > +{
> > +	/* Disable EEE */
> > +	phy_write_mmd(phydev, MDIO_MMD_AN, MDIO_AN_EEE_ADV, 0);
> 
> Is EEE broken on this PHY? Or is this just to get it into a defined
> state?

As I said in commit message, the initialization (including EEE) is
from the vendor driver.
I have also tested it with EEE enabled by default on one of my APs,
and got occasional link drops.

> 
> Otherwise
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> 
>     Andrew
