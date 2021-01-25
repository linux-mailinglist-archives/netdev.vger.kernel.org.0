Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE3F53031EC
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 03:37:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730920AbhAYQuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 11:50:19 -0500
Received: from mail-40134.protonmail.ch ([185.70.40.134]:32048 "EHLO
        mail-40134.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730896AbhAYQsV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 11:48:21 -0500
Date:   Mon, 25 Jan 2021 16:47:08 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1611593234; bh=I3xy6sZ12ElIWuQRDnLe05W3RMEqCz0yicJ3v/sVy5A=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=LS3VPvFHa92bA0w/PDSrAx7Qy/4AcGyC/MI8tT6di2/Hy6CP3SIU90b93w77++WKx
         4ep21Au8baahOT97nA1uzY3MkjP/uog4jOS7YAwgJ5Icro7+tTNxcBQkI6bpJvwzSr
         GzBJecJIKrvdBQaz/HoStENCeDP5k7EUBZy5GH85APmlVQZf38VMT1euB0gpA7v++d
         p2VXld4WAsLMrXjzra7WETRMTji4+b/k6vEVCbiVsQ86tXdcK74hf02JrxEkH2P67o
         CavBOlegelbNi9KywlMt6pnXLVcBuikRYxZGo0crzJ+lUfb37w4b6agmRzxTti8ylq
         +6jshfreQ5aBQ==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Aleksandr Nogikh <nogikh@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Dexuan Cui <decui@microsoft.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        linux-rdma@vger.kernel.org, linux-mm@kvack.org,
        Alexander Lobakin <alobakin@pm.me>
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH net-next 2/3] net: constify page_is_pfmemalloc() argument at call sites
Message-ID: <20210125164612.243838-3-alobakin@pm.me>
In-Reply-To: <20210125164612.243838-1-alobakin@pm.me>
References: <20210125164612.243838-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Constify "page" argument for page_is_pfmemalloc() users where applicable.

Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c   | 2 +-
 drivers/net/ethernet/intel/fm10k/fm10k_main.c     | 2 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c       | 2 +-
 drivers/net/ethernet/intel/iavf/iavf_txrx.c       | 2 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c         | 2 +-
 drivers/net/ethernet/intel/igb/igb_main.c         | 2 +-
 drivers/net/ethernet/intel/igc/igc_main.c         | 2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c     | 2 +-
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c   | 2 +-
 include/linux/skbuff.h                            | 4 ++--
 11 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/=
ethernet/hisilicon/hns3/hns3_enet.c
index 512080640cbc..0f8e962b5010 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2800,7 +2800,7 @@ static void hns3_nic_alloc_rx_buffers(struct hns3_ene=
t_ring *ring,
 =09writel(i, ring->tqp->io_base + HNS3_RING_RX_RING_HEAD_REG);
 }
=20
-static bool hns3_page_is_reusable(struct page *page)
+static bool hns3_page_is_reusable(const struct page *page)
 {
 =09return page_to_nid(page) =3D=3D numa_mem_id() &&
 =09=09!page_is_pfmemalloc(page);
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_main.c b/drivers/net/et=
hernet/intel/fm10k/fm10k_main.c
index 99b8252eb969..32fcb7a51b5d 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_main.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_main.c
@@ -194,7 +194,7 @@ static void fm10k_reuse_rx_page(struct fm10k_ring *rx_r=
ing,
 =09=09=09=09=09 DMA_FROM_DEVICE);
 }
=20
-static inline bool fm10k_page_is_reserved(struct page *page)
+static inline bool fm10k_page_is_reserved(const struct page *page)
 {
 =09return (page_to_nid(page) !=3D numa_mem_id()) || page_is_pfmemalloc(pag=
e);
 }
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethe=
rnet/intel/i40e/i40e_txrx.c
index 2574e78f7597..3886cddfd856 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -1850,7 +1850,7 @@ static bool i40e_cleanup_headers(struct i40e_ring *rx=
_ring, struct sk_buff *skb,
  * A page is not reusable if it was allocated under low memory
  * conditions, or it's not in the same NUMA node as this CPU.
  */
-static inline bool i40e_page_is_reusable(struct page *page)
+static inline bool i40e_page_is_reusable(const struct page *page)
 {
 =09return (page_to_nid(page) =3D=3D numa_mem_id()) &&
 =09=09!page_is_pfmemalloc(page);
diff --git a/drivers/net/ethernet/intel/iavf/iavf_txrx.c b/drivers/net/ethe=
rnet/intel/iavf/iavf_txrx.c
index 256fa07d54d5..d9ba8433c911 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_txrx.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
@@ -1148,7 +1148,7 @@ static void iavf_reuse_rx_page(struct iavf_ring *rx_r=
ing,
  * A page is not reusable if it was allocated under low memory
  * conditions, or it's not in the same NUMA node as this CPU.
  */
-static inline bool iavf_page_is_reusable(struct page *page)
+static inline bool iavf_page_is_reusable(const struct page *page)
 {
 =09return (page_to_nid(page) =3D=3D numa_mem_id()) &&
 =09=09!page_is_pfmemalloc(page);
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethern=
et/intel/ice/ice_txrx.c
index 422f53997c02..ecbf94cb11ea 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -732,7 +732,7 @@ bool ice_alloc_rx_bufs(struct ice_ring *rx_ring, u16 cl=
eaned_count)
  * ice_page_is_reserved - check if reuse is possible
  * @page: page struct to check
  */
-static bool ice_page_is_reserved(struct page *page)
+static bool ice_page_is_reserved(const struct page *page)
 {
 =09return (page_to_nid(page) !=3D numa_mem_id()) || page_is_pfmemalloc(pag=
e);
 }
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethern=
et/intel/igb/igb_main.c
index 84d4284b8b32..5e1aa7d04bf7 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -8215,7 +8215,7 @@ static void igb_reuse_rx_page(struct igb_ring *rx_rin=
g,
 =09new_buff->pagecnt_bias=09=3D old_buff->pagecnt_bias;
 }
=20
-static inline bool igb_page_is_reserved(struct page *page)
+static inline bool igb_page_is_reserved(const struct page *page)
 {
 =09return (page_to_nid(page) !=3D numa_mem_id()) || page_is_pfmemalloc(pag=
e);
 }
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethern=
et/intel/igc/igc_main.c
index 43aec42e6d9d..2939a3a4fa00 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -1648,7 +1648,7 @@ static void igc_reuse_rx_page(struct igc_ring *rx_rin=
g,
 =09new_buff->pagecnt_bias=09=3D old_buff->pagecnt_bias;
 }
=20
-static inline bool igc_page_is_reserved(struct page *page)
+static inline bool igc_page_is_reserved(const struct page *page)
 {
 =09return (page_to_nid(page) !=3D numa_mem_id()) || page_is_pfmemalloc(pag=
e);
 }
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/et=
hernet/intel/ixgbe/ixgbe_main.c
index e08c01525fd2..e2cd995512b1 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -1940,7 +1940,7 @@ static void ixgbe_reuse_rx_page(struct ixgbe_ring *rx=
_ring,
 =09new_buff->pagecnt_bias=09=3D old_buff->pagecnt_bias;
 }
=20
-static inline bool ixgbe_page_is_reserved(struct page *page)
+static inline bool ixgbe_page_is_reserved(const struct page *page)
 {
 =09return (page_to_nid(page) !=3D numa_mem_id()) || page_is_pfmemalloc(pag=
e);
 }
diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/ne=
t/ethernet/intel/ixgbevf/ixgbevf_main.c
index a14e55e7fce8..b4fb6bee1bb0 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -781,7 +781,7 @@ static void ixgbevf_reuse_rx_page(struct ixgbevf_ring *=
rx_ring,
 =09new_buff->pagecnt_bias =3D old_buff->pagecnt_bias;
 }
=20
-static inline bool ixgbevf_page_is_reserved(struct page *page)
+static inline bool ixgbevf_page_is_reserved(const struct page *page)
 {
 =09return (page_to_nid(page) !=3D numa_mem_id()) || page_is_pfmemalloc(pag=
e);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_rx.c
index dec93d57542f..9fff677026b7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -212,7 +212,7 @@ static inline u32 mlx5e_decompress_cqes_start(struct ml=
x5e_rq *rq,
 =09return mlx5e_decompress_cqes_cont(rq, wq, 1, budget_rem) - 1;
 }
=20
-static inline bool mlx5e_page_is_reserved(struct page *page)
+static inline bool mlx5e_page_is_reserved(const struct page *page)
 {
 =09return page_is_pfmemalloc(page) || page_to_nid(page) !=3D numa_mem_id()=
;
 }
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 9313b5aaf45b..b027526da4f9 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2943,8 +2943,8 @@ static inline struct page *dev_alloc_page(void)
  *=09@page: The page that was allocated from skb_alloc_page
  *=09@skb: The skb that may need pfmemalloc set
  */
-static inline void skb_propagate_pfmemalloc(struct page *page,
-=09=09=09=09=09     struct sk_buff *skb)
+static inline void skb_propagate_pfmemalloc(const struct page *page,
+=09=09=09=09=09    struct sk_buff *skb)
 {
 =09if (page_is_pfmemalloc(page))
 =09=09skb->pfmemalloc =3D true;
--=20
2.30.0


