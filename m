Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E452F3B5D1B
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 13:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232802AbhF1L2L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 07:28:11 -0400
Received: from mail-vi1eur05on2102.outbound.protection.outlook.com ([40.107.21.102]:22880
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232767AbhF1L2K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Jun 2021 07:28:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PeNxFcSEm0nwvIOhY6HOYp2WFtMFEa5OPkovXDs28K/m1M6hhtzCiDDd+XmPdDMTytsLkmqX0XuIjqi9KfTFRc1e83pliXcxYALkpGVSs2J9WECml+A0FFKG9dW5eR4HYM6hnWd5NHO6TYj9v3vIjKxUfvfSE9NcotD1yAyyysypeqXmF7ayJ0lJXqWcYPm+qmma4rbrZQY1QWNM6moKc4/S02msmcGraaOJczn7PxZ6bY2sTzDJWGUFCmA2OjAIZy1n+lahNcER5IKppY4LeMzBUi7b0s+xWdNrW11GRd7eA40QQOXry4uBgUBHitMqHnK32rebR68dHH2pn3SKiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jrHVxbNMMQ/Tsf2Dswko8vpdg7UDqV4Q53KVkaIrZ50=;
 b=ezFRhKVftWhpwS6laD6FT7oZm1ScxcdZd5gdPyK2lZIqO4SMwvgCAmxfhS2kBfeStSKMKbOGESIjb7CDchwvgSMtPxihfGYRrHwrnXYNRUX4ZGpMa23C0rNejC5elKcultSwAI3ILSCT9I65CQWTawBvsGpiwrkwkgTw1MaEZxypE4GYB7Uh4pa61M8MP+W7hpIrl2ac70OJY7mbS43TeWxWqp5C8iUXi/ExxkPNYBpgLwrsTawrco8FD5ehj6CpLzGfseFYOeLADl1zpOqoSpEKczOrH0eUMOE2PI2+QopKzFcBKSJJDZF9gOhgFb4mt7ne+H1hDc+9uo6grt0GGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=itu.dk; dmarc=pass action=none header.from=itu.dk; dkim=pass
 header.d=itu.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=itu.dk; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jrHVxbNMMQ/Tsf2Dswko8vpdg7UDqV4Q53KVkaIrZ50=;
 b=KIwd5dTQ7iRxWHymDlW86ejeGUgxXZA3IAY72BgYFBbWC2eZzTAE6sK0Ib2C2AuDjpR7sn/Vo2I1sgl0VpUQy/GMuoRMd4SD5THXOnHxpwZyXIwp8M5x6dZ4d/6d9hxW8kSKx8Yj0aK318oQJ9un24YEHs70uO2yt8y6kgov4OC4m0jjXBRjADvgZizq0I0CYE1Dbp0bGPto+wEHJ6GjvsDIqX3J1eDTdKF264z63Yder6OHjtxemPOjF9+gzlmVY+vK470uQM3SBgecJJNEUtqkBVqfXrsphVIrM395Xgv3B4gi1TbP8LMmZrvayNuuX8FbHJfqeyVn2ObLmuQrDw==
Received: from AM0PR02MB5777.eurprd02.prod.outlook.com (2603:10a6:208:180::13)
 by AM0PR02MB5202.eurprd02.prod.outlook.com (2603:10a6:208:100::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.20; Mon, 28 Jun
 2021 11:25:41 +0000
Received: from AM0PR02MB5777.eurprd02.prod.outlook.com
 ([fe80::9832:7a6d:cf4e:d511]) by AM0PR02MB5777.eurprd02.prod.outlook.com
 ([fe80::9832:7a6d:cf4e:d511%9]) with mapi id 15.20.4264.026; Mon, 28 Jun 2021
 11:25:41 +0000
From:   Niclas Hedam <nhed@itu.dk>
To:     "stephen@networkplumber.org" <stephen@networkplumber.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH v2] net: sched: Add support for packet bursting.
Thread-Topic: [PATCH v2] net: sched: Add support for packet bursting.
Thread-Index: AQHXbBBTiYdTK7SBI0G27l9pUjSwVQ==
Date:   Mon, 28 Jun 2021 11:25:41 +0000
Message-ID: <532A8EEC-59FD-42F2-8568-4C649677B4B0@itu.dk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=none action=none header.from=itu.dk;
x-originating-ip: [130.226.132.10]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ae369b67-47a4-4410-feba-08d93a277675
x-ms-traffictypediagnostic: AM0PR02MB5202:
x-microsoft-antispam-prvs: <AM0PR02MB5202BD99772EBEED89F1C849B4039@AM0PR02MB5202.eurprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1850;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WIQaeCaVlWuxjBibCUlq1fKgF9u/uXsiDGixwgzLNX1LsuwH/gBXJ/RNdn5PNemk8sVNmEdVCse2mYm6f0WczRIUXph5qEefgh4S+6cjUQWV0Ci4B+9O4MJmNN9QHkAMRiuoH+ltA3v+7udbc9jX8FweJ2Y/FJS3+AARsrwFM/siY9q31I22yh7wTZKQF/GP8NEKGaRQbfPRgMuc3VHs0VP/k9c4VRoBAGGk5jWAtnga3ZhmiIHFbY6VvM4XdOvOwhPqyJqW612kp3LWSwoeJEvujSJJjGAcqK7mgMeVdZOqRJLfZJici0TfqzeJStI6cMR+kqyl75/CImRRGb2ko+o1972R6meRYXgzjFGjRMYEuT4QMFJx5V46iPaEkRZwo9zc73wlnF3+Xm/BNvUU3hH93T0sxNwhIt/YHaha2AnZplmyHfbXPSfSgaELGO8FCiRJEJR1q36/1gT3TaaJH8mAptF72+IDUSTtxrcic3bmla0WcCPQf+pLFoyDDfY1tWVXP0sYSi6QQ/f77K6t7JaKztNyl87QfERELgST0PYxqwfRCASychMY9HSbKA8elfvxT8djgC3WGKjC/QvevZUgK5ecwVFMQ+syQSdSgrb0s+FyGbpTlojPEl+2AhCFSLrY3QS1B/QhybTrXKmzOJXwOxKJuBPfW8QM9+jZLTy9MLHbHm8O8yMLSGM3he32OsEzREEOt2IepV2CBpUf2Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR02MB5777.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39840400004)(396003)(346002)(136003)(366004)(64756008)(316002)(53546011)(66946007)(6506007)(66556008)(86362001)(33656002)(6486002)(5660300002)(2906002)(36756003)(786003)(66476007)(6916009)(66446008)(76116006)(26005)(122000001)(83380400001)(91956017)(71200400001)(186003)(6512007)(478600001)(8936002)(8676002)(38100700002)(8976002)(4326008)(2616005)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?R41DXBF27w8nkWZ+EZZUajzGaR2BUYJb5Q2yFHEo9XP0PnVo2fIsseel1rFr?=
 =?us-ascii?Q?P0ckvd/5ymmfTw0awCJGJBdnvrKhYPurApZCrmFfRjxbqYJjj4fVp6Yf8bJR?=
 =?us-ascii?Q?m/A45cYDK+mcrbUSUGpduQD1xmkoCyHWbvrsHpmD7q6DJv3d03ED6XDtZIwc?=
 =?us-ascii?Q?PsChqkmXyhxUqRzfJjcT3XJ2QPJ6VTbdiVi/FTC/HvgzGumifcl1ZGTiLSxf?=
 =?us-ascii?Q?7HJlWpBvM3sLCKVP9L6pKHLZ6Hesy3I9w/UQd5qyk86B62D/KguniLsrbjym?=
 =?us-ascii?Q?eHyzIMEw1Un+9zoun/iNeg5n239P/PUcDzYX/jn2YtuCG8Zbo6Zxucqvq+Vc?=
 =?us-ascii?Q?7KIwLraQEi7uaRxcJYUBCmbXfaUafIW61MKSXBAWYW1qiFmyP1+5U2KvTXNg?=
 =?us-ascii?Q?DfHafagiiGLoxAjP5xO1PoYx/rw+KbbB+/IaNSwCNIzNshZRD6rh+NZFAXb+?=
 =?us-ascii?Q?hH8EFTvoXqmVgClJuwQGM3x2mX7NxC2/4ndw4UJ4voYKhMfYpWtlDcXWNhtL?=
 =?us-ascii?Q?MG+p7VOiuhcNTkIE/C3eq/rEPe3/rps92qP3CrVoQoYJeuWxuVGC2YFAolsL?=
 =?us-ascii?Q?z0JRrMqx93psv1i9h60qZ7anq6wwQo8LAe0PjibR4USPFxn7kxJgQnTrfR96?=
 =?us-ascii?Q?nqjiUJP//4mf0xuGdQzwYfHHd+K04fbInbObEyNONMW6nVVqu/OkXo7XSMPo?=
 =?us-ascii?Q?F7v6RvxKi/fzwLgRPAiC7nVUnWbNE0OdIhNeVAvXhnT3y5h+p92TaTovJkT8?=
 =?us-ascii?Q?tVCbLKEZScHXUi0bY26/w0eTS9RsxwH5wqNlc0NJXw1h4sP/2OmSvyLUZytt?=
 =?us-ascii?Q?z7QTfdVae0p/MRAIhZ5uVaJPwfEecvp7ZEPoiwfH6ZxtUMb8XskpTsXEliHf?=
 =?us-ascii?Q?UqCz/wYDI2525GmoUasHrihwrJYC0hHrX6RWNmYiS4rDqN5wC6vpxJ0soW2O?=
 =?us-ascii?Q?w3xhdfm7Lms8NSDsI1UveSwJ/i40VUdNwuTr6ToQLVZuX+HY8lGjOBIEmG7J?=
 =?us-ascii?Q?5483cdTGvwhKM0mlsHk/9qJ1ff1ce2pWRVDfDkUZYW8K1fDwwsDEWHZfmiCD?=
 =?us-ascii?Q?dfAyxEZm1NCoLI+Y2L7KcTDH9Gov36MGD9Dkxz7jAIAYfRKV7olnClhurSuA?=
 =?us-ascii?Q?qQ8Dppq+pf4xyDiXB2FvpzeeGfMdmu/lrJjy/9/yIArB6NXttfEaMeIrD2sw?=
 =?us-ascii?Q?dtzV55d9mRFNJuiH6OEoqjJzDU+pMr7xzR0RhgRRlzT1NhmhPZajFIGx2p23?=
 =?us-ascii?Q?Lila3mvwGg2fAsuHFqei5+FY1lSNOJLOCFFQfEq9rK1pB/UcyvPt1NO1T+uk?=
 =?us-ascii?Q?lPIcf6/B/t2trJxxLaxLB6/k?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <431683225A31A844B294F2006EE3F7DA@eurprd02.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: itu.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR02MB5777.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae369b67-47a4-4410-feba-08d93a277675
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2021 11:25:41.4180
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bea229b6-7a08-4086-b44c-71f57f716bdb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fiPO0gfKxO/Pzqy10F+BlUDs4WLMQl5hktwrDIKQ3FjOrL+1iO/Hzb05QGKqAGb7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR02MB5202
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From 71843907bdb9cdc4e24358f0c16a8778f2762dc7 Mon Sep 17 00:00:00 2001
From: Niclas Hedam <nhed@itu.dk>
Date: Fri, 25 Jun 2021 13:37:18 +0200
Subject: [PATCH] net: sched: Add support for packet bursting.

This commit implements packet bursting in the NetEm scheduler.
This allows system administrators to hold back outgoing
packets and release them at a multiple of a time quantum.
This feature can be used to prevent timing attacks caused
by network latency.

Signed-off-by: Niclas Hedam <nhed@itu.dk>
---
v2: add enum at end of list (Cong Wang)
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
2.25.1=
