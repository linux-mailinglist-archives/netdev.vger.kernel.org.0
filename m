Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAE3125855C
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 03:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726625AbgIABua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 21:50:30 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:8228 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726521AbgIABu1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 21:50:27 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0811oPkj015066
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 18:50:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=xZfr7J7vumhx1Zgou/Z0il+VrwbvbOFRutiV/wfxi9k=;
 b=nhyUL3/rnsu+hCujoNYh7nOtb/NgGgCuhYuBv5BcqhcoiH7CmX0WbOkFa3/36RwmTGrN
 vll2mwRQZlz7auKMx0Bres6Dd/yslRILHlGTCVBmHm/KacHzBc/xLGnpGOd9whYvIoRP
 VWb2huOMg+5RoNL80lAWkyEtvIVLbIMVpf0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 337jh03bds-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 18:50:26 -0700
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 31 Aug 2020 18:50:24 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 8B9872EC663B; Mon, 31 Aug 2020 18:50:22 -0700 (PDT)
From:   Andrii Nakryiko <andriin@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH v2 bpf-next 08/14] tools/bpftool: replace bpf_program__title() with bpf_program__section_name()
Date:   Mon, 31 Aug 2020 18:49:57 -0700
Message-ID: <20200901015003.2871861-9-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200901015003.2871861-1-andriin@fb.com>
References: <20200901015003.2871861-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-01_01:2020-08-31,2020-09-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 malwarescore=0
 spamscore=0 lowpriorityscore=0 bulkscore=0 adultscore=0 priorityscore=1501
 phishscore=0 suspectscore=8 impostorscore=0 mlxlogscore=602 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009010014
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf_program__title() is deprecated, switch to bpf_program__section_name()=
 and
avoid compilation warnings.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/bpf/bpftool/prog.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index d393eb8263a6..f7923414a052 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -1304,7 +1304,7 @@ static int load_with_options(int argc, char **argv,=
 bool first_prog_only)
 		enum bpf_prog_type prog_type =3D common_prog_type;
=20
 		if (prog_type =3D=3D BPF_PROG_TYPE_UNSPEC) {
-			const char *sec_name =3D bpf_program__title(pos, false);
+			const char *sec_name =3D bpf_program__section_name(pos);
=20
 			err =3D get_prog_type_by_name(sec_name, &prog_type,
 						    &expected_attach_type);
@@ -1398,7 +1398,7 @@ static int load_with_options(int argc, char **argv,=
 bool first_prog_only)
 		err =3D bpf_obj_pin(bpf_program__fd(prog), pinfile);
 		if (err) {
 			p_err("failed to pin program %s",
-			      bpf_program__title(prog, false));
+			      bpf_program__section_name(prog));
 			goto err_close_obj;
 		}
 	} else {
--=20
2.24.1

