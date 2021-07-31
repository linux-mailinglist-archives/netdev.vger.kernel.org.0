Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4EC3E1919
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 18:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbhHEQKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 12:10:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbhHEQKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 12:10:33 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEE7BC061765;
        Thu,  5 Aug 2021 09:10:18 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id b13so7291613wrs.3;
        Thu, 05 Aug 2021 09:10:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=9p0BWmMEtNSCXMgXpMprvV7ayLxCiY66E2bnAsr570k=;
        b=th3AyCbESFprNCmY5xqQMz4KUPjGu3bnG4iBMHq7yt0PyWVPE42L4GRKIXaw9hFR4s
         f23W83h7avb9V9ofOdT4rmi74kxWVdQC6V1lFSeVRHOFOdHTey80H8ffzp9IdFfqn9Tb
         F/ib9lr6surJAfpwpvyLQH46egh2cemQ6z+IvZZNVnBLsWwHAw4HHRI6+doFvMIzYhJM
         s+5t779BD3BT9Mt9Zrp+l9aXnvypcYNGRWWuzbkhmQQfEkI74FfTkV4KIFvFjJO04pi8
         BMojZQdv8EpiCxC55tEI+9gfgsJHGLELPkRcZZBQLWuAdAF2iyxaPaxC8qeMoFl1biTT
         8Kwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=9p0BWmMEtNSCXMgXpMprvV7ayLxCiY66E2bnAsr570k=;
        b=rFoZSxzHMIsFFEmi4ywyft9Ov1naDA86ZqfRC+vpDdUT9tMU3+ppWTmdCGm6iaDc2k
         eiVXxlxkcuvsBK4tZtdnesSPvw37M44qh1Szb2TK1DDWfHZ9vXjkXK79vJz0eZqU9HWV
         BNLMbLSfiLQ1V8evaE6Jo+Aj3oJacDqmCMzaWCgBCvTWW2bopR7GybEVONTIF9ArbCek
         zxD45LNm7XmIhrYIlHeL1rX46LR1QQiz6u++vV8XVfv1v/Pkj3qe+z3ZThURUUz6dQ8e
         6NqO0BP6qeLIiCR2sLWNrJeRM/qTGzRrPTkxhS6JHbu5YthzNIfD683SdETyOaai1gns
         yEMw==
X-Gm-Message-State: AOAM532ohXP4J0fcs56kNV1lQudY2A0xQeKiT31KGtM51kI2/eWJK+RR
        iP3kXs/Sg0zLeDPUMraS21z/5G3yI9wkHBs=
X-Google-Smtp-Source: ABdhPJxbsXart+XZJyvStDIYKQAblurcR40Ls3JrA5QbHuIqj6CJKdX4Td7pxmR22iZvj/ZaHO6F2Q==
X-Received: by 2002:adf:fd90:: with SMTP id d16mr6463147wrr.105.1628179817157;
        Thu, 05 Aug 2021 09:10:17 -0700 (PDT)
Received: from localhost.localdomain ([77.109.191.101])
        by smtp.gmail.com with ESMTPSA id n5sm5843968wme.47.2021.08.05.09.10.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 09:10:16 -0700 (PDT)
From:   Jussi Maki <joamaki@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net, j.vosburgh@gmail.com,
        andy@greyhouse.net, vfalico@gmail.com, andrii@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com
Subject: [PATCH bpf-next v6 0/7]: XDP bonding support
Date:   Sat, 31 Jul 2021 05:57:31 +0000
Message-Id: <20210731055738.16820-1-joamaki@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210609135537.1460244-1-joamaki@gmail.com>
References: <20210609135537.1460244-1-joamaki@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset introduces XDP support to the bonding driver.

The motivation for this change is to enable use of bonding (and
802.3ad) in hairpinning L4 load-balancers such as [1] implemented with
XDP and also to transparently support bond devices for projects that
use XDP given most modern NICs have dual port adapters.  An alternative
to this approach would be to implement 802.3ad in user-space and
implement the bonding load-balancing in the XDP program itself, but
is rather a cumbersome endeavor in terms of slave device management
(e.g. by watching netlink) and requires separate programs for native
vs bond cases for the orchestrator. A native in-kernel implementation
overcomes these issues and provides more flexibility.

Below are benchmark results done on two machines with 100Gbit
Intel E810 (ice) NIC and with 32-core 3970X on sending machine, and
16-core 3950X on receiving machine. 64 byte packets were sent with
pktgen-dpdk at full rate. Two issues [2, 3] were identified with the
ice driver, so the tests were performed with iommu=off and patch [2]
applied. Additionally the bonding round robin algorithm was modified
to use per-cpu tx counters as high CPU load (50% vs 10%) and high rate
of cache misses were caused by the shared rr_tx_counter. Fix for this
has been already merged into net-next. The statistics were collected
using "sar -n dev -u 1 10".

 -----------------------|  CPU  |--| rxpck/s |--| txpck/s |----
 without patch (1 dev):
   XDP_DROP:              3.15%      48.6Mpps
   XDP_TX:                3.12%      18.3Mpps     18.3Mpps
   XDP_DROP (RSS):        9.47%      116.5Mpps
   XDP_TX (RSS):          9.67%      25.3Mpps     24.2Mpps
 -----------------------
 with patch, bond (1 dev):
   XDP_DROP:              3.14%      46.7Mpps
   XDP_TX:                3.15%      13.9Mpps     13.9Mpps
   XDP_DROP (RSS):        10.33%     117.2Mpps
   XDP_TX (RSS):          10.64%     25.1Mpps     24.0Mpps
 -----------------------
 with patch, bond (2 devs):
   XDP_DROP:              6.27%      92.7Mpps
   XDP_TX:                6.26%      17.6Mpps     17.5Mpps
   XDP_DROP (RSS):       11.38%      117.2Mpps
   XDP_TX (RSS):         14.30%      28.7Mpps     27.4Mpps
 --------------------------------------------------------------

RSS: Receive Side Scaling, e.g. the packets were sent to a range of
destination IPs.

[1]: https://cilium.io/blog/2021/05/20/cilium-110#standalonelb
[2]: https://lore.kernel.org/bpf/20210601113236.42651-1-maciej.fijalkowski@intel.com/T/#t
[3]: https://lore.kernel.org/bpf/CAHn8xckNXci+X_Eb2WMv4uVYjO2331UWB2JLtXr_58z0Av8+8A@mail.gmail.com/

Patch 1 prepares bond_xmit_hash for hashing xdp_buff's.
Patch 2 adds hooks to implement redirection after bpf prog run.
Patch 3 implements the hooks in the bonding driver.
Patch 4 modifies devmap to properly handle EXCLUDE_INGRESS with a slave device.
Patch 5 fixes an issue related to recent cleanup of rcu_read_lock in XDP context.
Patch 6 fixes loading of xdp_tx.o by renaming section name.
Patch 7 adds tests.

v5->v6:
- Address Andrii's comments about the tests.

v4->v5:
- As pointed by Andrii, use the generated BPF skeletons rather than libbpf
  directly.
- Renamed section name in progs/xdp_tx.c as the BPF skeleton wouldn't load it
  otherwise due to unknown program type.
- Daniel Borkmann noted that to retain backwards compatibility and allow some
  use cases we should allow attaching XDP programs to a slave device when the
  master does not have a program loaded. Modified the logic to allow this and
  added tests for the different combinations of attaching a program.

v3->v4:
- Add back the test suite, while removing the vmtest.sh modifications to kernel
  config new that CONFIG_BONDING=y is set. Discussed with Magnus Karlsson that
  it makes sense right now to not reuse the code from xdpceiver.c for testing
  XDP bonding.

v2->v3:
- Address Jay's comment to properly exclude upper devices with EXCLUDE_INGRESS
  when there are deeper nesting involved. Now all upper devices are excluded.
- Refuse to enslave devices that already have XDP programs loaded and refuse to
  load XDP programs to slave devices. Earlier one could have a XDP program loaded
  and after enslaving and loading another program onto the bond device the xdp_state
  of the enslaved device would be pointing at an old program.
- Adapt netdev_lower_get_next_private_rcu so it can be called in the XDP context.

v1->v2:
- Split up into smaller easier to review patches and address cosmetic
  review comments.
- Drop the INDIRECT_CALL optimization as it showed little improvement in tests.
- Drop the rr_tx_counter patch as that has already been merged into net-next.
- Separate the test suite into another patch set. This will follow later once a
  patch set from Magnus Karlsson is merged and provides test utilities that can
  be reused for XDP bonding tests. v2 contains no major functional changes and
  was tested with the test suite included in v1.
  (https://lore.kernel.org/bpf/202106221509.kwNvAAZg-lkp@intel.com/T/#m464146d47299125d5868a08affd6d6ce526dfad1)

---


