Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 148FD3BE89A
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 15:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231715AbhGGNQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 09:16:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbhGGNQ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 09:16:29 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A601DC061574;
        Wed,  7 Jul 2021 06:13:47 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id p16so4014447lfc.5;
        Wed, 07 Jul 2021 06:13:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NwHzmYM5uEjwUcFDkSDotLPD1CEM6aH0VuObqbX+j/s=;
        b=qijBIqnPJUA9x0brYERYwX5lQyf2RpM2mBw7DRfWCbNp529Ru/FOPcS0I4KP69i5Pi
         CIFCZ3I3iWjVqr0vH3K8ytt105IESt2BohQxjsnypmPtLNQ7bGkDvWVpRTef1xt0GUsC
         XxAPgJ4e4UjukDY2if5v8dFn9WgJVUpozu9tv5CeESfX+DnEu+OiPx7THtoXgK2jP3AE
         FiA+wpvflNyKva0uIfSxqjIrVmQ/qMCoQPCMlG/1Du9j+UqfgVN/7YXfDyFYyYlTbx9r
         ZadVZGy/HYolAp3b3CVIqPb4ybfib1qTwSxwReIGB/XXBmJ/VWGmuQva5msM8ugNTdij
         Coag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=NwHzmYM5uEjwUcFDkSDotLPD1CEM6aH0VuObqbX+j/s=;
        b=MZIqboxA2bSTeyRJP8BtIoUhSSMIMNsaR05c51k5w/2W4GEXQBydqZkME5T3GUKwPJ
         wCIKvVM9K1ka95afLA50WQvpmBCM6hyvQywRgKjoyowsfQhhjW6l5NoHzkc9K1wq/Dls
         RcDsMLIUI/QrKL+B2PlOtkOwAImIOJ7RGc+y9YhnNei+GXYn4fJhPicqO3o9RSsmWKM2
         wCKmNPrXf/Z9qdO4mWhWCbn6lR2Z2tuWMNMrJ6MLFdTVd9aiEXwVSZBYNiRjpZV+F/Gs
         IlVbo6fXbSiAM1TmnrR7CLpCWIoVQXqsw9OLgZHsGbN8uubOVkGjUgDKTVdrdvnVDLNG
         FpPg==
X-Gm-Message-State: AOAM533S4+XkrettpFUMWJLs4l6a3r9qYZEqiqiUEPYK43MwaNXbGPSF
        pJv1nn0Wkez9vNfUUcjEtem89wm0j8uMtNqTlA==
X-Google-Smtp-Source: ABdhPJyDldqjJOPt3wVsJaxm5PPKNTuKV9GtmMGJ9HBY6+jnyqv7evMdIgJvHq/HhPezADlBMWjWfQ==
X-Received: by 2002:a05:6512:550:: with SMTP id h16mr19278323lfl.636.1625663625620;
        Wed, 07 Jul 2021 06:13:45 -0700 (PDT)
Received: from localhost.localdomain ([89.42.43.188])
        by smtp.gmail.com with ESMTPSA id u9sm1423571lfm.127.2021.07.07.06.13.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 06:13:44 -0700 (PDT)
From:   Jussi Maki <joamaki@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net, j.vosburgh@gmail.com,
        andy@greyhouse.net, vfalico@gmail.com, andrii@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        Jussi Maki <joamaki@gmail.com>
Subject: [PATCH bpf-next v3 0/5] XDP bonding support
Date:   Wed,  7 Jul 2021 11:25:46 +0000
Message-Id: <20210707112551.9782-1-joamaki@gmail.com>
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

Jussi Maki (5):
  net: bonding: Refactor bond_xmit_hash for use with xdp_buff
  net: core: Add support for XDP redirection to slave device
  net: bonding: Add XDP support to the bonding driver
  devmap: Exclude XDP broadcast to master device
  net: core: Allow netdev_lower_get_next_private_rcu in bh context

 drivers/net/bonding/bond_main.c | 450 ++++++++++++++++++++++++++++----
 include/linux/filter.h          |  13 +-
 include/linux/netdevice.h       |   6 +
 include/net/bonding.h           |   1 +
 kernel/bpf/devmap.c             |  67 ++++-
 net/core/dev.c                  |  11 +-
 net/core/filter.c               |  25 ++
 7 files changed, 504 insertions(+), 69 deletions(-)

-- 
2.27.0

