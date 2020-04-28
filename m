Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00FB41BB60F
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 07:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbgD1Fus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 01:50:48 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:13322 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726282AbgD1Fus (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 01:50:48 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 03S5m128016542
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 22:50:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=ZppH8LmTBcCLKB2liD30tj5HEBZWJrX/+aGjeLKGTLY=;
 b=mVHGg3TkcfexgUnyiBWq+uTolpueLzieOqGoCUSxCBFmX91vkJVNaWkxxLKjEffeuGOn
 KHp5LP7pf06WnDpmVRPgytaoiDtP5sDd8RQGIvdvjSsIS3WF1VwB0DYG8AedPMjqIjGH
 8s2R6pIStGPl6tEGjC404T6QMqjk8rSew9I= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 30mgvnh2f4-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 22:50:47 -0700
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 27 Apr 2020 22:50:14 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 58D242EC3228; Mon, 27 Apr 2020 22:50:10 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Quentin Monnet <quentin@isovalent.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 10/10] bpftool: add link bash completions
Date:   Mon, 27 Apr 2020 22:49:44 -0700
Message-ID: <20200428054944.4015462-11-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200428054944.4015462-1-andriin@fb.com>
References: <20200428054944.4015462-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-28_02:2020-04-27,2020-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 bulkscore=0
 malwarescore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 priorityscore=1501 impostorscore=0 mlxlogscore=681 clxscore=1015
 suspectscore=8 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004280049
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend bpftool's bash-completion script to handle new link command and it=
s
sub-commands.

Reviewed-by: Quentin Monnet <quentin@isovalent.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/bpf/bpftool/bash-completion/bpftool | 39 +++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftoo=
l/bash-completion/bpftool
index 45ee99b159e2..c033c3329f73 100644
--- a/tools/bpf/bpftool/bash-completion/bpftool
+++ b/tools/bpf/bpftool/bash-completion/bpftool
@@ -98,6 +98,12 @@ _bpftool_get_btf_ids()
         command sed -n 's/.*"id": \(.*\),$/\1/p' )" -- "$cur" ) )
 }
=20
+_bpftool_get_link_ids()
+{
+    COMPREPLY+=3D( $( compgen -W "$( bpftool -jp link 2>&1 | \
+        command sed -n 's/.*"id": \(.*\),$/\1/p' )" -- "$cur" ) )
+}
+
 _bpftool_get_obj_map_names()
 {
     local obj
@@ -1082,6 +1088,39 @@ _bpftool()
                     ;;
             esac
             ;;
+        link)
+            case $command in
+                show|list|pin)
+                    case $prev in
+                        id)
+                            _bpftool_get_link_ids
+                            return 0
+                            ;;
+                    esac
+                    ;;
+            esac
+
+            local LINK_TYPE=3D'id pinned'
+            case $command in
+                show|list)
+                    [[ $prev !=3D "$command" ]] && return 0
+                    COMPREPLY=3D( $( compgen -W "$LINK_TYPE" -- "$cur" )=
 )
+                    return 0
+                    ;;
+                pin)
+                    if [[ $prev =3D=3D "$command" ]]; then
+                        COMPREPLY=3D( $( compgen -W "$LINK_TYPE" -- "$cu=
r" ) )
+                    else
+                        _filedir
+                    fi
+                    return 0
+                    ;;
+                *)
+                    [[ $prev =3D=3D $object ]] && \
+                        COMPREPLY=3D( $( compgen -W 'help pin show list'=
 -- "$cur" ) )
+                    ;;
+            esac
+            ;;
     esac
 } &&
 complete -F _bpftool bpftool
--=20
2.24.1

