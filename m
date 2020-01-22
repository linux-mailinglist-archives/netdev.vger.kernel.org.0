Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8D0145B7F
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 19:22:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728709AbgAVSW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 13:22:56 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:38878 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbgAVSW4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 13:22:56 -0500
Received: by mail-pl1-f196.google.com with SMTP id t6so114162plj.5
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 10:22:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=R8o/e98Y1o4b0t9zPieroZgdORNBdpNL7fXG7tccg/Q=;
        b=BsqcFup7gaCa4lLtBZcFGZLTZ7VGBqmIW1xpOtICll3LlHz77YGtXZW0Jong932lB7
         +gvv+b4ZoWZ91ckKtSNL5W+eZvC5tRXjoXx5A0mcXQv+JmR5bDCmNcGgIePivlLrO/sH
         Mt8agSyXeaPRcDFo1rn5dQRI2qOKePyi7sc/ILpmt1Sy41DKdwXMTY2xptRN1zjy4TGt
         cP+dFzovq3DNl6uxcZ7nhV+ndfXJlP8LlblQZ8tzVVOTrrZK4ujS377AzBo20m+3B9d4
         9VdZMjLiLz+GWPTJiMFAl6WbAYK+nUA5tWiWpf6EkL6E568PHckpYjh4PcewwVsqfpp/
         29VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=R8o/e98Y1o4b0t9zPieroZgdORNBdpNL7fXG7tccg/Q=;
        b=NxtD5jVQlzYBJDjIM4ys35I0CgOogGco84WqFPA8PoVAlsEkX9Vi/pHFo3+7xtZZ/M
         y1PkFEiKE/YqJQTcK4dVU7QxKl7INdQSCMGoGqJuCGuYQbnGoGAEhiplPv6akq303SJ4
         q/jyY/FYKEEvKdxaFdEIEu+wcTE8SEOZFb+svz8c6ZtcgI6uqefA4MvFpbxTSCLB7z9V
         bY9zyCIc41swQsPyBCaNp2S1rD6gby1/ScIkzvn6W/jhmLQxJN1pKOn49mFAlXsptsOH
         wAyOL/mvJKd1RpjmguAgtoeMJUHz24ruhbePMgifXI4t5/55ruNcy8w01MFtPmi8sx/9
         4yGQ==
X-Gm-Message-State: APjAAAVCNuBhF7+gZocjwBMBEHHznoRmfZ2TRWhbEuIguzroDqa78qIY
        NeVS6PHP1guexlrX/TrJtJZhp7t34xtaq7qf
X-Google-Smtp-Source: APXvYqxXNyY/8ORF2JeKK7wqSh/ftTmntjOTq7YgxMlIKKHiDaSqtdK2+mNNzxXLu0qyYjnRMrK90A==
X-Received: by 2002:a17:90b:11d7:: with SMTP id gv23mr4527265pjb.94.1579717375510;
        Wed, 22 Jan 2020 10:22:55 -0800 (PST)
Received: from localhost.localdomain ([223.186.203.82])
        by smtp.gmail.com with ESMTPSA id o17sm3996532pjq.1.2020.01.22.10.22.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 10:22:55 -0800 (PST)
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
Subject: [PATCH net-next v7 02/10] pie: use U64_MAX to denote (2^64 - 1)
Date:   Wed, 22 Jan 2020 23:52:25 +0530
Message-Id: <20200122182233.3940-3-gautamramk@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200122182233.3940-1-gautamramk@gmail.com>
References: <20200122182233.3940-1-gautamramk@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>

Use the U64_MAX macro to denote the constant (2^64 - 1).

Signed-off-by: Mohit P. Tahiliani <tahiliani@nitk.edu.in>
Signed-off-by: Leslie Monis <lesliemonis@gmail.com>
Signed-off-by: Gautam Ramakrishnan <gautamramk@gmail.com>
---
 include/net/pie.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/pie.h b/include/net/pie.h
index 440213ec83eb..7ef375db5bab 100644
--- a/include/net/pie.h
+++ b/include/net/pie.h
@@ -10,8 +10,8 @@
 
 #define QUEUE_THRESHOLD 16384
 #define DQCOUNT_INVALID -1
-#define DTIME_INVALID 0xffffffffffffffff
-#define MAX_PROB 0xffffffffffffffff
+#define DTIME_INVALID U64_MAX
+#define MAX_PROB U64_MAX
 #define PIE_SCALE 8
 
 /* parameters used */
-- 
2.17.1

