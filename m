Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8CC2F68C7
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 19:07:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729137AbhANSCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 13:02:44 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:57104 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729674AbhANSCn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 13:02:43 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from tariqt@nvidia.com)
        with SMTP; 14 Jan 2021 20:01:52 +0200
Received: from dev-l-vrt-206-005.mtl.labs.mlnx (dev-l-vrt-206-005.mtl.labs.mlnx [10.234.206.5])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 10EI1pYO001704;
        Thu, 14 Jan 2021 20:01:52 +0200
From:   Tariq Toukan <tariqt@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Boris Pismenny <borisp@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jarod Wilson <jarod@redhat.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next V2 6/8] net/bonding: Declare TLS RX device offload support
Date:   Thu, 14 Jan 2021 20:01:33 +0200
Message-Id: <20210114180135.11556-7-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210114180135.11556-1-tariqt@nvidia.com>
References: <20210114180135.11556-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following the description in previous patch (for TX):
As the bond interface is being bypassed by the TLS module, interacting
directly against the slaves, there is no way for the bond interface to
disable its device offload capabilities, as long as the mode/policy
config allows it.
Hence, the feature flag is not directly controllable, but just reflects
the offload status based on the logic under bond_sk_check().

Here we just declare RX device offload support, and expose it via the
NETIF_F_HW_TLS_RX flag.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Boris Pismenny <borisp@nvidia.com>
---
 include/net/bonding.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/bonding.h b/include/net/bonding.h
index 97fbec02df2d..019e998d944a 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -89,7 +89,7 @@
 #define BOND_XFRM_FEATURES (NETIF_F_HW_ESP | NETIF_F_HW_ESP_TX_CSUM | \
 			    NETIF_F_GSO_ESP)
 
-#define BOND_TLS_FEATURES (NETIF_F_HW_TLS_TX)
+#define BOND_TLS_FEATURES (NETIF_F_HW_TLS_TX | NETIF_F_HW_TLS_RX)
 
 #ifdef CONFIG_NET_POLL_CONTROLLER
 extern atomic_t netpoll_block_tx;
-- 
2.21.0

