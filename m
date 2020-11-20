Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AFCB2BA202
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 06:44:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbgKTFl3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 00:41:29 -0500
Received: from mxout70.expurgate.net ([91.198.224.70]:36081 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726381AbgKTFl2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 00:41:28 -0500
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1kfzAi-000S6Y-M4; Fri, 20 Nov 2020 06:41:24 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1kfzAi-000JUM-1i; Fri, 20 Nov 2020 06:41:24 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id C3AC1240041;
        Fri, 20 Nov 2020 06:41:23 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id 4648C240040;
        Fri, 20 Nov 2020 06:41:23 +0100 (CET)
Received: from mschiller01.dev.tdt.de (unknown [10.2.3.20])
        by mail.dev.tdt.de (Postfix) with ESMTPSA id A4F4B20D9C;
        Fri, 20 Nov 2020 06:41:22 +0100 (CET)
From:   Martin Schiller <ms@dev.tdt.de>
To:     andrew.hendry@gmail.com, davem@davemloft.net, kuba@kernel.org,
        xie.he.0141@gmail.com
Cc:     linux-x25@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Martin Schiller <ms@dev.tdt.de>
Subject: [PATCH net-next v4 5/5] net/x25: remove x25_kill_by_device()
Date:   Fri, 20 Nov 2020 06:40:36 +0100
Message-ID: <20201120054036.15199-6-ms@dev.tdt.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201120054036.15199-1-ms@dev.tdt.de>
References: <20201120054036.15199-1-ms@dev.tdt.de>
MIME-Version: 1.0
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
Content-Transfer-Encoding: quoted-printable
X-purgate-type: clean
X-purgate-ID: 151534::1605850884-00008E89-CD28E413/0/0
X-purgate: clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove obsolete function x25_kill_by_device(). It's not used any more.

Signed-off-by: Martin Schiller <ms@dev.tdt.de>
---
 net/x25/af_x25.c | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index 313a6222ded9..1432a05805ab 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -199,22 +199,6 @@ static void x25_remove_socket(struct sock *sk)
 	write_unlock_bh(&x25_list_lock);
 }
=20
-/*
- *	Kill all bound sockets on a dropped device.
- */
-static void x25_kill_by_device(struct net_device *dev)
-{
-	struct sock *s;
-
-	write_lock_bh(&x25_list_lock);
-
-	sk_for_each(s, &x25_list)
-		if (x25_sk(s)->neighbour && x25_sk(s)->neighbour->dev =3D=3D dev)
-			x25_disconnect(s, ENETUNREACH, 0, 0);
-
-	write_unlock_bh(&x25_list_lock);
-}
-
 /*
  *	Handle device status changes.
  */
--=20
2.20.1

