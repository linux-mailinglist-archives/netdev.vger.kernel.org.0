Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23FE2287946
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731367AbgJHP7M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:59:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731277AbgJHP5U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:57:20 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18400C061755;
        Thu,  8 Oct 2020 08:57:20 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id a200so4331358pfa.10;
        Thu, 08 Oct 2020 08:57:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vvc+gmlWaLd/NazlUIQ4wOqeiliYouVFUVS4Xj2GMQA=;
        b=lQk2NgmoOtQT8zsvBIYFXLZFSG9zQwCm9vpLkpy3WwKTxsVXtABZbbZSwKoo2dwb6R
         NmaVZ2jS6k2wg7UljfOcs+pKPyx5H6jE0qiyd24lQzRM/+hyehTTs5sQglXSWDkcyKbD
         fQU33XhLPZW7PLqUzwggNwrkQ2o8dArWHXUuoEVKYpy/+yElmciPhpEEUO9088VlZ1AN
         eTbhsLh1kmkhjJUOtwcuUAa1s0MZAKiis0ICokAoJSIavPWoTMNGD3M427NiusNTgqbH
         a2GxAjLCTnjveBvteZm+2znl+E4FyfuO/cmD3aBSDBs/lF0zHS6wEgMl72lqpsnqk+7n
         cJAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vvc+gmlWaLd/NazlUIQ4wOqeiliYouVFUVS4Xj2GMQA=;
        b=TcE/f+y3NEQnUHMryZkLzJ07BeNUazLK9o5kXlbkRmjHK5U3c+ppIybKRofisIFh2/
         gA20TXPrz12AXuk1V63FiRbli4xHXtp6rRO7RGbZ1hb8VPIyhCdVA30C90h919T62MAF
         TssmPbhFPx1NtNU2v2J5IQ6jLoXQ1w9JscGmPwLNK1/5jdm9jvlMdWP2hhPe7+EQPLkf
         9CHtnuDr97yITkvLoJTs94SXAUaAogogHEAReYYe7qKH8M0hJsUtQoJpxYtmPg3MQHm7
         fxpqXOw0XF492tZJeYUOAWfHjrEUCuZHjXVMXDhlznQ8DWUKr5szV1TflZyOId+UKA9k
         pmhA==
X-Gm-Message-State: AOAM530pnunFst+hAX/gF+Xa8Shnjaa/tL8MFyhQk0Fb4iO3UotFZLNB
        FSk8hnCm5WjBONoU/Z3yZOs=
X-Google-Smtp-Source: ABdhPJyjF6nhCOw6ehr/I+coH9XQEJEWSgJXVoSMAj+Aqoj05pURfpxUOlH0iz/N5uiLzG9U2KKnow==
X-Received: by 2002:a62:830c:0:b029:152:3490:c8e6 with SMTP id h12-20020a62830c0000b02901523490c8e6mr7876320pfe.6.1602172639629;
        Thu, 08 Oct 2020 08:57:19 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.57.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:57:18 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 096/117] b43legacy: set B43legacy_DEBUGFS_FOPS.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:51:48 +0000
Message-Id: <20201008155209.18025-96-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 75388acd0cd8 ("[B43LEGACY]: add mac80211-based driver for legacy BCM43xx devices")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/broadcom/b43legacy/debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/broadcom/b43legacy/debugfs.c b/drivers/net/wireless/broadcom/b43legacy/debugfs.c
index e7e4293c01f2..7c6e7cfeb822 100644
--- a/drivers/net/wireless/broadcom/b43legacy/debugfs.c
+++ b/drivers/net/wireless/broadcom/b43legacy/debugfs.c
@@ -318,6 +318,7 @@ static ssize_t b43legacy_debugfs_write(struct file *file,
 			.read	= b43legacy_debugfs_read,		\
 			.write	= b43legacy_debugfs_write,		\
 			.llseek = generic_file_llseek,			\
+			.owner = THIS_MODULE,				\
 		},						\
 		.file_struct_offset = offsetof(struct b43legacy_dfsentry, \
 					       file_##name),	\
-- 
2.17.1

