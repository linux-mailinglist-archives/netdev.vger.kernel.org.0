Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 748543B2B3B
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 11:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231669AbhFXJVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 05:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231569AbhFXJVQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 05:21:16 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C481BC061574;
        Thu, 24 Jun 2021 02:18:56 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id h11so5808928wrx.5;
        Thu, 24 Jun 2021 02:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=tM3RWQBBauYQYRk1u1dT2ftwopoSoZPRTaiu9Ggky6I=;
        b=YOLXzhpASbcxTUxqqfJxuMo/Ew36FKQEsppSpsnhHQjlYyx5Vl2GuLJLaGTrSutoJ1
         QXlPHb1KdiUEkI2xX9vME6kSLOhd0rj6gGEYCYEFQbsO1/X0Qt1RAKM7SdZw/qAU+Pvb
         Y9ys6H9lXZeMEeuIHpAepVj4EA5vzCRpm664owv6F72k7fkE+RVcngD22j24Jc39oQyE
         UWH46172+SmCMR6ZPq7TV6/83y5SRFhbtQ0ArjcRs08mq6QX6QTLkJV4wRkUylULMaTQ
         wIJen/HX2pR+V0w/WY0RVPAILR2KDl9RTgagEvbqk1n130ahN9J3kspMYJg10J5FRz5P
         AVNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=tM3RWQBBauYQYRk1u1dT2ftwopoSoZPRTaiu9Ggky6I=;
        b=iUFtgzywMxqJz08yeTEI03kUDKmH6nwGzMFrb0UxhQphEl5BLxcYJRY5R2kcr1ijMR
         Sh2CAY6EG8peM+mrczVeo3zST4phb1tgv6YJiwqmG4/Ul/kVfgAD7j/MBarbUos8aCZE
         iHINBa45b/vu45SK30S6C9fgeRlPxfhT6rN8MlN3ABSWOPNK5nSafHBUfEhIPd9ynqho
         78PIXJj41DYQYfBP6E1uoKLFiqafJzsom+8kvc3i1E5uaeEI/jYHxQv7eQrAXVqvPMqT
         q/zYWoJIXpfrVkGAETGkydZwMS2r7er6ZyiTwobCo22b1dZWqKQ8THqeS9lKc1JDSSqS
         HJNA==
X-Gm-Message-State: AOAM530j+IzA+iXOM+0LYz6/toEdPwnHRZ6GUCqudzY/FkS/auiK9SXz
        0aXSFAlvwYs0bLkKsCb/tR3V0jgKJtaHbPQ=
X-Google-Smtp-Source: ABdhPJzp7Ig9vw7TqbMWKXJPRqdcYDe4o1FAzg2lAr1omGVf5YQbExagHZw2S9Clm6CL3SFy1iQwNQ==
X-Received: by 2002:a5d:47ca:: with SMTP id o10mr2594958wrc.339.1624526335042;
        Thu, 24 Jun 2021 02:18:55 -0700 (PDT)
Received: from localhost.localdomain (212-51-151-130.fiber7.init7.net. [212.51.151.130])
        by smtp.gmail.com with ESMTPSA id r1sm2456216wmh.32.2021.06.24.02.18.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 02:18:54 -0700 (PDT)
From:   joamaki@gmail.com
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net, j.vosburgh@gmail.com,
        andy@greyhouse.net, vfalico@gmail.com, andrii@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        Jussi Maki <joamaki@gmail.com>
Subject: [PATCH bpf-next v2 0/4] XDP bonding support
Date:   Thu, 24 Jun 2021 09:18:39 +0000
Message-Id: <20210624091843.5151-1-joamaki@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210609135537.1460244-1-joamaki@gmail.com>
References: <20210609135537.1460244-1-joamaki@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jussi Maki <joamaki@gmail.com>

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

Patch 1 prepares bond_xmit_hash for hashing xdp_buff's
Patch 2 adds hooks to implement redirection after bpf prog run
Patch 3 implements the hooks in the bonding driver. 
Patch 4 modifies devmap to properly handle EXCLUDE_INGRESS with a slave device.

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

Jussi Maki (4):
  net: bonding: Refactor bond_xmit_hash for use with xdp_buff
  net: core: Add support for XDP redirection to slave device
  net: bonding: Add XDP support to the bonding driver
  devmap: Exclude XDP broadcast to master device

 drivers/net/bonding/bond_main.c | 431 +++++++++++++++++++++++++++-----
 include/linux/filter.h          |  13 +-
 include/linux/netdevice.h       |   5 +
 include/net/bonding.h           |   1 +
 kernel/bpf/devmap.c             |  34 ++-
 net/core/filter.c               |  25 ++
 6 files changed, 445 insertions(+), 64 deletions(-)

-- 
2.27.0

