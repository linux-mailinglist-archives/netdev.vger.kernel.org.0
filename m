Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9714F211521
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 23:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727894AbgGAV21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 17:28:27 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:30766 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727884AbgGAV20 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 17:28:26 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 061LGGpT009952
        for <netdev@vger.kernel.org>; Wed, 1 Jul 2020 14:28:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=facebook;
 bh=ImuQ/pcsPbh8Tb6FKSwCSOd7ITPakKzlYlr5H24zEBQ=;
 b=pneKoYu+uly1oNkHUIqknKlch5QtSEBLwY4ZxIDYIio73LOxyRI3yI89UWJaAJjBbijB
 9AB/InKTKRa0zWfIRZooMUXm+nkMS8e9VX869J9f7wv81N5V91fpDG6jq2ieWzA1oUnL
 rCxFhvZRHpbgagu9BRA5Yw0Vda5uJLaphcs= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31xntc1pv0-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 01 Jul 2020 14:28:25 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 1 Jul 2020 14:28:24 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 0F7D52EC3A77; Wed,  1 Jul 2020 14:28:21 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] tools/bpftool: turn off -Wnested-externs warning
Date:   Wed, 1 Jul 2020 14:28:16 -0700
Message-ID: <20200701212816.2072340-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-01_12:2020-07-01,2020-07-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 cotscore=-2147483648 lowpriorityscore=0 mlxscore=0 clxscore=1015
 bulkscore=0 spamscore=0 suspectscore=8 impostorscore=0 priorityscore=1501
 adultscore=0 mlxlogscore=972 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007010148
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Turn off -Wnested-externs to avoid annoying warnings in BUILD_BUG_ON macr=
o when
compiling bpftool:

In file included from /data/users/andriin/linux/tools/include/linux/build=
_bug.h:5,
                 from /data/users/andriin/linux/tools/include/linux/kerne=
l.h:8,
                 from /data/users/andriin/linux/kernel/bpf/disasm.h:10,
                 from /data/users/andriin/linux/kernel/bpf/disasm.c:8:
/data/users/andriin/linux/kernel/bpf/disasm.c: In function =E2=80=98__fun=
c_get_name=E2=80=99:
/data/users/andriin/linux/tools/include/linux/compiler.h:37:38: warning: =
nested extern declaration of =E2=80=98__compiletime_assert_0=E2=80=99 [-W=
nested-externs]
  _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
                                      ^~~~~~~~~~~~~~~~~~~~~
/data/users/andriin/linux/tools/include/linux/compiler.h:16:15: note: in =
definition of macro =E2=80=98__compiletime_assert=E2=80=99
   extern void prefix ## suffix(void) __compiletime_error(msg); \
               ^~~~~~
/data/users/andriin/linux/tools/include/linux/compiler.h:37:2: note: in e=
xpansion of macro =E2=80=98_compiletime_assert=E2=80=99
  _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
  ^~~~~~~~~~~~~~~~~~~
/data/users/andriin/linux/tools/include/linux/build_bug.h:39:37: note: in=
 expansion of macro =E2=80=98compiletime_assert=E2=80=99
 #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
                                     ^~~~~~~~~~~~~~~~~~
/data/users/andriin/linux/tools/include/linux/build_bug.h:50:2: note: in =
expansion of macro =E2=80=98BUILD_BUG_ON_MSG=E2=80=99
  BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
  ^~~~~~~~~~~~~~~~
/data/users/andriin/linux/kernel/bpf/disasm.c:20:2: note: in expansion of=
 macro =E2=80=98BUILD_BUG_ON=E2=80=99
  BUILD_BUG_ON(ARRAY_SIZE(func_id_str) !=3D __BPF_FUNC_MAX_ID);
  ^~~~~~~~~~~~

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/bpf/bpftool/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
index 273da1615503..51bd520ed437 100644
--- a/tools/bpf/bpftool/Makefile
+++ b/tools/bpf/bpftool/Makefile
@@ -40,7 +40,7 @@ bash_compdir ?=3D /usr/share/bash-completion/completion=
s
=20
 CFLAGS +=3D -O2
 CFLAGS +=3D -W -Wall -Wextra -Wno-unused-parameter -Wno-missing-field-in=
itializers
-CFLAGS +=3D $(filter-out -Wswitch-enum,$(EXTRA_WARNINGS))
+CFLAGS +=3D $(filter-out -Wswitch-enum -Wnested-externs,$(EXTRA_WARNINGS=
))
 CFLAGS +=3D -DPACKAGE=3D'"bpftool"' -D__EXPORTED_HEADERS__ \
 	-I$(if $(OUTPUT),$(OUTPUT),.) \
 	-I$(srctree)/kernel/bpf/ \
--=20
2.24.1

