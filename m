Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B323454F06
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 22:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240909AbhKQVJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 16:09:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240718AbhKQVI5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 16:08:57 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8A66C06120C;
        Wed, 17 Nov 2021 13:05:34 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id l25so514863eda.11;
        Wed, 17 Nov 2021 13:05:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=YnUMLgDp1zo1jtmDh7aRg/AZvHUDDRU4suCv1fQWM/E=;
        b=H9ONFhmdPbc82w1+RRAq5AqXW8ukuy2z6WdNCF3TiHP0voSOaR+912jrudXH+Or5We
         mrnt2deYIgXtWQkWqJnSq1HJor658sOzVNeonat3w3phhQmY0yKNzAIQkmW+hueqg9Za
         0foeO8eF3Rs9BeGlQ6epsM835EGUZ0N8xteOBmlCiasQFeTOAJ7vM5qUmbtVrit/AFlr
         lEoYW3riM7oK1NFFEIBvSaMrU7Xg2FLni0+dtScWOvDO2hLXKAeVrSRlo0F9rWAau6YP
         rBy9K7Ylj8hwX8a+IxMikOBM5lAVY+8uvdxceGMBrSM/LucxTd1vFYa+ctFHqV+1pw3h
         5XaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YnUMLgDp1zo1jtmDh7aRg/AZvHUDDRU4suCv1fQWM/E=;
        b=5UwprFPHC88yKOlkeMuq455MHHMf44s6BzW000oVInCSe+FcL42ALbseBl6SN1Vqr2
         hf9Rym/p0MqoXf3ybhjbj7XtXw0fQzeXNYHvhOB8cn1nMOXkUGVxsT5S2BVcajjUPlmS
         5z5utQhzMl5iky5aJ8Pd9re+8MX3rvEm+ebwkXJ6gwidr94/dOU22IPG7cPUZTFNS/oT
         ZTJ6bCpN536Bwj/GYsFyE+LiPMSGsAB6VYTAF8wtGupHFZDOYTGh/HYXgerK5FLylRhE
         v7NySPTL84nyBbh8Djp9N9GjzPXFGp29wcoR8KyFzM1lAPITOW8OIm3jEVRvkrodpVtt
         3YsQ==
X-Gm-Message-State: AOAM532opV/+d7V+1sCFaJVdNjmD3DRwFFRm0UFLPUGsMXfPDLkXopVh
        s1eU4SI+dp6vcORtV2Td1VU=
X-Google-Smtp-Source: ABdhPJyMHGymr1h4ZZot9sUpAhSQqO4WfRD9qpBhGUjR7OO0NFFN79iodTQGYpnLUW5QQ4hYczgHUg==
X-Received: by 2002:a17:907:a088:: with SMTP id hu8mr26457266ejc.234.1637183133391;
        Wed, 17 Nov 2021 13:05:33 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id di4sm467070ejc.11.2021.11.17.13.05.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 13:05:33 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [net-next PATCH 16/19] net: dsa: qca8k: enable mtu_enforcement_ingress
Date:   Wed, 17 Nov 2021 22:04:48 +0100
Message-Id: <20211117210451.26415-17-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211117210451.26415-1-ansuelsmth@gmail.com>
References: <20211117210451.26415-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

qca8k have a global MTU. Inform DSA of this as the change MTU port
function checks the max MTU across all port and sets the max value
anyway as this switch doesn't support per port MTU.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index c3234988aabf..cae58753bb1f 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1315,6 +1315,9 @@ qca8k_setup(struct dsa_switch *ds)
 	/* Set max number of LAGs supported */
 	ds->num_lag_ids = QCA8K_NUM_LAGS;
 
+	/* Global MTU. Inform dsa that per port MTU is not supported */
+	ds->mtu_enforcement_ingress = true;
+
 	return 0;
 }
 
-- 
2.32.0

