Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8DC62C341
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 17:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233586AbiKPQAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 11:00:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232801AbiKPQAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 11:00:12 -0500
Received: from EUR03-VI1-obe.outbound.protection.outlook.com (mail-vi1eur03on2067.outbound.protection.outlook.com [40.107.103.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 040AE4298A;
        Wed, 16 Nov 2022 08:00:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CPYBhMi5+MTeIEgpmrISsH7qOxqhzi1PKpzOUU1gACEQI+gqEZDrnsp73SN917OutG9YbbaoTSkSn6vKHwMmUwHlhcXBiV0t8BBihQy2BQjrTUTM7VO2ES/fMGIn454oaBq1WxUG0ySnBwO+g7RVbDhJdaRy6ZQc3IPo3aL8qE9WgriEMDftnB+aRjxn+EKnfSH2waTPPukPVgSYMD8GTiG/kNLqLDjvcJ0WmWINk+LCeUXryKs0XNUpYByvCkpfPy+Oo/c9fw4ZZ5MB6tSkllIw+j0iQI26h2JlME+VDkLH2TT0Kq2aeKx1yUEXQMasm/5fnb+5LwfPXZv3Fpebug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IALcJ7R6fSLPeTDRDodQ+BPFvBPA48JD9NTNlPlHXKM=;
 b=jtFEVQqp0xa1JSP+zF7bgw+Jt574QkMmJoyZzsqXk0V6JGu2jwGe6BlKeZd6ACCd76fAOnwFV88IrCYJ6gCfJg5eBVMEZWzczrXQvwkTDHrfLfWum0ArXUk97mxTBW4ArgrLuPCfKqSRUxEDMEuMNdSvzrJJIYqsnF/0qwrp8O/2stbkKP6wlLANXS+yVDpcABjS0oR5AgRmtEu4kBRE9y/klfhkgdN4bknstDQx2g1/25q/vHejO05HmU5fjSaSU0iry9pF17eMZuQiqyQ2pZiyFNgk8h1JXYa2W13+vbCFt5+M4aumLOgALFo0KkJiNenR/YbgQcRaTSqnTsPeaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IALcJ7R6fSLPeTDRDodQ+BPFvBPA48JD9NTNlPlHXKM=;
 b=T+X/krCO6TM3xxmpbVgT3dlg1m3EMnVjKU1Y5jxCd+GzcdGjtPusIYSDYG9ZmEsp7gz+Z4rhxgU85N5PvVaeB56T3aKWosrGaz1A/TDvN3JKU3Q2KmEwoQquIqn1er+HEcuOYwY8AepFdD8W0Xtb3ibir9vEno6DDIxv3u/UHK8=
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by AS8PR04MB8771.eurprd04.prod.outlook.com (2603:10a6:20b:42c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Wed, 16 Nov
 2022 16:00:08 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::6b44:4677:ad1d:b33a]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::6b44:4677:ad1d:b33a%6]) with mapi id 15.20.5813.019; Wed, 16 Nov 2022
 16:00:08 +0000
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
Thread-Index: AQHY9eM2DcCGX+tMv0uN92sufUZdVq4+cwAAgAAGTYCAAA76UIAABgiAgABeOBCAAriEAIAAFxUQ
Date:   Wed, 16 Nov 2022 16:00:08 +0000
Message-ID: <PAXPR04MB9185FA86AEAF112D06132CC689079@PAXPR04MB9185.eurprd04.prod.outlook.com>
References: <20221111153505.434398-1-shenwei.wang@nxp.com>
 <20221114134542.697174-1-alexandr.lobakin@intel.com>
 <Y3JLz1niXbdVbRH9@lunn.ch>
 <PAXPR04MB91853D935E363E8A7E3ED7BF89059@PAXPR04MB9185.eurprd04.prod.outlook.com>
 <20221114152327.702592-1-alexandr.lobakin@intel.com>
 <PAXPR04MB918589D35F8B10307D4D430E89059@PAXPR04MB9185.eurprd04.prod.outlook.com>
 <20221116143336.3385874-1-alexandr.lobakin@intel.com>
In-Reply-To: <20221116143336.3385874-1-alexandr.lobakin@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR04MB9185:EE_|AS8PR04MB8771:EE_
x-ms-office365-filtering-correlation-id: 833faaa0-05dc-438c-174e-08dac7eba281
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +S748ODeNqLovMK3sQlJLpna7ZcNnhrup+NGvka+aUZx6QaPQoWUnzkYsG3ugKdQr4OnnUockMCuBKvTr/08/OW6UmMJknoliaVeqat3y/Q0ruMyK1ssJugXPdSlmG6NrJM272s5b6rYq5prBOHh9cH9EW7iAJxtkZLswG66s8rJXgK07J61htyFZehfoMS2hRnxBoIBIpqzs17tjRUC7oLzFA2G40GeUHFOfS0ncwcMInC2R8SNhzyHgFhpST8c+AP2KXSrwaIh8dgVAgJY5g/fxcrRM56VnJ49z1xO/1w0V0AJmad+B9AyqR7Fxpoh28lDI+UZbFUOGWMXhC8oadrOe3eGVAVY5Igvi5rxUeqB9uGE3U8uAAzk11biXlfUsNGZSDNMgu1My3XIEJfs5n8sYgd8nDx7r+pG1FYxkjBFTxvXWhilMecsB1IGL1NX7i9ltc4ePXSRD43iukK56XKQzk/7Ar5HJP4Uvuyaz7AxzxRk0dkEfv+3b9hwFHCV5osfeo6tZWVx9a/KhysyRRKhgd/rfC5kDZoOvaCSwSLXA6ozu7yg1yOeoe0CXS/ghARkfdqqHIVknAgt4lnPDk3JlvhIQJK1QxNvG9DnRb8Tfe1jLtaKnt8B2/Wi9sbJXeslKW9sKhK8ltzU+N871f2F+O6eC8V1qYUikMNRJLgXcj7ebmKyKkXZBJvr7qlb1CzFs6k0PrUZoYeSJPe9wA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(366004)(346002)(376002)(39860400002)(451199015)(2906002)(38100700002)(7416002)(8936002)(52536014)(44832011)(55016003)(122000001)(5660300002)(38070700005)(66476007)(66946007)(9686003)(76116006)(66556008)(8676002)(41300700001)(4326008)(7696005)(64756008)(66446008)(6506007)(26005)(53546011)(186003)(86362001)(6916009)(54906003)(45080400002)(83380400001)(33656002)(55236004)(966005)(478600001)(316002)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?56EgFcZvNamy1GeZSHSWtPMmawF+OBxXqP4LIXlnz9II0mNCS0JEmevJF5aL?=
 =?us-ascii?Q?6mrgebwvoncZ6VYaFzCdUuzOg6802s6Dcy7x015g09MWqCpNkk8tvQj3MN0F?=
 =?us-ascii?Q?iGGKbZubflwTTKYPrieuWKZaANnAqreMT6FJXlTnTZZTV6PbSgRImQkqxkD9?=
 =?us-ascii?Q?5idACVYzOYbq0Uuk1LG2EBh8lvrApGZxGmkArkc2+swWk0yQGJ8oDjiyIoDP?=
 =?us-ascii?Q?zlHZTF06KVD3HB4X0CzUQkJaxAk2z6BJDDimIUaKy8gNXdz8FPrXawjrdrXR?=
 =?us-ascii?Q?oRekp+/piUMvfJeKTu3L8rWNjRnMynEu6UQzavddnwixwwThSLS/W4bAAY68?=
 =?us-ascii?Q?RUKnTzdBSxzQxke9Do+GFfT7e3Ql19QsLtFbFAZxsNJ5hiQDFtGLKEbrgnf0?=
 =?us-ascii?Q?XjxbD1Y8oA2gHaJUDT7T77JwGGh3L4A7kfJJRMjixXOD1N1AeSI72K+VReOM?=
 =?us-ascii?Q?8kUM79UyL7/vi4Lgu04afw7l2nXVC3qsojYXRxAupUjnjNC83K3yJXdxF7by?=
 =?us-ascii?Q?RADmBLZqHDH6I+qV2BbyEy/jwX9wD/QaU6Q/dt1Ms6jq9qQUZZZ7kMPcRNG+?=
 =?us-ascii?Q?ktrMBS017ETTKDAt7iGhgGnYo9e7fc9gxar7zpkTapEGbkTTuP0RbU+cBTkT?=
 =?us-ascii?Q?jVL6nqZAF2cckxCKoi5ztbZzNNEtLi5Ygszut2IUEfGJaknwjkHdiuGoHVJ/?=
 =?us-ascii?Q?sg9jEJ5gu3fG/EWjlNI7zXyQU/ks7kjoeNVNXlJQd4JYRD0oKNeRhhHs9gcS?=
 =?us-ascii?Q?xXINSlXOKAS9CqO/40EzJn6V2geOwgMSYOhv6T/5tP5m9AaPWdLsdE1WAFh6?=
 =?us-ascii?Q?dU/pH/awMdwETj17cE6XzGdq5jtjeInw9Yx8ofJxgE0Vie5o4BtPWBz1wlwJ?=
 =?us-ascii?Q?2csXqX0BsNT9jbN648WmBq2+JPar46jIYaOaAOP5DoWjbCqasJBH9ncoYWbl?=
 =?us-ascii?Q?EIcD6T6bUUGHKePSlN3J35xZbCexWmQBDUNJuKn7OEuydQ6ST6mncvqUj8VC?=
 =?us-ascii?Q?EwyWYfoMIxaPN7om4tKJWkxM37b3GcNRA5ome/0YauFpAq88z9j15kt1stpI?=
 =?us-ascii?Q?YvkeA764jf9RIzqKvzs/6RcJmYtUBWTeRbYzdQi9PztTMrF04PkpU+qMJQ/y?=
 =?us-ascii?Q?FMRSbtdd3WIOSi5J68oohYVuWW8rocUCcX4A25EBWtkQAgExOoZZ2oBnj+kP?=
 =?us-ascii?Q?YZ5b7QnTaUutE8sWUxYvYO+UdNTGdJO24hA97Ruwg2k22FjqfAHGPs/5y4T3?=
 =?us-ascii?Q?+zM4lm5rT/EXgaOyJ2mX5r5k7jdxi9xAytlx5ihL/IepZhGxBAE7nJg75JCj?=
 =?us-ascii?Q?hdXefDsDsWQeQBrC1Pa5GohVTyXcs3UZerrJ94YN5GpVMyG5t5lFfdBCNBXa?=
 =?us-ascii?Q?1DoSKxY3UtXFHLisk0FGMffFjDqYYDCFQdvqeg1JMRZaHk1rF9HgkiitQkNR?=
 =?us-ascii?Q?MXsDk9F7Cf9zYYnd9l/LE4zq/VEzDyHVi+IU8S0od5fQ9tfBVRF4lgLNKXh4?=
 =?us-ascii?Q?Y7NRgAz9UtlLUQTV0mQK/0/tmKRfIPS5FaoUhlJVbLwy2/8oBsESq4fmm0kr?=
 =?us-ascii?Q?rlUIDrLvMTkntIECBO43FKHbOqm7np+HR/ncyjyp?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 833faaa0-05dc-438c-174e-08dac7eba281
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Nov 2022 16:00:08.3332
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /7Ck35pjVfGAkdumCO10gN66V/9htPQNpPfDLPY9+52fX5YrebQQLwwLMuZ/dE1xzDf4VQf4XKXp9iggCWFUqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8771
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
> Sent: Wednesday, November 16, 2022 8:34 AM
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
> Date: Mon, 14 Nov 2022 21:17:48 +0000
>=20
> > > -----Original Message-----
> > > From: Alexander Lobakin <alexandr.lobakin@intel.com>
> > > Sent: Monday, November 14, 2022 9:23 AM
> > > To: Shenwei Wang <shenwei.wang@nxp.com>
> > > Cc: Alexander Lobakin <alexandr.lobakin@intel.com>; Andrew Lunn
> > > <andrew@lunn.ch>; David S. Miller <davem@davemloft.net>; Eric
> > > Dumazet <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>;
> > > Paolo Abeni <pabeni@redhat.com>; Alexei Starovoitov
> > > <ast@kernel.org>; Daniel Borkmann <daniel@iogearbox.net>; Jesper
> > > Dangaard Brouer <hawk@kernel.org>; John Fastabend
> > > <john.fastabend@gmail.com>; Wei Fang <wei.fang@nxp.com>;
> > > netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> > > imx@lists.linux.dev; kernel test robot <lkp@intel.com>
> > > Subject: [EXT] Re: [PATCH v3 1/1] net: fec: add xdp and page pool
> > > statistics
>=20
> [...]
>=20
> > Did some testing with the atomic64_t counter, with the following codes
> > to update the u64 counter in the end of every NAPI poll cycle.
> >
> > @@ -1764,7 +1768,13 @@ fec_enet_rx_queue(struct net_device *ndev, int
> > budget, u16 queue_id)
> >
> >         if (xdp_result & FEC_ENET_XDP_REDIR)
> >                 xdp_do_flush_map();
> > +#if 1
> > +       if (xdp_prog) {
> > +               int i;
> > +               for(i =3D 0; i < XDP_STATS_TOTAL; i++)
> > +                       atomic64_add(xdp_stats[i], &rxq->stats[i]);
> > +       }
> > +#endif
> >         return pkt_received;
> >  }
> >
> > With the codes above, the testing result is below:
> > root@imx8qxpc0mek:~/bpf# ./xdpsock -i eth0
> >  sock0@eth0:0 rxdrop xdp-drv
> >                    pps            pkts           1.00
> > rx                 349399         1035008
> > tx                 0              0
> >
> >  sock0@eth0:0 rxdrop xdp-drv
> >                    pps            pkts           1.00
> > rx                 349407         1384640
> > tx                 0              0
> >
> > Without  the atomic_add codes above, the testing result is below:
> > root@imx8qxpc0mek:~/bpf# ./xdpsock -i eth0
> >  sock0@eth0:0 rxdrop xdp-drv
> >                    pps            pkts           1.00
> > rx                 350109         1989130
> > tx                 0              0
> >
> >  sock0@eth0:0 rxdrop xdp-drv
> >                    pps            pkts           1.00
> > rx                 350425         2339786
> > tx                 0              0
> >
> > And regarding the u32 counter solution, the testing result is below:
> >    root@imx8qxpc0mek:~/bpf# ./xdpsock -i eth0
> >      sock0@eth0:0 rxdrop xdp-drv
> >                        pps            pkts           1.00
> >     rx                 361347         2637796
> >     tx                 0              0
> >
> > There are about 10K pkts/s difference here. Do we really want the u64
> counters?
>=20
> Where did those atomic64_t come from? u64_stats_t use either plain
> u64 for 32-bit platforms or local64_t for 64-bit ones. Take a look at [0]=
 for the
> example of how x86_64 does this, it is far from atomic64_t.

The v5 patch has changed it to u64.=20

Thanks,
Shenwei
>=20
> >
> > Regards,
> > Shenwei
> >
> > >>
> > >> Thanks,
> > >> Shenwei
> > >>
> > >>>
> > >>>        Andrew
> > >
> > > Thanks,
> > > Olek
>=20
> [0]
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Felixi=
r.boo
> tlin.com%2Flinux%2Fv6.1-
> rc5%2Fsource%2Farch%2Fx86%2Finclude%2Fasm%2Flocal.h%23L31&amp;data
> =3D05%7C01%7Cshenwei.wang%40nxp.com%7Caf8d6634fcfc4d77e07308dac7dfa
> 4a8%7C686ea1d3bc2b4c6fa92cd99c5c301635%7C0%7C0%7C638042060598040
> 501%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiL
> CJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=3DsWQ4Ts
> ayZvfs4pkCpC4tWvT51Cv89c4N6D5w2J%2FDC84%3D&amp;reserved=3D0
>=20
> Thanks,
> Olek
