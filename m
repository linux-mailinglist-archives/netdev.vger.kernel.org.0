Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB51624D2C
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 22:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231508AbiKJVk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 16:40:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230407AbiKJVkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 16:40:25 -0500
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2057.outbound.protection.outlook.com [40.107.104.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D596311179;
        Thu, 10 Nov 2022 13:40:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ALQuXIDBMVX8gtWc6R16RvebkbNGyT6TrEWsK+imoDUmW61RKHvWgMADPJcHiDwIXo7bO0FBKjBvurYhzBZsHAZMfQHDAP1ZJZcDoFcyL4dr4QeaK0mnjbLZT54dSJyTB15fAtUG0E32aK0tVIjXLH7o6r8/NzuZITHBtzYCGmDhC/YV3yBWcQo42kKnVt292zoXNAYbi3YFLV+kD4+qt76gOeDKPWkZKhkE8Y94dAdG90nSHeylsyOO00+wmt348HiEClthmSVhHPISSFyI0I3ARSgaexkAuZ6eGop7Mrd8kQiter3RjPmaI99XzbL5fTwziHkq3pfKv8LIj3/tTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IcLUpjKlugoBJiACP+4jq9JMN61ipxdsgWDlxPdZekk=;
 b=HVTqKLsbrYk1RwqZP2kuMAve7BpElcu/mv1Fdo7WKyqbiYmVEcVUwekj3uF6a1BnObSBX5fjgSCMF/fT+W5z+si7jkOaSN9D4XPAKkvF3cxj7AvqX5FLHD6TUJ903g5UHDSQeq/F7haVpBc6ERnBomwoHvum3ue/wWTT84f/8qUTZegMwjrKcQKbrClZZOkFGngHKb9fhx2wFIEJFg/vDiisU7b184KrmkXIzMe2HpX5pcrwpCvm0SOMGd4wr3yAuqSU0i1ZBFvM06pDZkhePUY5rx1fuKx18aELKg+t8n2iPthcdwWLftsvIXzcIE1EMENKUJR+uGCBtSUOasgOsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IcLUpjKlugoBJiACP+4jq9JMN61ipxdsgWDlxPdZekk=;
 b=s472Mnfdfw5KR1QOOK8isAlJ/bqiu0aIM1cEXGVZ0cY5RarhmERAx3sDv+pQz+ax5dOQFstK9qh/PjRW/gAqKF4NCD/BROqOXrKRmdl3OYnvKdMQtchnwvPLyiXSGe/PeazlRTR3rw0uwmdg2T3ttVCFYd6sZazTWnCOyEsVqJY=
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by AS8PR04MB7687.eurprd04.prod.outlook.com (2603:10a6:20b:291::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Thu, 10 Nov
 2022 21:40:21 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::6b44:4677:ad1d:b33a]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::6b44:4677:ad1d:b33a%6]) with mapi id 15.20.5813.013; Thu, 10 Nov 2022
 21:40:21 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
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
Thread-Index: AQHY8+NzKrQRZ3k0YEy+QDrsvHgkC644DoaAgAAaV3CAADZxgIAAUdXA
Date:   Thu, 10 Nov 2022 21:40:21 +0000
Message-ID: <PAXPR04MB9185CDDD50250DFE5E492C7189019@PAXPR04MB9185.eurprd04.prod.outlook.com>
References: <20221109023147.242904-1-shenwei.wang@nxp.com>
 <4349bc93a5f2130a95305287141fde369245f921.camel@redhat.com>
 <PAXPR04MB91853A6A1DDDBB06F33C975E89019@PAXPR04MB9185.eurprd04.prod.outlook.com>
 <20221110164321.3534977-1-alexandr.lobakin@intel.com>
In-Reply-To: <20221110164321.3534977-1-alexandr.lobakin@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR04MB9185:EE_|AS8PR04MB7687:EE_
x-ms-office365-filtering-correlation-id: be87e83d-927c-47a8-67b0-08dac3642b1d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ro+uOyWE4XWcifDNcHs1k2hz86ixvZuCVsfiG9Mw7nC9PmtF5Yr5xbYEd6XguV6GmTxYdZNUfH8RhP8/rhiSu2cOaUMSq108gqDtnxb/NInSyCOJqfi8x5P0HirFLmUDkrFQXj523JIfBiue9+BGOpwxnTUgxj45B0c2TsnNMfPSAgcQeZ1iUQKGT33t33rhGWxZ9/y8cmPSGU+ayD0VX3Ar3gF5ihjdyj8psIpAOln8HNVL7w5HmGwh/NQ9JgAy4biNjqSSQJDn2VheOfmcqLfheeLx/4OrMDK9vroMdNTETVe8LJeBug1gc/ndp7sDIhEgFo/CvlK0n6kpNV2R0NaoyBAqxE2QejwqI5YRsA2eBGnX6I+oz4DDVukcc5CsslpmoLkmSWM9+IRrWrSF0eN9BMq//P7HhN5HewUqZsV7xejFVfEuh1RpF+oU1eCm5BVoa7jOUT7fX6tG4ZTj/iHoTcE7rYktrSaqkjhlSbVAI77GslQIPOGrOZ9F7yUam7uglqi5G+TnXki4nWVJTZHbfKHaoL+UWKHSPYxyVyyumY8lkcurShxrrfCUh/1wUTyBLwwZw4FZBqqV5OiOy0extg4iJfPnZ8zXSVUMYysfcasjj1QewzmyWwp+KGzXrkFnJXafRDrhmqLVEuPzLBTzPTBAGUqqNyOBbDZeQW578dcEWRUP6/OlPXSdH538hPZXfOkO2lZ9Y1aEjxIPJ7+DrVH7utRW0cz5CqJzO48EKYe99JQL44DxEQ1Ea2MlbtHn7sR24bXUVef2XORcdQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(346002)(376002)(136003)(396003)(451199015)(71200400001)(83380400001)(186003)(7416002)(2906002)(86362001)(55016003)(38100700002)(38070700005)(122000001)(478600001)(54906003)(6916009)(33656002)(316002)(66446008)(55236004)(6506007)(7696005)(44832011)(53546011)(5660300002)(66476007)(26005)(52536014)(8676002)(76116006)(66946007)(4326008)(9686003)(66556008)(64756008)(8936002)(41300700001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jiy813wX+WJUWibeu2g9e57iq6rvG2JGICwlQedo6FlTnu3JrRllrMIdSdxr?=
 =?us-ascii?Q?6ysHFCzUO80rNonIcV/tbIok3c7M9vKGoZ0eG3YJeTGSczFdsBO0fRu+rC3l?=
 =?us-ascii?Q?EhmJ3fyT/K5aZARkVle1uRfRr3Iga/45h7UjIXPR/wFn3I1OHmR5xzT4CT7D?=
 =?us-ascii?Q?zWcvlzOvbduSA0PF1K5nzvRMK8OqUfRWQozC1X7nWTfd+wPI0pNKOPWzqZ64?=
 =?us-ascii?Q?Bwa5fyXQF65HvSCmDwyouM4iXxMMJaeSz9pjD41KtGqQejyL4lAPdn9+8Owr?=
 =?us-ascii?Q?GgNiZgMcarwnGuOxDtGyvScy3d75LZ6uLV00MQuKDbKrrpreYc23A3UgDWX5?=
 =?us-ascii?Q?yDUPOQH8FRiZ7e3Y2mDuXXm1tB1GOIJa35rqgku+xv0yJaSVGL5CZct9+IDM?=
 =?us-ascii?Q?Sk4Buu/xURkY4HIOBUa0zsGv4/vBlzlYuTPqLwUER7ziaI85iU2m1cZslzeS?=
 =?us-ascii?Q?xadeI6OphcenEcMiPpYqCf6rByH+NzaCiz3Def/yp5b5f7FtIYF//WD8oVJF?=
 =?us-ascii?Q?14TbORXfPZqu6rpoKvWtGk6/3q2tIyBRcxNo1+awPCojnWPCf8Lj0De48Wmk?=
 =?us-ascii?Q?iaZb9tDSu6cX33qP6MEgLmmn9MQVEjrR2GcG5bEtQF9PpUMQSItr976tfauQ?=
 =?us-ascii?Q?1lk3yTnHsuDrkAbJeGYPn68RuCAWnbqvZJ2/L2LVKga2mLVm0OBtqrz/Jq8p?=
 =?us-ascii?Q?yJfHhqYM1SiPBYpgNGBWAGxS2Ep/QL3UEa9wATuZsSgrzo0VaZ1Yu3xl6TwJ?=
 =?us-ascii?Q?LKfHzXFsf+uQ+XQMx5u6JdxZiOVWST4/N8mrSxL3ORZdNOUNxopDGzSYk7jB?=
 =?us-ascii?Q?i0QD+VXy8KD2tVLBb+OxrqjRPdMbzxH6nSZYr90qNzCCSKBddpKgQpCAwwGA?=
 =?us-ascii?Q?tjSlJ3hKiMXCZbMr8I0J2PIoDY3enEBiX8T9lJvtTvjbrqpSvt2PfCDOcyro?=
 =?us-ascii?Q?S53zxJ2LMWjNhtxQs5V6KkhZmDBOT5bLsj1A6jDWTxVn7Azb3empAq19LoKp?=
 =?us-ascii?Q?4SGJPkVMMprE4POAExJcq4VDihnT7QWnRk60EhxDwRU5F1XLiGshr/v23ZyY?=
 =?us-ascii?Q?7eGfc7QuxfNSijf2NkvUWncGwZfJ3GSv9hhwkeTOMNz1xZNNQOvoFU0AVXJ5?=
 =?us-ascii?Q?hVo9StgfASQoXabMJk9/E2BSIxk52oX33df2Q6RZ90a0GU8NkbBc1WSpoANK?=
 =?us-ascii?Q?ujyBozUNw3KUbA38SHEGKSGp41XBb3ob/qTdidg8AztI/oU5FZssov3Xp151?=
 =?us-ascii?Q?c5KAzJPpTP7F6uuGceb1kGC37ptPufjQF8/LwkGMpa9IkLS8e/0VPCw/9q4F?=
 =?us-ascii?Q?B7jX92rdYjap81YjVpjmMbFX/xSDFoevYdFu2QNFytxHkn1PvVtpxzMy3JaK?=
 =?us-ascii?Q?7ugE5U6JfXVllm6qL3TuoiAV8gT022K1rvu/2XEOJqOkyRv20SQ5zvIti9mE?=
 =?us-ascii?Q?22XIR2tUD5ztsJ3MRPt9z3ltPt3lQhHdC5kt61+wzMK1qoN6074R9tIQThcG?=
 =?us-ascii?Q?6JtL90Ogpn4tECA6LC78SKjfqdzaLW668foxNlKTx6OZBxQMvSyTr3W+/7Lt?=
 =?us-ascii?Q?lV8o6cfUczjV8KdeM51Fd1si6nKdKT3zQoDKceZw?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be87e83d-927c-47a8-67b0-08dac3642b1d
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2022 21:40:21.3683
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wFIpv3IjZFf4PeTubfM0PkDqtxfnYdLdGV+vP4Hs8BZGsE1BIRxmOrZILWu03CPLv5dfIzlnUkwVdQPA284C4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7687
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Alexander Lobakin <alexandr.lobakin@intel.com>
> Sent: Thursday, November 10, 2022 10:43 AM
> To: Shenwei Wang <shenwei.wang@nxp.com>
> Cc: Alexander Lobakin <alexandr.lobakin@intel.com>; Paolo Abeni
> <pabeni@redhat.com>; David S. Miller <davem@davemloft.net>; Eric Dumazet
> <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Alexei
> > > at ../drivers/net/ethernet/freescale/fec_main.c:2788:4:
> > > ../include/linux/fortify-string.h:413:25: warning: call to
> '__read_overflow2_field'
> > > declared with attribute warning: detected read beyond size of field
> > > (2nd parameter); maybe use struct_group()? [-Wattribute-warning]
> > >   413 |                         __read_overflow2_field(q_size_field, =
size);
> > >       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~
> > >
> > > I think you can address it changing fec_xdp_stat_strs definition to:
> > >
> > > static const char
> > > fec_xdp_stat_strs[XDP_STATS_TOTAL][ETH_GSTRING_LEN] =3D
> >
> > That does a problem. How about just change the memcpy to strncpy?
>=20
> Don't use a static char array, it would consume more memory than the curr=
ent
> code. Just replace memcpy()s with strscpy().
>=20
> Why u32 for the stats tho? It will overflow sooner or later. "To keep it =
simple
> and compatible" you can use u64_stats API :)

The reason to use u32 here is : 1. It is simple to implement. 2. To follow =
the same
behavior as the other MAC hardware statistic counters which are all 32bit. =
3. I did
investigate the u64_stats API, and think it is still a little expensive her=
e.

Thanks,
Shenwei

>=20
> >
> > Regards,
> > Shenwei
> >
> > > { // ...
> > >
> > > Cheers,
> > >
> > > Paolo
>=20
> Thanks,
> Olek
