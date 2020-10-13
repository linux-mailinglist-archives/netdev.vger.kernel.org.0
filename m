Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D68D28C95A
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 09:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390339AbgJMH3v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 03:29:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390145AbgJMH3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 03:29:50 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 933AFC0613D0;
        Tue, 13 Oct 2020 00:29:50 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id t18so10205331plo.1;
        Tue, 13 Oct 2020 00:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=M+hPPlgTv2YdBHtRGeycL5jpqPJPwGINWtjJsu2TNcc=;
        b=UolpU46tg6AHwTYwut+u5m6Z2I4Ts2n43AywtTrizrLh74mWZVEnbatBSbfkIPPEL1
         icinaYTpN+DIFZnarHD2AOBQ/1ZYb/XacaWKfjXilItaJgU2ORsUQYuz6eMav2EhIxd9
         q9xdcFENtIcvMtm4lH6HoLyPSjDUQUcImn5WpjFJJXapvZKuaoBbvDZoWV7quNDr3ZwD
         dRD8baz1yMlKNr9Vw7Ftu7mdBphxLJ0I5wHPjo4vEIV6GozziM/tPFiVK180xDAywdXv
         v53RPow1ktFsuhVPqcmDRYFcPwYXuqZZzNnOrA6IVehUnlEDUun/v/7XJ2gVmWT1OKxl
         jZFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=M+hPPlgTv2YdBHtRGeycL5jpqPJPwGINWtjJsu2TNcc=;
        b=UgGUH4fAM+lAKJuU0MSL1CKNNMc4W2zr3Dy9hM20FXvSh0xof+dTQawV3oZv3bYwHP
         L2b4XxgaWV0GEG8rtAEPgiaTuM6UjaZ8W2DRxXnJ5KiOibgb1r7BQO4bif7kMh1J2szw
         K54m3eEMDEEWpVmLwJMrXfhwJj/FnUt86Os/UfM1p+ln75reWyOk/JDafF5FRgL8+kOv
         XYyL+psvpPk2WojNDxABBHTpTudnRhEXMa5uAAQub6buxqzRXa9O08dPwpe62zoC74Ee
         TdNrOZbKZDWCg9gHd0EB3Qe44m7U2FMpHNaj7CwqQtD3LOK2/SQc3F9Vgrl1zL9nTRC1
         uxMw==
X-Gm-Message-State: AOAM531sh/MIHbp9U288J+0n//DfG9CW4HOvAkq4hBTNRHMUmer9RtO8
        Jh48M4rrrYaeq+KRXuba748nutYNNGg=
X-Google-Smtp-Source: ABdhPJzyeWcToTujcfD73qaqE+kkkvJfRo4uVxpfwnQIsXQV3ozCXXOzo/sRPviDTzz7o+7Evu43gQ==
X-Received: by 2002:a17:90b:e92:: with SMTP id fv18mr24945941pjb.42.1602574189400;
        Tue, 13 Oct 2020 00:29:49 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g9sm21098081pgm.79.2020.10.13.00.29.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Oct 2020 00:29:48 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net,
        gnault@redhat.com, pabeni@redhat.com,
        willemdebruijn.kernel@gmail.com
Subject: [PATCHv3 net-next 16/16] sctp: enable udp tunneling socks
Date:   Tue, 13 Oct 2020 15:27:41 +0800
Message-Id: <afbaca39fa40eba694bd63c200050a49d8c8df81.1602574012.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <59d083919cccb32dad7aec119d00c5300b0c2800.1602574012.git.lucien.xin@gmail.com>
References: <cover.1602574012.git.lucien.xin@gmail.com>
 <fae9c57767447c4fd97476807b9e029e8fda607a.1602574012.git.lucien.xin@gmail.com>
 <c01a9a09096cb1b292d461aa5a1e72aae2ca942a.1602574012.git.lucien.xin@gmail.com>
 <dbad21ff524e119f83ae4444d1ae393ab165fa7c.1602574012.git.lucien.xin@gmail.com>
 <7159fb58f44f9ff00ca5b3b8a26ee3aa2fd1bf8a.1602574012.git.lucien.xin@gmail.com>
 <b9f0bfa27c5be3bbf27a7325c73f16205286df38.1602574012.git.lucien.xin@gmail.com>
 <c9c1d019287792f71863c89758d179b133fe1200.1602574012.git.lucien.xin@gmail.com>
 <37e9f70ffb9dea1572025b8e1c4b1f1c6e6b3da5.1602574012.git.lucien.xin@gmail.com>
 <08854ecf72eee34d3e98e30def6940d94f97fdef.1602574012.git.lucien.xin@gmail.com>
 <732baa9aef67a1b0d0b4d69f47149b41a49bbd76.1602574012.git.lucien.xin@gmail.com>
 <4885b112360b734e25714499346e6dc22246a87d.1602574012.git.lucien.xin@gmail.com>
 <c97b738ae89c59f14afbbca22d0294dc24eca30f.1602574012.git.lucien.xin@gmail.com>
 <46f33eb9331b7e1e688a7f125201ad600ae83fbd.1602574012.git.lucien.xin@gmail.com>
 <c79a0be422c96fec9da194a20853811d93809393.1602574012.git.lucien.xin@gmail.com>
 <df18ce9f94be0a58bbf1743071993b95696aed2d.1602574012.git.lucien.xin@gmail.com>
 <59d083919cccb32dad7aec119d00c5300b0c2800.1602574012.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1602574012.git.lucien.xin@gmail.com>
References: <cover.1602574012.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to enable udp tunneling socks by calling
sctp_udp_sock_start() in sctp_ctrlsock_init(), and
sctp_udp_sock_stop() in sctp_ctrlsock_exit().

Also add sysctl udp_port to allow changing the listening
sock's port by users.

Wit this patch, the whole sctp over udp feature can be
enabled and used.

v1->v2:
  - Also update ctl_sock udp_port in proc_sctp_do_udp_port()
    where netns udp_port gets changed.
v2->v3:
  - call htons() when setting sk udp_port from netns udp_port.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/protocol.c |  5 +++++
 net/sctp/sysctl.c   | 50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+)

diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index be002b7..79fb4b5 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1469,6 +1469,10 @@ static int __net_init sctp_ctrlsock_init(struct net *net)
 	if (status)
 		pr_err("Failed to initialize the SCTP control sock\n");
 
+	status = sctp_udp_sock_start(net);
+	if (status)
+		pr_err("Failed to initialize the SCTP udp tunneling sock\n");
+
 	return status;
 }
 
@@ -1476,6 +1480,7 @@ static void __net_exit sctp_ctrlsock_exit(struct net *net)
 {
 	/* Free the control endpoint.  */
 	inet_ctl_sock_destroy(net->sctp.ctl_sock);
+	sctp_udp_sock_stop(net);
 }
 
 static struct pernet_operations sctp_ctrlsock_ops = {
diff --git a/net/sctp/sysctl.c b/net/sctp/sysctl.c
index ecc1b5e..4395659 100644
--- a/net/sctp/sysctl.c
+++ b/net/sctp/sysctl.c
@@ -49,6 +49,8 @@ static int proc_sctp_do_rto_min(struct ctl_table *ctl, int write,
 				void *buffer, size_t *lenp, loff_t *ppos);
 static int proc_sctp_do_rto_max(struct ctl_table *ctl, int write, void *buffer,
 				size_t *lenp, loff_t *ppos);
+static int proc_sctp_do_udp_port(struct ctl_table *ctl, int write, void *buffer,
+				 size_t *lenp, loff_t *ppos);
 static int proc_sctp_do_alpha_beta(struct ctl_table *ctl, int write,
 				   void *buffer, size_t *lenp, loff_t *ppos);
 static int proc_sctp_do_auth(struct ctl_table *ctl, int write,
@@ -292,6 +294,15 @@ static struct ctl_table sctp_net_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 	{
+		.procname	= "udp_port",
+		.data		= &init_net.sctp.udp_port,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_sctp_do_udp_port,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= &udp_port_max,
+	},
+	{
 		.procname	= "encap_port",
 		.data		= &init_net.sctp.encap_port,
 		.maxlen		= sizeof(int),
@@ -487,6 +498,45 @@ static int proc_sctp_do_auth(struct ctl_table *ctl, int write,
 	return ret;
 }
 
+static int proc_sctp_do_udp_port(struct ctl_table *ctl, int write,
+				 void *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct net *net = current->nsproxy->net_ns;
+	unsigned int min = *(unsigned int *)ctl->extra1;
+	unsigned int max = *(unsigned int *)ctl->extra2;
+	struct ctl_table tbl;
+	int ret, new_value;
+
+	memset(&tbl, 0, sizeof(struct ctl_table));
+	tbl.maxlen = sizeof(unsigned int);
+
+	if (write)
+		tbl.data = &new_value;
+	else
+		tbl.data = &net->sctp.udp_port;
+
+	ret = proc_dointvec(&tbl, write, buffer, lenp, ppos);
+	if (write && ret == 0) {
+		struct sock *sk = net->sctp.ctl_sock;
+
+		if (new_value > max || new_value < min)
+			return -EINVAL;
+
+		net->sctp.udp_port = new_value;
+		sctp_udp_sock_stop(net);
+		ret = sctp_udp_sock_start(net);
+		if (ret)
+			net->sctp.udp_port = 0;
+
+		/* Update the value in the control socket */
+		lock_sock(sk);
+		sctp_sk(sk)->udp_port = htons(net->sctp.udp_port);
+		release_sock(sk);
+	}
+
+	return ret;
+}
+
 int sctp_sysctl_net_register(struct net *net)
 {
 	struct ctl_table *table;
-- 
2.1.0

