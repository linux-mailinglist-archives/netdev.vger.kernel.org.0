Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D83C613D64
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 19:34:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbiJaSeH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 14:34:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbiJaSeG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 14:34:06 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70054.outbound.protection.outlook.com [40.107.7.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41B3C12626;
        Mon, 31 Oct 2022 11:34:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ac5fLu2wTyu5ECP+ygv/bEWljQRZQX5IjHEelSsGGiMc94cItc0YaurnBoqC8sRbXcxXE8ekOwl0v0uU2pFka9Me49h89Bvk91laiq6YadvTd/ZXoMbAn6ehzVrNGotDkrXtD2b+Ig4fA3uOHCyCyGQLJ1jK7ytXrGvdJ03b7gC1O86JUn9pc+kM/Ip4Yp18ieKdnPHjGbNPhZl+ril7DRm4s3Pu1H3gqCvfnAmGvmtG9EI4WaFELhtghm3XrtKSFJscuBjrcyExarxq6gT8ngGbNp8tDH6R66sjJM+Uf5uipGwM+dobsNdLxhnCFX5Zav+RNapGtEXVDY+Tyn2isw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c/C4kifzUKKsES+cooWq4imyJ5Evnkf6Cdz7TJh2Tkw=;
 b=Hsm1iaKoPNuumRBXiRpdTFbPAC9fCGqvEM4uK1qi1pH3NCJho0rnI0xge27Q9AbCmJ3bXwPUpI5v6xNBQ+5yavW6yLpF1JXPFGR2LhaVgq6sspi+P8y7PsNzJUKSinxYCfZJZsYO7gOo5KtgTNvP3yiyhmLUmPhBuTEmc7NZwNI9uMzGBSXcB/9D3YYWPVOAdonF+cSVAce0Iy8fzkFPnmwU2H4zyVTOQFQhzC9cAe/EyzDxtFJT/WPQnXEvnCaIyb1omtxzIpbAaXc2P6Hgbj/M9YEgjAV+HfEf0EsOL3HeVRo+gUEC8Lkhy1sqSliR4C0IJCr1Nll3CM2fK4bOaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c/C4kifzUKKsES+cooWq4imyJ5Evnkf6Cdz7TJh2Tkw=;
 b=T/QGBbQwe4F3YnY6Db4+hvpsPhEfBjAXcJ/LR3YK7doxiswWmbWyYrjbTLFSNEGa62i9XUVTpM+gyCTktKyruPJPTeW5hO3AZfUyEJ9ddbz4mvcsrQSCZkq9+qPDFS9naf/knFl9+o2JBB1beHnDlMeWpSUTwN+eRDrE7+uDLNk=
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by AS4PR04MB9292.eurprd04.prod.outlook.com (2603:10a6:20b:4e7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Mon, 31 Oct
 2022 18:34:02 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::b1ab:dd4f:9237:d9f8]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::b1ab:dd4f:9237:d9f8%3]) with mapi id 15.20.5769.019; Mon, 31 Oct 2022
 18:34:02 +0000
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
Thread-Index: AQHY7UT3Rg7ikccfbkSHV941HzNcma4ovLaAgAAVGBA=
Date:   Mon, 31 Oct 2022 18:34:02 +0000
Message-ID: <PAXPR04MB918581FFA58483608B3A7DCA89379@PAXPR04MB9185.eurprd04.prod.outlook.com>
References: <20221031162200.1997788-1-shenwei.wang@nxp.com>
 <Y2ABb+G+ykcUd413@lunn.ch>
In-Reply-To: <Y2ABb+G+ykcUd413@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR04MB9185:EE_|AS4PR04MB9292:EE_
x-ms-office365-filtering-correlation-id: 633a0b81-c9d1-4f1b-30ea-08dabb6e7be7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lTU59zypKU1n1zI1uVBQ2BcdmsUvpPNkrsyJxsg5CM0yM9Qv8jwYgjnENTmA8tqJZTOgMRpleX1wgSNdQ1fhrLGhUnEYIilxkGGwR3TLA9o5Gow0qrX15vr2K+Bqd13HA2KlarmQKMDzP1BPkAwSlisS04gU27Alpw+lqk+hOvFbPafZm2katXDoaOjYUazPOKZ5wUt3d2PKpFJNGOK6dfgIXzVbyGVuXT+kaYV6r5kdTXPEC2BlYE/I3f0BwXQRA84ZFXwG++1Xmd+S3EgZsMwRwjM+inpIskYXs5z0BUcKZucGPB7MT+fnYSXFkTF3B4zrxqrvJORq4aONym/P2v/U0mS3wyXzGXyaO+TRPnGkYhjP4/+pEuJLaC2d/iyBMckYG8WnXLvAoYtl8iiEFtmTBknSeR/OFQ8wIacZI7gjWwHIcovdL+3MQYbI0vmgoEZsfY7tx1NPHvgPMsEM/R60TWqkqHm6FV+l1C4r0rPrVtQY4sLyKy7ey2r0N9O+2EbRer2XUf9Au80r3RwlgllcWzgnMC60Bz8ykyt2v1TOEX+yp+9Jk3/+bKpm/5EFuWM9UEI8NLq7hm0resyrKTB5Frc8IFlfUHie2S8qSsODMiApB7FBltvnWG1Z2o7Nva29Wz104eSJFBa/pvhxnNZ34kH0m3JXXM/5tIpp6nvZ0JTAZ1zODnFgGZMcqW3Dq/VP+XzcgEH/2HhkGA5XBrJWowOmYVWySFM2NlPxOvtPYnxgrsRE74Y43C72jbur14Bw+Rd8uvl9F22yUNd50Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(376002)(136003)(39860400002)(396003)(346002)(451199015)(86362001)(33656002)(38070700005)(38100700002)(122000001)(71200400001)(186003)(2906002)(9686003)(44832011)(55016003)(83380400001)(478600001)(7696005)(26005)(53546011)(6506007)(55236004)(41300700001)(66446008)(64756008)(66476007)(4326008)(8676002)(54906003)(6916009)(4744005)(66556008)(316002)(5660300002)(76116006)(7416002)(66946007)(8936002)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?VPlZFQI2yZKGZikmsHWTT4yMhsZahKi8FquyHJGIuAp5aLJkkuDTk4kLJdPk?=
 =?us-ascii?Q?/Mm716wcEd8/Wi/2QMynXTaXhv0Am96g8YIGfiTmKetxywACcFAhwq8t8Ir4?=
 =?us-ascii?Q?bVS0YGJHTCTaO4bJ2WOrwPJGTXrrXLtXs8D8zQDn1RyyMZp0kpl7JXgt6he5?=
 =?us-ascii?Q?lpc9MNEUsIAPgAK1SlwLVMRklhsYpV0uMzipD+l8gYYhmAiciXKlD/X7yzgk?=
 =?us-ascii?Q?HCLJwYc3p0Soj0tg5H08/knZ9VySZ1DZTzZl+iaPUNhO8XTRjW0I+eHNqDp6?=
 =?us-ascii?Q?vO9vzh25dcZqrAbF8iPbDWFKnYs2ZB/SpmwfgfpWOmOPJtdorlgolZ/Yfzjn?=
 =?us-ascii?Q?kjXREZTu0mkBZsYW3Hn/P6iWEq+SyzmK85/5RhtdFoBWj5a+0ft8Zgr9ilPe?=
 =?us-ascii?Q?/lC2WBviErlhgnuM2R2G8ah4sp/vaenmwKUUxKtsEM7Iv5lv/VZuj88AsK/z?=
 =?us-ascii?Q?DmxsUJQhlkYNgJoC+AlGGSQk3ECFpiXWaENlFit5m2Dsh91/igFB7Lyx+IF0?=
 =?us-ascii?Q?TQPlg4UELoQ6fOaHmQsQvej0qwVE998qQorATRQayIHyyCbYocmZgon1pPUV?=
 =?us-ascii?Q?PEEt18ipqRfLV4mF0+4wiBdOv+sDZ1issWDUaHFsmsJ7BpuNQTlmvbbMFDK6?=
 =?us-ascii?Q?WHelKbuSF0P04nianBbLwctlzV1Tdd+18LBGq34sf1oqQ+uMrj2YnyPhOdGQ?=
 =?us-ascii?Q?JV1zI8gdYiB1Ox+cVPqZLCT5zuDq541z39IzZJjZqhrH9jJRiaZ8H/8x6teO?=
 =?us-ascii?Q?B9IonTulhR3vEO9fZjS83jEvfB+hSzpcYvtkIKH8Xj91BOCnh+8yGt5JhrW0?=
 =?us-ascii?Q?tbzlZXLk+7KiqT0sR95u/96OM28nOK+7qtmyFWS/sCZqqtj3WcQcDbp2Kc5w?=
 =?us-ascii?Q?/QgCOYHDW4dOR2ASxCB1CnPglFFi9aRy6gcj7R0tfnRlpDnI7/4Zcz9VgO39?=
 =?us-ascii?Q?WKSNXMQ4JSHqHKzN2ojyfc9NRta+Df1M+LASmXNKf3gu4Gw8GFXqsyBZQlPB?=
 =?us-ascii?Q?cGUHJftyU6g2trErzChKH4N/Ezn3q6+2qkCvFo9kspgYzt+usBWKwwb4TgEB?=
 =?us-ascii?Q?LTpFk5stSsNw/4/6YfI00NiqRFCYizG+CHTCVJUZv0JqQR6HcWF4luT6TNZk?=
 =?us-ascii?Q?Mpsa+EacHDdzlsUCjxWBbX9ZkXMGXRgGwYpBoQ9rldk8PudVAB98VIlvXGJD?=
 =?us-ascii?Q?LJpZqQvaIpKMBDeSs3kf7skqLnUVIJ2RYqGdeD3GiDBr5aUZ2C2gJ+KV11VG?=
 =?us-ascii?Q?VIbnRPFCkVBi65GJ38obvuLC3p8mtykJ7qV0Mv1+4D3IJDthT5n8AxV8/3v+?=
 =?us-ascii?Q?xw1WiBFMKXM4oiYf9kM81WrAXX7vEZr6SBR2kqF7wBzUNkdvBFpaOE4SMHRn?=
 =?us-ascii?Q?DZOXJq8uojCUp6QAa7jdequCNuW9aeBQHgv/2mXUV4HWqIuyvrpgtJjk69SM?=
 =?us-ascii?Q?NrR9rwaZFFj8UAVhnrBUsDYlVcZOwhXYVJXs8EpkIlO6BnukeJ0LEqILwqlV?=
 =?us-ascii?Q?EZORf1C0G8GJGCH9Llt70cu9xKHO5aNOqgZGEy6ifdLsJY7zbPocIo27xJFy?=
 =?us-ascii?Q?jWY6HryaXbhQBefYMAr3sXJUqhSdn8SNKpdKw9xo?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 633a0b81-c9d1-4f1b-30ea-08dabb6e7be7
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Oct 2022 18:34:02.5423
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qRs5sMRvKUdyTV7vAbhNBlSn9gSi0DYT8tO8upzdrOfWZLEl0wkfGswC0CHn3I+EMV6Te6EY/E8MKRHOBu1aBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR04MB9292
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
> Sent: Monday, October 31, 2022 12:10 PM
> To: Shenwei Wang <shenwei.wang@nxp.com>
> > +                     cbd_base =3D rxq->bd.base;
> > +                     if (bpf->prog)
> > +                             rxq->bd.ring_size =3D XDP_RX_RING_SIZE;
> > +                     else
> > +                             rxq->bd.ring_size =3D RX_RING_SIZE;
> > +                     size =3D dsize * rxq->bd.ring_size;
> > +                     cbd_base =3D (struct bufdesc *)(((void *)cbd_base=
) + size);
> > +                     rxq->bd.last =3D (struct bufdesc *)(((void
> > + *)cbd_base) - dsize);
>=20
> This does not look safe. netif_tx_disable(dev) will stop new transmission=
s, but
> the hardware can be busy receiving, DMAing frames, using the descriptors,=
 etc.
> Modifying rxq->bd.last in particular seems risky. I think you need to dis=
able the
> receiver, wait for it to indicate it really has stopped, and only then ma=
ke these
> modifications.
>=20

Sounds reasonable. How about moving the codes of updating ring size to the =
place
right after the enet reset inside the fec_restart? This should clear those =
risky corner
cases.

Thanks,
Shenwei

>         Andrew
