Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E22FA455C04
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 13:58:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233614AbhKRNBQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 08:01:16 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:57418 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232163AbhKRNAn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 08:00:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1637240263; x=1668776263;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=j/0ca7hXl32K5luAtpihGEK4BUx6G5/UQ4YGF/yuGKM=;
  b=EDnqY57QKwSO0c5ur4w0blGtXqak3DImpCeJfN1CC/tCkDvlrxfBXDT+
   Frt/PqNm/VsbyQGFO2GwEjGp0QL/se0u1WviTh7Czt6OoAmQ9K7pryVtE
   kN9TAka19gorF3kBIncHGj6iY1aAhW6dICAo/uTLmFu6+t47Nnk+pxPzi
   hSnKV2usNst+6KvFYfzxXXTmFWR/rJLfUtqJzgqEBNLj7kRgjhxIElfjW
   qkyOr/RJoL79MkKJ5JYAtlrmgvxDbLlpHa6OtFRvzP5Fwuany6agQ+TKi
   kEZl1gS44vtPRdhy2ra0K1kV8mr8/a5QA6/8I2izeHKPMks1D7BK/EfaN
   Q==;
IronPort-SDR: Tte6N3iF1NeBc+TCVuZMv25iVdoZ6KV/9vbmNe3qFYcrghSUQAvVxj9IQ4J1X+8Qz1JmkZvIvc
 FZMeNv8xWqxC49Yqy4r7tNOnMk06/eyo49cjxglOqXKPuH1WtA5xyOk1p9mDiMZi1RLIVjKuoj
 V+lf5ivrfHEtyAFj6k/LOri1HecMKrvhuW6z8T0Uf/jNx3FCX0YpCUsCVw8ksxuBZOJX96niJq
 2iqiPIDEfpJXdXlup4tW4eNndOrtgtR7jBRHyKnp40ykfQH9myxiVV0dLVYk3+M16QGzZazWE8
 1IM8bOrB/kpGmj98oDC9Oq+/
X-IronPort-AV: E=Sophos;i="5.87,244,1631602800"; 
   d="scan'208";a="136998624"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Nov 2021 05:57:40 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 18 Nov 2021 05:57:40 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Thu, 18 Nov 2021 05:57:40 -0700
Date:   Thu, 18 Nov 2021 13:59:28 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <p.zabel@pengutronix.de>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 3/5] net: lan966x: add port module support
Message-ID: <20211118125928.tav7k5xlbnhrgp3o@soft-dev3-1.localhost>
References: <20211117091858.1971414-1-horatiu.vultur@microchip.com>
 <20211117091858.1971414-4-horatiu.vultur@microchip.com>
 <YZTRUfvPPu5qf7mE@shell.armlinux.org.uk>
 <20211118095703.owsb2nen5hb5vjz2@soft-dev3-1.localhost>
 <YZYj9fwCeWdIZJOt@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <YZYj9fwCeWdIZJOt@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 11/18/2021 09:59, Russell King (Oracle) wrote:
> 
> On Thu, Nov 18, 2021 at 10:57:03AM +0100, Horatiu Vultur wrote:
> > > > +static void decode_sgmii_word(u16 lp_abil, struct lan966x_port_status *status)
> > > > +{
> > > > +     status->an_complete = true;
> > > > +     if (!(lp_abil & LPA_SGMII_LINK)) {
> > > > +             status->link = false;
> > > > +             return;
> > > > +     }
> > > > +
> > > > +     switch (lp_abil & LPA_SGMII_SPD_MASK) {
> > > > +     case LPA_SGMII_10:
> > > > +             status->speed = SPEED_10;
> > > > +             break;
> > > > +     case LPA_SGMII_100:
> > > > +             status->speed = SPEED_100;
> > > > +             break;
> > > > +     case LPA_SGMII_1000:
> > > > +             status->speed = SPEED_1000;
> > > > +             break;
> > > > +     default:
> > > > +             status->link = false;
> > > > +             return;
> > > > +     }
> > > > +     if (lp_abil & LPA_SGMII_FULL_DUPLEX)
> > > > +             status->duplex = DUPLEX_FULL;
> > > > +     else
> > > > +             status->duplex = DUPLEX_HALF;
> > > > +}
> > >
> > > The above mentioned function will also handle SGMII as well.
> >
> > I noticed that you have phylink_decode_sgmii_work(), so I will try to
> > export it also.
> 
> Another approach would be to split phylink_mii_c22_pcs_decode_state()
> so that the appropriate decode function is selected depending on the
> interface state, which may be a better idea.

I have tried to look for phylink_mii_c22_pcs_decode_state() and I
have found it only here [1], and seems that it depends on [2]. But not
much activity happened to these series since October.
Do you think they will still get in?

[1] https://patchwork.kernel.org/project/netdevbpf/patch/20211022160959.3350916-1-sean.anderson@seco.com/
[2] https://lore.kernel.org/netdev/20211022155914.3347672-1-sean.anderson@seco.com/

> 
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

-- 
/Horatiu
