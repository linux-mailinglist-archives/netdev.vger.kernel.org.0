Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8074210E53
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 17:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731737AbgGAPEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 11:04:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35060 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731039AbgGAPEi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 11:04:38 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1jqeHp-0008To-Kh; Wed, 01 Jul 2020 15:04:33 +0000
From:   Colin King <colin.king@canonical.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net/packet: remove redundant initialization of variable err
Date:   Wed,  1 Jul 2020 16:04:33 +0100
Message-Id: <20200701150433.551656-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable err is being initialized with a value that is never read
and it is being updated later with a new value.  The initialization is
redundant and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/packet/af_packet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 29bd405adbbd..7b436ebde61d 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -4293,7 +4293,7 @@ static int packet_set_ring(struct sock *sk, union tpacket_req_u *req_u,
 	struct packet_ring_buffer *rb;
 	struct sk_buff_head *rb_queue;
 	__be16 num;
-	int err = -EINVAL;
+	int err;
 	/* Added to avoid minimal code churn */
 	struct tpacket_req *req = &req_u->req;
 
-- 
2.27.0

