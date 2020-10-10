Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93C7F28A203
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 00:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388191AbgJJWxf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:53:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728686AbgJJSo6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 14:44:58 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10550C08EC3E;
        Sat, 10 Oct 2020 11:17:44 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id 144so9746441pfb.4;
        Sat, 10 Oct 2020 11:17:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hZvt0PA/C7uHoXPjIYLi9RxOX2L92HAoDtLQvnBgMdY=;
        b=jGwXx9vS2OAAXYAidZfLiQBk1syQfi/3j9RBagBNgBQEZQIlOpuCEhWcQuYHCU+mab
         wKoy3lIZK7Ui+00eyLssbxME5ObnhU+XCQyRvFj4PrkqOwT6/LjGACZWGo17W+pmJqPs
         uCxu1eAVHkWJMSPFKUSXKHCjEQtPCNcrTAurDuJNjTsu43g0d2N10TiZxIjrXcTwic38
         PeObcZLIYrvuU4FpBaDuUV2bvEm+3ZtVbZqrsSC5/suWqRpKOXIUVTcsyxSFVo9JgmvI
         8OqRT16wq+APdY7oW3+fl/jZXIAGYqf27+LR9c1vsnox9ZWuo81qmI3uw+YTLPaxH/Ly
         CYSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hZvt0PA/C7uHoXPjIYLi9RxOX2L92HAoDtLQvnBgMdY=;
        b=r9jQf79QMk4kDyC3VTCv6w7Wra7U1QsE3VQr8UUXaB4v/9YmG9mfL9rk7VX3MvZKL4
         MayZsv3MVcqzRT7trpqnX2b+iEvUf8Mk4CtQDVCWKn6ubIbRdlChA37fJoAZTVlxPXDF
         d+9hbEVnmL4Cy7o3Qb9bd1PokvKXeBMeIhO0+iScbso2JzMUGMd9b62bsl3A8e743cUh
         grzcqLus9nCHk9D3vnbajzEet8ZCi2UGry73jNBcx+JRlH//Yp6asneuyrf4ctjnwceI
         aRIg/XQBihtcXa0vCt4A6UBQvF2pkFY4708NdeKifw5eaLvhxiaR0WnWtZ+arKXq+vpe
         R7Og==
X-Gm-Message-State: AOAM532vX1Xzpn/NOBVB19prehFj7dxuRJcTh54KPtOQS8dab9wQ4EeU
        cAHa0S9k3YtpJycX/BlbLg==
X-Google-Smtp-Source: ABdhPJxOO/Zak/lpjhTjEgLni2qH4ITJWCGXcGUfWACCA46tHGAfPjByfSXmAFxlI0jJVc9o8I/9hQ==
X-Received: by 2002:a17:90b:4acf:: with SMTP id mh15mr10921782pjb.204.1602353863311;
        Sat, 10 Oct 2020 11:17:43 -0700 (PDT)
Received: from localhost.localdomain ([182.209.58.45])
        by smtp.gmail.com with ESMTPSA id q65sm14974615pfq.219.2020.10.10.11.17.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2020 11:17:42 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Xdp <xdp-newbies@vger.kernel.org>
Subject: [PATCH bpf-next v2 0/3] samples: bpf: Refactor XDP programs with libbpf
Date:   Sun, 11 Oct 2020 03:17:31 +0900
Message-Id: <20201010181734.1109-1-danieltimlee@gmail.com>
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

