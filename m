Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3CE664BCE
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 20:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728178AbfGJSAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 14:00:32 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:33594 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727697AbfGJSAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 14:00:30 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6AHwHag014885
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 11:00:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=5FHhKB44YPugc3jIrj5xLrQSCWsm8IgFUhUwzhBR2+c=;
 b=nzZg9BxRed5i/hdo7azJJfGdNckvqXgpc1Ac1ksVdKw8i6kSQhQ/uy1gG4eiGBh9RSHL
 fnKsayCosDPNN8m/u7oL9uhsKm2XYiwSQVkYWrByZK7AdDtnzWb/RJcsbW9Nf/xwqQmJ
 Td4+TAsuT8YaadTUX8zqQxciBAd4Cezh9SQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2tnhfc1jdx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 11:00:29 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 10 Jul 2019 11:00:27 -0700
Received: by devvm424.lla2.facebook.com (Postfix, from userid 134475)
        id D333A11FAA302; Wed, 10 Jul 2019 11:00:25 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Javier Honduvilla Coto <javierhonduco@fb.com>
Smtp-Origin-Hostname: devvm424.lla2.facebook.com
To:     <netdev@vger.kernel.org>
CC:     <yhs@fb.com>, <kernel-team@fb.com>, <jonhaslam@fb.com>
Smtp-Origin-Cluster: lla2c09
Subject: [PATCH v6 bpf-next 2/3] bpf: sync kernel uapi headers
Date:   Wed, 10 Jul 2019 11:00:24 -0700
Message-ID: <20190710180025.94726-3-javierhonduco@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190710180025.94726-1-javierhonduco@fb.com>
References: <20190410203631.1576576-1-javierhonduco@fb.com>
 <20190710180025.94726-1-javierhonduco@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-10_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907100203
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sync kernel uapi headers.

Signed-off-by: Javier Honduvilla Coto <javierhonduco@fb.com>
---
 tools/include/uapi/linux/bpf.h | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 402208581b2d..505ee91898c2 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -2710,6 +2710,23 @@ union bpf_attr {
  *		**-EPERM** if no permission to send the *sig*.
  *
  *		**-EAGAIN** if bpf program can try again.
+ *
+ * int bpf_descendant_of(pid_t pid)
+ *     Description
+ *             Determine if the process identified by *pid* is an ancestor
+ *             (or equal) of the user process executed in this tracing
+ *             context. This is useful when filtering events happening
+ *             to a process and all of its descendants.
+ *
+ *             Note that *pid* must be the pid from the global namespace
+ *             as the pids of the process chain will be resolved using the
+ *             initial pid namespace viewer context.
+ *     Return
+ *             * 1 if the process identified by *pid* is an ancestor, or equal,
+ *             of the currently executing process within the global pid
+ *             namespace
+ *
+ *             * 0 otherwise.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -2821,7 +2838,8 @@ union bpf_attr {
 	FN(strtoul),			\
 	FN(sk_storage_get),		\
 	FN(sk_storage_delete),		\
-	FN(send_signal),
+	FN(send_signal),		\
+	FN(descendant_of),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
-- 
2.17.1

