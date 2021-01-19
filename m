Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D128B2FBB5F
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 16:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391562AbhASPiT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 10:38:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389232AbhASPhs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 10:37:48 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67CB4C061573;
        Tue, 19 Jan 2021 07:37:08 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id v24so23029076lfr.7;
        Tue, 19 Jan 2021 07:37:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7aqjyg0T+I67x5AOe2DmPGa7n0A0pLyQlK9d3r+MkR0=;
        b=eEw44TLhlXQJiJVQEZU355mQf/5f2itKalxC2qIbhercdLLCPtpufBQyWUT70eHIEy
         plNwHdZY7cegfPd3rWIHAzrzDyFV3W54WzU7TWq+9SoihoREvL2/NqXtmaJ0LSP0brza
         Q0SK6BxfASnzpF8vc0e/KmrsFoAlLDudAu/ffiH0mrt9Wk1GtxU0v4h63CirkfYZKkwK
         g0yA55U8jayMMKSAaApsXuMq8lT2C+CCSKoDPd5TSUKP4RW9b/I0ZFSNwhme8rHaqWgM
         DEQZz4HYD761PJvNJJzOnoT51wGrzYfjHCkhX6UluaY6Z44BJs1b0zTQ3g318+RZqtkH
         fEDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7aqjyg0T+I67x5AOe2DmPGa7n0A0pLyQlK9d3r+MkR0=;
        b=IW5BPGwjOUvhwN2n9nd9hVw6QGr5f9x7ocvNJW7XVJq5SGCFKRY2WzuwmcfyU8cO9U
         IctwU7J7pBPXgRCYiINWv4LHAy7IIi7D832N24YZYFj0psnQVkFPHIhkIGfRZ6sQSaZA
         JvmTYV1Z2DqBFWjw+vFRKcww8OcYBTEb+UkcXiS1Wx0OEIT2vEoUt8ABON9vah1TbmIM
         L1Am1tmgQIgCxDSBGYdxzVTlN+XbXCFtHRP5OBUjVRIJPEogb1pHPrVTQRl3igASr6TW
         UB53CM5B2dasJ5yesxsahlUQoSGE0U+Tx3ZlIR/vJZH48iH154v2l4M41I6CM4Uc00RC
         0YnQ==
X-Gm-Message-State: AOAM5322oW27YDb2RRNYWs+nmMxfgPD6z1ou4u55FE2pt5oSIJDiUCbH
        P3YkKaPHnpSwvep7shJHwEg=
X-Google-Smtp-Source: ABdhPJxFZul59sFpnb/MGyYZI7tsieyKq/+vlS76qJA1pEQSjXKekykw2G3FLVXNdcbVjkfYdn0wnA==
X-Received: by 2002:a19:644b:: with SMTP id b11mr2081699lfj.358.1611070626977;
        Tue, 19 Jan 2021 07:37:06 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (c213-102-90-208.bredband.comhem.se. [213.102.90.208])
        by smtp.gmail.com with ESMTPSA id z2sm2309075lfd.142.2021.01.19.07.37.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 07:37:06 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, kuba@kernel.org,
        jonathan.lemon@gmail.com, maximmi@nvidia.com, davem@davemloft.net,
        hawk@kernel.org, john.fastabend@gmail.com, ciara.loftus@intel.com,
        weqaar.a.janjua@intel.com
Subject: [PATCH bpf-next 0/8] Introduce bpf_redirect_xsk() helper
Date:   Tue, 19 Jan 2021 16:36:47 +0100
Message-Id: <20210119153655.153999-1-bjorn.topel@gmail.com>
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


Björn Töpel (8):
  xdp: restructure redirect actions
  xsk: remove explicit_free parameter from __xsk_rcv()
  xsk: fold xp_assign_dev and __xp_assign_dev
  xsk: register XDP sockets at bind(), and add new AF_XDP BPF helper
  libbpf, xsk: select AF_XDP BPF program based on kernel version
  libbpf, xsk: select bpf_redirect_xsk(), if supported
  selftest/bpf: add XDP socket tests for bpf_redirect_{xsk, map}()
  selftest/bpf: remove a lot of ifobject casting in xdpxceiver

 include/linux/filter.h                   |  10 ++
 include/linux/netdevice.h                |   1 +
 include/net/xdp_sock.h                   |  12 ++
 include/net/xsk_buff_pool.h              |   2 +-
 include/trace/events/xdp.h               |  46 +++--
 include/uapi/linux/bpf.h                 |   7 +
 net/core/filter.c                        | 205 +++++++++++++----------
 net/xdp/xsk.c                            | 112 +++++++++++--
 net/xdp/xsk_buff_pool.c                  |  12 +-
 tools/include/uapi/linux/bpf.h           |   7 +
 tools/lib/bpf/libbpf.c                   |   2 +-
 tools/lib/bpf/libbpf_internal.h          |   2 +
 tools/lib/bpf/libbpf_probes.c            |  16 --
 tools/lib/bpf/xsk.c                      |  83 ++++++++-
 tools/testing/selftests/bpf/test_xsk.sh  |  48 ++++++
 tools/testing/selftests/bpf/xdpxceiver.c | 164 ++++++++++++------
 tools/testing/selftests/bpf/xdpxceiver.h |   2 +
 17 files changed, 530 insertions(+), 201 deletions(-)


base-commit: 95204c9bfa48d2f4d3bab7df55c1cc823957ff81
-- 
2.27.0

