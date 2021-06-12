Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A2E33A50C6
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 23:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231417AbhFLVLf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Jun 2021 17:11:35 -0400
Received: from mout.gmx.net ([212.227.15.19]:57675 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229777AbhFLVLe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Jun 2021 17:11:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1623532166;
        bh=beQBwqMpQA6B9ivaGgIzPpPIRq4yawuZkejHQIKAC8U=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=cFzqj1VARk5J4nClH81fI3EfbiYsy10zRNTuOAs7KOPcQ46fWAOUxnlf3cKkdoN8b
         bbgvmrvc5Ck3sTlwBOkhe7Nu6MSYaDhwPMNWpCYPqktg2v63Uk2vv53X7VsVxZibET
         LeGrLknqM/704AG2lnpPgUQdZUf0brDtkTeov7Zw=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [94.134.180.149] ([94.134.180.149]) by web-mail.gmx.net
 (3c-app-gmx-bs52.server.lan [172.19.170.105]) (via HTTP); Sat, 12 Jun 2021
 23:09:26 +0200
MIME-Version: 1.0
Message-ID: <trinity-7c1b2e82-e34f-4885-8060-2cd7a13769ce-1623532166177@3c-app-gmx-bs52>
From:   Norbert Slusarek <nslusarek@gmx.net>
To:     socketcan@hartkopp.net
Cc:     mkl@pengutronix.de, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] can: bcm: fix infoleak in struct bcm_msg_head
Content-Type: text/plain; charset=UTF-8
Date:   Sat, 12 Jun 2021 23:09:26 +0200
Importance: normal
Sensitivity: Normal
X-Priority: 3
X-Provags-ID: V03:K1:khf1SZseDGSCzVEyTjbukIC45rDMGYCLGPXdJt91XdrnnujuevRl/aifeSC5Do5Adnrhq
 rldgOuIAA/QnZgybbpcu70Oit3Hj6FBnho2KlIhnvpTzlJs+r92dlY23jIoIq70f4bnOgh+z5fcz
 rT5uog1Hd+onC0YGRfPJ2qYiDRN7Atxyvnj6SVGjsbno4CIuHE+X0TqxcfFc0cP/GRgIrMNWn96Q
 EnRPwgVluRGzBossm1MggMDiP/3h3REnw1RY1BZhBEnsmsBj4t/M3o3QaTA1EKcsAJPHLWD8HJg2
 TI=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Ha6xDhGW7kA=:ThQdfaYZ54eLhtt6Xuu8FY
 j3/HI5f8Ap96Lx4tNCxvQnV/Fv6WDWDs9hBqBmZkIht6L62gshpA/N8CuvUBUZEy4WhyZYq45
 j+U7XROY8nRHP39mj3cBLj7xaijTy8p5WpgmQJTHdnmg0u9JZOjDgAOHX2/Nn8HKxcZfy2kF7
 k5tTo2Gzon+y0NxIXVL1kkLteF9Ok+P+9SuB5OB6saqZqOjkjJMPZT5ZaauF6m8Lg6H5/hu5O
 J69j2yl1oRIecgb/Hl1yaiGcxOAViqxJgLhe+z8zy9fmgHsP6OAZM9cPFpT9XotpPj8A4a84D
 qZA8QSb7oYup9ydx5zRqHm/qQjZ6g3vqZPA1NO7SBP5FrWlokYk37ZpPI9BwyvlGSZpx393yb
 NhhkgojP6Ymkb9/GnzfM3ZDaKDe8jpqKN/jEXjCyAiFJmkqhJgjEWrln46voRtA8owDJ/eF2L
 9OFWBFqnxP+KvH7LsutbRGZ8zL+yUdpThO/kXc2li/UEShGhvFL7bIVZ9XzLH3PQa3QZ5nV71
 UicYAifkdDNCAe65SxJVvVGqmQEgYZkZyFoPApEak+HsjGNl9X6WBP7Xh1A5MK24LAr/N+ZCR
 OpT86OUTkPVqI9loI72mTmgF9UzjOZd3erxhgM7ffsZ5ZPIyuewwVKMIFvHBm+TFXVYUM3AeG
 IjrwSc4cmwIozen1XaB4eFhU8tIxZiA8YJZ3kb63kv+eo2nplLR9/bMUKsNeqpX0FaMFxQjaU
 ARApqURT0LLgC271muPXrhSdsbkxSxiVGC07idA0rY9zgYmrv6fsZ6FQkdCcCPwJ/UorhfM3Z
 jH6+UuF44VrTWoE2Bgo3hxJ0OYymA==
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Norbert Slusarek <nslusarek@gmx.net>
Date: Sat, 12 Jun 2021 22:18:54 +0200
Subject: [PATCH] can: bcm: fix infoleak in struct bcm_msg_head

On 64-bit systems, struct bcm_msg_head has an added padding of 4 bytes bet=
ween
struct members count and ival1. Even though all struct members are initial=
ized,
the 4-byte hole will contain data from the kernel stack. This patch zeroes=
 out
struct bcm_msg_head before usage, preventing infoleaks to userspace.

Fixes: ffd980f976e7 ("[CAN]: Add broadcast manager (bcm) protocol")
Signed-off-by: Norbert Slusarek <nslusarek@gmx.net>

=2D--
 net/can/bcm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/can/bcm.c b/net/can/bcm.c
index 909b9e684e04..b03062f84fe7 100644
=2D-- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -402,6 +402,7 @@ static enum hrtimer_restart bcm_tx_timeout_handler(str=
uct hrtimer *hrtimer)
                if (!op->count && (op->flags & TX_COUNTEVT)) {

                        /* create notification to user */
+                       memset(&msg_head, 0, sizeof(msg_head));
                        msg_head.opcode  =3D TX_EXPIRED;
                        msg_head.flags   =3D op->flags;
                        msg_head.count   =3D op->count;
@@ -439,6 +440,7 @@ static void bcm_rx_changed(struct bcm_op *op, struct c=
anfd_frame *data)
        /* this element is not throttled anymore */
        data->flags &=3D (BCM_CAN_FLAGS_MASK|RX_RECV);

+       memset(&head, 0, sizeof(head));
        head.opcode  =3D RX_CHANGED;
        head.flags   =3D op->flags;
        head.count   =3D op->count;
@@ -560,6 +562,7 @@ static enum hrtimer_restart bcm_rx_timeout_handler(str=
uct hrtimer *hrtimer)
        }

        /* create notification to user */
+       memset(&msg_head, 0, sizeof(msg_head));
        msg_head.opcode  =3D RX_TIMEOUT;
        msg_head.flags   =3D op->flags;
        msg_head.count   =3D op->count;
=2D-
2.30.2
