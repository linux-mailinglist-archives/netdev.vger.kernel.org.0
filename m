Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 012A5429B88
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 04:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231652AbhJLCeu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 22:34:50 -0400
Received: from mail-eopbgr1320099.outbound.protection.outlook.com ([40.107.132.99]:64903
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230362AbhJLCet (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Oct 2021 22:34:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ctZMCBCyfMAouG+fCfRZAR1jKa7L6kDwBQxemIcmY7t6iDPeptRIbfqlFi2685j/ZVH9L6u3kxnGyToBEkePJ4bHr9PXJOvs+S6q9+C+unmAuafNoNmxBwbSIGJbnWwXF0jF9kypTANGFAF1fGn27DKEwVxNQ20fqS9yXWBDfRINWKZhe3RN1Riaw2dRpntzMmtOunwgu+nxbKfSAge2aeecx4GQWc6ma2u2nBjIJDnjUueurV1ewugN41H2sxxWhjNh0TGOkOFzKWQJVm+lMeH8nuiAOq1HTXIcxAJQVVQVaZmMHnejOcrg6f8JVwnO/pjcQ/ouKlngN5ORS+YGnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EvApJGgKqShxGzk4OlDWBSlVv4WPa4knfg9HDu76pNg=;
 b=bO3IHpDkIizN0jrv+PdTkuvD/9/eA0UoARmofUlKYbwavkxCPAkHI00Ktm2dbTNHabzvs9leNuOuK4fD5bFgCIM7P6KJwk4ZoxY9uzjknoxfnbwZ75KIZOdqh1B+xUOag2S5+TN4BnyRMjDpNiNGDEsMHSXf5qhrv4sWTKzJ8kluFEb038op+qPRb4ESahpRh39sUHkqdm7+dzFx9tMDfIZJur2LZ2un21gYcVRVeO+lCXBMWnh0gk3Hk2QGk1ss+lZ/3besNC6W6xcWxcz7rlroHFLwf4Mbar0RKhmr+pREBuEGJO0YIMYrdtpN+CCsywS912bnnZb3ig9RQoe5JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EvApJGgKqShxGzk4OlDWBSlVv4WPa4knfg9HDu76pNg=;
 b=eTt2jjXCFSp6aRNeWgIVjC+gfWNDlPOV3XD/Yu4O0t4Q19KSiVeNaqiLkNPEn/kEMMWlpY5YHPmNSPaxc9/DK+XXvweF11ybgDPDapgByfg5ElbyZsXCWpPGoEBzlTY3Uco2GzApbuSanW8spPVL0EpQbdK5DTQ8vfRDrI7eQR0=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=vivo.com;
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com (2603:1096:4:78::19) by
 SG2PR0601MB1838.apcprd06.prod.outlook.com (2603:1096:3:8::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.24; Tue, 12 Oct 2021 02:32:42 +0000
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::fc12:4e1b:cc77:6c0]) by SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::fc12:4e1b:cc77:6c0%6]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 02:32:42 +0000
From:   Wan Jiabing <wanjiabing@vivo.com>
To:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kael_w@yeah.net, Wan Jiabing <wanjiabing@vivo.com>
Subject: [PATCH] [v2] selftests: bpf: Remove duplicated include in cgroup_helpers
Date:   Tue, 12 Oct 2021 10:32:30 +0800
Message-Id: <20211012023231.19911-1-wanjiabing@vivo.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HK2P15301CA0013.APCP153.PROD.OUTLOOK.COM
 (2603:1096:202:1::23) To SG2PR06MB3367.apcprd06.prod.outlook.com
 (2603:1096:4:78::19)
MIME-Version: 1.0
Received: from NJ-11126903.vivo.xyz (203.90.234.87) by HK2P15301CA0013.APCP153.PROD.OUTLOOK.COM (2603:1096:202:1::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.1 via Frontend Transport; Tue, 12 Oct 2021 02:32:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b4d85a6b-48b0-42a7-d102-08d98d2890e1
X-MS-TrafficTypeDiagnostic: SG2PR0601MB1838:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SG2PR0601MB1838ACEAED42F4ED8D3C2977ABB69@SG2PR0601MB1838.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:110;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EevLQXP0mhXx9jSLmmd0g0KBWpxnAk6v48+zi7dSOjLQ7yJE4+gNY9N/f0hL7wXoHiiTPzJLQPZvghUPTH6zb6tS8daRAMJbPDCFsXqGPPEpMpactKfFL+NBX4BA+Lq3ek26E6qyP2QdGSo5RPAg+v5HoLF1C26ynInXquJmIwYQrX/jtzv+sR+0WhITBhvlDiHI5uzQNNQ21rn+GBYmgGojzsgcW4cu6+3AOpYkJ2CGb1HuPkFstQFz259X6QZojXtOX36OuPe5yEQwAr25MHIcGTQU4uq72hLr1Bl8AyFCcK0hitGFiwF6NDc2qSaXKNW2bvzjxP0m9udUfRf8VfGBLBDak9EFgNHvoOEez6FFssfi1IytTRlYOWsHI3SFy7ngIkCzkLA6iDPsgoU6ZMAD9atRDdEJVRmheQud0Dgs+I6BTC2cpRLO+QxOyAJ7U5nNziYnq5wMwSId2dydY//9+p2ObDsczfx2sx3IfdE7OzrTUKQzXii9P5q/tIFBfsgOP4OFMEBkCGrYoiUp1TSIGg6dp8q4LpYUwGfnY0kFY8/uAxJDJx7Dc0JEC8soyer4BM3CwVqzthNmlrSWesw/I9bfBdJszUg75F19vFzYYbxMDe8cbSBHEI7l+bYIOCR2jvASNjDn3G0Z9DgzwNRR0OBT3/7EdrtGzjEjrE3m+tCHyQAkL8bgeca6Af/1b75VFwBjasxvqgteetiq6u8IAsgLSQtHGbB8Eqm8r9ecbtvzJE1w4HkZyjL0y0ZJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2PR06MB3367.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(86362001)(2616005)(508600001)(8676002)(956004)(6666004)(38350700002)(38100700002)(107886003)(83380400001)(1076003)(6512007)(6486002)(4744005)(921005)(5660300002)(7416002)(4326008)(26005)(316002)(110136005)(36756003)(66476007)(6506007)(66556008)(52116002)(2906002)(66946007)(186003)(4730100016);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MBBXFYl9G0FvjnOfCjofYh7HBZWQtCmayc7NhZgwLdqPkNVqXmiVr+3Ex2wV?=
 =?us-ascii?Q?1tp7AZ8rhkCk4U6ZehHvIRwmkTcrip8OPgl3Z8kavP0oJAJoHviO/mOQ8kJk?=
 =?us-ascii?Q?JVVOQf4Amb+PWS734ZR8xgQ7BJb+AbX1DbRq32YPNmcI5acPKsFOmyeDkVZi?=
 =?us-ascii?Q?eHVnTFahFH8aY1lk+8/ueZsqoUIv+02BIaezOSpaleDyJvW8xWUDL2b+dFYA?=
 =?us-ascii?Q?DcgCH5gf/VMYKgCFsJUCJoHToj250Aj6bRUJV++xKv8pWKdPd6DDrWmbroDy?=
 =?us-ascii?Q?EEJt9I09f0RYhK7O00qCnSWpZGmhicd6/EWrlgAOuZH64VGaKMuXX2Km2ElJ?=
 =?us-ascii?Q?8vXc0iCKVORnZufwb3the8F6ON0z1TdXDrmcKPM27bHDiyGZuaiObqhwWhIk?=
 =?us-ascii?Q?aPj/AT3swwkfSfniOD+CoqaLQV68rwbEUqaVYopXciEpXP4uYxbTqRmgMeik?=
 =?us-ascii?Q?I95v+FCrYAnczeMxEOmOnhRZepZoJDkCpBkCezcpLLETTU8yN+JT4c46OMfB?=
 =?us-ascii?Q?8kQk3BZhB6YWNaFHTrctuwBWol3WnMvj3YDSJRom7PtsklpRslO/47ZHS3TJ?=
 =?us-ascii?Q?JjM/Z7RPVOa1K4Ne/GIjB6rYlr3acGVYj46+RMiVAicMKr04sXZfGgk4Lm0h?=
 =?us-ascii?Q?gEHgkD83Dx0mBgxNM4W8NylWnQfruX1P4xQrooexnrAaYQ6hmws0RaxfliBP?=
 =?us-ascii?Q?xiNKogi6J6DHpmufeEt+lSOIjaKoQB2/K42IaRfkSNXs6q5tc7iyNoOJVTHw?=
 =?us-ascii?Q?puffPzKX2YXCvZSf9XEp9+yxRoyljAMruW+0BHZcb5purLVPjV9Rs5ZhfjoX?=
 =?us-ascii?Q?jYj0A6q1pZOq3upX6Vfyt37liVgEO4TRfdknFWepvxdPsPl7u3gSiyPgTkgP?=
 =?us-ascii?Q?rnmxBltAOkQ5MhSYD/8q2CFkTrNKeRGndWlR3Bh4mGhFP4dXOXcFrLMB6KJV?=
 =?us-ascii?Q?lxcF+SuvqwPL1Wuh19Jqm/pkPYTGWNJZgSWsMl8eJ0lP4xEjYU3y11nXxS3N?=
 =?us-ascii?Q?JqyHCJjTa+h/i8r4cuoRiqF9fziFLpEXeJ4HicpasH5w/+buV752K5kf6KKf?=
 =?us-ascii?Q?Cp0OTdG9W8cMZUQknvZhM1JvvzKmZZZmx2Cs20YL9JRcKN1GAsBPYWsqWEsJ?=
 =?us-ascii?Q?PSUeQX1gM4GigQM+mDeNwLmcD+egQUL5D/VUh3NTVpstGJ1BX3ZbUYGGJS1a?=
 =?us-ascii?Q?W+9D/2nWMupn0ePOBZfpEx6sNEarXm14TUTwTUvaBcj9lfJd4GUrjfl8YCBf?=
 =?us-ascii?Q?FkfKkNvG6WgWwHwqaxr23fx8fB9o+XcACwM3nYnkORSN1jpCL20h7S/oQ4aI?=
 =?us-ascii?Q?TAKijewgM7ZroLEOJC9NP0MQ?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4d85a6b-48b0-42a7-d102-08d98d2890e1
X-MS-Exchange-CrossTenant-AuthSource: SG2PR06MB3367.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 02:32:42.1350
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GA4JztlcS92diG0c8MxYE/7m6d/C/K/SNAR+9rBfClUE72p322CKHWPiZNbaJfvRWmCbeQydILT5T/CPFK7xcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR0601MB1838
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix following checkincludes.pl warning:
./scripts/checkincludes.pl tools/testing/selftests/bpf/cgroup_helpers.c
tools/testing/selftests/bpf/cgroup_helpers.c: unistd.h is included more
than once.

Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
---
Changelog:
v2:
- Fix the commit description.
---
 tools/testing/selftests/bpf/cgroup_helpers.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/cgroup_helpers.c b/tools/testing/selftests/bpf/cgroup_helpers.c
index 8fcd44841bb2..9d59c3990ca8 100644
--- a/tools/testing/selftests/bpf/cgroup_helpers.c
+++ b/tools/testing/selftests/bpf/cgroup_helpers.c
@@ -11,7 +11,6 @@
 #include <fcntl.h>
 #include <unistd.h>
 #include <ftw.h>
-#include <unistd.h>
 
 #include "cgroup_helpers.h"
 
-- 
2.30.2

