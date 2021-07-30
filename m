Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F019C3DC084
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 23:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232934AbhG3VzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 17:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232239AbhG3VzB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 17:55:01 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F76EC0613D5
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 14:54:55 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id u15so6812925wmj.1
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 14:54:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mAC8BUO1HwpV76GQDpKN1M+EroeUTcCIiK92P4SmGtg=;
        b=s8XKDUU5T3Ly+ohE8lqlsY3yeboxbtZr3Vicz2xcHLxk+xquDRokU8mio5IiFho5XN
         NhZHI5Z15uLBj/TsLu45DH0hPqX/BRYCzLjHIikMs+LahZuc4S6yaSIao63VCSL0GO3o
         3+2ogSySY2qU553z1nkTwwT1PYfhjXa6j0lv9RixK/Z50vXM+CYmys8fZ7KRoNjd8qT9
         HxVlupzQvRPA0MnMgZ0xgOsScgEcPdcoF3yMSx2iXYbtSFcAS1KSi8T9I0XSR8sHCN3/
         FO2dJoqgMDhJvJxZHlbyz79Psts5jpQUrgn7f26P5tqVLm9nn5u5TqSyOkiPDFPA5FFT
         0OfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mAC8BUO1HwpV76GQDpKN1M+EroeUTcCIiK92P4SmGtg=;
        b=fTHZaY+mCYaiIfW+lDnFKC3E4yH2irNbZhEZE9FYBu4Dykp0x9ysx69TmSsniax4sD
         t0AbfsKCDnD3ULUE5QEWaDBde71ykIygAf2Axxt5YbcLkpI3t+e0m+H0mKQsl01SjiC1
         YWBFLSZCPYsatzr/3hYShHONxoDfVqF0p+13q81ftsCY178Ths9j89c6n3JnkQym9gLK
         qY1P7a1SHk94SNxIM0i2zP7t6xhlCm4J/mlUyJs5fhw/WOdjDh0YBoCi0u4lczRlIlnH
         kmy3Qx1wM80VCq+XCc8OrTfGkLp3jksM8iNeo3S910y2hL0TSzvi1x2OwcCRlPsEklrR
         NqLw==
X-Gm-Message-State: AOAM5328FWa/kySei76+sQ6VYfJN//F383LYefs4JW3mACrdKfayV6+K
        NRWb0z+yukQ3Ig+5S5WsbbzMMQ==
X-Google-Smtp-Source: ABdhPJyRD/wusnyxOG6dN5hLnkOaTRm4m7Re/WS4sHV/+YfDB7p1jlDRvnKVgDzy/S5tKtJVd7akAw==
X-Received: by 2002:a05:600c:1c09:: with SMTP id j9mr5123837wms.183.1627682093964;
        Fri, 30 Jul 2021 14:54:53 -0700 (PDT)
Received: from localhost.localdomain ([149.86.78.245])
        by smtp.gmail.com with ESMTPSA id v15sm3210871wmj.39.2021.07.30.14.54.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 14:54:53 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next v2 1/7] tools: bpftool: slightly ease bash completion updates
Date:   Fri, 30 Jul 2021 22:54:29 +0100
Message-Id: <20210730215435.7095-2-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210730215435.7095-1-quentin@isovalent.com>
References: <20210730215435.7095-1-quentin@isovalent.com>
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
 tools/bpf/bpftool/bash-completion/bpftool | 54 ++++++++++++-----------
 1 file changed, 29 insertions(+), 25 deletions(-)

diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
index cc33c5824a2f..a7c947e00345 100644
--- a/tools/bpf/bpftool/bash-completion/bpftool
+++ b/tools/bpf/bpftool/bash-completion/bpftool
@@ -404,8 +404,9 @@ _bpftool()
                             return 0
                             ;;
                         5)
-                            COMPREPLY=( $( compgen -W 'msg_verdict stream_verdict \
-                                stream_parser flow_dissector' -- "$cur" ) )
+                            local BPFTOOL_PROG_ATTACH_TYPES='msg_verdict \
+                                stream_verdict stream_parser flow_dissector'
+                            COMPREPLY=( $( compgen -W "$BPFTOOL_PROG_ATTACH_TYPES" -- "$cur" ) )
                             return 0
                             ;;
                         6)
@@ -464,7 +465,7 @@ _bpftool()
 
                     case $prev in
                         type)
-                            COMPREPLY=( $( compgen -W "socket kprobe \
+                            local BPFTOOL_PROG_LOAD_TYPES='socket kprobe \
                                 kretprobe classifier flow_dissector \
                                 action tracepoint raw_tracepoint \
                                 xdp perf_event cgroup/skb cgroup/sock \
@@ -479,8 +480,8 @@ _bpftool()
                                 cgroup/post_bind4 cgroup/post_bind6 \
                                 cgroup/sysctl cgroup/getsockopt \
                                 cgroup/setsockopt cgroup/sock_release struct_ops \
-                                fentry fexit freplace sk_lookup" -- \
-                                                   "$cur" ) )
+                                fentry fexit freplace sk_lookup'
+                            COMPREPLY=( $( compgen -W "$BPFTOOL_PROG_LOAD_TYPES" -- "$cur" ) )
                             return 0
                             ;;
                         id)
@@ -698,15 +699,15 @@ _bpftool()
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
+                            COMPREPLY=( $( compgen -W "$BPFTOOL_MAP_CREATE_TYPES" -- "$cur" ) )
                             return 0
                             ;;
                         key|value|flags|entries)
@@ -1017,34 +1018,37 @@ _bpftool()
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

