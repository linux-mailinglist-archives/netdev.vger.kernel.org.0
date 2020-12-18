Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE512DDF3D
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 08:51:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732680AbgLRHuy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 02:50:54 -0500
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:28166 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732318AbgLRHux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 02:50:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1608277784;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7BKY15wF8aOwZdw6Jwti1+pccpFTzL/UrLD9CYYjYVo=;
        b=C13Szwdp4Hd9OM5MBQz2x63Klana84FPTpPIsNPwUOrF5cqyAfeu26a29jsuaQ4N0EF30A
        kMcl8ONqOfKfWKu8m6+fQMigfjrU1QJYXlsm2W5iFMqMQrDl11G94D0Nwr9mlFnxcAZi9R
        ycPDpxBk7dksnTqGBcJSpWnZkv1wb80=
Received: from EUR03-AM5-obe.outbound.protection.outlook.com
 (mail-am5eur03lp2058.outbound.protection.outlook.com [104.47.8.58]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-32-h-0-iC0rOZmcgl4OGpoBuQ-3; Fri, 18 Dec 2020 08:49:42 +0100
X-MC-Unique: h-0-iC0rOZmcgl4OGpoBuQ-3
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jOARkGXChtoLlmrxeFb4WCHuFEy1gitvf4b7KZRXQoprqQhR6vBjsYmIgUMVtcZtJkz7o1xY7UyIkjvr5vkKJDiYnisJkmiN1iAkCyOwEpqzKX3sDZb2YZwjwUZXwGM+7iujCJyagGQv/FsjgeK/hABNZqMAfPEojtEZTOWmWgRpVap2XTd4z1yjcr6914ByRcQL//vE7YvAdOy1fjp08vWF54YH9Syoji4elS50wZaXVgWmkzXRL6IDHrr4GldUi+/gBBEpV0GfgM+5n9vbRYAtrKO/cYrBHkFBWowV5CLS+txS4RWB7pocgcXiaNah7FVQohvjIrxT9hfBmCTriQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EtGbxeFGd5wrf0vUZRAXq5W++Pi5doTWbZ4QJ2ST5mA=;
 b=ItymLN/XOHHO5tMKtIMnv9FbP8REHMmKKPFOzkfYm3EBsFXS+r/03STnnFRWIhOVlhvNvXXw2Fo2O6qr5ay3FLocQ1Zu7KAFHVIIYQTBDM4b0yuDTHAPzE64MQXJ1RQmh1WZE48p2WatuDTrL3m4oncgQ6xC//ZqPJXSykztxL3n1JhIF8yr3rhxO33blL67t6fMGN6+RTyRgds4XtozfdfewDrnWjni8NI3oJ1JB3KVtCXSyDwjQirhc1KYHT+FoHl9XzeWB0rGHR+qFYOvJi4ltt6wAUdibc9hwnTqLfq2RiTDDt1PYdHrA4+cvKUUcUEz8d/gjxUOhfCq5bj5sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com (2603:10a6:8:b::12)
 by DB8PR04MB5755.eurprd04.prod.outlook.com (2603:10a6:10:ac::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.15; Fri, 18 Dec
 2020 07:49:37 +0000
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::80c9:1fa3:ae84:7313]) by DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::80c9:1fa3:ae84:7313%6]) with mapi id 15.20.3676.025; Fri, 18 Dec 2020
 07:49:37 +0000
From:   Gary Lin <glin@suse.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        andreas.taschner@suse.com
Subject: [PATCH v2 2/3] test_bpf: remove EXPECTED_FAIL flag from bpf_fill_maxinsns11
Date:   Fri, 18 Dec 2020 15:49:14 +0800
Message-ID: <20201218074915.22242-3-glin@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201218074915.22242-1-glin@suse.com>
References: <20201218074915.22242-1-glin@suse.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [36.227.5.136]
X-ClientProxiedBy: AM0PR10CA0037.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::17) To DB3PR0402MB3641.eurprd04.prod.outlook.com
 (2603:10a6:8:b::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from GaryLaptop.prv.suse.net (36.227.5.136) by AM0PR10CA0037.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.28 via Frontend Transport; Fri, 18 Dec 2020 07:49:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b08d823f-c09c-4824-b378-08d8a3297839
X-MS-TrafficTypeDiagnostic: DB8PR04MB5755:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB5755404EF75288EDA8794D52A9C30@DB8PR04MB5755.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1284;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ebGXR0VYqc2+O9n6HGzBtyuCSVs0z7NnwL77gklf8nWXumj45hxlU9cGLqgNRsd9Z1qN1n1tseZdI8zhL71nIavmq7CKKztC4FcyLfMvURRVmAP5xSeZIP/C5U+MZVAXQ0AiTW6RZCKPBfAlx0TIyYaA4U6NzXeUNCAFn37H7eN67c7vWJNwS2z+vv9D2OXDJkFdx2rW3n2wn6Rm+EU7RwTtL7D8tvMRDi48QJAprzQ/V3llzqdyr0vE+24Fo+YfP9KIJa0h1zK5lErjoGgygffOU82Rf5CPZj2hjEp3MuHQjXs6DxbqoooYPNFt/lUK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB3PR0402MB3641.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(39860400002)(396003)(376002)(346002)(6506007)(83380400001)(956004)(54906003)(66556008)(66946007)(52116002)(186003)(2906002)(66476007)(2616005)(26005)(8936002)(107886003)(86362001)(1076003)(16526019)(6486002)(4326008)(8676002)(6512007)(5660300002)(6666004)(478600001)(316002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?YLvAPvstXgx08TuP03GLvWR7ZLbBGt/gS2W0ElPxv9xQiBSS0U88Ud+QfgsT?=
 =?us-ascii?Q?H8oTi/mrQX94mXnbB9XKoBjcbK4HHFHx8z/AFslfds2EkWSwtxqNICJllwzT?=
 =?us-ascii?Q?IaCmJQl3Kgb0oSeQH5Ln6LfTxp3S7gban+uhogT8Yt4smcV7IXWMhY79WN74?=
 =?us-ascii?Q?jgIyQOYxSIzCEpZ6PZrsoP3Mg0yhkET3950I3j9N+EiAc0ZuMwUQDjELCc5Z?=
 =?us-ascii?Q?jrA3BPZKnUY5D/BlRgcmZo5Vr/WGQC8lTwHsjSoeNYDA8H06lg3lIlTpZo0x?=
 =?us-ascii?Q?Zhr0zCGOiDwaEm5Fzxq2Nm4l3Hj+LClDFJVkDJ3Fo6ZV7n9nuw8oayCDfdgL?=
 =?us-ascii?Q?/QUXU3fYkcntl0RvdUJkFFpDIbqo2C2XmlnBb80FniBYXQR79t5BLWf0e8On?=
 =?us-ascii?Q?KOoQ8F3Kwrsky1Bz+5QzqemkpRyuv9zqUHIm9GUtl0sUONRZmhk0/2YScwWc?=
 =?us-ascii?Q?tzUgRFXV8/+RstSBsaav101t6RnyVwCktH/C08aKOHVuDnz2I7cNhOBStG8I?=
 =?us-ascii?Q?zVux59gObrDus3QLoU92VD3lB3JLHPst2hLcEzE0cKy7O3mxOzAajJfZCHN0?=
 =?us-ascii?Q?tpnI4ACeHhe45p17GLP5UFylCoYXYLL1444P5TykhShpnTccL1yVDJ7yN9RV?=
 =?us-ascii?Q?oOHiaPgfLnYAHBTLBNf8Lg5oWR/mpS5wdXIlVP1f5IevMZDdSffvvDJMjCRb?=
 =?us-ascii?Q?IV7ikCC4cA/J+y4Rs3ptpIgNyrWcN7ynUbEbaXeLxSVIfb4O5uheaXkZ4SXw?=
 =?us-ascii?Q?MHXRz2GGw8DLCHncP0clrGymUgeVzL7+813GG1XD2Xf4gk9rNNfbWfY606Hz?=
 =?us-ascii?Q?LH8Fj65G8XSPsL3YJUsm9Vde3L1C+9HRCPGZRu0kGQeXJ80Cswm2KroyInfo?=
 =?us-ascii?Q?DkCpGnppvp34kUfuP/Ojo1sTbcDT+Vc22qk1PpMm8F30wO06vqRcFgfltrV0?=
 =?us-ascii?Q?82ePBCT6sep6qf2cqSCREsVIIiCSr4kplvnRSHTo2U4=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthSource: DB3PR0402MB3641.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2020 07:49:37.7380
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-Network-Message-Id: b08d823f-c09c-4824-b378-08d8a3297839
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L7wohqcOApv2dtpNY3+y1gEXdzJxOjFAMUa3Nj+0aD30+WutpNyZ9vV8NxAWBq9I
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5755
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With NOPs padding, x64 jit now can handle the jump cases like
bpf_fill_maxinsns11().

Signed-off-by: Gary Lin <glin@suse.com>
---
 lib/test_bpf.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index ca7d635bccd9..272a9fd143ab 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -345,7 +345,7 @@ static int __bpf_fill_ja(struct bpf_test *self, unsigne=
d int len,
=20
 static int bpf_fill_maxinsns11(struct bpf_test *self)
 {
-	/* Hits 70 passes on x86_64, so cannot get JITed there. */
+	/* Hits 70 passes on x86_64 and triggers NOPs padding. */
 	return __bpf_fill_ja(self, BPF_MAXINSNS, 68);
 }
=20
@@ -5318,15 +5318,10 @@ static struct bpf_test tests[] =3D {
 	{
 		"BPF_MAXINSNS: Jump, gap, jump, ...",
 		{ },
-#if defined(CONFIG_BPF_JIT_ALWAYS_ON) && defined(CONFIG_X86)
-		CLASSIC | FLAG_NO_DATA | FLAG_EXPECTED_FAIL,
-#else
 		CLASSIC | FLAG_NO_DATA,
-#endif
 		{ },
 		{ { 0, 0xababcbac } },
 		.fill_helper =3D bpf_fill_maxinsns11,
-		.expected_errcode =3D -ENOTSUPP,
 	},
 	{
 		"BPF_MAXINSNS: jump over MSH",
--=20
2.29.2

