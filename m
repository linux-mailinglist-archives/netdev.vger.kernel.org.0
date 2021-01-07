Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4163C2EC80A
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 03:21:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbhAGCVI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 21:21:08 -0500
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:25293 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726293AbhAGCVI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 21:21:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1609986000;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7BKY15wF8aOwZdw6Jwti1+pccpFTzL/UrLD9CYYjYVo=;
        b=YA1zhSIUiLEcgCfSLNmptx0STsC4ZIUO/wKgd+C8GDbhISsE8llib2Ka1yjgoaRDR//eOg
        nuqDF09C4ClNENsScZ6SVa+Fgxaf+PWlbeUGDrXTTJBjqpo0QJ32mvV0cuW1AapxiFkhBj
        IFIjhTNmVyi+uYvr8U41+LmiMA7zn0U=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2050.outbound.protection.outlook.com [104.47.14.50]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-31-1OpirYzNNFuOBCSQ4r-nRg-1; Thu, 07 Jan 2021 03:17:28 +0100
X-MC-Unique: 1OpirYzNNFuOBCSQ4r-nRg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SlJkeTArAbBZap8L98aPDWolzlRSaytS7vqpF1ypSPVCCdHjm1d+Cb3Z/rrPGSQh9TaYlapYWga+2lf1gkcFc5DiOHLbPJp8DFfFE+iSBRzmr04Zxopy7n560dAxG625XF9kMBKy1PNorhUX7MeNFv7b2S7jOUQKFxvPrVv+r34zoQPLfKL4maosLHBPOxcgihLxMNazpWMlxqKSwx9iCA7RbnuyKzG+PFg1HQDA1CdUVUDopmBG2JdUtV/FrosdGrDMnxrIAbzwD/CDa2nkGwbNNYNjtIuvppO1ubM7PpwbVqDmBtsNm6+yYMfx2Oy8BSApCExpINpGEC++U+aetw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EtGbxeFGd5wrf0vUZRAXq5W++Pi5doTWbZ4QJ2ST5mA=;
 b=afp/Zb4Sx/4o2eSB+kLZEk6spOEV2qu5IOH+VUFapz2Ma8bJkDuG3MoZ1XA78RyqmvF6xU3Myy7qoCs4Pc65RYVmecdm+bBRqdGl3SBXS/2zvB8TdRsLY/eM4XEu44bgWqK6DXdU1sa2kXyH8YDLtERw3iPW91UA3nCNjkWpDeCI+b0T1DrF903TtA9mhG3shPIGQvx2VswmfPQG4KAHVDo/CalnoT8u7GcT3OmnCukp9Bz/sGcuRI/KNbqgjC/TWQVdTCAAO+xz9K8HhMk9/xyFJo/fXjK+5IkkJj235oTpoG0eyAZZs2OGCH0kV1M+ICu161c2mZx3OQ7tyJ5IGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com (2603:10a6:8:b::12)
 by DB7PR04MB5226.eurprd04.prod.outlook.com (2603:10a6:10:21::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.20; Thu, 7 Jan
 2021 02:17:27 +0000
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::80c9:1fa3:ae84:7313]) by DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::80c9:1fa3:ae84:7313%6]) with mapi id 15.20.3721.024; Thu, 7 Jan 2021
 02:17:27 +0000
From:   Gary Lin <glin@suse.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     Eric Dumazet <eric.dumazet@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        andreas.taschner@suse.com
Subject: [PATCH RESEND v2 2/3] test_bpf: remove EXPECTED_FAIL flag from bpf_fill_maxinsns11
Date:   Thu,  7 Jan 2021 10:17:00 +0800
Message-ID: <20210107021701.1797-3-glin@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107021701.1797-1-glin@suse.com>
References: <20210107021701.1797-1-glin@suse.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [111.240.141.15]
X-ClientProxiedBy: AM4P190CA0024.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::34) To DB3PR0402MB3641.eurprd04.prod.outlook.com
 (2603:10a6:8:b::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from GaryLaptop.prv.suse.net (111.240.141.15) by AM4P190CA0024.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:56::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Thu, 7 Jan 2021 02:17:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f87805c1-4933-41ab-b4bb-08d8b2b2610f
X-MS-TrafficTypeDiagnostic: DB7PR04MB5226:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB5226A531397183DAD2EF78CAA9AF0@DB7PR04MB5226.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1284;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9HyJUsppbKDaL7Sc3uFK/xDdd+GB6AlquSnBTQAQO52ypqr0NCpGOYO9alCNNYOpblVlFSNg3qoRD1LnRkH47DiXNaCl49cs3XSGkIxi49F879qS/IPXR29U908sdgpup3d9d39G08iP9KxlwdSIGaw4NdKtr3Dm/3QIoBKu+lM0a2Pf7/luw3zKsg+4LT7vhtpV9SnbC+xbSrxNErk7C49ahzA/pJepqSQDIKFAKtatXM0Gws6bUfWxXBTO+P+Cb+Z3r1pf4vuyo/nXN2UxZ1bQs3Ff6AUpKmg6w8Sfu+SUFCUDb3sH9nD7xQWegHMggRtEmsEumRSAJ6W57E3q4p+I5ABzyAX+jfi/JPgGkepb/X+do+YyDWvzNQEF440mMKX1Skq42BbOkTJoSa5mCQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB3PR0402MB3641.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(366004)(136003)(39850400004)(396003)(478600001)(8676002)(5660300002)(6512007)(54906003)(86362001)(2616005)(956004)(110136005)(4326008)(8936002)(316002)(107886003)(6486002)(36756003)(1076003)(83380400001)(66946007)(66556008)(6666004)(16526019)(2906002)(52116002)(186003)(6506007)(66476007)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?uTBo8KK3zZAHIx8QCqWDtYiXd1kx7WsYXb+ziKvuFpWEYwnV1b+wn3YEzOCn?=
 =?us-ascii?Q?CkTyyQu63YiFtYatmTqA3HERAuoIx/t+aw2SHB6vRqXXBEujxEmGANNCJtV1?=
 =?us-ascii?Q?HjQ4GTnzUq4rg1yPXa00v8Wfv3qcujaQmp4VmO0CDr/BBPc0fwxNrzCK2pIW?=
 =?us-ascii?Q?ZHB/VPnJSb4kL3s3cBJ60oKVlzMvPT1y/FcP6Sc//4aDSNPcR4Nw9T1ezvYg?=
 =?us-ascii?Q?3CGJM3feeT4Y2w8mt8LvpCkNdr5xUlCtJJK5hLvaj0EQIEQnK1LjG+8hRD3N?=
 =?us-ascii?Q?2cSXMhmP5TXMplAw8tlsjj0kzA97WqxutXTLAdb3IKPbkBCIecsfbe0Rdqe+?=
 =?us-ascii?Q?YY7T2S9icSQdpOqm2uyNqBl+6a889slBmA0HqRZb4T1uWEHOrP4/FcLu4vaM?=
 =?us-ascii?Q?pbrNcURPkv6Vx0jcyyKU4pIGjXxGbzwxqTOK0ds0iE5jnMMlc4Yxe7lrE3SD?=
 =?us-ascii?Q?KfDTRSr+Fb3MwHTD1jqWFNCeRqgHXOltWgXXXsuqN0Sz95/X0PpNLlZBZVKq?=
 =?us-ascii?Q?2JdCKoW35mpPZivM3/DP7nrXGtBqYXJSiE+jJ/TX4Wkye+iB8+Vzj/dNHKgz?=
 =?us-ascii?Q?AmShyOnYvGKLhvwj9YRxY7lFujkok6Ph5rsUOnzQ/k3lyQObRMS/ZA6KJmJW?=
 =?us-ascii?Q?fzSECCtAbY0L0DYcFtjKDfOd05BaMHVRiI+E4onKp6qJR7OajmR7np28qZHL?=
 =?us-ascii?Q?Vq5bVkApfwZRsdhrZpiFRLRac5TMTs8a5zcc8ujn7t0uywXbm7iqaFMXFQtz?=
 =?us-ascii?Q?noUE1wVHyrA9O0xD17CAVZQmyWwN7xxHtDzYP9OfVTAiipiKTNuhBV39cXY3?=
 =?us-ascii?Q?oMnGmdr6D3clpu7xKsPJRphu8GxsDtmtgyisT2qeYIPwktbJItv5db7uvajz?=
 =?us-ascii?Q?IUZc6CuvLfyAr8JAqJy9IzouH3Ibo2nWym9IfUlw8seogbE7PcZ77qgaGWw/?=
 =?us-ascii?Q?PlNIAMeGsLXw3fRRvFOJRZ1Wr3RwFtC1tGFlU02dSh4ZUu8N+Ty0mrTiIYqk?=
 =?us-ascii?Q?3Nqb?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthSource: DB3PR0402MB3641.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2021 02:17:27.4597
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-Network-Message-Id: f87805c1-4933-41ab-b4bb-08d8b2b2610f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GjHOb3HIC3j7Uy9N93+3yXMN6HktcivRe06fgN3BbDQrmEMf3jKPx+OfWAfB4SIG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5226
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

