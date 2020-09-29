Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92D0627CFEE
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 15:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730772AbgI2Nvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 09:51:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728367AbgI2Nvc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 09:51:32 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1115C061755;
        Tue, 29 Sep 2020 06:51:32 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id l126so4611395pfd.5;
        Tue, 29 Sep 2020 06:51:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=nNboYdcjgXYzO6CmiDQoSlJrRKhaen2l7njFPVpXSdw=;
        b=AJI/5BMBLKoLLOvEbIGCw3Eom/0PjNKR2j2HM4TZHNlrMi6fRBCeyc7kjJIIT1eB8S
         r5SPndHtiADwGn2nK69FZ8mBmZ0rQpNke+lznOLn+YkZV2ZHj3XdLdLqAIeAWqaHh3l2
         nF45FmLyklGo8i31F3n1Kc4Ens5ARmSVm8lN0xuIn5KCxvF4h7aleBD8UjFKCNKZqyOo
         T50OBYGIp2jYVXPg6hlEzOL4U5ZehbwEboG2dgOu6C680bTs/nzBExunxG261u7DiRNZ
         KOO5DZJEL+V/b/ymOAWe1HEozl3wpzrclOU4NFJuLzhG9opqiFcJ9nJh06xoPrOWRhtm
         1w6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=nNboYdcjgXYzO6CmiDQoSlJrRKhaen2l7njFPVpXSdw=;
        b=QCIWg+S4MNugohTYdFdLYgT+g1IaKD2uJftoSzYqXoZVro0WDFMS2MwU+Hu/Bjj0b3
         7JLsgZ3DcQTB7U7aVWiOFRV1A+Co7QEqbKKkOJrTy7BlvA0Cg7QTk47ehblsHyBCVdae
         qe/cEwMHUOWPERhsDsCucHiF4FOgr5zIncc9aPle3VpCEu59bYgflF1r4Um8XpmMEqzI
         bPko/kAaQvsePeNir2bmFdY3B3ZVXf2WAwzeP6dFGy1o/0KHnePR090EjEZj6GU/T+/k
         0UaKKhDVPRJu5qTw8HQslrawaGaFPg82C4JUdyTe0B5rH3dNzbDIKcemhXtv4Dg9qT75
         Pp/w==
X-Gm-Message-State: AOAM531kPZyJ0zlUxv4CrTn9PWJlenxx1Wwb9jvDfHEKqLZQejX8V3mR
        2QXB3neoOHV3nsaUbPnQ1VGqJcFqXpk=
X-Google-Smtp-Source: ABdhPJxwDwVVlTaIr9qDocdrRgAs5OKZpJ+sgIUWMaASSyJjoYxXWoBsAh+jSlVpLy81pE4/HSsEBg==
X-Received: by 2002:a63:4404:: with SMTP id r4mr3090099pga.29.1601387491523;
        Tue, 29 Sep 2020 06:51:31 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j11sm2138991pji.31.2020.09.29.06.51.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Sep 2020 06:51:30 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>,
        Tom Herbert <therbert@google.com>, davem@davemloft.net
Subject: [PATCH net-next 15/15] sctp: enable udp tunneling socks
Date:   Tue, 29 Sep 2020 21:49:07 +0800
Message-Id: <780b235b6b4446f77cfcf167ba797ce1ae507cf1.1601387231.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <6388faf30ca428c5026e5a62fdf484dcad7e0da2.1601387231.git.lucien.xin@gmail.com>
References: <cover.1601387231.git.lucien.xin@gmail.com>
 <51c1fdad515076f3014476711aec1c0a81c18d36.1601387231.git.lucien.xin@gmail.com>
 <65f713004ab546e0b6ec793572c72c1d0399f0fe.1601387231.git.lucien.xin@gmail.com>
 <49a1cbb99341f50304b514aeaace078d0b065248.1601387231.git.lucien.xin@gmail.com>
 <97963ca7171b92486f46477b55928182abe44806.1601387231.git.lucien.xin@gmail.com>
 <ddf990677d003f4d0be245b88f4b0f25d54f26d5.1601387231.git.lucien.xin@gmail.com>
 <ec4b75d8c69ba640a9104158ab875c4011cb533d.1601387231.git.lucien.xin@gmail.com>
 <f9f58a248df8194bbf6f4a83a05ec4e98d2955f1.1601387231.git.lucien.xin@gmail.com>
 <e1ff8bac558dd425b2f29044c3136bf680babcad.1601387231.git.lucien.xin@gmail.com>
 <ff57fb1ff7c477ff038cebb36e9f0554d26d5915.1601387231.git.lucien.xin@gmail.com>
 <3f1b88ab88b5cc5321ffe094bcfeff68a3a5ef2c.1601387231.git.lucien.xin@gmail.com>
 <7ff312f910ada8893fa4db57d341c628d1122640.1601387231.git.lucien.xin@gmail.com>
 <3716fc0699dc1d5557574b5227524e80b7fd76b8.1601387231.git.lucien.xin@gmail.com>
 <82b358f40c81cfdecbfc394113be40fd1f682043.1601387231.git.lucien.xin@gmail.com>
 <6388faf30ca428c5026e5a62fdf484dcad7e0da2.1601387231.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1601387231.git.lucien.xin@gmail.com>
References: <cover.1601387231.git.lucien.xin@gmail.com>
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

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/protocol.c |  5 +++++
 net/sctp/sysctl.c   | 43 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+)

diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 6606a63..4b63883 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1466,6 +1466,10 @@ static int __net_init sctp_ctrlsock_init(struct net *net)
 	if (status)
 		pr_err("Failed to initialize the SCTP control sock\n");
 
+	status = sctp_udp_sock_start(net);
+	if (status)
+		pr_err("Failed to initialize the SCTP udp tunneling sock\n");
+
 	return status;
 }
 
@@ -1473,6 +1477,7 @@ static void __net_exit sctp_ctrlsock_exit(struct net *net)
 {
 	/* Free the control endpoint.  */
 	inet_ctl_sock_destroy(net->sctp.ctl_sock);
+	sctp_udp_sock_stop(net);
 }
 
 static struct pernet_operations sctp_ctrlsock_ops = {
diff --git a/net/sctp/sysctl.c b/net/sctp/sysctl.c
index ecc1b5e..7afe904 100644
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
@@ -487,6 +498,38 @@ static int proc_sctp_do_auth(struct ctl_table *ctl, int write,
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
+		if (new_value > max || new_value < min)
+			return -EINVAL;
+
+		net->sctp.udp_port = new_value;
+		sctp_udp_sock_stop(net);
+		ret = sctp_udp_sock_start(net);
+		if (ret)
+			net->sctp.udp_port = 0;
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

