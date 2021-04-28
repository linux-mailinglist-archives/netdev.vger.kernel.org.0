Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B092C36D2F1
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 09:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236618AbhD1HUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 03:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231635AbhD1HUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 03:20:19 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F33C061574;
        Wed, 28 Apr 2021 00:19:34 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id 10so572238pfl.1;
        Wed, 28 Apr 2021 00:19:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZN6v01nLBVJ0ad4GxkSUaJKljEm1LGYVTZQy0/N2Pbw=;
        b=HmTvGdUp42KsrWsBLhwqbS8WBwT9AuetXe6q1JLubCOo+sr9j/D4wlMikVf5iHGblD
         1pg5pRlDPz3pxbUPduJ/7MJDK3G+tLA9vUOuDyDzkfjQSaCg6ZY5j/qtxGs31T94mar1
         6S2N2754Soh7AlUQ2NhhTE0f8hCuRe6NtbsJtd1c3EjMIFSM+rrctEDt/QZ+rbOycIXW
         IVaav0K02taq7ba38G75ST664HQLqPhZTsqiR6OwMXafls61DGHiVmDbKCDWEY42QHo4
         Jc95ITTKTEW1fYJve1rYMAv3rxtNK3hQ+45tmoWIHERJHUjqh1fiM+EG7k1wqPnLBWl9
         TMQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZN6v01nLBVJ0ad4GxkSUaJKljEm1LGYVTZQy0/N2Pbw=;
        b=MSz9DkK6p2vTfxQNoQq9sT2EQ1lzPQxIc93MXXaW4xFo4vhAPkxb0sm8fCkm97muop
         aWtH+iExbiT157JZ6bn1j9ryIBVYDQWLTf5E9VXD72p47cj4e5pcosAWs7ZUU101gsbx
         9iDNSP5E3inB9NOVUE58e3EztajW2GSE/aKDBaAnDo/IeSZJLMT6JAxVVwW8FsqFdJ8e
         OUR5Ox5WDA0Se/ObJ9iTnwW+vXe3tEd0XQlCrPWbS0/3hV3R/WCj1M08rm92peKRfMEk
         YjCq59NRKrN6bYzjAScK4xKamG2lrF2l9NPTbtbq2YP5hgXg8GxEr9OeXpVo9+Q7nqZ1
         Co6A==
X-Gm-Message-State: AOAM531P6pfo9su28L2ZcH5qxmGWBxp/tGqm1dhEIVBQtS5JYX8iv1Ho
        lANGynB4eWpJwBuJTnwyZH1g3p5e6Gdniw==
X-Google-Smtp-Source: ABdhPJxCJiuhn6AAb7HPv6MH11ooD464/EYvQnk33r8SPZk4JI0mRpWVNwnMVooq/kGBleZe4WPWAQ==
X-Received: by 2002:a05:6a00:2389:b029:261:abe:184 with SMTP id f9-20020a056a002389b02902610abe0184mr27390159pfc.52.1619594374077;
        Wed, 28 Apr 2021 00:19:34 -0700 (PDT)
Received: from Leo-laptop-t470s.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id jv12sm4152491pjb.56.2021.04.28.00.19.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 00:19:33 -0700 (PDT)
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
Subject: [PATCHv11 bpf-next 0/4] xdp: extend xdp_redirect_map with broadcast support
Date:   Wed, 28 Apr 2021 15:19:12 +0800
Message-Id: <20210428071916.204820-1-liuhangbin@gmail.com>
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

The patchv10 link is here[2].

[1] https://lore.kernel.org/bpf/20210223125809.1376577-1-liuhangbin@gmail.com
[2] https://lore.kernel.org/bpf/20210423020019.2333192-1-liuhangbin@gmail.com

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
 include/linux/filter.h                        |  18 +-
 include/net/xdp.h                             |   1 +
 include/trace/events/xdp.h                    |   6 +-
 include/uapi/linux/bpf.h                      |  16 +-
 kernel/bpf/cpumap.c                           |   3 +-
 kernel/bpf/devmap.c                           | 306 +++++++++++++++---
 net/core/filter.c                             |  37 ++-
 net/core/xdp.c                                |  29 ++
 net/xdp/xskmap.c                              |   3 +-
 samples/bpf/Makefile                          |   3 +
 samples/bpf/xdp_redirect_map_multi_kern.c     |  88 +++++
 samples/bpf/xdp_redirect_map_multi_user.c     | 302 +++++++++++++++++
 tools/include/uapi/linux/bpf.h                |  16 +-
 tools/testing/selftests/bpf/Makefile          |   3 +-
 .../bpf/progs/xdp_redirect_multi_kern.c       |  94 ++++++
 .../selftests/bpf/test_xdp_redirect_multi.sh  | 204 ++++++++++++
 .../selftests/bpf/xdp_redirect_multi.c        | 226 +++++++++++++
 18 files changed, 1310 insertions(+), 65 deletions(-)
 create mode 100644 samples/bpf/xdp_redirect_map_multi_kern.c
 create mode 100644 samples/bpf/xdp_redirect_map_multi_user.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_redirect_multi_kern.c
 create mode 100755 tools/testing/selftests/bpf/test_xdp_redirect_multi.sh
 create mode 100644 tools/testing/selftests/bpf/xdp_redirect_multi.c

-- 
2.26.3

