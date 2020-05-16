Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E51D31D5E62
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 06:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbgEPEGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 00:06:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725275AbgEPEGS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 00:06:18 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE37DC061A0C;
        Fri, 15 May 2020 21:06:17 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id k19so1736388pll.9;
        Fri, 15 May 2020 21:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tcMo9k9IWtMOjQaxDVoLESBBbq+oDKX1tIAb1rdocqY=;
        b=Fp4HMknEq0jWdME2pS6G66k2yzuYZlT4ZS7jIEYv5OQcTWJkQbVFzZYW/Bgir+ewW+
         43G7K88IbCMg82b76WohLyvm/JUydmcLdUOtvA/JX4KB5L+QQ427F+8t7Fs7lyfbf4JQ
         gj42Te1dOhHLltrjTt/wuAMyzCCCE3sLHId5eP7Bmbmpm3JszmK7USEybt/0RDg7wDXF
         EQwWoIqCRUILUQy8jg3cw6dy2hKZcOkoY+aK305CIw16RHSW1aaso+O7rjJe1nIVVsob
         xUE+HLmhvsjrMahlXjdctK+A1OUbzAQoMqBUdSz9W5qn+2GwDosptVxkdpnWejGVdAJV
         qUNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tcMo9k9IWtMOjQaxDVoLESBBbq+oDKX1tIAb1rdocqY=;
        b=uVNPbVhRW5uic+K2FKg1Z+hSAcX/ksjS3HkH50ZiMf1L/Dn3O7VLSIslEWLZ+BxdOL
         gxqJdR6gFEZEiGa+/q+eo0Yz5pgucAPK5RrwYwQ1wcE60aOQex0cv7gj7BO7CF2dtWQZ
         z+6Gf6miQ2rNws9zqNYrV0Pfa4unmyeC4wZDRayfucJ2rR3zjNY6QEgaZDWo4BATF6d7
         Hw3RcAFMjhbQgbFDtm2rciNPCsnfzLWlweS+9g2mwPEpNa+UC+sPFJ3Tk85r6LggZEP6
         ce6vzbGhHL5A0lirQo1xpJT2YV8qWJF7zRbxs2Lw9HZG5yKQGZCCS4XMfaWFHi309tS/
         28bg==
X-Gm-Message-State: AOAM531bVAeCS3/XXxLMrj6edZkuop3ej94fWZOi5GK0oXShU6zqDeWp
        J6bKGGXTcS6TBORfuLXCig==
X-Google-Smtp-Source: ABdhPJz2cb5cOU9I/Ay/zw3g6UavT5t4mThTvUtCs2Kx/y3X1vy7KXjAckJ/HDXdEqyWW0aJRsen5w==
X-Received: by 2002:a17:902:bc48:: with SMTP id t8mr6657257plz.121.1589601976452;
        Fri, 15 May 2020 21:06:16 -0700 (PDT)
Received: from localhost.localdomain ([219.255.158.173])
        by smtp.gmail.com with ESMTPSA id b11sm98663pjz.54.2020.05.15.21.06.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 21:06:15 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>
Subject: [PATCH bpf-next v2 0/5] samples: bpf: refactor kprobe tracing progs with libbpf
Date:   Sat, 16 May 2020 13:06:03 +0900
Message-Id: <20200516040608.1377876-1-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the kprobe BPF program attachment method for bpf_load is
pretty outdated. The implementation of bpf_load "directly" controls and
manages(create, delete) the kprobe events of DEBUGFS. On the other hand,
using using the libbpf automatically manages the kprobe event.
(under bpf_link interface)

This patchset refactors kprobe tracing programs with using libbpf API
for loading bpf program instead of previous bpf_load implementation.

---
Changes in V2:
 - refactor pointer error check with libbpf_get_error
 - on bpf object open failure, return instead jump to cleanup
 - add macro for adding architecture prefix to system calls (sys_*)

Daniel T. Lee (5):
  samples: bpf: refactor pointer error check with libbpf
  samples: bpf: refactor kprobe tracing user progs with libbpf
  samples: bpf: refactor tail call user progs with libbpf
  samples: bpf: add tracex7 test file to .gitignore
  samples: bpf: refactor kprobe, tail call kern progs map definition

 samples/bpf/.gitignore              |  1 +
 samples/bpf/Makefile                | 16 +++----
 samples/bpf/sampleip_kern.c         | 12 +++---
 samples/bpf/sampleip_user.c         |  7 +--
 samples/bpf/sockex3_kern.c          | 36 ++++++++--------
 samples/bpf/sockex3_user.c          | 64 +++++++++++++++++++---------
 samples/bpf/trace_common.h          | 13 ++++++
 samples/bpf/trace_event_kern.c      | 24 +++++------
 samples/bpf/trace_event_user.c      |  9 ++--
 samples/bpf/tracex1_user.c          | 37 +++++++++++++---
 samples/bpf/tracex2_kern.c          | 27 ++++++------
 samples/bpf/tracex2_user.c          | 51 ++++++++++++++++++----
 samples/bpf/tracex3_kern.c          | 24 +++++------
 samples/bpf/tracex3_user.c          | 61 +++++++++++++++++++-------
 samples/bpf/tracex4_kern.c          | 12 +++---
 samples/bpf/tracex4_user.c          | 51 +++++++++++++++++-----
 samples/bpf/tracex5_kern.c          | 14 +++---
 samples/bpf/tracex5_user.c          | 66 +++++++++++++++++++++++++----
 samples/bpf/tracex6_kern.c          | 38 +++++++++--------
 samples/bpf/tracex6_user.c          | 49 ++++++++++++++++++---
 samples/bpf/tracex7_user.c          | 39 +++++++++++++----
 samples/bpf/xdp_redirect_cpu_user.c |  5 +--
 22 files changed, 455 insertions(+), 201 deletions(-)
 create mode 100644 samples/bpf/trace_common.h

-- 
2.25.1

