Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5C8646D23F
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 12:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232504AbhLHLh6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 06:37:58 -0500
Received: from mail-eopbgr1300137.outbound.protection.outlook.com ([40.107.130.137]:64864
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229573AbhLHLh6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 06:37:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R+BZq3uwl5ahVFhKJosuBKdkukR4hpHf93AVCZLdfTlHl66Kf6GeYFYUZFnoNaf6q/JT61WTXw9EZ62bi6cdbyR+PaRn7KHzHxDNKxnvxJOD9lEGnx8xJGKjVofH0LQ5PV9UyCpBYZJOthVRl5k4Rikm8oKtvrmvo6QsqCB44FrkRpJYuK1KcEuGUZvq9TSUJKvepDX8MCTRpyAd1k3dwYamPpOTtLCEIBxV2Wkn5+YWaNQxi4qg2PxWPeQMQoB+wz5dDt6D6D6y+oOoUW3XvhyYovQN4W6lrTkR5gECXBuyQn9FAALsY2Uvsv/ME+Md7Vp/7cCMECy83sXO7CwKzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OhgBK/pYdBRXkopsbRoww7w6CTB4gpilqzOv95+9JNA=;
 b=nqgqaWwhHVCK8zTlgQ+WE/Bg3EcsG9d2LDNlnbjSvlcBKWO2x1AL0WE+5+pcDwNm0oE4CKxhMPi/0ilmT/N95VBSLFYVghETmHmw5EVp7FeqL5Kbl8WnW5iux3uFXHvtmp+sWGIYIjQ1ic6VrTEKIJeKvfNbfB/dm1PKTcQVD4f4C3qczaUgtEQr7cGJaB+HFhqDiIB6i0KZcVjYeArp5sQqusIF2FkTufdKDeiof7FafC8uEUul60aYA7pLFVMQjJfzapgN72PAnYCF25tRM26bfg4u3lQztZe69MM1DiYxL0ZXzTWpJU1KjX2Buqr57zK+yUKMmsEYE/5tolwX8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OhgBK/pYdBRXkopsbRoww7w6CTB4gpilqzOv95+9JNA=;
 b=oE2hWMJlHJ6L0cMYyavXxuD98EqpZ5NyLjv3tfUCNL7I2xGqVbwPbLnzc2Jjgnjfe/Z7aIOCTcMN+07Dj1jpcIi4+dO3XSYQpyDcnjhmijVIzMS7TFuHdjXVB5ypZokRZQ3mn5eA5Grt+PNBN2g3LUMw02jaBWQ+ceq8Ae1cIOk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from TYZPR06MB4173.apcprd06.prod.outlook.com (2603:1096:400:26::14)
 by TY2PR06MB2655.apcprd06.prod.outlook.com (2603:1096:404:35::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.16; Wed, 8 Dec
 2021 11:34:23 +0000
Received: from TYZPR06MB4173.apcprd06.prod.outlook.com
 ([fe80::6093:831:2123:6092]) by TYZPR06MB4173.apcprd06.prod.outlook.com
 ([fe80::6093:831:2123:6092%8]) with mapi id 15.20.4755.023; Wed, 8 Dec 2021
 11:34:23 +0000
From:   Yihao Han <hanyihao@vivo.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     kernel@vivo.com, Yihao Han <hanyihao@vivo.com>
Subject: [PATCH] samples/bpf: fix swap.cocci warning
Date:   Wed,  8 Dec 2021 03:34:07 -0800
Message-Id: <20211208113408.45237-1-hanyihao@vivo.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: HK2PR04CA0046.apcprd04.prod.outlook.com
 (2603:1096:202:14::14) To TYZPR06MB4173.apcprd06.prod.outlook.com
 (2603:1096:400:26::14)
MIME-Version: 1.0
Received: from ubuntu.vivo.xyz (218.213.202.189) by HK2PR04CA0046.apcprd04.prod.outlook.com (2603:1096:202:14::14) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Wed, 8 Dec 2021 11:34:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ef4aa9e4-0558-46c3-4f91-08d9ba3eaebd
X-MS-TrafficTypeDiagnostic: TY2PR06MB2655:EE_
X-Microsoft-Antispam-PRVS: <TY2PR06MB2655E58C228BDA68C93100FAA26F9@TY2PR06MB2655.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1079;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +9BZGS7FT1U6nLAS+RU86DcEXmeOO11TYaaTBjROdHcrFl84ycX9FVnwteqlIUjaiS6yfL9Bav+E5QISPDCnq1N7/wHAfwImUriL3UWJtd4R4bgmpLyzwi+54fRgqzMatDjGfy8iJh3pPIVDAT4CdoT0n5s1+bVpepKKAIKQQ/1hVQZYUMPl7tbqlUe3C3n8SJUsz3REXBDnzXYtSjxL+/gO0z6hOTHSGH8/ad0iRsVqIdBBNA1w0qVc4EC1x9lF9r7hY8V7ZRb28O2GIfRWP2zAauBPzbNUiBysLfaPfvF8ltG/hNvZn71Hvs1tv0lpbiwMjVEtjcIjUeYD7i6zsyO/GVGmOPPfAy8UewTwg7jo7Gnei2soTooAkcO2K8te5DyWC35STgEFb+5SGDth7pl2jV78RZ12Bl8h2f3qXQgnPkL15IiuKxFbJGosDIPNTuQbA9jiBcjknrkc4gJdwHbVlAhxXsEasjYI9PdWQ9xfuZZtE94tUSKKUbYo6CwwIhzRKlaVXzNggfgBLX46hW+398DBWKgOKjRTp8JEcSzQwAwGfSfMGcS/uW+conWZNWXxaiw4MnVGNo5hInd3PWELTZgogg+aASjVX1mu0DTNhzuY3cKSxxbXQmWg2yMOYZLyeCKrMZ83Cz33KpcfVuU0H+iZyDdHhHipRRb80DG37SjC7YcaNlVrGqUG3FLwVOEFqkkONmOWOeoj5fHiPmYcafhN8sVrdBp7+WharINcVAp3YDd+QBKskS2jFPRw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYZPR06MB4173.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(921005)(7416002)(6486002)(6512007)(38100700002)(8676002)(6506007)(4744005)(36756003)(186003)(2906002)(26005)(2616005)(38350700002)(86362001)(66556008)(66946007)(66476007)(956004)(107886003)(4326008)(508600001)(5660300002)(316002)(6666004)(8936002)(1076003)(110136005)(83380400001)(52116002)(182500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oUJhKhdLIdkkjkIWvt7CMraKzORPxTPu3DZsKCYDDGuk0y5Q6nnv8ih+W1sY?=
 =?us-ascii?Q?n3uTTxgibvf+f8Cp62Nz9cpkM0IwUxlvi7dQ0GkCYcJlktpA2OkS3lwhrivb?=
 =?us-ascii?Q?oa2BJuYF9NA//Bg0VusGhyZo+hHBjMipuQknku6P58Wm+J9kjVrM/wevRHHO?=
 =?us-ascii?Q?ePArgEXreKIx+xEqEa8EpkwR1NApBS3cW7Pf5FP9PKQ9iO1qzR/1KRgKt8Qh?=
 =?us-ascii?Q?vit7zDx6P1oz111HzoixaUfcKFHBXXnNHF9nll/PQqxNnQpT4eEw10amvPUW?=
 =?us-ascii?Q?BpmCjZ2KuTLrHJSlyqc+dre2BtgKQKVb/2B7zvVwXZO9h70IGazDV0ROG2A7?=
 =?us-ascii?Q?D2poO21WFL5j4CdgvbzUWeCb+xffxPQtjfLZ3y96sDjIILffra/oO/uIVsLq?=
 =?us-ascii?Q?h6kY01OH/Wu/vV/3gWrYJvEVYu7F3/GqLda3GMHsNvRVBTByseKVzJUGFgfU?=
 =?us-ascii?Q?7LYV3UCJ1610V1gk7d2Qi4/G2j1Gh14py3OegI+ro8ciiC+hgZCq3szfwymX?=
 =?us-ascii?Q?fpxMZXXp2OQPfrc9ZsO9/weEXIh7Rlod2wkwh15emN+2/QUbfGHMu8b9NYm8?=
 =?us-ascii?Q?wAKH4MK/RFuJe+k7C+80XFUx4oZFASHUEbxZ/h0oL5DyyK3SEszD8jhmkTDd?=
 =?us-ascii?Q?15sxvhXRQanin8QIzuc13FhHEgSbfPYJLPhA1eLTy94KLal0buaLS4U4r/UT?=
 =?us-ascii?Q?fxdmy5oS7L2pY4JBy6NRfmb+J5Uzt1fHKTfB79cqs/OkfTWg9bIWJMYmQ9VA?=
 =?us-ascii?Q?rTTzdR67yeO/TYsNm/4CQntJofuADhXp4tIHlUUms4br8EKm4CrBGCjZb64s?=
 =?us-ascii?Q?6AqN5HqlJYZoQgoxSUKJJr2+SL3z2ukNqT+meE6fr0Ge18TwAtJjENb20eHl?=
 =?us-ascii?Q?Y6XuMSAU4Hb1kNFx6S+CZO7G89PIHyQreECjwXbmuqNfJ+jZgP2hB08tfM7D?=
 =?us-ascii?Q?n5pA+gJ0uqMtkGsgXh1NFUMvTahrk/jdTtxBgf5qB+cbmM0Cu6FcEoYwW2cT?=
 =?us-ascii?Q?5EoddfJseu68+yUepPuw0fLv/KjRY/11tRr4qb9/fDQUgwpqsbWt1xFA5H3t?=
 =?us-ascii?Q?1qtfwqhojNBCl7i6RxrmBfo4WZgHa6mW5V5Gou27ZHqxRSPLDzuWo6iUeUM9?=
 =?us-ascii?Q?K3cwsX7pHe7KbeEiOH+3XzL1AgP4PBtnWQQvC0xfDn1Q7nAm7QaAXb91hCxa?=
 =?us-ascii?Q?cDCxaO+g3pndXwKHX5QEYJpcznjZ9/yOk3BPGsg61VV+yoHyOnkXv8dDYIWf?=
 =?us-ascii?Q?6+/gdPOEE+XtlxYQB3cH5fqhGee2J1LZF4II4QAEj0PNgOlGZSmu5H9wbatX?=
 =?us-ascii?Q?iXUi+knZmW+sbCf5mwYBMmlhcXS4BmzF0bpeeB9QcTxzSDQP8PTQCiSDx7w/?=
 =?us-ascii?Q?EIjc0rQksepXMJEkYu18etOSXyfSmQ3zSOvGROxsliqww4psV2D0lQXu1h4n?=
 =?us-ascii?Q?nWzmEz6kNyt9IMKLZd9vNSY8+Mu0HG4Stbj4qvMIIHsIzjHY6Vm4Dw/SptTG?=
 =?us-ascii?Q?JzYLlJHrempE+bioOxPmEf1gwXhZBYhbxILrWF7wFBEH8DEsaceF6Up9efEY?=
 =?us-ascii?Q?1Upb4/O543JCbIR/VEW5IQAHN2+WaIvOnFp22+1DhCgh4feKWHuranVhRv0x?=
 =?us-ascii?Q?YTRiWV1yEWHu6IcermV7Wss=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef4aa9e4-0558-46c3-4f91-08d9ba3eaebd
X-MS-Exchange-CrossTenant-AuthSource: TYZPR06MB4173.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2021 11:34:23.3470
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 42h26rvQmzyj0lWD9D2u1ZZ1+Cz7hRS1nOn9Uva/yxCT1IVmQEfFvyXfAbZExyGQvJ1ksvF8PQTV7o4Y5mE6Dw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PR06MB2655
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix following swap.cocci warning:
./samples/bpf/xsk_fwd.c:660:22-23:
WARNING opportunity for swap()

Signed-off-by: Yihao Han <hanyihao@vivo.com>
---
 samples/bpf/xsk_fwd.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/samples/bpf/xsk_fwd.c b/samples/bpf/xsk_fwd.c
index 1cd97c84c337..e82582b225d3 100644
--- a/samples/bpf/xsk_fwd.c
+++ b/samples/bpf/xsk_fwd.c
@@ -653,9 +653,7 @@ static void swap_mac_addresses(void *data)
 	struct ether_addr *dst_addr = (struct ether_addr *)&eth->ether_dhost;
 	struct ether_addr tmp;
 
-	tmp = *src_addr;
-	*src_addr = *dst_addr;
-	*dst_addr = tmp;
+	swap(*src_addr, *dst_addr);
 }
 
 static void *
-- 
2.17.1

