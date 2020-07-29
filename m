Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FAE32327DB
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 01:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728037AbgG2XFn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 19:05:43 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:12922 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727115AbgG2XFm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 19:05:42 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06TN2FZf027440
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 16:05:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=u8kg52+HzkMY1tEw9AknzS+/BFunFBXL2tILZhwGvX0=;
 b=kKy30RqEGBphnnzbaovwwud8iFeq5GisuirplByv3+MyBueD47uEB6NgiVTUeP50mgPS
 lHL/ObqCGRJ/q4Ny9u8zg4ATJ72tE1MlC9Nz/+nsTCoC2RfseS3/aDTWEP3zjvfF4Qmn
 oziv9VB4kiJjtR62/DJj+eMQwkJEagVVA5E= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32jk9d8cub-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 16:05:41 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 29 Jul 2020 16:05:40 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id DD2982EC4E37; Wed, 29 Jul 2020 16:05:34 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 5/5] tools/bpftool: add documentation and bash-completion for `link detach`
Date:   Wed, 29 Jul 2020 16:05:20 -0700
Message-ID: <20200729230520.693207-6-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200729230520.693207-1-andriin@fb.com>
References: <20200729230520.693207-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-29_17:2020-07-29,2020-07-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 clxscore=1015 impostorscore=0 malwarescore=0 mlxscore=0 mlxlogscore=965
 suspectscore=8 adultscore=0 priorityscore=1501 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007290156
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add info on link detach sub-command to man page. Add detach to bash-compl=
etion
as well.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/bpf/bpftool/Documentation/bpftool-link.rst | 8 ++++++++
 tools/bpf/bpftool/bash-completion/bpftool        | 4 ++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/tools/bpf/bpftool/Documentation/bpftool-link.rst b/tools/bpf=
/bpftool/Documentation/bpftool-link.rst
index 38b0949a185b..4a52e7a93339 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-link.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-link.rst
@@ -21,6 +21,7 @@ LINK COMMANDS
=20
 |	**bpftool** **link { show | list }** [*LINK*]
 |	**bpftool** **link pin** *LINK* *FILE*
+|	**bpftool** **link detach *LINK*
 |	**bpftool** **link help**
 |
 |	*LINK* :=3D { **id** *LINK_ID* | **pinned** *FILE* }
@@ -49,6 +50,13 @@ DESCRIPTION
 		  contain a dot character ('.'), which is reserved for future
 		  extensions of *bpffs*.
=20
+	**bpftool link detach** *LINK*
+		  Force-detach link *LINK*. BPF link and its underlying BPF
+		  program will stay valid, but they will be detached from the
+		  respective BPF hook and BPF link will transition into
+		  a defunct state until last open file descriptor for that
+		  link is closed.
+
 	**bpftool link help**
 		  Print short help message.
=20
diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftoo=
l/bash-completion/bpftool
index 257fa310ea2b..f53ed2f1a4aa 100644
--- a/tools/bpf/bpftool/bash-completion/bpftool
+++ b/tools/bpf/bpftool/bash-completion/bpftool
@@ -1122,7 +1122,7 @@ _bpftool()
             ;;
         link)
             case $command in
-                show|list|pin)
+                show|list|pin|detach)
                     case $prev in
                         id)
                             _bpftool_get_link_ids
@@ -1139,7 +1139,7 @@ _bpftool()
                     COMPREPLY=3D( $( compgen -W "$LINK_TYPE" -- "$cur" )=
 )
                     return 0
                     ;;
-                pin)
+                pin|detach)
                     if [[ $prev =3D=3D "$command" ]]; then
                         COMPREPLY=3D( $( compgen -W "$LINK_TYPE" -- "$cu=
r" ) )
                     else
--=20
2.24.1

