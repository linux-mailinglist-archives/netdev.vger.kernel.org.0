Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6507272CD
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 01:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbfEVXQm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 19:16:42 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:34640 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727802AbfEVXQm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 19:16:42 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4MNFTf3011887
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 16:16:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=r6b6ThXtDa4qD/qDANK2Zkqj85CrvwEFjOLFRPvkCFE=;
 b=BzJ4f5tijcc9QQ7QA5LDqlDGuNT6AyuVp4JRHrHnPRLfEgDHmIMjlWNM2Z660DP9xinB
 OT7Htk1cVstLQGpQeopSoYuQqD20RwbbxJX8o0YNzAxs/74IBRyy4sG76fK46HzvphvE
 Kcxvez5eBsegDgyRJuqGp4m0sU34y74yejg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2sn81p1y6h-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 16:16:41 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 22 May 2019 16:16:40 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 081BC3702482; Wed, 22 May 2019 16:16:37 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Yonghong Song <yhs@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v3 2/3] tools/bpf: sync bpf uapi header bpf.h to tools directory
Date:   Wed, 22 May 2019 16:16:37 -0700
Message-ID: <20190522231637.505889-1-yhs@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190522231636.505712-1-yhs@fb.com>
References: <20190522231636.505712-1-yhs@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-22_14:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=955 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905220162
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bpf uapi header include/uapi/linux/bpf.h is sync'ed
to tools/include/uapi/linux/bpf.h.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 tools/include/uapi/linux/bpf.h | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 63e0cf66f01a..68d4470523a0 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -2672,6 +2672,20 @@ union bpf_attr {
  *		0 on success.
  *
  *		**-ENOENT** if the bpf-local-storage cannot be found.
+ *
+ * int bpf_send_signal(u32 sig)
+ *	Description
+ *		Send signal *sig* to the current task.
+ *	Return
+ *		0 on success or successfully queued.
+ *
+ *		**-EBUSY** if work queue under nmi is full.
+ *
+ *		**-EINVAL** if *sig* is invalid.
+ *
+ *		**-EPERM** if no permission to send the *sig*.
+ *
+ *		**-EAGAIN** if bpf program can try again.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -2782,7 +2796,8 @@ union bpf_attr {
 	FN(strtol),			\
 	FN(strtoul),			\
 	FN(sk_storage_get),		\
-	FN(sk_storage_delete),
+	FN(sk_storage_delete),		\
+	FN(send_signal),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
-- 
2.17.1

