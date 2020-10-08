Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B53D287869
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731594AbgJHPyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:54:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731571AbgJHPyE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:54:04 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 649D6C0613D7;
        Thu,  8 Oct 2020 08:54:01 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id x13so1715835pfa.9;
        Thu, 08 Oct 2020 08:54:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=9e5MAIq/WTxBR7cO0XNN15x8KyvYX2HvQDF/lGOVVbY=;
        b=VEPcyYyycqwjB0EnovEtgbGKIn5POpBjbFZtDPIWfjZaBuLQWDFhH9t9tC4IoSL9Z+
         JkZ7UC9EpF0YmfT0YokNYkRyX+D8KcroIS4Okqi1yVczrJ5AwjPKVIrfuL5HufXbWbHT
         j8gtBJgzU9Z56xhn3BH4B6T46VL+Bd2DOlbVJc3EtmtKsRGJzpYnkx2/qf0jYvDo5S8h
         nAkMOCXeIJxenDj0yJVBf7i/3/2Hmp4JlAxiaR6ycGalwbBP+ewXwDr3B1JB5WhhE2VP
         diA63dBzwYeGNv45Rgx95K2zuccncRI6nLj98KSVKnszImyBzm8+4DO83GTLt5+6rbAW
         E8Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=9e5MAIq/WTxBR7cO0XNN15x8KyvYX2HvQDF/lGOVVbY=;
        b=oWcv1d7WPFZDzDg/iPUCzo+M56BERxxvOM72DBRDgIdAiqf4N75nZqLS3kU8tAfjkN
         dzN51XAIFzjBkM/Nk0OfyQDS8h4MuTFB+wr64E5EhLkwXk4HHrL+o6sPDlQhsvYExIFU
         PQJaC/TEY+EGPurWp0Fu8KijGO9mHNjfzN9zJAx/jchdQKRyfeNubaULnHBP+xMhmnnB
         n+d0uYffBoBfXrAl3vj5lSXBsNL+LjDqkr8/S/CZ5BpXWmOncLE/Qyv0i0MSRy+9hvmQ
         PgDF8Atia3udMEAW4L8pViFXm1nLS9FlxqyQGx7c+zgfCOfceENzoOIgQfrnJ733gY3h
         Uy3Q==
X-Gm-Message-State: AOAM531tl0yQRVi8D/XaGu+lS2sk67sFxoav+q3mLQeppUTnB/MnMxDj
        ZmyhZaMC0B+1ORv5c2gdev0=
X-Google-Smtp-Source: ABdhPJyNwiyW0Q0htoPcCbOrJy5lwgX962d4O07C/UQfwFNQx9PwuZS/ALYsGSOIWNY4LZjqH/bO9Q==
X-Received: by 2002:a17:90b:ed3:: with SMTP id gz19mr7484382pjb.53.1602172440938;
        Thu, 08 Oct 2020 08:54:00 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.53.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:54:00 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 032/117] wl1271: set DEBUGFS_READONLY_FILE.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:50:44 +0000
Message-Id: <20201008155209.18025-32-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: f5fc0f86b02a ("wl1271: add wl1271 driver files")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/ti/wlcore/debugfs.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ti/wlcore/debugfs.h b/drivers/net/wireless/ti/wlcore/debugfs.h
index fc3bb0d2ab8d..9cc2dee42f51 100644
--- a/drivers/net/wireless/ti/wlcore/debugfs.h
+++ b/drivers/net/wireless/ti/wlcore/debugfs.h
@@ -35,6 +35,7 @@ static const struct file_operations name## _ops = {			\
 	.read = name## _read,						\
 	.open = simple_open,						\
 	.llseek	= generic_file_llseek,					\
+	.owner = THIS_MODULE,						\
 };
 
 #define DEBUGFS_ADD(name, parent)					\
-- 
2.17.1

