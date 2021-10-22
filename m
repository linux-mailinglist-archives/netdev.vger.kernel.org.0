Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 798BD437BB0
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 19:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233831AbhJVRTK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 13:19:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233799AbhJVRTK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 13:19:10 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37114C061766
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 10:16:52 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id v17so1774144wrv.9
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 10:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=em/Nrblnwi0M9WVCLrGI0pMI8zyH9MaJEleKZPMG568=;
        b=lAYp/QxSR/FGZTbaj3MOSKdZDBq/1u9YZDOMFMsNJfp+yO4prVsvl5tyyNAIwFMqoG
         N8dB3gyrCJkmoXAO/q1IZCdKlGTfqgn/egQaCttmpKphF/XfAnuv+boyVvZCDGrP3KIz
         0Mdc9BlMF7lkcqtqAsUmRN4lk9Sd4DGNbFunUKdc++UQ9O8IAHBXDnmmZyuQWP9mxnYu
         Q1sgj/nlVRlK304XQXcJfCKlW/SO/SuFYszP+b4BSsNnHlVD2chZn8cwXWTAB9ei1M3C
         ZbrWaOIjFcHR/fgZ5YFOVKCKUqpTGtkyNytyUM87Xi20I/+XQpY/WHcjZvR+pfGbSn2X
         XYqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=em/Nrblnwi0M9WVCLrGI0pMI8zyH9MaJEleKZPMG568=;
        b=wH4ky0ewPZpq/iQC3K8EeHk2joQuMJbUZMkH/bpSQDLKS43jTEBmsACrJsdBobCKdh
         4a8Efd4hnzCT27u4p692mKxSogcJ3q67zuz1tvuSYMNK9ySYzLZ2lBTivM4cvSE35wTU
         c3WolUp+YIKT04dUeHsEuOlt4Ax+7YtRA3uXGp4ri1tMCIcG9hRwdT0bo3TzJjNXHr+y
         laB+kaQhu3dnQ3dzn2Uvy0zoSht1yJr9UCL8N9BL/fQ+OTKdouw0327Wi9Mdqje9ZnNA
         dWuJdPYyRJhbUG/CzCjBaElPtWJgYbUKeqXDzEHOUkp1BVI4b+5GbJIP+d1VEXnvprMp
         zx3A==
X-Gm-Message-State: AOAM530Ic72NuX3JlEcfP5ct5zZH6DbG8A5muLAbWSk5JmbZYnbpr2do
        0wClPOyQKtlnXmboA8Mxqxkykw==
X-Google-Smtp-Source: ABdhPJxGnwJLm3aF1RZUg0UtMzbdM4xkUtoB6sj5MEIauSZYc2MgGys6Yw1ymm6ADIWuCPluHvejDA==
X-Received: by 2002:a5d:4643:: with SMTP id j3mr1311680wrs.297.1634923010757;
        Fri, 22 Oct 2021 10:16:50 -0700 (PDT)
Received: from localhost.localdomain ([149.86.74.50])
        by smtp.gmail.com with ESMTPSA id 6sm4427367wma.48.2021.10.22.10.16.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Oct 2021 10:16:50 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 0/5] bpftool: Switch to libbpf's hashmap for referencing BPF objects
Date:   Fri, 22 Oct 2021 18:16:42 +0100
Message-Id: <20211022171647.27885-1-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When listing BPF objects, bpftool can print a number of properties about
items holding references to these objects. For example, it can show pinned
paths for BPF programs, maps, and links; or programs and maps using a given
BTF object; or the names and PIDs of processes referencing BPF objects. To
collect this information, bpftool uses hash maps (to be clear: the data
structures, inside bpftool - we are not talking of BPF maps). It uses the
implementation available from the kernel, and picks it up from
tools/include/linux/hashtable.h.

This patchset converts bpftool's hash maps to a distinct implementation
instead, the one coming with libbpf. The main motivation for this change is
that it should ease the path towards a potential out-of-tree mirror for
bpftool, like the one libbpf already has. Although it's not perfect to
depend on libbpf's internal components, bpftool is intimately tied with the
library anyway, and this looks better than depending too much on (non-UAPI)
kernel headers.

The first two patches contain preparatory work on the Makefile and on the
initialisation of the hash maps for collecting pinned paths for objects.
Then the transition is split into several steps, one for each kind of
properties for which the collection is backed by hash maps.

Quentin Monnet (5):
  bpftool: Remove Makefile dep. on $(LIBBPF) for $(LIBBPF_INTERNAL_HDRS)
  bpftool: Do not expose and init hash maps for pinned path in main.c
  bpftool: Switch to libbpf's hashmap for pinned paths of BPF objects
  bpftool: Switch to libbpf's hashmap for programs/maps in BTF listing
  bpftool: Switch to libbpf's hashmap for PIDs/names references

 tools/bpf/bpftool/Makefile |  12 ++--
 tools/bpf/bpftool/btf.c    | 133 +++++++++++++++----------------------
 tools/bpf/bpftool/common.c |  50 +++++++-------
 tools/bpf/bpftool/link.c   |  44 +++++++-----
 tools/bpf/bpftool/main.c   |  17 +----
 tools/bpf/bpftool/main.h   |  54 +++++++--------
 tools/bpf/bpftool/map.c    |  44 +++++++-----
 tools/bpf/bpftool/pids.c   |  84 ++++++++++++-----------
 tools/bpf/bpftool/prog.c   |  44 +++++++-----
 9 files changed, 246 insertions(+), 236 deletions(-)

-- 
2.30.2

