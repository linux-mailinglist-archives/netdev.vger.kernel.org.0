Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84A615FA7EC
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 01:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbiJJXEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 19:04:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbiJJXEu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 19:04:50 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80071.outbound.protection.outlook.com [40.107.8.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 077B515816
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 16:04:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HDHF4jhaT5koAJGiArW/UZuW5WFbPffazznh3xiUDcJFuthgmOPdBdDEaUuEDHmv7HJC85UDGc8QHtu3bhlAFQ3Mv+TUZNfq3v4Ul6bAloIvjTAv8U8c/+TUa/BMxjOt3srYU7ONbebPYxCiWjJod/Yc5m5K3vb2GbJziLjGmHLJjsbWHATVaPmhLQ/kTNey9ak9NhnzF2j+dHsJlkuhFQ8WO7u1o3dOZHEVjGd51vp6v32kvXdNzfCquDqSyljrO+D9koFUzJZ9r/mpOzJ9TRksmBYYpVHgMcHqtIEMDz00vJfo7sGXRMKzvZ84ZLhRpvhZ6G47XeNFz6thzei9CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H/p0d/My2zLA8kVXfJectCwMBO1YP8ZuiPHYSP9SWNU=;
 b=J86Ithsc8SbWB/z1jh8Sde35ZTzxi2NyX/FsWo/CEj29N4j5dKWkpLA7kmysbX9ZR2ls1pSuuArO45NZF2OIa4JUgPKsAwPE5WldfRmkeQpEolOYTBP46gut85icC4yJFcZkNUsW6K2srVYVtFGdIH+35sdfvdZdYX+Pw1EztkPc5iP05k5xbgt7EXSOoas0X1vd7XeTsK9cbGRv46YXFnLF+M0pqub29IhS7nmIhP1xaALFmJGeTPHkge95yYqFrWh8SGFJ6fSGQwDvKh8WGsfyZr4Up6yc++y7phYvJCsH7r9329EMuvHtl8LARTz0EZ0kvPXrFxs6bdt/34UT2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H/p0d/My2zLA8kVXfJectCwMBO1YP8ZuiPHYSP9SWNU=;
 b=YehoM1npZqGYTmEViEayPkWc0fh96hK6OmvtpVfDFulmfKY20ft0XNGplNs8Gu1Kj29pQGz1yNf6K9sIgZofllpqHk/gHZLHGiVIeDWLTYyp0qTo4EkRXw/SZ+DvVhgNZaatz+8n68mnRCrfJWRSutmzHlMpo7JQ2ES+rgDs+Xc=
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by AM9PR04MB8779.eurprd04.prod.outlook.com (2603:10a6:20b:40a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Mon, 10 Oct
 2022 23:04:46 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::4d83:404:c74a:7563]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::4d83:404:c74a:7563%5]) with mapi id 15.20.5709.015; Mon, 10 Oct 2022
 23:04:46 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     Russell King <linux@armlinux.org.uk>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "imx@lists.linux.dev" <imx@lists.linux.dev>
Subject: RE: [EXT] Re: [PATCH 1/2] net: phylink: add mac_managed_pm in
 phylink_config structure
Thread-Topic: [EXT] Re: [PATCH 1/2] net: phylink: add mac_managed_pm in
 phylink_config structure
Thread-Index: AQHY3OecKKZikHVPb0es51htngWAcK4IJiUAgAAZSvA=
Date:   Mon, 10 Oct 2022 23:04:46 +0000
Message-ID: <PAXPR04MB9185959AB51611FFAAEC9EA289209@PAXPR04MB9185.eurprd04.prod.outlook.com>
References: <20221010203301.132622-1-shenwei.wang@nxp.com>
 <20221010203301.132622-2-shenwei.wang@nxp.com>
 <Y0SPupsMC3roy4J6@shell.armlinux.org.uk>
In-Reply-To: <Y0SPupsMC3roy4J6@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR04MB9185:EE_|AM9PR04MB8779:EE_
x-ms-office365-filtering-correlation-id: d9dbe32c-3e97-437f-e515-08daab13d350
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mf7FZ568cz7gJZt1BGXYThnj5OMKCwLHWjN2fvIBvy+I2fLZvleE0E5i6r3kC12I2sgekVRAIUUy4EqSLfnpfAjFBSpK24tv0UXYdXh8A7zVBprH3vdIxdoO8KR8HRK3s1kdW7a3PPgoMElyvWHpChxooB/F8ND6DzymoE/LdpJzhQTUNxLopdog+rjxTa3B/SNx91x4XByWCqsL1DecOiCU/NyClWYWse+4+3s79UbvJ0nH0Mr/REn86wSL3ErSh12l5Foh0qiY/9443G0q4euxDSajMLvWdo7vjZ5FwRLaJVzKJe6qysQqVcN67b7h+3544uIH2iQobwpI5BAv/TTCCrdQyIjSikBM6YwxvT8/AE23wfy18XMGrpjxdTCtt3+loB9kzwPAvH/cipfpgCI9iqIoNGUZjjnmVObbnXJuJ2GkKyEFLOIvlXHzMLMaHH+XKoEs3vtYDr2CErqTwDUwTC2j+Xdxn/A6zH0c1R4k0wZZ3tiNpeXzb1VoCNIkgClNtmL9okZJ9obs6RIMuEoqNbyDytUUn5gCebe9vACsCo3L91kGulFtsT/EchyFk8v/eiG4mY7emkwbQ4eRGDWXDEdoN+BlBtNP3/i2dSnhSr091Al10GYGgcObVMbXJyJeig40RFP6qUIXemVwH3tNsP5RVOt0jLkJJqf/2Vu+/Hcvf1dIcwKX2kyyRpw00sfCu/4lMKZm7PGO/qgVnUGEVyRYDXcXCPpZSdD3HSyYOp4HWnvEycfMZnn4V00D0RxY4gdHAIyyV4vyUblDVPOwbR8OlaDQ+ePyA+V9+7E=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(396003)(346002)(366004)(136003)(451199015)(7416002)(8936002)(66556008)(66446008)(5660300002)(966005)(33656002)(8676002)(64756008)(4326008)(71200400001)(38070700005)(66476007)(186003)(41300700001)(66946007)(83380400001)(76116006)(52536014)(53546011)(6506007)(7696005)(38100700002)(86362001)(478600001)(44832011)(9686003)(122000001)(26005)(6916009)(316002)(54906003)(2906002)(55016003)(45080400002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Teiy0jHzyhCwCuTP848I3BWVQZsN62R8Phagz35b00H3cJ47TAfMUSNVcTwZ?=
 =?us-ascii?Q?1piFMxIsEVavFlDt6YY6uRfc6ykXkSrLXb2Dd6hxoS8gdVs0r1XyWTIsT0iL?=
 =?us-ascii?Q?uadp0sd/W8JTYDMVGNOw5+qEE51Eh3OLbw+YXK6xgWH4Oa32EC7qLoOaLcbb?=
 =?us-ascii?Q?w2o1rzhLejhiFcXVpfVVLT76npVw0nLDXRGVNdTJ/LJvEDomeDou/8Jk+qTJ?=
 =?us-ascii?Q?ogGsy++glvYLay/xKoIKe+CczI5aSP5HhczL5iuM20NNi4cPvf0krK8luC1/?=
 =?us-ascii?Q?+Qi6OP4T/KgmqWosVpxGPYrso+ICkr8Xjb3fJqCzxS9kYAT3eXFQPr5xPwuk?=
 =?us-ascii?Q?eCnkUnjjG37OeV6nv/cJtkafuH6FKFtO3tXA+tiqeZ/eu/qm7tiepGbYUQTw?=
 =?us-ascii?Q?YNX7HRWOo4fRIbYnG5oFWM2ILPR/f01Yx7yePCqvKtd9QemHVHtafyzP/1jE?=
 =?us-ascii?Q?Amqi5XIOeAvdgxAYSXto6r9LNYZTp1PxKhPbZfYfsC/OkPsbtYrnOrpc8fEp?=
 =?us-ascii?Q?8UdbCLdjH0QVoMjI+JBqzwVu/SygqQrzDgowLl64jvWd4Fuk0+81gbge2+zM?=
 =?us-ascii?Q?ogYddtSr+v7Z5MvooB/GlXXFZzXa+wkvYh/g9g+tSHUUR9zpVahlMiqZaoG6?=
 =?us-ascii?Q?0YQTw7Nv09yC2DNBXLRQRLhBSX/nXb3nvKrMW1DIL/Cf9kWpOLQMChQhAKS+?=
 =?us-ascii?Q?JJGfamGdupaSiNz4TgoJUCE15OXLXZv/R5K4Hab4BtO5PK/wvyQmZAmzywcK?=
 =?us-ascii?Q?jDy/ajLbYMsbl6Px1/LbAO8EA5mgN7JkbZpb4v7pjGaYqSPYI3gkgEPvr+L2?=
 =?us-ascii?Q?XzH8/ZoCEQeragTZCmqOgGJHhw3rwm6+E5X9CtE+n6abQ4xjlgUrYOh65PX6?=
 =?us-ascii?Q?i03ooXO5wSCrLYQ5e00qOf5bn3S61MQftL41FuUBj+zvZb+/5gLMekPA6aWf?=
 =?us-ascii?Q?A0MtPFgQmeieZxy8+RtGvir0O8nXAhAVZLLGNYLFq8oMyIzh9QTJcMyLr619?=
 =?us-ascii?Q?szIKynJr73cgkIWrfJ08MV+Heb9NthpReIuDRS58PDCj1/BaMJdtjGxrndH0?=
 =?us-ascii?Q?IXQnUF2xWPT/meT0wkyZXEHipcLVEw9lheaUXE/v+05mxsiiPsNLgZd1uycB?=
 =?us-ascii?Q?lQSd4OhgwZpRU53Dkq5seBqWrjqYXsP5utjyyayJFYAWy3Nb3grrCZBtevbV?=
 =?us-ascii?Q?dU4rwKqhmEWibO/twsNx1a0LZwBEKTzfZGdrjWeAk54ayr2Zqc+LY3GcIhFP?=
 =?us-ascii?Q?uLL5fLHOCg5/3ABZd+f0TtiTOWHIjkuFuB7QGkTM3W31uzqlXaQox11VG9UL?=
 =?us-ascii?Q?L3CQpqfNVpGuBrf3abKIKBJ4KBW0oLn6ONEq2p7VjNAbbVHnesHemS+tLVhi?=
 =?us-ascii?Q?jXBF4eQxmhxwZcHohkUR/ZUsKWDJ+xrZL/L8y8Eni6pmMv7GXzQLwh/w5Q7T?=
 =?us-ascii?Q?HKRYf3MtfPzF0URfbLrJU0ZgCTpDHndg0p3w4aa9Q4YtISSfFUzJnL+KdfT4?=
 =?us-ascii?Q?/3RjMpSkK/0NyXywNDY//iOPhZ9eR21htNP+uYHZyu9yBrznDxXpnOVsbGM9?=
 =?us-ascii?Q?f6a1iLFAo83bGcup0noNg6x3iOD7hx7sNmPSkO8k?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9dbe32c-3e97-437f-e515-08daab13d350
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Oct 2022 23:04:46.4212
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 19ko0p+LdUmj071altX4WytCOPb9eeyn8wT6Aaf+eTOe1zi65oCjdgB4o2M69FJURt2xO/6gObQ7p7U86TkJhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8779
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
> Sent: Monday, October 10, 2022 4:34 PM
> To: Shenwei Wang <shenwei.wang@nxp.com>
> Cc: David S. Miller <davem@davemloft.net>; Eric Dumazet
> <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni
> <pabeni@redhat.com>; Maxime Coquelin <mcoquelin.stm32@gmail.com>;
> Andrew Lunn <andrew@lunn.ch>; Heiner Kallweit <hkallweit1@gmail.com>;
> Giuseppe Cavallaro <peppe.cavallaro@st.com>; Alexandre Torgue
> <alexandre.torgue@foss.st.com>; Jose Abreu <joabreu@synopsys.com>;
> netdev@vger.kernel.org; linux-stm32@st-md-mailman.stormreply.com; linux-
> arm-kernel@lists.infradead.org; imx@lists.linux.dev
> Subject: [EXT] Re: [PATCH 1/2] net: phylink: add mac_managed_pm in
> phylink_config structure
>=20
> Caution: EXT Email
>=20
> On Mon, Oct 10, 2022 at 03:33:00PM -0500, Shenwei Wang wrote:
> > diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> > index e9d62f9598f9..6d64d4b6d606 100644
> > --- a/drivers/net/phy/phylink.c
> > +++ b/drivers/net/phy/phylink.c
> > @@ -74,6 +74,7 @@ struct phylink {
> >
> >       bool mac_link_dropped;
> >       bool using_mac_select_pcs;
> > +     bool mac_managed_pm;
>=20
> I don't think you need this?

It was cleaned up in patch v4.

Thanks,
Shenwei

>=20
> --
> RMK's Patch system:
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fwww.a=
r
> mlinux.org.uk%2Fdeveloper%2Fpatches%2F&amp;data=3D05%7C01%7Cshenwei.
> wang%40nxp.com%7Cb7b04ce3002c4d29581c08daab07233d%7C686ea1d3bc2
> b4c6fa92cd99c5c301635%7C0%7C0%7C638010344382281159%7CUnknown%7
> CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJ
> XVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=3D8siCkBn5XpHUEmv3Vx4vzgC
> QDHDg94rZ%2Flv13pZhc1c%3D&amp;reserved=3D0
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
