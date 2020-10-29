Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ABD929E4A1
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 08:45:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730309AbgJ2HkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 03:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726923AbgJ2HYy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 03:24:54 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B791C08EA7A;
        Thu, 29 Oct 2020 00:07:26 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id f38so1597179pgm.2;
        Thu, 29 Oct 2020 00:07:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=ATbSL6Q32u4F3y+QUptyo6PFRdUoUx80acnuSgpGMmo=;
        b=hyzIJ9CMLeorkUhwLFkSl7pE3kygkhjQDPTIyjp5FcNLUAfVATx3hLsdk15GzWx2Rk
         kMF95eYBRU8MvImdzPysTtpFO/xkxhlIZ6t6YFuFXyIvjfmZRpIWbLepNmq1DlOcFwao
         ogwXWVhic9IXw3u4aPk4/b3YDuvxfRu802TH4YsxF9pjFQrlbrQlnDUfZ7I5aYquMmwl
         L60uNF4T7PtdJxmTYKH5B8/CGxW7NVCMU80+1lOH6pvv99Nkf4NZtQmxKoDsNeb1UQsP
         FlZpytkQWqy/stMXccHHOIrWDlxhit+DUl/simRs6qh7WreG9ntldgftaw7JoK4lMe1n
         FC4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=ATbSL6Q32u4F3y+QUptyo6PFRdUoUx80acnuSgpGMmo=;
        b=rF550lOF49Jd/vfIUaQl7ZjNC6QtJW2w6XIH3+l7yqNYFRdZ/5RE4pcUag1Ko5tPIa
         u7aTP+8kRjZOBtk5h7g4YWb7UnKibLV81sHbI/ULJAKP1UZIkUlgo11RMm1fw0+pUe3K
         ls8GNX+dd2YOaO6vALr8l524lJx9SmPucj6ElUxQbks1KgkMQvEb6MlxXmcBQv+9qFA5
         FaHv6wYPp3kAsr2giP3bq56wDDg3CdYcIfzcDSfLHbiS93GiirUJUfeskUNT+3ZF8eZR
         T+m0CnEBeIbio1QhzCbMRewdzFS439/IBYl1NzCPgOxj6qg0VyyJbcPJ2a0Wxg243TD6
         sgwQ==
X-Gm-Message-State: AOAM532tkuNVSpE7BwW24B1AqGCKWPxhqioMheENCZ1rzVo6v5e5n0Wg
        SoKh5pdebGpwMQEW2ixZn6SvwFtgxE8=
X-Google-Smtp-Source: ABdhPJzy50VIZcnngT+sbE2ZoeTcaSNWNufGSkW2c6EYHYRU7Ii/nMRBTW1OydoqUdK3/E7WeSXCpQ==
X-Received: by 2002:a63:9508:: with SMTP id p8mr2828344pgd.189.1603955245668;
        Thu, 29 Oct 2020 00:07:25 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x29sm1712103pfp.152.2020.10.29.00.07.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Oct 2020 00:07:24 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>, gnault@redhat.com,
        pabeni@redhat.com, willemdebruijn.kernel@gmail.com
Subject: [PATCHv5 net-next 16/16] sctp: enable udp tunneling socks
Date:   Thu, 29 Oct 2020 15:05:10 +0800
Message-Id: <8100c9314e5dc5bae00e44b18328da9bef881713.1603955041.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <f07cda44f4039fac54d48ddf82ae3fda953617af.1603955041.git.lucien.xin@gmail.com>
References: <cover.1603955040.git.lucien.xin@gmail.com>
 <48053c3bf48a46899bc0130dc43adca1e6925581.1603955040.git.lucien.xin@gmail.com>
 <4f439ed717442a649ba78dc0efc6f121208a9995.1603955040.git.lucien.xin@gmail.com>
 <e7575f9fea2b867bf0c7c3e8541e8a6101610055.1603955040.git.lucien.xin@gmail.com>
 <1cfd9ca0154d35389b25f68457ea2943a19e7da2.1603955040.git.lucien.xin@gmail.com>
 <3c26801d36575d0e9c9bd260e6c1f1b67e4b721e.1603955040.git.lucien.xin@gmail.com>
 <279d266bc34ebc439114f39da983dc08845ea37a.1603955040.git.lucien.xin@gmail.com>
 <066bbdcf83188bbc62b6c458f2a0fd8f06f41640.1603955040.git.lucien.xin@gmail.com>
 <e72ab91d56df2ced82efb0c9d26d29f47d0747f7.1603955040.git.lucien.xin@gmail.com>
 <2b2703eb6a2cc84b7762ee7484a9a57408db162b.1603955040.git.lucien.xin@gmail.com>
 <1032fd094f807a870ca965e8355daf0be068008d.1603955041.git.lucien.xin@gmail.com>
 <e23bd6fddaea6641348e2115877afec5a4e2cf19.1603955041.git.lucien.xin@gmail.com>
 <88a89930e9ab2d1b2300ca81d7023feaaa818727.1603955041.git.lucien.xin@gmail.com>
 <dcea42706709242930ae2d019355f27e7ca745d3.1603955041.git.lucien.xin@gmail.com>
 <566c52da624a35533e0d0403f6218dbe9d39589c.1603955041.git.lucien.xin@gmail.com>
 <f07cda44f4039fac54d48ddf82ae3fda953617af.1603955041.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1603955040.git.lucien.xin@gmail.com>
References: <cover.1603955040.git.lucien.xin@gmail.com>
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
v4->v5:
  - Not call sctp_udp_sock_start/stop() in sctp_ctrlsock_init/exit().
  - Improve the description of udp_port in ip-sysctl.rst.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 Documentation/networking/ip-sysctl.rst | 15 ++++++++++
 net/sctp/sysctl.c                      | 52 ++++++++++++++++++++++++++++++++++
 2 files changed, 67 insertions(+)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index dad3ba9..2aaf40b 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -2642,6 +2642,21 @@ addr_scope_policy - INTEGER
 
 	Default: 1
 
+udp_port - INTEGER
+	The listening port for the local UDP tunneling sock. Normally it's
+	using the IANA-assigned UDP port number 9899 (sctp-tunneling).
+
+	This UDP sock is used for processing the incoming UDP-encapsulated
+	SCTP packets (from RFC6951), and shared by all applications in the
+	same net namespace. This UDP sock will be closed when the value is
+	set to 0.
+
+	The value will also be used to set the src port of the UDP header
+	for the outgoing UDP-encapsulated SCTP packets. For the dest port,
+	please refer to 'encap_port' below.
+
+	Default: 0
+
 encap_port - INTEGER
 	The default remote UDP encapsulation port.
 
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

