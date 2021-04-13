Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3862235D5BB
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 05:15:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344340AbhDMDPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 23:15:53 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:47384 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236976AbhDMDPo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 23:15:44 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0UVPME4D_1618283723;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0UVPME4D_1618283723)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 13 Apr 2021 11:15:24 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org,
        "dust . li" <dust.li@linux.alibaba.com>
Subject: [PATCH net-next v4 02/10] netdevice: add priv_flags IFF_NOT_USE_DMA_ADDR
Date:   Tue, 13 Apr 2021 11:15:15 +0800
Message-Id: <20210413031523.73507-3-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210413031523.73507-1-xuanzhuo@linux.alibaba.com>
References: <20210413031523.73507-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some driver devices, such as virtio-net, do not directly use dma addr.
For upper-level frameworks such as xdp socket, that need to be aware of
this. So add a new priv_flag IFF_NOT_USE_DMA_ADDR.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 include/linux/netdevice.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 86e4bd08c2f1..78b2a8b2c31d 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1598,6 +1598,7 @@ typedef u64 netdev_priv_flags_t;
  * @IFF_LIVE_RENAME_OK: rename is allowed while device is up and running
  * @IFF_TX_SKB_NO_LINEAR: device/driver is capable of xmitting frames with
  *	skb_headlen(skb) == 0 (data starts from frag0)
+ * @IFF_NOT_USE_DMA_ADDR: driver not use dma addr directly. such as virtio-net
  */
 enum netdev_priv_flags {
 	IFF_802_1Q_VLAN_BIT,
@@ -1632,6 +1633,7 @@ enum netdev_priv_flags {
 	IFF_L3MDEV_RX_HANDLER_BIT,
 	IFF_LIVE_RENAME_OK_BIT,
 	IFF_TX_SKB_NO_LINEAR_BIT,
+	IFF_NOT_USE_DMA_ADDR_BIT,
 };
 
 #define __IFF_BIT(bit)		((netdev_priv_flags_t)1 << (bit))
@@ -1669,6 +1671,7 @@ enum netdev_priv_flags {
 #define IFF_L3MDEV_RX_HANDLER		__IFF(L3MDEV_RX_HANDLER)
 #define IFF_LIVE_RENAME_OK		__IFF(LIVE_RENAME_OK)
 #define IFF_TX_SKB_NO_LINEAR		__IFF(TX_SKB_NO_LINEAR)
+#define IFF_NOT_USE_DMA_ADDR		__IFF(NOT_USE_DMA_ADDR)
 
 /* Specifies the type of the struct net_device::ml_priv pointer */
 enum netdev_ml_priv_type {
-- 
2.31.0

