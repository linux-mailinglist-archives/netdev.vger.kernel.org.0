Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B321143F08
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 15:13:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728811AbgAUON2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 09:13:28 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:35837 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727059AbgAUON2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 09:13:28 -0500
Received: by mail-pf1-f195.google.com with SMTP id i23so1579506pfo.2
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 06:13:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Koo9oYgCLFqTmfRexnYrMar9O2Y7tkdHqNHY1KP94GM=;
        b=kaQfXK5kpkYlCNUEVALPaX1AungE115WE8CVXGusoSrjlX5d/Y+faxCvFtGqMQYICm
         HawsRpgOs59J5SLRityMTyfNyJQn5esgmqp3rKtJRgKxurtA7Hcwg9q4mdZx/dLu+MUC
         OJXaMcwTaHSwVKUsJd4/ujebyA3VZyGt5qCZtHi/Bb1gFLiC45lLH2hHVOOgO6BGo0p4
         a3HH42cO/cVefosgtRRBRJO43m0ypot3vryeCY5ftxDw/giU4OhrO02+FhgSYvQG4q9y
         D8KChg5DB4gu7xWPlE2vtjhi7Txt7xLu6q/yqC2r9yd9BUOwkaMEqbOKCuxsnr7+yLK+
         E3tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Koo9oYgCLFqTmfRexnYrMar9O2Y7tkdHqNHY1KP94GM=;
        b=GeDjOlj580EWHZBRqxV6KH9qnkLoM50W05yaAFKfS3Yj0OulN62I1HPgiGxTm9bX0j
         36N7gzUju5SOkEVAwjOxbSJ33JyM9sWo5b90sBC0dMdZCwjr2zsDTJhhnepnQLvvNcdS
         n7kqshvDcsfEAf2sH3laMTgMCVRQ75iBwSqh+42e7lyPINMFNmZ2SX9MErbjFDRJ27su
         7LDKGK+SdLdcS6a5sN1aV3JXkK7hw4BsDGdBDhf89Na1Yc8OT2cIuIMcP2N2Urbe5rV5
         Y1+46GKcnZxlN/K5axYqkMSUqmHldzaSM4/DW16Fm20yNkXxtD703atwcOPLA0hTs87D
         IW6w==
X-Gm-Message-State: APjAAAU982HFSYvy/nAvkqDT2wUTsr49Tl7PAE/bBYus9JBPqCGoXc1Q
        LDwl7mj7NMWZk4+KEFI529Mk6RjEfQvTGQ==
X-Google-Smtp-Source: APXvYqy7R8adZuPzcngyywI72HLvptoIKAJueNOX0ZbCKMDjk0ymSNcHwHjr9Ba5LqFJD+HgYkBRfg==
X-Received: by 2002:a63:d502:: with SMTP id c2mr5780841pgg.46.1579616007063;
        Tue, 21 Jan 2020 06:13:27 -0800 (PST)
Received: from localhost.localdomain ([223.186.212.224])
        by smtp.gmail.com with ESMTPSA id y203sm44836443pfb.65.2020.01.21.06.13.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2020 06:13:26 -0800 (PST)
From:   gautamramk@gmail.com
To:     netdev@vger.kernel.org
Cc:     "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S . Miller" <davem@davemloft.net>,
        Dave Taht <dave.taht@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Leslie Monis <lesliemonis@gmail.com>,
        Gautam Ramakrishnan <gautamramk@gmail.com>
Subject: [PATCH net-next v4 05/10] pie: rearrange structure members and their initializations
Date:   Tue, 21 Jan 2020 19:42:44 +0530
Message-Id: <20200121141250.26989-6-gautamramk@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200121141250.26989-1-gautamramk@gmail.com>
References: <20200121141250.26989-1-gautamramk@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>

Rearrange the members of the structures such that they appear in
order of their types. Also, change the order of their
initializations to match the order in which they appear in the
structures. This improves the code's readability and consistency.

Signed-off-by: Mohit P. Tahiliani <tahiliani@nitk.edu.in>
Signed-off-by: Leslie Monis <lesliemonis@gmail.com>
Signed-off-by: Gautam Ramakrishnan <gautamramk@gmail.com>
---
 include/net/pie.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/net/pie.h b/include/net/pie.h
index f9c6a44bdb0c..54ba6c6a7514 100644
--- a/include/net/pie.h
+++ b/include/net/pie.h
@@ -28,13 +28,13 @@ struct pie_params {
 
 /* variables used */
 struct pie_vars {
-	u64 prob;		/* probability but scaled by u64 limit. */
 	psched_time_t burst_time;
 	psched_time_t qdelay;
 	psched_time_t qdelay_old;
-	u64 dq_count;		/* measured in bytes */
 	psched_time_t dq_tstamp;	/* drain rate */
+	u64 prob;		/* probability but scaled by u64 limit. */
 	u64 accu_prob;		/* accumulated drop probability */
+	u64 dq_count;		/* measured in bytes */
 	u32 avg_dq_rate;	/* bytes per pschedtime tick,scaled */
 	u32 qlen_old;		/* in bytes */
 	u8 accu_prob_overflows;	/* overflows of accu_prob */
@@ -56,11 +56,11 @@ struct pie_skb_cb {
 
 static inline void pie_params_init(struct pie_params *params)
 {
-	params->alpha = 2;
-	params->beta = 20;
+	params->target = PSCHED_NS2TICKS(15 * NSEC_PER_MSEC);	/* 15 ms */
 	params->tupdate = usecs_to_jiffies(15 * USEC_PER_MSEC);	/* 15 ms */
 	params->limit = 1000;	/* default of 1000 packets */
-	params->target = PSCHED_NS2TICKS(15 * NSEC_PER_MSEC);	/* 15 ms */
+	params->alpha = 2;
+	params->beta = 20;
 	params->ecn = false;
 	params->bytemode = false;
 	params->dq_rate_estimator = false;
@@ -68,12 +68,12 @@ static inline void pie_params_init(struct pie_params *params)
 
 static inline void pie_vars_init(struct pie_vars *vars)
 {
-	vars->dq_count = DQCOUNT_INVALID;
+	/* default of 150 ms in pschedtime */
+	vars->burst_time = PSCHED_NS2TICKS(150 * NSEC_PER_MSEC);
 	vars->dq_tstamp = DTIME_INVALID;
 	vars->accu_prob = 0;
+	vars->dq_count = DQCOUNT_INVALID;
 	vars->avg_dq_rate = 0;
-	/* default of 150 ms in pschedtime */
-	vars->burst_time = PSCHED_NS2TICKS(150 * NSEC_PER_MSEC);
 	vars->accu_prob_overflows = 0;
 }
 
-- 
2.17.1

