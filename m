Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45C6FE2782
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 02:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407792AbfJXAtV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 20:49:21 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:40877 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407726AbfJXAtT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 20:49:19 -0400
Received: by mail-pl1-f194.google.com with SMTP id d22so10957111pll.7
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 17:49:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=oOu9mF9pYdLeAr4CFSUagq+qTmJTPEg1cD/WflVy0qI=;
        b=V7jFc2cNXdBvmT+CRAytILmvGrLquq4d/i6YnK8ByPiGimr2vSM3yyVw59MIsKf3JP
         ASWOTHrqXihF8BIxYoe4J9bPSk1NFWJk7JAbbtuK3EcSISi2hpRaRghD1hvcd5gcvWBD
         EXhtGxwG7YRrXfWrXxhEmw72UqF+ZWBSQWf3DgURBchgSP7E7I+E3KXoohBEbZmhtiAj
         dYpwfrZu7qtCyNsztw0yblyOAMpLlU2O/jJr0VEvhzz1XYUcyjYtdqaE3lcqfk4NOmu4
         91mrI54/Pzm2ID2U5lF7xBysSb+ifAcJ4l7v4en+Fpyyuy3aGIfiGgUdKuNxgMmsCJgu
         qLVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=oOu9mF9pYdLeAr4CFSUagq+qTmJTPEg1cD/WflVy0qI=;
        b=VtgT3yBtpzZ/U3nZvFnnAMZSaWE7oEEIiGcIf8TjoKd0bro9i0xxJ3FZxgplQtmGKw
         l7CzRowcY0mEWymV65zyXDgITy+fvDpCK1zxi/L49A6sUN1RHPL/0Rm7biwgYHocoJX9
         sBUzROW3lMkK19iVUnhWxJRWall1fsyyePQrjHrrZQKFx1kpRVgZPlJOumjCSkiJFxJm
         Cic+cBfEibCQxAJ/JVdW6ICRb8uir8MsYbfKDoeM5xuPZv3AJqdr2wkZQF10cp8QXQWp
         CtVHvJbNZ0dccOX43vRWU/M+K8n6xtWgEQC/adf+V7QftO9ddOPxVZLMlQvCidH58fF5
         Cm+A==
X-Gm-Message-State: APjAAAUix693banNd1a3jrWMzH3LVAFLyGL/mnNf+ECpEfe6broMyxZz
        u4PRzDQ6wLlL6QsfSJ7dEAxyvUUn4QCVeQ==
X-Google-Smtp-Source: APXvYqzLaEod5jJy1pQl3nJXxBlTOt80scpF1J+WAOFIPS7UsBUbVlD9lSnINLXQqG2PZEugsOlTWQ==
X-Received: by 2002:a17:902:b08b:: with SMTP id p11mr13176464plr.57.1571878157140;
        Wed, 23 Oct 2019 17:49:17 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id b3sm24696440pfd.125.2019.10.23.17.49.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Oct 2019 17:49:16 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 2/6] ionic: reverse an interrupt coalesce calculation
Date:   Wed, 23 Oct 2019 17:48:56 -0700
Message-Id: <20191024004900.6561-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191024004900.6561-1-snelson@pensando.io>
References: <20191024004900.6561-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the initial interrupt coalesce usec-to-hw setting
to actually be usec-to-hw.

Fixes: 780eded34ccc ("ionic: report users coalesce request")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 559b96ae48f5..cf64dea53f82 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1686,7 +1686,7 @@ static struct ionic_lif *ionic_lif_alloc(struct ionic *ionic, unsigned int index
 
 	/* Convert the default coalesce value to actual hw resolution */
 	lif->rx_coalesce_usecs = IONIC_ITR_COAL_USEC_DEFAULT;
-	lif->rx_coalesce_hw = ionic_coal_hw_to_usec(lif->ionic,
+	lif->rx_coalesce_hw = ionic_coal_usec_to_hw(lif->ionic,
 						    lif->rx_coalesce_usecs);
 
 	snprintf(lif->name, sizeof(lif->name), "lif%u", index);
-- 
2.17.1

