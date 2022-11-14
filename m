Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16C256283F1
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 16:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236842AbiKNPbc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 10:31:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236700AbiKNPb1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 10:31:27 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2081.outbound.protection.outlook.com [40.107.20.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB9A2497A;
        Mon, 14 Nov 2022 07:31:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XvmoSlVofKqv4iO9EjO+qelSzJ90fC99R6Q6B5ToZ02Twzde7u/9pComYm3aSwM7y4E0bzOSuwFZtd6u4NVHL6NHJNGUTb2TdWsy6tgQRFHj7EvDVqEUGGUOetYYSyZ7BjjoM9MyG+EljqkhuMmOCsl4OZyfrlnn1JmEvn6QeKJM+lfhUNfChgr3E/Hz+0Zgyo3ZfO9LnHigV5wirXkc8iLCg3kfqu/95zWD36VufGLkpQrml2EgYI2X0klL0xeRIdhF3DhnIZvFhoZROp9Ny8rKwQ3FCykcbyESnTxHp0kowZjTeAfTWQSW/Q19n9gYtzaJG1kxsHmsmIo8J0o96g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=onNZqgODvoS7N/S0k0vEvZp0az7Jfny1lAfVnqyMmFU=;
 b=VyfX8W7FkW6bGiOxbW4cJr2qjPiX+uQ5G1bLjWpqN3dbFZ6fQZMRWnMHXoEaJ9iEtx0kdmasKVcHm4I8wxkYxhHzir6Pm+MYbgsdh8SGIBnBA+3rqt7r9PHkVPtCPGFgta74t/jiE6Dw92kbKNqdLzNuaEp6UaNFljfwmYVRsxj67RMOmX2hACLCaAFZkyIxaPBmZYGXWJIPc59xu1MJKfZwapE+/n1VIh4KAA9iB0PRvKv6pBMXqJN2NhjrB3swNZOWfmGYxAdxJIOm6V+m9f6t7FUMEiLzbf18g2TZpTykcN1XlAAVCy8enwVTh429cF1NxvuoVSE3Vy2Qg/gmoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=onNZqgODvoS7N/S0k0vEvZp0az7Jfny1lAfVnqyMmFU=;
 b=QIbiHq4JUOZavQYsAlvJD6OS2U+63r8vgGcYq1Sav65UJAhDzDcETJIVMaYQjuAyaGvJ+uWp37pcPN2fBj4hFNGzESN+cVMXWgkANiByWtePliwT2w3eLUF6GxrSlJJ56hCtYHr48K7Fy7JI0Uq0bmNoHb+CGzNxpuWCO52CwrE=
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by PA4PR04MB7744.eurprd04.prod.outlook.com (2603:10a6:102:c9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Mon, 14 Nov
 2022 15:31:21 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::6b44:4677:ad1d:b33a]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::6b44:4677:ad1d:b33a%6]) with mapi id 15.20.5813.017; Mon, 14 Nov 2022
 15:31:21 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Wei Fang <wei.fang@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "imx@lists.linux.dev" <imx@lists.linux.dev>,
        kernel test robot <lkp@intel.com>
Subject: RE: [EXT] Re: [PATCH v3 1/1] net: fec: add xdp and page pool
 statistics
Thread-Topic: [EXT] Re: [PATCH v3 1/1] net: fec: add xdp and page pool
 statistics
Thread-Index: AQHY9eM2DcCGX+tMv0uN92sufUZdVq4+cwAAgAAQvXCAAAu7AIAAAHJg
Date:   Mon, 14 Nov 2022 15:31:20 +0000
Message-ID: <PAXPR04MB91858E0EEBE5D22EF6974E3C89059@PAXPR04MB9185.eurprd04.prod.outlook.com>
References: <20221111153505.434398-1-shenwei.wang@nxp.com>
 <20221114134542.697174-1-alexandr.lobakin@intel.com>
 <PAXPR04MB918591AA3C3A41AE794DB41489059@PAXPR04MB9185.eurprd04.prod.outlook.com>
 <20221114152736.702858-1-alexandr.lobakin@intel.com>
In-Reply-To: <20221114152736.702858-1-alexandr.lobakin@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR04MB9185:EE_|PA4PR04MB7744:EE_
x-ms-office365-filtering-correlation-id: 4ab8b58d-0ab7-4e75-5edf-08dac655480d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rAcNxajY+j084WOVlZ6sbs+TKkvs4I8LE9volHg7Q4zT8mlAqIqZja5cwr6whqu4NA0WM6yFejMHjw2s1gOZS69y7NaVC02bXB/SMmOHCRH1XFi6NAzlx4pgPZLYsKrYPJ7ZQ9zlshoJYqtCJxjAlgWhyeOpaiYYbsag/yHwFIYisVjKyibWBSSJ6via20eqD5FxC06KicJr1c28Q2q94UMtpEINP+SWhILLpBuRZZgItox+iZMYasBqcvxINIQORyEz0smMvQDmhsyVfEu1r6neVGy5/35VAARqO0/EIx47hB1MKtNuEY20zIjp6meFN7/2qyiaK/ys/68QPFDum/CnUj0XimPteiUKGUwcw4qxbTWQy75RkSGZy4FZW7yyipiOdQQlbKFgm0WkyOy/Nog0tI7MxNaavi7PxlZlOmOuf2TbJMZotDdSeSLFw0MEtPavmkHenj5WaFjVsWfpWSEundGSWQz0+myD/Pc8y/jytuNsJah2jmDzjHIMA1J02UTjZLj6EnaqUyisyoeT44bznZpJeWLwcjq4eX/BuHWFWs1LJ6zhbEnp2i+VV9/SL6CXMYFrdCW18leXxkoD1O7KJKbO2ryrmUnFeT7iYv5JkFJ/PwFpduunOpTp+vpg2QNLr4hh5G3VsNP+IsSXJf2TEH4XA6sDiC2Ktz59NtuyTgwjWYoRgt/vgF462onBTuiLcNTXPyURBXlZMUCGWTqG86Hne47M7/BuPN6Vwc7iA9nNPeFDXBOQESvYArPQkC+K44AIuPRZ7W4E+kDP4w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(346002)(366004)(39860400002)(136003)(451199015)(9686003)(7696005)(71200400001)(26005)(6506007)(478600001)(53546011)(55236004)(66446008)(66476007)(54906003)(41300700001)(66556008)(4326008)(66946007)(8676002)(64756008)(76116006)(6916009)(186003)(44832011)(316002)(83380400001)(7416002)(52536014)(55016003)(8936002)(33656002)(5660300002)(38100700002)(38070700005)(86362001)(122000001)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8hidr3wck9agXqKOY0PeWPPBbSovXSLQNjHBvXC5uz7ut4LnJ+VWxpicrZ9U?=
 =?us-ascii?Q?wDpbwxmBxYuq9F/crZNYK1Lm8v76uhnCCVpRbODBIkuU/2LkvtxRUj0sLpQH?=
 =?us-ascii?Q?RGKEE6JMaKC+00UcoOXm/zTf/sgR+bNoJkhUgPXNcL48+PKPvb2hP6xMLzFf?=
 =?us-ascii?Q?sdrIlM4tw1p2qt/k6Rxem5iSBSiKfNf61FXi6TskO2jOs/72yyWjSBh138Sz?=
 =?us-ascii?Q?k6SHS6N/xxvMstok4kpnYMO7plcPSmj6T1VBM69wuUK2XiwJLIN0TdDhzwHo?=
 =?us-ascii?Q?j6zmak+/KDZrZWBkhe153pqJjeUaoNV/02wjgD9yv/LyrUfmVULxcuF1cqDu?=
 =?us-ascii?Q?bk4HVyQKb0gXDDFI2Boz9jXk7fig7xAyQkKIIJBrpL/alRl7bT0o7m8BsKap?=
 =?us-ascii?Q?bkYfdCUyFQgNiJ2BrtqKANgHWkCmyu9+nZzTnj4rgQyCeMiJu9wEqhE0avvp?=
 =?us-ascii?Q?05m3R5tvZyMl4QxhIM5VIpdgnTOHUqSQ1KnBzpfYpOum6oSicKHEAKodp3nv?=
 =?us-ascii?Q?t06KAl9spO+p2kM7u8Xa2sUfe6+VgZhYP1u2ushlQOK1RQZejXllcR3ikm5f?=
 =?us-ascii?Q?guZVlCvQrhpg0xyBZ8V56v6FrUTzCJx+vRO5GJjBaFEohPYGG5oqQyeVWL+r?=
 =?us-ascii?Q?0aqWoM/uj+xQnB2pXhmlm8dH7xu+cyei7841TSP4YmbAtywPeyTCAgOdhnpE?=
 =?us-ascii?Q?ZWKW5rigTeS/uNuHU0MlikPcfyjB4O7nEXLfxdQllzQAVNTsDPsROSDGS6iK?=
 =?us-ascii?Q?EiKgR1VsDOs+6f6CFyg58TNoGpaF+nw2dKV0bRlUwQ6YUA5XSHvR5a6GQrvf?=
 =?us-ascii?Q?6p16RTakulBvuPG6gkYUcavvjWBmxPJjV5rScPI7VjNppI8SlFgyFMn0lW/n?=
 =?us-ascii?Q?GVjXg6e/d+uMNEmvFRzaUTorYRwDT03xE5ePh4r4WZfw2PhfgSmiNgOSBRGf?=
 =?us-ascii?Q?w2yoV2WYo2xRAZ85TXEwmUkYc8+y/Si70eyacE335Gh39rM4KeO7DJ0p64hF?=
 =?us-ascii?Q?a/TFSny4aGyaJJHtUzoqMEFcknGaLq4RYRIon/XaN34J+C1rNTl7vAx9YeBC?=
 =?us-ascii?Q?f1au2dmZ4CM98WtUhRKycmWCuaJrXSBPmKfL7CB/P4eVBjak5Zn0vVYJgC6Q?=
 =?us-ascii?Q?GswBpdQJ8UFa8xcgkzBK/gcF7U/n5EKfGFUKUOYVuaT8CMb2NGwD8yDwtTAj?=
 =?us-ascii?Q?LUyCdmJycKAXp9rXVZTkuySmzjbQxBfVBW1GDCRfVC+JMxCwthFrhWXKWvvI?=
 =?us-ascii?Q?0jPzT/V7yAJA4GZSOijt2kiREQ7kDwVJcWtGg+05Q+PR+CJaGVt8f53tIbLx?=
 =?us-ascii?Q?lQ6F0ZZg/twE+2Jnj+7jzzfzgNsyij3+60C7gKQ2nBFiYz4hrTzLeSKmIscQ?=
 =?us-ascii?Q?UwiorEP8U0eggPMSGxrrMNXhCLBj/xMEzAuo2g/10zEtL93YNfK5Z1BPAPPZ?=
 =?us-ascii?Q?M7PVxkCCyi/UxGEaNpTDdbB62efG+Eb6wI443xXs4I81A5rkWD2aLCEeUBY+?=
 =?us-ascii?Q?2MCgbFKAjCFu+G5+NvC8r2fuUQPTJ1xM6+sdp6SEJE0a9eYSKoF8VSvhqgNE?=
 =?us-ascii?Q?GwbeCYQu27IQW/gDl85h2NUPs1UuU+hTbyS6ysqZ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ab8b58d-0ab7-4e75-5edf-08dac655480d
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2022 15:31:20.9077
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Jz8TnW7+A1e9MlM+KpXfXwz1gCskdlA3p6nT1HQLAK8IfP/lNqBe+TMoOz8r7Bo+OKhF1EOUNc00xceiaN6BAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7744
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
> Sent: Monday, November 14, 2022 9:28 AM
> To: Shenwei Wang <shenwei.wang@nxp.com>
> Cc: Alexander Lobakin <alexandr.lobakin@intel.com>; David S. Miller
> <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>; Jakub
> Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; Alexei
> Starovoitov <ast@kernel.org>; Daniel Borkmann <daniel@iogearbox.net>;
> Jesper Dangaard Brouer <hawk@kernel.org>; John Fastabend
> <john.fastabend@gmail.com>; Wei Fang <wei.fang@nxp.com>;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; imx@lists.linux.dev=
;
> kernel test robot <lkp@intel.com>
> > > <daniel@iogearbox.net>;
> > >> @@ -29,6 +29,7 @@ config FEC
> > >>       select CRC32
> > >>       select PHYLIB
> > >>       select PAGE_POOL
> > >> +     select PAGE_POOL_STATS
> > >
> > > Drivers should never select PAGE_POOL_STATS. This Kconfig option was
> > > made to allow user to choose whether he wants stats or better
> > > performance on slower systems. It's pure user choice, if something
> > > doesn't build or link, it must be guarded with
> IS_ENABLED(CONFIG_PAGE_POOL_STATS).
> >
> > As the PAGE_POOL_STATS is becoming the infrastructure codes for many
> > drivers, it is redundant for every driver to implement the stub
> > function in case it is not selected. These stub functions should be pro=
vided by
> PAGE_POOL_STATS itself if the option is not selected.
>=20
> Correct, but I think you added 'select PAGE_POOL_STATS' due to some build
> issues on PPC64, or not? So if there are any when !PAGE_POOL_STATS, it's
> always better to handle this at the Page Pool API level in a separate pat=
ch.

Yes, the 'select PAGE_POOL_STATS' was added because of the building failure
found on PPC64 platform.

Thanks,
Shenwei

>=20
> >
> > >
> > >>       imply NET_SELFTESTS
> > >>       help
> > >>         Say Y here if you want to use the built-in 10/100 Fast
>=20
> Thanks,
> Olek
