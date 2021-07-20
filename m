Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7ADB3CF65E
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 10:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235181AbhGTIMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 04:12:44 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:7388 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234725AbhGTIJv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 04:09:51 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16K8g6wY026401;
        Tue, 20 Jul 2021 08:50:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=3Kxgyz1cBR1FVhlGxpQZPYoZeqUSJwYJGNBOMS3cMeM=;
 b=y8rFsvVVdMUydpnySZlcfVaKgUaERrCKDbkKe8J+adcUUXYtSzCHbR9JULOlXnYFQCia
 Zm0i9qGz+3qxMQsrDIOrxOsprr9XDACBKSHhMtVwYtRGnFIbuNfn2h+QrhRyXKI1h94X
 s8EB8il3VRedFaxznF7aoENRiVCwHEiox1oNR6bEEgJGTkK8thh9+M4vRnrgrlG6E0l7
 NkzXYsfKh/yRBUxndild2HxH9OI8jFMVF819wc53mQvy9fshyFd6rZEFEcIBBwXEAdpf
 /msjyV8kH6ap8sRYQsizYUjOuY6skCwRDkqgnyGJTlxJIjn4Wp8fCgG8NCQ6KDYhv1Vu 2A== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=3Kxgyz1cBR1FVhlGxpQZPYoZeqUSJwYJGNBOMS3cMeM=;
 b=GQyQVkTBVDVR90cGq6Gg/7unDNmAY0xa7suGHFgZP8kBRSyS9aaMcziE/vgknfkJAyDi
 X8e+ndRaBAKczsFpK2FdC3BaYxVv7yp/0DsI954eitXX6l5AZOKmH/Du/bJhx2r5JjsA
 STBwyn1HxWxtJxl0LbPM7RoWjCI+FD5XihMWDhR56ovejvnZYk7+P7KgbBoe2oea0YuF
 55+O+wqLabWsmCHkzS+7rt4XX769EgMX0oqcuWjCnqELXQYuy4SfTy+PwLODqwaJx9sK
 b+1BDA1w5mxWpBNAEL8rkccyKW/P8uc2hVETvjMVq3S+N2MPB5kJ378+IzZYOpB1juo2 TA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 39w9hft3v5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Jul 2021 08:50:12 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16K8fHhL048484;
        Tue, 20 Jul 2021 08:50:11 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2041.outbound.protection.outlook.com [104.47.73.41])
        by aserp3030.oracle.com with ESMTP id 39upea14nw-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Jul 2021 08:50:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uvsf4FQx1fgb5cUgXVogGmOo5TQFJE41AowIL/vnIhs3htVmZfHRyEUMJCvn2pgo4Hzi6QAHjpc+UB590f1lCJ06nZCk/7hWcGEzbXxHX2WfuMpvHewtrpjacncFvgwbWawIRd0bkh75nUvOSK5qLkiK4Flht98y79lyC/bkME520XQiYu1uJBmrv2AK9UYGDLEbmY7gxuUk+J3tAOcqL+AwLa2JWCMUwMMbbwpgFfHPBuCkiReRjH4DZM0WdZ5PnBNZEaswI2zyU+8kLGZGQQUQM5HQq6+4IJbVE56//rks351FUPc3jJsxJppBTZ7FfCftppad+JHpo7R40Uo++g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Kxgyz1cBR1FVhlGxpQZPYoZeqUSJwYJGNBOMS3cMeM=;
 b=Mh/pJ6vD3+VjtUhjmpdB069yZjWIhhF90kHenJ6qxBcqaygvDVuuTTD0ieiTfRX0eU5Cypod7KGbg3+RpPOGeJ84YsXK1wnbi2sabPcEK+AcZyRkSRcGCGrYx0dWzV/rE9Jg6hzQaX4ZdCBTqVmi+EAiH9NmEQHOY+2bxlI8psuBNL0ztRiDLFvGxF/cqJrJAGy7hVb4Wt+5m+D2qYZwFR7eQ/s/bjPe1sTMvfBGkR1n2Thu2BU+4Hi3XIj9x+nONvq1+G2t2UrTUsxma1SSkIKBttI2PklKGSF/ETO0j12BtbSxRT2baE27v4hTuaMuVZlWCJO31bs3c3ZpnngtVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Kxgyz1cBR1FVhlGxpQZPYoZeqUSJwYJGNBOMS3cMeM=;
 b=fRjUBkCpH37eo/GQo5v1nUDj6/CudvUN40Z/yFH49gl+tBu4tWMb5zSAduNxHI+UZXFRTmg3ZZ9jFmS8szoP/F+qFDiXAO8ULupFR+b3gijvhQAYQz4mbuJ9LwjGhzchh0EzwVcBFh8YA5HQAt1TJOVtt4G0+/OXEpOEQ3EkZi8=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by MN2PR10MB3470.namprd10.prod.outlook.com (2603:10b6:208:10d::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.22; Tue, 20 Jul
 2021 08:50:09 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::39e8:94ec:fc2d:5a56]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::39e8:94ec:fc2d:5a56%9]) with mapi id 15.20.4331.034; Tue, 20 Jul 2021
 08:50:09 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, morbo@google.com,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v2 bpf-next 2/3] selftests/bpf: add __int128-specific tests for typed data dump
Date:   Tue, 20 Jul 2021 09:49:52 +0100
Message-Id: <1626770993-11073-3-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1626770993-11073-1-git-send-email-alan.maguire@oracle.com>
References: <1626770993-11073-1-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: DB6PR07CA0158.eurprd07.prod.outlook.com
 (2603:10a6:6:43::12) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (95.45.14.174) by DB6PR07CA0158.eurprd07.prod.outlook.com (2603:10a6:6:43::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.9 via Frontend Transport; Tue, 20 Jul 2021 08:50:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9e2151b7-d819-432b-abbe-08d94b5b610e
X-MS-TrafficTypeDiagnostic: MN2PR10MB3470:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR10MB34700CFD6713686EDF5B40C8EFE29@MN2PR10MB3470.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5z+Tzydo1HAt1HnGaHtAFj0kOdw79a0pV5/HgmAtVpppGcaq70aCtY2fXHkZ4T/J3AXv44lLu/U9CCGWXpMRpZJ3BX+03mUVGciYrJUNMVYe7dJRAe5yLsT0lSOm+OhRC3Rr1vYQV++BOixt6Gx4Ddme/nNTezEQ7TEmXwK7YmY63GM1n0NnAfVQJbz2PIQixTWz3Ov0LirIY89s3wEQMeoAju8ghzj3ssk5o6UgRt2ii+ADNmTAchNEgZ5Z0SbwQHm7r2v0exvue+HKFqSeyfFsN4/vS3i4XSyXOjgSBCGpznwZL2RQXVjJ0b7h90oCp73OqdjltIsLo/lg/pEhQY18Q4PW4VRtpSUfHbK8FFlXUniuIYjtTrrLwlfj8CH1zRIey6ODvQK0PUz4mH7pKOqbElFgZP+vTBnRRPT0SChnvl+8HUdnJuprtQ/3JiM+nlPD0/GwUeJXwmG/tA+i+I92RojdGuUgyCmobSRhwFHVQStc4h5TfPtfPnX4ZV4ynG8APYf8bNsUfj1eFZvy/TBhaB8LvfEccrLP80KYsn0r/yKu7NXEoiOZIb44XFHnYN967+QwlmWf6Pj1l5QGiUN/Wb85u6aAPQENZ0w1NU38JR/q3pKrePgAtjxpiNHCWrD671onv3s+iJalSKOelwn2GGnnl34gajK+0fQRQnzbmLRIjpoiJZ4X7GQyN+aj75IKasCIVaZCJKoCCQM99A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(136003)(346002)(396003)(366004)(6506007)(6512007)(8936002)(2616005)(107886003)(26005)(66946007)(66476007)(956004)(6666004)(2906002)(4326008)(66556008)(86362001)(5660300002)(36756003)(52116002)(38100700002)(38350700002)(8676002)(6486002)(44832011)(186003)(316002)(7416002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ThSMjX0QL8j+xxecg/XLwem09HU57ZTEWyL94sDeT+kJEcGU0lwK/JtJ1Iz5?=
 =?us-ascii?Q?dQAzE0tgefFW6Ss5s8g7AmBznYksnQjHc43+cmzAXS1S6QxZ82dmhGmgpw9V?=
 =?us-ascii?Q?Gnsnld0FMgziKda1nl9RgUdPcHK5nJkp1ORL/J+q9dmw1H5KdRutLl+G9soG?=
 =?us-ascii?Q?jDoJcKBCqNUNuT1WCxAZq7PNHmlEdildL9hLpw5G1hYmUUTihpGEjQNDL6tM?=
 =?us-ascii?Q?0X7+GyzNZ4Ol1qbjpDctOdLvXg8bjQytaB2Qw49aTRYLSw7PFwbnC1tUFFo+?=
 =?us-ascii?Q?Eqnrl75BKOa2liGTpppvaXqyve+c6kOmOb0S0bD4TADvAhTAFufLlOkjCW9N?=
 =?us-ascii?Q?WOp3z/y2g/CqlCp1BHsDKHEUs05yH2Y7ah+gLfGBhWA6/vq1GI0fxuBovQ49?=
 =?us-ascii?Q?KhzKhoqRA/EiO7HlsxEJhwJAfQiQiQaTKCnXAeQLc1hygCtZoTkLesx9PKor?=
 =?us-ascii?Q?/L81j2qfMxTzTq4bIM5Sjt1FI+r/aWhLo6KPXqsiQEGsr99GF71KG4kIHa//?=
 =?us-ascii?Q?Vkr5VX90oPSQbf7WEXQG6oxEi1eTQNzUw+1PL0SkmXEkyBs7vaN1g4WSvCVl?=
 =?us-ascii?Q?ghEuHhvUJh2Ur5HVRHQ3n2ZsF6MRHE1J81jfmgHkv1mLNlrj3avj+5pF4m3k?=
 =?us-ascii?Q?fbouoHy4pqyPBQ4hKzrydTvgoU+QE2gs5JDs8ex7wrdAsvUHQbqgLklawNQD?=
 =?us-ascii?Q?D+984fbFxrXf76Xwbzx0b0rhjpg2I/S/RZRIkJ9hRG8NuRSYr1OEPiiZIDrS?=
 =?us-ascii?Q?sAyiWzmdWsMXBnQGy9SLau4OAd+lSToIT52mS70vxrzpwR0gwhMOKeArdye6?=
 =?us-ascii?Q?SMhNZ7cvXmOpbREEA7+XinWxLAmvHplRH+MOMWdp/oQVvihZupZH2sbAOhaJ?=
 =?us-ascii?Q?imZGfHoRKhmL2F+ARAP3uTSfR5wKWGd49GzJ4+2+NhCkGsANSmRHIma2t+wy?=
 =?us-ascii?Q?qDhYUeQ8wAjDa5BIfzpNlp1sbb1+MaQ9QnnK/VhBaqRc8k7kqqh5hMx/WlHk?=
 =?us-ascii?Q?nvg/cXbkULPYNuBrL1bav0a3tZBWJMjKVnSfWnbMtC+d39uDoz5J0PVqc33/?=
 =?us-ascii?Q?Zw6QJQdE5Iwnasl6BIEHvrha+5LNt+ytF9rzMJ7QhCC/HZfjpiEA1PCSy3r4?=
 =?us-ascii?Q?o9zlvSv8d+B7xc5wXE+Ljw+G2Jr31V5pXsociQnnNOOr+Qkor9ySoLBZ0P5n?=
 =?us-ascii?Q?BWFRzJ+yAWv31UFM6EeRSL/IbumHV7zGAVS7PdsKRCCNGRulTazjPArK1UMR?=
 =?us-ascii?Q?pzxu7f+0zNkiRY9huPbVRrxvrtQIIPDhNIQKSJplOdoS/8YAACiyGhnzCL0X?=
 =?us-ascii?Q?HMfyZk0cdySk+PJ03VExfFdu?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e2151b7-d819-432b-abbe-08d94b5b610e
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2021 08:50:09.4215
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hUAUCtq7VKBHeBBCTozKZnTBsNmZVOyVrd7nzo/NioTH+0uJqYGtZozR+97FtY/NmADMX/LQSnX0iV/MjWgo5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3470
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10050 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 bulkscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107200052
X-Proofpoint-GUID: imG1uRKnLFcw60-ql9ZwVaQiEPOOJITU
X-Proofpoint-ORIG-GUID: imG1uRKnLFcw60-ql9ZwVaQiEPOOJITU
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add tests for __int128 display for platforms that support it.
__int128s are dumped as hex values.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/testing/selftests/bpf/prog_tests/btf_dump.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/btf_dump.c b/tools/testing/selftests/bpf/prog_tests/btf_dump.c
index 0b4ba53..52ccf0c 100644
--- a/tools/testing/selftests/bpf/prog_tests/btf_dump.c
+++ b/tools/testing/selftests/bpf/prog_tests/btf_dump.c
@@ -327,6 +327,14 @@ static int btf_dump_data(struct btf *btf, struct btf_dump *d,
 static void test_btf_dump_int_data(struct btf *btf, struct btf_dump *d,
 				   char *str)
 {
+#ifdef __SIZEOF_INT128__
+	__int128 i = 0xffffffffffffffff;
+
+	/* this dance is required because we cannot directly initialize
+	 * a 128-bit value to anything larger than a 64-bit value.
+	 */
+	i = (i << 64) | (i - 1);
+#endif
 	/* simple int */
 	TEST_BTF_DUMP_DATA_C(btf, d, NULL, str, int, BTF_F_COMPACT, 1234);
 	TEST_BTF_DUMP_DATA(btf, d, NULL, str, int, BTF_F_COMPACT | BTF_F_NONAME,
@@ -348,6 +356,15 @@ static void test_btf_dump_int_data(struct btf *btf, struct btf_dump *d,
 	TEST_BTF_DUMP_DATA(btf, d, NULL, str, int, 0, "(int)-4567", -4567);
 
 	TEST_BTF_DUMP_DATA_OVER(btf, d, NULL, str, int, sizeof(int)-1, "", 1);
+
+#ifdef __SIZEOF_INT128__
+	TEST_BTF_DUMP_DATA(btf, d, NULL, str, __int128, BTF_F_COMPACT,
+			   "(__int128)0xffffffffffffffff",
+			   0xffffffffffffffff);
+	ASSERT_OK(btf_dump_data(btf, d, "__int128", NULL, 0, &i, 16, str,
+				"(__int128)0xfffffffffffffffffffffffffffffffe"),
+		  "dump __int128");
+#endif
 }
 
 static void test_btf_dump_float_data(struct btf *btf, struct btf_dump *d,
-- 
1.8.3.1

