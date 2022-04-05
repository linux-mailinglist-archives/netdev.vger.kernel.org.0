Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A31E4F53F2
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 06:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2361303AbiDFE0d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 00:26:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1577946AbiDEXRq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 19:17:46 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2863B443C0;
        Tue,  5 Apr 2022 14:46:22 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 235IrxND004957;
        Tue, 5 Apr 2022 21:46:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=JZY1xe2NCXPuryeUsWCGnfCYkr+gzOq82GgXW914gbI=;
 b=kFEhUw8TN6q5sLfXr8qazohol598pnA6xGVURx3eFn44VPsU7mrNyVoXjsS100kcsKS3
 0/dw384xJLuTsg31R4jZagplBnz0rPsuM8hk/E21t0Yq5uwCU4FmEcMx78Z8Jhk1bqOq
 OvW4cDrE4PVtGmsk+IF3tKg4HTAHypuP4ldfyYVhe3g5fGmEI16zqbPOzLLnupSS1T7W
 ewSVAyLFjnr7UMZ2b3Qi+X/NlqU7OqPmHDb8c2QzLpQLUeNjYbdBxfUfv0DRV/isM63V
 4sD1VkPX4SzqrDqy/ZWtjQbmWeyM+JTc09Vu4JSkhPO9K+pVd49Aqqwc9HTZgx47Jxr+ FQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6d92ya99-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Apr 2022 21:46:06 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 235Leb5G016425;
        Tue, 5 Apr 2022 21:46:05 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f6cx3wq77-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Apr 2022 21:46:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jvoSMAT/AmA3sAYxkhiJ4TQZwOxCmr0FSS3Cu2Bpja9NF6666vH/Y8H+dozMku8qaiW21XvOkQRcGtKoJIumR+FzwnIMYjFnaQbrOEDJIcDvutUo4GDQKbdoYt1y/votN+tUwGdFbRU0lf7Nk4q9ffKxfgHv2QZQvWb3fq8ierS77h63KGUKzWOrU+kVUnqKVK6wTOrw5SI/LxGd4h9QlVTiklUDf/LZAlVUwraNva5ncr4Hghc9TOmA3DZrePOCJOoyj5MMEXi2/ZVmoSrMyFw0KdpVK6l07tfo/DCdTX2qmHQAjfoGXh3v8UYZWrv+nztb2l7m4cschRENJvB0NA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JZY1xe2NCXPuryeUsWCGnfCYkr+gzOq82GgXW914gbI=;
 b=EM0Xw+/2r/yf5ObgiEIDqv6d0b+639G6syrbwirz4AUe/uPdiEk2X5XuQei54UwfHuUxeWfQJ5UKZ9zLTOnNGA/nZzRQwjlibvcekmBsEAfg58+WJnmJgp9EIxMtQciPWsjTPpdVnOfAx/iCgru3dL559jtSZQQN7FwELFerOkn8A3eTW5tllIQT7auwWiACyK9PI9q6cpZE4Bpg2uR/D87HSTESoVliBQp/3OCeLDrRIW79AnQOj5pIqo49VIehshgRQK22Zx2xxhMYLUb+Pu0tn0x/K+nhcw6BwRjiLZ10/wHIu4mnwZynN/A8N8zNlRTuUTKpZjQTsCWX3yhhhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JZY1xe2NCXPuryeUsWCGnfCYkr+gzOq82GgXW914gbI=;
 b=aPZZ8s5ASGVEcoxPEc/HiYVnHJS8H6DYnunFf638+UY7I8JrcIGoM2MOfa/UD6L9F+rNp1mwZRMJQI+y46AUzzxH8xr3M4e4/ldtwpdQC3wglfio45m4CrOek2kh/RsrUidLD8b1bEtmfCNFdCGloc4T9q7sYA/U6WgPZleRbOI=
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by BN6PR10MB1362.namprd10.prod.outlook.com (2603:10b6:404:42::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Tue, 5 Apr
 2022 21:46:03 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::bc05:7970:d543:fd52]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::bc05:7970:d543:fd52%3]) with mapi id 15.20.5123.031; Tue, 5 Apr 2022
 21:46:03 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     andrii@kernel.org, daniel@iogearbox.net, ast@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH bpf-next 1/2] libbpf: improve string handling for uprobe name-based attach
Date:   Tue,  5 Apr 2022 22:45:55 +0100
Message-Id: <1649195156-9465-2-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1649195156-9465-1-git-send-email-alan.maguire@oracle.com>
References: <1649195156-9465-1-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0302CA0016.eurprd03.prod.outlook.com
 (2603:10a6:205:2::29) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 562e1416-22f1-4598-0b36-08da174dae47
X-MS-TrafficTypeDiagnostic: BN6PR10MB1362:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB1362FA2D024D6BB9D43FAAB7EFE49@BN6PR10MB1362.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 30GZvmseeUaoW0e1+lLbYrVFUw0BN8lrVAqRzQvmjjCqlI5mg26t5ctG8/yJGw8nkUAC+nvjJiyaCpagmZdIyVrMj7SzrB9FW77/cvyqb3tIs7StkF2/83FQ4NLSS1SO2HaQPpl84vq7MD/ttI+YfrcIVbTheaktu5WPuAGNpS3rG/g6mj7zNUSSF66NSuLXi0/KSP1ecj6+YVhdi/orFtOkOTxvmG0/VfI67YvaUE8tYhjb+TMWCaTIiBHeBdCMT03GvV8oyb/e6CYwk7O2MHGU4Cb35D6NirWRLcqAX+h+OLlM/MKqCut9GZ1hsJTQ8/RzjDKPuZADxEpprFNN+5swm4TYnzfyLHTE4r+yLxWMMzGiVZZIliMpwErjUVXso3UTYsP932jQ1ablFoYY3qttKL25Mc1SZeJQuiGLXDgE05dpapEOopXB5tzwWClM4fiGoittIdbf8N8nTOsaPQ9kK3gRqcYA2oiETZr/RIEqDDmImzXqFZUY8FL7dNO21G1Yd55tDhW5WbpGnKtnSP0YWgdiPYeIIIen0XGcE8iKiccAVGNrhmtu7vmvNG1CRzShYbwQA7NvOsEtE+s7hNGxmpWs6ZEpT0gpmPyb0NVuzgo2oagV5IZWyIkNtsuRkc+zDmQ++XNvbA0DDiqpj6riA9QHWRyZj2+xfgJYbzRZ+cOmuB/jLQPwMJgiF+OTkZgCN2BKQEuPXZ78ukfNDw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(66946007)(4326008)(66556008)(66476007)(44832011)(8676002)(2906002)(38350700002)(38100700002)(52116002)(6512007)(6506007)(6666004)(5660300002)(8936002)(7416002)(107886003)(186003)(83380400001)(2616005)(316002)(6486002)(86362001)(36756003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?e4qCwv744aGJ/CFpDlIR75Lp+K/i1bJXmtUZhEcRc29MqHzvBD1b82OP3U6y?=
 =?us-ascii?Q?0ZieZvXaqlWxRvDJ2GQHJlSsHs2VMqMQze54OqO4uxAa0AECiQKs3xTRbM3u?=
 =?us-ascii?Q?mQfVjOtOXkGNI8yJQepexGy6AHnERVuPDRWUDLTgCPOfg/Lj/5B3yF1RROk8?=
 =?us-ascii?Q?plorRIxeY2/JB0N7SesGIT6oHlDH1Y/6U18QIbslojV7KvbEPB2quwX9wX4k?=
 =?us-ascii?Q?fRDXEd06c7XRfVrv5C9golGsaHi3LIulgQUdoC3ClYEpYhVZs0fRULIASKso?=
 =?us-ascii?Q?QNSEwdZcRXwvkZe16ubVHaLzq2G3f0sXJmE+Ze/+iHpdvEGE/5WAji/S+nDL?=
 =?us-ascii?Q?3Vlsic6diA3UMNWX4smfMotXUUbreCYfDlydB+V7zj8chKrGL71IsUvGLr+X?=
 =?us-ascii?Q?9ZI9xxVZS4NVTM8rfQg/Mg0hMSOorI25/eI9VEyWA9K0uhnFZxT2KwWBvH+0?=
 =?us-ascii?Q?xK3vbamXxilqWheFxx74UbCfnNyKHcua3ah7GailRoCzeTYcCFaVGbUx//Fw?=
 =?us-ascii?Q?rc3i/ynlt0ZqzKJaUToQ/5I4XgD0IlvW2LKPUxMjPGT+0sHXT9wkJPlEtGY0?=
 =?us-ascii?Q?wbi/Jki+BF2r6lLgkgbYak75t86sz34cUKR3X2wezIdjYyF/en8OhO2c8G7K?=
 =?us-ascii?Q?nXS9CENlctkkvJJQH9+jModmS2sBhcawGO697cZKCgXRBS3Z70FSWkMKX97R?=
 =?us-ascii?Q?BE309YZKB09QSXTfYdthtc5vMiHrFrNUIWAspsWJf5SG2vsbGAdBt2R2Xxzy?=
 =?us-ascii?Q?yPcjunRGLJzqBvNvbt5nPXJngGE64ITQ1THi2diSIU7BgAjXEq8w5CY4O0Dg?=
 =?us-ascii?Q?QcjE13a1F96ZxpmTFjR/ytO1oRl44RgUyEs1+iUjl1WVNMGfiIG/UUnoRl6Z?=
 =?us-ascii?Q?gM0FzW9JH3k/ryxHGIkF6YyV2XbRWM/7nPIZ61P93FwHn5/onKOMDI41Oelm?=
 =?us-ascii?Q?umBv6+7RObpA8E3ShkntFJkxRAWKEr+sxCAYxZyyZPrBsbDxWvHToSt1T4+s?=
 =?us-ascii?Q?00f5c1YON+/Q69R77qJrkH6+89bxL/w+y8fOC/h5OWbLkBnBjS5LUropBZPF?=
 =?us-ascii?Q?Cvh6SHRjYZg01jehVFnq9pmr8x8bLZlzP6HAj+qJzvKalqJ0Z74iEigfDOVG?=
 =?us-ascii?Q?Y7vL/z54Ofcn2qIyzETRsu/iufH7Z52PRGpiDtS8LJP0W7DiYp+bzkkIV23v?=
 =?us-ascii?Q?zKi5RoqsqSGHMcPwyLb9Hm3S6Jgrta/hc2htg/fjeho5kqhPmoBi0TwkrHrI?=
 =?us-ascii?Q?GGSf2XIgglUoJ3tnVISGYaeZwxQsHihNjs2qOssEuIB5N26b/qmdBEiKIyD9?=
 =?us-ascii?Q?e5ubNCEZKjnX21IT8+3LjeARol2olcnHv70HSvHIMzJcC+jJnaYZspCiCXFb?=
 =?us-ascii?Q?36jsawehGDTFC+m1/d1wydzd6UQTWhsavKBfi3ZAoU212CVsM1KidDa3gDEZ?=
 =?us-ascii?Q?3jK5sI/hR5rNtzTm3v26U8v3SxtLBUdso/XMB+eIZs6jVKXSdvTTBuufxL1Z?=
 =?us-ascii?Q?HKtfMGNqDyNz14s6idFSFsThnFL5k6kiC5COGfYPxKGh4Yvyt3C/b86lv+UD?=
 =?us-ascii?Q?2N9JiesYyZvfigxl3o/2DRkSzTrzGGViAVR5BF4SDQNSgNSTzobS3Gf4S/sY?=
 =?us-ascii?Q?k3tYrJbOPsLwL3wmUCBZy6TBtAf5FN96M13WR6XFYaYJTWvMv76H+CBH4Ncb?=
 =?us-ascii?Q?/E6iSlPhC9hKfpaFfo3wBO7mVfoArHCvLnSAQNJTLjxW3uKQRrDPx32PWd/u?=
 =?us-ascii?Q?Tjmu2FkAlRRXPHcD/gRhv9p1wCI+AAs=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 562e1416-22f1-4598-0b36-08da174dae47
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2022 21:46:03.1877
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: glcdnuk0XjXjxyeopEoM0IjBj2CvudrCII2NhlrmJ4n7TXNGWROoyp1JAgfWnc2ZTXFvduiAgQ+8oSkWzIG4Rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1362
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-05_07:2022-04-04,2022-04-05 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 bulkscore=0
 adultscore=0 mlxscore=0 phishscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204050119
X-Proofpoint-ORIG-GUID: lAPTZiACRtwhG4e1SLTc2Adf569iq-Xe
X-Proofpoint-GUID: lAPTZiACRtwhG4e1SLTc2Adf569iq-Xe
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For uprobe attach, libraries are identified by matching a ".so"
substring in the binary path.  This matches a lot of patterns that do
not conform to library .so[.version] suffixes, so instead match a ".so"
_suffix_, and if that fails match a ".so." substring for the versioned
library case.

For uprobe auto-attach, the parsing can be simplified for the SEC()
name to a single ssscanf(); the return value of the sscanf can then
be used to distinguish between sections that simply specify
"u[ret]probe" (and thus cannot auto-attach), those that specify
"u[ret]probe/binary_path:function+offset" etc.

Suggested-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/lib/bpf/libbpf.c          | 77 ++++++++++++++++-------------------------
 tools/lib/bpf/libbpf_internal.h |  5 +++
 2 files changed, 35 insertions(+), 47 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 91ce94b..3f23e88 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -10750,7 +10750,7 @@ static int resolve_full_path(const char *file, char *result, size_t result_sz)
 	const char *search_paths[3] = {};
 	int i;
 
-	if (strstr(file, ".so")) {
+	if (str_has_sfx(file, ".so") || strstr(file, ".so.")) {
 		search_paths[0] = getenv("LD_LIBRARY_PATH");
 		search_paths[1] = "/usr/lib64:/usr/lib";
 		search_paths[2] = arch_specific_lib_paths();
@@ -10897,60 +10897,43 @@ static int resolve_full_path(const char *file, char *result, size_t result_sz)
 static int attach_uprobe(const struct bpf_program *prog, long cookie, struct bpf_link **link)
 {
 	DECLARE_LIBBPF_OPTS(bpf_uprobe_opts, opts);
-	char *func, *probe_name, *func_end;
-	char *func_name, binary_path[512];
-	unsigned long long raw_offset;
+	char *probe_type = NULL, *binary_path = NULL, *func_name = NULL;
+	int n, ret = -EINVAL;
 	size_t offset = 0;
-	int n;
 
 	*link = NULL;
 
-	opts.retprobe = str_has_pfx(prog->sec_name, "uretprobe");
-	if (opts.retprobe)
-		probe_name = prog->sec_name + sizeof("uretprobe") - 1;
-	else
-		probe_name = prog->sec_name + sizeof("uprobe") - 1;
-	if (probe_name[0] == '/')
-		probe_name++;
-
-	/* handle SEC("u[ret]probe") - format is valid, but auto-attach is impossible. */
-	if (strlen(probe_name) == 0)
-		return 0;
-
-	snprintf(binary_path, sizeof(binary_path), "%s", probe_name);
-	/* ':' should be prior to function+offset */
-	func_name = strrchr(binary_path, ':');
-	if (!func_name) {
+	n = sscanf(prog->sec_name, "%m[^/]/%m[^:]:%m[a-zA-Z0-9_.]+%zu",
+		   &probe_type, &binary_path, &func_name, &offset);
+	switch (n) {
+	case 1:
+		/* handle SEC("u[ret]probe") - format is valid, but auto-attach is impossible. */
+		ret = 0;
+		break;
+	case 2:
 		pr_warn("section '%s' missing ':function[+offset]' specification\n",
 			prog->sec_name);
-		return -EINVAL;
-	}
-	func_name[0] = '\0';
-	func_name++;
-	n = sscanf(func_name, "%m[a-zA-Z0-9_.]+%li", &func, &offset);
-	if (n < 1) {
-		pr_warn("uprobe name '%s' is invalid\n", func_name);
-		return -EINVAL;
-	}
-	if (opts.retprobe && offset != 0) {
-		free(func);
-		pr_warn("uretprobes do not support offset specification\n");
-		return -EINVAL;
-	}
-
-	/* Is func a raw address? */
-	errno = 0;
-	raw_offset = strtoull(func, &func_end, 0);
-	if (!errno && !*func_end) {
-		free(func);
-		func = NULL;
-		offset = (size_t)raw_offset;
+		break;
+	case 3:
+	case 4:
+		opts.retprobe = str_has_pfx(prog->sec_name, "uretprobe");
+		if (opts.retprobe && offset != 0) {
+			pr_warn("uretprobes do not support offset specification\n");
+			break;
+		}
+		opts.func_name = func_name;
+		*link = bpf_program__attach_uprobe_opts(prog, -1, binary_path, offset, &opts);
+		ret = libbpf_get_error(*link);
+		break;
+	default:
+		pr_warn("uprobe name '%s' is invalid\n", prog->sec_name);
+		break;
 	}
-	opts.func_name = func;
+	free(probe_type);
+	free(binary_path);
+	free(func_name);
 
-	*link = bpf_program__attach_uprobe_opts(prog, -1, binary_path, offset, &opts);
-	free(func);
-	return libbpf_get_error(*link);
+	return ret;
 }
 
 struct bpf_link *bpf_program__attach_uprobe(const struct bpf_program *prog,
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
index b6247dc..155702a 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -103,6 +103,11 @@
 #define str_has_pfx(str, pfx) \
 	(strncmp(str, pfx, __builtin_constant_p(pfx) ? sizeof(pfx) - 1 : strlen(pfx)) == 0)
 
+/* similar for suffix */
+#define str_has_sfx(str, sfx) \
+	(strlen(sfx) <= strlen(str) ? \
+	 strncmp(str + strlen(str) - strlen(sfx), sfx, strlen(sfx)) == 0 : 0)
+
 /* Symbol versioning is different between static and shared library.
  * Properly versioned symbols are needed for shared library, but
  * only the symbol of the new version is needed for static library.
-- 
1.8.3.1

