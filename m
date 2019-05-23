Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E64028BAD
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 22:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388208AbfEWUmj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 16:42:39 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:48584 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388151AbfEWUmi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 16:42:38 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
        by mx0b-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4NKcXDr002881
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 13:42:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=i9KJsPXfMKWMU4yGosGCauJyd8EPlc91lPI8FQHp2j0=;
 b=Pk5ZJ74D/pVyKIKBopFYekWVxw1k1+FzSt9JW76HBrfCuNhl0GXYrfY1hX/9sZhbLwIo
 xDl+TuvAGVwWGry4TdpU2ssfEvnhQ4JKvykvYmJ0lWFvkcIrp4LVG/v3s9AVM4Tg1MWt
 kpJm9o5OdvEcigEyH6NmK3aJGyyGEBmBW5w= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0b-00082601.pphosted.com with ESMTP id 2snu991qy2-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 13:42:36 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Thu, 23 May 2019 13:42:28 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id A9BD5861799; Thu, 23 May 2019 13:42:27 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>,
        <kernel-team@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next 01/12] libbpf: ensure libbpf.h is included along libbpf_internal.h
Date:   Thu, 23 May 2019 13:42:11 -0700
Message-ID: <20190523204222.3998365-2-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190523204222.3998365-1-andriin@fb.com>
References: <20190523204222.3998365-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-23_16:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=772 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905230133
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

libbpf_internal.h expects a bunch of stuff defined in libbpf.h to be
defined. This patch makes sure that libbpf.h is always included.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf_internal.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
index f3025b4d90e1..850f7bdec5cb 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -9,6 +9,8 @@
 #ifndef __LIBBPF_LIBBPF_INTERNAL_H
 #define __LIBBPF_LIBBPF_INTERNAL_H
 
+#include "libbpf.h"
+
 #define BTF_INFO_ENC(kind, kind_flag, vlen) \
 	((!!(kind_flag) << 31) | ((kind) << 24) | ((vlen) & BTF_MAX_VLEN))
 #define BTF_TYPE_ENC(name, info, size_or_type) (name), (info), (size_or_type)
-- 
2.17.1

