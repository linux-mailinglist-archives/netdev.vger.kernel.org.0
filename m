Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 294812A603E
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 10:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728902AbgKDJIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 04:08:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728851AbgKDJGc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 04:06:32 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05125C061A4A
        for <netdev@vger.kernel.org>; Wed,  4 Nov 2020 01:06:32 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id x7so21205905wrl.3
        for <netdev@vger.kernel.org>; Wed, 04 Nov 2020 01:06:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=szFDNNaKEVDZSNkDXGPen7gT5j56LfEHgacJ/wxEkwY=;
        b=N/4knhJ7uTG/9yLA1FSuCU1flqXLayCobZP7LJXfq0bxqg/f2LQPv0S3+gwUmPrlvH
         ZcTQ8cmH725ndJazq3KjmCYX/gRdGKIjWOqFDqJ6Ca3yHBeMCHLvqP7MbavdbqsWv3p7
         tp/mtcK62uAtazyujW3FsYwtTv4ejBYtpMZufYjm5/EBuvnxhGiyARiEFh4oHYBpof1m
         FLMvr9ZE4WvZuj6VUoTmr+5MZIXNoqFQDTh/Kl6S82TH08rzQYQ/zWqOYCHsy8sFvrDU
         fZFsELF54BVdt4TghACs9PCg0x+aj2lcb0j+QMwz5ImUWToz4/E/k+BHprYQ7ZeD/4CF
         aBsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=szFDNNaKEVDZSNkDXGPen7gT5j56LfEHgacJ/wxEkwY=;
        b=biFORNsBmk/AxkDn0vZNEsk+WhdxPfaA2GKEwLj4/aadl4lHpfDJiQJY62d0zY1DIn
         ama2toSWxZdXGybLaf3H10+q7/bVWMesEBM44O+ZYPWSf39+5bET4su8baa83Je5w0xW
         9i1Vp2N31Rm8N9oU9BVci4wjvIqjxsgQt4zQgUprCNV/8Wxdid2xfcjn+ssFJt8MUujM
         zr5Y+ncUuFoDuwAHTyCGTvGlVvnUvjW/Awsr0WPLyR3LJXWCIFcnokBTKCw/LzIn0qyN
         mLRnOQSKqEpRdvngOFTeYjB764pGyNPI/nGP5hdTfZYX0uuUKk5treZL3ge0pjTqlyPE
         UqKw==
X-Gm-Message-State: AOAM532A6Nj+KQ6fcemwrU36WQvpw8Q9Ww4qRPMEnMx1YUmDkUVXJ+ap
        kqnzzqms4hnwUdrJP1+F82ac7A==
X-Google-Smtp-Source: ABdhPJzIJXs0rqnpGfYOPLHG8ZWucjsENoRrdaQl4vWak5XVOqN2jes5DesM6dPTbX7FugMpqk+Mjg==
X-Received: by 2002:adf:80c8:: with SMTP id 66mr31727752wrl.415.1604480790781;
        Wed, 04 Nov 2020 01:06:30 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id e25sm1607823wrc.76.2020.11.04.01.06.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 01:06:30 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        netdev@vger.kernel.org
Subject: [PATCH 06/12] net: ethernet: ti: am65-cpsw-qos: Demote non-conformant function header
Date:   Wed,  4 Nov 2020 09:06:04 +0000
Message-Id: <20201104090610.1446616-7-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201104090610.1446616-1-lee.jones@linaro.org>
References: <20201104090610.1446616-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/ethernet/ti/am65-cpsw-qos.c:364: warning: Function parameter or member 'ndev' not described in 'am65_cpsw_timer_set'
 drivers/net/ethernet/ti/am65-cpsw-qos.c:364: warning: Function parameter or member 'est_new' not described in 'am65_cpsw_timer_set'

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/ethernet/ti/am65-cpsw-qos.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-qos.c b/drivers/net/ethernet/ti/am65-cpsw-qos.c
index 3bdd4dbcd2ff1..ebcc6386cc34a 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-qos.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-qos.c
@@ -356,7 +356,7 @@ static void am65_cpsw_est_set_sched_list(struct net_device *ndev,
 		writel(~all_fetch_allow & AM65_CPSW_FETCH_ALLOW_MSK, ram_addr);
 }
 
-/**
+/*
  * Enable ESTf periodic output, set cycle start time and interval.
  */
 static int am65_cpsw_timer_set(struct net_device *ndev,
-- 
2.25.1

