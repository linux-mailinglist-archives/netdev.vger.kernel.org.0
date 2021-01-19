Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE2EF2FC570
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 01:14:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405929AbhASNtC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 08:49:02 -0500
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:52172 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390569AbhASKa0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 05:30:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1611052140;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yB0csRxSD99waBXb/MVj7U+cqmbggdEYvS9+OCXQWwk=;
        b=aMxZh1TtHvxxZMu5/Hc2oSe3zTLVpF8fen5PvKfIzo7x5ebYp1DF7UlCYrnhrvlcJmplAb
        CUElKfxZIGe4m+5ypuxsHOFl9tvp4+g92VIEPd5EnNNPr+4fiXI6T/7ahhNysbAHGJz/Rp
        jU+gUzFY9GyKd9Ocxt3hiKw6WmZBNhA=
Received: from EUR02-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur02lp2050.outbound.protection.outlook.com [104.47.6.50]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-14-CisVifiaMNmnz6RFdfTYyg-2; Tue, 19 Jan 2021 11:25:32 +0100
X-MC-Unique: CisVifiaMNmnz6RFdfTYyg-2
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=STE8qbTl0sMHEmaaqYRG5OqKJGFyxuiNUvE6VdXdo1n9cU1Z/WITepEnGuJ3tuR8hFQ92/KmqTvPnnEsPPLTRrIfNbzQqiCpFwVj77724VLrgZEtrrtl/sbaapNhtm5S0qSZg4T3kHI0DlLk+nfZ9OsIo5WyQktBacgoz3V6Uc+fzobsf47DD1JQIXoIKBIOKMa2FyctkLGnjsBLyFRjDy3wzD8vT0jF63D79TNKbKncW+0KBY6+I8ewVQdpusYoryiibF/Qccx5obEZnsXmjWuqUH0ZlVoPJn0jQxd1bmXcVB8MhOmJmQikPCA3z5dDH3rKur3QPty+uT/KdMl4rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EiPEfNmnPGyGHDv9RJ4rOy1Wt8uwYiAlb4GTKbKYxP8=;
 b=a/7XPFh4Clns2D4sc2KV71RLxSWLd6Jzco8vTJ2dxjhRwNwgpsphl9tk+m0f5OtoxcF7zLNK6ujzBd1/xZkI9YKW4XPVcvJ4Z/8WAAlSHPWBUOjqs7HAJbfa1sfi/DyQgKBIXOpGb9znxL7i3cY66au07eM0qYAgWMDl6D3zval8r/WkCOSpdxpXtVwNKymUP4uFNU+aoTTNBjq5S313aZvbyKdxbuxYUm+Zl68UcOsqoyyPqmnE1qTDIpqv4AmTZ7+1WQwRNPcq9S0PAV6XyEP6GVAo9f/mP6BP6/L7pf7rz+CBEfm5M1jW76EVWmGuAnFpv7iSJKfFf4SrGoBcxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com (2603:10a6:8:b::12)
 by DB6PR04MB3109.eurprd04.prod.outlook.com (2603:10a6:6:f::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3763.14; Tue, 19 Jan 2021 10:25:30 +0000
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::80c9:1fa3:ae84:7313]) by DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::80c9:1fa3:ae84:7313%6]) with mapi id 15.20.3763.014; Tue, 19 Jan 2021
 10:25:30 +0000
From:   Gary Lin <glin@suse.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     Eric Dumazet <eric.dumazet@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        andreas.taschner@suse.com
Subject: [PATCH v4 2/3] test_bpf: remove EXPECTED_FAIL flag from bpf_fill_maxinsns11
Date:   Tue, 19 Jan 2021 18:25:00 +0800
Message-ID: <20210119102501.511-3-glin@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210119102501.511-1-glin@suse.com>
References: <20210119102501.511-1-glin@suse.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [111.240.113.126]
X-ClientProxiedBy: FR2P281CA0023.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:14::10) To DB3PR0402MB3641.eurprd04.prod.outlook.com
 (2603:10a6:8:b::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from GaryLaptop.prv.suse.net (111.240.113.126) by FR2P281CA0023.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:14::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.6 via Frontend Transport; Tue, 19 Jan 2021 10:25:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d1c8b0b7-a330-4335-af37-08d8bc648bcb
X-MS-TrafficTypeDiagnostic: DB6PR04MB3109:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR04MB31094FFC305FE7A5EB3647DBA9A30@DB6PR04MB3109.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1284;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /Yf2etPIq2ZazqosfLaocxPHhTPr82JrAgkN92GmU+dw5h2yOiMgIG/CdcYQtJOUQX0ZDteXXTu0+adyuyBJmPOMthaA5Zb5ERwL3H62zvjbYNuFlQqGp+4bnR8hSPkbMt98mrr0LqRzgQ/h0PQ2t0GSQFnlRUSTqBgDZtjk36FoRKbnnBMIAXKRkQCkGemyNYzca7v2k2BddJkcGORj1tsNnIcmSn2E0HQqYOONss6nUkgrZAmGzO9cZMCrceLT17GSB6CngCtDDpLubqPMbtz4yR6xW+Jivy5zlqXtHef6xH2z8sfDX4xu19TR3YyQJb8ki4KdzbQCp7kHcXCJjUJU8XErQwy66v/1vYJQ0muT9zvzh96GzESY1dqIZ2ItuxQ4iqEray9afem3H5cV/w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB3PR0402MB3641.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(136003)(376002)(366004)(346002)(83380400001)(1076003)(186003)(26005)(6486002)(52116002)(316002)(956004)(16526019)(6512007)(6506007)(4326008)(107886003)(8676002)(5660300002)(36756003)(66556008)(2906002)(8936002)(66946007)(66476007)(86362001)(2616005)(478600001)(110136005)(6666004)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?rQptqlvNQyid0pXjaGoN26lH/plhx/Xo3gVEjuRZMAG3EiSPJ1a/bg/2JLa3?=
 =?us-ascii?Q?zd4+bcP4yBFs7QD/APVTdM9SrBdmQxEwk1aRTMpL2NgiQ4lk+nKBBeoMtpYp?=
 =?us-ascii?Q?Szigtk3sMmZPOJx4SpbCcchu32UpIQvlhANW4Rpx3lRBeAG8Fw6fDNR3FkHr?=
 =?us-ascii?Q?JiGXZTrIxsYiyVJS47zPDxhM52kzvx8JpOR6pswrVFTXd6Vg7ilTWB3xHFZp?=
 =?us-ascii?Q?n18ll8EHDmqcPHKceXxAJNB3pwv5q/eUcc1bED+h7IhYYdUx2vHKuqzq/Xij?=
 =?us-ascii?Q?mVKWSkQVZCaRI61ExE/lLyvKPX59Luamnky4k6kfjpZDBJg7EUx0iAKoy+kn?=
 =?us-ascii?Q?SCgmNHrQK6F43h80cdHo93Y79q9ygEo/Emkw1PLIrHf7imKluw6Pe7fkm8mS?=
 =?us-ascii?Q?Ux0VqS1ATTij2wo07N3nerraV8rqqD2kLSZDD4TCgs6Ma76ANucqzLGfGUU6?=
 =?us-ascii?Q?PfEOohHnH42QsLFDdAuJugqoUb/eX39e44u1yUp9/UQQzWeiGlHcaLdGvdFi?=
 =?us-ascii?Q?MOkfluGHDH5CNKibUgtBQPfbH3avgyo8zoc2gtom7xaRBraMKkvfoJScph7Q?=
 =?us-ascii?Q?KzK6vTDefVVq+sjZ3ntA8GHZfNA07w9VkX+Law+CkWpHsGlCGvm1LkxZFGLZ?=
 =?us-ascii?Q?xofGuaX/wFJM7aXiMQg0y6hCb1e8/4dwse/9SrlDzuX61tWrufrJJeijfNFr?=
 =?us-ascii?Q?DNL1REUtU+qcmkLBk7ZQqFKQvTdjgWvtPcqxAiN7VFQEZ1IaXxzLjIpkYm/M?=
 =?us-ascii?Q?l1yVgFZ9JosqB+16zM9/ociTdHgDZQmLLtFxqXihFWCcxyHgY88rE+Y572Rd?=
 =?us-ascii?Q?PT1kKlTzcX/BX5q1LXKeNJ4pUofOzDm7WhGbh9OeI5TGcbIVrfB3xg5xcMnA?=
 =?us-ascii?Q?qUPcRuJQwxU+ZHjjn3F5UZI1ebTob/HAk8mR5wK7DoppwP2eWKHJTwHxXfjS?=
 =?us-ascii?Q?JUdBL/WaFxT7+hgNnSHZqwk8E0eH6AIbQllhc7faQNkMlc1SXdCJmlg8MDEC?=
 =?us-ascii?Q?A2Dj?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1c8b0b7-a330-4335-af37-08d8bc648bcb
X-MS-Exchange-CrossTenant-AuthSource: DB3PR0402MB3641.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2021 10:25:30.5745
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fkv1Y4+zi5qkD26nKGISpsYFDXGxXkjacdj5otRFIgcKPvuGWTGL8rM8mT0w0g5V
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR04MB3109
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
index 49ec9e8d8aed..4dc4dcbecd12 100644
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

