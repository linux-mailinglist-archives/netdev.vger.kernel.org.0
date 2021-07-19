Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 424893CF033
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 01:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443294AbhGSXCl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 19:02:41 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:40062 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1388661AbhGSVBV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 17:01:21 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16JLa53e004803;
        Mon, 19 Jul 2021 21:41:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=8xrimcTTRuln132ZrcTynjBrAaSInFN/hHcnv7+/BYA=;
 b=v8NAr6qyreGCjZOgf5xjAlGdbZhrRtrxq5fUUHGxQe+0GvL8cICJ/pGkbNX0eW6hkk06
 NF5V+cXT0aospVHU9FkkVlEZajI6Rfs+psQubxsbzLDpFIA3NoHcFNCMQHLyf4zyR89q
 PWvj/Kr2dL3KjmSNTvCfMoQ2O62DGIaKZsjiBqR39c+lIYMfK2bn37qUteqzDLFa6M0R
 0syK5MjJZuu/2k3ZBK3EdC20q1bOz8dlO49AWArQHvXaigu/uANapFbcYh5CwUnSFwUD
 MgvjTqqK1DiamQAMxorh1PMTg1vrQvrQGVR72hpJoxtFoQ18IoHE8ulErPyBeG7oh0M0 Pw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=8xrimcTTRuln132ZrcTynjBrAaSInFN/hHcnv7+/BYA=;
 b=znhbimJFWnVgr0ABJB+vD3U73jouIQ76qeIxjvNPtz5VEbf1bjlAwO9u8U9o48HLFtws
 33Xsi3OktjAPerxKQlpvGMQg+TykobJ6q+VIxf0ppsnCtZaGRQ8jII6Jd9B7K+3eTeHw
 p3nh3N82DRBCdQWHb0CX/O+1UFpA9fGAEpM/SIVvHAdA2LI1qKp4IL/cMLcA6zx/aD+9
 DUmUnQM6k+bOzaSJw3S5KTWHyI0ehVuLcsXnw3dm8h5V54a61TtfUvEA6jCETV9XZj8Y
 2ZcH2qQX5OQrJrmN7z0KFJ8Be3QimPdNxeSEoDG2rF5K8uZf1qbD1Jv94eBca7MC5Rct Pg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 39w9hfs67g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Jul 2021 21:41:43 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16JLeRKG085203;
        Mon, 19 Jul 2021 21:41:42 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by userp3030.oracle.com with ESMTP id 39umaxsucp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Jul 2021 21:41:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bxwykeUvF8wbtl5rnizaOGkKPgoaWjTDfyeJAU4dC5GYUrApT1rvs42it1wqWhgMvSNqCVfVw4MfaAKOob9UM8QYeo/0jJhJTKGZnzX9apLNoDA23vvv1rP5bmoOZax2dpg308ToYDgCsRBQu5SIXm0+oNQP+Zo2AuiDFe146EF1Qo4MLD7jCb8PhAxGOFM9tkRV6gtMfcQdDoltnOONakJegCP9NcIVbDP6LjVVbpHwR+zeWtM6nqd3GJHeYSjTJhwNxZfDyj8Mew19awEdo9X+ULhGIYPBif6ZYYNiUeZo774p8lNXz23zDNuDXP40BfMx+mCSnUwii6R6fF2elw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8xrimcTTRuln132ZrcTynjBrAaSInFN/hHcnv7+/BYA=;
 b=SfB6ke7fPAsjDGxXjBycrOGqwAXv97h28UqQctlzvkK5KNFCFjdplzrdnqBs9Vg15YdLOiFxfxIxlQorQyaUfO4AtF0OQR+aPDw+POA+cEZ3tP0705Jn8M6W70qhkZGRIyW68Hg2+2gGTCaR8qQ9o/Dy/u790BemhXIdmxgTQkwMGKVNbtpJ7+Tlw2wjcMznOF+b6jZw9yZTwUXXun4vxmuoGOqwhNuJFtdT2aG/FG5x5VHP+7fQOgLAo1NIPSEan/eA0Ip4V8jC65Spg00sm1iyesIfiUKc0mObyNZOXUhehr5KtzoiD1Zk+r4CAoYW9x/JgZdJakKPVSMiiyop2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8xrimcTTRuln132ZrcTynjBrAaSInFN/hHcnv7+/BYA=;
 b=ptkcdPFDYJJK+cyJ+lG5IqMIQszqtONSbO97hn/KI9pS8sC1CQwVWtwpr3uDNxdVqyR84VobBiQG+qi6RQkuMQfVFvTGRX0Q8aYEh+KtZ++LPT8sllgjGZHjSRUug2Kpuoztm3UFcO//5bJoyFWRvHnF1L8/puJMmRrhE3dn0gE=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by MN2PR10MB3312.namprd10.prod.outlook.com (2603:10b6:208:126::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.24; Mon, 19 Jul
 2021 21:41:40 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::39e8:94ec:fc2d:5a56]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::39e8:94ec:fc2d:5a56%9]) with mapi id 15.20.4331.033; Mon, 19 Jul 2021
 21:41:40 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, morbo@google.com,
        shuah@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH bpf-next 3/3] libbpf: propagate errors when retrieving enum value for typed data display
Date:   Mon, 19 Jul 2021 22:41:29 +0100
Message-Id: <1626730889-5658-4-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1626730889-5658-1-git-send-email-alan.maguire@oracle.com>
References: <1626730889-5658-1-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: DU2PR04CA0278.eurprd04.prod.outlook.com
 (2603:10a6:10:28c::13) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (95.45.14.174) by DU2PR04CA0278.eurprd04.prod.outlook.com (2603:10a6:10:28c::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Mon, 19 Jul 2021 21:41:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 608e8286-9d9f-4ca1-d13b-08d94afdfe3a
X-MS-TrafficTypeDiagnostic: MN2PR10MB3312:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR10MB33125D8910482F4D6FCE9B31EFE19@MN2PR10MB3312.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eVUFpObVsEEJZvtU+wvE10BakUp5CHmxUfhRECYuZreTvtVBvykOKED6tvYiBYLB0uwUEzPN+NXb9X7r1KU0aYFTemV69I848I3DYItRbMk9dNreQqTT/LQ9xBA/nu7WEA4U/JwPfWRUrKD6X+QC75UjGWM6jORBpVNkCkG4lJY3iLYlGVJrISCR216ibjk+wyTO8IqiMV0O6iY+dJs1pgJ2XfJjWCIGn8s5mO9VM/7LTQf7yHKujbSCu81mE0/AWX/KhUtqrGNiJ0PjqUzVApfd/iorkKHXShkrBk+h4yegcsaF7wXqZcm/ejedYNMN1EBNNJ3kZ5yLmhmz4f0/slwZBNC8wgnCzV31wKV7WlKvpLD4i3GlJBjX03atTWg6Ecq8AjddjwV77iWLbCHwg8iG4TBCSB0HXleokb7pij33ThLYY5Bzw+NCufhObQ/M5QS2TcM4PGMA8GjRormw/BcIcfHqchvlh/uiEu9g7p3ezsPGUx8CMIeoBl4j60O6qJRR4zmydbUV5lsKGxrg/ZQibFZUpNMjwmaIPwyZgcaSEXvJVQzDi4fak03mvFXxyw1zX2LDVLWVCQu2i4oDgW+rpwA9kWPuekmbxCuoR/xdFG7oHAl+2bETOSQtEZAgg69z6+ylvjPpWH7Ky3ac3bgyzzixlXNwtqa9RIXCQw/qKdf4UrUzn1THO26pXCOtUKUnk6sT4jngi47UjXp2aQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(316002)(2616005)(956004)(83380400001)(36756003)(6506007)(4744005)(186003)(44832011)(38100700002)(107886003)(38350700002)(86362001)(6486002)(8936002)(66476007)(8676002)(6666004)(5660300002)(4326008)(2906002)(52116002)(7416002)(66946007)(26005)(66556008)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?f0CuuSZhG/Sebtq6+hbehAVs5oSLaWnYManvVWNbLomU/HD1OK/hbWEtLCxc?=
 =?us-ascii?Q?G1J55hvV6WP5K02xDewzisCZYIVGB262HDIAj7hTbWblWksBVgyppDchoM67?=
 =?us-ascii?Q?MP74/aGGpR0Jy03TIeImxJem9mGfIQQyFyGxLgCysDrscY8YwMJlELsXqr4U?=
 =?us-ascii?Q?QPre1L4U3oiIp85mJwU1lBqKN4UBQajkHF9eb1p+AK360xa5ziYZ9f997usi?=
 =?us-ascii?Q?RL6buriRKnFrk8tmLqneYJcFKoFyhYBorG+ORyYMmaL12fJS5BlgzsPEXfRo?=
 =?us-ascii?Q?h2Np9pPFpTDkPSudCmmL9gmpIw2etJ7eOTBz3NcVzi08FGc12XWMKLuz6Xay?=
 =?us-ascii?Q?GjkjS+1szDKLXsI2Jtj8fPd7KRV/rvxYfnxoDFmTKnBNEhgqYu9yucj0aApv?=
 =?us-ascii?Q?K7uM4ZT7fjk4lurz35t4H6/hJz5At21e6p1/ZGvFOywwRIV817pL4iF6hzeN?=
 =?us-ascii?Q?858espGq+hFzw5XvY2td3E5q/KCW63k6vjqIi4E8+u0A2dcDq0vG4HwE0axo?=
 =?us-ascii?Q?t3DkD2FGfUTEbkN+8JaJoyR9MXnselcc3Z7XpYHPegt+fd9jwgP7WQkOPYsc?=
 =?us-ascii?Q?623/0Oqm0g7vo1c8QitbpcuVRw9cnNGUECV7+fcAj8UIpSwa7z4Kt/O2KfnX?=
 =?us-ascii?Q?D0g/lyvmOFu4n9AfwaHP0XUybKC6G5LZJqVM2nsBZC0PBPUucxiQUHc1OJFJ?=
 =?us-ascii?Q?TodqSKMTzL2qAZ60rsJnZ3pOo4SYfPDocjpNhx6nkod6FVJ92cSisvXXxMuL?=
 =?us-ascii?Q?krJI9PDmGZGvaNdP/L5i83RkKEmdwq4bGOhAPvu+sh3KMfovqLJUruYbPJMx?=
 =?us-ascii?Q?sBBguxttTtKLMJP+CV/qUU/+9xDPFKKto1OGrPl5Lw3+L0HhOaVO/a6IqWLt?=
 =?us-ascii?Q?81Si4W+dYFotaXVaP31/P9dTcUos3y8RzDF0yQctq9anCmGzX7F+0Xop4fap?=
 =?us-ascii?Q?6hy7pE70BaQBAT0ySwJdt0wk3ABt/RRdC9Er605vST2DfroUmnYtGtjjEJUS?=
 =?us-ascii?Q?hAH/ZNGzMpmam3heDnspb/MPYOzCEiA4NUiVUpYwpNOxIxKvAQyzPqNYoWPG?=
 =?us-ascii?Q?yMvwMy8eotJQ73ALuo3/e/H2wFfpGwGPEP8fSd00pXSknq697jQeAZYhqPbe?=
 =?us-ascii?Q?PeNU1M28JV2ke9n2QxhXClkNUnePGqDZWyo6vjwgQehGZm7KU2LoSGs3Bc8f?=
 =?us-ascii?Q?f7djtIFNUYQLGObnH3/Yy0wtAC+nxfBycOKmzlg/9vhTF68W8zktCJ273Ia8?=
 =?us-ascii?Q?pzg5NOH5q3VaatWWzyeE+p0kctUJlJyLt3bTk2kXApeCD+AiEralfL33dX7O?=
 =?us-ascii?Q?dRJS1DYGylfHvYerMyRFsMM3?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 608e8286-9d9f-4ca1-d13b-08d94afdfe3a
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2021 21:41:40.3359
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hkR+qvCcSJPPT+7nzPDE1ZHjE7oLsLS7oLyLga9KETitO3ZqP753Mx9vueOXUDKdxrsBJMq5Us86HNrKY9/aSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3312
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10050 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107190124
X-Proofpoint-GUID: Xwqm6b2cdEiW7LDKG--FzN6ETrYVR0wi
X-Proofpoint-ORIG-GUID: Xwqm6b2cdEiW7LDKG--FzN6ETrYVR0wi
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When retrieving the enum value associated with typed data during
"is data zero?" checking in btf_dump_type_data_check_zero(), the
return value of btf_dump_get_enum_value() is not passed to the caller
if the function returns a non-zero (error) value.  Currently, 0
is returned if the function returns an error.  We should instead
propagate the error to the caller.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/lib/bpf/btf_dump.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index 4a25512..ddc900b 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -2145,8 +2145,9 @@ static int btf_dump_type_data_check_zero(struct btf_dump *d,
 		return -ENODATA;
 	}
 	case BTF_KIND_ENUM:
-		if (btf_dump_get_enum_value(d, t, data, id, &value))
-			return 0;
+		err = btf_dump_get_enum_value(d, t, data, id, &value);
+		if (err)
+			return err;
 		if (value == 0)
 			return -ENODATA;
 		return 0;
-- 
1.8.3.1

