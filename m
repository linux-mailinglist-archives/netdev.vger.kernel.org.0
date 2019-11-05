Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48A7CEFCFF
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 13:14:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730894AbfKEMOM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 07:14:12 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:49211 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730869AbfKEMOM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 07:14:12 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 5 Nov 2019 14:14:05 +0200
Received: from dev-l-vrt-206-005.mtl.labs.mlnx (dev-l-vrt-206-005.mtl.labs.mlnx [10.134.206.5])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id xA5CE4Sn009080;
        Tue, 5 Nov 2019 14:14:04 +0200
From:   Tariq Toukan <tariqt@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH net V2] Documentation: TLS: Add missing counter description
Date:   Tue,  5 Nov 2019 14:13:48 +0200
Message-Id: <20191105121348.12956-1-tariqt@mellanox.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add TLS TX counter description for the handshake retransmitted
packets that triggers the resync procedure then skip it, going
into the regular transmit flow.

Fixes: 46a3ea98074e ("net/mlx5e: kTLS, Enhance TX resync flow")
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 Documentation/networking/tls-offload.rst | 4 ++++
 1 file changed, 4 insertions(+)

v1 -> v2: Fixed counter description, per Jakub's comment.

diff --git a/Documentation/networking/tls-offload.rst b/Documentation/networking/tls-offload.rst
index 0dd3f748239f..f914e81fd3a6 100644
--- a/Documentation/networking/tls-offload.rst
+++ b/Documentation/networking/tls-offload.rst
@@ -436,6 +436,10 @@ by the driver:
    encryption.
  * ``tx_tls_ooo`` - number of TX packets which were part of a TLS stream
    but did not arrive in the expected order.
+ * ``tx_tls_skip_no_sync_data`` - number of TX packets which were part of
+   a TLS stream and arrived out-of-order, but skipped the HW offload routine
+   and went to the regular transmit flow as they were retransmissions of the
+   connection handshake.
  * ``tx_tls_drop_no_sync_data`` - number of TX packets which were part of
    a TLS stream dropped, because they arrived out of order and associated
    record could not be found.
-- 
2.21.0

