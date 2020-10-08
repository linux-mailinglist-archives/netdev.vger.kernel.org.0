Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 586D7287832
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731420AbgJHPw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731413AbgJHPwz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:52:55 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D19B4C061755;
        Thu,  8 Oct 2020 08:52:55 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id r21so1293184pgj.5;
        Thu, 08 Oct 2020 08:52:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=h28qh/0UzImVlEE/u3b4voL2HJ3HMccs4Vkpw5CMmh4=;
        b=nRsFPXegGHGZ6A/78nvdpB/Yu7sKC/ba459JMPpi0kF6RWsfJy/5eCah8GWvBEmm9h
         tbofCzH9oOW4Fj0kc9VkmlqQytUqgIhvuf5xzED0Nb2Z5rNnKXOrQuXIQyWfZqrHUsWJ
         vnNQSr7Mmg+Uk+C9NzgzVPOPgMe46tv3kcOwpQNnQalk93wA0PmGKkNH0Ze+PAZnITIL
         MN235eIE9HAV1CcY3FX6LUBDakqoPOgtmv3GD+3/cerYfmvWMyFK/obC+gBFMLKnh22d
         fFtpGcPQV6YtN7Qp4yqFks2uH5q23nNbsm+Ywq3FAucF1t8h6NHnkp8kEZ/+FdSVFcHm
         YxKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=h28qh/0UzImVlEE/u3b4voL2HJ3HMccs4Vkpw5CMmh4=;
        b=WCwT3r4g+eM8+6Y3E7HYdzHZ+gMZ0iFSNYIx4VmWKwfwYtaYutdp8NDycGJiLfNzbe
         z03ei6jh7kn5LtbBjCDCSQS76ZWp6YLqU+joLkBibO8r6tlYNDUn2ippa7kSSQs3udwP
         zTMYtpBBSfhGQksO0TNuYyRbreYqPBWLZA9qc4Dq4bbKP18JK0CLspPLxoiyfGj8n/SE
         Pvy0hfKwaUPto5KbqazmIe+ANu1ZIRxcYIM6LVK7ndsJh9cKhbx83NWwqDZXFIaYyvR/
         kyQyOWRmJ7sCin5mw7a31Qjhz4WKbgrMoP8OyPGXBbqLXztRw3jdsm4WsBZtU1PJ7lTR
         ugrQ==
X-Gm-Message-State: AOAM530CpzGp2agVrm4pwxbrw4FxiKKzy+JgrPvC4nABA7GI9pcXv98W
        SgRId+IyjH82K7Ov0wPCyT8TJ3/o9r8=
X-Google-Smtp-Source: ABdhPJxoXgA0eFLwWonuXfMX5tz1hKZClV4HtIfsDIHi0anuLincyoqVff4h4LzhL5jus7odclstjA==
X-Received: by 2002:a63:c0b:: with SMTP id b11mr8165694pgl.416.1602172375357;
        Thu, 08 Oct 2020 08:52:55 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.52.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:52:54 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 011/117] mac80211: set aqm_ops.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:50:23 +0000
Message-Id: <20201008155209.18025-11-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 9399b86c0e9a ("mac80211: add debug knobs for fair queuing")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/mac80211/debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 669d7e13ffe8..e2675db7490b 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -149,6 +149,7 @@ static const struct file_operations aqm_ops = {
 	.read = aqm_read,
 	.open = simple_open,
 	.llseek = default_llseek,
+	.owner = THIS_MODULE,
 };
 
 static ssize_t airtime_flags_read(struct file *file,
-- 
2.17.1

