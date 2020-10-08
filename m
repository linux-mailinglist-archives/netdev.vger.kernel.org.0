Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D41C02871F8
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 11:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729349AbgJHJuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 05:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729335AbgJHJui (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 05:50:38 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9840BC061755;
        Thu,  8 Oct 2020 02:50:38 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id x5so2507840plo.6;
        Thu, 08 Oct 2020 02:50:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=eHKwsdD2P/4UsoU1p41NzNCp0TnmAEioXR/YlvDUq0g=;
        b=Al3wMu1SjJLKcT9vC+aZ5/bYLMNPlgrmteGUTK30+HyUq7vxNcSnqMlTZ8T68ZV60+
         viakhm0GU93UkNR/VXxLdGTjZgKETxQT/FDaYhOfl8+QF3++IC19H35Zq6E7kenhV4FZ
         KtiViO9X/RfqLbtS49dZKgvnNO03Lr0N4RS9YapAMM+2ie4VrZAXF9/XhRejgZ8JmXQZ
         gFQJjvhCnVoFXi9bKh4XVOX669rs1MrDh/Aq2ZX0Mkc/bq1TCgueWTYq7hrpSY1Dfk1c
         vNflcL99kiq87kzQgChfWXHCtD0bPrKZegCO/5LA4tJUU2shMaJ43TMehmJW4kUadWUW
         Ejgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=eHKwsdD2P/4UsoU1p41NzNCp0TnmAEioXR/YlvDUq0g=;
        b=abQ2aJbtYvdaAmsdPXxZmNI01LRUzflPErJ0ALte3WFWIjqWiGF9F2jp/82r3ikTWf
         9Q42oyIyuJCCWBfqGUPNAlGVbZ0rs1i6LzqRXQUfecS+8P7KWJcwaebQy5AbtUwHkrbs
         XX0ycOckxg/wLtRTiAchBBQ5Kb4HiB9TgCDCT805aLDoZqC58w90A4+RwnL+bUdrcPxE
         8eAVT26Ptoky3k219TG/P+d4OyLP7mK4ogpmoNsZ64IpRRpWwADwwVerXU/EaQjIHe+g
         +eVy3UePh9lIBNSYAPfFMAgx2R2oQWDPVuNWyTVKeEUvdc5JnHKZddtuSEGYAB+/Nzft
         76/w==
X-Gm-Message-State: AOAM532QUDfVizJBGZDUd5cwRehCJfbsFVNG2JOkuZ6GmBwrYoj84r46
        /f2Z6AkQw6x2OoVp2IRTiU6NnzQPAw4=
X-Google-Smtp-Source: ABdhPJwMVa1K0ZNXOsQ+a1YeCThLJ3vRAy1nKg9x2aX+KLqZifBSUuVEoS+o1Rwk+qRmDEmwiBjpCA==
X-Received: by 2002:a17:902:c3c2:b029:d3:df24:1584 with SMTP id j2-20020a170902c3c2b02900d3df241584mr7063024plj.33.1602150637897;
        Thu, 08 Oct 2020 02:50:37 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e19sm6940258pfl.135.2020.10.08.02.50.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Oct 2020 02:50:37 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net
Subject: [PATCHv2 net-next 17/17] sctp: enable udp tunneling socks
Date:   Thu,  8 Oct 2020 17:48:13 +0800
Message-Id: <8ce0fde0d093d62e8969d1788a13921ed1516ad6.1602150362.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <a0d328bcd0cc1c274305513054256a05b86c6be0.1602150362.git.lucien.xin@gmail.com>
References: <cover.1602150362.git.lucien.xin@gmail.com>
 <052acb63198c44df41c5db17f8397eeb7c8bacfe.1602150362.git.lucien.xin@gmail.com>
 <c36b016ee429980b9585144f4f9af31bcda467ee.1602150362.git.lucien.xin@gmail.com>
 <483d9eec159b22172fe04dacd58d7f88dfc2f301.1602150362.git.lucien.xin@gmail.com>
 <17cab00046ea7fe36c8383925a4fc3fbc028c511.1602150362.git.lucien.xin@gmail.com>
 <6f5a15bba0e2b5d3da6be90fd222c5ee41691d32.1602150362.git.lucien.xin@gmail.com>
 <af7bd8219b32d7f864eaef8ed8e970fc9bde928c.1602150362.git.lucien.xin@gmail.com>
 <baba90f09cbb5de03a6216c9f6308d0e4fb2f3c1.1602150362.git.lucien.xin@gmail.com>
 <bcb5453d0f8abd3d499c8af467340ade1698af11.1602150362.git.lucien.xin@gmail.com>
 <bdbd57b89b92716d17fecce1f658c60cca261bee.1602150362.git.lucien.xin@gmail.com>
 <92d28810a72dee9d0d49e7433b65027cb52de191.1602150362.git.lucien.xin@gmail.com>
 <1128490426bfb52572ba338e7a631658da49f34c.1602150362.git.lucien.xin@gmail.com>
 <ad362276ba90a8af3178f19aba15a7e67107652f.1602150362.git.lucien.xin@gmail.com>
 <1d1b2e92f958add640d5be1e6eaec1ac5e4581ce.1602150362.git.lucien.xin@gmail.com>
 <5c0e9cf835f54c11f7e3014cab926bf10a47298d.1602150362.git.lucien.xin@gmail.com>
 <8815067eea44ffd7274b0038e48c2618c2e77916.1602150362.git.lucien.xin@gmail.com>
 <a0d328bcd0cc1c274305513054256a05b86c6be0.1602150362.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1602150362.git.lucien.xin@gmail.com>
References: <cover.1602150362.git.lucien.xin@gmail.com>
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

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/protocol.c |  5 +++++
 net/sctp/sysctl.c   | 49 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+)

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
index ecc1b5e..a723613 100644
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
@@ -487,6 +498,44 @@ static int proc_sctp_do_auth(struct ctl_table *ctl, int write,
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
+		lock_sock(sk);
+		sctp_sk(sk)->udp_port = net->sctp.udp_port;
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

