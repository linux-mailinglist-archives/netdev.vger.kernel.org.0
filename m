Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0947C388A31
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 11:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344631AbhESJJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 05:09:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344591AbhESJJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 05:09:24 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F7BBC06175F;
        Wed, 19 May 2021 02:08:03 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id b7so2501579plg.0;
        Wed, 19 May 2021 02:08:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qaVcr/WPJHQ+GOskkczub73YmS6MribEr4nYSYylHwQ=;
        b=fDBQr+lleoF5TWhTSDeH7AZiFxJ8sQesOATZlTiX5sLNu/mxwiTWKYyobeNLVNE8r/
         5KREwGEnpE0aVkFj5VcUzQX4TChlEwGHpaGaSVCYDPm0quBgAvFB9XCfGoG/Rp7kTOwZ
         TVZ8fuC3IGVSIZtzu+0/Qi0/IVJlsYhPHUqN28W5xt6Wy5VmNMm1ePrKf8FUd9hcs/Bq
         /HLwstcykiAfvznQ18cXXaoRpsn+Kl1hT7u+PHJWYg11yRAf+6D+jRnp++PtJN7yEWNx
         lR4HDPAwCkT1dhBp6/p/oSEzSPOvSPh5KAhMu+ttCInc36Mtt4LmUgUxwI/HI0qgSWLI
         HMaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qaVcr/WPJHQ+GOskkczub73YmS6MribEr4nYSYylHwQ=;
        b=XG4TXQ6e/gz+V+rD2yensqcAg5SZkLlBnnXzVk0UdAR6bG2KzLQhRQBwyW+h2PeSUi
         swb3Ob3Hi6WMminCBS7vK6HJGzhiiOjGkhYEhkDtb3bvEwFXPR8l00QsClQuq80wlFlc
         eOVXozm9nZvTNirpMMgeJop+pVW+iCLJCQfvDMLBB2LapGTB1oOQu0yweDp64cmC4s0H
         4VkkwUlqORhK4nRqXuQxU+dW1Xw9AsqwyAqY2eU7Z0pulw4O4yhH5cLnvG2qpNY6CdXL
         TgqaBrKVtXe/NlyeZhg4Q7f01bLVfnyant8GWOPWtKtzuX0ixGcOduCmW8X8G0ATnxOm
         jemg==
X-Gm-Message-State: AOAM533tof3r4sYyDpwx5VDBRR2+Tea6Ehd3OHKCiVDSm29H+zZc6sRK
        NYoLAQ70a/GsMdpgh520oaNCRHkXnbsRcA==
X-Google-Smtp-Source: ABdhPJxxNDceSs2Qtg/w5INhPEtiinkSHml8GofNxs8l+5Yh65RCEM2E5HcSaHlcREKFcTy6YJq0+w==
X-Received: by 2002:a17:902:d386:b029:f3:fa6:84a6 with SMTP id e6-20020a170902d386b02900f30fa684a6mr9553651pld.31.1621415282746;
        Wed, 19 May 2021 02:08:02 -0700 (PDT)
Received: from Leo-laptop-t470s.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s6sm14701848pgv.48.2021.05.19.02.07.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 02:08:02 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH v12 bpf-next 0/4] xdp: extend xdp_redirect_map with broadcast support
Date:   Wed, 19 May 2021 17:07:43 +0800
Message-Id: <20210519090747.1655268-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This patchset is a new implementation for XDP multicast support based
on my previous 2 maps implementation[1]. The reason is that Daniel thinks
the exclude map implementation is missing proper bond support in XDP
context. And there is a plan to add native XDP bonding support. Adding a
exclude map in the helper also increases the complexity of verifier and has
drawback of performance.

The new implementation just add two new flags BPF_F_BROADCAST and
BPF_F_EXCLUDE_INGRESS to extend xdp_redirect_map for broadcast support.

With BPF_F_BROADCAST the packet will be broadcasted to all the interfaces
in the map. with BPF_F_EXCLUDE_INGRESS the ingress interface will be
excluded when do broadcasting.

The patchv11 link is here[2].

[1] https://lore.kernel.org/bpf/20210223125809.1376577-1-liuhangbin@gmail.com
[2] https://lore.kernel.org/bpf/20210513070447.1878448-1-liuhangbin@gmail.com

v12: As Daniel pointed out:
a) defined as const u64 for flag_mask and action_mask in
   __bpf_xdp_redirect_map()
b) remove BPF_F_ACTION_MASK in uapi header
c) remove EXPORT_SYMBOL_GPL for xdpf_clone()

v11:
a) Use unlikely() when checking if this is for broadcast redirecting.
b) Fix a tracepoint NULL pointer issue Jesper found
c) Remove BPF_F_REDIR_MASK and just use OR flags to make the reader more
   clear about what's flags we are using
d) Add the performace number with multi veth interfaces in patch 01
   description.
e) remove some sleeps to reduce the testing time in patch04. Re-struct the
   test and make clear what flags we are testing.

v10: use READ/WRITE_ONCE when read/write map instead of xchg()
v9: Update patch 01 commit description
v8: use hlist_for_each_entry_rcu() when looping the devmap hash ojbs
v7: No need to free xdpf in dev_map_enqueue_clone() if xdpf_clone failed.
v6: Fix a skb leak in the error path for generic XDP
v5: Just walk the map directly to get interfaces as get_next_key() of devmap
    hash may restart looping from the first key if the device get removed.
    After update the performace has improved 10% compired with v4.
v4: Fix flags never cleared issue in patch 02. Update selftest to cover this.
v3: Rebase the code based on latest bpf-next
v2: fix flag renaming issue in patch 02


Hangbin Liu (3):
  xdp: extend xdp_redirect_map with broadcast support
  sample/bpf: add xdp_redirect_map_multi for redirect_map broadcast test
  selftests/bpf: add xdp_redirect_multi test

Jesper Dangaard Brouer (1):
  bpf: run devmap xdp_prog on flush instead of bulk enqueue

 include/linux/bpf.h                           |  20 ++
 include/linux/filter.h                        |  19 +-
 include/net/xdp.h                             |   1 +
 include/trace/events/xdp.h                    |   6 +-
 include/uapi/linux/bpf.h                      |  14 +-
 kernel/bpf/cpumap.c                           |   3 +-
 kernel/bpf/devmap.c                           | 306 +++++++++++++++---
 net/core/filter.c                             |  37 ++-
 net/core/xdp.c                                |  28 ++
 net/xdp/xskmap.c                              |   3 +-
 samples/bpf/Makefile                          |   3 +
 samples/bpf/xdp_redirect_map_multi_kern.c     |  88 +++++
 samples/bpf/xdp_redirect_map_multi_user.c     | 302 +++++++++++++++++
 tools/include/uapi/linux/bpf.h                |  14 +-
 tools/testing/selftests/bpf/Makefile          |   3 +-
 .../bpf/progs/xdp_redirect_multi_kern.c       |  94 ++++++
 .../selftests/bpf/test_xdp_redirect_multi.sh  | 204 ++++++++++++
 .../selftests/bpf/xdp_redirect_multi.c        | 226 +++++++++++++
 18 files changed, 1306 insertions(+), 65 deletions(-)
 create mode 100644 samples/bpf/xdp_redirect_map_multi_kern.c
 create mode 100644 samples/bpf/xdp_redirect_map_multi_user.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_redirect_multi_kern.c
 create mode 100755 tools/testing/selftests/bpf/test_xdp_redirect_multi.sh
 create mode 100644 tools/testing/selftests/bpf/xdp_redirect_multi.c

-- 
2.26.3

