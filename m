Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D33435D634
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 06:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344483AbhDMD7z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 23:59:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbhDMD7x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 23:59:53 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4FFFC061574;
        Mon, 12 Apr 2021 20:59:32 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id ot17-20020a17090b3b51b0290109c9ac3c34so9998367pjb.4;
        Mon, 12 Apr 2021 20:59:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=MMUmn5mABVsgrfWlibL4nmwnAT3Kpef8pz6y5TktZjk=;
        b=Ys9jkndzAW5uBB7GfhA/tsOayE/UE2BtjjEmlkCxMxIaFyKY9MFSTgxpxWfdxDk5h6
         4GWMRa1At+rbawl7r+Z1ypxff05XvHVP6FJk0rUwuZvpu7oHxR+zRcgQTNvQ5c0zIaDl
         8zGjUvzQzTebIuUXkQQJtgi2n3hrI2nMtG7ol1GcxV4Yi5T7hMrrLyU/uTne4QGBGugO
         m3Y2Ytu/ygqr53ax/sTz7JOBmqyJGoeegcv3N/XzUsjXfVnMz7S+aEA98LgmOUO/mHrP
         LcQuUXLYbgSbQ+lkHAY2DGQLleHBdh18anpWTWfuYc2fxLb5YxO77/JoFn32/4foikjV
         4yJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=MMUmn5mABVsgrfWlibL4nmwnAT3Kpef8pz6y5TktZjk=;
        b=McinsoHSu61UhEBu78fkTB09YALH63tw+V1Ok+aN180zT2deuBaeS8nAg4gzWBkcuu
         CuTRrf5lFPaHtYVpMgjErVqVNcjS7DKJdmBv/tD5scEExArxks8iu+UbwXSwWpnpl0Au
         FEF2hRTois5U6cv3UvEDq5/WRmC9S21AWVDUIt+fupwdScP4/uHWnXkDxeotLHYgWO1Y
         LEp2ydWq8+K4ItaL8rMoZSzhzyDft6Ot2Mx0ktUcW/dExOjYhKwBIFrytRbTH9/DNFMB
         knKSB16fwh2fwRmcDPeWY9AYAoDR0G8jO3+CxOa5AMBNXqqabyswVibUlJXYenrSIc6u
         Xj4w==
X-Gm-Message-State: AOAM5336Fbr/7unQrOgJFMewC+d3UomMTdcYGyfq5VH5T6yrRu1SAkEq
        nYGiFlOSAHZy/vVhyJ4YzH0=
X-Google-Smtp-Source: ABdhPJyMRWGljYt/4aZ19IQ3gt9VmDkMZt1nOhw1lL4WoWV67sNLFAuRj0SR3TADUx1CDcAdnktDiQ==
X-Received: by 2002:a17:90a:7bce:: with SMTP id d14mr2751340pjl.139.1618286371967;
        Mon, 12 Apr 2021 20:59:31 -0700 (PDT)
Received: from localhost.localdomain ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id 67sm11110165pfy.140.2021.04.12.20.59.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 20:59:31 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
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
        Frank Wunderlich <frank-w@public-files.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>
Subject: Re: [RFC v4 net-next 1/4] net: phy: add MediaTek PHY driver
Date:   Tue, 13 Apr 2021 11:59:20 +0800
Message-Id: <20210413035920.1422364-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210412150836.929610-1-dqfext@gmail.com>
References: <20210412034237.2473017-1-dqfext@gmail.com> <20210412034237.2473017-2-dqfext@gmail.com> <20210412070449.Horde.wg9CWXW8V9o0P-heKYtQpVh@www.vdorst.com> <20210412150836.929610-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 12, 2021 at 11:08:36PM +0800, DENG Qingfang wrote:
> On Mon, Apr 12, 2021 at 07:04:49AM +0000, René van Dorst wrote:
> > Hi Qingfang,
> > > +static void mtk_phy_config_init(struct phy_device *phydev)
> > > +{
> > > +	/* Disable EEE */
> > > +	phy_write_mmd(phydev, MDIO_MMD_AN, MDIO_AN_EEE_ADV, 0);
> > 
> > For my EEE patch I changed this line to:
> > 
> > genphy_config_eee_advert(phydev);
> > 
> > So PHY EEE part is setup properly at boot, instead enable it manual via
> > ethtool.
> > This function also takes the DTS parameters "eee-broken-xxxx" in to account
> > while
> > setting-up the PHY.
> 
> Thanks, I'm now testing with it.

Hi Rene,

Within 12 hours, I got some spontaneous link down/ups when EEE is enabled:

[16334.236233] mt7530 mdio-bus:1f wan: Link is Down
[16334.241340] br-lan: port 3(wan) entered disabled state
[16337.355988] mt7530 mdio-bus:1f wan: Link is Up - 1Gbps/Full - flow control rx/tx
[16337.363468] br-lan: port 3(wan) entered blocking state
[16337.368638] br-lan: port 3(wan) entered forwarding state

The cable is a 30m Cat.6 and never has such issue when EEE is disabled.
Perhaps WAKEUP_TIME_1000/100 or some PHY registers need to be fine-tuned,
but for now I think it should be disabled by default.

> 
> > 
> > > +
> > > +	/* Enable HW auto downshift */
> > > +	phy_modify_paged(phydev, MTK_PHY_PAGE_EXTENDED, 0x14, 0, BIT(4));
