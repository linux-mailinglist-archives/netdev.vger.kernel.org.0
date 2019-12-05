Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 425F21149A5
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 00:05:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726233AbfLEXE6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 18:04:58 -0500
Received: from mta-p6.oit.umn.edu ([134.84.196.206]:43870 "EHLO
        mta-p6.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725926AbfLEXE6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 18:04:58 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-p6.oit.umn.edu (Postfix) with ESMTP id 47TWWs13wWz9vBt9
        for <netdev@vger.kernel.org>; Thu,  5 Dec 2019 23:04:57 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p6.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p6.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Sy2jpBia1WE0 for <netdev@vger.kernel.org>;
        Thu,  5 Dec 2019 17:04:57 -0600 (CST)
Received: from mail-yb1-f198.google.com (mail-yb1-f198.google.com [209.85.219.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p6.oit.umn.edu (Postfix) with ESMTPS id 47TWWr6y4yz9vJyQ
        for <netdev@vger.kernel.org>; Thu,  5 Dec 2019 17:04:56 -0600 (CST)
Received: by mail-yb1-f198.google.com with SMTP id d191so1076939ybc.17
        for <netdev@vger.kernel.org>; Thu, 05 Dec 2019 15:04:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=MO10ke4bfA3Py2gapxPNJKqGZHjnWV9jw2bft4Kl1Hw=;
        b=B7gtMaEsF7Gm1FvHzVvdDonAn4mJJufpl+R6jt6JwtloKhiJ2BTcl4HXrVKOWhaX2J
         RzhOI9pXAhvHTojPFUzsuiN38kaBDjGpVWv0cM91qOpGlpDBXSIQIQv5VM2gsWDwplyH
         5V9wlLATp57c4WRZa4Etk8ylhUTa4US0bNXyCTdGaXNB65jnlXyhMJz5EryAVeLUWPZk
         h35YybOW4aeq+/fTPr5nh9es/lP2e8uxTEW+Fs4VSlKkVw7Em6tWWMoZeoc1NhAtXEwk
         Lx0OUm3R3zm7rCYIUWXpch7UOaBj6MWZdomcE59iPm8mi4rQYhzHsnQ8/nUcnrkiM/qo
         8Ccw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=MO10ke4bfA3Py2gapxPNJKqGZHjnWV9jw2bft4Kl1Hw=;
        b=T641GJJEmRAx4x5CM7KoRoR5BvHgMn8WHYC/Yfc9OYnjzmOTFPGHeV9Sdd63IrsddW
         x0KaszPpyoXvc4WUBLfs73KtJFVE4Kc03afC2CNqKyB9I1DSeBkHVngMQzr94WP42zaC
         ElJlh1+jCKK3BsD17r6VIFi3Wh1ECZMQhKPuRA/Vt10+OHFy9UwU3teufUZ+sJpE+hrG
         aKVZ+mm8hrAFkQPGkK/qmc8cypQfP5tsOm8soDTzO5+dQVd3MfRyRdOy2cV3BBjPMG+r
         rn5IlLJdhTjKL7JHLEeF254kjgOZclwj0y5AfAsO4FMlhKmnobNSAwuauimoKduxpPyz
         JdXQ==
X-Gm-Message-State: APjAAAWejU5isGh2XH5Sn66wkSJJnsnOIj/J3EynGgwbaRD6b4Y0XiYb
        07gAML43A65jPy4G73XDlX+AJUTpbDNlNcZxpYji9TmoHQ738xa4vt3HIRqprjVGdXWv75F/JAC
        /8Z+NQ4M+XxxWt5YWFUSf
X-Received: by 2002:a81:9243:: with SMTP id j64mr8238805ywg.513.1575587096448;
        Thu, 05 Dec 2019 15:04:56 -0800 (PST)
X-Google-Smtp-Source: APXvYqwg4ZN3+3krbx0S3IP2LY3Snyl3L4I6iUCuEMzgHmgR9YsTyF09HdZ2EYtDKvwy4ASNs5xVfQ==
X-Received: by 2002:a81:9243:: with SMTP id j64mr8238786ywg.513.1575587096210;
        Thu, 05 Dec 2019 15:04:56 -0800 (PST)
Received: from cs-u-syssec1.dtc.umn.edu (cs-u-syssec1.cs.umn.edu. [128.101.106.66])
        by smtp.gmail.com with ESMTPSA id u136sm5057802ywf.101.2019.12.05.15.04.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Dec 2019 15:04:55 -0800 (PST)
From:   Aditya Pakki <pakki001@umn.edu>
To:     pakki001@umn.edu
Cc:     kjlu@umn.edu, Michal Ostrowski <mostrows@earthlink.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] pppoe: remove redundant BUG_ON() check in pppoe_pernet
Date:   Thu,  5 Dec 2019 17:04:49 -0600
Message-Id: <20191205230450.8614-1-pakki001@umn.edu>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Passing NULL to pppoe_pernet causes a crash via BUG_ON.
Dereferencing net in net_generici() also has the same effect. This patch
removes the redundant BUG_ON check on the same parameter.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
---
 drivers/net/ppp/pppoe.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ppp/pppoe.c b/drivers/net/ppp/pppoe.c
index a44dd3c8af63..d760a36db28c 100644
--- a/drivers/net/ppp/pppoe.c
+++ b/drivers/net/ppp/pppoe.c
@@ -119,8 +119,6 @@ static inline bool stage_session(__be16 sid)
 
 static inline struct pppoe_net *pppoe_pernet(struct net *net)
 {
-	BUG_ON(!net);
-
 	return net_generic(net, pppoe_net_id);
 }
 
-- 
2.17.1

