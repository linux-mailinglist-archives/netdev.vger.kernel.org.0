Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7AF166D52
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 04:16:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729719AbgBUDQh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 22:16:37 -0500
Received: from mx2.suse.de ([195.135.220.15]:59612 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729699AbgBUDQf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Feb 2020 22:16:35 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A8A5DB10B;
        Fri, 21 Feb 2020 03:16:32 +0000 (UTC)
From:   Michal Rostecki <mrostecki@opensuse.org>
To:     bpf@vger.kernel.org
Cc:     Michal Rostecki <mrostecki@opensuse.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        linux-kselftest@vger.kernel.org (open list:KERNEL SELFTEST FRAMEWORK)
Subject: [PATCH bpf-next v2 4/5] bpftool: Update bash completion for "bpftool feature" command
Date:   Fri, 21 Feb 2020 04:16:59 +0100
Message-Id: <20200221031702.25292-5-mrostecki@opensuse.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200221031702.25292-1-mrostecki@opensuse.org>
References: <20200221031702.25292-1-mrostecki@opensuse.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update bash completion for "bpftool feature" command with the new
argument: "full".

Signed-off-by: Michal Rostecki <mrostecki@opensuse.org>
---
 tools/bpf/bpftool/bash-completion/bpftool | 27 ++++++++++++++++-------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
index 754d8395e451..f2bcc4bacee2 100644
--- a/tools/bpf/bpftool/bash-completion/bpftool
+++ b/tools/bpf/bpftool/bash-completion/bpftool
@@ -981,14 +981,25 @@ _bpftool()
         feature)
             case $command in
                 probe)
-                    [[ $prev == "prefix" ]] && return 0
-                    if _bpftool_search_list 'macros'; then
-                        COMPREPLY+=( $( compgen -W 'prefix' -- "$cur" ) )
-                    else
-                        COMPREPLY+=( $( compgen -W 'macros' -- "$cur" ) )
-                    fi
-                    _bpftool_one_of_list 'kernel dev'
-                    return 0
+                    case $prev in
+                        $command)
+                            COMPREPLY+=( $( compgen -W 'kernel dev full macros' -- \
+                                "$cur" ) )
+                            return 0
+                            ;;
+                        prefix)
+                            return 0
+                            ;;
+                        macros)
+                            COMPREPLY+=( $( compgen -W 'prefix' -- "$cur" ) )
+                            return 0
+                            ;;
+                        *)
+                            _bpftool_one_of_list 'kernel dev'
+                            _bpftool_once_attr 'full macros'
+                            return 0
+                            ;;
+                    esac
                     ;;
                 *)
                     [[ $prev == $object ]] && \
-- 
2.25.0

