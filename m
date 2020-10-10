Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CDF628A3D5
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 01:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389800AbgJJWzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:55:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730697AbgJJTwD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 15:52:03 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27770C0613E4;
        Sat, 10 Oct 2020 03:44:27 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id b19so5799085pld.0;
        Sat, 10 Oct 2020 03:44:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hZvt0PA/C7uHoXPjIYLi9RxOX2L92HAoDtLQvnBgMdY=;
        b=gx+VUSI01RH/8oATHGuLB8KhQEqs+3sIQfQcIyqY/xiTaO1SLBc3RbYR2xjei3taxS
         x+Dba9FI5K64RXJirW3XGdMMXxhDlTV1URuGroGNXUysthIzc8GPlmoznk3JlT3r19/2
         NcbquZVL+5eLw23eGxHzQIf3jdiI/UL8cdmHPTRMoaxrR3jbdnvo60GWE1XHSSp1qrgV
         iQxeMnmqe0BAuc4ySnUG+KeaEaeL48L7kvJpGNU+s7R3IBVFCcvAUOoMI2xCpcmc79Mr
         lb0pNE+eC3m8R6Vqjvvukkz70WeFrXJe8MlOFLf4NvyPpa73IihPoy4Y7KaP7kqSud/k
         hKpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hZvt0PA/C7uHoXPjIYLi9RxOX2L92HAoDtLQvnBgMdY=;
        b=tc4eKdUxDoMN+btGGChmqlvp1eHmbRtbchxM0TZnbwjUeSNo6306W5tR0GuqoVAVq6
         M67DHAkMR2K2WynNWngZ5ueyLxDZyqy7jG3QTNX90lx5sYie64nbjdgW52sDRtAQeil+
         EsqmpMytknzWC79Sh/dSb18Y9GmHNE4cQmp/tPaeY/Gw0grG+019W8RUpjonHRBtajyc
         7CQKJPY6oeTkyvYMRYZSPSyc/6LiE6OqU8i3uBU2ruH2EI5/x4Ib7/Jcty++Gw7kCPw3
         R497hhQlR7b5CROU381KraLVsQRBxowxyRVQ2DLCYbq7t+QUv7OJhOsbVKOmEzjW3mJ/
         1mBw==
X-Gm-Message-State: AOAM533j06PDjuxpcycnzmRgtEY4A1oMePEVpl+KUC1MO7w8xILzmYD0
        YOQam+hnPD0Q78YBAvnsow==
X-Google-Smtp-Source: ABdhPJyIFrQQ23bjGeX89Yr7HqDtbljUSmGUMAiA8YJaH6LMTSgWmOUNCVw8FFOUuJyTy8VO29HdRw==
X-Received: by 2002:a17:902:868d:b029:d3:9c6b:9e05 with SMTP id g13-20020a170902868db02900d39c6b9e05mr15510223plo.51.1602326666458;
        Sat, 10 Oct 2020 03:44:26 -0700 (PDT)
Received: from localhost.localdomain ([182.209.58.45])
        by smtp.gmail.com with ESMTPSA id n127sm13307286pfn.155.2020.10.10.03.44.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2020 03:44:25 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Xdp <xdp-newbies@vger.kernel.org>
Subject: [PATCH bpf-next v2 0/3] samples: bpf: Refactor XDP programs with libbpf
Date:   Sat, 10 Oct 2020 19:44:13 +0900
Message-Id: <20201010104416.1421-1-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To avoid confusion caused by the increasing fragmentation of the BPF
Loader program, this commit would like to convert the previous bpf_load
loader with the libbpf loader.

Thanks to libbpf's bpf_link interface, managing the tracepoint BPF
program is much easier. bpf_program__attach_tracepoint manages the
enable of tracepoint event and attach of BPF programs to it with a
single interface bpf_link, so there is no need to manage event_fd and
prog_fd separately.

And due to addition of generic bpf_program__attach() to libbpf, it is
now possible to attach BPF programs with __attach() instead of
explicitly calling __attach_<type>().

This patchset refactors xdp_monitor with using this libbpf API, and the
bpf_load is removed and migrated to libbpf. Also, attach_tracepoint()
is replaced with the generic __attach() method in xdp_redirect_cpu.
Moreover, maps in kern program have been converted to BTF-defined map.

---
Changes in v2:
 - added cleanup logic for bpf_link and bpf_object in xdp_monitor
 - program section match with bpf_program__is_<type> instead of strncmp
 - revert BTF key/val type to default of BPF_MAP_TYPE_PERF_EVENT_ARRAY
 - split increment into seperate satement
 - refactor pointer array initialization
 - error code cleanup

Daniel T. Lee (3):
  samples: bpf: Refactor xdp_monitor with libbpf
  samples: bpf: Replace attach_tracepoint() to attach() in
    xdp_redirect_cpu
  samples: bpf: refactor XDP kern program maps with BTF-defined map

 samples/bpf/Makefile                |   4 +-
 samples/bpf/xdp_monitor_kern.c      |  60 +++++------
 samples/bpf/xdp_monitor_user.c      | 159 +++++++++++++++++++++-------
 samples/bpf/xdp_redirect_cpu_user.c | 153 +++++++++++++-------------
 samples/bpf/xdp_sample_pkts_kern.c  |  14 ++-
 samples/bpf/xdp_sample_pkts_user.c  |   1 -
 6 files changed, 230 insertions(+), 161 deletions(-)

-- 
2.25.1

