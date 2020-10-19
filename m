Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86B0B292752
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 14:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727155AbgJSM1n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 08:27:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726356AbgJSM1m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 08:27:42 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A61DC0613CE;
        Mon, 19 Oct 2020 05:27:42 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id j18so5942280pfa.0;
        Mon, 19 Oct 2020 05:27:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=f6xe1mBGtorQSFf7VDg7oxNiLvTJ4QXITfE6mPgILsM=;
        b=MsOZbKiQY72G3LtSfI8TKZ+pnzFnOYBik8I+AhTww3T97P1CVoTclASDIsBETbVSyN
         7oMgaGeggIMJSru5EAWdh+DHJgmofHMvhiA3ShYTyXKN5MFG1A/kw1t5eVOE+WlmlI3h
         5bOxXtlt7Uk2riiRGzARvUEzA7CA79QitVKjJjgnpAWdualCyvZBTIgIjxENyTodN3aa
         /h3pu7ypuGf2UpV2tdyllrwisD6OerKMEl5t1Y42bbVL4uOdlYK8SwzUN4hLL/iqrQhx
         l91k9MKbmNpd2CaJucQEwxg7Rju0DteiGgtgXOVPhvZsLkCrYT/GrBC41/KkpbgeHEVa
         pNmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=f6xe1mBGtorQSFf7VDg7oxNiLvTJ4QXITfE6mPgILsM=;
        b=cU5c0hv3g6AAHL2Ov7xO1qsyGIKNPzIQlllaGIHGif5fHERZujkGjkufUCNU1bhOMH
         iim0LaHkQBDVbbrmgxGBHoU47Vsu2P2FFkrW96gtltFZ12AQjKsPGjlpOugPjDFzk+OY
         quJwnef1lttAVQPVwY+qGS+o8gd65mFwx9Fgn2RPphRKhR+QUME/jW3+xWKhvzeJOdOL
         4deLSicxU0hPIuEBbbw9Dljcl1rzAYMk7iaDdsuV1F5L20JrZPHgndKCYmrB0oKr8n+A
         iXV/RL+SwcYR4LJ4ixvyRcd25pL29XVxduAulIaSH6aVJdnf3dpbgCrF/kqByDwT6i/0
         JSqw==
X-Gm-Message-State: AOAM533gGBf7crbMHxcmozpR1eqQQpeg9G4O2reIZVMf2x8BittZX4Bq
        x+ng9r9olLuTVsHA8VDxwJhN0dF4yf8=
X-Google-Smtp-Source: ABdhPJxT196bJV3BiKE8uyEiVJPwy2G/+cKFVBhSmDKd3NBMAfTmZHTxtC29PT4o3MbuAVqE98VkPw==
X-Received: by 2002:a63:fb4a:: with SMTP id w10mr13682445pgj.285.1603110461616;
        Mon, 19 Oct 2020 05:27:41 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b10sm10820986pgm.64.2020.10.19.05.27.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Oct 2020 05:27:41 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net,
        gnault@redhat.com, pabeni@redhat.com,
        willemdebruijn.kernel@gmail.com
Subject: [PATCHv4 net-next 16/16] sctp: enable udp tunneling socks
Date:   Mon, 19 Oct 2020 20:25:33 +0800
Message-Id: <b65bdc11e5a17e328227676ea283cee617f973fb.1603110316.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <81779bb5f9dbe452d91904f617d8083f1ba91a34.1603110316.git.lucien.xin@gmail.com>
References: <cover.1603110316.git.lucien.xin@gmail.com>
 <71b3af0fb347f27b5c3bf846dbd34485d9f80af0.1603110316.git.lucien.xin@gmail.com>
 <de3a89ece8f3abd0dca08064d9fc4d36ca7ddba2.1603110316.git.lucien.xin@gmail.com>
 <5f06ac649f4b63fc5a254812a963cada3183f136.1603110316.git.lucien.xin@gmail.com>
 <e99845af51be8fdaa53a2575e8967b8c3c8d423a.1603110316.git.lucien.xin@gmail.com>
 <7a2f5792c1a428c16962fff08b7bcfedc21bd5e2.1603110316.git.lucien.xin@gmail.com>
 <7cfd72e42b8b1cde268ad4062c96c08a56c4b14f.1603110316.git.lucien.xin@gmail.com>
 <d55a0eaefa4b8a671e54535a1899ea4c00bc2de8.1603110316.git.lucien.xin@gmail.com>
 <25013493737f5b488ce48c38667a077ca6573dd5.1603110316.git.lucien.xin@gmail.com>
 <fe0630fd48830058df1bfdd53a9e6b9fbf83b498.1603110316.git.lucien.xin@gmail.com>
 <8547ef8c7056072bdeca8f5e9eb0d7fec5cdb210.1603110316.git.lucien.xin@gmail.com>
 <e8d627d45c604460c57959a124b21aaeddfb3808.1603110316.git.lucien.xin@gmail.com>
 <2cac0eaff47574dbc07a4a074500f5e0300cff3e.1603110316.git.lucien.xin@gmail.com>
 <15f6150aa59acd248129723df647d55ea1169d85.1603110316.git.lucien.xin@gmail.com>
 <37b49f3c6eb568d25d7e46fa3f55a1c580867bb2.1603110316.git.lucien.xin@gmail.com>
 <81779bb5f9dbe452d91904f617d8083f1ba91a34.1603110316.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1603110316.git.lucien.xin@gmail.com>
References: <cover.1603110316.git.lucien.xin@gmail.com>
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
  - Call htons() when setting sk udp_port from netns udp_port.
v3->v4:
  - Not call sctp_udp_sock_start() when new_value is 0.
  - Add udp_port entry in ip-sysctl.rst.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 Documentation/networking/ip-sysctl.rst |  6 ++++
 net/sctp/protocol.c                    |  5 ++++
 net/sctp/sysctl.c                      | 52 ++++++++++++++++++++++++++++++++++
 3 files changed, 63 insertions(+)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 3909305..9effc45 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -2640,6 +2640,12 @@ addr_scope_policy - INTEGER
 
 	Default: 1
 
+udp_port - INTEGER
+	The listening port for the local UDP tunneling sock.
+	UDP encapsulation will be disabled when it's set to 0.
+
+	Default: 9899
+
 encap_port - INTEGER
 	The default remote UDP encapsalution port.
 	When UDP tunneling is enabled, this global value is used to set
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index c8de327..894ab12 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1469,6 +1469,10 @@ static int __net_init sctp_ctrlsock_init(struct net *net)
 	if (status)
 		pr_err("Failed to initialize the SCTP control sock\n");
 
+	status = sctp_udp_sock_start(net);
+	if (status)
+		pr_err("Failed to initialize the SCTP UDP tunneling sock\n");
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
index ecc1b5e..e92df77 100644
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
@@ -487,6 +498,47 @@ static int proc_sctp_do_auth(struct ctl_table *ctl, int write,
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
+		if (new_value) {
+			ret = sctp_udp_sock_start(net);
+			if (ret)
+				net->sctp.udp_port = 0;
+		}
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

