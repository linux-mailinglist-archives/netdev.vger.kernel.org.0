Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 004BF925CB
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 16:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbfHSODR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 10:03:17 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:46886 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbfHSODQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 10:03:16 -0400
Received: by mail-pg1-f195.google.com with SMTP id m3so1272910pgv.13;
        Mon, 19 Aug 2019 07:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=Cc9MGjd/L/OVthrhqFEJDBKIaMz1N2Sx82Or9j2R06Q=;
        b=XWLbrZxlS/izP75jIzILAB0SchVN24GaZGtsNd+43V8V+m2LunxrCQMA1bVi7lJ/OI
         fwlwSY4byhf/DXL9LBvo6lsRewKjFBxi+xR5/Z0Ba6n/Sq5uUDbFN6cavQ9dqOJT8M/3
         MKRGy6KZZW5+wZj2gnkxuA7D+kkTR0914ejUy35rUFY3hHo7legIFNX63k8zgp72SaCs
         PDNChdcSUzIZnyt3Hjgn9GfXZhcqCxNLcotSE7w9m2lr/woDqlfMFxnwGv4KJ/X2842g
         0TlOVKDzOA8N7zxbxs25S6C5oYGK88YMw2GU8AqYr7loD7nwgld1HQmpk8ebZRUYkATH
         m4iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=Cc9MGjd/L/OVthrhqFEJDBKIaMz1N2Sx82Or9j2R06Q=;
        b=n42KH/NN6PrFEAVc6Nv30cL/qGUSwGDVaBwczjEDfqrcwgpZgiJyYaxHlh7QQfh6Gx
         79upe8jKPssHmQgaXs57o22PLDJop8gD2IR9vmEu84PGqu3LZxP0i45vg3U6iXImGJxA
         a7GhDciqF2SwHpKa8NMg7m16byInISxy50CT0S+/fQ5us7WcvtZ57oxWxGJb1OTzk+fR
         g4cO1VbZHOdjHzWsuUZvRu6ii3P6/oh6MCNYHsqVTrN51w+vpMXvyvlCoj48y0jczMsT
         LuhSCkVUKo8N+SNIOh/Dj4TS+l3EKvIcUoOuSV2zVqlkkT1wo2qPqY42UyCY2tO7LJ2l
         PFRQ==
X-Gm-Message-State: APjAAAUkLjD6A0LhzHcl+ZRV0lDy4/uWRXWWkY6rDoDTf3/qT6etKdZw
        rMs+3AHyGhly2I87LqrTAK4apjB9G1I=
X-Google-Smtp-Source: APXvYqxLcClY+tIA+j3L7isHd3Ys8Mv7ufegTqkqQdhpPrHPuysCT3mzoZsAjosuUqvbFlUWRoRs0Q==
X-Received: by 2002:a17:90a:2047:: with SMTP id n65mr21392136pjc.5.1566223395633;
        Mon, 19 Aug 2019 07:03:15 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t4sm18721132pfd.109.2019.08.19.07.03.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Aug 2019 07:03:15 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net
Subject: [PATCH net-next 2/8] sctp: not set peer.asconf_capable in sctp_association_init
Date:   Mon, 19 Aug 2019 22:02:44 +0800
Message-Id: <04b2de14df6de243e9faacc3a3de091adff45d52.1566223325.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <4c4682aab70fc11be7a505b11939dd998b9b21f5.1566223325.git.lucien.xin@gmail.com>
References: <cover.1566223325.git.lucien.xin@gmail.com>
 <4c4682aab70fc11be7a505b11939dd998b9b21f5.1566223325.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1566223325.git.lucien.xin@gmail.com>
References: <cover.1566223325.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

asoc->peer.asconf_capable is to be set during handshake, and its
value should be initialized to 0. net->sctp.addip_noauth will be
checked in sctp_process_init when processing INIT_ACK on client
and COOKIE_ECHO on server.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/associola.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 5010cce..d2ffc9a 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -54,7 +54,6 @@ static struct sctp_association *sctp_association_init(
 					const struct sock *sk,
 					enum sctp_scope scope, gfp_t gfp)
 {
-	struct net *net = sock_net(sk);
 	struct sctp_sock *sp;
 	struct sctp_paramhdr *p;
 	int i;
@@ -214,14 +213,6 @@ static struct sctp_association *sctp_association_init(
 	asoc->peer.sack_needed = 1;
 	asoc->peer.sack_generation = 1;
 
-	/* Assume that the peer will tell us if he recognizes ASCONF
-	 * as part of INIT exchange.
-	 * The sctp_addip_noauth option is there for backward compatibility
-	 * and will revert old behavior.
-	 */
-	if (net->sctp.addip_noauth)
-		asoc->peer.asconf_capable = 1;
-
 	/* Create an input queue.  */
 	sctp_inq_init(&asoc->base.inqueue);
 	sctp_inq_set_th_handler(&asoc->base.inqueue, sctp_assoc_bh_rcv);
-- 
2.1.0

