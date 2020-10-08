Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E95472871E2
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 11:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729289AbgJHJt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 05:49:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbgJHJt1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 05:49:27 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40088C061755;
        Thu,  8 Oct 2020 02:49:27 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id n14so3546589pff.6;
        Thu, 08 Oct 2020 02:49:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=0NQ6rBAGodZmng5U9FvOVx+JoVKAYom7BvJGxpJCao4=;
        b=q7e+CUI8PVJmdmYvGjAVPhm7gM4bNZr/oW05qNIp+l6JBzlg6gf70tSR1Yd73vtyL0
         FrTNUgd7Jd5z12xBTyYDwYVOFeP1b8KERz0pseA1QrPsvAAm0FV3hnLF2d/hXulU4v3u
         kZxX2UnetqUH1F+n5WRbFT/o4qdmC6R+igilbbW0FCc6Yb7bDWQxBx38SEsy8xvtUPGS
         jDneFavvOZNfcV+6YaokafMXXMjGshZ43hjn6nk0bzO0cyBDD1HVX+wgjXvsxGQdN7Q3
         VoscsrHIjYkC2FGtEP5WF+oq9MvNun89HyfDfSXMKD/s0bpHgCfGK+8MJC4LKVlTq0eF
         OgTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=0NQ6rBAGodZmng5U9FvOVx+JoVKAYom7BvJGxpJCao4=;
        b=MAkMWuudBX1IGq/RpuZkwLO1IYDgg+aHqay+QKNqy3JmRjle5iL1oFAEXD78+s2aYy
         3c3irqotNM35Cvp1R16xpmFrJUe8CiVRC1EEveQwBSeKaX2iSgSXJtacHFCaSVQaoFhh
         SE0EpacgMXmsthhq04LodsMx/hlc2vwfZ3prqTNo8B7cdzrF1pIecBs5zaxWozXHSqDL
         mksIUt7C5NN30yXLsZ5lV+iPuvz0PnebdZ83VMp1P0JXMR8eNCV9gyHUWxDWBvVeNAZH
         qiVy9Z1GHWhMnZj/YTu6jx4dWmxirjwK8GduxjwkhJh4mt8GsBfIrZqD9OMQmHHMCJ2k
         sCdw==
X-Gm-Message-State: AOAM531kxIkUM9QiRRgk9MjMxImUuNDyn4LifraD5Xu61TIycOBBDqvO
        cfOXKEYGFJLozPgb9sNQ1ZMAusSpICM=
X-Google-Smtp-Source: ABdhPJxIdUqvHkxJcTC76YlOyMv8SjfdrXmZZRCLV8XMLE4YYw51veNpWhJb2Oc2OMG0IOCZrPsyyQ==
X-Received: by 2002:a17:90a:109:: with SMTP id b9mr7510171pjb.35.1602150566514;
        Thu, 08 Oct 2020 02:49:26 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id i17sm6265574pfa.2.2020.10.08.02.49.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Oct 2020 02:49:25 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net
Subject: [PATCHv2 net-next 08/17] sctp: add encap_port for netns sock asoc and transport
Date:   Thu,  8 Oct 2020 17:48:04 +0800
Message-Id: <bcb5453d0f8abd3d499c8af467340ade1698af11.1602150362.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <baba90f09cbb5de03a6216c9f6308d0e4fb2f3c1.1602150362.git.lucien.xin@gmail.com>
References: <cover.1602150362.git.lucien.xin@gmail.com>
 <052acb63198c44df41c5db17f8397eeb7c8bacfe.1602150362.git.lucien.xin@gmail.com>
 <c36b016ee429980b9585144f4f9af31bcda467ee.1602150362.git.lucien.xin@gmail.com>
 <483d9eec159b22172fe04dacd58d7f88dfc2f301.1602150362.git.lucien.xin@gmail.com>
 <17cab00046ea7fe36c8383925a4fc3fbc028c511.1602150362.git.lucien.xin@gmail.com>
 <6f5a15bba0e2b5d3da6be90fd222c5ee41691d32.1602150362.git.lucien.xin@gmail.com>
 <af7bd8219b32d7f864eaef8ed8e970fc9bde928c.1602150362.git.lucien.xin@gmail.com>
 <baba90f09cbb5de03a6216c9f6308d0e4fb2f3c1.1602150362.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1602150362.git.lucien.xin@gmail.com>
References: <cover.1602150362.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

encap_port is added as per netns/sock/assoc/transport, and the
latter one's encap_port inherits the former one's by default.
The transport's encap_port value would mostly decide if one
packet should go out with udp encapsulated or not.

This patch also allows users to set netns' encap_port by sysctl.

v1->v2:
  - Change to define encap_port as __be16 for sctp_sock, asoc and
    transport.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/netns/sctp.h   |  2 ++
 include/net/sctp/structs.h |  6 ++++++
 net/sctp/associola.c       |  4 ++++
 net/sctp/protocol.c        |  3 +++
 net/sctp/socket.c          |  1 +
 net/sctp/sysctl.c          | 10 ++++++++++
 6 files changed, 26 insertions(+)

diff --git a/include/net/netns/sctp.h b/include/net/netns/sctp.h
index f622945..6af7a39 100644
--- a/include/net/netns/sctp.h
+++ b/include/net/netns/sctp.h
@@ -27,6 +27,8 @@ struct netns_sctp {
 	struct sock *udp6_sock;
 	/* udp tunneling listening port. */
 	int udp_port;
+	/* udp tunneling remote encap port. */
+	int encap_port;
 
 	/* This is the global local address list.
 	 * We actively maintain this complete list of addresses on
diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 0bdff38..aa98e7e 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -178,6 +178,8 @@ struct sctp_sock {
 	 */
 	__u32 hbinterval;
 
+	__be16 encap_port;
+
 	/* This is the max_retrans value for new associations. */
 	__u16 pathmaxrxt;
 
@@ -877,6 +879,8 @@ struct sctp_transport {
 	 */
 	unsigned long last_time_ecne_reduced;
 
+	__be16 encap_port;
+
 	/* This is the max_retrans value for the transport and will
 	 * be initialized from the assocs value.  This can be changed
 	 * using the SCTP_SET_PEER_ADDR_PARAMS socket option.
@@ -1790,6 +1794,8 @@ struct sctp_association {
 	 */
 	unsigned long hbinterval;
 
+	__be16 encap_port;
+
 	/* This is the max_retrans value for new transports in the
 	 * association.
 	 */
diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index fdb69d4..336df4b 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -99,6 +99,8 @@ static struct sctp_association *sctp_association_init(
 	 */
 	asoc->hbinterval = msecs_to_jiffies(sp->hbinterval);
 
+	asoc->encap_port = sp->encap_port;
+
 	/* Initialize path max retrans value. */
 	asoc->pathmaxrxt = sp->pathmaxrxt;
 
@@ -624,6 +626,8 @@ struct sctp_transport *sctp_assoc_add_peer(struct sctp_association *asoc,
 	 */
 	peer->hbinterval = asoc->hbinterval;
 
+	peer->encap_port = asoc->encap_port;
+
 	/* Set the path max_retrans.  */
 	peer->pathmaxrxt = asoc->pathmaxrxt;
 
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index dd2d9c4..5b74187 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1359,6 +1359,9 @@ static int __net_init sctp_defaults_init(struct net *net)
 	/* Set udp tunneling listening port to default value */
 	net->sctp.udp_port = SCTP_DEFAULT_UDP_PORT;
 
+	/* Set remote encap port to 0 by default */
+	net->sctp.encap_port = 0;
+
 	/* Set SCOPE policy to enabled */
 	net->sctp.scope_policy = SCTP_SCOPE_POLICY_ENABLE;
 
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 53d0a41..09b94cd 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4876,6 +4876,7 @@ static int sctp_init_sock(struct sock *sk)
 	 * be modified via SCTP_PEER_ADDR_PARAMS
 	 */
 	sp->hbinterval  = net->sctp.hb_interval;
+	sp->encap_port  = htons(net->sctp.encap_port);
 	sp->pathmaxrxt  = net->sctp.max_retrans_path;
 	sp->pf_retrans  = net->sctp.pf_retrans;
 	sp->ps_retrans  = net->sctp.ps_retrans;
diff --git a/net/sctp/sysctl.c b/net/sctp/sysctl.c
index c16c809..ecc1b5e 100644
--- a/net/sctp/sysctl.c
+++ b/net/sctp/sysctl.c
@@ -36,6 +36,7 @@ static int rto_alpha_max = 1000;
 static int rto_beta_max = 1000;
 static int pf_expose_max = SCTP_PF_EXPOSE_MAX;
 static int ps_retrans_max = SCTP_PS_RETRANS_MAX;
+static int udp_port_max = 65535;
 
 static unsigned long max_autoclose_min = 0;
 static unsigned long max_autoclose_max =
@@ -291,6 +292,15 @@ static struct ctl_table sctp_net_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 	{
+		.procname	= "encap_port",
+		.data		= &init_net.sctp.encap_port,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= &udp_port_max,
+	},
+	{
 		.procname	= "addr_scope_policy",
 		.data		= &init_net.sctp.scope_policy,
 		.maxlen		= sizeof(int),
-- 
2.1.0

