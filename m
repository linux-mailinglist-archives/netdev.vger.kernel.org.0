Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80EFC46102E
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 09:30:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232889AbhK2IdU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 03:33:20 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:41705 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241227AbhK2IbU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 03:31:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1638174483; x=1669710483;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=HlG+3llVnn83oRSxsh5iu9tkEzUVvCkWK5/oaYJw7Wk=;
  b=xRwcYSVi/AlD5K4kuaNmVkOu4c4Ge0VXq70utd29CuJi7Rkl7Us2Ogx8
   R296apCwhnNhHgoa27rT+4DgyAcx0XH5ja42o5x7wDyARZsyDDDXPfLF8
   bJlu3jdoB8W/oe4QgmFHCaw5YOA97eyIUfo1JNySfZt8jLYxVj45OQzNg
   9eLmL5jXjWy5Dgc3udcH/1/7XOFJcCnQrYxAWQQu1j7N2xZy9a2c1OGYq
   ybPPn64cBhM4GpJDqhL6gFr+azBEFla1iIVBHPAI7Up1AedMLyaRWfWW5
   V/6mPqZ0eiOoWqvTDOglq6j6u+UdXA3F91Ljw5/caDjINJXR18TOCF2bA
   w==;
IronPort-SDR: xj9ZNRJgXumkXCLBCBXSwEdWc7eKkoQlSk3FPLw26j7+23PaiwMXz4hIyteRAYZn+us1tPsTi3
 tA8JNEsA4iN71fyowmRw7HVcBltqy2LY0uNVnpsgxZM+9wfVe69xH2DF34aJI+7EHvQLI/h8/V
 yEaFUsHToOPERRmcsS1PBh+HVdAEeego2u+B4xcUNZiVVuNDrzZRWsQkrrVbxpEvmAONpw4PGN
 XcnkgnRTQtExZr8pF729W6IMEXI1x1haaM4sV3zqHJMDn/tHGDOmUNM0KxbPJACZE/hBD518BU
 Ld/V8c646J6eQ+7F3eYJid8X
X-IronPort-AV: E=Sophos;i="5.87,272,1631602800"; 
   d="scan'208";a="145403814"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Nov 2021 01:28:02 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Mon, 29 Nov 2021 01:28:02 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Mon, 29 Nov 2021 01:28:02 -0700
Date:   Mon, 29 Nov 2021 09:29:58 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
CC:     <andrew@lunn.ch>, <linux@armlinux.org.uk>, <davem@davemloft.net>,
        <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: phy: micrel: Add config_init for LAN8814
Message-ID: <20211129082958.ap6xtsb6jad3os4x@soft-dev3-1.localhost>
References: <20211126103833.3609945-1-horatiu.vultur@microchip.com>
 <402780af-9d12-45dd-e435-e7279f1b9263@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <402780af-9d12-45dd-e435-e7279f1b9263@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 11/26/2021 12:57, Heiner Kallweit wrote:

Hi Heiner,

> 
> On 26.11.2021 11:38, Horatiu Vultur wrote:
> >
> > +static int lan8814_config_init(struct phy_device *phydev)
> > +{
> > +     int val;
> > +
> > +     /* Reset the PHY */
> > +     val = lanphy_read_page_reg(phydev, 4, LAN8814_QSGMII_SOFT_RESET);
> > +     val |= LAN8814_QSGMII_SOFT_RESET_BIT;
> > +     lanphy_write_page_reg(phydev, 4, LAN8814_QSGMII_SOFT_RESET, val);
> > +
> > +     /* Disable ANEG with QSGMII PCS Host side */
> > +     val = lanphy_read_page_reg(phydev, 5, LAN8814_QSGMII_PCS1G_ANEG_CONFIG);
> > +     val &= ~LAN8814_QSGMII_PCS1G_ANEG_CONFIG_ANEG_ENA;
> > +     lanphy_write_page_reg(phydev, 5, LAN8814_QSGMII_PCS1G_ANEG_CONFIG, val);
> > +
> > +     /* MDI-X setting for swap A,B transmit */
> > +     val = lanphy_read_page_reg(phydev, 2, LAN8814_ALIGN_SWAP);
> > +     val &= ~LAN8814_ALIGN_TX_A_B_SWAP_MASK;
> > +     val |= LAN8814_ALIGN_TX_A_B_SWAP;
> > +     lanphy_write_page_reg(phydev, 2, LAN8814_ALIGN_SWAP, val);
> > +
> 
> Not directly related to just this patch:
> Did you consider implementing the read_page and write_page PHY driver
> callbacks? Then you could use phylib functions like phy_modify_paged et al
> and you wouldn't have to open-code the paged register operations.
> 
> I think write_page would just be
> phy_write(phydev, LAN_EXT_PAGE_ACCESS_CONTROL, page);
> phy_write(phydev, LAN_EXT_PAGE_ACCESS_ADDRESS_DATA, addr);
> phy_write(phydev, LAN_EXT_PAGE_ACCESS_CONTROL, (page | LAN_EXT_PAGE_ACCESS_CTRL_EP_FUNC));
> 
> and read_page
> phy_read(phydev, LAN_EXT_PAGE_ACCESS_CONTROL);

Thanks for the suggestion, but unfortunately it would not work.
The reason is that in the callback 'write_page' I don't actually get
also the address in the page that is needed to be read/write.

If this issue would be fixed, then there is another problem.
To read/write the data in the extended page is required to access the
register LAN_EXT_PAGE_ACCESS_ADDRESS_DATA. But that would not happen
when using the phy_read_paged, it would read actually the register in
page 0.

If I have missed something, please let me know.

> 
> > +     return 0;
> > +}
> > +
> >  static int lan8804_config_init(struct phy_device *phydev)
> >  {
> >       int val;
> > @@ -1793,6 +1824,7 @@ static struct phy_driver ksphy_driver[] = {
> >       .phy_id         = PHY_ID_LAN8814,
> >       .phy_id_mask    = MICREL_PHY_ID_MASK,
> >       .name           = "Microchip INDY Gigabit Quad PHY",
> > +     .config_init    = lan8814_config_init,
> >       .driver_data    = &ksz9021_type,
> >       .probe          = kszphy_probe,
> >       .soft_reset     = genphy_soft_reset,
> >
> 

-- 
/Horatiu
