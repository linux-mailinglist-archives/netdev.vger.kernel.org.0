Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8C25613FC7
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 22:18:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbiJaVRf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 17:17:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230317AbiJaVR2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 17:17:28 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70057.outbound.protection.outlook.com [40.107.7.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29431140B8;
        Mon, 31 Oct 2022 14:17:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M4Rn3lB41mPcnv9NEWycTNuFvN6BDfiOEEYSClwhN8eEFvqaGp5yhW0/fwdl0ewlsIpGbdd7PaopFSWpi48fXFvr+RvWOLrpdxZCYD+lBe+pXp/HUYeCLhoYN/e8kcErCTegDYxv3M+pN3aoP8KqfBxeMDUn9E7658bLDaDHlIVlruvTnFX85NCG7xHXFOyk0xOL6HI+IfUYeEoutKi8vok8kEwOXfewx0N8Qdr1VXsu9qz9QY0IcVY623BeKxGafmMxNxuWiAYvRGAg/dXW2fB5LycJ6JTX11Dbk+geqlCqVH/VWPjRGSEo9DY87KyH68bEKd1gwTv0Y/OTMUJKMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XaM0F7UAAa+2PQcGqbw6D+Qn12dbxsAf39uiRSAH11w=;
 b=MZoYiyEHdvw+wKnqmTdcb4qYJM3yQfYIvG+gPdPgJDdIH5GXJiTtPFLFVUFnqVLol84AVZfSyibQen1ACbtKUDJg2MsBhI2+hEGAHR1XorgFviKwSAYH7ioHBJit4P2mS76fKj8Z1MP3KIfV6Yep+eqvW7x46U+loLfd+WC5OrVjWM3bb9kTjv4frQdKNCgqaM2rUj47yzwnC+XqCRR8CjpSd/S/i6DjM4+rIXyOfcv7G0P1SE7/59dY+l7LuihgzqxgxcRooHUqZHFWIFju40qBDqx2xsQvc9TPBBYOJlTFnA+ghrjUZaTbtLUTN7d33XFX0CGObt9MXAvCZ/UdNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XaM0F7UAAa+2PQcGqbw6D+Qn12dbxsAf39uiRSAH11w=;
 b=dJP52m8LAxzYqjs6pOMV+iVWku36pdBzZzxRstcKVdCczF7VZUy0ToVbdgMtk/NMTQQhMVOugv/1Xia3GmCCtu7XhdXruWbDYxZY83NFvzBnTZYmhma72MSHWn93kiK7hoNRUk4GFXdwh6tp7H8LzWPCK71Sky/CAxDoSTJ7Zzw=
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by PAXPR04MB9122.eurprd04.prod.outlook.com (2603:10a6:102:22d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.18; Mon, 31 Oct
 2022 21:17:19 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::b1ab:dd4f:9237:d9f8]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::b1ab:dd4f:9237:d9f8%3]) with mapi id 15.20.5769.019; Mon, 31 Oct 2022
 21:17:19 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "imx@lists.linux.dev" <imx@lists.linux.dev>,
        kernel test robot <lkp@intel.com>
Subject: RE: [EXT] Re: [PATCH v2 1/1] net: fec: add initial XDP support
Thread-Topic: [EXT] Re: [PATCH v2 1/1] net: fec: add initial XDP support
Thread-Index: AQHY7UT3Rg7ikccfbkSHV941HzNcma4ovLaAgAAVGBCAAB8oAIAADzyg
Date:   Mon, 31 Oct 2022 21:17:19 +0000
Message-ID: <PAXPR04MB9185FC004E87082B04CB8A0D89379@PAXPR04MB9185.eurprd04.prod.outlook.com>
References: <20221031162200.1997788-1-shenwei.wang@nxp.com>
 <Y2ABb+G+ykcUd413@lunn.ch>
 <PAXPR04MB918581FFA58483608B3A7DCA89379@PAXPR04MB9185.eurprd04.prod.outlook.com>
 <Y2AtRL8l1/kZrwx7@lunn.ch>
In-Reply-To: <Y2AtRL8l1/kZrwx7@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR04MB9185:EE_|PAXPR04MB9122:EE_
x-ms-office365-filtering-correlation-id: cc22a4b8-2b96-419b-157f-08dabb854b4a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vFb1qCMiPDSF4zl//Ov3REKoVuur7VSVBgpfXa6foHj0Ig7CZmplFM859izfBLKY0XKKuwmPFPeDdq33HMUmNZ7zetCMCe1PU4e7CLBsZ6BIvbOXegmXLCF9EZSo+PJZcSrueolvIEQtxea60qjhy5djSX89iQMIVgI8ARRkn3v7dgoa9Pu4iQ50wxPl21aNDh50UvvpNPc5czXxJTTMaQ1HyYKVuUwcXZFWZOxB0ER1xBHcLi0lmWzkRbtkbz3osApzHJHUuImGYkqP1Hv0Hz2fMS6IpD/jJ+L8h6EBWO5M5/Zsh81MTBm86JZOjITo4S2BtTk+XguBlZHxigCdktLtwL6zQhDBQixG8KUTCzn5QBAkFZFc2nZC8HpDF12Cv1XrAsVQfbEoxDtU+oAJe1zzyQdcNdFv7atsgy33s7YP2h+gvee2QkN5dXuz1JLHtuxeX51K/dxr87MNPr5ruRFgySEZKZ9jAkcbu28bLjQX/4wHYDxjUgrtFveyOrOgcQlF1t38yWqBcv/nMarYXGdluDLEr+O3RYFyo7WKGoaGYWbvnJKL1wg79Ug1yeBYpfrVyOeW29Cvpd6rUv1ovqaDfYjUYy71pPrn/QbJfMnFa4OkfG39FK8v/vh89wp5YtWu2cI1CcI2eXNAqUElLFylkdRtg6+fgW5BoHockz9IwdIgYX4IhEjYdWcpAOW3CPQzOF83IQ9pZtqO8J9WH4FTXSLxsZMkz20uD+5vi8oRMzzPx8L4airABZKh5BJL/aLPkR/vQQFfFFVFrmI2eA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(346002)(366004)(396003)(136003)(451199015)(2906002)(316002)(54906003)(6916009)(83380400001)(38070700005)(4326008)(8676002)(76116006)(7416002)(5660300002)(66446008)(33656002)(41300700001)(66556008)(66476007)(64756008)(66946007)(71200400001)(478600001)(55016003)(8936002)(52536014)(44832011)(186003)(9686003)(7696005)(6506007)(38100700002)(26005)(122000001)(55236004)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ONPilNgNgybCvVlmTa7our+YIra3nWbC4W9lrmlVoXMzWGSPaQ1gMSU5Dyr6?=
 =?us-ascii?Q?n2ZCQOV3aGroEKPpihwrgq/i83sejQNkO5/6yR7xZ6QFenV8g/b8dY1LN1K3?=
 =?us-ascii?Q?oVtTMc4Xo4FLQ0nMBNOnei2/oMzicOGfkR1xX8cm9w/+24KxRbdFp1UuceCp?=
 =?us-ascii?Q?mAbXU0g/uNuxidhxesMnvzGhnw9h5cWuygJpB5VZHtDkg6FmvadnBVY+8/P4?=
 =?us-ascii?Q?CbUgDiVYtwt3vBRZp4aPWjP559NN4HJpauPbLTfWzwp1cyw/Xv96uPhLbs2w?=
 =?us-ascii?Q?cXr3mIGGGo0Gv/8EbQwT+N3Vr3BxgqoZyuTetd6n2TebCNyZaDMrwN7bNKgQ?=
 =?us-ascii?Q?bYnnL3OnhchC2wb4s4l9i9eI3eVXGorH5W6l0QOq0yI71qY+Rf920wpQ7sv0?=
 =?us-ascii?Q?uwBsyhBFcbszuulEMtBp6kTQCjmEHTyvQ04zWulGMn6JfOn+4bVU34IygoWg?=
 =?us-ascii?Q?Ve4SHUlcu+tD3WqZT4H/G1zgbQH8uwXuRpobQeJgqfq4r95/2+j/N/TLsDxU?=
 =?us-ascii?Q?SaSaa+mHLmDrX6tk9a4eKc4jv6SONoD6PTpwp5FmQygvNTcLg9+NsuFWRaOD?=
 =?us-ascii?Q?m/4SlVFzd8FqvQdSgsnZuJFRAH/2F4Oo38qymBCaB9VxksJRm/ENfggZmQne?=
 =?us-ascii?Q?pZtim6/vBi1PiVj2A9W4hmBqXeMI424JeJ8oRpeMKcfKU4tuhrizO+mFeGmv?=
 =?us-ascii?Q?5ny3kCMkBPC7fIcSsYP8DsmZcE7fkf3othTU2CagREhcIY/t6l2jvzqUqxao?=
 =?us-ascii?Q?36HORfR5FmXPdxeGW6/bYdIKRwNp74gbihush10usMkoaFDHSCEkjZ7WpBn2?=
 =?us-ascii?Q?ImoRihcop8kfimGU4Zwsr9h86Ry32sl2ZRp7mTxyQDpNvCo1GrBvzeRsVdud?=
 =?us-ascii?Q?Bf/9H7hPQ6FyBFODSwckQrISkUOrjBifWNSzM82NWARpfusNK107v1mdfw3p?=
 =?us-ascii?Q?jZPMyHEWQrFXiJdLTzUNjEQTzIPB08OsjmtP4F2V+m87sY2+POTQflz66P2r?=
 =?us-ascii?Q?e3PCYc+Tn4X+wceQ12gW6+qxzlUGxPP6n8D5mQmOHzEsQ42JL3SyqdLL6E0M?=
 =?us-ascii?Q?G16nYqSEwUr1Qrkq0xUy+9n414iBfGV4hbkVLJeSEfSXL35JVStENv0nkCay?=
 =?us-ascii?Q?WlcjeFj2FzziACVYAa/t/vj9L6wyAlO8pf9obE5W2C6sQGUcG75Qzc9hds2I?=
 =?us-ascii?Q?To6JaWrlqwtIpZhHY2OZPd5dMzmjmqgGAD6LzcSMqyh2okiM667DsVzgJlW5?=
 =?us-ascii?Q?gO0O2U/wuBlxXuJK24+bdS5uxGDC9QYoyM8YSeN4Lbgx2DMgSB5I3Y42uH5H?=
 =?us-ascii?Q?M43p4LCjuypMhOeDxunOwBcD7WpuO944SJ7MvUsoO9QULYmUE/wZarh3pZkA?=
 =?us-ascii?Q?7PgmY+h68KBGDMcox1pyWiBLaHknV+qZ4Cs6PClyLsGTTdEnH41uk5dLdbm5?=
 =?us-ascii?Q?HW7jr8FTqKIQUL/ybC/sRcGFw3WGV8vQku20wQr295CfWn8m4jtYhD9iMGG4?=
 =?us-ascii?Q?hHxScAqxd3ZUrBOm9moBdhlaFr6eQ8/AsFXrrsv+29z/C/rjxdLzVGk8+0hT?=
 =?us-ascii?Q?h0+mVePQ4Xx/dL/cilMzGJBbXKma3AbBlv61Pccb?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc22a4b8-2b96-419b-157f-08dabb854b4a
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Oct 2022 21:17:19.4209
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zQFONHkgKj8QsgT9BvJUTfqEtkDyeVMh23pzbjDp4xg3UpZOSK9KdhFo+T0pa/565u7/BNlh7ug0gtiPXL90TQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9122
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
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Monday, October 31, 2022 3:17 PM
> > > to disable the receiver, wait for it to indicate it really has
> > > stopped, and only then make these modifications.
> > >
> >
> > Sounds reasonable. How about moving the codes of updating ring size to
> > the place right after the enet reset inside the fec_restart? This
> > should clear those risky corner cases.
>=20
> That sounds reasonable. But please add some comments. The driver has
> RX_RING_SIZE elements allocated, but you are only using a subset. This ne=
eds to
> be clear for when somebody implements the ethtool --rings option.
>=20

The latest performance data regarding the native XDP has got improved a lot=
. The ring=20
size change doesn't seem necessary any more. The v3 patch has removed that =
part
of codes, and that logic can be added back in future if necessary as well a=
s the ethtool -rings option.

Thanks,
Shenwei

> And i still think it would be good to implement that code. As your number=
s show,
> the ring size does affect performance, and it is hard to know if your har=
d coded
> XDP_RX_RING_SIZE is the right value, depending on what the eBPF program i=
s
> doing. If the ethtool option was provided, it allows users to benchmark d=
ifferent
> ring sizes for their workload.
>=20
>    Andrew
