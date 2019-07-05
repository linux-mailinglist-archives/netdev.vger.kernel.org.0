Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9A31609B8
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 17:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728144AbfGEPu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 11:50:26 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:13424 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727217AbfGEPuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 11:50:25 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x65FoE3x019402
        for <netdev@vger.kernel.org>; Fri, 5 Jul 2019 08:50:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=1GFiSMUPFuZ0tYlVWtp0E/7NlOVoKMrYZYBEYOG90H8=;
 b=UR8X3Nwtp6yySkiw9ueOzQ1hl+enQltWwol0o0/5toB1XynMoUePEfqKZUDKjoOfM+cB
 zHzHMQhXw+C0TTdojMxUzfP9e+ddK14VhmAOpmOR1zbgF85/VJPLeahR7Dl/swXarFB4
 W1vmlcAoYmfHCg0zC1FJg6N06ILNf92hgdw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2tj4ku13sw-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 05 Jul 2019 08:50:24 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 5 Jul 2019 08:50:21 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 4A28A861628; Fri,  5 Jul 2019 08:50:20 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>, <ast@fb.com>,
        <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v5 bpf-next 2/4] selftests/bpf: add __uint and __type macro for BTF-defined maps
Date:   Fri, 5 Jul 2019 08:50:10 -0700
Message-ID: <20190705155012.3539722-3-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190705155012.3539722-1-andriin@fb.com>
References: <20190705155012.3539722-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-05_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907050194
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add simple __uint and __type macro that hide details of how type and
integer values are captured in BTF-defined maps.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Acked-by: Song Liu <songliubraving@fb.com>
Acked-by: Yonghong Song <yhs@fb.com>
---
 tools/testing/selftests/bpf/bpf_helpers.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
index 1a5b1accf091..5a3d92c8bec8 100644
--- a/tools/testing/selftests/bpf/bpf_helpers.h
+++ b/tools/testing/selftests/bpf/bpf_helpers.h
@@ -8,6 +8,9 @@
  */
 #define SEC(NAME) __attribute__((section(NAME), used))
 
+#define __uint(name, val) int (*name)[val]
+#define __type(name, val) val *name
+
 /* helper macro to print out debug messages */
 #define bpf_printk(fmt, ...)				\
 ({							\
-- 
2.17.1

