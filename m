Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1708A3CA148
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 17:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238617AbhGOPS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 11:18:57 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:37610 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238470AbhGOPSv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 11:18:51 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16FF7WrA024682;
        Thu, 15 Jul 2021 15:15:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=2TAzlCf/asjE1KjZ/nZEE+1tfqARE2ekC6iwVS7c7aA=;
 b=ybP/I9cNzI6fC7+AZl331cgL6Wb0kDgH7iVEA5MyLi20cjHMUT4rODVP86/H8KJlnIi6
 ZO+gxvwmRIV3/5rSJ4yHFAKU/0po2vIaXPv9HBfgQ+9Zp/NXyCzhA5pQU8rUQgSAReaD
 JjkSx/DOPPzsZIzdxBNhqmwpARwrIqlRsX6vmuihHM2pSMuxB7QmkjMdYXxM60/6pq+L
 5c/LJM5+ZIvIKjG+uKhLfbLbrQtb14dXNF5/hpElrNMEbK33OXKLG/2LLpz4nJ+IgkbA
 +GByiCKezM48xP22xtDAJp6fqSTOx3f9U4sSd1zfEHo3Ai/Dpo0iPVyFLkmYr4JSbE7U Aw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=2TAzlCf/asjE1KjZ/nZEE+1tfqARE2ekC6iwVS7c7aA=;
 b=cLPQoHCBObiYOR8+Q0hAvAvPNgJlV2MhTO206icatj/799KVVyEM2UJ35FF8iS6kss65
 rzAXcfUd+takiFf6pH3q9TmzqjMTTqINLkL5zrUm84aPthyveLLJCSUJlcuFrYgc+mk4
 3TUuEbWtCRFFDWZT6J3It6x7iRp7Dio1GE89LMLMnuBX8bIMgst9TF623BP+pntalyZu
 b8ZxIijeJPKaqgHezQQjOiVKiuMcs6dg44ipZDk/TUNkei5zGn2l7Sp2Ug/k/8Gkt7j2
 tcJNp8WOERaw8WGW7Wy8ONsS4rbYkhvW5Qk0jbpKqB1ZbQaWIGsa4afG6WE61irJ9TyC 5Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39t77uspj0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jul 2021 15:15:40 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16FF6oaM092315;
        Thu, 15 Jul 2021 15:15:39 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by aserp3020.oracle.com with ESMTP id 39q3chuhhh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jul 2021 15:15:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EjxwATIelqlWho2nKYGUmtD267tf2ogF8EwYyTaSBAB0Fz4og+brpebgJIBkT2FRbe8CyMwM40+bEDKArxQ93U/58ArAVGDurbJS3yLPq7ziMgPOm4v6ypGzjA5/zc0oVbvRAv4ZQrsA0/ovtJjTO8U7lDeL7jxmYPEDUTqYdaCRbfkSRvnakjMK/fBQFxndlWhLJ+dXEg2sAGp9ZZblJTDBMk1gCoKJqXaEUAU/jCMbu86dPcd7aoJD1TdIXmsVGJiJYCtWOm+hePAfWKhlvh5nSFz45u4JhC8ugvZVvx4X6LsMurxpfbN4aSWy0zolQUNmGnskCW6B/ycIxyzuhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2TAzlCf/asjE1KjZ/nZEE+1tfqARE2ekC6iwVS7c7aA=;
 b=iCYZiAt04YFTaUBSfZxeYTvi1Kt0Gx/DQ/+CbaVkAZJDLL7fwHYyiNa4Y7Neh9EhJgU/O29szXCaIHcB9TSFgMT2x66PT4Yats86fLGL5bAIKKFfAgP+/4R1dQOdS1tn5Jc34us7QaQ/9UgeBJUOsflvjr1FsaoRu+f+3xmEc2J20R6UFQ4XWhvolP1A6o5a0GPXzmBfhNoYn7DznwQvzmduixO2iKG1vwBsQV9ACQjUWQUma2KbmQi6T2RJ2gFSiViQDn2omvLx+mvL9z2urfBWhas/CCbEp32gmtZYsk0JL10uIWdbjDn4Vc8HljXIfW6IMj+L5ZqrH7uOhV9w4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2TAzlCf/asjE1KjZ/nZEE+1tfqARE2ekC6iwVS7c7aA=;
 b=tZCfTzBLkI2+CoqmgJazi+cG38uVSGMOJklTJC2qo5q0F14sUaKbC7rq6MfO6ftwAETe+M45+3GQ6O314bJNlQ7l32jmDroPotf4qA/H2eDkFg23rVLsefe6D4pcsePzSSKt8+naLuAMSnfp6NqRPBoa1CJpJa4p0FS9gj3Gj2s=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by BLAPR10MB5123.namprd10.prod.outlook.com (2603:10b6:208:333::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Thu, 15 Jul
 2021 15:15:36 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::39e8:94ec:fc2d:5a56]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::39e8:94ec:fc2d:5a56%9]) with mapi id 15.20.4331.024; Thu, 15 Jul 2021
 15:15:36 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, morbo@google.com,
        shuah@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v6 bpf-next 2/3] selftests/bpf: add ASSERT_STRNEQ() variant for test_progs
Date:   Thu, 15 Jul 2021 16:15:25 +0100
Message-Id: <1626362126-27775-3-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1626362126-27775-1-git-send-email-alan.maguire@oracle.com>
References: <1626362126-27775-1-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0357.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18d::20) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.uk.oracle.com (95.45.14.174) by LO4P123CA0357.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:18d::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Thu, 15 Jul 2021 15:15:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5e7244f4-7070-4985-ed8f-08d947a365d3
X-MS-TrafficTypeDiagnostic: BLAPR10MB5123:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BLAPR10MB5123348E078249E99C1D0711EF129@BLAPR10MB5123.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:65;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mJ1aav61+0pi2OmZH/p+khlV4aG/yMIBZ5T6DsxmCeG1dq9NiOMAQeX+JhpsrUrx+ZLIktvU42zrDmDWzPXSK/cA1LmawGXN4E3DGFM7hqdII3D99BHPOPQpz69iAUXwUdDCGaTEAzGLBZCF8IK34oG5r+KWDriOJ6emVlnesr/xOsMz51QjoWsVQ0Wm51IepgEBPq6bEoFZOdIwMCpGrPsWSzPDg/zdE1jMqi5Eeh6lulRnSViMvLbRMgKoVz0wEPXmA6nWcjMOaG6Opm7MQ0RStZnbWRLRAdxmaAon5lSgluCJPjqt9P3e7sOJ5//Pf2ROEN8Ld4jViTOG5GsQfVTSbQIFszCobhIWMQ6XI6Roret6bEevJFCamk+g1eO8mytWm9GPfF6LlyU9CmpDG2C5iBtaN7iQzAUOn//lUYMO4tZxU8g9CYry4BR7KHzrLLnQ+WGp9PJepJ4Wpet4nDlOxbY31O4/XTNn62JdmRhYXuut8K2Fn/n/60nJA7a/gXkNoUyojG/ApvHpKiBUWQh5+vyJCjliatNBS5iGz51OOkHAXWDuxrrzUJbJ61n4g19q2j3j5u8D5HXRnrWJj6ckLIlEM6P+JPbwa6jlcMBP+C4sc0u2BepH+3hO53V4j2n/E/Wny0wDOD04zqysFSq/4kx3MkXQpG0kfah8GfQCjTVROTTXnA3v76sFrUJ41Vn4cLnNpw4SA6vg0+XUFg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(44832011)(316002)(8676002)(478600001)(2906002)(66476007)(4326008)(66556008)(86362001)(66946007)(8936002)(6486002)(52116002)(7696005)(186003)(5660300002)(36756003)(956004)(7416002)(6666004)(26005)(38100700002)(107886003)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FnAxzrxnpR65NSBgjx3cBQQGYWqB4x74GIdVgET8MALSih6I76AST1mWnEVr?=
 =?us-ascii?Q?lft+4Bo7Ap7v4nQPXEthSb1Fz/wPdGqBZ/cCF7Cn+38lY3CwyL5DJ5Gujdgn?=
 =?us-ascii?Q?IYS1mq+7aky5RlKsx+uW3xuRRx2dr1acI+kMJM/2xYP0hpgyMS6szXBNMV+2?=
 =?us-ascii?Q?YSjxZ1pDg9oHTvxJwCeCxfk+hEOlnkpOMT3MrLVeetuGRxKS7K2JsjKG59mx?=
 =?us-ascii?Q?H5eDtIlFtzP+QRT+Ao4JhaC8vpF3fyonJrGtxNe6R09priAQwEQNf7do6haM?=
 =?us-ascii?Q?ARpvj8IKOVvIE4mX5KdBiqU93NZu4k8tfcHcamspq9SQJ77PFa3scUJX9ETL?=
 =?us-ascii?Q?Hco9j0MclB1rrrgyubcAdk4bQt6nZQwAqkDQ6vKN2t8o1qD18PVYgL3jRP5G?=
 =?us-ascii?Q?DqAt2kGnMB+F4sV42hHgRVN6TorDB2g3NW1aCszCzzDMgCui4AbqiyYEjB3i?=
 =?us-ascii?Q?svhvwmUsYsRfkibNGvb45+35zvK1utybRmERDfo17LKyY9UmYzNkSkwvihWi?=
 =?us-ascii?Q?+A2tKXnCGmlq4EgZ1rA9WVz0N7w5Z8GrK1zIv4zsKN6GArIwOx7HLtGOQtD/?=
 =?us-ascii?Q?SNuajnUvokTBJ3EkMMzRz0RUfm2JURip15r8Gp1PpZ7D87rf4UsweC89Eyoo?=
 =?us-ascii?Q?gM3GXfmiUWF7C7ndtuQDFZQlLZE2H7dQ3bnr+aKksQdSxvIXOBzkPP6pSaD5?=
 =?us-ascii?Q?qnUb1E9KCXIDsGeHuiHfC9Dy9K0RA6OK2HIZpSi8B+Mzx7BL2hAlDthuUIyu?=
 =?us-ascii?Q?ShAhWFC5XKC06YPSp4d/x3GVlWBLDvI4Y+FjSIudoGlG6pIHGNXoKH7fQdEa?=
 =?us-ascii?Q?S7ndf5kEW0CYxFbbNaZX1s9h/pBLlFU4FhdKzx8bYmOIDY2oC7NC61QVoDCL?=
 =?us-ascii?Q?hQskgYu1pb9XdwmsTWB0yhqSyygf0X2sXAUgaYSxgOjp2S9EZgsJNqBfc9iF?=
 =?us-ascii?Q?HLf/Mq17f2i6+HZ214p72qLhWMQCjKZ6QV3zedMc37qlYx8AS969AOSeosAk?=
 =?us-ascii?Q?7Y63p3l+HUDdqY6DO6VGTqA8DdR8CHsgPhPIsex7220+Vu+tYqLwFRusUVOq?=
 =?us-ascii?Q?kUBc9J0J64h24ZXO4ZdTGzEiuPxNWPjN7/+9MOn/ajmUFnrPMLi/IYDVCF3F?=
 =?us-ascii?Q?dycWak/hRc6w+WQeZKPC3BVGuK9EbsaCD8OlBRKJV//6r9KsInIc+LWYnbxs?=
 =?us-ascii?Q?0FSPprZtP0lxVOA2FM7/f8rucoSZ/NPM1lRWpFb25FrC+X5mL04O6DRuUVmZ?=
 =?us-ascii?Q?GRRbhQFqY6NpUgW43LUKb/sDRT2+QpCTWULi+XIa/5A7yV+KGSRy7G8tq/b6?=
 =?us-ascii?Q?kCg2907zX0ZNTuf+H4U1ZErt?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e7244f4-7070-4985-ed8f-08d947a365d3
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2021 15:15:36.5116
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YoGJYw6/mr7C7pMY9PWbHOXPebEW3ReFlLu7R1IVncuFZ0tZ2dpegZQ3e0ShV6xorljzF9mABawpv7XrIs1ubw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5123
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10045 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107150107
X-Proofpoint-GUID: ICdq73TMgfEmG04Uv_0yMjev0UdILqXs
X-Proofpoint-ORIG-GUID: ICdq73TMgfEmG04Uv_0yMjev0UdILqXs
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It will support strncmp()-style string comparisons.

Suggested-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/testing/selftests/bpf/test_progs.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_progs.h b/tools/testing/selftests/bpf/test_progs.h
index 8ef7f33..c8c2bf8 100644
--- a/tools/testing/selftests/bpf/test_progs.h
+++ b/tools/testing/selftests/bpf/test_progs.h
@@ -221,6 +221,18 @@ struct test_env {
 	___ok;								\
 })
 
+#define ASSERT_STRNEQ(actual, expected, len, name) ({			\
+	static int duration = 0;					\
+	const char *___act = actual;					\
+	const char *___exp = expected;					\
+	int ___len = len;						\
+	bool ___ok = strncmp(___act, ___exp, ___len) == 0;		\
+	CHECK(!___ok, (name),						\
+	      "unexpected %s: actual '%.*s' != expected '%.*s'\n",	\
+	      (name), ___len, ___act, ___len, ___exp);			\
+	___ok;								\
+})
+
 #define ASSERT_OK(res, name) ({						\
 	static int duration = 0;					\
 	long long ___res = (res);					\
-- 
1.8.3.1

