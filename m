Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB065E580F
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 03:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230353AbiIVBbu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 21:31:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbiIVBbr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 21:31:47 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2126.outbound.protection.outlook.com [40.107.113.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F08D9E8BF;
        Wed, 21 Sep 2022 18:31:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GJXm6HG/G70dQaouBVK6P8kZLI+Ykuhc7kB+bEUS6vOrw41GjgbPW+8xw3ZOTKKaiYPQBCzawEPXznrd6sbCnnkNhz7a2hLucsJf/oMb1xSASPBC+OWfBFNv2S8lvqNgQfxrxyZC7vv6Xu4VUleUIKxg/ZNPVsDUY4ZlHMr4ECWBjty7x9d8FsD5cmo2oqa6Rr/NLZ54yoO1QEn9iBFkB9prmh7zk4t+GTyDQ49N9JxeRvP4FbXZ67mInxO/a2CaYgHLwpphlVLb0wzniQEu90YcI+hZCQVsIfpT1palKSP5ghoDq4Iyvk086Q+QSMgIC1O34dkHZIbM0TKVNKhqCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4pvAt+V5eOrvoN1u93pi6NCHr3J+vuvRrXuo3kLmN2U=;
 b=hwFJnYZ34d9onZ90L83KwKfXL56Oi8bfoEGmikiRkOml6NMXrHlz+nX101FWYpDwNaYoNCwppdDW3V9qUXDD1kszlU2oMNykjaK7dTz9kC7ILc30tZWGp2gI+fqtjc+nq4GXEGA6yDPch8e7JmiKnaxNGlLUaczi6GnZUf/6osg+umsWnXEH2ATLYP90Ns9ngrE3vfTQmkDDNEmwlMrEf/Y69ZlPDLza50gHy9rQulF8fretF+JIdzS5lVHjR985JpgB/2w9eeFO40IVATKje9CjBTp33WcV6OnNbAAmlGTh95/UNFWXOzjUzwimj+MURbaJgH3Vq78CQ9xwbQAUrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4pvAt+V5eOrvoN1u93pi6NCHr3J+vuvRrXuo3kLmN2U=;
 b=LcdZBojV72cblZb4HfyfgfJbF5isX2/yvMkOFRqQRnl6cIhBsl8dm5TjN/ZnxsNRm/yURgKfyALn95K+WOnOWYr9Hnj5ksupGebysd2SyYBiaLFTh9fd2L15MKamXvSrY2bx6Ffhe6A13Cs+moKfzlT4jac2gjW7gY9PZwhRpYo=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by TY3PR01MB10516.jpnprd01.prod.outlook.com
 (2603:1096:400:314::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.18; Thu, 22 Sep
 2022 01:31:43 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::2991:1e2d:e62c:37d0]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::2991:1e2d:e62c:37d0%3]) with mapi id 15.20.5654.018; Thu, 22 Sep 2022
 01:31:43 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>
CC:     "kishon@ti.com" <kishon@ti.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>,
        "linux-phy@lists.infradead.org" <linux-phy@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH v2 0/8] treewide: Add R-Car S4-8 Ethernet Switch support
Thread-Topic: [PATCH v2 0/8] treewide: Add R-Car S4-8 Ethernet Switch support
Thread-Index: AQHYzZbyqTwrMjeNqkC6dNbQ2PLk4a3p9OQAgACfZDCAAA+uAIAAA10AgAACkpA=
Date:   Thu, 22 Sep 2022 01:31:43 +0000
Message-ID: <TYBPR01MB53411BA181FDA6FEADDFED38D84E9@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20220921084745.3355107-1-yoshihiro.shimoda.uh@renesas.com>
 <20220921074004.43a933fe@kernel.org>
 <TYBPR01MB534186B5BA8E5936C46E3B6DD84E9@TYBPR01MB5341.jpnprd01.prod.outlook.com>
 <20220921180640.696efb1a@kernel.org> <Yyu38hhzNcjFfgCN@lunn.ch>
In-Reply-To: <Yyu38hhzNcjFfgCN@lunn.ch>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|TY3PR01MB10516:EE_
x-ms-office365-filtering-correlation-id: 39103bc9-0d56-4978-7ac2-08da9c3a34df
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dr3zz6js3PkeEge8YybEVqjbmN/3Dq0Lyb5EYj8EQD7g7ck7r0CUFR7XDdgsBUGvgFdQ5fcmM7ig1JQdpJq6HzaS2hs6BNau6DdZLtADh3Bzk7BBYwCze90vSrtiaBbdoQNgE/yu1JE3G25Aj80Bmf6saJ2v3bnATKLzu8UGuk8Sea7TDFyR0aX/NR5XVc01yPhvc+V6PdatR7Lvh8Z4J1Iov+8RwTLiC2SJLe7erPANuijR6hIyRaNnCq9JTvSkXPfp+5Q1BYrYKCYw8/aVDiOBcIz5OO1SARhShPC+bBnXtb5uYEI0uMDvmc1+NpmzWQ5opOGkesEEqVTeJeq6rPemBqyHWdVgipvAcAWyWrHXT1kg7Q0bQH8TbFAVltwSi+RQ07GUgg6O+427Kh36dc0X28LooThchLmsmq2I2Qng98PZ9BLZJGCWJ13wDiC42NPFINjxT30Zj/jKH3vkxjNEDlvjKci24J5lICaB0eQ5pwFfq7/Kkag3Cyh0tT4tK52km3ogFguXjP7SPXbIikXvN9m2mKg3GY0xO4e+GbR6BtjVEFCrXSnCD0ndy9k+XAKXokmXT4Swf/7DwfvWnNUhU7gQGrW17nzOTOyeGqjmWzn1cgtHL9TcDRzNwKxfXCGItk+g4zqPZ8dNkmMbtG4pyaeeCFQPk1lVufId3D89VXrVW/Ki77pV90532kWrxEKsQ//KhQLKNmAG4wnky64rScJCf+GQtbd/zt1Fcftp+1vugnLv/zIqRlIPSF/V7JrmEVA5OrXMuxsi6OaPgA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(39860400002)(376002)(136003)(346002)(451199015)(76116006)(83380400001)(86362001)(33656002)(6506007)(38100700002)(7696005)(122000001)(2906002)(38070700005)(4326008)(8676002)(64756008)(66446008)(66476007)(52536014)(41300700001)(478600001)(55016003)(186003)(66946007)(7416002)(66556008)(5660300002)(8936002)(9686003)(316002)(71200400001)(110136005)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HW8IVg9IbJWEaTvRwSius85JXu8cUFSaFzowFddvlptPy2gxtjcob2xMqs9q?=
 =?us-ascii?Q?mhHfC4PfFZZE+Z9XJwArBHzWKCJkFWyrLLzgv/GXmxCljVxtfGa9TWZMIvCz?=
 =?us-ascii?Q?bg30vn/pQEK2TVWwyzdlxo9unhXJ5c17e+oN8uv4fxnEMd3t++lbuEz1bpx3?=
 =?us-ascii?Q?de0bipQEr3CROOb4f9iJHY6IUZC/VnP/0hdNQTpr1yu9oMgy+D56UhRezOYw?=
 =?us-ascii?Q?PXyyPKMLAj3pbNAPXitOf7dlZQcoKSfjSV3SdLRrzTH7QywH4myhDEfXpqyv?=
 =?us-ascii?Q?I6mH/AU8g7I/BqESAOkyEBN70+pH+1SRjCYFiQJGOt1fQUPfIZ6DIHCAol+N?=
 =?us-ascii?Q?HagX0JEuIkcf7pfL0Ks0ZbjE30R0vvSmlJjqSzG4cmX4T9qO+mX/P/MObifd?=
 =?us-ascii?Q?hoHPnRTNLbz3T/HFW7zahkz8z8sJaRLw4DUVU2DwPHIw/Zrsu/Td4c2SCpND?=
 =?us-ascii?Q?RJIJW64QSzIGhC4AcPNeAqDCP8CwaEw+UriSPZhBhy0VuMEVoFSaZ3wzErS7?=
 =?us-ascii?Q?iN7a5870Gzw56GEaIoXRHCgJ2tb272kczOBp7WpQSaZ4UZlHAkQoaxzEhTza?=
 =?us-ascii?Q?OWni8r1UG+aaiRZwxbj+UvRR59d9VV6abU2aNSMKY8xaCApTFjXdrSlr//FX?=
 =?us-ascii?Q?uvb9eilUMDPjJiK+F0vkAN0mYykdtfWbjj8rN0yLJ7qp1ILYLpBEKUdU3n4E?=
 =?us-ascii?Q?pnKR2NfLjPu/jpZZEtxstm5LMTACGQQy4Aqyv4xRrS4Se1jXceTPB412h4rF?=
 =?us-ascii?Q?OW4PigPptxIBnH5DsJlazAJBVi/2rk+4uoo7HMSuWJlIOlHMGQf0lZvVxIX4?=
 =?us-ascii?Q?YBZfJy/hLhv3uEflxm4ut6dBzMvqbx8TAet0IiOD2/+h+2Oxz01HBRhwZOUV?=
 =?us-ascii?Q?hFiXqM3aYoj1YW16by+9F0jxnria4E49Pyaog7NjRu0eCyiK+7mA0GUQR2Zy?=
 =?us-ascii?Q?D3N6LPVLAskJ3xt6udqCiN4Ur7Oai3wMIk6DWdxqvoi+XaIgWP+0hhp9j4yl?=
 =?us-ascii?Q?2PBtOyuqs+C0LKGvGl4lD7cwHFqaGx59hlhtWfvYUUyoAT+nnkYd7/Nu4u+i?=
 =?us-ascii?Q?rFiM82wBdNb0AhDJO8Tkj4Bn9tLKl3dQY2h6dTa5KZJw8tHB95Le0eACNWYu?=
 =?us-ascii?Q?MShKPAHwnJMC9RvmE27FukUKVwMLwC84Hgq7no4NWi5AkXG90VjaD3omjQ6r?=
 =?us-ascii?Q?Lz6TXOgwpq5dpqBfh59rbSn2q+IZ5NEvYSXkQ2bojgt1/J820ccHPdbqGx1x?=
 =?us-ascii?Q?PkHvMRlLsrtL88Ij/JmT61Tja4NgWDU5K8rN6dtZpJT4qhA2gNHihfs3GC0e?=
 =?us-ascii?Q?uI88eCj/MSvvui12bNEjowk793KLiYmM9dIKvsFvhvG4Ssax7iVnNluCsaJS?=
 =?us-ascii?Q?PybxqSgf/Nph9fNnd/m7sXE5Qx5dxgbzBLGkFrpxNEPdyJaXdCDyIWyYtbfh?=
 =?us-ascii?Q?i24JDapblxa/o6cB7oneD/+qHkmSVdR/D24gjvSJ8S8WadpHIm8XnLCwBZBX?=
 =?us-ascii?Q?xyRBuoAvIbVPbrEZKpSSSjjWA1IlIvQCUqyNt+vDOgOdFWp4ghfP4vDBdz1A?=
 =?us-ascii?Q?mXE9yQFl/0azFcjzBSRIZdg1IxDgq0KI6zy6Zy12DPbe96v0wQgpvRE20ycV?=
 =?us-ascii?Q?/AvRZpupaUgUSIynyPEc5NmaySIeb4Kx34m4whKXclssUfWiv0o9dRV1jjbQ?=
 =?us-ascii?Q?t1uSgw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYBPR01MB5341.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39103bc9-0d56-4978-7ac2-08da9c3a34df
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2022 01:31:43.4819
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y+cogDx5ZvFKcU9XwAtNcbUxizLH5OKC9VMbQ69pmiagx5VovPrdAAGreXXGWzrWoPPk2+7scVVSPRKypMpfxKBbaCbV5oZ9f5VZfPCeF4Ssz6bfLS/xyCsVgCRggxOb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY3PR01MB10516
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

> From: Andrew Lunn, Sent: Thursday, September 22, 2022 10:19 AM
>=20
> On Wed, Sep 21, 2022 at 06:06:40PM -0700, Jakub Kicinski wrote:
> > On Thu, 22 Sep 2022 00:46:34 +0000 Yoshihiro Shimoda wrote:
> > > I thought we have 2 types about the use of the treewide:
> > > 1) Completely depends on multiple subsystems and/or
> > >    change multiple subsystems in a patch.
> > > 2) Convenient for review.
> > >
> > > This patch series type is the 2) above. However, should I use
> > > treewide for the 1) only?
> >
> > I thought "treewide" means you're changing something across the tree.
> > If you want to get a new platform reviewed I'd just post the patches
> > as RFC without any prefix in the subject. But I could be wrong.
> >
> > My main point (which I did a pretty poor job of actually making)
> > was that for the networking driver to be merged it needs to get
> > posted separately.
>=20
> Expanding on that...
>=20
> You have a clock patch, which should go via the clock subsystem Maintaine=
r.
> You have a PHY path, which should go via the generic PHY subsystem Mainta=
iner.
> You have an Ethernet driver and binding patch, which can go via netdev,
> Cc: the device tree list.
> And a patch to add the needed nodes to .dts files which can go via the
> renesas Maintainer.
>=20
> At an early RFC stage, posting them all at once can be useful, to help
> see all the bits and pieces. But by the time you have code ready for
> merging, it should really go via easu subsystem Maintainer.

Thank you very much for the detailed explanation. I completely understood i=
t.

> All these patches should then meet up in next, and work. If any are
> missing, the driver should return -ENODEV or similar.

Yes, I did test such things.

> If there are any compile time dependencies in these patches, then we
> need to handle them differently. But at a very quick glance, i don't
> see any.

You're correct. This patch series doesn't depend in compile time.

Best regards,
Yoshihiro Shimoda

> 	 Andrew
