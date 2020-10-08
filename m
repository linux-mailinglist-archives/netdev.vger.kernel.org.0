Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4C8928792D
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731942AbgJHP5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730970AbgJHP4z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:56:55 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02114C061755;
        Thu,  8 Oct 2020 08:56:55 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id o25so4682117pgm.0;
        Thu, 08 Oct 2020 08:56:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0zIsMJt7nMSPYfhqvNOhy588R8B7b1fBm6xS2B2jQIY=;
        b=FSWzHUoPiDqhvaPRKOBdsq6b3u1pRNdYQC7taGIwxFp7NqG5xIOSj0M1Gn5aitKLHL
         CBWqwcr6xk5R+aQVFCdv9+dVnnmkCtRiGbAh4hKdVISjYVcGR2miDdOvblyRc4UnNzt+
         1tfp661aoGp08kTcBXftZuvqezGhMOfpYFYdAqOVoKZ5DzXm84miLfDt8RoS0vIGqKSl
         nu5rzDroLfRmUMZw+JAgfIIl2J2h7WsgHL/gi/ysaSctq7dHO8pNBrpHQW2Fmhdqga7X
         r0pWywhTzP6paxPvR4Hz0ZEM+CaO8Pd0q2xU92+Eh+jb8ub++URuYCPHP73B+WL+gDg7
         QyiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0zIsMJt7nMSPYfhqvNOhy588R8B7b1fBm6xS2B2jQIY=;
        b=RUdphhI6X5iBKjildr6CelY32o7+D7GUMDduhEmfwMVwQU1b2s+hEHkJOmCJ56zwFh
         Lf/u0gIQ23hedqAVopQOmzbEiRjmJIeGpQ4cObE3UfnDaua/JPxdpNf7SDAKXtfqPs96
         AuAZvu1HApZZumuzi9TkZBQMecLcBLtsovnXA/2ON0U3NHjdgnCeH3A6AKtSrlc7PBvM
         jDj5W3XyqC2BW0vgfkGOs3t5GbbtgqiT0E3X0dO2tmSj/elScPG48edKlnS6Bk038jSL
         xxM1PJQzxBIOvrD1Ctu8Z15bBndgy/4VGCl78X7Mz84QUHGcJdBkFwo9DNFGaOZoJwNu
         wPTg==
X-Gm-Message-State: AOAM5326+QSCuDvH/SjezTN5SzBRaw7a9w9KN39VCLF9KBhfnJHo9Byq
        psbDTnzxkNvvfaA3JZlO6X8=
X-Google-Smtp-Source: ABdhPJwsN6a+9A2N7o2AXDI8Jgts/CjX71qJWddnd6xYG85+a0FRLv3NS04yv7gouJBuz/bYt1aErQ==
X-Received: by 2002:a65:5b48:: with SMTP id y8mr7704919pgr.67.1602172614592;
        Thu, 08 Oct 2020 08:56:54 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.56.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:56:53 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 088/117] wil6210: set fops_led_cfg.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:51:40 +0000
Message-Id: <20201008155209.18025-88-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 10d599ad84a1 ("wil6210: add support for device led configuration")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index afbe30989ee4..54285e5420f6 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -2113,6 +2113,7 @@ static const struct file_operations fops_led_cfg = {
 	.read = wil_read_file_led_cfg,
 	.write = wil_write_file_led_cfg,
 	.open  = simple_open,
+	.owner = THIS_MODULE,
 };
 
 /* led_blink_time, write:
-- 
2.17.1

