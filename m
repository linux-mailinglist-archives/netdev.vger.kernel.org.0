Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D166FE0D3F
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 22:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389066AbfJVUb0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 16:31:26 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:38582 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731256AbfJVUbZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 16:31:25 -0400
Received: by mail-pg1-f196.google.com with SMTP id w3so10636297pgt.5
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 13:31:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=oOu9mF9pYdLeAr4CFSUagq+qTmJTPEg1cD/WflVy0qI=;
        b=BavnNv+eY3Rm1/GlwYLl3SWKkKZm8EP8ojFuRk+4Uju/E0sop9PZGqjKLNE/kd8MUs
         bIyJpiYaE1VeWhfNb1JDTAaxrj0lzEfI0xkHaazi+EXCSA5xDRa4k7CWH9KnAu38ogSs
         dcVy2EAu3UWr1jYw90c8Uykn4jrK2bKOF7FMxKLyHxfgVhDcOIwYPCCbmA/S3K91R7cz
         1sgKn/NfEsxeLd3dgI3xASS2wWFhr3UJ41gimLwedvNGI8Bih32F7gVybtROztULVNZH
         yIbYwdBzvLjJEOrEiIwIg/bvd6Z1ORa8/BixI4x0WrWfFvZVCEq6vrWsdB+i4HkDNiFu
         5ltg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=oOu9mF9pYdLeAr4CFSUagq+qTmJTPEg1cD/WflVy0qI=;
        b=sjXids7fFa5HNwq6SP8w1aqs24qu9zEzHmEVAw9YhFJwHEbWdan+zFDqd5aWNyCrUI
         FycoSxdXu/5XMakk+SIWOU9rojR7LalRXWDzGEk755zykK8M89pmkKo9G6gbVtSSEvkz
         meHHiGHH+M5WwZoWaBur6Y0kvfX8dqOzmmZ9894f6rEwYR8q922fAyKVWLVMLcny0prj
         bRf8CzRii/B2P17sUWe31h9HMvt8m2Ez44uJxgFqkw4E3JDk+o2nzAlxj9/7fHetGt6Q
         ydwt9sc8eam5io+ffOfe2EHogpWfPjbg2vv9EURQDSfUkvcbTQ51M8KUoXQDqnfNYgw6
         m/6w==
X-Gm-Message-State: APjAAAVWqQ3hesxmwNbrf0kP1Y1d42Tw1ql4e4jDfGgiFKEdikcBigLW
        5IpdzqFHA+z9BWxb9z8HVvEvEtgx6L9AFw==
X-Google-Smtp-Source: APXvYqxz3AaOUp2Fm0DMyjPTUkVCLXKzdgKsElMrYUd2+5BWIKpUVao3XhEVfgj9iIdRJo4k5qd7og==
X-Received: by 2002:a62:35c4:: with SMTP id c187mr6423539pfa.125.1571776284795;
        Tue, 22 Oct 2019 13:31:24 -0700 (PDT)
Received: from driver-dev1.pensando.io.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id q143sm20754530pfq.103.2019.10.22.13.31.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Oct 2019 13:31:24 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 2/6] ionic: reverse an interrupt coalesce calculation
Date:   Tue, 22 Oct 2019 13:31:09 -0700
Message-Id: <20191022203113.30015-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191022203113.30015-1-snelson@pensando.io>
References: <20191022203113.30015-1-snelson@pensando.io>
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

