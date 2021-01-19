Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B87EB2FBE21
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 18:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732249AbhASRkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 12:40:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391597AbhASPvE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 10:51:04 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6718C061575;
        Tue, 19 Jan 2021 07:50:23 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id u21so22489825lja.0;
        Tue, 19 Jan 2021 07:50:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZizYMuJQ9py7Nk42+7yHdTuqobroM/tXzsUJzEZOKlk=;
        b=J/MmTTnzO15IZyPtb1MUDHhCHtKaOpolhzXeH//mYOqX2+We/QNgR/HKjI6he+VKoN
         7UhxJ8jFkVKyOBMYNJbH0mKP6AKs/pGsRHPpHCSWaKh7GnnQ08i4wdGZG40YgFGHO+m2
         WWt0SR1MYlTqsIBka2ZnXtwzk7pCVy6E1vbrDdsIS6qUxW+GDvBKjZlBdBT1f2pC+yJZ
         54RSSN+6T7Wi+TTBF68fkwAyjKQKls2ZdkS9YE9GVV7aJJk9o4a28keQkpOfcZYr0HDW
         dEQm46vCue0ozN4qsZT55c4sAZHDQUd3242szNq5xfrazkcooVWaHAbtDaoBMdhsNpw3
         hAIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZizYMuJQ9py7Nk42+7yHdTuqobroM/tXzsUJzEZOKlk=;
        b=e0BhAE5tJbBoD7p3sANXS4n4XAtWu4sEandWKy96iilAQLoFddL0fd/QITqxrky/QF
         mmKDab4U4giE6v9lfetdJbPqnyxupVgLd35NfhTXvqtL2rK6WGV1gFf04UOl0/2eiPIm
         l7muKwKNlkOUCMvlP3z8sun7qP5elIdJXcsT18yBUqfHlckrMnBZ8d/4ZdeT/Yiuy/+G
         A+GS4zpBmpUITI2tG2ucWtVfbrpoZo7K77xhUYlnxu6MN9KnmvN6ABxWk4tzOr8e53ZE
         cqGRJ0R0Bk9oZkZ0zGgxF1TsFdDmakVi1qv3koXrFn3fx+EszR+2Nz+UfpKVPhO9I80v
         KuFA==
X-Gm-Message-State: AOAM532TEkErV0yotpHKjqxVCp/IPepm2ugVTT/aLsqpNpAxhlIxb1Ad
        cAGOd+eoq6WhRQW9zdXs5FU=
X-Google-Smtp-Source: ABdhPJzYhRxxDKegWJGsRYtKloSXImZaTRuY1yeW9LZRuN0rNZB4IEdaNr/RrAYI9PZyUJDxjCDPkA==
X-Received: by 2002:a2e:6a04:: with SMTP id f4mr2198974ljc.255.1611071422259;
        Tue, 19 Jan 2021 07:50:22 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (c213-102-90-208.bredband.comhem.se. [213.102.90.208])
        by smtp.gmail.com with ESMTPSA id h20sm2309249lfc.239.2021.01.19.07.50.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 07:50:21 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, kuba@kernel.org,
        jonathan.lemon@gmail.com, maximmi@nvidia.com, davem@davemloft.net,
        hawk@kernel.org, john.fastabend@gmail.com, ciara.loftus@intel.com,
        weqaar.a.janjua@intel.com
Subject: [PATCH bpf-next v2 0/8] Introduce bpf_redirect_xsk() helper
Date:   Tue, 19 Jan 2021 16:50:05 +0100
Message-Id: <20210119155013.154808-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series extends bind() for XDP sockets, so that the bound socket
is added to the netdev_rx_queue _rx array in the netdevice. We call
this to register the socket. To redirect packets to the registered
socket, a new BPF helper is used: bpf_redirect_xsk().

For shared XDP sockets, only the first bound socket is
registered. Users that need more complex setup has to use XSKMAP and
bpf_redirect_map().

Now, why would one use bpf_redirect_xsk() over the regular
bpf_redirect_map() helper?

* Better performance!
* Convenience; Most user use one socket per queue. This scenario is
  what registered sockets support. There is no need to create an
  XSKMAP. This can also reduce complexity from containerized setups,
  where users might what to use XDP sockets without CAP_SYS_ADMIN
  capabilities.

The first patch restructures xdp_do_redirect() a bit, to make it
easier to add the new helper. This restructure also give us a slight
performance benefit. The following three patches extends bind() and
adds the new helper. After that, two libbpf patches that selects XDP
program based on what kernel is running. Finally, selftests for the new
functionality is added.

Note that the libbpf "auto-selection" is based on kernel version, so
it is hard coded to the "-next" version (5.12). If you would like to
try this is out, you will need to change the libbpf patch locally!

Thanks to Maciej and Magnus for the internal review/comments!

Performance (rxdrop, zero-copy)

Baseline
Two cores:                   21.3 Mpps
One core:                    24.5 Mpps

Patched
Two cores, bpf_redirect_map: 21.7 Mpps + 2%
One core, bpf_redirect_map:  24.9 Mpps + 2%

Two cores, bpf_redirect_xsk: 24.0 Mpps +13%
One core, bpf_redirect_xsk:  25.5 Mpps + 4%

Thanks!
Björn

v1->v2: 
  * Added missing XDP programs to selftests.
  * Fixed checkpatch warning in selftests.

Björn Töpel (8):
  xdp: restructure redirect actions
  xsk: remove explicit_free parameter from __xsk_rcv()
  xsk: fold xp_assign_dev and __xp_assign_dev
  xsk: register XDP sockets at bind(), and add new AF_XDP BPF helper
  libbpf, xsk: select AF_XDP BPF program based on kernel version
  libbpf, xsk: select bpf_redirect_xsk(), if supported
  selftest/bpf: add XDP socket tests for bpf_redirect_{xsk, map}()
  selftest/bpf: remove a lot of ifobject casting in xdpxceiver

 include/linux/filter.h                        |  10 +
 include/linux/netdevice.h                     |   1 +
 include/net/xdp_sock.h                        |  12 +
 include/net/xsk_buff_pool.h                   |   2 +-
 include/trace/events/xdp.h                    |  46 ++--
 include/uapi/linux/bpf.h                      |   7 +
 net/core/filter.c                             | 205 ++++++++++--------
 net/xdp/xsk.c                                 | 112 ++++++++--
 net/xdp/xsk_buff_pool.c                       |  12 +-
 tools/include/uapi/linux/bpf.h                |   7 +
 tools/lib/bpf/libbpf.c                        |   2 +-
 tools/lib/bpf/libbpf_internal.h               |   2 +
 tools/lib/bpf/libbpf_probes.c                 |  16 --
 tools/lib/bpf/xsk.c                           |  83 ++++++-
 .../selftests/bpf/progs/xdpxceiver_ext1.c     |  15 ++
 .../selftests/bpf/progs/xdpxceiver_ext2.c     |   9 +
 tools/testing/selftests/bpf/test_xsk.sh       |  48 ++++
 tools/testing/selftests/bpf/xdpxceiver.c      | 164 +++++++++-----
 tools/testing/selftests/bpf/xdpxceiver.h      |   2 +
 19 files changed, 554 insertions(+), 201 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/xdpxceiver_ext1.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdpxceiver_ext2.c


base-commit: 95204c9bfa48d2f4d3bab7df55c1cc823957ff81
-- 
2.27.0

