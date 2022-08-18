Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6A33598D59
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 22:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345735AbiHRUFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 16:05:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244401AbiHRUD1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 16:03:27 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB702D1E3F;
        Thu, 18 Aug 2022 13:01:01 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id j8so5170280ejx.9;
        Thu, 18 Aug 2022 13:01:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=uiS6ly542BXQE8sS6sZ3F6nSNqIfByC0pjYHdwH7KMk=;
        b=L8tH1Z9bTv4I1/eucDUMcF1PJbw7KbcNWzKSgM4sMy0sstkB2srnaBIvAjJhHfGZ9H
         xs++V5B7dxK8f0iTrvoUoaw8ZSJ8CyxTOxKgV5IZDqZiAXp+79uEg7yWX3Ml86CSssHF
         NyXlZE35FxAWQO3ZZ4FKw9gP0nNAEQhz3JKhl2XYPrr6GtF6vzrI2Zj+Ic7IRsKgIuar
         p7wqxaqxUpoxn7dca5rp4aHFsUF46lSehzNj+pVvT/SOWUBfL79MmR0C1lKV2P2oA+I2
         D/c6aWMtzSE87DLUarXd6mgKh5QcT6Lw0H9ucfvXKIb94LUXR5D+qDsdJ51/vySYIwGM
         N6sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=uiS6ly542BXQE8sS6sZ3F6nSNqIfByC0pjYHdwH7KMk=;
        b=OU5FouNShP83UxLe0+keMN4TIFYrA9MJPFeusQuik9CwoxZbfgoP7F8VAnotGNsNAa
         myI4ytrGAzBW8ATFCMpYpjaKH/f8t/hXoUhyr9tFHIwdvbpnkXuTqtWqnaajmElBK0mE
         4lO9MvksVYpEWxCYmuebxUqD8yhgFU4VF/+aq/91r2gU98jERgMW9LV+3OacCAoGIr+/
         f3n+Bdufa63Ys41zWB8yNF8FhHxXVmFKxdTshzCrz84r0O8I8iIVdigtjbdnD6T6QdMg
         w6IkxkCTPQ08l/ftx0a2mMM7uh6kuEYUxVqFoFklHL7mne4pJYQrHhx8SOKj8JT+qDLt
         Bkow==
X-Gm-Message-State: ACgBeo0PQbk3ObZYU86RA9cAHNmzsIFWhQ0hpMeEadEOjHIxWWENwNSG
        R3xTM8CQ5Z3gYXEO97SZSoM=
X-Google-Smtp-Source: AA6agR4Gk2EDC0MGdlToI9/qM3eszNqigN1ZPh5JelOKJ81FP5JV1XGI+8XUSC8zpdlZHmS6K/QZzg==
X-Received: by 2002:a17:907:a40f:b0:730:c4ce:631c with SMTP id sg15-20020a170907a40f00b00730c4ce631cmr2745478ejc.362.1660852859708;
        Thu, 18 Aug 2022 13:00:59 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:a080:17c8:ba1c:b6f3:3fe0])
        by smtp.gmail.com with ESMTPSA id fw30-20020a170907501e00b00722e4bab163sm1215087ejc.200.2022.08.18.13.00.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 13:00:59 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Philip Paeps <philip@trouble.is>
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Caowangbao <caowangbao@huawei.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v7 23/26] tcp: authopt: tcp_authopt_lookup_send: Add anykey output param
Date:   Thu, 18 Aug 2022 22:59:57 +0300
Message-Id: <a63040f97047879e691d7678b2017736cf3b9437.1660852705.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1660852705.git.cdleonard@gmail.com>
References: <cover.1660852705.git.cdleonard@gmail.com>
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

The anykey param can be used to distinguish between "no keys configured"
and "no keys valid". The former case should result in unsigned traffic
while the latter should result in an error.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 net/ipv4/tcp_authopt.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/net/ipv4/tcp_authopt.c b/net/ipv4/tcp_authopt.c
index de1390273ef3..9aa3aea25a97 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -387,38 +387,42 @@ static bool better_key_match(struct tcp_authopt_key_info *old, struct tcp_authop
  * tcp_authopt_lookup_send - lookup key for sending
  *
  * @net: Per-namespace information containing keys
  * @addr_sk: Socket used for destination address lookup
  * @send_id: Optional send_id. If >= 0 then only return keys that match
+ * @anykey: Set to true if any keys are present for the peer
  *
  * If anykey is false then authentication is not required for peer.
  *
  * If anykey is true but no key was found then all our keys must be expired and sending should fail.
  */
 static struct tcp_authopt_key_info *tcp_authopt_lookup_send(struct netns_tcp_authopt *net,
 							    const struct sock *addr_sk,
-							    int send_id)
+							    int send_id,
+							    bool *anykey)
 {
 	struct tcp_authopt_key_info *result = NULL;
 	struct tcp_authopt_key_info *key;
 	int l3index = -1;
 
 	hlist_for_each_entry_rcu(key, &net->head, node, 0) {
-		if (send_id >= 0 && key->send_id != send_id)
-			continue;
-		if (key->flags & TCP_AUTHOPT_KEY_NOSEND)
-			continue;
 		if (key->flags & TCP_AUTHOPT_KEY_ADDR_BIND)
 			if (!tcp_authopt_key_match_sk_addr(key, addr_sk))
 				continue;
 		if (key->flags & TCP_AUTHOPT_KEY_IFINDEX) {
 			if (l3index < 0)
 				l3index = l3mdev_master_ifindex_by_index(sock_net(addr_sk),
 									 addr_sk->sk_bound_dev_if);
 			if (l3index != key->l3index)
 				continue;
 		}
+		if (anykey)
+			*anykey = true;
+		if (key->flags & TCP_AUTHOPT_KEY_NOSEND)
+			continue;
+		if (send_id >= 0 && key->send_id != send_id)
+			continue;
 		if (better_key_match(result, key))
 			result = key;
 		else if (result)
 			net_warn_ratelimited("ambiguous tcp authentication keys configured for send\n");
 	}
@@ -463,14 +467,14 @@ struct tcp_authopt_key_info *__tcp_authopt_select_key(const struct sock *sk,
 		 */
 		if (info->flags & TCP_AUTHOPT_FLAG_LOCK_KEYID)
 			send_id = info->send_keyid;
 		else
 			send_id = rsk->recv_rnextkeyid;
-		key = tcp_authopt_lookup_send(net, addr_sk, send_id);
+		key = tcp_authopt_lookup_send(net, addr_sk, send_id, NULL);
 		/* If no key found with specific send_id try anything else. */
 		if (!key)
-			key = tcp_authopt_lookup_send(net, addr_sk, -1);
+			key = tcp_authopt_lookup_send(net, addr_sk, -1, NULL);
 		if (key)
 			*rnextkeyid = key->recv_id;
 		return key;
 	}
 
@@ -491,18 +495,22 @@ struct tcp_authopt_key_info *__tcp_authopt_select_key(const struct sock *sk,
 	 */
 	if (info->flags & TCP_AUTHOPT_FLAG_LOCK_KEYID) {
 		int send_keyid = info->send_keyid;
 
 		if (!key || key->send_id != send_keyid)
-			new_key = tcp_authopt_lookup_send(net, addr_sk, send_keyid);
+			new_key = tcp_authopt_lookup_send(net, addr_sk,
+							  send_keyid,
+							  NULL);
 	} else {
 		if (!key || key->send_id != info->recv_rnextkeyid)
-			new_key = tcp_authopt_lookup_send(net, addr_sk, info->recv_rnextkeyid);
+			new_key = tcp_authopt_lookup_send(net, addr_sk,
+							  info->recv_rnextkeyid,
+							  NULL);
 	}
 	/* If no key found with specific send_id try anything else. */
 	if (!key && !new_key)
-		new_key = tcp_authopt_lookup_send(net, addr_sk, -1);
+		new_key = tcp_authopt_lookup_send(net, addr_sk, -1, NULL);
 
 	/* Update current key only if we hold the socket lock. */
 	if (new_key && key != new_key) {
 		if (locked) {
 			if (kref_get_unless_zero(&new_key->ref)) {
-- 
2.25.1

