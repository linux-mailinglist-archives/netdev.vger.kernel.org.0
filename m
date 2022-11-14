Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA8C628364
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 16:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236355AbiKNPCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 10:02:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236763AbiKNPBt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 10:01:49 -0500
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20049.outbound.protection.outlook.com [40.107.2.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E67B61FCE7;
        Mon, 14 Nov 2022 07:01:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a9FCGoKRz80RFnN65r7CzVeCDyZLvEE19KDK2ZsnwfdqdXIv9Hzq4zpgcnsNYR2xeObT4FxyCvzNFP06kxwUhG/SRtsoXGo8VT/lhh+oWgJXQmS2RyNnjrrRgvg/4BP6a2DPMuRs7LIbjXMEfMMJmAkebyTkK267CHo2AmDfe55XO4/kHOLcURzLhZV7U4epDY2FxB2PIWDmTLIBkJSWduTet/N+1zgiUUWyvZt1hFrqfF4KehdhrAMtEO2JoZl0u7OOgKbBsuLx/IFrUUaE4nwfXx19R1XS9Dy2/9Jj8pkpmM+URwe/WZm2vXLhvm9t+PecURe/tX9zqh3HWhlm3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uBXRcXa4i2V863rD69nOSoEC/yTnY9QnyDhZy0MqRRA=;
 b=FH0972ayynvu1hTKA2m/+w26/Jz71P3mA2LnqJTZAUqlQZJN/Kq/dVS0GfL4q5ULjzE07f/ATqCe899camI4Rbqyv5UWzWTN91mwCpSdzDTOJ5aGevVgIMlQqGYJRu1xWFV7qCy6Yrr+/gPZ6wGPb9AVwn6hkqWNezNF+W5UXrDS2kOJszgKVzHb5wiauZOHogSw8i3+Eg97fOkLBbaU0Lk/zEiT7lM3zo+4XNbOCD+3UVDL6NhfEYWGeSp9B4DrZGS+gbNT9OOvrf6Gwb5WtL4BEOmJ91jjeeoLSEFTPoNq1Z/3RCQv2Z8143qzhFmoWyBaGF5EnVt2Ox7x0MPvCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uBXRcXa4i2V863rD69nOSoEC/yTnY9QnyDhZy0MqRRA=;
 b=Vyz3JihagWmuO6iDiGEv5PDE95VFHLoYFDFaDaDLaWzrkolJAwi/wYbTFZ61yUND1jwOvkHnThq2a0Zilhl58W4osutp7S01pNxZ4C7tVki7rynJm92v15aeVxH/zK8kSoiAsjlEY2WoIw7l9K+ptcbSfRkoqC1vPPI1aHstDlM=
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by AM8PR04MB7458.eurprd04.prod.outlook.com (2603:10a6:20b:1c4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Mon, 14 Nov
 2022 15:01:46 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::6b44:4677:ad1d:b33a]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::6b44:4677:ad1d:b33a%6]) with mapi id 15.20.5813.017; Mon, 14 Nov 2022
 15:01:46 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Andrew Lunn <andrew@lunn.ch>
CC:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "imx@lists.linux.dev" <imx@lists.linux.dev>
Subject: RE: [EXT] Re: [PATCH v2 RESEND 1/1] net: fec: add xdp and page pool
 statistics
Thread-Topic: [EXT] Re: [PATCH v2 RESEND 1/1] net: fec: add xdp and page pool
 statistics
Thread-Index: AQHY8+NzKrQRZ3k0YEy+QDrsvHgkC644DoaAgAAaV3CAADZxgIAAUdXAgAXC4QCAAARvAIAAAdMAgAAPjpA=
Date:   Mon, 14 Nov 2022 15:01:46 +0000
Message-ID: <PAXPR04MB91850496D46660D3B8394B7F89059@PAXPR04MB9185.eurprd04.prod.outlook.com>
References: <20221109023147.242904-1-shenwei.wang@nxp.com>
 <4349bc93a5f2130a95305287141fde369245f921.camel@redhat.com>
 <PAXPR04MB91853A6A1DDDBB06F33C975E89019@PAXPR04MB9185.eurprd04.prod.outlook.com>
 <20221110164321.3534977-1-alexandr.lobakin@intel.com>
 <PAXPR04MB9185CDDD50250DFE5E492C7189019@PAXPR04MB9185.eurprd04.prod.outlook.com>
 <20221114133502.696740-1-alexandr.lobakin@intel.com>
 <Y3JHvo4p10iC4QFH@lunn.ch>
 <20221114135726.698089-1-alexandr.lobakin@intel.com>
In-Reply-To: <20221114135726.698089-1-alexandr.lobakin@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR04MB9185:EE_|AM8PR04MB7458:EE_
x-ms-office365-filtering-correlation-id: 8e744bea-9cf2-4759-68e0-08dac651262e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5nX0TjV+vJLL7xs348SdEY+5Rj0XIQLOy9YNw5HT1cWpzoeh3e4eazvnj5Jjrpr3WdNDV9Jzjkjp3SpLhxvlwFCGdtsV/we5xw1ZXkxn2QgJ/oXJTSeQGxvibO6/DyB1MuTz3ef2mQyJo1rCEnq4YZfqiQj++yErxHBYLldlZbT5Z11+t9IOVVGrQ3Pawyd0ZRyxWrkNhxTffJ3yGRURJebqDQuUf5Bi8MgVKdirtrGYOcl6wtscGb6y2tCtgYUNIjWTKeQEg8qx/++CI+UlXe57pzJmkjtyePOUQmQmEKvqcEVbKoLLOhY1VmFHlq9fyA3gncPDxf/6NRDQ/oMCVKI89rIW5mpihRgbJ3Fuao1Ivcjvz4VwIRL3px70696q7GXVC4Fq0bWkrg266yTCko+3miS+xzNcaaSp7FvX+i5za2uAx/GjQXkoy64rpyBLA0tHKZvpqr7wERaNY0BkPWlw+8QQgmKN4IWfWLUNkgtz+ktFBnjKRtKnfcKl6cR4aQWCQH0JfR1Qt+DQoXNsmyipPcbCd5wiFoNnyQnF2A7HcmD1ZuB4Xim/doO2a9Ab7jLvlgEWTNd6MDcyaf1e3EvKKoEI9RvUH/R028KcYCelhNXfYvb93gbT810DSAaisuGpTPDbw+yEr29oR06veGe5uxZ1ZXPbPdKFuM8J+tb0yhQMtQ0bRBaY5BxASkDCPEGTLzz/w3xV+eLPodnduFKav83IyFJ5vEGE1B1T0qHOoiufvmiCjnbHnUpFO7+uRE6kmFbCknmUkD1lWPzz7A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(396003)(39860400002)(136003)(346002)(451199015)(55016003)(86362001)(33656002)(38100700002)(122000001)(38070700005)(44832011)(2906002)(186003)(64756008)(41300700001)(66556008)(4326008)(76116006)(66476007)(5660300002)(66446008)(66946007)(8676002)(7696005)(53546011)(7416002)(55236004)(54906003)(52536014)(316002)(6506007)(8936002)(110136005)(83380400001)(26005)(9686003)(478600001)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?GuQjTXds0umjqxWFKK5MFZ4J5hKMiLwnIPpViRT9pdb4w+qmMe0kXKFsLuMT?=
 =?us-ascii?Q?0KjoBwykCU8+/UCp3jf6d6IJal6lBIQuHR3zHNtJe+JAI43UjohtHfTRkz45?=
 =?us-ascii?Q?BFtbyRvh/EGos1Uk4KYlX8N0XetcsZipZHUaGJn86sEN7NX/xoiBEsMIf13/?=
 =?us-ascii?Q?R2FELDwCLyfWB/hHPNp0EM18mVZ33swZ4A5QlseORSbukUd6wXGY4WivgGMR?=
 =?us-ascii?Q?qJK0TBqk5n1CnyU89LTO1EKYbcNKocVd6Rsrv1h8JhXtf3DmXv1Qq1JYPMus?=
 =?us-ascii?Q?SwFgED/rCEDK55FEOxsv/kS/L5F5N0mQTeQU+1oQHcoSGHySzBoNcrurLJmq?=
 =?us-ascii?Q?A95OvucXwsu8mwZuYxATi/b9m1gcxutCkkvG3OgsFhlGbFclQmb/On7LyxQy?=
 =?us-ascii?Q?cmGFL5lzlu41pU3keB5TD47LbjkBWn09f/UGPdUt9wVHkpLvkVbsCor7XT16?=
 =?us-ascii?Q?qxcsMq/roDCdVlB2os5/DTIwtZNSVNKQ9IKamps3Gatxln0LMVDav179Inkh?=
 =?us-ascii?Q?CcrEbNgolrOSfr2mgHdbgIbTpBM+3ViahmBWk75qX+qZoKeHhiGGTPH7yiYb?=
 =?us-ascii?Q?HxMhB6+4oyurDhPQKvX6ThSqYPcs3/nmaH9ryMlSdx0cl3uayxqNZMg6MsGk?=
 =?us-ascii?Q?TRuDgKN6O0d6gFY5ja9ov2xfN4SJXIT1639MImoGLhGNOnhlyGeNGXoWW9Le?=
 =?us-ascii?Q?bqXS3q9Ge81haZYqhjZ05Yygt90RT/Vm2hocNbJfDWFGwJenDhQdRqWHNX3E?=
 =?us-ascii?Q?eMhgW7rG1rgejR8owmc3npOzO52z4jbimEUoOqTshzGWRzcNGyx+sTzxJAp2?=
 =?us-ascii?Q?UPNj/s/2bOJDWNVfHJnBG+MZbpMi1Gcdoz6DbaBvJ3Kd/u+z1hW9rMR1d7Nv?=
 =?us-ascii?Q?F7usOhjoU4+Hx43EmBHsPgjqV2fXG8SSYX+9tovIUFBODlNdyXty9V/th8MY?=
 =?us-ascii?Q?akuLGLy6QZliE4OPD22U005lZ1PxAswu+4e1EeGQOobGuSoCC7fD5U6MP9xX?=
 =?us-ascii?Q?W4l8RK1eNt57M+/87ELoXv29ifthN4CorhmhqdXFR4c0KDww4wgPZ3rA6Aw0?=
 =?us-ascii?Q?wR9PCzYwSxffko92kZ+B93Qqsmh+Hj19QR+5WzYH28xwmImvsoWGy5/iGfJk?=
 =?us-ascii?Q?XaKeapCu5OF3hZdTKR7Nq4vHBCAoO1f3aNLLANLRjr9gvXRSjWBPvYPr4oPU?=
 =?us-ascii?Q?UBzx4fM2zxEPfLPGrD+1PJ0/ucfv/O6DLkkQ03Is3TRGPtSE1bKuT6E8haRk?=
 =?us-ascii?Q?7RXS+P5bgU3uvewQMnnDhkXI9bp+UAxNOaL1jgg+bw8c8boRwT7eS50bTGtl?=
 =?us-ascii?Q?CZmMxJQhm8kfY+2EMoAHoqIEYK89YmQXPFJhWzi/kvX3ZFLc2EFknVtCgLXL?=
 =?us-ascii?Q?jLDaoALOVkvER/aNcDRj8ebkocHsss6Ubo35e19KWVkOXAtuqv76pmI2Cr7u?=
 =?us-ascii?Q?D0qAG4x9p/b9ZtU4Y8ZWcUqkkkz5fXKESgkyBvzmOLbF7aPWxJ4HS5xqoF9b?=
 =?us-ascii?Q?NnZfkO7RIAP2jYspfwUDVulupQrezV0LOC0r1+C1NiX/JPYgTHl8UmC729JZ?=
 =?us-ascii?Q?w6l9raGHnHngO5/O2mf7r7+BsRMZyNZcn8AQmU/H?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e744bea-9cf2-4759-68e0-08dac651262e
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2022 15:01:46.1104
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NLyI+xkRxC9cvpmL0G2lIFHtNTFowN4OThiaKvshdjy420+vSDH6GP+8VUYYoiduJyPe5xv0zNNBNo1tCDHh/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7458
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
> From: Alexander Lobakin <alexandr.lobakin@intel.com>
> Sent: Monday, November 14, 2022 7:57 AM
> To: Andrew Lunn <andrew@lunn.ch>
> Cc: Alexander Lobakin <alexandr.lobakin@intel.com>; Shenwei Wang
> <shenwei.wang@nxp.com>; Paolo Abeni <pabeni@redhat.com>; David S. Miller
> <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>; Jakub
> Kicinski <kuba@kernel.org>; Alexei Starovoitov <ast@kernel.org>; Daniel
> Borkmann <daniel@iogearbox.net>; Jesper Dangaard Brouer
> <hawk@kernel.org>; John Fastabend <john.fastabend@gmail.com>;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; imx@lists.linux.dev
> Subject: [EXT] Re: [PATCH v2 RESEND 1/1] net: fec: add xdp and page pool
> statistics
>=20
> Caution: EXT Email
>=20
> From: Andrew Lunn <andrew@lunn.ch>
> Date: Mon, 14 Nov 2022 14:50:54 +0100
>=20
> > >    What is your machine and how fast your link is?
> >
> > Some FEC implementations are Fast Ethernet. Others are 1G.
> >
> > I expect Shenwei is testing on a fast 64 bit machine with 1G, but
> > there are slow 32bit machines with Fast ethernet or 1G.
>=20
> Okay. I can say I have link speed on 1G on MIPS32, even on those which ar=
e 1-
> core 600 MHz. And when I was adding more driver stats, all based on
> u64_stats_t, I couldn't spot any visible regression.
> 100-150 Kbps maybe?
>=20

I did implement a quick version of u64_stats_t counters, and the performanc=
e impact
was about 1~3Mbps on the i.MX8QXP which is 1.2GHz ARM64 Dual Core platform,=
 which
is about 1.5% performance decrease.

Regards,
Shenwei

> >
> >      Andrew
>=20
> Thanks,
> Olek
