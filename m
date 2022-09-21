Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAE195BF1DC
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 02:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbiIUAQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 20:16:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbiIUAQa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 20:16:30 -0400
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-eopbgr00077.outbound.protection.outlook.com [40.107.0.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04DC73D5B6;
        Tue, 20 Sep 2022 17:16:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AEUq+rom5+K2L4Mp89PtHt/K8RuBXWncEWL1FtsFkg8+llDOVoN3s2jZcusS3cc57IfI49TW60d+xJ+zCGg9lYOzfv0lZF5fkbigRXNXXkA/5SXcxgyCyInRKscCavLLnZMGSZ9gJztF9zq7eVm210yrufAtWfnZ/Lt87JXU0tHkbVvFdJPOI4kyyW/ZmTbAPlW5sv+Bf9u0R/M4VQhfDEWId87eBo403utigG2zIcOrvqimHooqL/Oyw8OTbMMLHVEMCuVdH1WIBpHQhQ7AW0GE3zptKQuGY3JfYftPc+5f3jTayrksPn+e+tewKifpUDzg5Zn5Lk8d6BXANSLtdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K9bQASqGf45kCPQk1wxaWC921NBduyP2E3WbKxEz5mQ=;
 b=WU1xPQbQBDSmzimCnnkfKIgXQoIiLxV9mWOiSBnBa8HIMTlTHwW5qQ1QnWHcw9m/LsK8yrF3gjPPlTuuRnXd6AB6ef/ZQoy7Zr43xp0I1mjBiWQ4X5pXpM101MIokbhaVD2ibvnNn9Dr92TSPVsuxAwrWVA1O0lYMVx+lUJfGuIBLupv+nGyyP/xgBcvV+ZOOQImPqhskgNLddTiqJmmQo23UGL284L4WUovO6qdJ1QEHKRRiHCVryBPc0DAsA6Q5VIAhFlbdmofpsUkwpgofsznDq8k9JRFjkT9O3jurP0H8HmoQ2o6An9S4uIHzgaaSJ+wPzWt6KRAJw/8c4B8Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K9bQASqGf45kCPQk1wxaWC921NBduyP2E3WbKxEz5mQ=;
 b=E8Mm+ORCYoiJDWI1a3DJdPZZFkjCLaP0r+4WYJDs05e1fAKM7QhEaPgcqZimi5WlWSi2ZPOVp6Pmjn3zykd5jLZ6COB/q4JacJnJwrGpvzJmBbsAkqrK0A1H110J81cvXgwaJvoqNFHy8XlbCJSLVcYPaH6K1zPiTpkYn5TPZn8=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB9079.eurprd04.prod.outlook.com (2603:10a6:20b:446::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.15; Wed, 21 Sep
 2022 00:16:27 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5632.021; Wed, 21 Sep 2022
 00:16:26 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 net-next 7/7] net/sched: taprio: replace safety
 precautions with comments
Thread-Topic: [PATCH v2 net-next 7/7] net/sched: taprio: replace safety
 precautions with comments
Thread-Index: AQHYyPEMssHTbOdWeEqTjPVnldStm63o1mCAgAA2g4A=
Date:   Wed, 21 Sep 2022 00:16:26 +0000
Message-ID: <20220921001625.jwpr5r5tneyoxect@skbuf>
References: <20220915105046.2404072-1-vladimir.oltean@nxp.com>
 <20220915105046.2404072-8-vladimir.oltean@nxp.com>
 <20220920140119.481f74a3@kernel.org>
In-Reply-To: <20220920140119.481f74a3@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|AS8PR04MB9079:EE_
x-ms-office365-filtering-correlation-id: fb83b97c-c914-4401-b1e9-08da9b6685fb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZKuBVSZ4l+xBFf72Qrv5/bx6KMk7bLl0npzVFeiEEQUsReRz0c1Eoc2J/qQzsuxwshdqc9LoJXLf/fY1B5tAukhDgGokHCBvTiu8oy7pGat2iS11JImWJcM56TSnKP2WFRH4JR//f8WyJrTTYxr85WeQup9tNfBXuEfYz2YakfR3ABU8jqlAqwF95CqyaYTF+dViV8aiCynugS4V/HerpcZbBW2labfOYYNjOh29/T918R7ooOROtyf8GOSl1Tu23bPIrXmgOPLiRor6f8BkmnTe+gQEmEEmOwaaR4c3FuK6L86BXnp+x+Vz/qewCyWPJyEqLkIkEyrR2aLUCOiuQWSm8Tkd0GOP02bQ6jwNSqtAMPZ61i7KzMUbn/reIVKqg6pQmZg1RQBQU1cxn2If0wUUH5Xudaoc3XfV5NAJnxx8sBHwNGwNwwHYZAIlU2gbApzS6UpnuiH7sffllQgOTB1qOITGb4TlWR+GwwWXXUiTHWsGq38QCYtDnlC+YLycl9ZCdaQWXruZKJYJdTkCopaJ+6Pnqg5egpaa9hF695y2B5+UjxeFaq8n5xr6ATAfzOpvgVOzDuu7yS08FhEd2YaZymrdDPlcjnK143TfhtFrQCAW7OM3HnwJSFLRuLQGOnVs8twgM4NvKk9DRhGAySVyHgWaMFxdqd0qUs/EzwrJ62GsVnXU9TnVJxEKhitIuLeTlsM5Ow25F64sk71zOFKDL1V+YxQzuV/yvvBJUBavATV/XBjRzyaBXjK0/CNc
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(376002)(396003)(136003)(39860400002)(346002)(366004)(451199015)(71200400001)(44832011)(1076003)(186003)(9686003)(6512007)(26005)(38100700002)(33716001)(54906003)(91956017)(6916009)(8936002)(7416002)(5660300002)(66556008)(66946007)(4326008)(8676002)(6506007)(66476007)(41300700001)(76116006)(66446008)(86362001)(64756008)(122000001)(2906002)(478600001)(38070700005)(6486002)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?YO6UBvcO76Z7InrGI7AXSdyw9Xz1drV2cp7rN81KVoXJVVIWnIS5fbKu8dQK?=
 =?us-ascii?Q?BF1cWt2MKMIley7TRDgd5cyamgtE+a0Vh0fz1RrleFJLxw+wxwgqnjQtKNY8?=
 =?us-ascii?Q?YXv4HzhgKN82FsLg1eS+7rKjCbAhu23eD8OaFtMI0H8Yb9yhCA/8SaVdGgsr?=
 =?us-ascii?Q?c0Lcgaxv59O5/MHm8Zj0Zk9K6HLy/pLaoohzJAKBgvQqDm9Ae7AO/BzM73kH?=
 =?us-ascii?Q?fAB429WcMFQUPgIUEUUcJG2FQ5LBI8L7SMCFqs98e6xMEehwRpW3CekdC6hh?=
 =?us-ascii?Q?1xagEOrIE64gruTH0b3CJXlfaC7wKG5KSFN8+v86ZHw6X2eEIqZ2xPQsqnZN?=
 =?us-ascii?Q?Q5e8rz/Yqx2/gdJdYZpFH5TJDUsD04bb0WhwoXU/q5nSbNmPBFGqoMgkI4EZ?=
 =?us-ascii?Q?xJiJHnJTfOcJZE8oezCS32gwFTwnpp0a/fChRhKGyEQ/UaAIzRkIyGX0RBmO?=
 =?us-ascii?Q?DFuI9te1M1sOEktHA81CVtLgBhjWy4ISdCxNBtHCCJg+VLW+Rn1Bpp1SPf+s?=
 =?us-ascii?Q?cB4sDhToofnW0u3RjcX+UgVrRgCFrNCwDynKgaeyS8nE7f2nyTllTv6DGKzP?=
 =?us-ascii?Q?wnNzq0+B0x0/9LofxMCR5DHYceYob4BsNwzdrlK2GGSAtq1TmMkp1N2LPHuB?=
 =?us-ascii?Q?43fbKc3tzTBW80MwpD4i4UhoT1yLQzCCgK2UJ1j9o1kJru8woZsI0lNIk2m5?=
 =?us-ascii?Q?MzSRbAn1ilblh9YuJ4JNYrGn+7vdzCGMLeYQaH7h0w2u9B24h4GC29qB215a?=
 =?us-ascii?Q?dKgqxUbg+d2NLD1YfYJVJaF9T1uxSKJSyWs9xXl6X9jJVMNOpmQ+46BmuiCc?=
 =?us-ascii?Q?bRJrnLyvpsMcjJln8LGhx/QiSw/ZxEylS8gdtHMVu/n2BNEuErw1yrybCxpW?=
 =?us-ascii?Q?YGMJFsDRXyzy0nBhjvUbikEtRkrv0ycwiUGn72RG4+7Ryty/pHgyEuklZ+Z1?=
 =?us-ascii?Q?w7xnVnq3AmTCcKrZ3gR2MmPXkcK+zO1hL0ZlYO9iCnhTYBm9Qb/vkkRdG4xp?=
 =?us-ascii?Q?690Yuj7Lsap4PwBrIeBolKzikFUr/F2cPXXMdMJ/24d7saN3PieovOWAi285?=
 =?us-ascii?Q?TDpXp6smI/iaZllYBR7Fb3zx2EvcQNKuKyDiBN09wMbLR2LuhmBSXGCSe4W+?=
 =?us-ascii?Q?R9hcCz5z/3EwaIShfjSjzXRwCIEu+XU5WthcF3kPNbXmksXGQUaKwSmRyDnr?=
 =?us-ascii?Q?xbvKutDvOS63xJOLn18INzeZETBH1PYVVHh+JNM3Ko+T0k7CLfW6DTkTb7Ld?=
 =?us-ascii?Q?L1H19ArPKLPwY4LjYAewfUzeNC9pRN/VLcCLEwSEwVVEYr+NQV2uA/rhC6KH?=
 =?us-ascii?Q?4HWQLwb1LOacPJRCrIWgcW20iMcbPmc/Ais+eEN7QYTBgua9KO1xMqkWh0Ge?=
 =?us-ascii?Q?QQwaDs5IvaTgCJOcH/BjW+Wrn7De0URtNICjmfJJgsxtnVD6C0B0tUNzi4wb?=
 =?us-ascii?Q?9LUwS+/4eEsPwUdfLI6LGmyj96gKTm/FPSEuh0bsumftMmmnVYa2ox3UD262?=
 =?us-ascii?Q?PoUzoDB4U2OZJh74gUT0f1k4x5sAh0wjSkiQaely7SwAxkwLsjY7Mh3RRGar?=
 =?us-ascii?Q?bLvIyhy+w7j8OlJ3YDtcAr4Br8xCL008jhvsjqBQoa0J12QMDutn8AfvwCVO?=
 =?us-ascii?Q?Ig=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <88DEC59C63C0EE4BB4DA596DB72F5FF8@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb83b97c-c914-4401-b1e9-08da9b6685fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Sep 2022 00:16:26.2555
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gx/MbOSPUoqRjzQhU4e2o/ANYmFjwhgLHhVmErj3PFMBjrnI5U1Vqe5CKb4h0BTfeOmK4lU1PtZPm4aTCZ3bIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB9079
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 20, 2022 at 02:01:19PM -0700, Jakub Kicinski wrote:
> On Thu, 15 Sep 2022 13:50:46 +0300 Vladimir Oltean wrote:
> > The WARN_ON_ONCE() checks introduced in commit 13511704f8d7 ("net:
> > taprio offload: enforce qdisc to netdev queue mapping") take a small
> > toll on performance, but otherwise, the conditions are never expected t=
o
> > happen. Replace them with comments, such that the information is still
> > conveyed to developers.
>=20
> Another option is DEBUG_NET_WARN_ON_ONCE() FWIW, you probably know..

Just for replacing WARN_ON_ONCE(), yes, maybe, but when you factor in
that the code also had calls to qdisc_drop(), I suppose you meant
replacing it with something like this?

	if (DEBUG_NET_WARN_ON_ONCE(unlikely(FULL_OFFLOAD_IS_ENABLED(q->flags))))
		return qdisc_drop(skb, sch, to_free);

This won't work because DEBUG_NET_WARN_ON_ONCE() force-casts WARN_ON_ONCE()
to void, discarding its evaluated value.

We'd be left with something custom like below:

	if (IS_ENABLED(CONFIG_DEBUG_NET) && unlikely(FULL_OFFLOAD_IS_ENABLED(q->fl=
ags))) {
		WARN_ONCE(1, "Trying to enqueue skb into the root of a taprio qdisc confi=
gured with full offload\n");
		return qdisc_drop(skb, sch, to_free);
	}

which may work, but it's so odd looking that it's just not worth the
trouble, I feel?=
