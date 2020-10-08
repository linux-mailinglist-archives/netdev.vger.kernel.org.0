Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53A7A28783D
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731456AbgJHPxI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:53:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729869AbgJHPww (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:52:52 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B15FC061755;
        Thu,  8 Oct 2020 08:52:52 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id f19so4315598pfj.11;
        Thu, 08 Oct 2020 08:52:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1lzOTnPcS21YNiqg/E2Mnuwona6C8eTvscN2/7/mNOg=;
        b=DYC0ehBTNNCdj7kwEdPDtQI6kw5hwwSZaq9IpjJQqdY6R/TdjCxZoaMDxvudZAgA9/
         BAFVaGc2pu5d2/iXMaTXTS9+6ZqGFTQsygAK+PYPbuaCeuFVzVgIhWczJbHJek3ABjcf
         kFl0Wxxl1ZkE+G0f5SK1d0dafZgCc37p3rn9RDL2ZOaJTTcD+AZ6GRFe6wiX6rYu1ZbJ
         k/V7iteXWGFHhV9IMUJt0R0DaUSbRMLCwAPdkBG8tVEcWgxzied5dAVudgMw5EyjvOD2
         dbCOrEVGr2JaUeaNhqcGECSAJOYjW9KQO8djlXGZmssa1Sr9f5ijKUTfBBH5e1mNs3jO
         mAcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=1lzOTnPcS21YNiqg/E2Mnuwona6C8eTvscN2/7/mNOg=;
        b=Mn8pi6/m10y6TknG12jFvq7cIT7WBREAdRU6JXvEja5YOH3dR6PWjFM5h2GeSm68pA
         W/kIj8dSfYN61gETepGJN/Q3jxM2pcidInnQtyI4rilq8ie9L96VrLLNvUkOD3tDcj+E
         vcBi6G0f5vTXetfMf4d+4U0msD6Usn84d7hSh+ghwx7EZ5/3HlsA4JSYl9UNI0OTIneE
         2r4j0hIq0KglH1dFwdgJz/L0oVsKppavVibkKued9Ash2ci63Xp0lkKSxqnVYD4A5CF4
         QxWxxVpB0srXAetAS9rfZTimGeAQesEQvIy0aIm7SPliZY66SdRf2W0sBipW+VWche3v
         YmrQ==
X-Gm-Message-State: AOAM532L6DCeU0DmUU9qu7e559DLps9jDHBaQk1vgTkv2FIiFe22yc2J
        jO0bvx7Aj6ltFCAr7Ft5E9U=
X-Google-Smtp-Source: ABdhPJwpTwyF2uviebYn/JocjFs4QX4iSjwHskFizHx+N5/C0+a4HM4T5DJJmoiphFWrSbJzYycMjA==
X-Received: by 2002:a17:90a:9b89:: with SMTP id g9mr8948245pjp.123.1602172372146;
        Thu, 08 Oct 2020 08:52:52 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.52.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:52:51 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 010/117] mac80211: set DEBUGFS_READONLY_FILE_OPS.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:50:22 +0000
Message-Id: <20201008155209.18025-10-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: e9f207f0ff90 ("[MAC80211]: Add debugfs attributes.")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/mac80211/debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 54080290d6e2..669d7e13ffe8 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -46,6 +46,7 @@ static const struct file_operations name## _ops = {			\
 	.read = name## _read,						\
 	.open = simple_open,						\
 	.llseek = generic_file_llseek,					\
+	.owner = THIS_MODULE,						\
 };
 
 #define DEBUGFS_READONLY_FILE(name, fmt, value...)		\
-- 
2.17.1

