Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90E8C3E2A89
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 14:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343685AbhHFM3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 08:29:39 -0400
Received: from mail-bn8nam12on2117.outbound.protection.outlook.com ([40.107.237.117]:62433
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1343657AbhHFM3g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Aug 2021 08:29:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cTN+miyplTWnUiix3NiKMLu72Gx1BFA72hb3jUB5aDxheWtPqsm5UdTH4GTiLrdxsamW3dtQjNDZs0adTfbSvijI7N7ljlqNmRJcX6d6bjVgbroQ4bjPtzOw47yjPMXJuUmmwWuI9cY1tCuEC1j9jbxY0Qj5cxgWX4OBvTjK3F9s2GRMQoX9wPbkNI/hWXEZ6WEkuGW1bcgmYZYQnuMOFXx7uFsPCSFRxrZMayPUbEOzy/QIH/9Dipb9GNDecWl/g1qL0UwTyugS9uqLzA5/x6yy6rWl0EWBrjKKCOGwZdz0lgQMw5WIAvQFdx3HmXrj8NBSr6b2+eIE7ds8ivahmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u5THErndH4UgGQ1n0znk6dkwOCJVixIUEZUlsNnmjmE=;
 b=Md3vBSfSh0layxFCcdvxiBfQoMNz31bYQ7Ymd3mP/WZ09Lj19w8KRJVFofcFU9Jw5kAsbOIvaNOpJhUk8dO9NCKsiSImlGD6ldA7F6JqHDHD8au78KjqVZ/+jK/2wkAZueRIMa74s/7lF/wFFFkyRG+pZWSKuDFrrm/YS++e7q7hRPxoKpPg4s6BnkjJhzXwgAI3FHc5rF78MukJofAKsLtSlCUBgo5ihKRrBb1S0gqt3/7EuP0BuWlYxNOp0zw0eNTu6b/LOX5+JUv/YB+ItOTCG1ayLOlMURSy9oedPqx9BWg5dqkBzqiVSMV1gWNtO4S2t69RMPwZjc44uFyaJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u5THErndH4UgGQ1n0znk6dkwOCJVixIUEZUlsNnmjmE=;
 b=svaZ2/DGd9bsY0tgdGcizEq59ylXf4N8cbZlYEMVpwawVjENDjdlJYK5g77kFxQLGQj746T724ZSKOjCXqqk97HXVNfdwYTacCcv5A4lYePRfHqB87IU7gsRdDVm6Obvbf2n4k8JeShnVWc79CJQEs1niqPbil7V2RdwlDE7qnA=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4825.namprd13.prod.outlook.com (2603:10b6:510:99::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.7; Fri, 6 Aug
 2021 12:29:19 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3%9]) with mapi id 15.20.4373.023; Fri, 6 Aug 2021
 12:29:19 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        oss-drivers@corigine.com,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH 2/2] samples/bpf: xdpsock: Remove forward declaration of ip_fast_csum()
Date:   Fri,  6 Aug 2021 14:28:55 +0200
Message-Id: <20210806122855.26115-3-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210806122855.26115-1-simon.horman@corigine.com>
References: <20210806122855.26115-1-simon.horman@corigine.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM3PR07CA0141.eurprd07.prod.outlook.com
 (2603:10a6:207:8::27) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from madeliefje.horms.nl (2001:982:7ed1:403:201:8eff:fe22:8fea) by AM3PR07CA0141.eurprd07.prod.outlook.com (2603:10a6:207:8::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.6 via Frontend Transport; Fri, 6 Aug 2021 12:29:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e636d855-ebdd-4b17-ea49-08d958d5d01b
X-MS-TrafficTypeDiagnostic: PH0PR13MB4825:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB48257B5251268EB2F9BB4634E8F39@PH0PR13MB4825.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aFT/SqX2WFLX54Foi/YWvVOMX34Bx3RsmNuQll84jMP9y+pn/eGyCxx18G4L38GbmYJDwkKcRYbDw72ENMMMWfkUZ94tHDbCj5pHPcSJKODRUFnrS8viTMaJjv0SAdcvSm/w7i3OqwoouUxoQhm3noLooFlMzOp/GZASyz0fo8u5psr7aFrvmdkvSGCcWKa2epTvboi/C+qBkMT4j4vA810ARhW1GjoOkuPIYcrKm2yKPfEMAw1cZ7bEcAxHuXC3XDjBt0smjfg9wp5oxU52Xws1BjQEr7WamZTKF1yZhcvfSMLmfT5SDbx6eDUAk+CGKUOZLqtDAI9+ST/9FxsyVbXnE60DNADDcYCUKrnCeM9IVoqiz6jSzyhaQ07Cs+mYD9CrSjMbJerDazJ1yiIx1BljOMYzjQxePc2fnYpmt5YRgp4HyFRZzkRczGDfmO5SUsLfQbKv67fgd1jT0HmJLIJuipLe56q4Y6U455e8kdXlp4jJ4b6B5rI0mqLGeBE6DY+6KRKKR7lGi8d3bNWQesjZgkyMzP8Wn9/cBf2qvEMtgf2qB7r1AcVmTbjZhImY0AGaz6E6JoL5iTNEXG2rQ4ZdfiOzAFQd4fKyCbuE9tBpyykFUynA83hs1fZbx7L+LKY5j01tddm3g7qHxE2UwQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(39840400004)(346002)(366004)(376002)(38100700002)(66574015)(6486002)(186003)(5660300002)(478600001)(4326008)(52116002)(6506007)(36756003)(86362001)(83380400001)(110136005)(107886003)(8936002)(54906003)(8676002)(66946007)(44832011)(66556008)(2616005)(66476007)(1076003)(6666004)(2906002)(6512007)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QWJpdDJBL1ZnY0RMY3c5TzNvbTRVdzc1UlhrL2p0ZmZHTGVLRVloaDNEQkRn?=
 =?utf-8?B?bjRGemZMY3ZqQkYrOWVhQUxqMkJwbDkrNnhtUkgrQWVNNXQvZFoxNmt3OS9l?=
 =?utf-8?B?YUsyM1JXZUdZQVdsVTB3Y0dPcUIvNXdZVlFPVkNmVWNoRGJUVXFNNjNQekps?=
 =?utf-8?B?K2xKS3FzZ3NqYm5ISmZqWnFtTmZZelljcWo2SXNUaXZ6Q2JIRE15ek9EWWVw?=
 =?utf-8?B?Z0FOUWpjNEtrRlUveFVUd0ZMTmkyZXRSQXNxWC9IczV3WXlEeXVrcXlaVUhW?=
 =?utf-8?B?TUgxZ0ZXYlFkTkQxS28vQzZ3R1l0YjIvUXpZbFJIUGhIaHJocFFuc25WYUNZ?=
 =?utf-8?B?cm9GQVFPa0dhUmlkVkl4Q0hHYnRIZUlYTmtIN1NtaHVDSzJabEFLbWJhLzNE?=
 =?utf-8?B?M3NnejE4Ym1SclpYdTFWeWhiZzNNU2JlY21XaFQ4bThMZWN1cVRDSDVnRmd5?=
 =?utf-8?B?YXFCbGkwMEpybU5CM0Q3M1ljWmtBd0lZbithbUM1elZYL3dxSzNzTWM4aW1r?=
 =?utf-8?B?bkh3Qzl6b0VZYlVDSWVPeWxkQkpzY1BaL1NGT2s0V25DczFFSlZlRWVoYUhn?=
 =?utf-8?B?anMzODhoaEJEQlFmMGlPK0wwVUpiRy9xdFR4YnovTkpaUUdsU2ZVYVdkeW9p?=
 =?utf-8?B?NlRRVkJpS1dYYmU2ZWRrVWJybmVLdWhKNlVIWDNrWS9GTnMvemdZbE0yNTdR?=
 =?utf-8?B?cmZFWFpzekN6azBRNWVjREVoWVpPK25MbzFiczJRUlUyYnlWd0RLVnN2K3I5?=
 =?utf-8?B?MWZrZWtzUUlxdG1hQ3RtTkt5WEExQ3J5bTByOFEzbjc0TWJibm4vY3JycVRU?=
 =?utf-8?B?OStyQU5QZzJMdnlVZ0ZJRlhMQ2lWWnJ5KzFNUzJQODFhdHU3VFJpT1NPek90?=
 =?utf-8?B?Q0JBMjFrdFFndWVid043aWVkbUVueVh4RndhUzR5ZFZZRDk1QVJvRTdNcjFX?=
 =?utf-8?B?VE9CSERSS3VFVGpPdFJOd01JSldFVVI0UVRicGxocE5Tb0NQYlUydVFrcjhV?=
 =?utf-8?B?TVcyRkhjRVk1Si91NXkrcE1Bd0FpZ1NYQUdmT2FQaXlPWTNBbjNXcW9KS3VT?=
 =?utf-8?B?TG1BMFQ1TUVkM2diWW9wRHBjOE1YUitJSmFweU91b3cyWVRBVzlJdDE3QXF6?=
 =?utf-8?B?b2JiYU1UVzlYOHRrK2haV2ZaQyt0UFVCZUV3dFYwN1pHNW1mZ1dtZjgwOWVP?=
 =?utf-8?B?cnRhTlZTdG5zY2RFRmYyeVdMbDd5OVowZk5sRVQzdlBnT3dDVGU1ZThFZFBy?=
 =?utf-8?B?bXcrU21rQlN0dExyMW5zcm1JbXlhbWZOMUVwRDNBVGU5NkdKZGpoNmFpSmFY?=
 =?utf-8?B?bjdGc3lzb0VqcmJrazRLQlY0MVpEZGZXQnRuQ1ZRMDRuYnJsSFI5SGphMDVC?=
 =?utf-8?B?RUI3TDljTkFjYnVwU1Ixdjc4OXpKTEViMjRWM2cxOUV2SGtOYTYvelBJSFUz?=
 =?utf-8?B?OFRmQzh0VUhja1BES1ZQNk15dXQwMVZZWHNLRHZEQU5qNmxZRGVuYVk3eWls?=
 =?utf-8?B?cHI3TEFsVjVWOHo5QTFlUzdDNFdlL0U4MFBqdTZoTVNLWkt1RVRlY1R6ZkZJ?=
 =?utf-8?B?MjcrT3ZyVndsbmdnMlh3UEV2MUg0WXlkTC9OekpKNFB0SnBHZ2x5WklVRTZa?=
 =?utf-8?B?OWduS3RKTFR1Vml0aXVIUzZBOTc2TzVLU0doZFNweTR1THN3bVluN1FIYnoy?=
 =?utf-8?B?TlpFUEJGUDRTbWlWU0NLQTN6Q2o0V0tJRXhRWGRDRThhRWM1aFloU1ZkUlJi?=
 =?utf-8?B?bTZIYzdYUkxwQm9TaU55dU11K05tRjdMeVZIYU9PK3lLSDEybVVrdFFDcTlw?=
 =?utf-8?B?djNvZTBDaS9HZjZwUXc4TFZadWNZd1lOWHh1eHB2TVFyY2pVMjRlN1ZQUDVJ?=
 =?utf-8?Q?phzsY2W8Yaf/6?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e636d855-ebdd-4b17-ea49-08d958d5d01b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2021 12:29:19.4893
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2IGY2Bu5tSODeUPTW7hwgIJdJRzaIjtdxtf6bn4jZeN538+iXx38aTzLC5We3XHDQZjbkkCpf5HigKJJ3tenraKINQgxXVAalIEi0PGgMYU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4825
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Niklas Söderlund <niklas.soderlund@corigine.com>

There is a forward declaration of ip_fast_csum() just before its
implementation, remove the unneeded forward declaration.

While at it mark the implementation as static inline.

Signed-off-by: Niklas Söderlund <niklas.soderlund@corigine.com>
Reviewed-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 samples/bpf/xdpsock_user.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index 7c56a7a784e1..49d7a6ad7e39 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -651,15 +651,13 @@ static unsigned int do_csum(const unsigned char *buff, int len)
 	return result;
 }
 
-__sum16 ip_fast_csum(const void *iph, unsigned int ihl);
-
 /*
  *	This is a version of ip_compute_csum() optimized for IP headers,
  *	which always checksum on 4 octet boundaries.
  *	This function code has been taken from
  *	Linux kernel lib/checksum.c
  */
-__sum16 ip_fast_csum(const void *iph, unsigned int ihl)
+static inline __sum16 ip_fast_csum(const void *iph, unsigned int ihl)
 {
 	return (__sum16)~do_csum(iph, ihl * 4);
 }
-- 
2.20.1

