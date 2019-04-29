Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1000DFD2
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 11:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727823AbfD2Jwn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 05:52:43 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52442 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727537AbfD2Jwm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 05:52:42 -0400
Received: by mail-wm1-f67.google.com with SMTP id j13so13230378wmh.2
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 02:52:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=ddTRmLv3Sk/ckYO9yCrHSXMQdGG/Jaht3+8SnFS3LJI=;
        b=DfPO4wJoi//vng7BCPbbkGAkaJYEtOi2Gw2tEWEGt84k594JJ2FzIf286M0r+fXK0r
         4tT4Z/kLykmcuEBduVdHGVxfdC47xF/wyzWJslLS4IDtcY0KiH/xdVr9V/tEe1SwvTM8
         mzcSmvjsVYrFVaf4BbXIB2TDufFG1/BwRfDAic+0cj2jPFqOgEDxcFmwHmCuF+yG9Et8
         X9nf0b72GE3/ofS9zs3VuS2af7AzWCL/+b+kSTU3r4yGr2dTmoJV0BTrdPR9FWenxVP2
         28YETjZSTHV1fmu7dnXnNF69wO5A6uIaWz2hNtJSEREKOHc7ICVGIM50uwwnuZqDak+U
         PCmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ddTRmLv3Sk/ckYO9yCrHSXMQdGG/Jaht3+8SnFS3LJI=;
        b=XKJW7UHkrKuy6ZxqDle/A7rKJiLRI0Xorb81kgyDWVUDMvgIcNpdMvjquP89dwIprI
         R/ORjQu15C4TZASgjo8nIeeHBBzw1i9W4YHhZSdcVTJgKhvwrOVAUa3SO/P8R37Cuwc2
         bS1M0ljJxox6v8Lkm31zgkBMv0KUWgwpKIBmFNStmwmG7a/ZW2X+Evs+UM2FT19KuAHi
         L0oJ5uQqLyrt0NjQA3xRDHBMXIg9gEmHq//MQrfiOVLR+9J630NM4S3V5kaXNAoNoJS4
         IZpLJsKUXlLA3gYQGtA6tjZZfGdDjNc05FTuXsy3ro2vNxduObGTg4oefJthhxblfDDG
         Ln6Q==
X-Gm-Message-State: APjAAAXnr31IhvkKGfvyruLABQ+Pkoda2jwvSKaMpXoXMNCMt+LxvaxR
        iS8DToGVvPILbZVmJquxHYURxw==
X-Google-Smtp-Source: APXvYqw+mL/lwzhfdzg9TA3z5w2PAVOlGeeH+sNuRHUDhkdm3MFPEdV0WaUW8zM31xRUGc7D5kS97Q==
X-Received: by 2002:a1c:7008:: with SMTP id l8mr16158593wmc.49.1556531561198;
        Mon, 29 Apr 2019 02:52:41 -0700 (PDT)
Received: from cbtest32.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id x20sm11241535wrg.29.2019.04.29.02.52.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Apr 2019 02:52:40 -0700 (PDT)
From:   Quentin Monnet <quentin.monnet@netronome.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: [PATCH bpf-next 0/6] tools: bpftool: add options for debug info from libbpf and verifier
Date:   Mon, 29 Apr 2019 10:52:21 +0100
Message-Id: <20190429095227.9745-1-quentin.monnet@netronome.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
This series adds several options to bpftool to make it print additional
information via libbpf or the kernel verifier when attempting to load
programs.

A first option is used to select the log level for libbpf, and a second one
is used for the verifier level. A third option (with a short name) is added
as a shortcut for printing all available information from both components.

A new API function is added to libbpf in order to pass the log_level from
bpftool with the bpf_object__* part of the API. Also, the flags defined to
name the verifier log levels are moved from kernel headers to UAPI headers,
in an effort to make it easier to users to pass the value they want.

Quentin Monnet (6):
  tools: bpftool: add --log-libbpf option to get debug info from libbpf
  tools: bpftool: add --log-all option to print all possible log info
  libbpf: add bpf_object__load_xattr() API function to pass log_level
  bpf: make BPF_LOG_* flags available in UAPI header
  tools: bpf: report latest changes from BPF UAPI header to tools
  tools: bpftool: add --log-verifier option to print kernel debug logs

 include/linux/bpf_verifier.h                  |   3 -
 include/uapi/linux/bpf.h                      |   5 +
 .../bpftool/Documentation/bpftool-prog.rst    |  20 ++++
 tools/bpf/bpftool/bash-completion/bpftool     |  46 +++++++-
 tools/bpf/bpftool/main.c                      | 105 ++++++++++++++++--
 tools/bpf/bpftool/main.h                      |   1 +
 tools/bpf/bpftool/prog.c                      |  24 ++--
 tools/include/uapi/linux/bpf.h                |   5 +
 tools/lib/bpf/libbpf.c                        |  20 +++-
 tools/lib/bpf/libbpf.h                        |   6 +
 tools/lib/bpf/libbpf.map                      |   1 +
 11 files changed, 211 insertions(+), 25 deletions(-)

-- 
2.17.1

