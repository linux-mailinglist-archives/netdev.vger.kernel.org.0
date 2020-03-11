Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1AE18249F
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 23:19:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730049AbgCKWTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 18:19:02 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36006 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729848AbgCKWTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 18:19:01 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02BMIhJv026561
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 15:19:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=TwcVDV4erLZpPn3mpdBqCSvF9UDAzmftpaFg0/dzy6E=;
 b=Jjr/ESn9qVwyAZXMYB0/6QsG/5sfKSUFFNDKFs+rd3PxrBho5bxXsrBXxwLeuoe3HppB
 qGGmfCUEL9+/3G8uHqHaApnStdHh6Ud0xDwBckLHtXMK42uOtJbwsu8fepofH7GuEw2h
 C2NhMxruQvpWzkiBKTgtDofUUgvl3Q64vwQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2ypfsqewwv-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 15:19:00 -0700
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 11 Mar 2020 15:18:57 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id AC51F62E2936; Wed, 11 Mar 2020 15:18:50 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <john.fastabend@gmail.com>, <quentin@isovalent.com>,
        <kernel-team@fb.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <arnaldo.melo@gmail.com>, <jolsa@kernel.org>,
        Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 2/3] bpftool: skeleton should depend on libbpf
Date:   Wed, 11 Mar 2020 15:18:43 -0700
Message-ID: <20200311221844.3089820-3-songliubraving@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200311221844.3089820-1-songliubraving@fb.com>
References: <20200311221844.3089820-1-songliubraving@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-11_11:2020-03-11,2020-03-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 mlxscore=0 malwarescore=0 priorityscore=1501 mlxlogscore=999 spamscore=0
 bulkscore=0 adultscore=0 clxscore=1015 suspectscore=0 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003110125
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the dependency to libbpf, to fix build errors like:

  In file included from skeleton/profiler.bpf.c:5:
  .../bpf_helpers.h:5:10: fatal error: 'bpf_helper_defs.h' file not found
  #include "bpf_helper_defs.h"
           ^~~~~~~~~~~~~~~~~~~
  1 error generated.
  make: *** [skeleton/profiler.bpf.o] Error 1
  make: *** Waiting for unfinished jobs....

Fixes: 47c09d6a9f67 ("bpftool: Introduce "prog profile" command")
Acked-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
---
 tools/bpf/bpftool/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
index 0d9ede8e7340..45a37e2fb6e6 100644
--- a/tools/bpf/bpftool/Makefile
+++ b/tools/bpf/bpftool/Makefile
@@ -126,7 +126,7 @@ $(OUTPUT)_prog.o: prog.c
 $(OUTPUT)_bpftool: $(_OBJS) $(LIBBPF)
 	$(QUIET_LINK)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(_OBJS) $(LIBS)
 
-skeleton/profiler.bpf.o: skeleton/profiler.bpf.c
+skeleton/profiler.bpf.o: skeleton/profiler.bpf.c $(LIBBPF)
 	$(QUIET_CLANG)$(CLANG) -I$(srctree)/tools/lib -g -O2 -target bpf -c $< -o $@
 
 profiler.skel.h: $(OUTPUT)_bpftool skeleton/profiler.bpf.o
-- 
2.17.1

