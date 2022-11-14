Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7296628B38
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 22:17:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237603AbiKNVRz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 16:17:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235636AbiKNVRx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 16:17:53 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60083.outbound.protection.outlook.com [40.107.6.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D49A464;
        Mon, 14 Nov 2022 13:17:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L4smPb/uQOrtCx8+9d8djXxbO31XvJ85+TacfDOXTIvhOp+8U2ob7oa0My1+1yXZ0K6txBa71KtU/Xb/LUVTu40W4uOC7ONou9aVo4wb91Yxu8Vl9Do08eEak0Bl5871MmxVKe7ZXjrkDlEzrnoIVUgn/Ys+DECJDsGOCA9duls2UzBbgMqXiyuPglr6zl9TquVAf16OA+4/lDzowU6mLsJljmiXNDrYwYo/xzATQmPX1bhwBJp8Jzy55wxeAeE9sKWOholmRCl4C9mxlDiWEgnpGDH0V3UtvDOEV5u+SW6sPFiQhz5WOTP5j+GCV1IAw36dUWYP0ccQYZ60YgG+Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OHt7h+E1hWnXHSKntySn/GSPSjQBzanNxSdYPWvlQGw=;
 b=UQAvFjKEx00zvR/0TjiO2PTyucOLLwVgaqWoEohgDs+z41gdZOBp55XXLUGzdahTVnnshJyMF24NSiusZSfy0Wq0v4ySIp+ylYOt3+sWf8XLKtwzZyCB3dD3W/aHtuu6I2TKj9jLE45HfBNZowYnJ89X20CoAwcOzGT3Zm7+PVuxwInxOqHQUPKrYuCeSIPsx9SDq1/mfjhi6RMjT9h1WaRa+GEIWmOo+hhvFLOpG2zfHDzAwYcdu26M3pSFgNCi1s7Uo3t8hbT+gpR9YIWciza3eyKsR6shJvedvLAjq5jD/7jHTkAgwYN7vKg7e+T+xRWV/NBofeGKwFqnCpFpcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OHt7h+E1hWnXHSKntySn/GSPSjQBzanNxSdYPWvlQGw=;
 b=RcTPWbDOs9wWc4U045EMkKfwamPzdrJir2oFa5UrUNnEpDA+O6S9NndSvG+7QMgCh6Fsnppx8Oqao3nmqUzO/HyQ4HiUqkQoOeqm3QWACDknacb+bZdAzLPu+RCFXDc61S2Mf2pUY4frs+h189juYtuzDBgdzj622BLDpto7DLs=
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by PA4PR04MB9296.eurprd04.prod.outlook.com (2603:10a6:102:2a7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Mon, 14 Nov
 2022 21:17:49 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::6b44:4677:ad1d:b33a]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::6b44:4677:ad1d:b33a%6]) with mapi id 15.20.5813.018; Mon, 14 Nov 2022
 21:17:49 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
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
Thread-Index: AQHY9eM2DcCGX+tMv0uN92sufUZdVq4+cwAAgAAGTYCAAA76UIAABgiAgABeOBA=
Date:   Mon, 14 Nov 2022 21:17:48 +0000
Message-ID: <PAXPR04MB918589D35F8B10307D4D430E89059@PAXPR04MB9185.eurprd04.prod.outlook.com>
References: <20221111153505.434398-1-shenwei.wang@nxp.com>
 <20221114134542.697174-1-alexandr.lobakin@intel.com>
 <Y3JLz1niXbdVbRH9@lunn.ch>
 <PAXPR04MB91853D935E363E8A7E3ED7BF89059@PAXPR04MB9185.eurprd04.prod.outlook.com>
 <20221114152327.702592-1-alexandr.lobakin@intel.com>
In-Reply-To: <20221114152327.702592-1-alexandr.lobakin@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR04MB9185:EE_|PA4PR04MB9296:EE_
x-ms-office365-filtering-correlation-id: 9ebc835c-9c10-4a21-5829-08dac685aed0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eRJ40Nuu79MXIIzj9jc+lwfOK2uEghfK1zWe4BQIbNiGN81CIZP3BSHzyvqVg7qXXnvDP5I2EN67RLyJbFt2oMW8Ykd0enH+MtcxqY4ip0ZlzWO6OrbPjzyVRrs5aqQZ1QFlBk4RtCsobFSCv1xh18e7tjUnpcgFXlwT2CKwOfI40ybEdgubjBGHU9USNlIaAb8amLSddSlroNXbXQlRJiGLh5VMKBaootXhjNSOYS/DzB7hBbF0WQ8pYwVrkTvzs8tFPBCuigT0WlJMNqslySV8fEIjvFyUuszI8EZkv+C8fzNbZ8SAZE8N0fOQM+4jq9f4pXzWwDnY9N4/NrKzo6cnVqumzN16hmCz4qJhGQ84iFMtKd5EHdvLy9VsHuGWhEbZjIp5hpodcIjy6cya1Z1yNCVqcGfmp/YKOkkvSa7kMqAsS7NM8wz9aikHJY8kVkNiqk/xThvAUzd79E/emaQRDfV4/cXtwtmvCzj/x88xqBe76qSeYEcIKJkQr4dh8wXE0Bdi60x11Mo3HbMcrkVYhYrI0D98ch8Md42c+giQzSN/jtQFbf6Yzq69UsddHNAmbRPVYbe9FAoYWzjXVW5BgH41uE/es5sETdQNq7fm8qNwC9MrRTN//1wWrogPy2k4UEV9YkSnJPakSFdFiZflOujFCzABOArRKwxXCkzGYvrjpXrr6kPdLeTF0CQp82+mFMIF5l444TF+r65Xc0hfSkEe/AzYdHZBcdJf8YWU9gmk0+pxetAR89qbaH9sBYvJJ/xRxmfGN8m0r8RSAw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(39860400002)(366004)(136003)(346002)(451199015)(52536014)(8676002)(186003)(66946007)(316002)(66556008)(9686003)(26005)(76116006)(55236004)(66446008)(64756008)(4326008)(66476007)(41300700001)(55016003)(44832011)(53546011)(7416002)(5660300002)(8936002)(122000001)(38100700002)(86362001)(83380400001)(2906002)(33656002)(71200400001)(478600001)(38070700005)(6916009)(54906003)(6506007)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xBFHl+V1G4L9DZ9coIzi7w434oYUUNg3lfCQsrDu1DOklYp6qe8GAW+tKnzg?=
 =?us-ascii?Q?+acnuQlkdoXIYFUk7xvdW29t2h54lcFCI17A88Ns2ruUak0oQp/dCbR+MAuQ?=
 =?us-ascii?Q?y4EMHHmUHEbe1jgwWteerDGwqw+ygjXIJD5mTuSb608lNHocbXd4v3E87wFO?=
 =?us-ascii?Q?dWYEUAkyMdhG9eH1Nkwpg7/Lgo4F6MV3/LC0pQanGMbs9DWs+C7n+RH6u+8j?=
 =?us-ascii?Q?5Y/fiOAdkRNB0AS8p2GjuoaiZ9ByRmQfpBVrNtii3txupFE/os5HacDWpTYJ?=
 =?us-ascii?Q?Ozjjev77tVEiiMC0lwkVWk4i5Qya7uvXBAcvRPXZ5LJCZHPdD4GetaBCfx+I?=
 =?us-ascii?Q?ufKwOtx+nftAjrIQaxz+6+Sren3Xy2aCS+3wioWtc+s4WB/S0KW3uuhE4T6R?=
 =?us-ascii?Q?9qF7S8QQm1IYTGVTDoreAFT47vxnK8+ysH1K/DGo4iEiD+MObqPjS6Kv/8lp?=
 =?us-ascii?Q?8DwKKPIiy1SJeuP/KcLyc75cJ4cavOljhT5y9Va6EyPtDTh8hlPWe/BHV6ci?=
 =?us-ascii?Q?R5i0D0qjhFWTu9qzKmhLu8EA71A/2auAtrWvkeYTUeksI7ci7cib4fozyrGF?=
 =?us-ascii?Q?4HYg827Gx0kSm9sNFsMd4IgkLVVd1f5H5vWshH7gqB93BYOITwqMGSXMfFXD?=
 =?us-ascii?Q?EJIK1HK1uyzFlbsWneZgkMedQ78UT47vvlM6x7Dho9IthrBP6m4NZckbEa99?=
 =?us-ascii?Q?4zt69SGgYX04aJlLSac9UjfTGsRi15NofClfzwYcCUoQvRMCzQOoDR8ko+MW?=
 =?us-ascii?Q?sjce99NVJoCPcHk2WSBEMDzXSt9W7MKhxizEXg0qmxuRDlgFnpKIHLwyImeY?=
 =?us-ascii?Q?uVzwXabqgj7aViYIGRiFshDWn5aunYfPZIqbx84YMYFTLTKnniGK7O2loijQ?=
 =?us-ascii?Q?b2rbLQRcenbdomV4fO6gfMSIbYHel/WnrUKexb2uydI6lACFGV/doaxNzxep?=
 =?us-ascii?Q?m3aP8+BPbsEMx8eg9XyQkuIBNKL2jKAyrjflIRzKGO1VPO6cxYaU+N529Cop?=
 =?us-ascii?Q?s7nT1cq6luRV0FIvvdfuY6tH2G+OEhHQzs/X2jF5eAC1KNE/OWxOjtvdQAho?=
 =?us-ascii?Q?yoM7rcm2T8Jg/8v7XYTlB8S6v6SuvtkYRoIn9s7VtJWOVqR0EcVwmTZi9Hv0?=
 =?us-ascii?Q?3KfUGHSJcp3IgMp2Bm7Sh+Tl10LLEhhfyk8KZTQVnWIiVy1Xtu2eNJxrDi2Z?=
 =?us-ascii?Q?oxrFht0wypMuR+rZxRX/awp4DUYGJG/YjlaPneSKxPG8ysWz6AE677xxWgA6?=
 =?us-ascii?Q?bZgxzJlI5AXbGrR1odECbXCWBhpI2Pp1scJNosc3E02Y3BlezFLDC1180r8c?=
 =?us-ascii?Q?kdfe3TNAsUH8hXIqM9TQ67JTK3MPzqrZjIwMwbiEcvDgql7vwjma2BHMwzu/?=
 =?us-ascii?Q?MYy/uQsbVJpHR1xUwKYboXDoKH64+qR9gvv8CtJWEe23Pr44A8oif4SbsNyr?=
 =?us-ascii?Q?F8wIVWNJuWOUoZTzHF2be9jj59kqQQeqOO2dJ3zVyRtVqVSs1z9ICCd194Pn?=
 =?us-ascii?Q?t/Q+b7vtYQv+YaGVln5nt07ZJYlxZlD7Ga0Vdh1r9YUPZfkH8vgMQfF6gLM4?=
 =?us-ascii?Q?iK+sed8v1poJEN+N1QIoDETWA63mEoiV5yivHBK0?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ebc835c-9c10-4a21-5829-08dac685aed0
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2022 21:17:49.1092
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eCaMk4etGe/ezQyQBvPmvaRfnN5jNPHwQCXyozec7OEASTtkgQvDm3JkDBBP2TyJ6XD54iB2ThENavVsbhOvsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB9296
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
> Sent: Monday, November 14, 2022 9:23 AM
> To: Shenwei Wang <shenwei.wang@nxp.com>
> Cc: Alexander Lobakin <alexandr.lobakin@intel.com>; Andrew Lunn
> <andrew@lunn.ch>; David S. Miller <davem@davemloft.net>; Eric Dumazet
> <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni
> <pabeni@redhat.com>; Alexei Starovoitov <ast@kernel.org>; Daniel Borkmann
> <daniel@iogearbox.net>; Jesper Dangaard Brouer <hawk@kernel.org>; John
> Fastabend <john.fastabend@gmail.com>; Wei Fang <wei.fang@nxp.com>;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; imx@lists.linux.dev=
;
> kernel test robot <lkp@intel.com>
> Subject: [EXT] Re: [PATCH v3 1/1] net: fec: add xdp and page pool statist=
ics
>=20
> Caution: EXT Email
>=20
> From: Shenwei Wang <shenwei.wang@nxp.com>
> Date: Mon, 14 Nov 2022 15:06:04 +0000
>=20
> > > -----Original Message-----
> > > From: Andrew Lunn <andrew@lunn.ch>
> > > Sent: Monday, November 14, 2022 8:08 AM
> > > To: Alexander Lobakin <alexandr.lobakin@intel.com>
> > > Cc: Shenwei Wang <shenwei.wang@nxp.com>; David S. Miller
> > > <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>; Jakub
> > > Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; Alexei
> > > Starovoitov <ast@kernel.org>; Daniel Borkmann
> > > <daniel@iogearbox.net>; Jesper Dangaard Brouer <hawk@kernel.org>;
> > > John Fastabend <john.fastabend@gmail.com>; Wei Fang
> > > <wei.fang@nxp.com>; netdev@vger.kernel.org;
> > > linux-kernel@vger.kernel.org; imx@lists.linux.dev; kernel test robot
> > > <lkp@intel.com>
> > > Subject: [EXT] Re: [PATCH v3 1/1] net: fec: add xdp and page pool
> > > statistics
> > >
> > > Caution: EXT Email
> > >
> > >> Drivers should never select PAGE_POOL_STATS. This Kconfig option
> > >> was made to allow user to choose whether he wants stats or better
> > >> performance on slower systems. It's pure user choice, if something
> > >> doesn't build or link, it must be guarded with
> > >> IS_ENABLED(CONFIG_PAGE_POOL_STATS).
> > >
> > > Given how simple the API is, and the stubs for when
> > > CONFIG_PAGE_POOL_STATS is disabled, i doubt there is any need for the
> driver to do anything.
> > >
> > >>>     struct page_pool *page_pool;
> > >>>     struct xdp_rxq_info xdp_rxq;
> > >>> +   u32 stats[XDP_STATS_TOTAL];
> > >>
> > >> Still not convinced it is okay to deliberately provoke overflows
> > >> here, maybe we need some more reviewers to help us agree on what is
> better?
> > >
> > > You will find that many embedded drivers only have 32 bit hardware
> > > stats and do wrap around. And the hardware does not have atomic read
> > > and clear so you can accumulate into a u64. The FEC is from the
> > > times of MIB 2 ifTable, which only requires 32 bit counters. ifXtable=
 is
> modern compared to the FEC.
> > >
> > > Software counters like this are a different matter. The overhead of
> > > a
> > > u64 on a 32 bit system is probably in the noise, so i think there is
> > > strong argument for using u64.
> >
> > If it is required to support u64 counters, the code logic need to
> > change to record the counter locally per packet, and then update the
> > counters for the fec instance when the napi receive loop is complete.
> > In this way we can reduce the performance overhead.
>=20
> That's how it is usually done in the drivers. You put u32 counters on the=
 stack,
> it's impossible to overflow them in just one NAPI poll cycle. Then, after=
 you're
> done with processing descriptors, you just increment the 64-bit on-ring c=
ounters
> at once.
>=20

Did some testing with the atomic64_t counter, with the following codes to u=
pdate
the u64 counter in the end of every NAPI poll cycle.

@@ -1764,7 +1768,13 @@ fec_enet_rx_queue(struct net_device *ndev, int budge=
t, u16 queue_id)
=20
        if (xdp_result & FEC_ENET_XDP_REDIR)
                xdp_do_flush_map();
+#if 1
+       if (xdp_prog) {
+               int i;
+               for(i =3D 0; i < XDP_STATS_TOTAL; i++)
+                       atomic64_add(xdp_stats[i], &rxq->stats[i]);
+       }
+#endif
        return pkt_received;
 }

With the codes above, the testing result is below:
root@imx8qxpc0mek:~/bpf# ./xdpsock -i eth0
 sock0@eth0:0 rxdrop xdp-drv
                   pps            pkts           1.00
rx                 349399         1035008
tx                 0              0

 sock0@eth0:0 rxdrop xdp-drv
                   pps            pkts           1.00
rx                 349407         1384640
tx                 0              0

Without  the atomic_add codes above, the testing result is below:
root@imx8qxpc0mek:~/bpf# ./xdpsock -i eth0
 sock0@eth0:0 rxdrop xdp-drv
                   pps            pkts           1.00
rx                 350109         1989130
tx                 0              0

 sock0@eth0:0 rxdrop xdp-drv
                   pps            pkts           1.00
rx                 350425         2339786
tx                 0              0

And regarding the u32 counter solution, the testing result is below:
   root@imx8qxpc0mek:~/bpf# ./xdpsock -i eth0
     sock0@eth0:0 rxdrop xdp-drv
                       pps            pkts           1.00
    rx                 361347         2637796
    tx                 0              0

There are about 10K pkts/s difference here. Do we really want the u64 count=
ers?

Regards,
Shenwei

> >
> > Thanks,
> > Shenwei
> >
> > >
> > >        Andrew
>=20
> Thanks,
> Olek
