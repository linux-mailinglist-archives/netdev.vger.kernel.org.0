Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B37A4EC837
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 17:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348178AbiC3P25 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 11:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348173AbiC3P2z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 11:28:55 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDF711AF7E3;
        Wed, 30 Mar 2022 08:27:08 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22UFLbBx007047;
        Wed, 30 Mar 2022 15:26:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=y1fF5YcD2rlCj1OiSYr3RCgJu48iffewo4ZMGl9uPCE=;
 b=IYd6H56AjAofGqNTh+jDYxMWfeYYvvedJiqAcdKm9wqU+QqFLUj+rsmcJw3m5D1zEy+4
 nS4ZUi56N0Tn31Knk9RFy1h5QukGQ9Sv8psrQKMqcUJ2nJ9uoT/XeJ7lP45jMv4a7Dra
 eZH9owc7FY9LnWiIsw4VLGLOsvcbGhGYJdqT4tD70W9TUB/iggVZRQdq5UEkvwIWComk
 vacwBPOEpgnNWpdecnNn3FW0LvBjrmWnGyspBjgXGTx+3KPpIUO06CQlX52T8mLkzNWK
 UJ7vHZ0ryDTJXplbEd37g56BqMgLZTNaSYt3fEoAihMl0tYflibcyS0R4HxEMducrYKC BA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f1tes1t19-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Mar 2022 15:26:50 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22UFB4KY082540;
        Wed, 30 Mar 2022 15:26:50 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2040.outbound.protection.outlook.com [104.47.57.40])
        by aserp3020.oracle.com with ESMTP id 3f1tmypv59-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Mar 2022 15:26:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ubbkr9UB9s06tQQrOywQ+2kTXFl/3i3GfquT0xi/7Zmljpz/0uY/I1T7X/JZIA2NIfH0sLxeCl+aGEAgrUadsZoFMnCbiKGdn60HoRY66hYgbt3BY088ceCb1EiIdnqjdaJSRpSfjpX5A6skiuhuuLhHyRQfH87WwMtGDrmrcHtmY5/jVLlQDtJmGQw78LbWr5Hh25/zP69SEPapvF+c4mp2PiGT0KJUxrRUQgqlObTezMBDGAz6aywT7TQFNQuowiLIdeBjdx8F5fdAof5cyqxvnoRvv8Gwe9dVE3dQR9+u+HUunizOgGG0L4cYtcKbftvS7v7ZMO8m9DPRcE6rWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y1fF5YcD2rlCj1OiSYr3RCgJu48iffewo4ZMGl9uPCE=;
 b=FhRgB32PTzRkSBH4YsrLo5+wainuoWPIRftxhod5c5MwplyB5Wp+JSfL78/u4lvyA7p5tgMhXDFx7o0kWQlSeXhQuicR8aawCUgUcoqBo13DmoPzEDpiT6dkNz3gB7PGQu9I7k6e0G7xQK1sYgMN8WIHnsgwVkMR/RrX3UyB7zHMtj2CneK9miJi0e74CtNxKQwk53xvDXxNMtf12B8LcDToLo8lSkqblfHr0jBipZkRXSGpVW6cGJRXaqSrV85Yg3dED4GlG1F/eGXon1r+STiypxuwUMfIwbY06FWq3WiGJMgfwPVK6maHpTBj1Xz2shZ5OzLBFjC9IzCjbD55FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y1fF5YcD2rlCj1OiSYr3RCgJu48iffewo4ZMGl9uPCE=;
 b=vMTv/ZMxD8ldH4khIL0g7IyWGppIWIm5kUhCphrrOC6Zd2tdnCUpd/q0YovOO0vZnKusyTuwShROSjF8YSy71w2YUqWuPBzhSJMPbWhyir5dv1RLuJxW8UDyUY5HjR/t3SnxU219ayQGdGjHY5xyYz9OH/PFsDHtotcr9VBuMKQ=
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by BN8PR10MB3251.namprd10.prod.outlook.com (2603:10b6:408:c9::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.22; Wed, 30 Mar
 2022 15:26:48 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::1483:5b00:1247:2386]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::1483:5b00:1247:2386%4]) with mapi id 15.20.5123.020; Wed, 30 Mar 2022
 15:26:48 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     andrii@kernel.org, daniel@iogearbox.net, ast@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, toke@redhat.com,
        sunyucong@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v5 bpf-next 1/5] libbpf: bpf_program__attach_uprobe_opts() should determine paths for programs/libraries where possible
Date:   Wed, 30 Mar 2022 16:26:36 +0100
Message-Id: <1648654000-21758-2-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1648654000-21758-1-git-send-email-alan.maguire@oracle.com>
References: <1648654000-21758-1-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0362.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18e::7) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 19ddf010-c330-44c1-3f24-08da1261b4e0
X-MS-TrafficTypeDiagnostic: BN8PR10MB3251:EE_
X-Microsoft-Antispam-PRVS: <BN8PR10MB325110960848A0E04CB15075EF1F9@BN8PR10MB3251.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bXF062o7PtNFozQk36wHKrezizlD5tYE4vCtX3gjMj6e3PvTqwl7H+MxCCFtU8Z5+3kwTxsNPjqfpp3Kdq82LRVv1o685QtHSJ7Sd+RYtodnTpH26wMDmnt8ESXklnsENtGI3UNxjV9l7A+NMPcbysnn3fu7XdCH4CjtMCVBGQuOU4P9aRBtBkkrQzMShyNw03AtWIzEZoEmdTS7Zs3qoWAqBRV5PGeBO4xoC+W2oIvZvww1i9mA1oxjz3QYXzrmhijqvobnPeBa27KEDkD2wKCALURjNXPJGltvw1wDIBxUFwcTMbC8I80r3DM2LiUKNMSBzFWGZxyq/cOrUfkl+t9Bdf1WQr/dLLqM+IhscJ8AaLFV+NFOYz9bpfqwdgXlT6ovhxJSWJCyrdExnzqpHFhEEeYHhXk+452IK6E3y5scnfkbPCum5cOyAN+AsSdlyVy2hFb70biN8S7KK9GEhm85XTkiQx94+ogiYLI0T9/S8+nUjg+GJM7W9+k2eVJjU4zu58beeMlbjyOojNq0Bd5hgnCvb8ukkSTuKG8WrZCJOzFJYTqmVGoAfleUEdygLjwmMNR8pTU50S5yjiD9+x3NmFNiRpUUV/BvJAxo+3aIa8PyMc3mCZN1X6lLSa6nx572G821tuBJQgrrYWSRlLeuU9fIca89IgzliJ4w+4SxrisskDBjFrYIRv3vZCVpKxIt79efIRP6iUyJu+N2VEK7iRi9inKDWCm98F6Wf4rpoDIsjfBUa7B1rZfwIuig
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66476007)(66556008)(66946007)(8676002)(316002)(38100700002)(38350700002)(36756003)(4326008)(86362001)(6486002)(5660300002)(8936002)(2616005)(6506007)(7416002)(52116002)(44832011)(186003)(26005)(6512007)(6666004)(83380400001)(107886003)(508600001)(2906002)(101420200003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?e3xJZaX7QZBHhjh30CeqHRdERn3Fges/aXn5VOZ5eNJGOvwh+XKyhbsAHElb?=
 =?us-ascii?Q?15WojrMjzvUEA1Hmc66IGBZO694qWEyHtZ4F5sSmUP8CrWxVHevnj25yutQu?=
 =?us-ascii?Q?+/3GFxAP4u8Shmnv7QSs4fLjLciSPfTAilqgI10LYuTY5Q100Xh9AiD0CbQW?=
 =?us-ascii?Q?8ijGQBCsSvcPg90eNaShKb10mmV6NV5QEAWN/2WqOKPhXz9KAhtYlAn99jvI?=
 =?us-ascii?Q?Sve0q7s+3LAeLEotwrgqo2JfT1MIiEfD++Buxkv6i2Fe4Lpv/FYa6cV5Av/P?=
 =?us-ascii?Q?UUbkTHAMvjQ8Y/QyJU4xn1nE7HglI3eDzXPOYzFB9YtQWgVKSVjkuDhYI6T7?=
 =?us-ascii?Q?1/oZCC+qgAVcOsVdFYGelyY/RP8IsuloGucwZMaYP1xNEyEUCETeBLwYZ6HT?=
 =?us-ascii?Q?iqVYqoFKpJtMo/JKYJV9/obyHaMHkyXslkTthtf5i5liRpI4a+NWxV6I/zoQ?=
 =?us-ascii?Q?jCnTyHA5uBDfLsEnSYtBET/Tl1n8kRzg9MVN/8isgUjn8S2leyBq1+trwMi1?=
 =?us-ascii?Q?N4kLQhQ4JSN5qdyYf9tTb2R0ExbXHmY/sBcAs3Xo4amPG1N2ltwwIZMW5p3g?=
 =?us-ascii?Q?PIGZ4qy2QhpD+wTKUyDYB2p8XJAAl6efjTMYjIxGVjNWRyWmeGvV67nTs5MS?=
 =?us-ascii?Q?AqmuQh+zdN3/QYl2dlX6mkksR/Eo53y0Fxbu+K+2bXBRaLTb/VKTJQF5zqaN?=
 =?us-ascii?Q?nhi/WLeBlJ+D5Slo9XUCVxG0fr3QZa6M6hiZv/0GuRZAN9fSfw5GafmuBgHw?=
 =?us-ascii?Q?1Si1kkDzWIUv/WxYTuFd7229wLU7rNVUzBaDZdWVEuFuVGRP7/iQB/vjKIJ7?=
 =?us-ascii?Q?Ip+47xFRH+MfbxaPFdJRNFrCa0EKmkPZg+Bs7Nctj0QBLdOXZa80ofFGWq6Y?=
 =?us-ascii?Q?lzUIYtzj/T5yXHU2b1oULtzQOQ6pxUpwypHPCgZFIZi8anKghJdCe5Z1QQq0?=
 =?us-ascii?Q?xpZWMouTjOhJ7PVltfh2po+SGZ0dolJNC0PdRO7rd50ayIngyS7z/sMs4ddX?=
 =?us-ascii?Q?FJkD5vu9UHYV4TTVrZHzbCtflcstLl2w1t6MLKji0gWJvckUXh8RF01RtFxp?=
 =?us-ascii?Q?BHll+Ul4GXr84xN3fzEDfCYdUT8jjgU+FQLeCHtbE4UKcXwhA405UH+BJEtb?=
 =?us-ascii?Q?t8MF7of7syMTp7EARtUcdIMre2SKe4u82F19d4eXz+kIfJQfOoVbxrrxrQZN?=
 =?us-ascii?Q?rUqUboT6K4yggJ3+1SPcP7Zqqz4QxLMBZkNRfIofPJuqC1eeSPwkGYncBHwq?=
 =?us-ascii?Q?AH2b0f3+YQ60UwfSYg0Ob1YmLFPw4MFaB5HOUMGmHbDx3dn1XytMVUKMBLXx?=
 =?us-ascii?Q?KuUykA7X8YgO1OP1l8MCvEwKU2k2sKnEEf797PmV0RhT+ZtVTwstvuPXYTwm?=
 =?us-ascii?Q?Balya8ivDI4bZy35GgGNRcoY3gqrj6Z3njpJrMkOeNz3/50TaDkSfDQp0x8p?=
 =?us-ascii?Q?EA+og4ZEd8GkvVIP5vrFUv3q/Ph3HpPiO5Yr9fwdICleNXtqmUE5pE5vhpo5?=
 =?us-ascii?Q?HSKFz2pXDARKVkkQ5IErm3cDRHCTXZMHoHitP7E1tU+uLVYVfM/pMBDpApot?=
 =?us-ascii?Q?N/D3oLwtHefE7kIgHQfq+xwSMzstRSmnnk49SYxXZO4pDV+MVs503lacsd15?=
 =?us-ascii?Q?wfsU44EnCkLRfkw8HTs4HBXnLBe39w/DwV39nsO8LBXwy7NJFRw4sMDAw60p?=
 =?us-ascii?Q?iBA7DQXDQcR3MvgLOuXHjBTIYZwCzk5WgU6FoW6eV2NKLbVf3OaYXXnU+qSM?=
 =?us-ascii?Q?sc5ookA/ijkZd5TiQ9lPt0/9ISWr8PY=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19ddf010-c330-44c1-3f24-08da1261b4e0
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2022 15:26:48.3787
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AEOzluD2Dnv4rmQoLIq7AK/m+Q0bXWhUP/g9/AttxqzfHXlsZbGLyITx4D9u76o4bJgpTv/tZ9xYPRCJA84CMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3251
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10302 signatures=695566
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 phishscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203300074
X-Proofpoint-GUID: V-OYj9lTrcaFNBSLd_1RHKGoSbA2XvSt
X-Proofpoint-ORIG-GUID: V-OYj9lTrcaFNBSLd_1RHKGoSbA2XvSt
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf_program__attach_uprobe_opts() requires a binary_path argument
specifying binary to instrument.  Supporting simply specifying
"libc.so.6" or "foo" should be possible too.

Library search checks LD_LIBRARY_PATH, then /usr/lib64, /usr/lib.
This allows users to run BPF programs prefixed with
LD_LIBRARY_PATH=/path2/lib while still searching standard locations.
Similarly for non .so files, we check PATH and /usr/bin, /usr/sbin.

Path determination will be useful for auto-attach of BPF uprobe programs
using SEC() definition.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/lib/bpf/libbpf.c | 53 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 52 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 809fe20..a7d5954 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -10517,6 +10517,46 @@ static int perf_event_uprobe_open_legacy(const char *probe_name, bool retprobe,
 	return pfd;
 }
 
+/* Get full path to program/shared library. */
+static int resolve_full_path(const char *file, char *result, size_t result_sz)
+{
+	const char *search_paths[2];
+	int i;
+
+	if (strstr(file, ".so")) {
+		search_paths[0] = getenv("LD_LIBRARY_PATH");
+		search_paths[1] = "/usr/lib64:/usr/lib";
+	} else {
+		search_paths[0] = getenv("PATH");
+		search_paths[1] = "/usr/bin:/usr/sbin";
+	}
+
+	for (i = 0; i < ARRAY_SIZE(search_paths); i++) {
+		const char *s;
+
+		if (!search_paths[i])
+			continue;
+		for (s = search_paths[i]; s != NULL; s = strchr(s, ':')) {
+			char *next_path;
+			int seg_len;
+
+			if (s[0] == ':')
+				s++;
+			next_path = strchr(s, ':');
+			seg_len = next_path ? next_path - s : strlen(s);
+			if (!seg_len)
+				continue;
+			snprintf(result, result_sz, "%.*s/%s", seg_len, s, file);
+			/* ensure it is an executable file/link */
+			if (access(result, R_OK | X_OK) < 0)
+				continue;
+			pr_debug("resolved '%s' to '%s'\n", file, result);
+			return 0;
+		}
+	}
+	return -ENOENT;
+}
+
 LIBBPF_API struct bpf_link *
 bpf_program__attach_uprobe_opts(const struct bpf_program *prog, pid_t pid,
 				const char *binary_path, size_t func_offset,
@@ -10524,6 +10564,7 @@ static int perf_event_uprobe_open_legacy(const char *probe_name, bool retprobe,
 {
 	DECLARE_LIBBPF_OPTS(bpf_perf_event_opts, pe_opts);
 	char errmsg[STRERR_BUFSIZE], *legacy_probe = NULL;
+	char full_binary_path[PATH_MAX];
 	struct bpf_link *link;
 	size_t ref_ctr_off;
 	int pfd, err;
@@ -10536,12 +10577,22 @@ static int perf_event_uprobe_open_legacy(const char *probe_name, bool retprobe,
 	ref_ctr_off = OPTS_GET(opts, ref_ctr_offset, 0);
 	pe_opts.bpf_cookie = OPTS_GET(opts, bpf_cookie, 0);
 
+	if (binary_path && !strchr(binary_path, '/')) {
+		err = resolve_full_path(binary_path, full_binary_path,
+					sizeof(full_binary_path));
+		if (err) {
+			pr_warn("failed to resolve full path for '%s'\n", binary_path);
+			return libbpf_err_ptr(err);
+		}
+		binary_path = full_binary_path;
+	}
+
 	legacy = determine_uprobe_perf_type() < 0;
 	if (!legacy) {
 		pfd = perf_event_open_probe(true /* uprobe */, retprobe, binary_path,
 					    func_offset, pid, ref_ctr_off);
 	} else {
-		char probe_name[512];
+		char probe_name[PATH_MAX + 64];
 
 		if (ref_ctr_off)
 			return libbpf_err_ptr(-EINVAL);
-- 
1.8.3.1

