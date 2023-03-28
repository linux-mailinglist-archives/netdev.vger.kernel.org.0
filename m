Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9916CCBA7
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 22:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbjC1U4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 16:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjC1U4s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 16:56:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B29A01FFF
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 13:56:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56091B81E6F
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 20:56:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE3A7C433D2;
        Tue, 28 Mar 2023 20:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680037004;
        bh=dtVRfSb+OPdj+FfT+gmihz5hWMXLxWt3OLgoXd3RzPk=;
        h=From:To:Cc:Subject:Date:From;
        b=JmVqR0LUwAe8M8WEPQ0c8ku5VKBDWSh0lGGNyhaYG1f45H/dulGm4tX+5OCkp+dUh
         Mk15H+NDQgQIvFnYhkVRTH8HXKNo/BXaQaB9cb0KXLAtIIVi32R+0Fy5s9tgbIh2za
         3MZ46LmCyBR/ovVxRmfs2lUhkP1iIcIz7/EEtLX6jCU2xSUS9uNrpg5OFz7cMeHIzL
         pRXZKBJjtL1UVkcST7XP1OxTqTDVfOoxk1GC1iV+M8kx2y0gftXGaMN15Ik3egGHxD
         oW5OA+Yd3SURzp1vmovhN4diWv0iRiXqMWtIoID9OOZyRLdULkoJ809nH8Va96adyi
         SftbtXyL1BT4Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: [pull request][net-next 00/15] mlx5: Drop internal page cache implementation 
Date:   Tue, 28 Mar 2023 13:56:08 -0700
Message-Id: <20230328205623.142075-1-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave, Hi Jakub,

This series from Dragos provides the patches that remove the mlx5
internal page cache implementation and convert mlx5 RX buffers to
completely rely on the standard page pool.

For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.


The following changes since commit 86e2eca4ddedc07d639c44c990e1c220cac3741e:

  net: ethernet: ti: am65-cpsw: enable p0 host port rx_vlan_remap (2023-03-28 15:29:50 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2023-03-28

for you to fetch changes up to 3905f8d64ccc2c640d8c1179f4452f2bf8f1df56:

  net/mlx5e: RX, Remove unnecessary recycle parameter and page_cache stats (2023-03-28 13:43:59 -0700)

----------------------------------------------------------------
mlx5-updates-2023-03-28

Dragos Tatulea says:
====================

net/mlx5e: RX, Drop page_cache and fully use page_pool

For page allocation on the rx path, the mlx5e driver has been using an
internal page cache in tandem with the page pool. The internal page
cache uses a queue for page recycling which has the issue of head of
queue blocking.

This patch series drops the internal page_cache altogether and uses the
page_pool to implement everything that was done by the page_cache
before:
* Let the page_pool handle dma mapping and unmapping.
* Use fragmented pages with fragment counter instead of tracking via
  page ref.
* Enable skb recycling.

The patch series has the following effects on the rx path:

* Improved performance for the cases when there was low page recycling
  due to head of queue blocking in the internal page_cache. The test
  for this was running a single iperf TCP stream to a rx queue
  which is bound on the same cpu as the application.

  |-------------+--------+--------+------+---------|
  | rq type     | before | after  | unit |   diff  |
  |-------------+--------+--------+------+---------|
  | striding rq |  30.1  |  31.4  | Gbps |  4.14 % |
  | legacy rq   |  30.2  |  33.0  | Gbps |  8.48 % |
  |-------------+--------+--------+------+---------|

* Small XDP performance degradation. The test was is XDP drop
  program running on a single rx queue with small packets incoming
  it looks like this:

  |-------------+----------+----------+------+---------|
  | rq type     | before   | after    | unit |   diff  |
  |-------------+----------+----------+------+---------|
  | striding rq | 19725449 | 18544617 | pps  | -6.37 % |
  | legacy rq   | 19879931 | 18631841 | pps  | -6.70 % |
  |-------------+----------+----------+------+---------|

  This will be handled in a different patch series by adding support for
  multi-packet per page.

* For other cases the performance is roughly the same.

The above numbers were obtained on the following system:
  24 core Intel(R) Xeon(R) Platinum 8380 CPU @ 2.30GHz
  32 GB RAM
  ConnectX-7 single port

The breakdown on the patch series is the following:
* Preparations for introducing the mlx5e_frag_page struct.
* Delete the mlx5e_page_cache struct.
* Enable dma mapping from page_pool.
* Enable skb recycling and fragment counting.
* Do deferred release of pages (just before alloc) to ensure better
  page_pool cache utilization.

====================

----------------------------------------------------------------
Dragos Tatulea (15):
      net/mlx5e: RX, Remove mlx5e_alloc_unit argument in page allocation
      net/mlx5e: RX, Remove alloc unit layout constraint for legacy rq
      net/mlx5e: RX, Remove alloc unit layout constraint for striding rq
      net/mlx5e: RX, Store SHAMPO header pages in array
      net/mlx5e: RX, Remove internal page_cache
      net/mlx5e: RX, Enable dma map and sync from page_pool allocator
      net/mlx5e: RX, Enable skb page recycling through the page_pool
      net/mlx5e: RX, Rename xdp_xmit_bitmap to a more generic name
      net/mlx5e: RX, Defer page release in striding rq for better recycling
      net/mlx5e: RX, Change wqe last_in_page field from bool to bit flags
      net/mlx5e: RX, Defer page release in legacy rq for better recycling
      net/mlx5e: RX, Split off release path for xsk buffers for legacy rq
      net/mlx5e: RX, Increase WQE bulk size for legacy rq
      net/mlx5e: RX, Break the wqe bulk refill in smaller chunks
      net/mlx5e: RX, Remove unnecessary recycle parameter and page_cache stats

 .../ethernet/mellanox/mlx5/counters.rst            |  26 --
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  51 ++-
 .../net/ethernet/mellanox/mlx5/core/en/params.c    |  53 ++-
 .../ethernet/mellanox/mlx5/core/en/reporter_rx.c   |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   |  10 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/rx.c    |  54 +--
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 167 +++++---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    | 452 +++++++++++----------
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |  20 -
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.h |  10 -
 11 files changed, 464 insertions(+), 389 deletions(-)
