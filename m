Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02BB4105A7
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 08:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbfEAG42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 02:56:28 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:43912 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726005AbfEAG40 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 02:56:26 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x416mW8c023292
        for <netdev@vger.kernel.org>; Tue, 30 Apr 2019 23:56:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=USqjk3EJGRFLoec6O+/rFlqnlw84fmAE9AWomwTX9J0=;
 b=L7Idok9w7QrEKwo12wiW0vvwMGi3wfF7wXc0sHNdDJ8xpCaiitILSBs9uka6mspLvGfP
 xPuVHdQ77HufK2Gh+g6+mBlM+lbSyOvo/q/l0CE/YZnjFpUTxmNfItCmyWbBlBn09Udb
 kBiXXZbbiDu/UrWXumJJ5kUk4hgsIj9pxbk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2s6xhnh71v-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 30 Apr 2019 23:56:25 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 30 Apr 2019 23:56:24 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 51F9C3702FB8; Tue, 30 Apr 2019 23:56:23 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Yonghong Song <yhs@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC PATCH bpf-next 2/3] tools/bpf: sync bpf uapi header bpf.h
Date:   Tue, 30 Apr 2019 23:56:23 -0700
Message-ID: <20190501065623.2599923-1-yhs@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190501065621.2599742-1-yhs@fb.com>
References: <20190501065621.2599742-1-yhs@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-01_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=856 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905010048
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sync bpf uapi header bpf.h to tools directory.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 tools/include/uapi/linux/bpf.h | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 72336bac7573..e3e824848335 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -2667,6 +2667,18 @@ union bpf_attr {
  *		0 on success.
  *
  *		**-ENOENT** if the bpf-local-storage cannot be found.
+ *
+ * int bpf_send_signal(u32 pid, u32 sig)
+ *	Description
+ *		Send signal *sig* to *pid*.
+ *	Return
+ *		0 on success or successfully queued.
+ *
+ *		**-ENOENT** if *pid* cannot be found.
+ *
+ *		**-EBUSY** if work queue under nmi is full.
+ *
+ * 		Other negative values for actual signal sending errors.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -2777,7 +2789,8 @@ union bpf_attr {
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

