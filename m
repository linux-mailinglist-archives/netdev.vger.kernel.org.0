Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3A08598D24
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 22:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345846AbiHRUCc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 16:02:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345725AbiHRUBE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 16:01:04 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE20BD1254;
        Thu, 18 Aug 2022 13:00:50 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id b16so3209164edd.4;
        Thu, 18 Aug 2022 13:00:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=xUwlz5tV2pDmzkwueTqVMNi0VVgFLaQtoJ1cuBHIFlg=;
        b=G3b1ziIgi6OjKq7ncGmGQzIi8TOKyW//qmLb7qYKwzfpty1jelTczOj4n+wnmzcm2S
         bTSXs6MsELu1OVQsViT304UEXbsjwDRBYwvqk6GyFIvmfyMng1LRjAtve9P9oGOEeB2T
         pqiTdZY66tnOh5Xh+g+21hluiZvVmlfz6Ae32illSKhSynmxXNncbM8FiLT4Yn1b8+ge
         orcPmdUtkHM60+zfLSxxKNDHwB5o3WPUSOPem3nsHIFr9SsyKFgXSDvZoAgSYV3hvuUu
         HHgP9L4R8t1Nsa3GFuMzPdaKwKPDywDS6zlokD7I1YhWHOj9b0lRv6MufX4cLSL6xARY
         266A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=xUwlz5tV2pDmzkwueTqVMNi0VVgFLaQtoJ1cuBHIFlg=;
        b=h5cOLzSLP5y1YuyevPOUs8kujtfhsmtgq1fexFDYSkk/NCd6OQ9R8IXXAY9uroUwY4
         BehTLZHC8ZZoWf+ZFxGkqvrGZSm/BeWTbfRpGoefsUvoUHCAUiO4HVdMVKQHvMH4WNIk
         hR8Ie8G9YbZaKs37SG0kRhUVroZE37xcmH2ocXD2AEt+0b0D9H+LOFhBlj8I4VmqZRX8
         HcZuI20nFqiquEQ3mMuWs1TS2wCiZjzVUOlk+lAiBxsym667D0WLIksgodFXSKbhXkXF
         JaDeW25On0fkO/HePmk0hNBZ4AEgnsmB8aVxgWTJketGAW8S0knpCVWPCNGR8/fhSqYq
         L0wQ==
X-Gm-Message-State: ACgBeo02SRRkmsnZMeyU30lkNucshLIEOIkGf4l2Ty4CfnX01sj6oK4q
        mFomIf56HP7jNhjxa1Ldb1k=
X-Google-Smtp-Source: AA6agR4R8q8t5lOgVLkeGXZPq1wSJdDWADc5Pm+sXIDX4pY/5bqGqjJE6RqJTWnEz6Logo26pvUWfQ==
X-Received: by 2002:a05:6402:500d:b0:440:9bc5:d0c1 with SMTP id p13-20020a056402500d00b004409bc5d0c1mr3491968eda.202.1660852850223;
        Thu, 18 Aug 2022 13:00:50 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:a080:17c8:ba1c:b6f3:3fe0])
        by smtp.gmail.com with ESMTPSA id fw30-20020a170907501e00b00722e4bab163sm1215087ejc.200.2022.08.18.13.00.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 13:00:49 -0700 (PDT)
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
Subject: [PATCH v7 18/26] tcp: authopt: Add /proc/net/tcp_authopt listing all keys
Date:   Thu, 18 Aug 2022 22:59:52 +0300
Message-Id: <07670e63c786e9e46ba52aaecb81ad7e1418767e.1660852705.git.cdleonard@gmail.com>
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

This provides a very brief summary of all keys for debugging purposes.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 Documentation/networking/tcp_authopt.rst |  10 +++
 net/ipv4/tcp_authopt.c                   | 102 ++++++++++++++++++++++-
 2 files changed, 111 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/tcp_authopt.rst b/Documentation/networking/tcp_authopt.rst
index 6520c6d02755..eaf389f99139 100644
--- a/Documentation/networking/tcp_authopt.rst
+++ b/Documentation/networking/tcp_authopt.rst
@@ -69,10 +69,20 @@ The rnextkeyid value sent on the wire is usually the recv_id of the current
 key used for sending. If the TCP_AUTHOPT_LOCK_RNEXTKEY flag is set in
 `tcp_authopt.flags` the value of `tcp_authopt.send_rnextkeyid` is send
 instead.  This can be used to implement smooth rollover: the peer will switch
 its keyid to the received rnextkeyid when it is available.
 
+Proc interface
+--------------
+
+The ``/proc/net/tcp_authopt`` file contains a tab-separated table of keys. The
+first line contains column names. The number of columns might increase in the
+future if more matching criteria are added. Here is an example of the table::
+
+	flags	send_id	recv_id	alg	addr	l3index
+	0x44	0	0	1	10.10.2.2/31	0
+
 ABI Reference
 =============
 
 .. kernel-doc:: include/uapi/linux/tcp.h
    :identifiers: tcp_authopt tcp_authopt_flag tcp_authopt_key tcp_authopt_key_flag tcp_authopt_alg
diff --git a/net/ipv4/tcp_authopt.c b/net/ipv4/tcp_authopt.c
index 06f8df1d80c9..0a273ad239ec 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -5,10 +5,11 @@
 #include <net/ipv6.h>
 #include <net/tcp.h>
 #include <linux/kref.h>
 #include <crypto/hash.h>
 #include <linux/inetdevice.h>
+#include <linux/proc_fs.h>
 
 /* This is mainly intended to protect against local privilege escalations through
  * a rarely used feature so it is deliberately not namespaced.
  */
 int sysctl_tcp_authopt;
@@ -1731,26 +1732,125 @@ int __tcp_authopt_inbound_check(struct sock *sk, struct sk_buff *skb,
 
 	return 1;
 }
 EXPORT_SYMBOL(__tcp_authopt_inbound_check);
 
+#ifdef CONFIG_PROC_FS
+struct tcp_authopt_iter_state {
+	struct seq_net_private p;
+};
+
+static struct tcp_authopt_key_info *tcp_authopt_get_key_index(struct netns_tcp_authopt *net,
+							      int index)
+{
+	struct tcp_authopt_key_info *key;
+
+	hlist_for_each_entry(key, &net->head, node) {
+		if (--index < 0)
+			return key;
+	}
+
+	return NULL;
+}
+
+static void *tcp_authopt_seq_start(struct seq_file *seq, loff_t *pos)
+	__acquires(RCU)
+{
+	struct netns_tcp_authopt *net = &seq_file_net(seq)->tcp_authopt;
+
+	rcu_read_lock();
+	if (*pos == 0)
+		return SEQ_START_TOKEN;
+	else
+		return tcp_authopt_get_key_index(net, *pos - 1);
+}
+
+static void tcp_authopt_seq_stop(struct seq_file *seq, void *v)
+	__releases(RCU)
+{
+	rcu_read_unlock();
+}
+
+static void *tcp_authopt_seq_next(struct seq_file *seq, void *v, loff_t *pos)
+{
+	struct netns_tcp_authopt *net = &seq_file_net(seq)->tcp_authopt;
+	void *ret;
+
+	ret = tcp_authopt_get_key_index(net, *pos);
+	++*pos;
+
+	return ret;
+}
+
+static int tcp_authopt_seq_show(struct seq_file *seq, void *v)
+{
+	struct tcp_authopt_key_info *key = v;
+
+	/* FIXME: Document somewhere */
+	/* Key is deliberately inaccessible */
+	if (v == SEQ_START_TOKEN) {
+		seq_puts(seq, "flags\tsend_id\trecv_id\talg\taddr\tl3index\n");
+		return 0;
+	}
+
+	seq_printf(seq, "0x%x\t%d\t%d\t%d",
+		   key->flags, key->send_id, key->recv_id, (int)key->alg_id);
+	if (key->flags & TCP_AUTHOPT_KEY_ADDR_BIND) {
+		if (key->addr.ss_family == AF_INET6)
+			seq_printf(seq, "\t%pI6", &((struct sockaddr_in6 *)&key->addr)->sin6_addr);
+		else
+			seq_printf(seq, "\t%pI4", &((struct sockaddr_in *)&key->addr)->sin_addr);
+		if (key->flags & TCP_AUTHOPT_KEY_PREFIXLEN)
+			seq_printf(seq, "/%d", key->prefixlen);
+	} else {
+		seq_puts(seq, "\t*");
+	}
+	seq_printf(seq, "\t%d", key->l3index);
+	seq_puts(seq, "\n");
+
+	return 0;
+}
+
+static const struct seq_operations tcp_authopt_seq_ops = {
+	.start		= tcp_authopt_seq_start,
+	.next		= tcp_authopt_seq_next,
+	.stop		= tcp_authopt_seq_stop,
+	.show		= tcp_authopt_seq_show,
+};
+#endif /* CONFIG_PROC_FS */
+
+static int __net_init tcp_authopt_proc_init_net(struct net *net)
+{
+	if (!proc_create_net("tcp_authopt", 0400, net->proc_net,
+			     &tcp_authopt_seq_ops,
+			     sizeof(struct tcp_authopt_iter_state)))
+		return -ENOMEM;
+	return 0;
+}
+
+static void __net_exit tcp_authopt_proc_exit_net(struct net *net)
+{
+	remove_proc_entry("tcp_authopt", net->proc_net);
+}
+
 static int tcp_authopt_init_net(struct net *full_net)
 {
 	struct netns_tcp_authopt *net = &full_net->tcp_authopt;
 
 	mutex_init(&net->mutex);
 	INIT_HLIST_HEAD(&net->head);
 
-	return 0;
+	return tcp_authopt_proc_init_net(full_net);
 }
 
 static void tcp_authopt_exit_net(struct net *full_net)
 {
 	struct netns_tcp_authopt *net = &full_net->tcp_authopt;
 	struct tcp_authopt_key_info *key;
 	struct hlist_node *n;
 
+	tcp_authopt_proc_exit_net(full_net);
 	mutex_lock(&net->mutex);
 
 	hlist_for_each_entry_safe(key, n, &net->head, node) {
 		hlist_del_rcu(&key->node);
 		tcp_authopt_key_put(key);
-- 
2.25.1

