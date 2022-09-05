Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD38C5ACC49
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 09:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237365AbiIEHIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 03:08:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237232AbiIEHHU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 03:07:20 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC843F1F0;
        Mon,  5 Sep 2022 00:06:50 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id cu2so15232716ejb.0;
        Mon, 05 Sep 2022 00:06:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=74+6RKOeD3QnYDoe9HbO1jvM/A1aI0nHjrlAm2sa2+8=;
        b=gghYKEw/nyGr1NVCJLIk9y72zzR1rIxx9WBFmEoVGw5MAUq7uIeH/kaowd+AkMcGRp
         iQ5Ohws17RXwIUOZ7T+lg6w3824myxtLGWKkUZYHkD/TU3ZhcnTAxI3AQly9THSYZY+V
         8G3z0GBD1im1ETenPF4WNrUvKQ/Couc4OZC2WjsE7/i3aOIBr+3HcPjLfcKLxFIwvBKa
         SdgVqQ96kNrOGTZAO9c/8tOuiUonWGIVrfCl1y5K8wPBow5EghjJanphjJyBrBmCCm1o
         VU5P/PsfPw0RXDYh/uAA11ceBgUVNawz0XlAfz9eS4we7mBC7CfCPHUm4WDHLbwF8loN
         TayA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=74+6RKOeD3QnYDoe9HbO1jvM/A1aI0nHjrlAm2sa2+8=;
        b=ZBYE2XBhPwmRT0yL4L+DXmXjUo3GOTKup4QEdwOkSrqcDc8IP4rcyarLHjiieThrL4
         jjo63UKvD2+aqR1mp80jkJlZwUZ8fBd1WrgtI+0aNMTQVVcQdXerJI8anHO8chxXTEnL
         EJwpjo4+Y3xnm+WbTrXML2zV7kJ3g2Av4qIJ4BwX11+RTGlTfYk07FLMIOuyy1phdf2+
         MXJhMITZwrez9fPOre4Rs1aF+cU3TRHmjIL9H29p93GXki0oSzCquKGHY8Xt//HPk185
         WOyJcYrRCtiZ9pucKKfw+lfikQUH6cmUOhCOOAaobIxUGN4LIqUCYpgZsqYSfhSdHZ1R
         FvDg==
X-Gm-Message-State: ACgBeo1EK8Q5vRvNcUd7t/vXCyfxY8hO+AEwqxxSUfg9Pv7wqRN88cqb
        olUuN1kGKZU7QJfz09NQXRA=
X-Google-Smtp-Source: AA6agR7QlynEeoqSHvhKlIyexNfHVT+mO2pk3+H4+/kkFce+8/8AjbBWk36TXvCHy+LnEtya7TlydQ==
X-Received: by 2002:a17:906:5a64:b0:741:3586:92f with SMTP id my36-20020a1709065a6400b007413586092fmr30692208ejc.721.1662361608601;
        Mon, 05 Sep 2022 00:06:48 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:a080:40ec:9f50:387:3cfb])
        by smtp.gmail.com with ESMTPSA id n27-20020a056402515b00b0043cf2e0ce1csm5882775edd.48.2022.09.05.00.06.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 00:06:48 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>
Cc:     Francesco Ruggeri <fruggeri@arista.com>,
        Salam Noureddine <noureddine@arista.com>,
        Philip Paeps <philip@trouble.is>,
        Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Caowangbao <caowangbao@huawei.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v8 19/26] tcp: authopt: Add /proc/net/tcp_authopt listing all keys
Date:   Mon,  5 Sep 2022 10:05:55 +0300
Message-Id: <0fb9caada66b79fcf8eb1d267db8c65d4885e1aa.1662361354.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1662361354.git.cdleonard@gmail.com>
References: <cover.1662361354.git.cdleonard@gmail.com>
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
index 5631750cc3f7..2bceefe6fe1d 100644
--- a/Documentation/networking/tcp_authopt.rst
+++ b/Documentation/networking/tcp_authopt.rst
@@ -76,10 +76,20 @@ management. It also tries to behave predictably in all scenarios therefore it
 breaks ties by numeric IDs.
 
 A userspace daemon can use the "lock" flags to implement different key
 management and key rotation policies.
 
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
index 28c10a916fb3..ba16b8c50565 100644
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
@@ -1810,26 +1811,125 @@ int __tcp_authopt_inbound_check(struct sock *sk, struct sk_buff *skb,
 	save_inbound_key_info(info, opt);
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

