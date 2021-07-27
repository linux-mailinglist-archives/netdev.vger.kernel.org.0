Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE3C3D7C70
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 19:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231805AbhG0Rn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 13:43:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231200AbhG0Rnv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 13:43:51 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4956DC0613CF
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 10:43:51 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d1so9350312pll.1
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 10:43:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ZA2IzpdOyxIMsdJwDWeKgKu82j6q1PMQCVPMwrsTtMA=;
        b=aIJ3KGdesWxTkqUYqU0zok12rvYANjEeGQg8lcfWjfHIAXDPbPjBO0ukKNtVAtKqGg
         i8/zz+G7GLxvidkPAQauo5r9kqztAQLLISEOiqDAkw4k9lt/1hC2aYDab9rysbbpKtYM
         OS9mey1jlFYRXhiQL++Ldth0U1r/fekxchCM9upBnH5jAnU8B9bCgEzYXfRZPMffx4hc
         ZJo1DSD5nKZsWMWuwq09EO5O4PMCq567xvvu7bGjcuAj8mo+pAkuPm9ZCL1vdOKh704v
         4j2ofQpJLYP3BlyyeW5xvOK4FOS9gpsE3O/+PkQHtQPYanqvK86LiQOKD12RZXHY8Wjc
         j/9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ZA2IzpdOyxIMsdJwDWeKgKu82j6q1PMQCVPMwrsTtMA=;
        b=R16TWF5oBcbJjrVBHW86zTbU5M+40SyGeGskfim2ikI7CgR0/9+z5yoHABixZ1Pquy
         l7asXieCHXErSAk7VX5sA45BsQxRQbLxpcrjYWzyCENeJWcrrj0WnXEMlYHHOCZKbctb
         wLRMQlpcWL5JqLvUXbbl9EEaytn6GjjpyikE96eCoK1Myw/ZF8P/sXc4iQFk173s52zd
         C5dICT4gImVGh0aUB3jHZIZZh+FBZEsSCKZs6b5E3R9Uh5gAQfwjCaoFLYvLhar9hYhV
         IywR+chzqBljN198fQnweJCH121m1F1FhcJneNe65x91S9xfLjRB4g6drLPdzbQSsbGI
         hTiA==
X-Gm-Message-State: AOAM533ki1myy39esZw5bcDGgeJNMhuAIn7pV54KQcz1XgWsSIWtAbZC
        ixACWfnTUnoHJZu5zhZH8yCKOJfHyKLQ3w==
X-Google-Smtp-Source: ABdhPJwAq0ok4r1m1LSOXKHtkhBW0/tbKqUxsk9LvIWMketKYf6BITv9wNmq32aXYLlDxd1di7w4tg==
X-Received: by 2002:a62:ee0f:0:b029:335:a681:34f6 with SMTP id e15-20020a62ee0f0000b0290335a68134f6mr24049321pfi.55.1627407830896;
        Tue, 27 Jul 2021 10:43:50 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id t9sm4671944pgc.81.2021.07.27.10.43.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 10:43:50 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 07/10] ionic: remove unneeded comp union fields
Date:   Tue, 27 Jul 2021 10:43:31 -0700
Message-Id: <20210727174334.67931-8-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210727174334.67931-1-snelson@pensando.io>
References: <20210727174334.67931-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We don't use these fields, so remove them from
the definition.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_dev.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index 8945aeda1b4c..8311086fb1f4 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -161,8 +161,6 @@ struct ionic_dev {
 struct ionic_cq_info {
 	union {
 		void *cq_desc;
-		struct ionic_txq_comp *txcq;
-		struct ionic_rxq_comp *rxcq;
 		struct ionic_admin_comp *admincq;
 		struct ionic_notifyq_event *notifyq;
 	};
-- 
2.17.1

