Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5E9517C98C
	for <lists+netdev@lfdr.de>; Sat,  7 Mar 2020 01:17:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbgCGARd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 19:17:33 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:18148 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726498AbgCGARc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 19:17:32 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0270GDFU032427
        for <netdev@vger.kernel.org>; Fri, 6 Mar 2020 16:17:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=1nENAz7Y8kiqR4HFYPIa/nZ1ccvm8KtvX812Yxx88TA=;
 b=A+ENloTPYIJfjLqn/h871ril5gwN9aftRVSPjvSxdybdyctuSbTAL3FYBqcf8OzsDVcT
 KnwROVtEHGKC8jRQ3c9pcHJxI842mems10/E1hfqV6adZ/EhG3LK3Ik2UZViY0DQxebu
 wMzbX9NIGglQ66XqC6bfgeRpZjPqWMEglMo= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2ykrv7jgfh-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 06 Mar 2020 16:17:31 -0800
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 6 Mar 2020 16:17:30 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 0CDF362E2880; Fri,  6 Mar 2020 16:17:26 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <quentin@isovalent.com>, <kernel-team@fb.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <arnaldo.melo@gmail.com>,
        <jolsa@kernel.org>, Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v5 bpf-next 3/4] ybpftool: bash completion for "bpftool prog profile"
Date:   Fri, 6 Mar 2020 16:17:12 -0800
Message-ID: <20200307001713.3559880-4-songliubraving@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200307001713.3559880-1-songliubraving@fb.com>
References: <20200307001713.3559880-1-songliubraving@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-06_09:2020-03-06,2020-03-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 priorityscore=1501 mlxscore=0 phishscore=0 bulkscore=0 lowpriorityscore=0
 impostorscore=0 suspectscore=0 malwarescore=0 adultscore=0 clxscore=1015
 mlxlogscore=958 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003070000
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add bash completion for "bpftool prog profile" command.

Reviewed-by: Quentin Monnet <quentin@isovalent.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
---
 tools/bpf/bpftool/bash-completion/bpftool | 45 ++++++++++++++++++++++-
 1 file changed, 44 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
index f2838a658339..49f4ab2f67e3 100644
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
+                            case $prev in
+                                id)
+                                    _bpftool_get_prog_ids
+                                    ;;
+                                name)
+                                    _bpftool_get_prog_names
+                                    ;;
+                                pinned)
+                                    _filedir
+                                    ;;
+                            esac
+                            return 0
+                            ;;
+                        5)
+                            COMPREPLY=( $( compgen -W "$METRIC_TYPE duration" -- "$cur" ) )
+                            return 0
+                            ;;
+                        6)
+                            case $prev in
+                                duration)
+                                    return 0
+                                    ;;
+                                *)
+                                    COMPREPLY=( $( compgen -W "$METRIC_TYPE" -- "$cur" ) )
+                                    return 0
+                                    ;;
+                            esac
+                            return 0
+                            ;;
+                        *)
+                            COMPREPLY=( $( compgen -W "$METRIC_TYPE" -- "$cur" ) )
+                            return 0
+                            ;;
+                    esac
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

