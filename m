Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F059217708
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 20:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728504AbgGGStK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 14:49:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728149AbgGGStK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 14:49:10 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D902BC061755;
        Tue,  7 Jul 2020 11:49:09 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id m9so8544570pfh.0;
        Tue, 07 Jul 2020 11:49:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Kf653+zbToz7bmDqSuYXxZeQRGyIzjUbN2keubtjwkM=;
        b=RAQCPqnLfeS0KdnUeuC7YgwFIg+VZaASxr7DCPAhM2HBRGKL2LsBx78/tKTN/nK7UI
         C6kJvpkcugUkxy4c09JDNVF5nLG4DFq4PIQDhou9NOrOz8KMQVlvZjY+Xs7P3GOPYCV7
         x2nIQgwHZK+FyCfLv0phvc3iGrKgRPPQrAZ7fUGe9RKfpRRtekZBl8YpQrw5nUNEoq3e
         l23ubgkFdl3KhOJzSc5OOOj4JeMUfQ+H8yCntdDEpWQmG65B6MIBVp5mjQ7wYQgyeo2b
         4zFDTFr+weObSgYhsiiqTOqu3no3OcZruRPISVlTV5MHibiTCmj1tUC6P3GWMLdbOInp
         VRJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Kf653+zbToz7bmDqSuYXxZeQRGyIzjUbN2keubtjwkM=;
        b=erOIhmviSUxOBQcwFOX+ZgeX2yi0QojATrYeBqp6Onj5/tMXXYT19fIgdlf1wT48vU
         Gu5tfGt+QYM7zMBx8qaWeACmb4Tjuw69emEQUNcZgHJS5sDkkirnAh0s8x4jtpheN+I7
         tnVFW9MExYntqhEgv5m8KNqbaT6E37tbTYBSJsCa2381NtfTg4CQ4KuBYK7Nv3l8Rqlo
         OnBOcR3nK4803YN3WYCx0d3wlCnj9TPnlUXo1w/QGMeI+4GyghrMOLIDY5LclyI2rydS
         797WPvXbzMwLJrDxmSLicB/lqMQEh2lDk4/md7L36vHCQkAqi29pmRDci7KNOu8duvN6
         Bmjw==
X-Gm-Message-State: AOAM531V0WaL/uB1M4O5xX7uPVZGcwvRkpAsnh0WIsNgYHHafHd21t0/
        qH2Ees6xJWc65XA3nzH6YQ==
X-Google-Smtp-Source: ABdhPJyY4oY8kuBTTlFKRTdDjEYAjCtD/q0wxsOefK6zDP4zTt/fyEtxcfE5LJQpgFAraG0NMwD4Fw==
X-Received: by 2002:a65:6650:: with SMTP id z16mr48401881pgv.161.1594147749326;
        Tue, 07 Jul 2020 11:49:09 -0700 (PDT)
Received: from localhost.localdomain ([182.209.58.45])
        by smtp.gmail.com with ESMTPSA id r7sm1625278pgu.51.2020.07.07.11.49.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2020 11:49:04 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next v2 0/4] samples: bpf: refactor BPF map test with libbpf
Date:   Wed,  8 Jul 2020 03:48:51 +0900
Message-Id: <20200707184855.30968-1-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There have been many changes in how the current bpf program defines
map. The development of libbbpf has led to the new method called 
BTF-defined map, which is a new way of defining BPF maps, and thus has
a lot of differences from the existing MAP definition method.

Although bpf_load was also internally using libbbpf, fragmentation in 
its implementation began to occur, such as using its own structure, 
bpf_load_map_def, to define the map.

Therefore, in this patch set, map test programs, which are closely
related to changes in the definition method of BPF map, were refactored
with libbbpf.

---
Changes in V2:
 - instead of changing event from __x64_sys_connect to __sys_connect,
 fetch and set register values directly
 - fix wrong error check logic with bpf_program
 - set numa_node 0 declaratively at map definition instead of setting it
 from user-space
 - static initialization of ARRAY_OF_MAPS element with '.values'

Daniel T. Lee (4):
  samples: bpf: fix bpf programs with kprobe/sys_connect event
  samples: bpf: refactor BPF map in map test with libbpf
  samples: bpf: refactor BPF map performance test with libbpf
  selftests: bpf: remove unused bpf_map_def_legacy struct

 samples/bpf/Makefile                     |   2 +-
 samples/bpf/map_perf_test_kern.c         | 188 ++++++++++++-----------
 samples/bpf/map_perf_test_user.c         | 164 +++++++++++++-------
 samples/bpf/test_map_in_map_kern.c       |  94 ++++++------
 samples/bpf/test_map_in_map_user.c       |  53 ++++++-
 samples/bpf/test_probe_write_user_kern.c |   9 +-
 tools/testing/selftests/bpf/bpf_legacy.h |  14 --
 7 files changed, 305 insertions(+), 219 deletions(-)

-- 
2.25.1

