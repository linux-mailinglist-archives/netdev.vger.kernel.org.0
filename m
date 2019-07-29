Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 363B178E8E
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 16:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728687AbfG2O7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 10:59:53 -0400
Received: from gateway23.websitewelcome.com ([192.185.50.161]:35397 "EHLO
        gateway23.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727034AbfG2O7v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 10:59:51 -0400
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
        by gateway23.websitewelcome.com (Postfix) with ESMTP id E16BCC1ED
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 09:59:49 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id s77thaZT94FKps77thkQi3; Mon, 29 Jul 2019 09:59:49 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=XmpL5my71AoWQs+D7f6gDo6C6zjPh/VxE9FhrUoDW+k=; b=YPfJRKWVkoa9XYZRrUKQgiiCxX
        J3prPSSfYQzABPIC6B6QcsrlM04EbFP+jAIIgkFw48U8jXrGiVI/52jKJv4Rp7+S/CC6Kx7T0Vsf6
        yV5M6bQElyRVSa4WNwiERV336bJ5QVJOhU0MhMb+RCdmimiMLItg/GWW8fKhpRxhW8ts864U67Ku2
        NCx3UDswU5OOgTXNgVMogNu7tyfQzjUdEfH0sg9SbiNm0+pXFFpRwSfAxVkSZRvFHLgSbEqfr+sBP
        DAmAgaKjwOMv2HGC09OJ8p7lAq/XReMmZ3y80wkjHNREuqYAFY/4jU5uf1dQhPRju2BalFtFNkC7H
        KXfx+Qpw==;
Received: from [187.192.11.120] (port=51566 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1hs77s-002aSP-HK; Mon, 29 Jul 2019 09:59:48 -0500
Date:   Mon, 29 Jul 2019 09:59:47 -0500
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Julian Wiedmann <jwi@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH] net/af_iucv: mark expected switch fall-throughs
Message-ID: <20190729145947.GA9494@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.192.11.120
X-Source-L: No
X-Exim-ID: 1hs77s-002aSP-HK
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [187.192.11.120]:51566
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 30
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mark switch cases where we are expecting to fall through.

This patch fixes the following warnings:

net/iucv/af_iucv.c: warning: this statement may fall
through [-Wimplicit-fallthrough=]:  => 537:3, 519:6, 2246:6, 510:6

Notice that, in this particular case, the code comment is
modified in accordance with what GCC is expecting to find.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 net/iucv/af_iucv.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/net/iucv/af_iucv.c b/net/iucv/af_iucv.c
index 09e1694b6d34..ebb62a4ebe30 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -512,7 +512,9 @@ static void iucv_sock_close(struct sock *sk)
 			sk->sk_state = IUCV_DISCONN;
 			sk->sk_state_change(sk);
 		}
-	case IUCV_DISCONN:   /* fall through */
+		/* fall through */
+
+	case IUCV_DISCONN:
 		sk->sk_state = IUCV_CLOSING;
 		sk->sk_state_change(sk);
 
@@ -525,8 +527,9 @@ static void iucv_sock_close(struct sock *sk)
 					iucv_sock_in_state(sk, IUCV_CLOSED, 0),
 					timeo);
 		}
+		/* fall through */
 
-	case IUCV_CLOSING:   /* fall through */
+	case IUCV_CLOSING:
 		sk->sk_state = IUCV_CLOSED;
 		sk->sk_state_change(sk);
 
@@ -535,8 +538,9 @@ static void iucv_sock_close(struct sock *sk)
 
 		skb_queue_purge(&iucv->send_skb_q);
 		skb_queue_purge(&iucv->backlog_skb_q);
+		/* fall through */
 
-	default:   /* fall through */
+	default:
 		iucv_sever_path(sk, 1);
 	}
 
@@ -2247,10 +2251,10 @@ static int afiucv_hs_rcv(struct sk_buff *skb, struct net_device *dev,
 			kfree_skb(skb);
 			break;
 		}
-		/* fall through and receive non-zero length data */
+		/* fall through - and receive non-zero length data */
 	case (AF_IUCV_FLAG_SHT):
 		/* shutdown request */
-		/* fall through and receive zero length data */
+		/* fall through - and receive zero length data */
 	case 0:
 		/* plain data frame */
 		IUCV_SKB_CB(skb)->class = trans_hdr->iucv_hdr.class;
-- 
2.22.0

