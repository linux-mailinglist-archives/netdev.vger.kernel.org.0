Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1A141838F7
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 19:46:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbgCLSq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 14:46:29 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37993 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727014AbgCLSq2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 14:46:28 -0400
Received: by mail-wr1-f66.google.com with SMTP id x11so4090110wrv.5
        for <netdev@vger.kernel.org>; Thu, 12 Mar 2020 11:46:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Gc4XGbEnsdtIWPY34ern2lcaBJ5zVKAE3vmO2e4SFfQ=;
        b=b4HLHlTostz7Agkn2AFNmXYks+1Xiah3Jdw4kWa2WylzJKSXGW1usqbHXH1/0gp8bS
         MIbK8Tam7VQXIdtoyxNvPa1f5I6XPjKAUvx1Wt/OeIdMbstatJSiCWgbtxM3PM/CE9hl
         O3ZzaiN/sE/iPTVYmez+tOpT//CzEZDU07lh3ZwNJRUqHrtrp9uy2h0H9pWJ+TqDiklL
         7iYCWGE2WjXFFILhyP87Hvfl/3Fq3WUD5i/6xrmMgF9EzyAmpKb3/Q6cYVvYI54O7JKY
         DMwnfjaM+A8q+RPR3yVRA8DlGmprFzvXmUxwrQw8HU4+WmYyhkPUrK2k8rLQgkUfDBQE
         xpSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Gc4XGbEnsdtIWPY34ern2lcaBJ5zVKAE3vmO2e4SFfQ=;
        b=WzonFVTi8wYqIYjpZRaLoznZv4y1lQihoNNv5QspmuzpzhUHBUqSP155uzgFxeWjIB
         mHul7LB4+2kVWXyIM/hkgJORG7ZNuXz2fISKy3HxQ6SUJdJowfxZ6rkQcAD3CMtqSxAm
         HyH7pK0eLK9yF+saUYb3csxbwDztWA6a0vqFMc9YFNNRzRoHMjhjNuq15qsjvCj+p4sV
         gmfSL9pQqni3uJ3Vtz0cb+iTD+PZ09F5c0x77korxDoe8iCCOvxErx0L8xOUtNBXahwf
         bmxmJxs9Ois8eTHjTJbi8+R38GYqB83RBrutBcrNjdiWgTx2PKUE3UIp6takQE1D2wtY
         e2Pg==
X-Gm-Message-State: ANhLgQ0Ny+G8tG+GmSKs29t/FiBkm7C2QOItqmDDtS4OUG2xad9AEN/I
        qBrSC2DDTwQ+ItTNbtOFaYyYCQ==
X-Google-Smtp-Source: ADFU+vvI2VgifkieNa7ajL6NE65/zw3GlwkiQJfZ+7KAgwYL3E1FzaZIwq9IPd4igBiu6aZOjV/9wA==
X-Received: by 2002:adf:9cd1:: with SMTP id h17mr6709511wre.416.1584038785880;
        Thu, 12 Mar 2020 11:46:25 -0700 (PDT)
Received: from localhost.localdomain ([194.35.118.177])
        by smtp.gmail.com with ESMTPSA id b12sm50019665wro.66.2020.03.12.11.46.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2020 11:46:25 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next v2 2/2] tools: bpftool: fix minor bash completion mistakes
Date:   Thu, 12 Mar 2020 18:46:08 +0000
Message-Id: <20200312184608.12050-3-quentin@isovalent.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200312184608.12050-1-quentin@isovalent.com>
References: <20200312184608.12050-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Minor fixes for bash completion: addition of program name completion for
two subcommands, and correction for program test-runs and map pinning.

The completion for the following commands is fixed or improved:

    # bpftool prog run [TAB]
    # bpftool prog pin [TAB]
    # bpftool map pin [TAB]
    # bpftool net attach xdp name [TAB]

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/bpf/bpftool/bash-completion/bpftool | 29 ++++++++++++++++-------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
index a9cce9d3745a..9b0534f558f1 100644
--- a/tools/bpf/bpftool/bash-completion/bpftool
+++ b/tools/bpf/bpftool/bash-completion/bpftool
@@ -542,8 +542,8 @@ _bpftool()
                     esac
                     ;;
                 run)
-                    if [[ ${#words[@]} -lt 5 ]]; then
-                        _filedir
+                    if [[ ${#words[@]} -eq 4 ]]; then
+                        COMPREPLY=( $( compgen -W "$PROG_TYPE" -- "$cur" ) )
                         return 0
                     fi
                     case $prev in
@@ -551,6 +551,10 @@ _bpftool()
                             _bpftool_get_prog_ids
                             return 0
                             ;;
+                        name)
+                            _bpftool_get_prog_names
+                            return 0
+                            ;;
                         data_in|data_out|ctx_in|ctx_out)
                             _filedir
                             return 0
@@ -756,11 +760,17 @@ _bpftool()
                     esac
                     ;;
                 pin)
-                    if [[ $prev == "$command" ]]; then
-                        COMPREPLY=( $( compgen -W "$PROG_TYPE" -- "$cur" ) )
-                    else
-                        _filedir
-                    fi
+                    case $prev in
+                        $command)
+                            COMPREPLY=( $( compgen -W "$MAP_TYPE" -- "$cur" ) )
+                            ;;
+                        id)
+                            _bpftool_get_map_ids
+                            ;;
+                        name)
+                            _bpftool_get_map_names
+                            ;;
+                    esac
                     return 0
                     ;;
                 event_pipe)
@@ -887,7 +897,7 @@ _bpftool()
             case $command in
                 skeleton)
                     _filedir
-		    ;;
+                    ;;
                 *)
                     [[ $prev == $object ]] && \
                         COMPREPLY=( $( compgen -W 'skeleton help' -- "$cur" ) )
@@ -987,6 +997,9 @@ _bpftool()
                                 id)
                                     _bpftool_get_prog_ids
                                     ;;
+                                name)
+                                    _bpftool_get_prog_names
+                                    ;;
                                 pinned)
                                     _filedir
                                     ;;
-- 
2.20.1

