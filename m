Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D61528791A
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731873AbgJHP54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:57:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731929AbgJHP5o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:57:44 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3F1CC061755;
        Thu,  8 Oct 2020 08:57:44 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id w21so4343949pfc.7;
        Thu, 08 Oct 2020 08:57:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VzmpAj3/XydPcNzFnXx4Q2UcRZu6Ce5O73ll1dCz4ho=;
        b=m/iCZrSKXpxkTgzjwKsdwGuPDjMQOgY52x3yeBwI7NDJLmIR26tZ3HYpJs0RjhhZi/
         3hWT9Y8R4GduQQ2U7MWqFTnir3+bzxKHbt1P4ZmTY2niaG9YWlDHTeHi2h7h1U7JxbUC
         OLlezOS4++WmV4wudIQfOPMGm4NDFVwAVvTGIzmiC1x7mKPomAJxrpOmfB/oFF9MmifR
         A4QX5Q3Lh3mmJhmKnoDHTM1z4Q5TaZzU72Ajo47aKXy3nQvrk1wvofaLeD6io4hdDNhW
         VhylhbIKJvJ8syOVbD0HtZ+zkDDl50FjjXTRn3dibE9PJFR0B4r/EslDgeKkE5unzx0x
         zaEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VzmpAj3/XydPcNzFnXx4Q2UcRZu6Ce5O73ll1dCz4ho=;
        b=LbgIOEsW7hSj3AjSIP5r0ZmvTxI1ROuV4c/0EX2NHY4KH3zErJhwy4+066BcjVsvSs
         Bs4TrPEwz5Gxs0EcaxfH755FsX0DIP9HRvsMr5FEOGK5UFQU1vxtUq8HMKlCIgl2s6m4
         qfqHK4NoThw3dRngJn8FCe+OmWs/AvIOhI3tb7WJTo+kZN1PBUgtZ9azwFU4FFXMA3Ft
         t72IcZw7hPMA6PVPIaLgPnLrtDxAI0fYFvrMoNeu1pPbxNynW8+GatQyZJZ+nqGSXH1N
         YGjH5ujxIzyb1ksdpuHsyVh8GORXgbBmw38zQ8qqfLU5Urh05Qe/kwdDjBq76HKNZA6N
         N0Sw==
X-Gm-Message-State: AOAM5312klifElkAfZpMkoyP4v0Oxq//HHxHoZhcYJKCcsQdBsoAbtVw
        /CqQhEoyr1hkkSKIVJglRDPASlvBojA=
X-Google-Smtp-Source: ABdhPJyEPVEqtT72hdr3zBzaofj0lbgKL4SSMjqt1hcNmO7OYZmwCeFQPFUEZC4jLrLbkGLQ56zoMQ==
X-Received: by 2002:a63:703:: with SMTP id 3mr7834032pgh.159.1602172664430;
        Thu, 08 Oct 2020 08:57:44 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.57.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:57:43 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 104/117] mt76: set fops_tx_stats.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:51:56 +0000
Message-Id: <20201008155209.18025-104-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: e57b7901469f ("mt76: add mac80211 driver for MT7915 PCIe-based chipsets")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
index 38f473d587c9..31ac338c5526 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
@@ -234,6 +234,7 @@ static const struct file_operations fops_tx_stats = {
 	.read = seq_read,
 	.llseek = seq_lseek,
 	.release = single_release,
+	.owner = THIS_MODULE,
 };
 
 static int mt7915_read_temperature(struct seq_file *s, void *data)
-- 
2.17.1

