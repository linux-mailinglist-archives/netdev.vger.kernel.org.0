Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32A35449F57
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 01:15:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239158AbhKIASJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 19:18:09 -0500
Received: from mx0a-002c1b01.pphosted.com ([148.163.151.68]:22822 "EHLO
        mx0a-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241148AbhKIASJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 19:18:09 -0500
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1A8M3hR7007014;
        Mon, 8 Nov 2021 16:15:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=proofpoint20171006; bh=9y4s3+DE7t9ya4ycWR5zn+OPlgDFRHuPTsAt6HHFtXg=;
 b=kDg+Z8K5zwAtQ+pDgHOmnxh3mqPiv23lGs6e6YtUtMmf2H2WSG9w2KT0FFUae7B4HpoY
 H8CEUZP7pprKKoas0PAojirAPPppaPZtX/aUinWU4pIHsgfl2areweyYPJKt4VRspc/8
 r9nsnHN4jNqGbjLweWT74TKSYlETvWOHzk1eVnb6SLNytrTPoCC4158YZWr7keXVO+Ro
 GisRDEwpu88qMY45Bi67OpmffFbPWRrZ7JNJ+OKWPjpD10g3mbnCtlFCCjLJpGWh9tqX
 AfIJzeiD9A1cIcxIiRI4mE0D77uZjwKmYNwdPL2dCHkXVVLOav89yqnPGWzrH68oQN/5 bw== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3c6pp2jfcq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Nov 2021 16:15:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TR9BC76XCkpYiEgufSPx6Wsoni+pwqePSN8yBl6hBA4PqasVogZuT0coY13awPDViLvxPvOUxBWO/op1Sdtimv41YPB5zMOkpEaMj3KaPpe/+kKBwaNeFmfuaPuT1+Ft2QEQTgmhj4KwTK0urPxPwX+VZgQMzk6b/E0SDEm5i5R1A3NTXsT/YF+pa4muhLNalYpl8lW50CyfaYY7gxvzKLzJLIqu651W4d0Dm0nG51QJIy2GUzbTKp4FPUFNLk76/yTLLZq/DCGvFLp0xT6UEdzdA8xcFpdHhA1k1EjOHz+YkeEdDkF/TKiYAenqqXlkcBoMF/CnjBVQDH5udJ6osw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9y4s3+DE7t9ya4ycWR5zn+OPlgDFRHuPTsAt6HHFtXg=;
 b=M9gGxJuc4U7/6Z2q4OrWdgxYeH11I2b9OT/8wVVCBThUGGy37mnGMJ1UJn8+tQ8FcjQTKib/tboaecLbW6MyzG8uhSXGx1mvtq8LwIZl1mDQ+eqDkJxmu1oPFD6T/lHxzBRZe1t8nRrWW4S++hdIRe8oAP6b8ySn3MYDVnH5SY8dpp3arrta7Hv5SvDUFBtSgh1rdgM9boWRh0jYxJESuSlu7w2jn009T5AWryPXee10eX9sZiy9u3oKbmZWfNQy9ddFRrQedaDHbFI/d7JA+ffG4VGFTRQjAkFy2KBKTvUjBQa2qVY7mas/4fl8VPo6BTAneNFrv5Q870CFIRH16Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nutanix.com;
Received: from CH0PR02MB8041.namprd02.prod.outlook.com (2603:10b6:610:106::10)
 by CH2PR02MB6952.namprd02.prod.outlook.com (2603:10b6:610:82::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10; Tue, 9 Nov
 2021 00:15:16 +0000
Received: from CH0PR02MB8041.namprd02.prod.outlook.com
 ([fe80::6448:2a3:f0a9:a985]) by CH0PR02MB8041.namprd02.prod.outlook.com
 ([fe80::6448:2a3:f0a9:a985%5]) with mapi id 15.20.4669.015; Tue, 9 Nov 2021
 00:15:16 +0000
From:   Eiichi Tsukata <eiichi.tsukata@nutanix.com>
To:     sgarzare@redhat.com, davem@davemloft.net, kuba@kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Eiichi Tsukata <eiichi.tsukata@nutanix.com>
Subject: [PATCH net v2] vsock: prevent unnecessary refcnt inc for nonblocking connect
Date:   Tue,  9 Nov 2021 00:15:02 +0000
Message-Id: <20211109001502.9152-1-eiichi.tsukata@nutanix.com>
X-Mailer: git-send-email 2.9.3
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0019.namprd05.prod.outlook.com
 (2603:10b6:a03:254::24) To CH0PR02MB8041.namprd02.prod.outlook.com
 (2603:10b6:610:106::10)
MIME-Version: 1.0
Received: from eiichi-tsukata.ubvm.nutanix.com (192.146.154.244) by BY3PR05CA0019.namprd05.prod.outlook.com (2603:10b6:a03:254::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.7 via Frontend Transport; Tue, 9 Nov 2021 00:15:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a44c298e-b82d-441b-7453-08d9a3160177
X-MS-TrafficTypeDiagnostic: CH2PR02MB6952:
X-Microsoft-Antispam-PRVS: <CH2PR02MB6952F92BFB0D1E6EC7165F1B80929@CH2PR02MB6952.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 183SFZoIOvK5oU21nvR4fJBaLF7bpTL/rjemxwlS67VJlAOxRxQuOo5TXbJwLRpwI8YUkV6t4kPQQldCYtR/zVSFoDL00/AL1n/MF35Z+UuYAkPYkLPnfLaQC7u/pekf1/krWt09Ha/LmxvqbOxkZdJ/1D6yTa6U+0AdjTHfdPHNOgOWAjxD5qlcGD4anIpx1Jt4Ia2zg9jk7Rc5OWI0L/vK5bh+VpmRf8x5WoNPz8FomM0Yk7nYrTmG9hTm2NzwVSh2w/mD6+WILK32x1TIsr0bVTxLb8/JVbq58YpucE+1PucjKwkPt1SctndSdvW2wPZSp74E628RCyyRPUCvyoDj/jB04ENVGqdyc3/Zxk6rW4+wM/Uo8mieLSjNtcf3RIQKSeHaT58dRjsqKd2NSGRpIq7msHR3OltWM4sqdG1y9qIMDLdb3etA8w5CVOno9xOS5Qddip8Q4aA89N1Pb816PGxZUcV1WjDmXnkj+PyL3FpaQFVTVc3/j/NBwKE6VoiylCtnDj4x8UcqV9/GKCObd8TUzlB++PijQjYtO7aZJLrlUNr5BqOY2WVxhcGxFqwd1/QmgoM10+4PEB7gporjtmnL2+CZzokQrRo5u4A8u6Ev13gnDJ+UzfGnVJqrI928+jNI27f8S5uh+e6u6igs2mhDL/HKGH+wUKPs/z4hld+XE2qZkfKUT19ML6TxQT5G5uvucOQpTGlMxHmBPA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR02MB8041.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36756003)(6486002)(44832011)(38100700002)(2906002)(83380400001)(38350700002)(107886003)(8936002)(8676002)(7696005)(186003)(26005)(6666004)(52116002)(66946007)(5660300002)(2616005)(4326008)(66476007)(66556008)(86362001)(956004)(4744005)(316002)(508600001)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?b+ihu7bkcRVHzX31TqwXEhtODSc0pqeUEvj6UGSgxYe337Uy4CRUhcAWTRyJ?=
 =?us-ascii?Q?3xRxkMkFA3PXXyTDwAQYSCkWcQgKNwnZGzO90geawGr5VwwosTQ3yD97BgaU?=
 =?us-ascii?Q?6ooWJwaGPgLvsVAb8QHDkLcxLWBk9N2JjhlatZQlWwusJNwZowhqugXHyb9d?=
 =?us-ascii?Q?RsuUuAPly7j6mdl27GYn1GNBQN7b3oPRkUJlr0Saqm4w1jIIhO8PUP0g9ESx?=
 =?us-ascii?Q?gQAMz1b1n3emG2dTcLn0uLKI6muXV09GvPxO2VExOB7IKvJwBQYUrmNsPdpJ?=
 =?us-ascii?Q?tkcFPd8nc6Vr7uVAUK3I7pH6fEsVJg492hSVkXwWFkihBOFpUXOZTQHGI8mI?=
 =?us-ascii?Q?oPMseGsMMiHnO9knczm3EPeqGy2zHju9D7hcM4IxkjUjTFKvUbAVazTukWDE?=
 =?us-ascii?Q?aFn4xy03JEiLcnxIeBUHNKAtBUKzz5YvM4xmGhJkDyWByDT7Mt5p+TWMKsst?=
 =?us-ascii?Q?5Wpz21dLwXmbwK3dYbxjZHJXdNSVBbmCPzUWxUScng4Fvi6mJaLyezOneptL?=
 =?us-ascii?Q?HQJIv+PRitsHxuw6OzQUY5V+4HkRxDf5S8RZ/ED/UyMV37NU7SKti0EZ6ocm?=
 =?us-ascii?Q?K+Wn0JgHpAqqH44Ej2LC291MtpZ0C/zV421zQSaFFz3RgvNRj0L5D797nWwu?=
 =?us-ascii?Q?Ul/qYcVy710bir7p/cIwtrmBl9I0Eomo/nR1sQvv79rn+mY4x9EA6Z1XkJ96?=
 =?us-ascii?Q?/mBDdaKMXMAdLE9Iwjix4nBXPClKYzHK7YPwRpVDXIcjjzwyBqQHtUucRb7B?=
 =?us-ascii?Q?h7t/xJyE6XpDhzrU0QU4BAWniISUSjXli41RsrqJQtscaA/4hSxrkUQE+uyz?=
 =?us-ascii?Q?6O/zFY0cnApM+V8JzIbNIsAP53l81NmuZ03WyTTZPVECX6RGj8LPHsGONhDg?=
 =?us-ascii?Q?z0q5A3+5ktoM5Z5cGLoJICBx6zN7FN7+LqAEtzKWCcTSJvTU3wMvLrKmBJ11?=
 =?us-ascii?Q?ssY19NxyONFeF5P2dwouNBC6dv8CwrMTF4EHpkdjXFIZgcimJNphLqsMQaT/?=
 =?us-ascii?Q?U2gma+yZbrd8ZpAqdmTYNJligvuwFCVDLVzZnrjMo3kZY6OCIf4kAjl0ZaWf?=
 =?us-ascii?Q?2TSaSlFiONFDkTcBcDXwb1MrOtbq1m//FNuC+MVpTzSCHf0EsSRSopz9hCmX?=
 =?us-ascii?Q?LqmVKHurjGASUYuue7TzdpO7Y+CT3GB94Mb/KA6GAbQuND1P6caBnpn+O3a8?=
 =?us-ascii?Q?GgTUnC/KsKAe7fNYMc8XGcNXRsLZcyt764MIDn/YPXpxWHZi+cp8QY+wV5LX?=
 =?us-ascii?Q?wV0//jlwKVF2hp3bSHKF9oBab/eMBOZYTWfmWawaabLaksFwTe+NiGKLue5M?=
 =?us-ascii?Q?WTdnrJ5a0RnyKa07XfNFhRNB0wmAAEywzFHSwx1o3MrMRDAIguYX7Qb+1kp0?=
 =?us-ascii?Q?K71MlAjvdu/taveINLM85P7itwRSNLACFPcS2XB3eTsmdrgtPxbEpwvqhm6I?=
 =?us-ascii?Q?1YAJgmhYP30TF0+XTUCXKFITQXK4EDSnpuUG3/J5xfFm0Na0Vl7iRCrmP8qA?=
 =?us-ascii?Q?Py8p7mjU39roEKbLvUVK/GhAvy2hptEXSt6YcxgBFK3Q965wE3KVo+Yw3LHg?=
 =?us-ascii?Q?7HqCcCqrJ9WrGyV7VZPT1wScmL/yoxcRGKCHOjQJinJpagJy4cXxs8ejXb8v?=
 =?us-ascii?Q?+/NjMHTRYqDzeH4/9wCPtZOrKdbl0+xClVKdelThllC1dlqhEPYpsN7chSZa?=
 =?us-ascii?Q?4JBgV5bRbCrW5yNwVM6EWvbqUEw=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a44c298e-b82d-441b-7453-08d9a3160177
X-MS-Exchange-CrossTenant-AuthSource: CH0PR02MB8041.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2021 00:15:16.0960
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wS9gq2MlxgqhaYx7RjqWTVi1qddPMJNyf4OC7uEj9gCam7PLqm9bu2S0hsOuP9b7eCifzoreWPeqnJVLK2a2UlL9PnTm9b5x6uIKoVaPAzc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR02MB6952
X-Proofpoint-GUID: Btw3Pa00sRWAnscv0zmtCGJKn5Fn-zfy
X-Proofpoint-ORIG-GUID: Btw3Pa00sRWAnscv0zmtCGJKn5Fn-zfy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-08_07,2021-11-08_02,2020-04-07_01
X-Proofpoint-Spam-Reason: safe
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently vosck_connect() increments sock refcount for nonblocking
socket each time it's called, which can lead to memory leak if
it's called multiple times because connect timeout function decrements
sock refcount only once.

Fixes it by making vsock_connect() return -EALREADY immediately when
sock state is already SS_CONNECTING.

Fixes: d021c344051a ("VSOCK: Introduce VM Sockets")
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Eiichi Tsukata <eiichi.tsukata@nutanix.com>
---
 net/vmw_vsock/af_vsock.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index e2c0cfb334d2..fa8c1b623fa2 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1322,6 +1322,8 @@ static int vsock_connect(struct socket *sock, struct sockaddr *addr,
 		 * non-blocking call.
 		 */
 		err = -EALREADY;
+		if (flags & O_NONBLOCK)
+			goto out;
 		break;
 	default:
 		if ((sk->sk_state == TCP_LISTEN) ||
-- 
2.33.1

