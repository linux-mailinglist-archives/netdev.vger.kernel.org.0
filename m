Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E3082466A7
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 14:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728347AbgHQMwJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 08:52:09 -0400
Received: from wnew3-smtp.messagingengine.com ([64.147.123.17]:37651 "EHLO
        wnew3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726265AbgHQMwH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 08:52:07 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.west.internal (Postfix) with ESMTP id AF63E7BA;
        Mon, 17 Aug 2020 08:52:05 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 17 Aug 2020 08:52:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=z+o1oqIT69Bxy5Ipe
        yPLN/a1Mbq/cIsWgHBukxiLJ7U=; b=EASC3nHTftjo1WqEDBbniBMHvszJr2i5B
        YL2EFp8/IFGwlcF1Q+0RyPvU8gX9mYgbYOu17eltqE4rYxMEnlgA6O2YDCi9ndTC
        VjaXPpV5asMPuhCa6ctyOpgbihE0zcQm07XrpG/XGdT4EeOMdCf5spId15goldgP
        7BjbaO17mPn//0NYsPEO0S6JQKYON3Of37Pzvly+kS2tFWyS/a6v3HoZwJy81aFJ
        46XgkgaZKrVmPBEgyBa2idKG2AxwJaxsIGK5WevOwiRjndH9+23MUYqnR5apaavT
        28edCbwsjzShXHWe3g0r+HKXYuHCZJgRpu0jCtOOjCQrBcUayZUKg==
X-ME-Sender: <xms:cn06XxbYn3Ui4cQdnUmZypCWLZQ-29qlkoGaoTJPp0fbMbaYD73DXA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtfedgheeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecukfhppeejledrudekvddrieefrdegvdenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthh
    esihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:cn06X4bhcEHHijuaS3vBQyit78v-1IME9b2_xuvmVewq4CUFFL_Vow>
    <xmx:cn06Xz_CllpCUN_7ndK9kWd2YE1cec_Crmz6MXiI8u11aRIrtXZ65w>
    <xmx:cn06X_q6rP3pidlADq0wRalZYhBun1_QM8hxU9z7mp9bXkAro8Ys3Q>
    <xmx:dX06X57KsVa2egHwJ255DISA081PHki_1E7M37D7QH1AfVnHxp5KLUs6e1w>
Received: from localhost.localdomain (bzq-79-182-63-42.red.bezeqint.net [79.182.63.42])
        by mail.messagingengine.com (Postfix) with ESMTPA id 796E9306005F;
        Mon, 17 Aug 2020 08:51:50 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        amcohen@nvidia.com, danieller@nvidia.com, mlxsw@nvidia.com,
        roopa@nvidia.com, dsahern@gmail.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com, saeedm@nvidia.com,
        tariqt@nvidia.com, ayal@nvidia.com, eranbe@nvidia.com,
        mkubecek@suse.cz, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 0/6] devlink: Add device metric support
Date:   Mon, 17 Aug 2020 15:50:53 +0300
Message-Id: <20200817125059.193242-1-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

This patch set extends devlink to allow device drivers to expose device
metrics to user space in a standard and extensible fashion, as opposed
to the driver-specific debugfs approach.

This a joint work with Amit Cohen and Danielle Ratson during a two-day
company hackathon.

Motivation
==========

Certain devices have metrics (e.g., diagnostic counters, histograms)
that are useful to expose to user space for testing and debugging
purposes.

Currently, there is no standardized interface through which these
metrics can be exposed and most drivers resort to debugfs, which is not
very welcome in the networking subsystem and for good reasons. For one,
it is not a stable interface on which users can rely. Secondly, it
results in duplicated code and inconsistent interfaces in case drivers
are implementing similar functionality.

While Ethernet drivers can expose per-port counters to user space via
ethtool, they cannot expose device-wide metrics or configurable metrics
such as counters that can be enabled / disabled or histogram agents.

Solution overview
=================

Currently, the only supported metric type is a counter, but histograms
will be added in the future. The current interface is:

devlink dev metric show [ DEV metric METRIC | group GROUP ]
devlink dev metric set DEV metric METRIC [ group GROUP ]

Device drivers can dynamically register or unregister their metrics with
devlink by calling devlink_metric_counter_create() /
devlink_metric_destroy().

Grouping allows user space to group certain metrics together so that
they can be queried from the kernel using one request and retrieved in a
single response filtered by the kernel (i.e., kernel sets
NLM_F_DUMP_FILTERED).

Example
=======

Instantiate two netdevsim devices:

# echo "10 1" > /sys/bus/netdevsim/new_device
# echo "20 1" > /sys/bus/netdevsim/new_device

Dump all available metrics:

# devlink -s dev metric show
netdevsim/netdevsim10:
   metric dummy_counter type counter group 0 value 2
netdevsim/netdevsim20:
   metric dummy_counter type counter group 0 value 2

Dump a specific metric:

# devlink -s dev metric show netdevsim/netdevsim10 metric dummy_counter
netdevsim/netdevsim10:
   metric dummy_counter type counter group 0 value 3

Set a metric to a different group:

# devlink dev metric set netdevsim/netdevsim10 metric dummy_counter group 10

Dump all metrics in a specific group:

# devlink -s dev metric show group 10
netdevsim/netdevsim10:
   metric dummy_counter type counter group 10 value 4

Future extensions
=================

1. Enablement and disablement of metrics. This is useful in case the
metric adds latency when enabled or consumes limited resources (e.g.,
counters or histogram agents). It is up to the device driver to decide
if a metric is enabled by default or not. Proposed interface:

devlink dev metric set DEV metric METRIC [ group GROUP ]
	[ enable { true | false } ]

2. Histogram metrics. Some devices have the ability to calculate
histograms in hardware by sampling a specific parameter multiple times
per second. For example, the transmission queue depth of a port. This
enables the debugging of microbursts which would otherwise be invisible.
While this can be achieved in software using BPF, it is not applicable
when the data plane is offloaded as the CPU does not see the traffic.
Proposed interface:

devlink dev metric set DEV metric METRIC [ group GROUP ]
	[ enable { true | false } ] [ hist_type { linear | exp } ]
	[ hist_sample_interval SAMPLE ] [ hist_min MIN ] [ hist_max MAX ]
	[ hist_buckets BUCKETS ]

3. Per-port metrics. While all the metrics can be exposed as global and
namespaced as per-port by naming them accordingly, there is value in
allowing user space to dump all metrics related to a certain port.
Proposed interface:

devlink port metric set DEV/PORT_INDEX metric METRIC [ group GROUP ]
	[ enable { true | false } ] [ hist_type { linear | exp } ]
	[ hist_sample_interval SAMPLE ] [ hist_min MIN ] [ hist_max MAX ]
	[ hist_buckets BUCKETS ]
devlink port metric show [ DEV/PORT_INDEX metric METRIC | group GROUP ]

To avoid duplicating ethtool functionality we can decide to expose via
this interface only:

1. Configurable metrics
2. Metrics that are not only relevant to Ethernet ports

TODO
====

1. Add devlink-metric man page
2. Add selftests over mlxsw

Ido Schimmel (6):
  devlink: Add device metric infrastructure
  netdevsim: Add devlink metric support
  selftests: netdevsim: Add devlink metric tests
  mlxsw: reg: Add Tunneling NVE Counters Register
  mlxsw: reg: Add Tunneling NVE Counters Register Version 2
  mlxsw: spectrum_nve: Expose VXLAN counters via devlink-metric

 .../networking/devlink/devlink-metric.rst     |  37 ++
 Documentation/networking/devlink/index.rst    |   1 +
 Documentation/networking/devlink/mlxsw.rst    |  36 ++
 drivers/net/ethernet/mellanox/mlxsw/reg.h     | 104 ++++++
 .../ethernet/mellanox/mlxsw/spectrum_nve.h    |  10 +
 .../mellanox/mlxsw/spectrum_nve_vxlan.c       | 285 +++++++++++++++
 drivers/net/netdevsim/dev.c                   |  92 ++++-
 drivers/net/netdevsim/netdevsim.h             |   1 +
 include/net/devlink.h                         |  18 +
 include/uapi/linux/devlink.h                  |  19 +
 net/core/devlink.c                            | 346 ++++++++++++++++++
 .../drivers/net/netdevsim/devlink.sh          |  49 ++-
 12 files changed, 995 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/networking/devlink/devlink-metric.rst

-- 
2.26.2

