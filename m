Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53D2413B568
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 23:44:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728892AbgANWo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 17:44:27 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36888 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727102AbgANWo1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 17:44:27 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00EMhkUW026819
        for <netdev@vger.kernel.org>; Tue, 14 Jan 2020 14:44:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=GEVp/+/62LS/bb1ZozULgnaOZTQXXrPuUWpbugBkFGk=;
 b=caQzMZ1rtgr8l0gHkXusdubqUyw+6+q/1BSSUywU+1JKVn3fAnSbi9bAmwLZb2S8Q18U
 Ap+MXZRpLoMxKkMGSWogJ4kD9C2fmkVeXRtWTysxUZ7N2edVarXZn5lbwjeg/QwXoyCT
 +GVP4xQoHl2OBdLjlp74Lq9++06+A08PdQg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2xhp0fg6jt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 14 Jan 2020 14:44:26 -0800
Received: from intmgw004.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 14 Jan 2020 14:44:25 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 9122F29438DC; Tue, 14 Jan 2020 14:44:19 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 4/5] bpftool: Add struct_ops map name
Date:   Tue, 14 Jan 2020 14:44:19 -0800
Message-ID: <20200114224419.3028615-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200114224358.3027079-1-kafai@fb.com>
References: <20200114224358.3027079-1-kafai@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-14_06:2020-01-14,2020-01-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 impostorscore=0 bulkscore=0 phishscore=0 adultscore=0 spamscore=0
 clxscore=1015 mlxscore=0 priorityscore=1501 suspectscore=13
 mlxlogscore=756 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-2001140175
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds BPF_MAP_TYPE_STRUCT_OPS to "struct_ops" name mapping
so that "bpftool map show" can print the "struct_ops" map type
properly.

[root@arch-fb-vm1 bpf]# ~/devshare/fb-kernel/linux/tools/bpf/bpftool/bpftool map show id 8
8: struct_ops  name dctcp  flags 0x0
	key 4B  value 256B  max_entries 1  memlock 4096B
	btf_id 7

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 tools/bpf/bpftool/map.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
index 45c1eda6512c..4c5b15d736b6 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -48,6 +48,7 @@ const char * const map_type_name[] = {
 	[BPF_MAP_TYPE_QUEUE]			= "queue",
 	[BPF_MAP_TYPE_STACK]			= "stack",
 	[BPF_MAP_TYPE_SK_STORAGE]		= "sk_storage",
+	[BPF_MAP_TYPE_STRUCT_OPS]		= "struct_ops",
 };
 
 const size_t map_type_name_size = ARRAY_SIZE(map_type_name);
-- 
2.17.1

