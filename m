Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A960557E3B7
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 17:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbiGVP0w convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 22 Jul 2022 11:26:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiGVP0v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 11:26:51 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9BC859EC5C;
        Fri, 22 Jul 2022 08:26:48 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 26MFQW5J0014317, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 26MFQW5J0014317
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Fri, 22 Jul 2022 23:26:32 +0800
Received: from RTEXMBS01.realtek.com.tw (172.21.6.94) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 22 Jul 2022 23:26:37 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS01.realtek.com.tw (172.21.6.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 22 Jul 2022 23:26:36 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::415c:a915:a507:e600]) by
 RTEXMBS04.realtek.com.tw ([fe80::415c:a915:a507:e600%5]) with mapi id
 15.01.2308.027; Fri, 22 Jul 2022 23:26:36 +0800
From:   Hau <hau@realtek.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next] r8169: add support for rtl8168h(revid 0x2a) + rtl8211fs fiber application
Thread-Topic: [PATCH net-next] r8169: add support for rtl8168h(revid 0x2a) +
 rtl8211fs fiber application
Thread-Index: AQHYnRCVRrASn8LKuEagRDBDIpqm962Iwo2AgABzCoCAAU5IgA==
Date:   Fri, 22 Jul 2022 15:26:36 +0000
Message-ID: <146c30d91ffd4514a23f52ac1bac24dd@realtek.com>
References: <20220721144550.4405-1-hau@realtek.com>
 <356f4285-1e83-ab14-c890-4131acd8e61d@gmail.com> <YtoZCaLTMFw8cTem@lunn.ch>
In-Reply-To: <YtoZCaLTMFw8cTem@lunn.ch>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.129]
x-kse-serverinfo: RTEXMBS01.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2022/7/22_=3F=3F_12:44:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> 
> > > +#define RT_SFP_ST (1)
> > > +#define RT_SFP_OP_W (1)
> > > +#define RT_SFP_OP_R (2)
> > > +#define RT_SFP_TA_W (2)
> > > +#define RT_SFP_TA_R (0)
> > > +
> > > +static void rtl_sfp_if_write(struct rtl8169_private *tp,
> > > +				  struct rtl_sfp_if_mask *sfp_if_mask, u8 reg,
> u16 val) {
> > > +	struct rtl_sfp_if_info sfp_if_info = {0};
> > > +	const u16 mdc_reg = PIN_I_SEL_1;
> > > +	const u16 mdio_reg = PIN_I_SEL_2;
> > > +
> > > +	rtl_select_sfp_if(tp, sfp_if_mask, &sfp_if_info);
> > > +
> > > +	/* change to output mode */
> > > +	r8168_mac_ocp_write(tp, PINOE, sfp_if_info.mdio_oe_o);
> > > +
> > > +	/* init sfp interface */
> > > +	r8168_mac_ocp_write(tp, mdc_reg, sfp_if_info.mdc_pd);
> > > +	r8168_mac_ocp_write(tp, mdio_reg, sfp_if_info.mdio_pu);
> > > +
> > > +	/* preamble 32bit of 1 */
> > > +	rtl_sfp_shift_bit_in(tp, &sfp_if_info, 0xffffffff, 32);
> > > +
> > > +	/* opcode write */
> > > +	rtl_sfp_shift_bit_in(tp, &sfp_if_info, RT_SFP_ST, 2);
> > > +	rtl_sfp_shift_bit_in(tp, &sfp_if_info, RT_SFP_OP_W, 2);
> > > +
> > > +	/* phy address */
> > > +	rtl_sfp_shift_bit_in(tp, &sfp_if_info, sfp_if_mask->phy_addr, 5);
> > > +
> > > +	/* phy reg */
> > > +	rtl_sfp_shift_bit_in(tp, &sfp_if_info, reg, 5);
> > > +
> > > +	/* turn-around(TA) */
> > > +	rtl_sfp_shift_bit_in(tp, &sfp_if_info, RT_SFP_TA_W, 2);
> > > +
> > > +	/* write phy data */
> > > +	rtl_sfp_shift_bit_in(tp, &sfp_if_info, val, 16);
> 
> This looks like a bit-banging MDIO bus? If so, please use the kernel code,
> drivers/net/mdio/mdio-bitbang.c. You just need to provide it with functions
> to write and read a bit, and it will do the rest, including C45 which you don't
> seem to support here.

I will try to use these functions.

> > > +static enum rtl_sfp_if_type rtl8168h_check_sfp(struct
> > > +rtl8169_private *tp) {
> > > +	int i;
> > > +	int const checkcnt = 4;
> > > +
> > > +	rtl_sfp_eeprom_write(tp, 0x1f, 0x0000);
> > > +	for (i = 0; i < checkcnt; i++) {
> > > +		if (rtl_sfp_eeprom_read(tp, 0x02) != RTL8211FS_PHY_ID_1 ||
> > > +			rtl_sfp_eeprom_read(tp, 0x03) !=
> RTL8211FS_PHY_ID_2)
> > > +			break;
> > > +	}
> 
> Reading registers 2 and 3 for a PhY idea? Who not just use phylib, and a PHY
> driver?
> 
>   Andrew

Reading register 2 and 3, it is for checking hardware use which pin(eeprom or gpo) to connect to RTL8211FS.

> ------Please consider the environment before printing this e-mail.
