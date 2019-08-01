Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59ECD7D258
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 02:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728469AbfHAApQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 20:45:16 -0400
Received: from mail-pf1-f171.google.com ([209.85.210.171]:37168 "EHLO
        mail-pf1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727348AbfHAApP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 20:45:15 -0400
Received: by mail-pf1-f171.google.com with SMTP id 19so32801612pfa.4
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 17:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kLMuijA18sh2bA/PgdoVUftIt4nGQrb6guUDBTGn8W8=;
        b=GlLRA0/JM+hBud+TABzYEDT9fqHJEIM16MI8P5w7wMC8n8TDRdWsW/NXlsFpxtHf+G
         ciTZC9/o5km3UB6wF3KIt+sCtEHgYvIl+UFqR25FUGQ1LmlJyHI5Fcd2H3weTH4Ixfaw
         H2gO1FjyBTrWZmtaRmVmXX7NlM3IEOzcA/LKbFFaatBiaYbgcCY4DgI1X+/i9mZWcG+c
         uw/tOcjoSudYF5dDXqALFgaj+YLJI54nSejvj5XyFw01Tbdh8UfHqGhXWkLxPUardggL
         o0yxB1sbtySYbvkzHmdaLmYoRmclQM+x92mEkPMCtjwpPWGOwyL6tChqvRk14PZp/gEh
         2i1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kLMuijA18sh2bA/PgdoVUftIt4nGQrb6guUDBTGn8W8=;
        b=oBXrmrOWzyicXxqkLXpMc8XE0VLsOoA5kN0H4MryNVd//zBEoaBcAB4N2X73CXYdMO
         L82Bc8uNNhUlDJtU70xdROUQz7iC4iEoqkG6FOn60pRellhm/bB7S+cXfEa+xHwulOzG
         WJM8nTqACyRQ4kU3OQKsfdfbvtzUsM925UjvZsZveSIhTiSXeI3+CI18RfIYJeqOZYcj
         BNM/MqBXs1c+1lq1Af2kHeVqkvDTHsdeyPYzzeYWhVkoWHtBZZnGADsAnxO/lkBFKzer
         QNJoqfD+8oB5pDeEJb7BQXR60OuQ//bByd7cN4EGIVE6YCA8y+VXkXe1IEVgPTAwC/Or
         T42g==
X-Gm-Message-State: APjAAAVis8lQ+0jbpZA/MwcfMujRSTve/e4QSnblpwvDY1WW82iANW1x
        T+bZy5Kyd846iIkEV39XXfw=
X-Google-Smtp-Source: APXvYqz8IyDEZoNzvrMrSuGf/k5nVmwKtGEcNzKgav+hGWW0i4KSiTzQBBYmZTC/k8vzqYUl3ogIBw==
X-Received: by 2002:a17:90a:9a95:: with SMTP id e21mr5453460pjp.98.1564620314820;
        Wed, 31 Jul 2019 17:45:14 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id f32sm2435978pgb.21.2019.07.31.17.45.14
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 31 Jul 2019 17:45:14 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     jiri@resnulli.us, chrism@mellanox.com
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [RFC iproute2 2/4] Revert "tc: flush after each command in batch mode"
Date:   Wed, 31 Jul 2019 17:45:04 -0700
Message-Id: <20190801004506.9049-3-stephen@networkplumber.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190801004506.9049-1-stephen@networkplumber.org>
References: <20190801004506.9049-1-stephen@networkplumber.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit d66fdfda71e4a30c1ca0ddb7b1a048bef30fe79e.
---
 tc/tc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tc/tc.c b/tc/tc.c
index 1f23971ae4b9..c115155b2234 100644
--- a/tc/tc.c
+++ b/tc/tc.c
@@ -405,7 +405,6 @@ static int batch(const char *name)
 
 		err = do_cmd(largc, largv, tail == NULL ? NULL : tail->buf,
 			     tail == NULL ? 0 : sizeof(tail->buf));
-		fflush(stdout);
 		if (err != 0) {
 			fprintf(stderr, "Command failed %s:%d\n", name,
 				cmdlineno - 1);
-- 
2.20.1

