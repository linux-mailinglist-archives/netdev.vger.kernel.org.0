Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C61DB287855
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731523AbgJHPxh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:53:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731507AbgJHPxd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:53:33 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40132C061755;
        Thu,  8 Oct 2020 08:53:33 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id y14so4626147pgf.12;
        Thu, 08 Oct 2020 08:53:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=mmvCzbbj3ToRI3pSoyPBiaY4so5rk1xRmVzeycxsTt4=;
        b=nJTcwzqKjPHT8EOdYap9MYAOyauIWk2p8EVmJWhkj6iGNnitv8oCBvnS80Avz4R4EJ
         7Zp9C/TSi9JVo2E4JtNeBI30OO6L6rI05m8KjU2xpIzZPmgFQQRi8p9rcPxGO5fHzUSk
         DS7H59/yLjUUE/+86wyoK+y1KuswHcjZBuVD1n7mesUaWxpFjhoSBymLbKCbKzkK6d8Z
         dsagoIbezMCMeyWIkbitsqcNENjXvWYX139kHYel1hYG56IOuJtQgtrwidUwVjvVdhqo
         ROd+cKNZdz5+Cj3yvj63zUTMRNrpHdPbgJ458Y2+hh8z5oKfJy1VUAlopCnM1sU3t5Vi
         X0cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=mmvCzbbj3ToRI3pSoyPBiaY4so5rk1xRmVzeycxsTt4=;
        b=t0Cd0tOSLVljKQM17kyZinuHo+qcB2zh60TNWIcr7gpb5xMewRFyD9F6EbbsXgyQgZ
         3POyIAL0j0Aaa+j5Z9HVfM3OvzTijSWWVtosMbsq2tQddMiH2auIWSWrksXlrXytWm2i
         FeJlcQ7ISaLInB1rWzLrpWH9XXxnSmo8Wflr29osJlXVt2DPRPA00OHdxZDdzhNxk2DS
         O4BlGR6HF3M0VDLWVKdumottzfAUvlz/q+kTu2PwR3Zrl4CMn044aN/4tQgpoDbLLQUu
         kXhrucBsRQIj5UxqhJOWMhHaSQ+VcTr3P1O/lVNOGxbWQ3vI9tan7INynrCUSPpxbaEt
         yCCw==
X-Gm-Message-State: AOAM532F0qdLD8bjAjMWgpWwKh50z9eEv0HtoUev+GNbyWDk6LpJ05Qq
        NVP0NmrlUes2Dd96lEVL1ynYNAsT5jk=
X-Google-Smtp-Source: ABdhPJynJM22ztW5ocmwcbe994yqqIqvamTFbMjrnbocyhm/n4dIfO8Kd9neDxME0GjNaWeTUmsSBQ==
X-Received: by 2002:a17:90a:1704:: with SMTP id z4mr8753175pjd.7.1602172412849;
        Thu, 08 Oct 2020 08:53:32 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.53.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:53:32 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 023/117] netdevsim: set nsim_udp_tunnels_info_reset_fops.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:50:35 +0000
Message-Id: <20201008155209.18025-23-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 424be63ad831 ("netdevsim: add UDP tunnel port offload support")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/netdevsim/udp_tunnels.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/netdevsim/udp_tunnels.c b/drivers/net/netdevsim/udp_tunnels.c
index 22c06a76033c..2482b0f80b2f 100644
--- a/drivers/net/netdevsim/udp_tunnels.c
+++ b/drivers/net/netdevsim/udp_tunnels.c
@@ -119,6 +119,7 @@ static const struct file_operations nsim_udp_tunnels_info_reset_fops = {
 	.open = simple_open,
 	.write = nsim_udp_tunnels_info_reset_write,
 	.llseek = generic_file_llseek,
+	.owner = THIS_MODULE,
 };
 
 int nsim_udp_tunnels_info_create(struct nsim_dev *nsim_dev,
-- 
2.17.1

