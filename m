Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9A3A28D955
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 06:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730014AbgJNEgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 00:36:54 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:18210 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726037AbgJNEgy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 00:36:54 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09E4ZM1k011016
        for <netdev@vger.kernel.org>; Tue, 13 Oct 2020 21:36:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=facebook;
 bh=sl7Keq768JmYFP2QGaRO4xIW+BR0M1wIdYM0fJxUwXE=;
 b=aFeEuhWhXweCDqnRWk9q5mMw5Vmj7Wl/9zKjNPKtt9umKDdv39fEYy/lbgZn/c7lwg6B
 HgI8eZsGZ7MbNSz77b/+gTlrR64rbsTiSsuRO4Gpz69W9NxJPMLIbI/FPcGHHkXejHZj
 iakMx35SwnAUPpUWBjDsFHZK7a/e/Kc6WxI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 345ff5k721-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 13 Oct 2020 21:36:53 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 13 Oct 2020 21:36:52 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 662C862E1AE9; Tue, 13 Oct 2020 21:36:41 -0700 (PDT)
From:   Song Liu <songliubraving@fb.com>
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <kernel-team@fb.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH bpf-next] selftests/bpf: fix compilation error in progs/profiler.inc.h
Date:   Tue, 13 Oct 2020 21:36:38 -0700
Message-ID: <20201014043638.3770558-1-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
X-FB-Internal: Safe
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-14_02:2020-10-14,2020-10-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0
 impostorscore=0 priorityscore=1501 phishscore=0 adultscore=0
 mlxlogscore=999 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2010140031
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following error when compiling selftests/bpf

progs/profiler.inc.h:246:5: error: redefinition of 'pids_cgrp_id' as diff=
erent kind of symbol

pids_cgrp_id is used in cgroup code, and included in vmlinux.h. Fix the
error by renaming pids_cgrp_id as pids_cgroup_id.

Fixes: 03d4d13fab3f ("selftests/bpf: Add profiler test")
Signed-off-by: Song Liu <songliubraving@fb.com>
---
 tools/testing/selftests/bpf/progs/profiler.inc.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/profiler.inc.h b/tools/tes=
ting/selftests/bpf/progs/profiler.inc.h
index 00578311a4233..b554c1e40b9fb 100644
--- a/tools/testing/selftests/bpf/progs/profiler.inc.h
+++ b/tools/testing/selftests/bpf/progs/profiler.inc.h
@@ -243,7 +243,7 @@ static ino_t get_inode_from_kernfs(struct kernfs_node=
* node)
 	}
 }
=20
-int pids_cgrp_id =3D 1;
+int pids_cgroup_id =3D 1;
=20
 static INLINE void* populate_cgroup_info(struct cgroup_data_t* cgroup_da=
ta,
 					 struct task_struct* task,
@@ -262,7 +262,7 @@ static INLINE void* populate_cgroup_info(struct cgrou=
p_data_t* cgroup_data,
 				BPF_CORE_READ(task, cgroups, subsys[i]);
 			if (subsys !=3D NULL) {
 				int subsys_id =3D BPF_CORE_READ(subsys, ss, id);
-				if (subsys_id =3D=3D pids_cgrp_id) {
+				if (subsys_id =3D=3D pids_cgroup_id) {
 					proc_kernfs =3D BPF_CORE_READ(subsys, cgroup, kn);
 					root_kernfs =3D BPF_CORE_READ(subsys, ss, root, kf_root, kn);
 					break;
--=20
2.24.1

