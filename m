Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC1A4A0C02
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 23:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727002AbfH1VEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 17:04:12 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:1328 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726883AbfH1VEL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 17:04:11 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7SL47O9028837
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 14:04:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=iPq7cHxWDw+ax28E2LpaitvRSxJaxf2/KfQM8ivfW8E=;
 b=gF5RmwXp0Ez/AChRy1q6sLElJwG/h2G0LVFPEyRSnL7UpSRGMoU69YNPrQqh/gRCU6S+
 jOsdl18697ElyCerdkVMCOOu8OKBySw0UaGHPpMETLxhjHzqynEHqBe3VXI5dz6dd6L2
 z+rTg96uxyQvKJHyrTK0ZJ4DanDTgv6sSkk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2unvfyhhn7-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 14:04:10 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 28 Aug 2019 14:03:56 -0700
Received: by devvm2868.prn3.facebook.com (Postfix, from userid 125878)
        id C7EB8A25D5D7; Wed, 28 Aug 2019 14:03:55 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Julia Kartseva <hex@fb.com>
Smtp-Origin-Hostname: devvm2868.prn3.facebook.com
To:     <rdna@fb.com>, <bpf@vger.kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     Julia Kartseva <hex@fb.com>
Smtp-Origin-Cluster: prn3c11
Subject: [PATCH bpf-next 01/10] bpf: introduce __MAX_BPF_PROG_TYPE and __MAX_BPF_MAP_TYPE enum values
Date:   Wed, 28 Aug 2019 14:03:04 -0700
Message-ID: <43989d37be938b7d284028481e63df0a0471e29f.1567024943.git.hex@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1567024943.git.hex@fb.com>
References: <cover.1567024943.git.hex@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-08-28_11:2019-08-28,2019-08-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 priorityscore=1501 mlxscore=0 mlxlogscore=999 clxscore=1015 malwarescore=0
 spamscore=0 lowpriorityscore=0 bulkscore=0 phishscore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1908280206
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to __MAX_BPF_ATTACH_TYPE identifying the number of elements in
bpf_attach_type enum, add tailing enum values __MAX_BPF_PROG_TYPE
and __MAX_BPF_MAP_TYPE to simplify e.g. iteration over enums values in
the case when new values are added.

Signed-off-by: Julia Kartseva <hex@fb.com>
---
 include/uapi/linux/bpf.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 5d2fb183ee2d..9b681bb82211 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -136,8 +136,11 @@ enum bpf_map_type {
 	BPF_MAP_TYPE_STACK,
 	BPF_MAP_TYPE_SK_STORAGE,
 	BPF_MAP_TYPE_DEVMAP_HASH,
+	__MAX_BPF_MAP_TYPE
 };
 
+#define MAX_BPF_MAP_TYPE __MAX_BPF_MAP_TYPE
+
 /* Note that tracing related programs such as
  * BPF_PROG_TYPE_{KPROBE,TRACEPOINT,PERF_EVENT,RAW_TRACEPOINT}
  * are not subject to a stable API since kernel internal data
@@ -173,8 +176,11 @@ enum bpf_prog_type {
 	BPF_PROG_TYPE_CGROUP_SYSCTL,
 	BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE,
 	BPF_PROG_TYPE_CGROUP_SOCKOPT,
+	__MAX_BPF_PROG_TYPE
 };
 
+#define MAX_BPF_PROG_TYPE __MAX_BPF_PROG_TYPE
+
 enum bpf_attach_type {
 	BPF_CGROUP_INET_INGRESS,
 	BPF_CGROUP_INET_EGRESS,
-- 
2.17.1

