Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFAFD59EA42
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 19:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbiHWRu4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 23 Aug 2022 13:50:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232981AbiHWRuD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 13:50:03 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7FE2993
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 08:48:34 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 27NFm0R81003011, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36504.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 27NFm0R81003011
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Tue, 23 Aug 2022 23:48:00 +0800
Received: from RTEXMBS02.realtek.com.tw (172.21.6.95) by
 RTEXH36504.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Tue, 23 Aug 2022 23:48:14 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS02.realtek.com.tw (172.21.6.95) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Tue, 23 Aug 2022 23:48:14 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::d902:19b0:8613:5b97]) by
 RTEXMBS04.realtek.com.tw ([fe80::d902:19b0:8613:5b97%5]) with mapi id
 15.01.2375.007; Tue, 23 Aug 2022 23:48:14 +0800
From:   Hau <hau@realtek.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH v3 net-next] r8169: add support for rtl8168h(revid 0x2a) + rtl8211fs fiber application
Thread-Topic: [PATCH v3 net-next] r8169: add support for rtl8168h(revid 0x2a)
 + rtl8211fs fiber application
Thread-Index: AQHYtkFCqIBipNqwCkqP74BSSxF+S6260IqAgAG+nrD//4kAAIAAh3Zg
Date:   Tue, 23 Aug 2022 15:48:13 +0000
Message-ID: <f0e230cebf274ce9ae38bf74e3d5da06@realtek.com>
References: <20220822160714.2904-1-hau@realtek.com> <YwPf8yXud3mYFvnW@lunn.ch>
 <7e24c3c4c3ea42e482a70160aec6930c@realtek.com> <YwTyxpKbjxz1s8Xe@lunn.ch>
In-Reply-To: <YwTyxpKbjxz1s8Xe@lunn.ch>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.129]
x-kse-serverinfo: RTEXMBS02.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2022/8/23_=3F=3F_02:07:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36504.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: fallback
X-KSE-Antivirus-Interceptor-Info: fallback
X-KSE-AntiSpam-Interceptor-Info: fallback
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > > @@ -914,8 +952,12 @@ static void r8168g_mdio_write(struct
> > > rtl8169_private *tp, int reg, int value)
> > > >  	if (tp->ocp_base != OCP_STD_PHY_BASE)
> > > >  		reg -= 0x10;
> > > >
> > > > -	if (tp->ocp_base == OCP_STD_PHY_BASE && reg == MII_BMCR)
> > > > +	if (tp->ocp_base == OCP_STD_PHY_BASE && reg == MII_BMCR) {
> > > > +		if (tp->sfp_if_type != RTL_SFP_IF_NONE && value &
> > > BMCR_PDOWN)
> > > > +			return;
> > > > +
> > >
> > > Please could you explain this change.
> > H/W has issue. If we power down phy, then H/W will become abnormal.
> 
> Does the MAC break, or the PHY? If the PHY is the problem, the work around
> should be in the PHY driver, not the MAC driver.
>
It is a workaround. We did not get the root cause yet.

> > > > +/* MDIO bus init function */
> > > > +static int rtl_mdio_bitbang_init(struct rtl8169_private *tp) {
> > > > +	struct bb_info *bitbang;
> > > > +	struct device *d = tp_to_dev(tp);
> > > > +	struct mii_bus *new_bus;
> > > > +
> > > > +	/* create bit control struct for PHY */
> > > > +	bitbang = devm_kzalloc(d, sizeof(struct bb_info), GFP_KERNEL);
> > > > +	if (!bitbang)
> > > > +		return -ENOMEM;
> > > > +
> > > > +	/* bitbang init */
> > > > +	bitbang->tp = tp;
> > > > +	bitbang->ctrl.ops = &bb_ops;
> > > > +	bitbang->ctrl.op_c22_read = MDIO_READ;
> > > > +	bitbang->ctrl.op_c22_write = MDIO_WRITE;
> > > > +
> > > > +	/* MII controller setting */
> > > > +	new_bus = devm_mdiobus_alloc(d);
> > > > +	if (!new_bus)
> > > > +		return -ENOMEM;
> > > > +
> > > > +	new_bus->read = mdiobb_read;
> > > > +	new_bus->write = mdiobb_write;
> > > > +	new_bus->priv = &bitbang->ctrl;
> > >
> > > Please use alloc_mdio_bitbang().
> > >
> > I have tried to use alloc_mdio_bitbang(). But I will get error message "
> rmmod: ERROR: Module r8169 is in use " when I try to unload r8169.
> > After debug, I found it is cause by "__module_get(ctrl->ops->owner); " in
> alloc_mdio_bitbang().
> 
> void free_mdio_bitbang(struct mii_bus *bus) {
>         struct mdiobb_ctrl *ctrl = bus->priv;
> 
>         module_put(ctrl->ops->owner);
>         mdiobus_free(bus);
> }
> 
> Make sure your cleanup is symmetrical to your setup.
> 
I have tried to call free_mdio_bitbang() in rtl_remove_one (). But when I try to unload r8169, rtl_remove_one() did not get called.
So there is no chance to call free_mdio_bitbang().

------Please consider the environment before printing this e-mail.
