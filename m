Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3A8178377
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 20:56:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731458AbgCCT4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 14:56:11 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:52128 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731420AbgCCT4L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 14:56:11 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 023Ju6Qh016934
        for <netdev@vger.kernel.org>; Tue, 3 Mar 2020 11:56:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=cw2duZ+922g/UCLQ0XOQV1XlDNxJBbO0wW10OnBcjXo=;
 b=SUBjKwjUwpiCT5B1sgyBPlraq0RhsrdvoqxMZGCKwc0SEn7q/sgdGoh8XwzocgjBrb+3
 TJG6kvRodHUieMAWDQYCwFFS6IZTAdcPfIKDLkveNK3j4Iq4aaGpbXBK2nNNyY+QhIzE
 0qLsr/KJj/kYBU4o0C3+jzIfoVeklvfTbUY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yhs5g1snw-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 03 Mar 2020 11:56:10 -0800
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Tue, 3 Mar 2020 11:56:07 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 7BFD262E3363; Tue,  3 Mar 2020 11:56:05 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <quentin@isovalent.com>, <kernel-team@fb.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <arnaldo.melo@gmail.com>,
        <jolsa@kernel.org>, Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 3/3] bpftool: bash completion for "bpftool prog profile"
Date:   Tue, 3 Mar 2020 11:55:55 -0800
Message-ID: <20200303195555.1309028-4-songliubraving@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200303195555.1309028-1-songliubraving@fb.com>
References: <20200303195555.1309028-1-songliubraving@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-03_06:2020-03-03,2020-03-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 suspectscore=0 phishscore=0
 mlxscore=0 lowpriorityscore=0 spamscore=0 priorityscore=1501
 impostorscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2001150001 definitions=main-2003030127
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add bash completion for "bpftool prog profile" command.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 tools/bpf/bpftool/bash-completion/bpftool | 45 ++++++++++++++++++++++-
 1 file changed, 44 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
index f2838a658339..e54f36c0c973 100644
--- a/tools/bpf/bpftool/bash-completion/bpftool
+++ b/tools/bpf/bpftool/bash-completion/bpftool
@@ -337,6 +337,7 @@ _bpftool()
 
             local PROG_TYPE='id pinned tag name'
             local MAP_TYPE='id pinned name'
+            local METRIC_TYPE='cycles instructions l1d_loads llc_misses'
             case $command in
                 show|list)
                     [[ $prev != "$command" ]] && return 0
@@ -498,6 +499,48 @@ _bpftool()
                 tracelog)
                     return 0
                     ;;
+                profile)
+                    case $cword in
+                        3)
+                            COMPREPLY=( $( compgen -W "$PROG_TYPE" -- "$cur" ) )
+                            return 0
+                            ;;
+                        4)
+			    case $prev in
+                                id)
+                                    _bpftool_get_prog_ids
+                                    ;;
+                                name)
+                                    _bpftool_get_map_names
+                                    ;;
+                                pinned)
+                                    _filedir
+                                    ;;
+			    esac
+			    return 0
+			    ;;
+			5)
+			    COMPREPLY=( $( compgen -W "$METRIC_TYPE duration" -- "$cur" ) )
+			    return 0
+			    ;;
+                        6)
+			    case $prev in
+                                duration)
+				    return 0
+                                    ;;
+                                *)
+				    COMPREPLY=( $( compgen -W "$METRIC_TYPE" -- "$cur" ) )
+				    return 0
+                                    ;;
+			    esac
+			    return 0
+			    ;;
+                        *)
+			    COMPREPLY=( $( compgen -W "$METRIC_TYPE" -- "$cur" ) )
+			    return 0
+			    ;;
+		    esac
+                    ;;
                 run)
                     if [[ ${#words[@]} -lt 5 ]]; then
                         _filedir
@@ -525,7 +568,7 @@ _bpftool()
                 *)
                     [[ $prev == $object ]] && \
                         COMPREPLY=( $( compgen -W 'dump help pin attach detach \
-                            load loadall show list tracelog run' -- "$cur" ) )
+                            load loadall show list tracelog run profile' -- "$cur" ) )
                     ;;
             esac
             ;;
-- 
2.17.1

