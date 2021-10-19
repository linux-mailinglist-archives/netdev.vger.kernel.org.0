Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 270054330C4
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 10:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234545AbhJSIK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 04:10:28 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:50731 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234803AbhJSIKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 04:10:14 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 85A2D5C00EF;
        Tue, 19 Oct 2021 04:08:01 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 19 Oct 2021 04:08:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=IO4P8Iu1MZvyNlbatn0TsBSKiXjm3K8y8hunwwtGb0s=; b=iRRSB+MU
        HF/QWScvZ/z3SIGsGEzeciANKzYOkvtrqpYiYYsreCK9y5XnZYM+4xAhWKY80voS
        4kYn8+rNEiKo8OOEAJ2N2MfRicp9Di7DFg5TA+0vqqNsxop04A6OzXRGc5B6T9QI
        EQvvBy9lB8gNM9qrwcI6dfQ44MzUV/UfZNip/MUeQpNlwf7YCypSvzjv0Ne7ICDy
        Tbl6DUBSxrqyHdutbLSGQBfJTSLdD+D28xIgJPk5Y57Ybyy5tMLoAIGpl6HbPi3w
        Tg1sOuInGUTZrvv3wQjiBnfBBtLyxQv69hvf+kGANSDYiuUp2uQri6H5Z/i4Tu2h
        noMDzhzopdMiOQ==
X-ME-Sender: <xms:4XxuYTti5oxi-Ec4kywD3l5ZmaNCRTiqtVm3-Z0Npj5M9C_hLXaVkA>
    <xme:4XxuYUfxsvrehkR2i2wIwDX7PTUHOR1XHzCgS-pG-TEDgMbyefiRKYz9CEsF0E1zf
    ANV4PraJ9s3TYc>
X-ME-Received: <xmr:4XxuYWzdynlKwS71ugrGIVoCxRgBERWaR0f9Gy_9ISMCRY0Bh7vIQa_7B1Az6K4ojF2D4_PGOs9pxK7LMyPbTNL9WcB6LwYSg15SD7L9NXE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddvuddguddvhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpedtnecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:4XxuYSO7wipT7WomqppZofdewlE54svUsiCxXe9n1P36YpkWfT5ANw>
    <xmx:4XxuYT_kkkNbipJhpxMFXc-coAo93BHkL6WpIUOg2e3kQxpzPlQgyg>
    <xmx:4XxuYSVllktn9n5IxXDtpYkSeoYMZrWT_Gb052XCednNn7KJYWpzTg>
    <xmx:4XxuYTzMbOG1G4exQ50hYl6W7LsEuq9ws1XQyScM76gBFpDl7me34g>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 19 Oct 2021 04:07:58 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 1/9] net: sch_tbf: Add a graft command
Date:   Tue, 19 Oct 2021 11:07:04 +0300
Message-Id: <20211019080712.705464-2-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211019080712.705464-1-idosch@idosch.org>
References: <20211019080712.705464-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

As another qdisc is linked to the TBF, the latter should issue an event to
give drivers a chance to react to the grafting. In other qdiscs, this event
is called GRAFT, so follow suit with TBF as well.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 include/net/pkt_cls.h |  2 ++
 net/sched/sch_tbf.c   | 16 ++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 4a5833108083..193f88ebf629 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -977,6 +977,7 @@ enum tc_tbf_command {
 	TC_TBF_REPLACE,
 	TC_TBF_DESTROY,
 	TC_TBF_STATS,
+	TC_TBF_GRAFT,
 };
 
 struct tc_tbf_qopt_offload_replace_params {
@@ -992,6 +993,7 @@ struct tc_tbf_qopt_offload {
 	union {
 		struct tc_tbf_qopt_offload_replace_params replace_params;
 		struct tc_qopt_offload_stats stats;
+		u32 child_handle;
 	};
 };
 
diff --git a/net/sched/sch_tbf.c b/net/sched/sch_tbf.c
index 78e79029dc63..72102277449e 100644
--- a/net/sched/sch_tbf.c
+++ b/net/sched/sch_tbf.c
@@ -184,6 +184,20 @@ static int tbf_offload_dump(struct Qdisc *sch)
 	return qdisc_offload_dump_helper(sch, TC_SETUP_QDISC_TBF, &qopt);
 }
 
+static void tbf_offload_graft(struct Qdisc *sch, struct Qdisc *new,
+			      struct Qdisc *old, struct netlink_ext_ack *extack)
+{
+	struct tc_tbf_qopt_offload graft_offload = {
+		.handle		= sch->handle,
+		.parent		= sch->parent,
+		.child_handle	= new->handle,
+		.command	= TC_TBF_GRAFT,
+	};
+
+	qdisc_offload_graft_helper(qdisc_dev(sch), sch, new, old,
+				   TC_SETUP_QDISC_TBF, &graft_offload, extack);
+}
+
 /* GSO packet is too big, segment it so that tbf can transmit
  * each segment in time
  */
@@ -547,6 +561,8 @@ static int tbf_graft(struct Qdisc *sch, unsigned long arg, struct Qdisc *new,
 		new = &noop_qdisc;
 
 	*old = qdisc_replace(sch, new, &q->qdisc);
+
+	tbf_offload_graft(sch, new, *old, extack);
 	return 0;
 }
 
-- 
2.31.1

