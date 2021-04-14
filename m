Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A17E35FC23
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 22:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353611AbhDNUCc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 14 Apr 2021 16:02:32 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:27304 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1353616AbhDNUC1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 16:02:27 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13EJwqJ1003334
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 13:02:05 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 37wv653kx1-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 13:02:05 -0700
Received: from intmgw006.03.ash8.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 14 Apr 2021 13:02:03 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id D70232ECEBDF; Wed, 14 Apr 2021 13:01:56 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH bpf-next 01/17] bpftool: support dumping BTF VAR's "extern" linkage
Date:   Wed, 14 Apr 2021 13:01:30 -0700
Message-ID: <20210414200146.2663044-2-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210414200146.2663044-1-andrii@kernel.org>
References: <20210414200146.2663044-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: EnIUdILUU6W3Krb8WuuSsJbswva0UlBC
X-Proofpoint-GUID: EnIUdILUU6W3Krb8WuuSsJbswva0UlBC
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-14_12:2021-04-14,2021-04-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=939 malwarescore=0 adultscore=0 bulkscore=0
 mlxscore=0 clxscore=1015 priorityscore=1501 spamscore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104140127
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add dumping of "extern" linkage for BTF VAR kind. Also shorten
"global-allocated" to "global" to be in line with FUNC's "global".

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/bpf/bpftool/btf.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
index 62953bbf68b4..001749a34899 100644
--- a/tools/bpf/bpftool/btf.c
+++ b/tools/bpf/bpftool/btf.c
@@ -71,7 +71,9 @@ static const char *btf_var_linkage_str(__u32 linkage)
 	case BTF_VAR_STATIC:
 		return "static";
 	case BTF_VAR_GLOBAL_ALLOCATED:
-		return "global-alloc";
+		return "global";
+	case BTF_VAR_GLOBAL_EXTERN:
+		return "extern";
 	default:
 		return "(unknown)";
 	}
-- 
2.30.2

