Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E89F319D55
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 12:25:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbhBLLYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 06:24:54 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:53895 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbhBLLYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 06:24:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1613129087; x=1644665087;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QCd/Zlir04Dl2NGKOoOA5y7PJjH8X/k3s88NDNd7sb8=;
  b=tUUimL1gLE5h/8qv/5OKnz+K56hBlj9b7mzr05rLBso9SbYoo+qL5rDS
   8TERCMfN+TVeBKBTevDlSm22fKjXkVQ/KbLB2CngEjsp19JwJ9aTdAmXI
   j31b5oGNUpRjy35fP2rEHcemgmDObygKPoMj1zWsyUtQtT2DN8rftTJib
   jPWk+Fw6BogjNdSGtaNrBBvJ4OLqK2WUhNkQbG4O/SNzix6q44f6He7HH
   otpsh54KQgPGKKlKgZPsEs5bSfoHjh98hJRQb3PQXDT3pzVAAEighOxqZ
   y21MA6BsaqLDETh1zIpJaJuzdb3DqX2jB3mmK+kdWZKOgL+Qj5ixGGcTg
   g==;
IronPort-SDR: eyQ2SKCIr8YYUew8aikIfGxQX210l37lb3LKkJxbXa23CWERa2FtCeCYZaefEQ6JUOCZOgp3G7
 y2+whvokez8wPFXO0xfrGDnNdRkS+wx+W4bF29zHHs00AnKmhR8HUQDoe4ShbATzFCRX6vlzcm
 Q2hkPi7OTrbrXOqsMCsGUHMpg7QmFWe5/t+Davna4EDgjVuMDuwIxZL/Zn/UImV4uXr5g5/RYN
 pAGnFD9RhKOpiGbl1papCrasLyda1cveTWCSEYw+MhxAoLM+puC1dRKubL7pHYSCxRI0YCuK8X
 DQw=
X-IronPort-AV: E=Sophos;i="5.81,173,1610434800"; 
   d="scan'208";a="106364260"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Feb 2021 04:23:31 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 12 Feb 2021 04:23:53 -0700
Received: from tyr.hegelund-hansen.dk (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Fri, 12 Feb 2021 04:23:30 -0700
Message-ID: <5c649c9af4754278280cf19e9ba1dbe3b7709bd4.camel@microchip.com>
Subject: Re: [PATCH v14 2/4] phy: Add media type and speed serdes
 configuration interfaces
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     David Miller <davem@davemloft.net>
CC:     <kishon@ti.com>, <vkoul@kernel.org>,
        <alexandre.belloni@bootlin.com>, <lars.povlsen@microchip.com>,
        <bjarni.jonasson@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <andrew@lunn.ch>
Date:   Fri, 12 Feb 2021 12:23:27 +0100
In-Reply-To: <20210210.153203.2010046208603151217.davem@davemloft.net>
References: <20210210085255.2006824-1-steen.hegelund@microchip.com>
         <20210210085255.2006824-3-steen.hegelund@microchip.com>
         <20210210.153203.2010046208603151217.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On Wed, 2021-02-10 at 15:32 -0800, David Miller wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you
> know the content is safe
> 
> From: Steen Hegelund <steen.hegelund@microchip.com>
> Date: Wed, 10 Feb 2021 09:52:53 +0100
> 
> > Provide new phy configuration interfaces for media type and speed
> > that
> > allows allows e.g. PHYs used for ethernet to be configured with
> > this
> > information.
> > 
> > Signed-off-by: Lars Povlsen <lars.povlsen@microchip.com>
> > Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
> > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> > Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
> > ---
> >  drivers/phy/phy-core.c  | 30 ++++++++++++++++++++++++++++++
> >  include/linux/phy/phy.h | 26 ++++++++++++++++++++++++++
> >  2 files changed, 56 insertions(+)
> > 
> > diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
> > index 71cb10826326..ccb575b13777 100644
> > --- a/drivers/phy/phy-core.c
> > +++ b/drivers/phy/phy-core.c
> > @@ -373,6 +373,36 @@ int phy_set_mode_ext(struct phy *phy, enum
> > phy_mode mode, int submode)
> >  }
> >  EXPORT_SYMBOL_GPL(phy_set_mode_ext);
> > 
> > +int phy_set_media(struct phy *phy, enum phy_media media)
> > +{
> > +     int ret;
> > +
> > +     if (!phy || !phy->ops->set_media)
> > +             return 0;
> > +
> > +     mutex_lock(&phy->mutex);
> > +     ret = phy->ops->set_media(phy, media);
> > +     mutex_unlock(&phy->mutex);
> > +
> > +     return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(phy_set_media);
> > +
> > +int phy_set_speed(struct phy *phy, int speed)
> > +{
> > +     int ret;
> > +
> > +     if (!phy || !phy->ops->set_speed)
> > +             return 0;
> > +
> > +     mutex_lock(&phy->mutex);
> > +     ret = phy->ops->set_speed(phy, speed);
> > +     mutex_unlock(&phy->mutex);
> > +
> > +     return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(phy_set_speed);
> > +
> >  int phy_reset(struct phy *phy)
> >  {
> >       int ret;
> > diff --git a/include/linux/phy/phy.h b/include/linux/phy/phy.h
> > index e435bdb0bab3..e4fd69a1faa7 100644
> > --- a/include/linux/phy/phy.h
> > +++ b/include/linux/phy/phy.h
> > @@ -44,6 +44,12 @@ enum phy_mode {
> >       PHY_MODE_DP
> >  };
> > 
> > +enum phy_media {
> > +     PHY_MEDIA_DEFAULT,
> > +     PHY_MEDIA_SR,
> > +     PHY_MEDIA_DAC,
> > +};
> > +
> >  /**
> >   * union phy_configure_opts - Opaque generic phy configuration
> >   *
> > @@ -64,6 +70,8 @@ union phy_configure_opts {
> >   * @power_on: powering on the phy
> >   * @power_off: powering off the phy
> >   * @set_mode: set the mode of the phy
> > + * @set_media: set the media type of the phy (optional)
> > + * @set_speed: set the speed of the phy (optional)
> >   * @reset: resetting the phy
> >   * @calibrate: calibrate the phy
> >   * @release: ops to be performed while the consumer relinquishes
> > the PHY
> > @@ -75,6 +83,8 @@ struct phy_ops {
> >       int     (*power_on)(struct phy *phy);
> >       int     (*power_off)(struct phy *phy);
> >       int     (*set_mode)(struct phy *phy, enum phy_mode mode, int
> > submode);
> > +     int     (*set_media)(struct phy *phy, enum phy_media media);
> > +     int     (*set_speed)(struct phy *phy, int speed);
> > 
> >       /**
> >        * @configure:
> > @@ -215,6 +225,8 @@ int phy_power_off(struct phy *phy);
> >  int phy_set_mode_ext(struct phy *phy, enum phy_mode mode, int
> > submode);
> >  #define phy_set_mode(phy, mode) \
> >       phy_set_mode_ext(phy, mode, 0)
> > +int phy_set_media(struct phy *phy, enum phy_media media);
> > +int phy_set_speed(struct phy *phy, int speed);
> >  int phy_configure(struct phy *phy, union phy_configure_opts
> > *opts);
> >  int phy_validate(struct phy *phy, enum phy_mode mode, int submode,
> >                union phy_configure_opts *opts);
> > @@ -344,6 +356,20 @@ static inline int phy_set_mode_ext(struct phy
> > *phy, enum phy_mode mode,
> >  #define phy_set_mode(phy, mode) \
> >       phy_set_mode_ext(phy, mode, 0)
> > 
> > +static inline int phy_set_media(struct phy *phy, enum phy_media
> > media)
> > +{
> > +     if (!phy)
> > +             return 0;
> > +     return -ENOSYS;
> > +}
> 
> Maybe ENODEV instead?

Sure.  I will update that.

-- 
BR
Steen

-=-=-=-=-=-=-=-=-=-=-=-=-=-=
steen.hegelund@microchip.com

