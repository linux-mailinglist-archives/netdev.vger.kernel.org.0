Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90C0F211A00
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 04:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726374AbgGBCRA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 22:17:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725845AbgGBCRA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 22:17:00 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BD01C08C5C1;
        Wed,  1 Jul 2020 19:17:00 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id u5so11835574pfn.7;
        Wed, 01 Jul 2020 19:17:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=egnC0GNYGHuNV6qyWKpbS2ZeD+YbiDqcnODMXAUX1eA=;
        b=eP6nE0V+G1sf0ZkCxuGRe2p/HL70ICrNoKSqW2J4VWjMB+dVnO/ymOXISqFSqxJP97
         u32L7aTKT1C7k/CY10fdfloG/rlp4QqJZ+udTMwdj7mYWmk1rlUUENIvM1Vggb5nLTGO
         XyBlwP9xSKoj/2M4QCD3smpgkaQ85pUi61kl2EpvDfB7zf++/Z+w4bqkbCQ5IAsJ+9Xf
         F/7g2CTKOP0fCwF70jJnOEPEya8GnvHP2aBTnRtitHcx3dJweQi2RZXPgJyd/98eIyD/
         uDe/Ppk/OfpZlc0tf+gBtsHEtah0evmjaWzwOvpMvfo4gCPA04EIc9jqnmu8VQ/xhUWJ
         Pjpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=egnC0GNYGHuNV6qyWKpbS2ZeD+YbiDqcnODMXAUX1eA=;
        b=sYaK8KElVZH5Nrr38+CX/S4hURNZGlFbzX5U6Y7MCD7v5Y51CvieLW6xhWMva1zpTJ
         xiSgfv6Bz79+2crrxJCFeD5IcvpSUioFlQmkGhN5AT1oruOLAdLoyiv08S9mji620twM
         ma8gywe7626LaY5iTPy8WngYZ5ofMWZbTjpvyjYkX3VQ11xXInzJV2H1yRw8ViNNEe3L
         6rclHzHE6FQ+iJsK9+jk8gIjMQNbaaEl4/U9P+diznRedO9Gn4LuJOi3/qRCuRtmulbg
         N03LlinUP/tn8gX5CL9nQUYcLxaYeUeTt6Nyu0kxEsKHiblZc/XhYTH+RRgODvHSl9R2
         FRdQ==
X-Gm-Message-State: AOAM531BYLEnYjl2mzqaJ84AGqFsoMHal81C2BEGj06Y7HWcoq00Nl7+
        9nZGf4H+npul5TWYop1Ejb5tOxLXww==
X-Google-Smtp-Source: ABdhPJzWDFBvqa3OWiuUB1Lg/l5JhB622QC2Y2DFVWFp1UuLvXAFaaqiYnMgqPLNEotkH2+adE8ZCA==
X-Received: by 2002:a63:417:: with SMTP id 23mr21348577pge.44.1593656219500;
        Wed, 01 Jul 2020 19:16:59 -0700 (PDT)
Received: from localhost.localdomain ([182.209.58.45])
        by smtp.gmail.com with ESMTPSA id s1sm6428828pjp.14.2020.07.01.19.16.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 19:16:58 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next 0/4] samples: bpf: refactor BPF map test with libbpf
Date:   Thu,  2 Jul 2020 11:16:42 +0900
Message-Id: <20200702021646.90347-1-danieltimlee@gmail.com>
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

Daniel T. Lee (4):
  samples: bpf: fix bpf programs with kprobe/sys_connect event
  samples: bpf: refactor BPF map in map test with libbpf
  samples: bpf: refactor BPF map performance test with libbpf
  selftests: bpf: remove unused bpf_map_def_legacy struct

 samples/bpf/Makefile                     |   4 +-
 samples/bpf/map_perf_test_kern.c         | 182 +++++++++++------------
 samples/bpf/map_perf_test_user.c         | 130 +++++++++++-----
 samples/bpf/test_map_in_map_kern.c       |  87 ++++++-----
 samples/bpf/test_map_in_map_user.c       |  53 ++++++-
 samples/bpf/test_probe_write_user_kern.c |   2 +-
 tools/testing/selftests/bpf/bpf_legacy.h |  14 --
 7 files changed, 275 insertions(+), 197 deletions(-)

-- 
2.25.1

