Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C636E2F5E25
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 10:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728395AbhANJzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 04:55:54 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:47562 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728043AbhANJzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 04:55:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1610618080;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7BKY15wF8aOwZdw6Jwti1+pccpFTzL/UrLD9CYYjYVo=;
        b=WWB53pLiBWVwi9Eg4BZThiNa6mpi69PtNcP/ZrIjYC8kP/8Z7kX8A7eIbC8g/7vgWYAiDI
        Cfgtqq7Mt8cmS5beSLC2rvdcC9PiFs2XILdx2AFwbfk6MYq+2tHUjFTSG30Yg3VfEkZgK2
        2kUXTDHI6X1YYZOk7mA/lxCO3BCZmn0=
Received: from EUR03-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur03lp2058.outbound.protection.outlook.com [104.47.9.58]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-35-Ghh6-pguNtWOlCPwo3LU2Q-2; Thu, 14 Jan 2021 10:54:39 +0100
X-MC-Unique: Ghh6-pguNtWOlCPwo3LU2Q-2
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gJC+fXa/KPOMiI9PlwESLbL7thjF3oW1EW7eUj+tfl6X32yLMR0cBMlD4kGKQh4AONNv5i7P7aZp81F0uX2SwjMtSBqRPlaOOlcO9jtDSunrSw8Iz49MbqfMlY3Ev2oVaX//iL1tzFnzLLNjfNzcPCL7GPVeLrDny2LjYgK9iXTPuN0dFcs8VnhgeWQ5RU/Z7qMmR9yw9HfCsRVI+3oZye7OqUp2C8XnDyxjdkdaCJ+x5vg4oG1J3VXqjPggJYnctqfSC+J5g5clZd2EK5ns2H2iNn6aR8JFKotQhIUUD1h5NnwaXr5wAd1uiz47RELJN3oFvuJtbteT4bDxPayMSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EtGbxeFGd5wrf0vUZRAXq5W++Pi5doTWbZ4QJ2ST5mA=;
 b=dyZ5F8FaE00oMmrinYwmN/DDaWTQ/GXjNTAjXG4N0sKaasZRVit2W9wOg1tORwTRcJsI11miQ5+CkeXmzhGK/uDIKbVBXvjGqxgNU7XGrlGFPk9k0o8vU2gle/FufoyO7Az46kP6Pw+IQTGZ6A4PxdaYzTfdlqrsygG6zd2DIjQdkrHOmp7wASKFfCUyXH88i4UNw6BLeV9KJXbSVmiIy/klOgKQN109JKfcEydAgCrQWVHpuRK4TqMI+qL3wxTj9Tg0e5GAiQkgoqQe9SWjjXgHUod7kinGXcWBXfbET+SnaS0mUze29OFRhThD+zMHvlqYgUdXmmxwcpdwxfSN3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com (2603:10a6:8:b::12)
 by DBBPR04MB6153.eurprd04.prod.outlook.com (2603:10a6:10:d2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.12; Thu, 14 Jan
 2021 09:54:35 +0000
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::80c9:1fa3:ae84:7313]) by DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::80c9:1fa3:ae84:7313%6]) with mapi id 15.20.3763.011; Thu, 14 Jan 2021
 09:54:35 +0000
From:   Gary Lin <glin@suse.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     Eric Dumazet <eric.dumazet@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        andreas.taschner@suse.com
Subject: [PATCH v3 2/3] test_bpf: remove EXPECTED_FAIL flag from bpf_fill_maxinsns11
Date:   Thu, 14 Jan 2021 17:54:10 +0800
Message-ID: <20210114095411.20903-3-glin@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210114095411.20903-1-glin@suse.com>
References: <20210114095411.20903-1-glin@suse.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [111.240.145.171]
X-ClientProxiedBy: AM0PR10CA0111.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::28) To DB3PR0402MB3641.eurprd04.prod.outlook.com
 (2603:10a6:8:b::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from GaryLaptop.prv.suse.net (111.240.145.171) by AM0PR10CA0111.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:e6::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Thu, 14 Jan 2021 09:54:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c57fced-c0f3-4ddb-ccc5-08d8b8726681
X-MS-TrafficTypeDiagnostic: DBBPR04MB6153:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBBPR04MB6153FE48AE5D1E5D75571CE7A9A80@DBBPR04MB6153.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1284;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oYtwp3Oiun8806eBPcyX3Es2oPmt3TK93vw77TRxNRVHcDrI8StdbJpfyPfhuZCaSFxG1BhzFTqBLmNXD/eJgac+SlCiuMYCHNvI5Qh+1HWJNQ3e6Bjs7j9AvVI2hzO4oNQ1izXh30JHbI5g9CdwnUT0+b85zanYXLyDe6hx+g8PYAYtJFS/fEBm+/ZBNhcC0qWN3uaHf0jhNqVbgN3ReYDEpX0F7AJ3pdBkcEEJG8mR2iYcgOsVVGdoUYImOV5NlpEaXgq9FSnG1Ja0y6fIfEAY16HiXGcospUFc2OfQl621R0xn7B5Ffj8mWsGXPwW1N8SkjwGCTiHv/FsqI7BnddcktsQ66Pty8Ftm8Pa2JasLqrTWNg3S/rw7mcqLisJzhx9TjbOfcJWO15YGF5LgQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB3PR0402MB3641.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(346002)(396003)(39860400002)(366004)(316002)(83380400001)(1076003)(6486002)(2906002)(478600001)(52116002)(8676002)(5660300002)(186003)(110136005)(4326008)(107886003)(36756003)(6666004)(8936002)(16526019)(6506007)(66946007)(6512007)(956004)(26005)(2616005)(66476007)(54906003)(86362001)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?vQAu3ZZ4xImlRhUAuE/rJO7tJq3Xy4kiAUUkRGTeStRa/4arrvQ07zxIlmF1?=
 =?us-ascii?Q?Vh+e8VLs//6fb41CjEZP30VB2tBBfr5OuTsPUZo/CVLmx5llS37a2tUwHgwL?=
 =?us-ascii?Q?xWHI6tvg945r9zUDkMn8N9BqWlW3xSgfkDCMvOHwAuTPM218P5sZTz0YaYTx?=
 =?us-ascii?Q?YRuVZ2mYfmpqyFqQOoExTWQM1ATrpxS21Sp85LTRrunouww2gImBppr/EVCN?=
 =?us-ascii?Q?qwnKvVfRJ8j6mSKFhQISDcitROcHDADUuAjMfNjzqwCkVj5Lg4n3jAPAhy5s?=
 =?us-ascii?Q?0hesZDDEhdjZHtzh0yTRVRHhwNwhCdJsIc/W296eZkpdEY8JokyevxueZ4h4?=
 =?us-ascii?Q?oB57p46UcyipO6rOUdeO38wxEVtKsxjAdtDjxlyB2mrRk84vrbNSyQa0AplV?=
 =?us-ascii?Q?x7c3yC+EP6d3lggDMyXBlEeiQtzzJV2DmGWaVfjyc1hJ63lV5hAV3/aOaETN?=
 =?us-ascii?Q?21rdCiQ/0e03JtjDw4F84tgPsTdHQU1I0R6cfyE5Z3VvKTtLQScl11num3yx?=
 =?us-ascii?Q?oZy0ntF638owUQD5n/EEVsaIFvkVY5i/HnTFZSK/ojhPejf4SJKOvx66dFsl?=
 =?us-ascii?Q?J9ueq5DZm3JdrmlRSFGyAAcZ12qGQHOIoAk1qwyZKkFb8zl8t0c3qDGdR7zO?=
 =?us-ascii?Q?pm2fRPw4KwtGaqMegDF0uJmnVbYG9ocwGgGpIenebEghT4eolQF8kA5HqH/R?=
 =?us-ascii?Q?OAmCDIzWZs7lVGaigCsATdvZzbxGcmDyNh3AF5VCg6zHHO3Z2OGOMfvNXhpa?=
 =?us-ascii?Q?97Cg8j1FWDZP4KgsMOiXamxCkYNCOdYv6kI0ppYvCGEKXaRl86X6oFnPLgR+?=
 =?us-ascii?Q?r91RjOEHJDFfhyd3Hprcu4OUNtyrss23mJMM05tS40CTRJqEqqB/RuWyItvw?=
 =?us-ascii?Q?pjlaWAN3Y3z8S46ZwY2WifYkNRuU36of3coEO4myHq8CC7W8fVc0+ysbVV6G?=
 =?us-ascii?Q?jufThdr/YhvycPKM+jASe9bnG+vVpRuWJmpyIVYn4BC1hVrbhjm7M+5DRvZj?=
 =?us-ascii?Q?6LIw?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthSource: DB3PR0402MB3641.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2021 09:54:35.7281
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c57fced-c0f3-4ddb-ccc5-08d8b8726681
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oWL6dcT6qRUIaqziicw2+CGECE9hKjbGa+uupnK0z4uI6Bm+9varsAAwlUCEgH56
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB6153
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

