Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40714145B81
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 19:23:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728827AbgAVSXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 13:23:06 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46323 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbgAVSXG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 13:23:06 -0500
Received: by mail-pf1-f195.google.com with SMTP id n9so217904pff.13
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 10:23:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=lLPfkaHUdJk91hEn7ISh5HhzYqtAwjmDshBoNiXJGwM=;
        b=pqh/hUj/OID2qAYXnmxMGKaTa7eFYta1drhRmJ2YkDt2b/svjhq0QPu4c6Guv5f5sB
         OAImgAUxYlQlO+prD5ikmYr/BCGEC2mQI2gfKO66KNM1M/0ecO95IU1SdiOvRYEhfgCm
         Ny2LUvygvavfqmy24kndspxFwrQSGt4q6guWeZm4eDvWP/T6E+iVUVm3PWJRgPfCOkDM
         a7QcPYsVYW3JaH330PXTGef6dbmRXWoBBL333BTlvq066dJTUoBPL2Z3fs2N5vD2D6Wu
         +SFX19kk3Ehy3w/St/pIiZbxIxXbel2RwBpoqyWiUsKYviq4I9QDwuQH1vnd5+2ICoeP
         jcmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=lLPfkaHUdJk91hEn7ISh5HhzYqtAwjmDshBoNiXJGwM=;
        b=i1jvi7YKyHFg8AkDI/zx38/qj3f60C6brxiCSm5DHhFoOz/OVY8mXAjYL5KXnaCyqo
         UXHmhB0edf25+li++ImmlPD2t6wWThq/O9uQg66WMOUKYLw5X8nNOkRue0w/6ZQYtANj
         FF7wL5ZJ2p9y7Mode5quuENkbOwwF5K4CV0ZvdmvQT+6NPzVM5Rs48ZmM+agJRXu9hoU
         aFPrL7LVxMBYBTd9TGInx0e1qsjppl+gwFN2WjJ5d/sesytzqNIKEN5IiLwSTB2ByDyZ
         1VsYZvvZcNtBs+7sdmDJ+feoM923deAhH8AcOYQHzMQyiSLOikDH2z1Ujh2OqVM2aeQD
         aUuA==
X-Gm-Message-State: APjAAAVo42/4Vs4RO27K0A20ytOadQtbkCC645fWimp1rqD2NxFIgfpa
        qYilGz5lVfYrq8NnO6xJj2D1pQjW60x/oqb2
X-Google-Smtp-Source: APXvYqxbZR4ZDUqmZG/ZPNt/U+VW8HDx+AuVo1tHbqbsWyTZ6il1tK8CD0iPF3Xtkx7yxcF4yEM5cA==
X-Received: by 2002:a62:53c3:: with SMTP id h186mr3731194pfb.118.1579717385218;
        Wed, 22 Jan 2020 10:23:05 -0800 (PST)
Received: from localhost.localdomain ([223.186.203.82])
        by smtp.gmail.com with ESMTPSA id o17sm3996532pjq.1.2020.01.22.10.23.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 10:23:04 -0800 (PST)
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
Subject: [PATCH net-next v7 04/10] pie: use u8 instead of bool in pie_vars
Date:   Wed, 22 Jan 2020 23:52:27 +0530
Message-Id: <20200122182233.3940-5-gautamramk@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200122182233.3940-1-gautamramk@gmail.com>
References: <20200122182233.3940-1-gautamramk@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>

Linux best practice recommends using u8 for true/false values in
structures.

Signed-off-by: Mohit P. Tahiliani <tahiliani@nitk.edu.in>
Signed-off-by: Leslie Monis <lesliemonis@gmail.com>
Signed-off-by: Gautam Ramakrishnan <gautamramk@gmail.com>
---
 include/net/pie.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/pie.h b/include/net/pie.h
index 397c7abf0879..f9c6a44bdb0c 100644
--- a/include/net/pie.h
+++ b/include/net/pie.h
@@ -21,8 +21,8 @@ struct pie_params {
 	u32 limit;		/* number of packets that can be enqueued */
 	u32 alpha;		/* alpha and beta are between 0 and 32 */
 	u32 beta;		/* and are used for shift relative to 1 */
-	bool ecn;		/* true if ecn is enabled */
-	bool bytemode;		/* to scale drop early prob based on pkt size */
+	u8 ecn;			/* true if ecn is enabled */
+	u8 bytemode;		/* to scale drop early prob based on pkt size */
 	u8 dq_rate_estimator;	/* to calculate delay using Little's law */
 };
 
-- 
2.17.1

