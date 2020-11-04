Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBD6A2A5E67
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 07:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727651AbgKDGzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 01:55:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726152AbgKDGzm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 01:55:42 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28974C061A4D;
        Tue,  3 Nov 2020 22:55:42 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id x13so16503785pfa.9;
        Tue, 03 Nov 2020 22:55:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=3GoZYIKtBnd3WfV4L8B60YbvUuaUYQQEisVULesPA6M=;
        b=LCKex+0fYaIMg7gWdul+7ggT0UOH4EKdfKwWimYOm0DZKM7Fp1ly1kQU2rl+vg5OtI
         Oml/V0tuvBOPDXac0nyE1RD3Z2YXbbZYdk7oQWdxiVx1ZXXiYKa814UEsbcYzDfk5E88
         3Y7HfPHXx7MACt3Ahhk9//CcJGtKZD0vMmwwXzGTf/qWIdHWvY0zHtdeylAX8qX15JqI
         zaJzNbGTV9CMfbUg/p5A9VsP3TIxy4yHZsEyOmrw08Z1gEzg6nd6DshUXkuodGx09QIM
         0cNPntfYM60c3FnQTddSjZzAMI3pvx5TwziV5WF9Dbz1Bzk2ixqe7TpJqz61kaTb2i7N
         P5cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=3GoZYIKtBnd3WfV4L8B60YbvUuaUYQQEisVULesPA6M=;
        b=PGEdl4A50e7v3aFjgcXveIGj/1URRcVIdkndiNdee5JPm970kQBMed968LXqGUSG4n
         oY/vKSPW0bOc5XJLLXoasezZraf1qnR8jiN+dxpjdcQ1JYL9zzAy1cJC/PDtMKdeG8hX
         /NTS3Fi0/rigR71ndQlgV5k7GTbM0Nb6LN1LNa2W8sU3KkKln93dYUd0NEp6P7XCqXoj
         x0hdkmgMYhEt55mH7j9YQSDRpT1c40dCw2SwuPZhA8g/3/w2ep0+kLfxijgqIaDczAnr
         Sp3vw5X+OlIu1TC+Xsj6jhdkvHVWWPdcm+WIaIIwzQz5oZ4a5jhphQInknKVMfiLLrRi
         8VVw==
X-Gm-Message-State: AOAM531aeKuUWvw7j6EPm4LkjV2SByfijMg2P4s9JBYbMrhVrmj8ylHB
        wMKmfwaJQeLEocDzTPKr0c+VK2ndWAw=
X-Google-Smtp-Source: ABdhPJxNC0eOK2R6MYbOSpWGpDiPubuOF1Nfy3nwylc+zcDR0NW9DnqiHZeh/FNE+rxdp4ibCY2o7Q==
X-Received: by 2002:a62:2c16:0:b029:15d:8d2:2e6d with SMTP id s22-20020a622c160000b029015d08d22e6dmr29431217pfs.52.1604472941217;
        Tue, 03 Nov 2020 22:55:41 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id i11sm1158981pfd.211.2020.11.03.22.55.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Nov 2020 22:55:40 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] sctp: bring inet(6)_skb_parm back to sctp_input_cb
Date:   Wed,  4 Nov 2020 14:55:32 +0800
Message-Id: <136c1a7a419341487c504be6d1996928d9d16e02.1604472932.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

inet(6)_skb_parm was removed from sctp_input_cb by Commit a1dd2cf2f1ae
("sctp: allow changing transport encap_port by peer packets"), as it
thought sctp_input_cb->header is not used any more in SCTP.

syzbot reported a crash:

  [ ] BUG: KASAN: use-after-free in decode_session6+0xe7c/0x1580
  [ ]
  [ ] Call Trace:
  [ ]  <IRQ>
  [ ]  dump_stack+0x107/0x163
  [ ]  kasan_report.cold+0x1f/0x37
  [ ]  decode_session6+0xe7c/0x1580
  [ ]  __xfrm_policy_check+0x2fa/0x2850
  [ ]  sctp_rcv+0x12b0/0x2e30
  [ ]  sctp6_rcv+0x22/0x40
  [ ]  ip6_protocol_deliver_rcu+0x2e8/0x1680
  [ ]  ip6_input_finish+0x7f/0x160
  [ ]  ip6_input+0x9c/0xd0
  [ ]  ipv6_rcv+0x28e/0x3c0

It was caused by sctp_input_cb->header/IP6CB(skb) still used in sctp rx
path decode_session6() but some members overwritten by sctp6_rcv().

This patch is to fix it by bring inet(6)_skb_parm back to sctp_input_cb
and not overwriting it in sctp4/6_rcv() and sctp_udp_rcv().

Reported-by: syzbot+5be8aebb1b7dfa90ef31@syzkaller.appspotmail.com
Fixes: a1dd2cf2f1ae ("sctp: allow changing transport encap_port by peer packets")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/structs.h | 6 ++++++
 net/sctp/ipv6.c            | 2 +-
 net/sctp/protocol.c        | 3 +--
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 80f7149..1aa5852 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -1121,6 +1121,12 @@ static inline void sctp_outq_cork(struct sctp_outq *q)
  * sctp_input_cb is currently used on rx and sock rx queue
  */
 struct sctp_input_cb {
+	union {
+		struct inet_skb_parm    h4;
+#if IS_ENABLED(CONFIG_IPV6)
+		struct inet6_skb_parm   h6;
+#endif
+	} header;
 	struct sctp_chunk *chunk;
 	struct sctp_af *af;
 	__be16 encap_port;
diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index 814754d..c3e89c7 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -1074,7 +1074,7 @@ static struct inet_protosw sctpv6_stream_protosw = {
 
 static int sctp6_rcv(struct sk_buff *skb)
 {
-	memset(skb->cb, 0, sizeof(skb->cb));
+	SCTP_INPUT_CB(skb)->encap_port = 0;
 	return sctp_rcv(skb) ? -1 : 0;
 }
 
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 41f287a..6f2bbfe 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -843,7 +843,6 @@ static int sctp_ctl_sock_init(struct net *net)
 
 static int sctp_udp_rcv(struct sock *sk, struct sk_buff *skb)
 {
-	memset(skb->cb, 0, sizeof(skb->cb));
 	SCTP_INPUT_CB(skb)->encap_port = udp_hdr(skb)->source;
 
 	skb_set_transport_header(skb, sizeof(struct udphdr));
@@ -1163,7 +1162,7 @@ static struct inet_protosw sctp_stream_protosw = {
 
 static int sctp4_rcv(struct sk_buff *skb)
 {
-	memset(skb->cb, 0, sizeof(skb->cb));
+	SCTP_INPUT_CB(skb)->encap_port = 0;
 	return sctp_rcv(skb);
 }
 
-- 
2.1.0

