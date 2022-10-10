Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4FD15FA199
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 18:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbiJJQLq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 12:11:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbiJJQLo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 12:11:44 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60045.outbound.protection.outlook.com [40.107.6.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C51A927CE3
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 09:11:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bbhUhpxbfLxKd9aRnCm+Wgt8pz8aia8E+1FBwIdK4YI6BUrwtYsJ+gtFisKMqyv0zkK9fHpsU7bfX7qFvn5fhyQGVJ0oF18N1didmtYklrBMgfI1cjHYn5hYpyqq4ePtJ0C9JD6nE2ckH29gQthqy/KX41lsg+7YqPElK2FyQFI/Lk5TZ6zLfLmz/kKQEpkiDuVUBcyZrJ2kAyLF+Hvr9Idr3MUUHg7IzwMhniJRKpmHQtIN/1xHGw1+grfPkXYY7bsCSavoNKP5U3pcoEqqsw2l7SszmrVrkn4Mr3SuWgmwQ98c/gQmElOk5HN/Nnj8a/6XAiEJTXi++Ar//Bma2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wSNb56DmA38Ea6Y9/BBWMA1Ggnuj0ou+BoaDy+QH2og=;
 b=OexfZuJ906zWiPT8Hiw9XML5Q/1fqMQG9Uh043gyvKtFBgwFriXEcvMl1jGlNeGLG4jrOBveOFPjGw46+Bes0c6vs5n1hNhoiBEwRWXcNrL27YErpcBvQkDt/hlJqtYIYH166XnH8l42sqhPZnQhRaBpYgYO2pM2XkJEGi23CZWbKYHEhErpu3nr4jKCS6DXbdE6/bMRULTf/N9OW2p+Wr84zfxYXU1aijkcw9BXrydhZjnFnxm47nMD/uu+xz9QIDmdrPP7DURfaGKCvcuWlFp0vV9SpUTy8bceU40s9xZoqp5NJuXgMO6OfKsEtoiy1Xzl1sy9l87p41/xDU0Tjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wSNb56DmA38Ea6Y9/BBWMA1Ggnuj0ou+BoaDy+QH2og=;
 b=ZXf3BazYzp3ijfzOLLybpwD+915e3UMe/NBStaLdRO2LMFxg+KSsVFufsDUwnAzHkOLv4PJMs+dqGTu9IpUWk/ffY/4vrj9riva298F2GA9ELjiHZo6Yerfc8KZ/tZox/4xaNzaZlpPbJQ7ncrGmSzZo+g3JUAlAIOQUOL7c+RE=
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by AS4PR04MB9508.eurprd04.prod.outlook.com (2603:10a6:20b:4cb::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.38; Mon, 10 Oct
 2022 16:11:36 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::4d83:404:c74a:7563]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::4d83:404:c74a:7563%5]) with mapi id 15.20.5709.015; Mon, 10 Oct 2022
 16:11:36 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     Russell King <linux@armlinux.org.uk>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "imx@lists.linux.dev" <imx@lists.linux.dev>
Subject: RE: [EXT] Re: [PATCH v3 1/1] net: phylink: add phylink_set_mac_pm()
 helper
Thread-Topic: [EXT] Re: [PATCH v3 1/1] net: phylink: add phylink_set_mac_pm()
 helper
Thread-Index: AQHY2mN8NiUdjFp6H0SMw6HHEkZ4lq4EGh0AgAOcBDCAAA1tAIAACz0A
Date:   Mon, 10 Oct 2022 16:11:36 +0000
Message-ID: <PAXPR04MB9185313B299F8788906E0EE789209@PAXPR04MB9185.eurprd04.prod.outlook.com>
References: <20221007154246.838404-1-shenwei.wang@nxp.com>
 <Y0EmbNyFhT/HsBMh@shell.armlinux.org.uk>
 <PAXPR04MB9185302A6164DC02812B471589209@PAXPR04MB9185.eurprd04.prod.outlook.com>
 <Y0Q4zqhEjzIU2dIX@shell.armlinux.org.uk>
In-Reply-To: <Y0Q4zqhEjzIU2dIX@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR04MB9185:EE_|AS4PR04MB9508:EE_
x-ms-office365-filtering-correlation-id: b5e56c44-be3b-4942-93f6-08daaada1b39
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a+H2a5NSQjTG20f0WXg5F8pISj5VQJ2UCwvr1OZf6VImrNMHhq41oOSn5rao+4N8TZJetTioYHrR6bjRQn37TuVbdp93MakbmSbs93sCkC2QDbRguROwOYAFw/9y+UGU328BBeSXFncn22ukIVNn1bJ9s91gFpX5uqMHSFSGO//sSlrPeyPDuC/7QplCsa8g4jeNKbr61aOS1Uo4Pf0lrQ4Tve7APpMScAONK1WXS8D9iVKiHPWN7YSy7uqNFyTgT8avy9q+GBVeTe+S82NI7HPZhWrGUnqDqIHV66ayxccq/C2COwOuTrZCVPB+5rmGDifqF4GHV+jFFrkVv0lak8DcJPCTqgNrAuMYNae2mDyxri+xwuDlYNe+tp3ge4IX4qTFqaLUxn9IeVxhaigHS5ynqF3DNrhiaDf+gWllqzGD3jY1D6+KCi34oOQWpLUcSLUNA/6Gwqbx413GRNIoNs0eY75vWCeHSwuiZrE4/0xchfa5yO+Xzklgv8zAyeL5UT4iCGAD4AONkPGQmyhJ/x91osRr5fR//nlK860Jm2q5OZV8jPXBXmJP66BVpjGZbu+ax+SLcPhgPV6vWT2t7DakCg/HW1I7wrT6gKII/bnYGPT22Z40fCvOPUJX9A0Xe1N4nXbEF3HBsnTPICf2uDWgWsjohRNRuJDhVCUN4QQ0Dvbs49K7x8AJ6kSlAWU16yDKbueSZ4XzPMx7jxYMjZveoV2VuMC/UvRwJZpLg6HR7ye8e9dFbR5o3ySmKsms/Al1bnJzHzC8K55vyIrFev4Sc+VC+VBIio8sm9T3g3o=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(376002)(136003)(366004)(346002)(451199015)(122000001)(76116006)(9686003)(26005)(38100700002)(478600001)(66946007)(66476007)(8676002)(33656002)(66446008)(66556008)(4326008)(186003)(966005)(64756008)(55236004)(71200400001)(53546011)(7696005)(54906003)(86362001)(316002)(6916009)(6506007)(83380400001)(45080400002)(8936002)(44832011)(52536014)(5660300002)(55016003)(41300700001)(38070700005)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jhfrxw6QVNRjJsGoZ5jI6oBuw8nPrRPa61/Qi1kx4L+3S1hKfMCJSAy1pT/b?=
 =?us-ascii?Q?ZdFu62VOo2fwMFYSEwnRbTZx6YooRU2eugkg8hhQGAgKquOcQo0IB1ho00Bq?=
 =?us-ascii?Q?AFT5cFbOSFuQcIUkyqxgSxw6sRW6nTmuLCpc2FIaz9o2QuWTFnckQlzKQKms?=
 =?us-ascii?Q?JMTykp+cqJTyoJWG2OI2hNFEERvMEzmbReFK4KR0q1a5HzjZTIX/gsw5dQjA?=
 =?us-ascii?Q?NrP6YGiuQ4byqNvpigqzlZyJG0fi4E3+qBgAt+n4T5Jr2FhkScIXBL6fVAw5?=
 =?us-ascii?Q?pp3Wl6F9BBYUiZnCT7zzhsyDTP3O0Zr7GWCgINlxb4IMOoqDDzrkfCYDl4CT?=
 =?us-ascii?Q?8eXZCVufIi4qCAKuPuI049XwaRVbLnTu9W6gaSkIgD4ThWsWlWyoCahOCmUn?=
 =?us-ascii?Q?kLkz07xjvM1EgPrxryDKrOlTYNyN2fmU1wPaWf+XzLr8jmCVJVF5RPISmS6w?=
 =?us-ascii?Q?zyttZjdDSR4ZoNEufJp5hzzLQmcHHUOU1PbDW1fCGycer4dfSoPY6ceAERxH?=
 =?us-ascii?Q?Ddve7v4UWGvfmRe2vLg7d4OIaWW8ntptqLK6yL/vdKCDTnkkf76Dy1VasybI?=
 =?us-ascii?Q?TmDZ+ftoLFVhI04fKrr8SchAnXo1U8uYHJdLp8tYxPD68aSfrgcmHTSthe70?=
 =?us-ascii?Q?5qylD0VAgY6BmwiY5NseauRvGCnCwCxKZ3o6z+seAXdMMkDJQUFEyYgvlr8F?=
 =?us-ascii?Q?ZGA4atK0UR1vE60Ih7fh5ryW4nczYtwh+eDY9KbQH2Qv/rZJsDem+QFS/R46?=
 =?us-ascii?Q?tR2H7K6MVIkmODJgbSVfqhuLuqRzvjxx5yTsSKJ0ume7/+gLR0z00GE+SW5Q?=
 =?us-ascii?Q?ZHbAqjh9Jbgyk+EBKHyuRLA9oXtYd4FU2OHUaWvaEN5JPbmIhf2vAjlaU0Uc?=
 =?us-ascii?Q?kTeRuilciptPmXJOLXIM70pAK7TJAt61Nrz66uyqAvH9w386buvdWKzIv+Cv?=
 =?us-ascii?Q?rB5HF4bH24gmPq/B5GDvxrXpknojKxZaRKNaTsbiUsjF+vTLmdnolBK4R3/Q?=
 =?us-ascii?Q?n1dCgB4tibR14HB1BR06swDJxmDkySKeitwJwI8X1Nxxj2451zDYf3VLG70X?=
 =?us-ascii?Q?Al2ZSA6e6zH5DmelvYojZcdmtck9ZIrOVguZwfUtTyhXk9pnto1qwglSKjDb?=
 =?us-ascii?Q?XpyJV2uCW8t8VlApRXXu9i4YzQq2c60b2ouv5JS8lrtHcPhSI6yQ9+6Nyru+?=
 =?us-ascii?Q?K8ZKFY13QgVdW+fAPeG1FwQBKbdsYZG8YlhaJDb0yDYG1REQ/ofHlIw8d3Qy?=
 =?us-ascii?Q?5UEWRcu7kuRho7GzDymBsis9dt+YV5phNPNZmFIK/fnHP2u/8A8PyPeWjjbI?=
 =?us-ascii?Q?aEnAQ7NugUaPZStbeqITYYQTwWFCs3C9T7AveCOJkwOsmoH+VNkEBPMNLmsi?=
 =?us-ascii?Q?uqbY9djuDdhD380ObGkohs4sAGqOvGikBD8s8qFXHCg6IW8XncfknIXlorna?=
 =?us-ascii?Q?g9Yx/XPyX+wSeQQK3rzQ8WorUTYPvpKR1LgrZvqj1ebRzW7wqCIy/cUi7mWZ?=
 =?us-ascii?Q?sLfcQ9mPLvoHLfbf1WJwKBg+xMF++cts+oIT34hv10IYX4Wp/5xQYZJs1YKm?=
 =?us-ascii?Q?VfNA3AImY9tEU+SYctNRiDlGqVLjIhGr4tZOmCgx?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5e56c44-be3b-4942-93f6-08daaada1b39
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Oct 2022 16:11:36.2540
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GMfkrGR/ujj8bDHCqR2awJtirZV8MidJgTtksnxvF/ehsVpt/F2Rnko8ADytLQrmKEcQG2hSZVCiXf/Dhoz6/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR04MB9508
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Russell King <linux@armlinux.org.uk>
> Sent: Monday, October 10, 2022 10:23 AM
> To: Shenwei Wang <shenwei.wang@nxp.com>
> Cc: Andrew Lunn <andrew@lunn.ch>; Heiner Kallweit <hkallweit1@gmail.com>;
> David S. Miller <davem@davemloft.net>; Eric Dumazet
> > > with an accessible PHY, what should happen if the system goes into a =
low
> power state?
> > >
> >
> > In theory, the SFP should be covered by this patch too. Since the
> > resume flow is Controlled by the value of phydev->mac_managed_pm, it
> > should work in the same way after the phydev is linked to the SFP phy i=
nstance.
>=20
> It won't, because the MAC doesn't know when it needs to call your new fun=
ction.
>=20
> Given this, I think a different approach is needed here:
>=20
> 1) require a MAC to call this function after phylink_create() and record
>    the configuration in struct phylink, or put a configuration boolean in
>    the phylink_config structure (probably better).
>=20

I prefer to use the function call because it is simple to implement and is =
easy to use.

> 2) whenever any PHY is attached, check the status of this feature, and
>    pass the configuration on to phylib.
>=20
> That means MACs don't have to keep calling the function - they declare ea=
rly on
> whether they will be using MAC managed PM or not and then they're done wi=
th
> that. Keeps it simple.
>=20

Agree. Let me implement this idea in the next version.

Thanks,
Shenwei

> Russell.
>=20
> --
> RMK's Patch system:
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fwww.a=
r
> mlinux.org.uk%2Fdeveloper%2Fpatches%2F&amp;data=3D05%7C01%7Cshenwei.
> wang%40nxp.com%7C2d5aa021cfa74162a1e008daaad350cc%7C686ea1d3bc2b
> 4c6fa92cd99c5c301635%7C0%7C0%7C638010121814590052%7CUnknown%7C
> TWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJX
> VCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=3DvEHqzO3CSdtvSuaW80%2FaBK
> sDp895q7leiz1w%2BZNmGCU%3D&amp;reserved=3D0
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
