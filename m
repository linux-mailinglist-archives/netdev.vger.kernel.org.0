Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D75D13B54FD
	for <lists+netdev@lfdr.de>; Sun, 27 Jun 2021 21:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231476AbhF0TOl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Jun 2021 15:14:41 -0400
Received: from mail-vi1eur05on2129.outbound.protection.outlook.com ([40.107.21.129]:24480
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231375AbhF0TOl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Jun 2021 15:14:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DI3lB8QuK86vdGNI4AP1zW47ZCwWBFnI4kRxbCjsUKzBLztgldOOAKz3MqRnLx08/sBG6UbJ7bm7cfw+zPo0ZOfmJhM0Sdq6ZLL4ET+vX70UwvM/qB9GHZ5Kf086AbCfPRvei4fqGASCHMVnS/mzunlfkStkg0tED8eekZ3c4QoQWpdx5P/hvVFTinldeTt9HSRB/MaDsv7FqlkRrA3AEmEYML1g8Unv+CyC2Byok7kl+xylolZv2uVOrjh2Af7QAkPxubJtWU1fVOsp/+uCnBk0XvIhX8ZbMPu/vG81eNgxZpv/jKAnKftG8iKKFvyv8LHtyLkS7+7UP2c71z+m2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kz/IupXG4n+GysJ9Sl/uEu9dgnSTTbHH6x3Xcbt3Rvs=;
 b=hFR/zBPE1VZz39YS+u4MCPC4kxTz44bWiXwMuZnhtsR7PV7Ud+NHy9TAmXvqLctsT5PsDOTa+qO9+7kltCCpjCnUIBmjcQXx/U3qz6vR035eNRCQv2Q29YA51NjPCoX5kYH9uimfHzzEDEz89huSZJOuMarkxyGhRycApR3rdQ2NAAmSPnuZvrDW+FbNwXtlOBO9GzCtlOh0KjpbZgpf1g4LUHE7LwhlrFyZN4kIzRIoBIxO/mbfLmqKtkMhswn/sseC3lAkHvKxe5sbYiC0fHhLm099d4NaGwiZPvekjJkQT74vjQKa02O78uiiP14Qq1r1Hs11cu5QqgrWyp/hcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=itu.dk; dmarc=pass action=none header.from=itu.dk; dkim=pass
 header.d=itu.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=itu.dk; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kz/IupXG4n+GysJ9Sl/uEu9dgnSTTbHH6x3Xcbt3Rvs=;
 b=JWFxZjQ6UO+nRe/I+QNHajQz4aOWj7jfey/mAEYiloW0W9GAE4TkiBM3IaSUI4YAWDuYIjLtJYQAdo8ZwVib2AWIogAQLlyBFCu/xUCHvTfLbrzPCqMqOqiSOrAyXO6NeNH1AVdAZqldipAtjGU3XI5LXgcAHFC8elJlN5BWFq2AvNi+reKfDGZ+5Mu1P+32DhxrCE2iMFotwfpv9nIUyBYzADBgWGx8jlslbgSsVihKhpfLqSNTxgPlau6RoUjG0CUGvaDGCxnvOLiL9wcJshV2aYQySDYFSp6t1ZyVjVunpTGQvlUWJ1sv/yzKdfZIXu0/XjijyegHKYL7xmJi7w==
Received: from AM0PR02MB5777.eurprd02.prod.outlook.com (2603:10a6:208:180::13)
 by AM9PR02MB7345.eurprd02.prod.outlook.com (2603:10a6:20b:3b6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.23; Sun, 27 Jun
 2021 19:12:13 +0000
Received: from AM0PR02MB5777.eurprd02.prod.outlook.com
 ([fe80::9832:7a6d:cf4e:d511]) by AM0PR02MB5777.eurprd02.prod.outlook.com
 ([fe80::9832:7a6d:cf4e:d511%9]) with mapi id 15.20.4264.026; Sun, 27 Jun 2021
 19:12:13 +0000
From:   Niclas Hedam <nhed@itu.dk>
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: sched: Add support for packet bursting.
Thread-Topic: [PATCH] net: sched: Add support for packet bursting.
Thread-Index: AQHXaboRq3ThYDzh+UOlN3JDzgVYqKsoMjKAgAALBYA=
Date:   Sun, 27 Jun 2021 19:12:13 +0000
Message-ID: <A5627177-BF51-46C5-99AD-E25357CC7617@itu.dk>
References: <0124A7CD-1C46-4BC2-A18C-9B03DD57B8B8@itu.dk>
 <CAM_iQpWC0arAJsY2Y+SKzYwaiyGDwQ61mopriEK9Q9EsPnwgTw@mail.gmail.com>
In-Reply-To: <CAM_iQpWC0arAJsY2Y+SKzYwaiyGDwQ61mopriEK9Q9EsPnwgTw@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=itu.dk;
x-originating-ip: [213.32.242.111]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8ab1c1b4-67c2-4cf5-5733-08d9399f78bb
x-ms-traffictypediagnostic: AM9PR02MB7345:
x-microsoft-antispam-prvs: <AM9PR02MB73457711B6CE2B630F44F5DEB4049@AM9PR02MB7345.eurprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:883;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +FvXp3ifDOkMhoroxkZbaNq3eAiWJZ+dxJ+4N1JToXQOPGfLceDqpkVucH5ZoDNxasWsNiPnczN1C03hp3TNIiq9a3GU09YhA8Qpj/MIm3VFXzBOeJvYj2lmhjh8IigRk6WrfRO5JyYPncyGLd31sxa/aNVW2GbKFz2I8/dbFxoqjaPtM6Yh+Z1U3RW02kbdI1+WH1hwkgZc+4ztyfeA02NYrLYZ9oDMdnnIrR7ge2QS1VvKjMY2/Zo7EJmB1UEOYqPvCVli3K2G9ddhdqEaNvFtGIiCHhLsX80PuiMKMG7GfvlVoGEo3a1TMOfRoPffEj48rK1/SBdv3++OgxaNMj2oDH6hPbRdA5KYSAb1J3L+LCud4qyJ34BTilWj5gYK/BCvSAqfbP2O+Bf4S3REdO7cBhQd+bWBVgg2dglFuZgG4SIDfz8W5OS91n7nZJMkt4/0MWSQL88+KgzU5Zc79ysSnIpLGAdRe4CLn1KrjCw9xvokQy7VsYmjVT0Yq4rx21kLTBdVP39tT+Fd1Mk85F29vH3PbSKX6ETti+mveyFkOJERlP3GS612ppNBPQCzx10yTDEakcHuNvbbGoCqD+B6PqZG9IHu+ZyaolSjOu/iwkIoeTnX8wkuzg+Wxy0s5PPtBSJDYEdV9zvIs+5vPQqiSrGxOtvmLUVnWA6sjX1rdRE7oUZxrytbOISpeophbiWoIx07FylzTVjUf2vIGw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR02MB5777.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(136003)(39840400004)(376002)(346002)(316002)(786003)(5660300002)(91956017)(33656002)(66446008)(478600001)(54906003)(66556008)(66476007)(2616005)(64756008)(83380400001)(76116006)(186003)(66946007)(36756003)(26005)(4326008)(2906002)(6512007)(122000001)(38100700002)(6916009)(6486002)(8936002)(8676002)(53546011)(86362001)(71200400001)(8976002)(6506007)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?DWKXEl59fD4lEL+wNbfTMN8pS/G8BY0MnRTuFD/jBCTx6bwX1lt25hif3Wm6?=
 =?us-ascii?Q?hGKkmyxC8owChLOVGiEnjIY4z0Skus2WZlCpOtR0TwZMyrKd02K5LjZrQ7Bx?=
 =?us-ascii?Q?zumIzmD+kiPma7alDaHDb0JVgJrdSoDOahyPpxXAtah/8uJnCp/z1kxXvfGt?=
 =?us-ascii?Q?WHqa5eyr+mUbNBLLS9/5DN8lIAcWMAoMg2V8a/VpJJ0s0cJE8xSHxrby3xe5?=
 =?us-ascii?Q?aG/+BR6mMDrywguHf0E2EnaP45hPX/yvzEamaSjSfQgyFyufvN+J6k7hrX26?=
 =?us-ascii?Q?tLTQ57hDz4O7QNvWOVntbS+G5gK83QK7GCIB8p6jqDb0Nl+ul9XjLXwI5xXr?=
 =?us-ascii?Q?MpMelNmJ9Rv/3MZlkhrUuxamilMrkheZwnQE2VV5ce9I9EO7mZgZFlCHxD5x?=
 =?us-ascii?Q?CyW761hnvfF5g1HMm4DXqBorDbHWFi8PC2wNiOQwaA/e+U9htzr+JfDxSrt7?=
 =?us-ascii?Q?uAqImBiVCyfS8lVXOyIFFMbJaGzY8VgK+5SOshqYspcCnPpZXXUwpnMzmVDC?=
 =?us-ascii?Q?6QqVBepI6/7W7CVp74fKNsTjVY765ZvcaelCaYSoELXuHgmyxLSmGcZxjrpw?=
 =?us-ascii?Q?hZgAKP6l7SlHIbYQ4Emp0Y4D5QKe41iMEmkqCnzn+iO8xR2ZOuk8kNoS9FJj?=
 =?us-ascii?Q?fUkvZZ5jB04+lyyL3MuHcs21EUtYkljDZRdeJk504I7PRaGOxTmQynpxgJBZ?=
 =?us-ascii?Q?Wn3/dDxN/YWTGkiR0yDzVkJS4vpKlL+NAfWMcdSq+nxNDCD4F604O7HDpSr9?=
 =?us-ascii?Q?yXF4mwLbf8QI9DRiu1jLM1LkiIyBQhmosjMZoVOIZ3nVDb7bda+u7wxchoxv?=
 =?us-ascii?Q?3Ww74zkLLBOLV8mc8r8uB9+h2rJLGBf+WJfMtPiSjP+w385cjsoLXnNF73Vr?=
 =?us-ascii?Q?iTrtqe5yoQUkl5WoogEiTM7E/PaH95ACNXJLn5d9r7VCtk9umQ85H4npJg9B?=
 =?us-ascii?Q?2hhXFxWlZePQT/fwj+5n3UjOSyjr3x6wF+LbRVZ+IOKCiXcDO+pIAMrQOzcK?=
 =?us-ascii?Q?OVbrIqCtNlLTuB0ABqR/YJMC457CG0l/+mWnLYyyGbC0TI355zTajNroLsIh?=
 =?us-ascii?Q?fRwluqq41jAAYGzqg0lXvW1IZm/ew4MpDndr9uyip6R8HDHI24aDE3wLaCCO?=
 =?us-ascii?Q?VK7bQR5YO9Eh8lYSgSuvuJAcDjNcS8855+K4z+oo185LK1l8/ubBRXV099vF?=
 =?us-ascii?Q?F4hon9RIrK0t78B03lQNawAe5INaPtK96JMfCi40buW46ku4Exx5FvGeTdfY?=
 =?us-ascii?Q?LLKT6anlguiFfbQUqVPaI+UIv6Bol6nnj/iMnWhtSD1cSCXREFyYOf2wzTbQ?=
 =?us-ascii?Q?mTVn5oMmZPvZggODJ6RNuGpu?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <13D1E0957C6D544D9E8EB3171E4D6096@eurprd02.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: itu.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR02MB5777.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ab1c1b4-67c2-4cf5-5733-08d9399f78bb
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2021 19:12:13.6717
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bea229b6-7a08-4086-b44c-71f57f716bdb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UGVZ7+xbyWmg2oDKzSqv/40lDp/LOqfghgQJMp7YcD2iCQFyEJoY0Y5JM3/kYuqW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR02MB7345
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Cong,

Good point.
Here is a new patch.

From 71843907bdb9cdc4e24358f0c16a8778f2762dc7 Mon Sep 17 00:00:00 2001
From: Niclas Hedam <nhed@itu.dk>
Date: Fri, 25 Jun 2021 13:37:18 +0200
Subject: [PATCH] net: sched: Add support for packet bursting.

This commit implements packet bursting in the NetEm scheduler.
This allows system administrators to hold back outgoing
packets and release them at a multiple of a time quantum.
This feature can be used to prevent timing attacks caused
by network latency.

Signed-off-by: Niclas Hedam <niclas@hed.am>
---
 include/uapi/linux/pkt_sched.h |  2 ++
 net/sched/sch_netem.c          | 24 +++++++++++++++++++++---
 2 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.=
h
index 79a699f106b1..1ba49f141dae 100644
--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -603,6 +603,7 @@ enum {
 	TCA_NETEM_JITTER64,
 	TCA_NETEM_SLOT,
 	TCA_NETEM_SLOT_DIST,
+        TCA_NETEM_BURSTING,
 	__TCA_NETEM_MAX,
 };

@@ -615,6 +616,7 @@ struct tc_netem_qopt {
 	__u32	gap;		/* re-ordering gap (0 for none) */
 	__u32   duplicate;	/* random packet dup  (0=3Dnone ~0=3D100%) */
 	__u32	jitter;		/* random jitter in latency (us) */
+	__u32	bursting;	/* send packets in bursts (us) */
 };

 struct tc_netem_corr {
diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index 0c345e43a09a..52d796287b86 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -85,6 +85,7 @@ struct netem_sched_data {
 	s64 latency;
 	s64 jitter;

+	u32 bursting;
 	u32 loss;
 	u32 ecn;
 	u32 limit;
@@ -467,7 +468,7 @@ static int netem_enqueue(struct sk_buff *skb, struct Qd=
isc *sch,
 	/* If a delay is expected, orphan the skb. (orphaning usually takes
 	 * place at TX completion time, so _before_ the link transit delay)
 	 */
-	if (q->latency || q->jitter || q->rate)
+	if (q->latency || q->jitter || q->rate || q->bursting)
 		skb_orphan_partial(skb);

 	/*
@@ -527,8 +528,17 @@ static int netem_enqueue(struct sk_buff *skb, struct Q=
disc *sch,
 	qdisc_qstats_backlog_inc(sch, skb);

 	cb =3D netem_skb_cb(skb);
-	if (q->gap =3D=3D 0 ||		/* not doing reordering */
-	    q->counter < q->gap - 1 ||	/* inside last reordering gap */
+	if (q->bursting > 0) {
+		u64 now;
+
+		now =3D ktime_get_ns();
+
+		cb->time_to_send =3D now - (now % q->bursting) + q->bursting;
+
+		++q->counter;
+		tfifo_enqueue(skb, sch);
+	} else if (q->gap =3D=3D 0 ||		/* not doing reordering */
+	    q->counter < q->gap - 1 ||		/* inside last reordering gap */
 	    q->reorder < get_crandom(&q->reorder_cor)) {
 		u64 now;
 		s64 delay;
@@ -927,6 +937,7 @@ static const struct nla_policy netem_policy[TCA_NETEM_M=
AX + 1] =3D {
 	[TCA_NETEM_ECN]		=3D { .type =3D NLA_U32 },
 	[TCA_NETEM_RATE64]	=3D { .type =3D NLA_U64 },
 	[TCA_NETEM_LATENCY64]	=3D { .type =3D NLA_S64 },
+	[TCA_NETEM_BURSTING]	=3D { .type =3D NLA_U64 },
 	[TCA_NETEM_JITTER64]	=3D { .type =3D NLA_S64 },
 	[TCA_NETEM_SLOT]	=3D { .len =3D sizeof(struct tc_netem_slot) },
 };
@@ -1001,6 +1012,7 @@ static int netem_change(struct Qdisc *sch, struct nla=
ttr *opt,

 	q->latency =3D PSCHED_TICKS2NS(qopt->latency);
 	q->jitter =3D PSCHED_TICKS2NS(qopt->jitter);
+	q->bursting =3D PSCHED_TICKS2NS(qopt->bursting);
 	q->limit =3D qopt->limit;
 	q->gap =3D qopt->gap;
 	q->counter =3D 0;
@@ -1032,6 +1044,9 @@ static int netem_change(struct Qdisc *sch, struct nla=
ttr *opt,
 	if (tb[TCA_NETEM_LATENCY64])
 		q->latency =3D nla_get_s64(tb[TCA_NETEM_LATENCY64]);

+	if (tb[TCA_NETEM_BURSTING])
+		q->bursting =3D nla_get_u64(tb[TCA_NETEM_BURSTING]);
+
 	if (tb[TCA_NETEM_JITTER64])
 		q->jitter =3D nla_get_s64(tb[TCA_NETEM_JITTER64]);

@@ -1150,6 +1165,9 @@ static int netem_dump(struct Qdisc *sch, struct sk_bu=
ff *skb)
 			     UINT_MAX);
 	qopt.jitter =3D min_t(psched_tdiff_t, PSCHED_NS2TICKS(q->jitter),
 			    UINT_MAX);
+	qopt.bursting =3D min_t(psched_tdiff_t, PSCHED_NS2TICKS(q->bursting),
+			    UINT_MAX);
+
 	qopt.limit =3D q->limit;
 	qopt.loss =3D q->loss;
 	qopt.gap =3D q->gap;
--
2.25.1

> On 27 Jun 2021, at 20:32, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>=20
> On Fri, Jun 25, 2021 at 5:03 AM Niclas Hedam <nhed@itu.dk> wrote:
>> diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sch=
ed.h
>> index 79a699f106b1..826d1dee6601 100644
>> --- a/include/uapi/linux/pkt_sched.h
>> +++ b/include/uapi/linux/pkt_sched.h
>> @@ -594,6 +594,7 @@ enum {
>>        TCA_NETEM_DELAY_DIST,
>>        TCA_NETEM_REORDER,
>>        TCA_NETEM_CORRUPT,
>> +       TCA_NETEM_BURSTING,
>>        TCA_NETEM_LOSS,
>>        TCA_NETEM_RATE,
>>        TCA_NETEM_ECN,
>=20
> You can't add a new enum in the middle, as it is UAPI.
>=20
> Thanks.

