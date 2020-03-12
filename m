Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D86618389A
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 19:26:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbgCLS0I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 14:26:08 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43257 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbgCLS0I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 14:26:08 -0400
Received: by mail-wr1-f66.google.com with SMTP id b2so2546866wrj.10
        for <netdev@vger.kernel.org>; Thu, 12 Mar 2020 11:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Gc4XGbEnsdtIWPY34ern2lcaBJ5zVKAE3vmO2e4SFfQ=;
        b=L9bfE9GCb6NjbSuBecBwDG3/L2SzwVf7WX6omWK5LB9sYYGRx2OxozR7+GM8SpzI4k
         KwEWOWnq9Xwf6aUE0zK293OtBlktg2iiRYyePAloIJlMOmufl+2JOfEXIhL4Fek3e7PY
         rdnL4PPZRtvIHozsX1MEB60fKIVdTLA08R28Krn6HwoKk10+V/wVu3DQtbfNovL125Bp
         Yx3ST8DRBpl1uNwPZKi7Kc1R9gvnhvFVtOnvwlTdBUEdLLOiv9va4rIR5DZid2ZjOj0C
         tRwMdz5odi/iQghF9mMXSQITm8MJYezmzMsAyTe9a66rVOPkRIdae71VfrhDC6i0Xnc1
         TW7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Gc4XGbEnsdtIWPY34ern2lcaBJ5zVKAE3vmO2e4SFfQ=;
        b=fcdmiPtWY4E9HHZd7Uv8uo0VRx1cb5AZlPEFv1o7r6BOsGERXBGfX2M+jd8oBWWhfY
         gN1giZexB+gBnC6YVQuiRY2/pZsZt+cImduiNpLAKmj82e4SN/na8syk/6+PeIsWf3H8
         QYuSxtlKI9w0Y3mR4zGopSHq1AG7niyVpjemDB/vsWGZ7Fxykudn4CkIVVrcpBGRXj0o
         9jLycB3gQj6cuJmsy02qec6jJCcgZmglVrs7vr9zpb1IaXzBQc7E7Yg8cvl/ZSAt3PnU
         MUUyVbPsU7m1W28rrq+LBtR1cdq5Pzn5/rPvoerfhibNc286OWMMpyAYXqLkc8qk0G1w
         B5hg==
X-Gm-Message-State: ANhLgQ2sV1txQ6ga+TcphJzzJgfYphNKpVExvIJo9VL8jF3hjawrLn4G
        /cLQf6nqxtSz2scQjUQG0NavG4e2QmQ=
X-Google-Smtp-Source: ADFU+vuh+0RDXEwnDckgZwLvjvJuPOv4mibsESf5PLhgeyLJfmwidcZ5J2frTLxelsaYxug/cDGCeg==
X-Received: by 2002:adf:f708:: with SMTP id r8mr12259839wrp.221.1584037566162;
        Thu, 12 Mar 2020 11:26:06 -0700 (PDT)
Received: from localhost.localdomain ([194.35.118.177])
        by smtp.gmail.com with ESMTPSA id r9sm6379134wma.47.2020.03.12.11.26.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2020 11:26:05 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 2/2] tools: bpftool: fix minor bash completion mistakes
Date:   Thu, 12 Mar 2020 18:25:55 +0000
Message-Id: <20200312182555.945-3-quentin@isovalent.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200312182555.945-1-quentin@isovalent.com>
References: <20200312182555.945-1-quentin@isovalent.com>
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

