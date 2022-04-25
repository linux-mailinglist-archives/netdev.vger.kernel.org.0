Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C9A050D6FA
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 04:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240374AbiDYCih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 22:38:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240370AbiDYCid (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 22:38:33 -0400
Received: from bee.birch.relay.mailchannels.net (bee.birch.relay.mailchannels.net [23.83.209.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBA7B38B6;
        Sun, 24 Apr 2022 19:35:23 -0700 (PDT)
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 6C54F8E19FC;
        Mon, 25 Apr 2022 02:35:23 +0000 (UTC)
Received: from pdx1-sub0-mail-a217.dreamhost.com (unknown [127.0.0.6])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 8F28D8E19E9;
        Mon, 25 Apr 2022 02:35:22 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1650854123; a=rsa-sha256;
        cv=none;
        b=Bn3GCg5qIxFPAN0ipEYfxjwToCGQDZ+0oEim8U4qG7/ftzxtluFky0c6nL5nTmvK6zga/H
        yjHdAlwO5gGb7cXrlHsenbNVOwRG6I5KAkVlykYDlipDgidevYuttpKWYkaLq5X1yBxzPW
        G8nF9eyVZyBxItl18UajlxiGLKLsGB49BnGVAEK0HBWpZ3j14YnGBkJPYvLsrzzfyOzab/
        nId6N1g++hQOPnE0TgFnyZ27bIBuH4oXLUbDq8fEHLFisfWNqlGW/K4keRZlCyJ7b7dEcb
        Vm360xPYZGbNiEOK2rMN/LkbJvj3CBnJyuMWbxnEYO56Shw4wfxv1GMotAXpIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
        s=arc-2022; t=1650854123;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:dkim-signature;
        bh=7zItbbh/pambe0Jl/RcuQk654dqnszM7BO9yP/9Zzo8=;
        b=Z3rPjluSQ7kWyhoj9sloYvuJIrDkZ1fqVz8R+pQseNT8QOP47ghnbZkfIrZMJrIEYcrKlw
        QInwqSMYCgqhQpOqtevHZyh9/5bSsY8PJWl+IVBIIR0vM8DOK4zYtZ12KexEwyee4D1lif
        hVUDnOPbwOOGDrBAb26tm4KjB0FimOC7tBXwkFpDoNyDPvIANwz9TS7w2HIGqx33iTcEy4
        QeSmoMiIKelX46W8ekcRsy+hkREZgKWyGE5xrpraZ6E42g4LxPI89g8e9ZorhdLjQIJdr6
        uSq9rkV0YhgMizTb0KNqzbhoAMu8qW47KKgUotdNSyLzEXkEz5UTaWTUeIRKwg==
ARC-Authentication-Results: i=1;
        rspamd-6dfbdcb948-z5c67;
        auth=pass smtp.auth=dreamhost smtp.mailfrom=ian@linux.cowan.aero
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|ian@linux.cowan.aero
X-MailChannels-Auth-Id: dreamhost
X-Well-Made-Whispering: 02e4ef101dcd17bf_1650854123287_99724531
X-MC-Loop-Signature: 1650854123286:1623070866
X-MC-Ingress-Time: 1650854123286
Received: from pdx1-sub0-mail-a217.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
        by 100.127.95.118 (trex/6.7.1);
        Mon, 25 Apr 2022 02:35:23 +0000
Received: from localhost.localdomain (unknown [69.12.38.97])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: ian@linux.cowan.aero)
        by pdx1-sub0-mail-a217.dreamhost.com (Postfix) with ESMTPSA id 4Kmpyd5V8vz1K1;
        Sun, 24 Apr 2022 19:35:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.cowan.aero;
        s=dreamhost; t=1650854122;
        bh=7zItbbh/pambe0Jl/RcuQk654dqnszM7BO9yP/9Zzo8=;
        h=From:To:Cc:Subject:Date:Content-Transfer-Encoding;
        b=uxU6x2jU9IwI1OtbgTRyZ5qg0o11mcQBdJMUpNLjojl2nkDkJ/9+c1yTIcFuAjzX1
         4Y+Unqi4fkNYCb4P9C9m69r+BWyQF4gGDBDsCusZncgD7z7/DlbIRkY+PAQfv9/ozQ
         88qKHtS0RayWHyJ7SWovFRKVy6fUP9g+NaKPsqs//GIEWgUylV/o9bxwSi1/MjN+gT
         SCH/bovOAZQbwiNfkG4l3m8tpHIsfl9yksOOXYH0ICv2zAX52XuHr3JEBe0+CsH/Bt
         RZt92zht7LX/UiYz5jDQ4LSoerYvdvGgkUFmR3ZdnzIFLHGTOS4ZE+N3XMjzXQnmJu
         8yqctGdkmSzTA==
From:   Ian Cowan <ian@linux.cowan.aero>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ian Cowan <ian@linux.cowan.aero>
Subject: [PATCH] net: appletalk: cleanup brace styling
Date:   Sun, 24 Apr 2022 22:35:12 -0400
Message-Id: <20220425023512.502988-1-ian@linux.cowan.aero>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This cleans up some brace styling to meet the style guide. There is one
exception where the compiler wants unnecessary braces to prevent
multiple if/else ambiguity.

Signed-off-by: Ian Cowan <ian@linux.cowan.aero>
---
 net/appletalk/ddp.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/net/appletalk/ddp.c b/net/appletalk/ddp.c
index bf5736c1d458..2709d9621b25 100644
--- a/net/appletalk/ddp.c
+++ b/net/appletalk/ddp.c
@@ -161,8 +161,9 @@ static void atalk_destroy_timer(struct timer_list *t)
 	if (sk_has_allocations(sk)) {
 		sk->sk_timer.expires = jiffies + SOCK_DESTROY_TIME;
 		add_timer(&sk->sk_timer);
-	} else
+	} else {
 		sock_put(sk);
+	}
 }
 
 static inline void atalk_destroy_socket(struct sock *sk)
@@ -174,8 +175,9 @@ static inline void atalk_destroy_socket(struct sock *sk)
 		timer_setup(&sk->sk_timer, atalk_destroy_timer, 0);
 		sk->sk_timer.expires	= jiffies + SOCK_DESTROY_TIME;
 		add_timer(&sk->sk_timer);
-	} else
+	} else {
 		sock_put(sk);
+	}
 }
 
 /**************************************************************************\
@@ -211,8 +213,9 @@ static void atif_drop_device(struct net_device *dev)
 			dev_put(dev);
 			kfree(tmp);
 			dev->atalk_ptr = NULL;
-		} else
+		} else {
 			iface = &tmp->next;
+		}
 	}
 	write_unlock_bh(&atalk_interfaces_lock);
 }
@@ -444,12 +447,13 @@ static struct atalk_route *atrtr_find(struct atalk_addr *target)
 				 */
 				if (r->target.s_node == target->s_node)
 					goto out;
-			} else
+			} else {
 				/*
 				 * this route will work if there isn't a
 				 * direct host route, so cache it
 				 */
 				net_route = r;
+			}
 		}
 	}
 
@@ -615,8 +619,9 @@ static void atrtr_device_down(struct net_device *dev)
 			*r = tmp->next;
 			dev_put(dev);
 			kfree(tmp);
-		} else
+		} else {
 			r = &tmp->next;
+		}
 	}
 	write_unlock_bh(&atalk_routes_lock);
 
@@ -1386,8 +1391,9 @@ static int atalk_route_packet(struct sk_buff *skb, struct net_device *dev,
 		struct sk_buff *nskb = skb_realloc_headroom(skb, 32);
 		kfree_skb(skb);
 		skb = nskb;
-	} else
+	} else {
 		skb = skb_unshare(skb, GFP_ATOMIC);
+	}
 
 	/*
 	 * If the buffer didn't vanish into the lack of space bitbucket we can
-- 
2.35.1

