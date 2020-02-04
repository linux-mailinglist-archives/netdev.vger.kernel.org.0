Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53273151F7E
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 18:31:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727484AbgBDRb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 12:31:29 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:39306 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727310AbgBDRb2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 12:31:28 -0500
Received: by mail-qt1-f195.google.com with SMTP id c5so14937400qtj.6
        for <netdev@vger.kernel.org>; Tue, 04 Feb 2020 09:31:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1LfEcHC2k6UzQ3OMzdtEdKqTZvWj45+OQsBOVs2ohCg=;
        b=pr4pXn7VAeINQFh+BmBdxoOtQFGXy4mSviRrKqUZdjB4y1r0VXeTcWRITW6J0XEg8x
         nLBwXKEoDFOoboEeSU5fEDmI3BFpwJmRIH5bt3ebIeTEbGM+YoN4ivNcfljzm9gl/G49
         cy1W279Bpxdzw7djdxxc7I9V+YnSWYVK2v6ffiQMdEaOZ+roVXjrAsmiAPyefESy3Bds
         SH/3SODFNXJicQy2RbFKZF76CQ3wKoOCs1D1fp3m1MXlmZLE5aaNuMMQLjk9N7SWdzey
         0gqk8qbqSYutdqm6pma7X+a17Hy9xhza/Y5KmVm7xzw44LF+4TxzAVjvwaeTSe+EZwdT
         9gXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1LfEcHC2k6UzQ3OMzdtEdKqTZvWj45+OQsBOVs2ohCg=;
        b=em6VVJdEW3LDUzPv3SYVSu8CDDtdtAo2FrCPBg1vAfiQNX5AnqLda5iePBSw84kyu1
         1L/EUr6zqiVPk4tA8pMZS6AOlJBkETsElE5JWyxVY79k5vdf8nhVzXyP+sthHjt18kKz
         dRllCWzIvWxHSSwSVWYCMbGO0UCFYnRJDOtY4UCDIrzSzjr7jDJ4bRFvM2hiLvBk/YsU
         SThxToyszZbKcUY0iQBJe3tzocxAxXhCTIxLmCZ9jbZ1Xk+m3UMbjMV/zkF/i6NGsDd1
         GIjvpbKmmFSlxnmInZnMelFU7YXaeJTMgTjGS3oC4f80GtVXbM8WlPOwDV1czSLAsd8w
         IT5A==
X-Gm-Message-State: APjAAAXg/4zuaDH86yzCwr+KDZbzkVKYIXAdYkTEwY/FvLY4oIK0XV9W
        62GcDcn62FIOvjBszVYYeVQ=
X-Google-Smtp-Source: APXvYqxmq9qAAvWgK/DwH+Oo8/T6g7h60r1Gkj3HNXYrDOqkfp5t6yohupzgueT/A7IVJXigEc0aoA==
X-Received: by 2002:ac8:7b9b:: with SMTP id p27mr30133747qtu.2.1580837485970;
        Tue, 04 Feb 2020 09:31:25 -0800 (PST)
Received: from localhost.localdomain ([45.72.237.143])
        by smtp.gmail.com with ESMTPSA id m54sm12466623qtf.67.2020.02.04.09.31.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2020 09:31:25 -0800 (PST)
From:   Alexander Aring <alex.aring@gmail.com>
To:     davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org, andrea.mayer@uniroma2.it,
        dav.lebrun@gmail.com, mcr@sandelman.ca, stefan@datenfreihafen.org,
        Alexander Aring <alex.aring@gmail.com>
Subject: [PATCH net 2/2] net: ipv6: seg6_local: don't set headroom
Date:   Tue,  4 Feb 2020 12:30:19 -0500
Message-Id: <20200204173019.4437-3-alex.aring@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200204173019.4437-1-alex.aring@gmail.com>
References: <20200204173019.4437-1-alex.aring@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The headroom value only need to be set on tunnels before Layer 3 like
mpls. Remove it from seg6_local because it's in Layer 3.

Signed-off-by: Alexander Aring <alex.aring@gmail.com>
---
 net/ipv6/seg6_local.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
index 7cbc19731997..3b77184edf2b 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -37,7 +37,6 @@ struct seg6_action_desc {
 	int action;
 	unsigned long attrs;
 	int (*input)(struct sk_buff *skb, struct seg6_local_lwt *slwt);
-	int static_headroom;
 };
 
 struct bpf_lwt_prog {
@@ -55,7 +54,6 @@ struct seg6_local_lwt {
 	int oif;
 	struct bpf_lwt_prog bpf;
 
-	int headroom;
 	struct seg6_action_desc *desc;
 };
 
@@ -603,7 +601,6 @@ static struct seg6_action_desc seg6_action_table[] = {
 		.action		= SEG6_LOCAL_ACTION_END_B6_ENCAP,
 		.attrs		= (1 << SEG6_LOCAL_SRH),
 		.input		= input_action_end_b6_encap,
-		.static_headroom	= sizeof(struct ipv6hdr),
 	},
 	{
 		.action		= SEG6_LOCAL_ACTION_END_BPF,
@@ -677,8 +674,6 @@ static int parse_nla_srh(struct nlattr **attrs, struct seg6_local_lwt *slwt)
 	if (!slwt->srh)
 		return -ENOMEM;
 
-	slwt->headroom += len;
-
 	return 0;
 }
 
@@ -952,7 +947,6 @@ static int parse_nla_action(struct nlattr **attrs, struct seg6_local_lwt *slwt)
 		return -EOPNOTSUPP;
 
 	slwt->desc = desc;
-	slwt->headroom += desc->static_headroom;
 
 	for (i = 0; i < SEG6_LOCAL_MAX + 1; i++) {
 		if (desc->attrs & (1 << i)) {
@@ -1004,7 +998,6 @@ static int seg6_local_build_state(struct nlattr *nla, unsigned int family,
 
 	newts->type = LWTUNNEL_ENCAP_SEG6_LOCAL;
 	newts->flags = LWTUNNEL_STATE_INPUT_REDIRECT;
-	newts->headroom = slwt->headroom;
 
 	*ts = newts;
 
-- 
2.20.1

