Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05EADF3FAD
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 06:21:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730151AbfKHFUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 00:20:55 -0500
Received: from mail-pl1-f180.google.com ([209.85.214.180]:34931 "EHLO
        mail-pl1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730040AbfKHFUz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 00:20:55 -0500
Received: by mail-pl1-f180.google.com with SMTP id s10so3287203plp.2;
        Thu, 07 Nov 2019 21:20:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=jYn8k5LzKsb+FnPYAGr58+mcelF1Igy8/c8FJgw1PYY=;
        b=fo1WKP1lBjD3PJhycTD/pxN7TQTDaJv+gNx7zchRcKXeoRN6Y4bJBNRsg2puKDOAlk
         0vtZoNOefzJWIvBjSt/NN02PWu11zXQu3ch4ZHR3tNFdkhitGpWjxUyBKIpIjaonQVtp
         QrFUsJbqJylbuww9KVPAni273EqQ9yXxFKWMSrX9bD9TtuwNbCGwWeD7YRQyhaQ1q6/d
         hs+TUZfC0r8vs91Kaxwfx3IhfJheopKIP4i6f2N0Hc8YMFQ2M8h3naiWNd8DOIAHMFbl
         0tbRkmZDv8NQSYBLGQ36IpX6arfXLrlRu4BO2RJr6+asDk3mWQ6EPKMoNg+w7t/TYycd
         BNjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=jYn8k5LzKsb+FnPYAGr58+mcelF1Igy8/c8FJgw1PYY=;
        b=Gi14ZI17Te428eNizfkYxX5Yp/PAMlJpp/jiOW3S4pIsRv5dMwPrEWlLdW1CUSyxz+
         dyfT6FugoSW+lQIhr4vBqGl2uxErc9plqg7gaAsmeysrAxpxOadq20VdUudogY/BCXKF
         +4bwmY8A1x1WzYrWmu8S6Kugk4cFtjWx3kr8xJi4xquYJR4ZI5kfiQNqFWCVpv72xGKJ
         3NC2s6YEt1vBOUWz99OPZGldCxWacjdlxlYSUd2vbVIpCEoX85u2IrY4lw7bY/Yk46yt
         1IhfRL/Fm9ytwM4s88RDUBgArZ8hzRjzq2LyNcj+TEbrO+S7qXc44OnETXbm3rvSzXxU
         9K3A==
X-Gm-Message-State: APjAAAU8jUeBsRJiMJua1p1dg8+kCKZ9fO5KLoixlFZYm65vnxmTN3CS
        yg70IbMjeNANO4ykFnjPt2BgcWrW
X-Google-Smtp-Source: APXvYqzEMVM+vHN/6lx7GAS5Kov3jiZ0fX8asQOrKNqR5X0g0dAEy3tWPkY+EMNqSHVhEyDgh21lAQ==
X-Received: by 2002:a17:902:59d9:: with SMTP id d25mr4903059plj.250.1573190453876;
        Thu, 07 Nov 2019 21:20:53 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 193sm5190809pfv.18.2019.11.07.21.20.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Nov 2019 21:20:53 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net,
        David Laight <david.laight@aculab.com>
Subject: [PATCHv4 net-next 1/5] sctp: add pf_expose per netns and sock and asoc
Date:   Fri,  8 Nov 2019 13:20:32 +0800
Message-Id: <d008eb59f963118ae264e0151da79c382f16a69b.1573190212.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1573190212.git.lucien.xin@gmail.com>
References: <cover.1573190212.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1573190212.git.lucien.xin@gmail.com>
References: <cover.1573190212.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As said in rfc7829, section 3, point 12:

  The SCTP stack SHOULD expose the PF state of its destination
  addresses to the ULP as well as provide the means to notify the
  ULP of state transitions of its destination addresses from
  active to PF, and vice versa.  However, it is recommended that
  an SCTP stack implementing SCTP-PF also allows for the ULP to be
  kept ignorant of the PF state of its destinations and the
  associated state transitions, thus allowing for retention of the
  simpler state transition model of [RFC4960] in the ULP.

Not only does it allow to expose the PF state to ULP, but also
allow to ignore sctp-pf to ULP.

So this patch is to add pf_expose per netns, sock and asoc. And in
sctp_assoc_control_transport(), ulp_notify will be set to false if
asoc->expose is not 'enabled' in next patch.

It also allows a user to change pf_expose per netns by sysctl, and
pf_expose per sock and asoc will be initialized with it.

Note that pf_expose also works for SCTP_GET_PEER_ADDR_INFO sockopt,
to not allow a user to query the state of a sctp-pf peer address
when pf_expose is 'disabled', as said in section 7.3.

v1->v2:
  - Fix a build warning noticed by Nathan Chancellor.
v2->v3:
  - set pf_expose to UNUSED by default to keep compatible with old
    applications.
v3->v4:
  - add a new entry for pf_expose on ip-sysctl.txt, as Marcelo suggested.
  - change this patch to 1/5, and move sctp_assoc_control_transport
    change into 2/5, as Marcelo suggested.
  - use SCTP_PF_EXPOSE_UNSET instead of SCTP_PF_EXPOSE_UNUSED, and
    set SCTP_PF_EXPOSE_UNSET to 0 in enum, as Marcelo suggested.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
---
 Documentation/networking/ip-sysctl.txt | 22 ++++++++++++++++++++++
 include/net/netns/sctp.h               |  8 ++++++++
 include/net/sctp/constants.h           | 10 ++++++++++
 include/net/sctp/structs.h             |  2 ++
 include/uapi/linux/sctp.h              |  1 +
 net/sctp/associola.c                   |  1 +
 net/sctp/protocol.c                    |  3 +++
 net/sctp/socket.c                      | 13 +++++++++++--
 net/sctp/sysctl.c                      | 10 ++++++++++
 9 files changed, 68 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
index 49e95f4..ad374b4 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -2088,6 +2088,28 @@ pf_enable - INTEGER
 
 	Default: 1
 
+pf_expose - INTEGER
+	Unset or enable/disable pf (pf is short for potentially failed) state
+	exposure.  Applications can control the exposure of the PF path state
+	in the SCTP_PEER_ADDR_CHANGE event and the SCTP_GET_PEER_ADDR_INFO
+	sockopt.   When it's unset, no SCTP_PEER_ADDR_CHANGE event with
+	SCTP_ADDR_PF state will be sent and a SCTP_PF-state transport info
+	can be got via SCTP_GET_PEER_ADDR_INFO sockopt;  When it's enabled,
+	a SCTP_PEER_ADDR_CHANGE event will be sent for a transport becoming
+	SCTP_PF state and a SCTP_PF-state transport info can be got via
+	SCTP_GET_PEER_ADDR_INFO sockopt;  When it's diabled, no
+	SCTP_PEER_ADDR_CHANGE event will be sent and it returns -EACCES when
+	trying to get a SCTP_PF-state transport info via SCTP_GET_PEER_ADDR_INFO
+	sockopt.
+
+	0: Unset pf state exposure, Compatible with old applications.
+
+	1: Disable pf state exposure.
+
+	2: Enable pf state exposure.
+
+	Default: 0
+
 addip_noauth_enable - BOOLEAN
 	Dynamic Address Reconfiguration (ADD-IP) requires the use of
 	authentication to protect the operations of adding or removing new
diff --git a/include/net/netns/sctp.h b/include/net/netns/sctp.h
index bdc0f27..18c3dda 100644
--- a/include/net/netns/sctp.h
+++ b/include/net/netns/sctp.h
@@ -97,6 +97,14 @@ struct netns_sctp {
 	int pf_enable;
 
 	/*
+	 * Disable Potentially-Failed state exposure, ignored by default
+	 * pf_expose	-  0  : compatible with old applications (by default)
+	 *		-  1  : disable pf state exposure
+	 *		-  2  : enable  pf state exposure
+	 */
+	int pf_expose;
+
+	/*
 	 * Policy for preforming sctp/socket accounting
 	 * 0   - do socket level accounting, all assocs share sk_sndbuf
 	 * 1   - do sctp accounting, each asoc may use sk_sndbuf bytes
diff --git a/include/net/sctp/constants.h b/include/net/sctp/constants.h
index 823afc4..e88b77a 100644
--- a/include/net/sctp/constants.h
+++ b/include/net/sctp/constants.h
@@ -286,6 +286,16 @@ enum { SCTP_MAX_GABS = 16 };
 				 * functions simpler to write.
 				 */
 
+/* These are the values for pf exposure, UNUSED is to keep compatible with old
+ * applications by default.
+ */
+enum {
+	SCTP_PF_EXPOSE_UNSET,
+	SCTP_PF_EXPOSE_DISABLE,
+	SCTP_PF_EXPOSE_ENABLE,
+};
+#define SCTP_PF_EXPOSE_MAX	SCTP_PF_EXPOSE_ENABLE
+
 /* These return values describe the success or failure of a number of
  * routines which form the lower interface to SCTP_outqueue.
  */
diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 503fbc3..9a43738 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -215,6 +215,7 @@ struct sctp_sock {
 	__u32 adaptation_ind;
 	__u32 pd_point;
 	__u16	nodelay:1,
+		pf_expose:2,
 		reuse:1,
 		disable_fragments:1,
 		v4mapped:1,
@@ -2053,6 +2054,7 @@ struct sctp_association {
 
 	__u8 need_ecne:1,	/* Need to send an ECNE Chunk? */
 	     temp:1,		/* Is it a temporary association? */
+	     pf_expose:2,       /* Expose pf state? */
 	     force_delay:1;
 
 	__u8 strreset_enable;
diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
index 6bce7f9..765f41a 100644
--- a/include/uapi/linux/sctp.h
+++ b/include/uapi/linux/sctp.h
@@ -933,6 +933,7 @@ struct sctp_paddrinfo {
 enum sctp_spinfo_state {
 	SCTP_INACTIVE,
 	SCTP_PF,
+#define	SCTP_POTENTIALLY_FAILED		SCTP_PF
 	SCTP_ACTIVE,
 	SCTP_UNCONFIRMED,
 	SCTP_UNKNOWN = 0xffff  /* Value used for transport state unknown */
diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 1ba893b..4cadff5 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -86,6 +86,7 @@ static struct sctp_association *sctp_association_init(
 	 */
 	asoc->max_retrans = sp->assocparams.sasoc_asocmaxrxt;
 	asoc->pf_retrans  = sp->pf_retrans;
+	asoc->pf_expose   = sp->pf_expose;
 
 	asoc->rto_initial = msecs_to_jiffies(sp->rtoinfo.srto_initial);
 	asoc->rto_max = msecs_to_jiffies(sp->rtoinfo.srto_max);
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 08d14d8..f86be7b 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1220,6 +1220,9 @@ static int __net_init sctp_defaults_init(struct net *net)
 	/* Enable pf state by default */
 	net->sctp.pf_enable = 1;
 
+	/* Ignore pf exposure feature by default */
+	net->sctp.pf_expose = SCTP_PF_EXPOSE_UNSET;
+
 	/* Association.Max.Retrans  - 10 attempts
 	 * Path.Max.Retrans         - 5  attempts (per destination address)
 	 * Max.Init.Retransmits     - 8  attempts
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 939b8d2..669e02e 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -5041,6 +5041,7 @@ static int sctp_init_sock(struct sock *sk)
 	sp->hbinterval  = net->sctp.hb_interval;
 	sp->pathmaxrxt  = net->sctp.max_retrans_path;
 	sp->pf_retrans  = net->sctp.pf_retrans;
+	sp->pf_expose   = net->sctp.pf_expose;
 	sp->pathmtu     = 0; /* allow default discovery */
 	sp->sackdelay   = net->sctp.sack_timeout;
 	sp->sackfreq	= 2;
@@ -5521,8 +5522,16 @@ static int sctp_getsockopt_peer_addr_info(struct sock *sk, int len,
 
 	transport = sctp_addr_id2transport(sk, &pinfo.spinfo_address,
 					   pinfo.spinfo_assoc_id);
-	if (!transport)
-		return -EINVAL;
+	if (!transport) {
+		retval = -EINVAL;
+		goto out;
+	}
+
+	if (transport->state == SCTP_PF &&
+	    transport->asoc->pf_expose == SCTP_PF_EXPOSE_DISABLE) {
+		retval = -EACCES;
+		goto out;
+	}
 
 	pinfo.spinfo_assoc_id = sctp_assoc2id(transport->asoc);
 	pinfo.spinfo_state = transport->state;
diff --git a/net/sctp/sysctl.c b/net/sctp/sysctl.c
index 238cf17..5d1ad44 100644
--- a/net/sctp/sysctl.c
+++ b/net/sctp/sysctl.c
@@ -34,6 +34,7 @@ static int rto_alpha_min = 0;
 static int rto_beta_min = 0;
 static int rto_alpha_max = 1000;
 static int rto_beta_max = 1000;
+static int pf_expose_max = SCTP_PF_EXPOSE_MAX;
 
 static unsigned long max_autoclose_min = 0;
 static unsigned long max_autoclose_max =
@@ -318,6 +319,15 @@ static struct ctl_table sctp_net_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
+	{
+		.procname	= "pf_expose",
+		.data		= &init_net.sctp.pf_expose,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= &pf_expose_max,
+	},
 
 	{ /* sentinel */ }
 };
-- 
2.1.0

