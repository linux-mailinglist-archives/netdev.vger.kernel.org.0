Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD735F1310
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 21:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232103AbiI3T6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 15:58:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232087AbiI3T6V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 15:58:21 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2055.outbound.protection.outlook.com [40.107.22.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94C191B7DA7;
        Fri, 30 Sep 2022 12:58:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VgSD77iRCPG77QxCeWAxfz5XUWRqW6ErqbU4oLzIXcG2qOie/Lo0xF55wmLxCnTyGB649J8gDPf6WzRL1rncuoLUGHridJOnVIemFZiPd4YeCsmiKbix151PK+N1QRaYzo1jQVBVWTMgKLd5WbbDutQzmTCJZLg06Haq3kuAaOvrkFi5OUzMmrAevi/vUUVDJKmFz2jOwUY6HvnRv35p+bAChsSfgr45qN49J7zP1qx9HdSwbNcGeWWEucRMFcPuCbUvCjfRZOjYjZ6lOCfvxVaYKRWJf052HGAs+7sBjeDYH2/cIm9uvAFOsQMsgLj5/CmiObPHm8gq8oDXs69UTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KuiQXSA2LU4q96vDO5mgX2RD1/66+cMe9pf8K2eMNi8=;
 b=nkkcA649kXQ2HJpBCJceduEyKem2p3SbpxQ9+y/6MwnT7wd1BqxCdXxOnusOOQSzDfyZQCwJoKKP6t6RKsWcSyaZCOKZRdF/Cuz9yqObczN1+vXaJqt2PRJD6xOJ/KszxfXZjB0BssFru6aXwk8cJaEyzYj5YUoIxD93uInzz07t1CemP9N5Qv/9UXFQugQJMAyNalXh0SvcqQWIjqntiRXrZRNnLEYwb0YLRi6Ffd/PW/Luy96SXCcCQw1dBBoIcqtmYL5yU0nNERHHhj1k4/22ai9kOvuypUZ/bQdK6+kqD79ob92cIErszTIByfCsPEp1WLUAlDg1rBXcGnMS/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KuiQXSA2LU4q96vDO5mgX2RD1/66+cMe9pf8K2eMNi8=;
 b=Sl9/VgU7fzom9cEECIMnhr+Kv8OHoffNe1o3230vqwEmpDGuQ/2xlxuI1KodBhCyv0Uooykdra7dTxT67C24X+lJulzZ0Z1TzdSTt69utsbObgY+36D6UQzlM37gX5C2Fc2QJy6giTFcDBFBRN0bJMUy78YA24vHK1fm5Ir31ns=
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by AS1PR04MB9239.eurprd04.prod.outlook.com (2603:10a6:20b:4c5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.19; Fri, 30 Sep
 2022 19:58:18 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::a543:fc4e:f6c5:b11f]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::a543:fc4e:f6c5:b11f%9]) with mapi id 15.20.5676.023; Fri, 30 Sep 2022
 19:58:18 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "David S . Miller" <davem@davemloft.net>,
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
        "imx@lists.linux.dev" <imx@lists.linux.dev>
Subject: RE: [EXT] Re: [PATCH 1/1] net: fec: using page pool to manage RX
 buffers
Thread-Topic: [EXT] Re: [PATCH 1/1] net: fec: using page pool to manage RX
 buffers
Thread-Index: AQHY1QQs3moef3i30kelaD3cHlhvbK34Yi8AgAAAVFA=
Date:   Fri, 30 Sep 2022 19:58:18 +0000
Message-ID: <PAXPR04MB9185E69829540686618987D289569@PAXPR04MB9185.eurprd04.prod.outlook.com>
References: <20220930193751.1249054-1-shenwei.wang@nxp.com>
 <YzdI4mDXCKuI/58N@lunn.ch>
In-Reply-To: <YzdI4mDXCKuI/58N@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR04MB9185:EE_|AS1PR04MB9239:EE_
x-ms-office365-filtering-correlation-id: 84ce16d4-d15c-47f3-c999-08daa31e1e8c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Au2ao8Hvoxkzf4WI4raVvdYal7OQyrpLSCfxiG/fBKGsv5++JH7G00W6skJobXQPEYq4eTYwZnah+y31LJfrA6p6ES9U2itWMeEmtGLvFtw1RiTT6q1kCTQKCXsQxvAnTwfbq1AHFZSEWR34pLxLG4isLqPMg9EK+rxjYDQMODyygW5tXZEyNSAdLwwJ02lgE3526EGEmVeyOS6G8YCjohQw5vh0Cf0tL7VsUIi3gZruEF4DDVh0Ue6BO1HjqPv80lkpxso983p6fqUsvlfdA7GFfszop9F6I47pPZYUSB1xTMhpMeJtFAMBhd2pfYdi0c8h9c1JA1fm9gkPw715ogtvdfAKJtGbTOflp1oJSOM1aPSLp7EVQ5k/Qa4zihZGNXqWinLkzEcuvomBatZRPgoq1D23OhgwuQNg/drv5ylDtGM+jhJxsrfaU/HcIiynOBkrn0YR1TQbDvlePoUE2hNfDLuGSY/OJRnVjQEM3n4t8XAadU70Sqt8wdHtVQ9yTsGMFpEPPrdRQDT9Raz7soJCxhNxT2HG1eRn5f/mwUsBJDp/ey/ijRM+ImJ3l59aETpHrW7lboMnnKEIE+i51b9WbMoe8gDRFwRF7KRnILi7CtgIqEtHq0rhF982mYqAhwaxyGG7VAscFKVwluS9XipS+u5HbBVJZPTc4/KXWY/zQr8Q4i4AB1pLSRuKbRNuWgdlptdVvFqxunG8qcAGmS4Ml811A+tgd1ihLi8WahMbDJngByTQ0YRBW5vYP2ktR8mWrdKiikXT5QdFzashVA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(39860400002)(346002)(366004)(396003)(451199015)(33656002)(55236004)(53546011)(6916009)(66476007)(86362001)(66556008)(316002)(38070700005)(54906003)(76116006)(66946007)(26005)(55016003)(66446008)(38100700002)(64756008)(71200400001)(83380400001)(186003)(122000001)(478600001)(7696005)(6506007)(2906002)(9686003)(41300700001)(66574015)(7416002)(8936002)(5660300002)(8676002)(52536014)(4326008)(44832011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?BhnJUvSwzPLDkM4eyUfFe0BWkHczOtt6e+okFItAVI7CClzZXef6BjwWBs?=
 =?iso-8859-1?Q?G7b9dmlvS4Tyzz5bklYYykZ2mxTY1LhOCYpu9tvSZh5YEAMYtbh5/Pfb61?=
 =?iso-8859-1?Q?cL4zeEERhmCuGctiYplfwQbU4FjmMdrNBPYsxKepp6mP+GrOkoAnPyDNIc?=
 =?iso-8859-1?Q?tb6eq4OOEsl2DpyymxkxfV/39MCAfQoW0/jLnhCuuMdOD8wPhpuj4VAbuy?=
 =?iso-8859-1?Q?5RUEVaukb58IUXG3ND2yPLoMzU8QNh3JaoQEAFWFGT5zLSe+gQ3vfeQBEF?=
 =?iso-8859-1?Q?PkqH8Dp1MRCfIZvxtzKcObapYKMMft3h1enNYXqTrtkrkxs6qyTVcH2k0U?=
 =?iso-8859-1?Q?JqYmyrSvVYehmOnjnm2cRN2GYobytBhT3c34ibyJg9QDZDu6bDBVXoTk88?=
 =?iso-8859-1?Q?PM2PalQwLDTocglzI8oq7kghtuebPViY5sg/OzDJQGUr9p+ZSfjBW7LhTC?=
 =?iso-8859-1?Q?aFVeqEK8TDRvqVv98PfCsAq3m4o7JkZLJl9wGAn13YuLEtF7HKZ94TNwNf?=
 =?iso-8859-1?Q?CTBuOiJkb0EL5EjQyvLK1qpVtUVnw9vOPBnfKZ95x4CUB/YDow1GdCK+ug?=
 =?iso-8859-1?Q?6B2tK2z8QTdmRnEckakt8ufV2GYsHaZ0rAH7Ry+M+p8NE0NYXEX+sqoSEp?=
 =?iso-8859-1?Q?0GRJfmBEETV6fDwj9MpyO5OK+5OhLldiGyseFK86hzhKs/Cmf8LwR0zSHh?=
 =?iso-8859-1?Q?s4CGo0IIIkNC97WvaT0Qy+VJgveDE+ObXyFAvOtGkYrfh3jsesiw5yt8Vm?=
 =?iso-8859-1?Q?0oR1RIDDr3xRDwja9a3DtBuC2KvDrLZhrQ50ZQQ5+iESWyAHefmIyJFjJ7?=
 =?iso-8859-1?Q?ZJKXc5SIp5UJTxpSiaySfyr0c/QmKsJnuh2e3ndMhoLwLysEoGcc3Ocqrd?=
 =?iso-8859-1?Q?0I6KcFn5vqxY9zcWFbfaLF0iKAT9mXeFrfi7xOcCBD6uGP3O1oUKV7BpeB?=
 =?iso-8859-1?Q?fU7EXyCrsyfd081+BBPki/NicB9qR0isFltOVXKwy8y+S5Tgjw4mQHl+2I?=
 =?iso-8859-1?Q?0kf5qztJQb8FEPMq2u862YtzswYBVCovreWc3bsOSa3x1oiV9cFaEMZFfk?=
 =?iso-8859-1?Q?O4scPbNjcP8ZxvhNTaSrMnuTeL/QyWac1LsikciQzskUgnAsen5oZ62U02?=
 =?iso-8859-1?Q?Iy2cpVbjBQesTZCvCnaX2fwAjqiUf01h6zxQBqmH+2cYZ3I91ggAAt2Wk9?=
 =?iso-8859-1?Q?NNs6ynAojPqAo5ej+6Ugx+MBGSOWZic6nMdbm7dZwLbza0RcDQ8iV6jnSC?=
 =?iso-8859-1?Q?1p2LXA3iwR6cdDm73D4nvG3l8r2PojOE8K4+cZ1a5fZ/AJhv2fjA3/GSM8?=
 =?iso-8859-1?Q?uuCfwo3htnCIvCq+IQtZfcbca2YX1KGnRtfGFRVG0owm2+8WLv3UhqfkVu?=
 =?iso-8859-1?Q?ajDdNVb6V/SrxA77altQVfg/i4Kp5QrS2B99UJytjMoreYcf+mZ9YGJmaA?=
 =?iso-8859-1?Q?URMHrJBz8uCDU3zGAwNJuVKukqLUOUvP1mAB1MVvBgot9kc9lU00x9OxCT?=
 =?iso-8859-1?Q?INxWBurbMPzYbZxP7iO3m5ICVCGNwQQ1SCvJvEzytPv/Kn6NaMgCrP+BFM?=
 =?iso-8859-1?Q?GI2pvCdZPDmRehcq8bOOIKxpBzbbqSCweUrMJXTyaO7+einVEmYmJqVaUJ?=
 =?iso-8859-1?Q?T+Lz+/2pWcLga10K7E8TxkVYKeO+s6UnuF?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84ce16d4-d15c-47f3-c999-08daa31e1e8c
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2022 19:58:18.3079
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rcQeijI4Gw5Su5UUEyHqO52VtrQEZQ4PQCftqxJBD2h1+MmINBD7lWsDWhJMDUNgHGtUqsFmYoPmkRk6l3R6Ig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR04MB9239
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
> Sent: Friday, September 30, 2022 2:52 PM
> To: Shenwei Wang <shenwei.wang@nxp.com>
> Cc: David S . Miller <davem@davemloft.net>; Eric Dumazet
> <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni
> <pabeni@redhat.com>; Alexei Starovoitov <ast@kernel.org>; Daniel Borkmann
> <daniel@iogearbox.net>; Jesper Dangaard Brouer <hawk@kernel.org>; John
> Fastabend <john.fastabend@gmail.com>; Wei Fang <wei.fang@nxp.com>;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; imx@lists.linux.dev
> Subject: [EXT] Re: [PATCH 1/1] net: fec: using page pool to manage RX buf=
fers
>=20
> Caution: EXT Email
>=20
> On Fri, Sep 30, 2022 at 02:37:51PM -0500, Shenwei Wang wrote:
> > This patch optimizes the RX buffer management by using the page pool.
> > The purpose for this change is to prepare for the following XDP
> > support. The current driver uses one frame per page for easy
> > management.
> >
> > The following are the comparing result between page pool
> > implementation and the original implementation (non page pool).
> >
> >  --- Page Pool implementation ----
> >
> > shenwei@5810:~$ iperf -c 10.81.16.245 -w 2m -i 1
> > ------------------------------------------------------------
> > Client connecting to 10.81.16.245, TCP port 5001 TCP window size:  416
> > KByte (WARNING: requested 1.91 MByte)
> > ------------------------------------------------------------
> > [  1] local 10.81.17.20 port 43204 connected with 10.81.16.245 port 500=
1
> > [ ID] Interval       Transfer     Bandwidth
> > [  1] 0.0000-1.0000 sec   111 MBytes   933 Mbits/sec
> > [  1] 1.0000-2.0000 sec   111 MBytes   934 Mbits/sec
> > [  1] 2.0000-3.0000 sec   112 MBytes   935 Mbits/sec
> > [  1] 3.0000-4.0000 sec   111 MBytes   933 Mbits/sec
> > [  1] 4.0000-5.0000 sec   111 MBytes   934 Mbits/sec
> > [  1] 5.0000-6.0000 sec   111 MBytes   933 Mbits/sec
> > [  1] 6.0000-7.0000 sec   111 MBytes   931 Mbits/sec
> > [  1] 7.0000-8.0000 sec   112 MBytes   935 Mbits/sec
> > [  1] 8.0000-9.0000 sec   111 MBytes   933 Mbits/sec
> > [  1] 9.0000-10.0000 sec   112 MBytes   935 Mbits/sec
> > [  1] 0.0000-10.0077 sec  1.09 GBytes   933 Mbits/sec
> >
> >  --- Non Page Pool implementation ----
> >
> > shenwei@5810:~$ iperf -c 10.81.16.245 -w 2m -i 1
> > ------------------------------------------------------------
> > Client connecting to 10.81.16.245, TCP port 5001 TCP window size:  416
> > KByte (WARNING: requested 1.91 MByte)
> > ------------------------------------------------------------
> > [  1] local 10.81.17.20 port 49154 connected with 10.81.16.245 port 500=
1
> > [ ID] Interval       Transfer     Bandwidth
> > [  1] 0.0000-1.0000 sec   104 MBytes   868 Mbits/sec
> > [  1] 1.0000-2.0000 sec   105 MBytes   878 Mbits/sec
> > [  1] 2.0000-3.0000 sec   105 MBytes   881 Mbits/sec
> > [  1] 3.0000-4.0000 sec   105 MBytes   879 Mbits/sec
> > [  1] 4.0000-5.0000 sec   105 MBytes   878 Mbits/sec
> > [  1] 5.0000-6.0000 sec   105 MBytes   878 Mbits/sec
> > [  1] 6.0000-7.0000 sec   104 MBytes   875 Mbits/sec
> > [  1] 7.0000-8.0000 sec   104 MBytes   875 Mbits/sec
> > [  1] 8.0000-9.0000 sec   104 MBytes   873 Mbits/sec
> > [  1] 9.0000-10.0000 sec   104 MBytes   875 Mbits/sec
> > [  1] 0.0000-10.0073 sec  1.02 GBytes   875 Mbits/sec
>=20
> What SoC? As i keep saying, the FEC is used in a lot of different SoCs, a=
nd you
> need to show this does not cause any regressions in the older SoCs. There=
 are
> probably a lot more imx5 and imx6 devices out in the wild than imx8, whic=
h is
> what i guess you are testing on. Mainline needs to work well on them all,=
 even if
> NXP no longer cares about the older Socs.
>=20

The testing above was on the imx8 platform. The following are the testing r=
esult
On the imx6sx board:

######### Original implementation ######

shenwei@5810:~/pktgen$ iperf -c 10.81.16.245 -w 2m -i 1
------------------------------------------------------------
Client connecting to 10.81.16.245, TCP port 5001
TCP window size:  416 KByte (WARNING: requested 1.91 MByte)
------------------------------------------------------------
[  1] local 10.81.17.20 port 36486 connected with 10.81.16.245 port 5001
[ ID] Interval       Transfer     Bandwidth
[  1] 0.0000-1.0000 sec  70.5 MBytes   591 Mbits/sec
[  1] 1.0000-2.0000 sec  64.5 MBytes   541 Mbits/sec
[  1] 2.0000-3.0000 sec  73.6 MBytes   618 Mbits/sec
[  1] 3.0000-4.0000 sec  73.6 MBytes   618 Mbits/sec
[  1] 4.0000-5.0000 sec  72.9 MBytes   611 Mbits/sec
[  1] 5.0000-6.0000 sec  73.4 MBytes   616 Mbits/sec
[  1] 6.0000-7.0000 sec  73.5 MBytes   617 Mbits/sec
[  1] 7.0000-8.0000 sec  73.4 MBytes   616 Mbits/sec
[  1] 8.0000-9.0000 sec  73.4 MBytes   616 Mbits/sec
[  1] 9.0000-10.0000 sec  73.9 MBytes   620 Mbits/sec
[  1] 0.0000-10.0174 sec   723 MBytes   605 Mbits/sec


 ######  Page Pool impl=E9mentation ########

shenwei@5810:~/pktgen$ iperf -c 10.81.16.245 -w 2m -i 1
------------------------------------------------------------
Client connecting to 10.81.16.245, TCP port 5001
TCP window size:  416 KByte (WARNING: requested 1.91 MByte)
------------------------------------------------------------
[  1] local 10.81.17.20 port 57288 connected with 10.81.16.245 port 5001
[ ID] Interval       Transfer     Bandwidth
[  1] 0.0000-1.0000 sec  78.8 MBytes   661 Mbits/sec
[  1] 1.0000-2.0000 sec  82.5 MBytes   692 Mbits/sec
[  1] 2.0000-3.0000 sec  82.4 MBytes   691 Mbits/sec
[  1] 3.0000-4.0000 sec  82.4 MBytes   691 Mbits/sec
[  1] 4.0000-5.0000 sec  82.5 MBytes   692 Mbits/sec
[  1] 5.0000-6.0000 sec  82.4 MBytes   691 Mbits/sec
[  1] 6.0000-7.0000 sec  82.5 MBytes   692 Mbits/sec
[  1] 7.0000-8.0000 sec  82.4 MBytes   691 Mbits/sec
[  1] 8.0000-9.0000 sec  82.4 MBytes   691 Mbits/sec
^C[  1] 9.0000-9.5506 sec  45.0 MBytes   686 Mbits/sec
[  1] 0.0000-9.5506 sec   783 MBytes   688 Mbits/sec


Thanks,
Shenwei

>     Andrew
