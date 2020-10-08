Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2C7287834
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731429AbgJHPxA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:53:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730244AbgJHPw7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:52:59 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09F89C061755;
        Thu,  8 Oct 2020 08:52:59 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id x16so4664249pgj.3;
        Thu, 08 Oct 2020 08:52:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Nudno0TMLbF93fxV9Luc8mIVBi0MtdHbJiPr3hJsn2M=;
        b=Mn2U7bOAw/FYl1MXq+kt29l1xgdRiXRbaRIGdrK6EtlG+ehdbPjvN+eoL4+SR8TSLC
         SY3rgknzJnVU5QIf660pUp38Im1P+kiqw1FLFXb/ZyaET+KFUJ3PK3G603y8SF0kbRWE
         4E4rFPJMpjnX9NyvV9+ER6V3k/H9WY5YNEd/DYCiS3qIMdFxISx4ww7avvoJignvetPN
         SMSnh+WIup30A0NfNTSxPliToeE+uTiPepi2sl0xojvNMJ71p7lxbv0ZgvIfncBrpJ9K
         6xXTIcLs4r7EvfhtuPG38aVTAhMNk8V54oBfvuj2d9pirh2QIjZiZkTS1sIUYFV8Kobu
         xdkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Nudno0TMLbF93fxV9Luc8mIVBi0MtdHbJiPr3hJsn2M=;
        b=q1kcxv5qjsGNKKnFS1aRzuAt9muLQeM2ycuRK/K1n5gAqGqw4AzWxfFDexWYp8SPwd
         6PSZUAXRqGok80hhGx+Abkqh6IQxJ1Ngfsjq37VOncoSnJ+7NlJy5g+NmVhI/uEggG/c
         zBFddPPK0/5dMij2wfopo0r57V5IKm8vhBjxpr99Ww5QkF39dcbUdl/iL++YmvVNNrv4
         cWxWf4OczZR3k5itCR3uErA658BMdNg9DdU/Mav/cdFphKcUzxi2QA1D7vM50er2tyF8
         GhG40maP3LfK/LXztm3tBMAnRTP2gPa5Il15WSQCfQRxSHQSqWIi+TZOCSyzZMiLhvyM
         8vqw==
X-Gm-Message-State: AOAM531Epj7mqJUZEQ6OIbaXDDaG7k3S1HE06evuR2AG1nDn8KpicWIj
        GROdcn9IyzH03d/9JkSbi4M=
X-Google-Smtp-Source: ABdhPJxwh0STCfQ58bRKqTza1Mv1kG0ToeekCMXy/6xh5ZuMTgHVh1b/xIpMl9QvrZ2ywnjp+3KTzA==
X-Received: by 2002:a63:4c43:: with SMTP id m3mr7766462pgl.19.1602172378420;
        Thu, 08 Oct 2020 08:52:58 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.52.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:52:57 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 012/117] mac80211: debugfs: set airtime_flags_ops.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:50:24 +0000
Message-Id: <20201008155209.18025-12-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: e322c07f8371 ("mac80211: debugfs: improve airtime_flags handler readability")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/mac80211/debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index e2675db7490b..794892fe6622 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -203,6 +203,7 @@ static const struct file_operations airtime_flags_ops = {
 	.read = airtime_flags_read,
 	.open = simple_open,
 	.llseek = default_llseek,
+	.owner = THIS_MODULE,
 };
 
 static ssize_t aql_txq_limit_read(struct file *file,
-- 
2.17.1

