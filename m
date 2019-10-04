Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0403CC5FD
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 00:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730588AbfJDWku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 18:40:50 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:33608 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728812AbfJDWkt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 18:40:49 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x94MekWo028674
        for <netdev@vger.kernel.org>; Fri, 4 Oct 2019 15:40:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=KGVWkcWq1stvP2V94g9ZRWXzKE6IfqLWJs6T74ojn1Y=;
 b=QiuYu7trF7sR+FrJ+hf2CY7Lf0EmWJrxzGdrcfBDxLBTV6HuDt3hHj8WcbPIA6fdXYIr
 Yf3taRzwFjDVN8WrKIpT+O7hLKwRdVQ6x3fhMPTso60bCU4L9XvqT/8PPoHb0fm9MxQw
 zzxmDxW9RP+pMOzcPnVpzyjdFc5GwfH/ug4= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vdmh9ewnb-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 15:40:49 -0700
Received: from 2401:db00:12:909f:face:0:3:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Fri, 4 Oct 2019 15:40:46 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 7CC0C8617D0; Fri,  4 Oct 2019 15:40:45 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v3 bpf-next 3/4] libbpf: fix bpf_object__name() to actually return object name
Date:   Fri, 4 Oct 2019 15:40:36 -0700
Message-ID: <20191004224037.1625049-4-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191004224037.1625049-1-andriin@fb.com>
References: <20191004224037.1625049-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-04_13:2019-10-03,2019-10-04 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=8
 adultscore=0 impostorscore=0 clxscore=1015 priorityscore=1501
 mlxlogscore=999 bulkscore=0 phishscore=0 mlxscore=0 malwarescore=0
 spamscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1910040191
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf_object__name() was returning file path, not name. Fix this.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index d471d33400ae..a02cdedc4e3f 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4231,7 +4231,7 @@ bpf_object__next(struct bpf_object *prev)
 
 const char *bpf_object__name(const struct bpf_object *obj)
 {
-	return obj ? obj->path : ERR_PTR(-EINVAL);
+	return obj ? obj->name : ERR_PTR(-EINVAL);
 }
 
 unsigned int bpf_object__kversion(const struct bpf_object *obj)
-- 
2.17.1

