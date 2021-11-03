Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA561443FA5
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 10:51:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231955AbhKCJxd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 05:53:33 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:32426 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231983AbhKCJx3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 05:53:29 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A38YhPE000566;
        Wed, 3 Nov 2021 09:49:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=+CsUVkpnV3XUQb3COymj/h0qcD0x5LLsId8i7Qr+Ma8=;
 b=b9kHe8UeN9NvynmKe5ts4iy1IY0kCwPsJoxQF6rJ0IhF4ewI4dv3npgxIQ/bi29gBYlm
 WAmVYokQgu1PUqW/hL/2z0O4WGSlYldrkH3rNqQXWYx91wG0dA6xL+CGCUBfUcW3sGB+
 LisAEsUu4T4vHXWCgLEBuxeL11Mi7fQw5/qMF1XknhfCNPi3VwQQVo4+izKOQr9bmiYx
 v1FVZ5XYE9KaAi90mztIJqQSXWnqoq2aLH2CiLrTX27y3T44nXJr8ctGHsepNMxs4Z1H
 FPg7a9Ia4Grvg4UZVkx6tEtjo6l5QiEH7t753yadg3n+sYt9xfSL5lXlLei899k7Hutz rg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c3q1n8bw6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Nov 2021 09:49:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A39kJYS187125;
        Wed, 3 Nov 2021 09:49:41 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by userp3020.oracle.com with ESMTP id 3c1khv93mw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Nov 2021 09:49:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mJi/D6G8Fj61yzlgC4Xa7586Af731yWeC1hH1pyKG4KbUTPIwGAPUHhCbcPN8cpmogbBsvwljyXHnD2FCY+goOxBDjxJvdgy9gQ/btUTxkde4NJTwDSmyEujo7UAR62Z2PVU8CvK/Hi8wFeGRitqMONUko+wve9iAgsI3jgYFFvVl/1hWcEI8Az4+WAcGLprb8BsIkGlOsiVF5Q/c1KnBXPNTbFXPkmW97hJ+H6N5DTC6PxEUp9vgE/zfySuW4tdkEzlTWMivHsEsokDyKzyK9HeoSy1T0QjqzBpuAMqM0C8ruSBWVUELbRzWwdPIoDqS4UrhG/Liis/cu21lg3+kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+CsUVkpnV3XUQb3COymj/h0qcD0x5LLsId8i7Qr+Ma8=;
 b=iXrXuB3u6yZEYIdwNQIl4esX+YJzEgGeq8AbWQuQJi5rGxO6NXBBCHeHOVs/LooulQozea/mUk+ZLzUyh2LhhQidBfrXXVFfNwn91+tTTfTo6V/fefyNiPci6CF7wXhPvJlwnhOnAX2GY3RQUMQnqI9lBU+74PLo21roQLk8YsZMZnrck8GAIPy2O6QWK7r6LtcJHRBHw24uc17UlDCUApeAasiR/8wDbuXN+6whH6QUdVpLhssu5hlAV3G4sMGJynVh4PYdhmAEMbT3vh6liCOQDU+9vMeeUV2GvE1ZlqXLiojPYXNH6kxQxI549smnnDXJKIOtf9U5VNS9HBk1+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+CsUVkpnV3XUQb3COymj/h0qcD0x5LLsId8i7Qr+Ma8=;
 b=ISJPqpuYuRpc0XVGwfviWqBrgM+kQassfzYdjc16onfLdW6PRjLieouTWgYjTeiUFmee8WKKZUG7nvz4U+d0/yT1edTRo2BxCAsQFhnv9Gp0gLPuksq3i5YQeO/PO5lNwG8SLujgCA9a6ofo7y4l/iPdolTxkNhEyABOJYPd9EQ=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DS7PR10MB5278.namprd10.prod.outlook.com (2603:10b6:5:3a5::9) by
 DM6PR10MB2490.namprd10.prod.outlook.com (2603:10b6:5:ae::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4649.17; Wed, 3 Nov 2021 09:49:39 +0000
Received: from DS7PR10MB5278.namprd10.prod.outlook.com
 ([fe80::6c17:986b:dd58:431d]) by DS7PR10MB5278.namprd10.prod.outlook.com
 ([fe80::6c17:986b:dd58:431d%7]) with mapi id 15.20.4649.018; Wed, 3 Nov 2021
 09:49:39 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ardb@kernel.org, catalin.marinas@arm.com, will@kernel.org,
        daniel@iogearbox.net, ast@kernel.org
Cc:     zlim.lnx@gmail.com, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, andreyknvl@gmail.com,
        vincenzo.frascino@arm.com, mark.rutland@arm.com,
        samitolvanen@google.com, joey.gouly@arm.com, maz@kernel.org,
        daizhiyuan@phytium.com.cn, jthierry@redhat.com,
        tiantao6@hisilicon.com, pcc@google.com, akpm@linux-foundation.org,
        rppt@kernel.org, Jisheng.Zhang@synaptics.com,
        liu.hailong6@zte.com.cn, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH bpf-next 0/2] arm64/bpf: remove 128MB limit for BPF JIT programs
Date:   Wed,  3 Nov 2021 09:49:27 +0000
Message-Id: <1635932969-13149-1-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0089.eurprd07.prod.outlook.com
 (2603:10a6:207:6::23) To DS7PR10MB5278.namprd10.prod.outlook.com
 (2603:10b6:5:3a5::9)
MIME-Version: 1.0
Received: from localhost.uk.oracle.com (138.3.204.46) by AM3PR07CA0089.eurprd07.prod.outlook.com (2603:10a6:207:6::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.4 via Frontend Transport; Wed, 3 Nov 2021 09:49:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 98475b55-8ee4-4881-2e79-08d99eaf406f
X-MS-TrafficTypeDiagnostic: DM6PR10MB2490:
X-Microsoft-Antispam-PRVS: <DM6PR10MB2490C4BB357AF2E8E9FD69C5EF8C9@DM6PR10MB2490.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rDtvi/vfezNUxP/SdvIxBB2zmRQmL0KT+Pl8mX7sk7aABnscuI5vtZ0GshVQtfhZO+8nwsNbzFqMx6xC61TdkXZUZIQYdXGe6/jp9ZKpMszGse27kJIvDY2N0K02f7Rv5m01nAL1SVLPxxqoRIaUDeTo1YGRDHb/SzzXJvzlecKbJxhIC0HPUDSWQFY0UhvZud84e12dxuMwvQ843ekl8GzNfRCFY3LGqcDfDuP0Vzk61Eqhg/FzCvtLDcFxkoilgNhukJtpEvHrkP7P1iwOYP5VOxQGwYPEl/gGBDzRuSaEzobAQ74RaT+YT3rBV1urJ9035Cvrry957KHMvibYS2G6sNkK5DuUsTyMIc/ikfEGHmofeCzN4BY3KGAlqmLbYrtCji8LQ9P2sq3DSydIAuUJAYfIvQjznaUjZ1kBczZbiopTRglIkfncfLbVSbbExydKVGs0X/JNT1gN1Sl8x/o2o/c8YkaqOf9cFYVLpn77XDtVy77u60TTnO8nWWQg39hq9mcXyHVkxNMC64mVTOi5exszDvmJdj3hZmVOHdwvScf9iC/kcLXCl/aAhuYtyWrK7tnHuaabtRmWK8XYFlwxw1z4A0mpGNFLjjwDym7E3mk5RxyiEqhJxEptDfQqJIpkqCHuIe3Ydi9ZQ0sNVk3rK+vr3cwYZTbjGOX1OVc0czTgbz2HyUBCPlxVaWIfLifzjwjcjWaGOoEtabxKlDCUQUs4c8n/zWXDaZSM3HTEPiMJvCA1rsL1+MJWeHaam5Hz+JV+qhPsNfHLhB1KHw6kvv/lMAQcnS9bAzi49/8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5278.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(316002)(36756003)(2906002)(966005)(66556008)(26005)(86362001)(8676002)(508600001)(83380400001)(6666004)(7416002)(8936002)(7406005)(38350700002)(956004)(2616005)(186003)(44832011)(107886003)(6486002)(38100700002)(66476007)(7696005)(66946007)(4326008)(52116002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0hKE3h4RUKwfCLSnOtpCuPBT9P5GVjBGfpqoczQLCX48P/kpXjuKvmguynwt?=
 =?us-ascii?Q?ShYb3Gxe4ZXWerMo+QODIM/GkV6gFvnVBmvdhX7j6CTqa71vKhELpjZgF3be?=
 =?us-ascii?Q?CgPIN2uHDw+og5utSEPVIL41zjhmnnzWDA5qWGhvae6oEHhXb90MDg/qzOAS?=
 =?us-ascii?Q?DNkSO6c1mNCY1mxA2UFrTtbHM9F9X1Ae2OTPn2ZaPglefxptA+DDEl+GUYdX?=
 =?us-ascii?Q?tt1dRFHxosNnCd2ItIyy1I45ry3iYlZVkb/tuj+JTJJfZ3m4y2be+c2cBvMi?=
 =?us-ascii?Q?zuy8d/nYCu0xJK+ELAaydzODmA4KL8jdC64z+EdGkO5gdcyKLqeyZccVWL1c?=
 =?us-ascii?Q?XiCo3sRSf30GWCB4qINzP50bUPOKmKQN6q/Wls8y/8ZXXx/N9EgeBNM3CQha?=
 =?us-ascii?Q?Ei6ipY2nzfJ9YacIhX5N5v0Y2qtdAnQfLH+eK8y2cKYbwoMqtR+5NNZ4YbOQ?=
 =?us-ascii?Q?G0BvZxhFZqNC8wc89NwkWib6CfTqdGRyYszhT+rbSQDZPK+gJljBwKJcBLQU?=
 =?us-ascii?Q?BOXHqeGtVqz3EdYvvRJDiPXpZlX/CCpsrKlDesit1cQ4QLPdqcofSEvyXnM+?=
 =?us-ascii?Q?GxcJZ8mrjlE+gxYXAUbT9bDpwvFwDOMWZYqUEQzVOUskJuIMFnwuzC/5OwCM?=
 =?us-ascii?Q?wvy9V8AK6td3A6k1eohnvN7U9cQPN/TqPwyC6eHsvnx4kqMQqPoVE5Noetig?=
 =?us-ascii?Q?ogVQWphUXAMv2ZvG2PuoF89nCXhvpUYUqH6+HAR5FZxHV+nVjV45xR59aAeQ?=
 =?us-ascii?Q?/kXmPiySJFxg2BcVHcOQEWJXqzyBwV577m6Gp3rQ2HcJ7LzdfsWcI07NvDh8?=
 =?us-ascii?Q?RGm7OF8GoMgrDsu0uLu7iRcYNlTvqa5PplJZBornk5XhQpufZNDJj4lTPFo2?=
 =?us-ascii?Q?ixiUedPuaxZRx9jZT1r++DhNTJsAU4HCVfNtOCQZ9mngy4wZbAZckkZxRU+a?=
 =?us-ascii?Q?Kwj1IgI9c5V3S5owtHn0dqE6ee8SXNsLZwE1tY/ic1p6FyZSJiTK1okzuElO?=
 =?us-ascii?Q?r9p18tI/P+SjE0cNVvUwG4pIJDDP4JA+s+jihgn30PBUg5d4Wr/1lUqUVMp+?=
 =?us-ascii?Q?2fsnj9u8e4bXkU8ss+ioO0SYEJRhZ2s1mp3TSYvOVm7/j+IfIXt26iJ8qOwN?=
 =?us-ascii?Q?IEX9Ln1KMnEVRrVG2lcYfGu5N73TOhYdSWrRgTpBiiilgqTlJza3g7rhWqqX?=
 =?us-ascii?Q?Xxy/SGajtyU9vTPdgpb4pl57CKTjvSF0getDqs/Feneh7Ly0OTcw03IqxBEc?=
 =?us-ascii?Q?vPRb9GpMC/2i6vpEk7NT/ctoRdbCruMOfLVCz68wvoves7A3TYxRMYODg0fJ?=
 =?us-ascii?Q?JWCJ9JjbfrnY742pQIOE2admOWsOW6aEtsEjtZbT0YWc3avDGWsSCXyTVbax?=
 =?us-ascii?Q?91HoI3aMrywCG9azQ/crW78mfn6lLFSETYbzG9sIQz5j68XmVQ+5s56BcimP?=
 =?us-ascii?Q?+18Ydxan0aIcwnRS8CtD6qttMlnzs3uzFy3aIDbJQRzslji5czAykUI5ow3j?=
 =?us-ascii?Q?3rTnEeSslApIJw79HwnWM5izRg18TmZhD0/QRr/kFHnsm++lg1c4yZZCv3uf?=
 =?us-ascii?Q?0kXFQzy3v20O2NZjeWxjxd2XTEfgB3ZwlgdXC1UvlG9HDYgz3is53xQrHolM?=
 =?us-ascii?Q?N4ulRD7YegewuEVvAde7aNw=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98475b55-8ee4-4881-2e79-08d99eaf406f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5278.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2021 09:49:38.9847
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: opAan1QpNvBcmdu7FDDhzxY5cD4aZs1UD5/DdJU4YG77b0QYumLVrWDSHp9x3lwNe/gi1tRmtkw1yHWxx6eUHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2490
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10156 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 bulkscore=0
 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=869 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111030055
X-Proofpoint-ORIG-GUID: GdlybEEI9kj7nBKoOzIkxx1L2IedTZ42
X-Proofpoint-GUID: GdlybEEI9kj7nBKoOzIkxx1L2IedTZ42
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a 128MB limit on BPF JIT program allocations; this is
to ensure BPF programs are in branching range of each other.
Patch 1 in this series removes this restriction, but because
BPF exception handling used the contiguous nature of the JIT
region in fixing up exceptions, changes are needed in exception
handling.  To verify exception handling still works, a test
case to validate exception handling in BPF programs is added in
patch 2.

There was previous discussion around this topic [1], in particular
would be good to get feedback from Daniel if this approach makes
sense.

[1] https://lore.kernel.org/all/20181121131733.14910-1-ard.biesheuvel@linaro.org/

Alan Maguire (1):
  selftests/bpf: add exception handling selftests for tp_bpf program

Russell King (1):
  arm64/bpf: remove 128MB limit for BPF JIT programs

 arch/arm64/include/asm/extable.h                   |  9 -----
 arch/arm64/include/asm/memory.h                    |  5 +--
 arch/arm64/kernel/traps.c                          |  2 +-
 arch/arm64/mm/extable.c                            | 13 +++++--
 arch/arm64/mm/ptdump.c                             |  2 -
 arch/arm64/net/bpf_jit_comp.c                      | 10 +++--
 tools/testing/selftests/bpf/prog_tests/exhandler.c | 45 ++++++++++++++++++++++
 tools/testing/selftests/bpf/progs/exhandler_kern.c | 35 +++++++++++++++++
 8 files changed, 97 insertions(+), 24 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/exhandler.c
 create mode 100644 tools/testing/selftests/bpf/progs/exhandler_kern.c

-- 
1.8.3.1

