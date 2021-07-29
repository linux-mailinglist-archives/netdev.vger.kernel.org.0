Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B21F03DA909
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 18:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231469AbhG2Q3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 12:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbhG2Q3p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 12:29:45 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCDF2C0613C1
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 09:29:41 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id c16so7640703wrp.13
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 09:29:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UL65CREhsUTX+wpIFaepq935uyxPAvZ4eTS/60V/p0A=;
        b=xKADFhgBvtMxJL90fuqJQrgCuUZcxZsk0aEsVshGUusbPk0dF9qRsaUpvDqV6vserK
         Iv8YTHl2cXEzr2liXRZhp6SjmauEZaDskCi/jyEfqFjQwSSiHcnvfihOhJE8VM+bfiMh
         hmGN1cKdZq3H0DQ6dalG+0U5NMO8fqIEoeftWsZ/W0dPhZsswv+ZzfzIf5sUxyAZYRfJ
         zKxOUDqJXucYspTXTVchRcX8+DH+JoKcOC3mqew+yz9vqST+cXV+Hop75s1fhakIjI4y
         E8xKuT/pUuP7SdOJQ8uLdUL+OwVnUejHlQkvsbKvd1QjgNVQhcYgzrHLYM4J2RD2vedX
         8Rig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UL65CREhsUTX+wpIFaepq935uyxPAvZ4eTS/60V/p0A=;
        b=X50Iykv9REr6RG4q6j2ZwnoFhXq5QyTnsolv1vdZgeXnObWWapAR+h9WDlglxgaN9m
         hv9j0USUV8iVxaKVju6TMK0eBCS4dDJaiCZCA30pmgu64HMO2+W3a/Y2fe+j0v7KSmMQ
         HTFXkfQ/TkRUjf/ugoW0et4ZhSwZhzx1gR9JgyOt1O1bz7sTBdoQ+rLlMKvS0YUQQfKn
         UEwzhBqXzkkC1kyymT+YCJb+nf/leV9pzCmauqL6n77NJDuFl7TcJNKZwlZtKBdgFpFV
         DOSWDUelGKvGdbISK3KfBNntmwFbUnRaltVqeNTPkVsZReEsodSP+vBUiGkoTTgaOnD9
         EVKQ==
X-Gm-Message-State: AOAM532VPeFnn12PtWyo3QjMyL/HPHMfasA3weUL+AcSpFTSRk9jvMKL
        4DO3OSDct5+6gvmn/vd2pXtPvg==
X-Google-Smtp-Source: ABdhPJyrKAT6qQfsESvgrQPNc9E75+HiEMB+KHXZThObUia+uD9MtTlB6eyMAq91Jhx5oUwi7dqcvQ==
X-Received: by 2002:adf:9cc7:: with SMTP id h7mr3246429wre.406.1627576180333;
        Thu, 29 Jul 2021 09:29:40 -0700 (PDT)
Received: from localhost.localdomain ([149.86.75.13])
        by smtp.gmail.com with ESMTPSA id 140sm3859331wmb.43.2021.07.29.09.29.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 09:29:39 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 1/7] tools: bpftool: slightly ease bash completion updates
Date:   Thu, 29 Jul 2021 17:29:26 +0100
Message-Id: <20210729162932.30365-2-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210729162932.30365-1-quentin@isovalent.com>
References: <20210729162932.30365-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bash completion for bpftool gets two minor improvements in this patch.

Move the detection of attach types for "bpftool cgroup attach" outside
of the "case/esac" bloc, where we cannot reuse our variable holding the
list of supported attach types as a pattern list. After the change, we
have only one list of cgroup attach types to update when new types are
added, instead of the former two lists.

Also rename the variables holding lists of names for program types, map
types, and attach types, to make them more unique. This can make it
slightly easier to point people to the relevant variables to update, but
the main objective here is to help run a script to check that bash
completion is up-to-date with bpftool's source code.

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/bpf/bpftool/bash-completion/bpftool | 57 +++++++++++++----------
 1 file changed, 32 insertions(+), 25 deletions(-)

diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
index cc33c5824a2f..b2e33a2d8524 100644
--- a/tools/bpf/bpftool/bash-completion/bpftool
+++ b/tools/bpf/bpftool/bash-completion/bpftool
@@ -404,8 +404,10 @@ _bpftool()
                             return 0
                             ;;
                         5)
-                            COMPREPLY=( $( compgen -W 'msg_verdict stream_verdict \
-                                stream_parser flow_dissector' -- "$cur" ) )
+                            local BPFTOOL_PROG_ATTACH_TYPES='msg_verdict \
+                                stream_verdict stream_parser flow_dissector'
+                            COMPREPLY=( $( compgen -W \
+                                "$BPFTOOL_PROG_ATTACH_TYPES" -- "$cur" ) )
                             return 0
                             ;;
                         6)
@@ -464,7 +466,7 @@ _bpftool()
 
                     case $prev in
                         type)
-                            COMPREPLY=( $( compgen -W "socket kprobe \
+                            local BPFTOOL_PROG_LOAD_TYPES='socket kprobe \
                                 kretprobe classifier flow_dissector \
                                 action tracepoint raw_tracepoint \
                                 xdp perf_event cgroup/skb cgroup/sock \
@@ -479,8 +481,9 @@ _bpftool()
                                 cgroup/post_bind4 cgroup/post_bind6 \
                                 cgroup/sysctl cgroup/getsockopt \
                                 cgroup/setsockopt cgroup/sock_release struct_ops \
-                                fentry fexit freplace sk_lookup" -- \
-                                                   "$cur" ) )
+                                fentry fexit freplace sk_lookup'
+                            COMPREPLY=( $( compgen -W \
+                                "$BPFTOOL_PROG_LOAD_TYPES" -- "$cur" ) )
                             return 0
                             ;;
                         id)
@@ -698,15 +701,16 @@ _bpftool()
                             return 0
                             ;;
                         type)
-                            COMPREPLY=( $( compgen -W 'hash array prog_array \
-                                perf_event_array percpu_hash percpu_array \
-                                stack_trace cgroup_array lru_hash \
+                            local BPFTOOL_MAP_CREATE_TYPES='hash array \
+                                prog_array perf_event_array percpu_hash \
+                                percpu_array stack_trace cgroup_array lru_hash \
                                 lru_percpu_hash lpm_trie array_of_maps \
                                 hash_of_maps devmap devmap_hash sockmap cpumap \
                                 xskmap sockhash cgroup_storage reuseport_sockarray \
                                 percpu_cgroup_storage queue stack sk_storage \
-                                struct_ops inode_storage task_storage' -- \
-                                                   "$cur" ) )
+                                struct_ops inode_storage task_storage'
+                            COMPREPLY=( $( compgen -W \
+                                "$BPFTOOL_MAP_CREATE_TYPES" -- "$cur" ) )
                             return 0
                             ;;
                         key|value|flags|entries)
@@ -1017,34 +1021,37 @@ _bpftool()
                     return 0
                     ;;
                 attach|detach)
-                    local ATTACH_TYPES='ingress egress sock_create sock_ops \
-                        device bind4 bind6 post_bind4 post_bind6 connect4 connect6 \
+                    local BPFTOOL_CGROUP_ATTACH_TYPES='ingress egress \
+                        sock_create sock_ops device \
+                        bind4 bind6 post_bind4 post_bind6 connect4 connect6 \
                         getpeername4 getpeername6 getsockname4 getsockname6 \
                         sendmsg4 sendmsg6 recvmsg4 recvmsg6 sysctl getsockopt \
                         setsockopt sock_release'
                     local ATTACH_FLAGS='multi override'
                     local PROG_TYPE='id pinned tag name'
-                    case $prev in
-                        $command)
-                            _filedir
-                            return 0
-                            ;;
-                        ingress|egress|sock_create|sock_ops|device|bind4|bind6|\
-                        post_bind4|post_bind6|connect4|connect6|getpeername4|\
-                        getpeername6|getsockname4|getsockname6|sendmsg4|sendmsg6|\
-                        recvmsg4|recvmsg6|sysctl|getsockopt|setsockopt|sock_release)
+                    # Check for $prev = $command first
+                    if [ $prev = $command ]; then
+                        _filedir
+                        return 0
+                    # Then check for attach type. This is done outside of the
+                    # "case $prev in" to avoid writing the whole list of attach
+                    # types again as pattern to match (where we cannot reuse
+                    # our variable).
+                    elif [[ $BPFTOOL_CGROUP_ATTACH_TYPES =~ $prev ]]; then
                             COMPREPLY=( $( compgen -W "$PROG_TYPE" -- \
                                 "$cur" ) )
                             return 0
-                            ;;
+                    fi
+                    # case/esac for the other cases
+                    case $prev in
                         id)
                             _bpftool_get_prog_ids
                             return 0
                             ;;
                         *)
-                            if ! _bpftool_search_list "$ATTACH_TYPES"; then
-                                COMPREPLY=( $( compgen -W "$ATTACH_TYPES" -- \
-                                    "$cur" ) )
+                            if ! _bpftool_search_list "$BPFTOOL_CGROUP_ATTACH_TYPES"; then
+                                COMPREPLY=( $( compgen -W \
+                                    "$BPFTOOL_CGROUP_ATTACH_TYPES" -- "$cur" ) )
                             elif [[ "$command" == "attach" ]]; then
                                 # We have an attach type on the command line,
                                 # but it is not the previous word, or
-- 
2.30.2

