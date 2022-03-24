Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B88D14E5F47
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 08:24:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348446AbiCXHZc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 03:25:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234921AbiCXHZb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 03:25:31 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2592A986F4;
        Thu, 24 Mar 2022 00:24:00 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id yy13so7338836ejb.2;
        Thu, 24 Mar 2022 00:24:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dc7drlj1jlLFeJfvyn32+P0vajF46kNNWGeRvJGukV8=;
        b=HqQi5kmtgTilXXWLucEpN4C168K/zGBnfq0Ia+Rgs9zVKrODvzYOl4McnsYWU2RioK
         q7gUgMjWKlcsl/6KVAI7YR+3WLvi39VqJP5ZUCwTsAeqTm9FmC/RtI1V+t6RSIFBBDRu
         Us67zQeNvvxUc00D8sItkNi1o9JvMMKfKCLmuRiOCFyT1Pd94LDOvRi7Y3FQuOUq7UvM
         vUvDntywdfNQCMR+dSkzcY50iJ9azOqErgzXXqicWOakSQnqTu4HHZRSdxCLhhMjLZ7q
         Q6LaLA/X7NM8zkTURU0r9LTh/UXRi0Ab2/XvHfywdH0z56nLpeJo5BpKAGxOmGqzw2Y/
         tyeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dc7drlj1jlLFeJfvyn32+P0vajF46kNNWGeRvJGukV8=;
        b=l+g10yD0GkDjWvYrnu/YRSErMYjUEs8QYn2mxb4KoGirr4onW4ldD9p1j6gJdXImz0
         Irs/EQ52cKwahIs9AJppJj0VeBu1W5j3AZ76tBaT7XWyI7kK5tCfmQ2U0upCTw3Y98re
         yTCqKWhxfjokS/Njl9cCziZ5/qnInVdqVhyfrWFyo4IA+JfHQm90PVt2vhr7wBJhvRkb
         JF0+mQjg332EUhKKGaEB6hJvfg9OAsSZXh1VTU8oWQTH+W3gyPwv097WLFx2iwefkmkD
         6nwJAY3zVoiGevqTNOiZkJ+5rWmExulezwpcj7ZZKy4l06TfjuN/90DTg75Jbh9MkvAm
         BZGg==
X-Gm-Message-State: AOAM533khxq1yVG/gN/1quWhJRpQWPpwwBy9fZZSas9mqFzijnXWrIoP
        dE3c6KmMBUvQ0Vvn/3WbIos=
X-Google-Smtp-Source: ABdhPJx1loH3icZmz6GcC3SKyNlA2D1JMRQhRf9/aY9xYIKyGiG7CVa8VQ4h/BYZfQG7yTq5nnf40w==
X-Received: by 2002:a17:907:72c5:b0:6da:e99e:226c with SMTP id du5-20020a17090772c500b006dae99e226cmr4213687ejc.515.1648106638547;
        Thu, 24 Mar 2022 00:23:58 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id qk30-20020a1709077f9e00b006dfae33d969sm777539ejc.216.2022.03.24.00.23.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 00:23:58 -0700 (PDT)
From:   Jakob Koschel <jakobkoschel@gmail.com>
To:     Vlad Yasevich <vyasevich@gmail.com>
Cc:     Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mike Rapoport <rppt@kernel.org>,
        "Brian Johannesmeyer" <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>, Jakob Koschel <jakobkoschel@gmail.com>
Subject: [PATCH] sctp: replace usage of found with dedicated list iterator variable
Date:   Thu, 24 Mar 2022 08:22:57 +0100
Message-Id: <20220324072257.62674-1-jakobkoschel@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To move the list iterator variable into the list_for_each_entry_*()
macro in the future it should be avoided to use the list iterator
variable after the loop body.

To *never* use the list iterator variable after the loop it was
concluded to use a separate iterator variable instead of a
found boolean [1].

This removes the need to use a found variable and simply checking if
the variable was set, can determine if the break/goto was hit.

Link: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/
Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
---
 net/sctp/bind_addr.c | 15 +++++++--------
 net/sctp/ipv6.c      | 24 +++++++++++-------------
 net/sctp/protocol.c  | 24 +++++++++++-------------
 3 files changed, 29 insertions(+), 34 deletions(-)

diff --git a/net/sctp/bind_addr.c b/net/sctp/bind_addr.c
index 59e653b528b1..c85ade7863bf 100644
--- a/net/sctp/bind_addr.c
+++ b/net/sctp/bind_addr.c
@@ -172,23 +172,22 @@ int sctp_add_bind_addr(struct sctp_bind_addr *bp, union sctp_addr *new,
  */
 int sctp_del_bind_addr(struct sctp_bind_addr *bp, union sctp_addr *del_addr)
 {
-	struct sctp_sockaddr_entry *addr, *temp;
-	int found = 0;
+	struct sctp_sockaddr_entry *addr = NULL, *iter, *temp;
 
 	/* We hold the socket lock when calling this function,
 	 * and that acts as a writer synchronizing lock.
 	 */
-	list_for_each_entry_safe(addr, temp, &bp->address_list, list) {
-		if (sctp_cmp_addr_exact(&addr->a, del_addr)) {
+	list_for_each_entry_safe(iter, temp, &bp->address_list, list) {
+		if (sctp_cmp_addr_exact(&iter->a, del_addr)) {
 			/* Found the exact match. */
-			found = 1;
-			addr->valid = 0;
-			list_del_rcu(&addr->list);
+			addr = iter;
+			iter->valid = 0;
+			list_del_rcu(&iter->list);
 			break;
 		}
 	}
 
-	if (found) {
+	if (addr) {
 		kfree_rcu(addr, rcu);
 		SCTP_DBG_OBJCNT_DEC(addr);
 		return 0;
diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index 470dbdc27d58..803950277f56 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -76,10 +76,8 @@ static int sctp_inet6addr_event(struct notifier_block *this, unsigned long ev,
 				void *ptr)
 {
 	struct inet6_ifaddr *ifa = (struct inet6_ifaddr *)ptr;
-	struct sctp_sockaddr_entry *addr = NULL;
-	struct sctp_sockaddr_entry *temp;
+	struct sctp_sockaddr_entry *addr = NULL, *iter, *temp;
 	struct net *net = dev_net(ifa->idev->dev);
-	int found = 0;
 
 	switch (ev) {
 	case NETDEV_UP:
@@ -97,21 +95,21 @@ static int sctp_inet6addr_event(struct notifier_block *this, unsigned long ev,
 		break;
 	case NETDEV_DOWN:
 		spin_lock_bh(&net->sctp.local_addr_lock);
-		list_for_each_entry_safe(addr, temp,
-					&net->sctp.local_addr_list, list) {
-			if (addr->a.sa.sa_family == AF_INET6 &&
-			    ipv6_addr_equal(&addr->a.v6.sin6_addr,
+		list_for_each_entry_safe(iter, temp,
+					 &net->sctp.local_addr_list, list) {
+			if (iter->a.sa.sa_family == AF_INET6 &&
+			    ipv6_addr_equal(&iter->a.v6.sin6_addr,
 					    &ifa->addr) &&
-			    addr->a.v6.sin6_scope_id == ifa->idev->dev->ifindex) {
-				sctp_addr_wq_mgmt(net, addr, SCTP_ADDR_DEL);
-				found = 1;
-				addr->valid = 0;
-				list_del_rcu(&addr->list);
+			    iter->a.v6.sin6_scope_id == ifa->idev->dev->ifindex) {
+				sctp_addr_wq_mgmt(net, iter, SCTP_ADDR_DEL);
+				addr = iter;
+				iter->valid = 0;
+				list_del_rcu(&iter->list);
 				break;
 			}
 		}
 		spin_unlock_bh(&net->sctp.local_addr_lock);
-		if (found)
+		if (addr)
 			kfree_rcu(addr, rcu);
 		break;
 	}
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 35928fefae33..6f1d7fd83465 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -777,10 +777,8 @@ static int sctp_inetaddr_event(struct notifier_block *this, unsigned long ev,
 			       void *ptr)
 {
 	struct in_ifaddr *ifa = (struct in_ifaddr *)ptr;
-	struct sctp_sockaddr_entry *addr = NULL;
-	struct sctp_sockaddr_entry *temp;
+	struct sctp_sockaddr_entry *addr = NULL, *iter, *temp;
 	struct net *net = dev_net(ifa->ifa_dev->dev);
-	int found = 0;
 
 	switch (ev) {
 	case NETDEV_UP:
@@ -797,20 +795,20 @@ static int sctp_inetaddr_event(struct notifier_block *this, unsigned long ev,
 		break;
 	case NETDEV_DOWN:
 		spin_lock_bh(&net->sctp.local_addr_lock);
-		list_for_each_entry_safe(addr, temp,
-					&net->sctp.local_addr_list, list) {
-			if (addr->a.sa.sa_family == AF_INET &&
-					addr->a.v4.sin_addr.s_addr ==
-					ifa->ifa_local) {
-				sctp_addr_wq_mgmt(net, addr, SCTP_ADDR_DEL);
-				found = 1;
-				addr->valid = 0;
-				list_del_rcu(&addr->list);
+		list_for_each_entry_safe(iter, temp,
+					 &net->sctp.local_addr_list, list) {
+			if (iter->a.sa.sa_family == AF_INET &&
+			    iter->a.v4.sin_addr.s_addr ==
+			    ifa->ifa_local) {
+				sctp_addr_wq_mgmt(net, iter, SCTP_ADDR_DEL);
+				addr = iter;
+				iter->valid = 0;
+				list_del_rcu(&iter->list);
 				break;
 			}
 		}
 		spin_unlock_bh(&net->sctp.local_addr_lock);
-		if (found)
+		if (addr)
 			kfree_rcu(addr, rcu);
 		break;
 	}

base-commit: f443e374ae131c168a065ea1748feac6b2e76613
-- 
2.25.1

