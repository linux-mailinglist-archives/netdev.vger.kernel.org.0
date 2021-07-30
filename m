Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CEE93E0165
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 14:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238247AbhHDMq0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 08:46:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238177AbhHDMqN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 08:46:13 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09344C06179F;
        Wed,  4 Aug 2021 05:45:47 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id c16so2069474wrp.13;
        Wed, 04 Aug 2021 05:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Y5oCjtfUPiPZiX19a83BkjFpOhWRd/FNy9QQM35k8Mk=;
        b=pWocEDUhvE3uMq6gJSXE7tlEh6RHfIlrxEfj4bj9aF02u/KOL/kmWB+jvcRgup1QCM
         YRTJ0bDvs3+El3l7cpv0w4E03tkoumzeBUl9hI+wcE5CcwILc3lsK1FlqYjtxvyw68AV
         8kOAx/NVT3kTjSy3OWuRs/cCAaJa7xBFFbTh1GJI+5UZhDHSzsBOIT7DB+6aAfkDRCft
         kptV6lKoTkwp9uJHduxL4ujpuwyIWt9PYrIktsXdxmGP7+Xb0/W3sL5UAwcSaJbZ70dW
         jj6vmoqf4awEctXQ8xokUFqlH3kdSAVfXCvq0rScG7NKU4NnJ4dtRs5nKM6fGC/fqT+E
         zUBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Y5oCjtfUPiPZiX19a83BkjFpOhWRd/FNy9QQM35k8Mk=;
        b=QsUbLisJUvZEW99S0GDbX6H7Cdk7HnHNzmAgmtw1166cYTMkJWJfqN7oMy1US2fJe9
         M9Jve5b6W5rQ7Lmj7rYKOU/lC44Enh/g/sNIHv5/FUdmi7r61t1EIejYV6Bp0RQNYa1q
         nQ7BTtf/S6B07uG2XcVdO288kA2US/+I2t0HObFO7//8rNX2POKa1qoIBjz7gzdRPMeo
         at94O/idt3jCSRepbcAd7zGgX7FymJOKb4e4vsii5sgCDlJYUgvnqecbdNCL/z7kyN5g
         t6ACVM6VZ4PsZBHTcSWhYGrk8Ocqmb97bkGZFIuWXEsyKeAa+9uHhI4hkhS/3R5h1Tk9
         4OaQ==
X-Gm-Message-State: AOAM532DERAnJg8BXv/WRr3xa6WDBLrGb4z0kXxk0jAObzFMW9L/d5ug
        JFvKFzVtjJJQLbYhyohSkMg+XaxzCEcwGaQ=
X-Google-Smtp-Source: ABdhPJxqIQq8kx3LU5FaJKoM2n0dIrI65WjgyhgAZH3lD/NcXjnuPMF9M298BYQI4yQsQy9BrST0Ig==
X-Received: by 2002:adf:9d88:: with SMTP id p8mr29651522wre.409.1628081145299;
        Wed, 04 Aug 2021 05:45:45 -0700 (PDT)
Received: from localhost.localdomain ([77.109.191.101])
        by smtp.gmail.com with ESMTPSA id y4sm2257923wmi.22.2021.08.04.05.45.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 05:45:44 -0700 (PDT)
From:   Jussi Maki <joamaki@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net, j.vosburgh@gmail.com,
        andy@greyhouse.net, vfalico@gmail.com, andrii@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com
Subject: [PATCH bpf-next v5 0/7] XDP bonding support
Date:   Fri, 30 Jul 2021 06:18:15 +0000
Message-Id: <20210730061822.6600-1-joamaki@gmail.com>
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


