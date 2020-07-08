Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75E69219158
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 22:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbgGHUTh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 16:19:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:36152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726122AbgGHUTh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 16:19:37 -0400
Received: from embeddedor (unknown [201.162.240.161])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D902620672;
        Wed,  8 Jul 2020 20:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594239576;
        bh=S84KvemR4M6dpgIi8v4v9eUz3FpWojXbsMcXjZdI0HE=;
        h=Date:From:To:Cc:Subject:From;
        b=weUr/blubCR5NpqUVcA2gNZD7HfiGJu4ukvmAQrs8BO7LOjwgQRhyYwztWJWORaxs
         SOZspislB67pt+1oKgI+XZ9Agd2Gus49p6dxI+EzcZXPITwrwU3GNAQuuTz5K5HSTR
         6OVMfB+MhqXDHa11OPQRt3zeYxH3ocGNZmkIRbqE=
Date:   Wed, 8 Jul 2020 15:25:05 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH] Bluetooth: RFCOMM: Use fallthrough pseudo-keyword
Message-ID: <20200708202505.GA1733@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace the existing /* fall through */ comments and its variants with
the new pseudo-keyword macro fallthrough[1].

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html?highlight=fallthrough#implicit-switch-case-fall-through

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 net/bluetooth/rfcomm/core.c | 2 +-
 net/bluetooth/rfcomm/sock.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/rfcomm/core.c b/net/bluetooth/rfcomm/core.c
index 2e20af317cea..f2bacb464ccf 100644
--- a/net/bluetooth/rfcomm/core.c
+++ b/net/bluetooth/rfcomm/core.c
@@ -479,7 +479,7 @@ static int __rfcomm_dlc_close(struct rfcomm_dlc *d, int err)
 		/* if closing a dlc in a session that hasn't been started,
 		 * just close and unlink the dlc
 		 */
-		/* fall through */
+		fallthrough;
 
 	default:
 		rfcomm_dlc_clear_timer(d);
diff --git a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
index df14eebe80da..0afc4bc5ab41 100644
--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -218,7 +218,7 @@ static void __rfcomm_sock_close(struct sock *sk)
 	case BT_CONFIG:
 	case BT_CONNECTED:
 		rfcomm_dlc_close(d, 0);
-		/* fall through */
+		fallthrough;
 
 	default:
 		sock_set_flag(sk, SOCK_ZAPPED);
-- 
2.27.0

