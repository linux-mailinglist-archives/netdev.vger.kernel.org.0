Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF50287954
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731178AbgJHP73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:59:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730084AbgJHP6Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:58:25 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D18F7C0613D4;
        Thu,  8 Oct 2020 08:58:24 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id y14so4637788pgf.12;
        Thu, 08 Oct 2020 08:58:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=MrwV7YboufuzPmRY7YXXjmmxDQMT3fV4x6LdtCZmti8=;
        b=LP1lH8q6rNJJwGYNet9TqcUgUeLGgdJTUoX2VABqWbb4zfKk/yK0DDzC3Sh+n8Ewt7
         sglipnDEAJIRMS+rdiTyx24W0oJhjP8C0wxOjmhA4U/myUk+5LH18UD+S28a0vgCfKUG
         9M9w9pa01efZDnCC2JZNjTPBgkVswRLlLFhcrrHPif7hOrct5Gv2Y5rmHLWa0PK7uo0J
         gCDGJVR8HFZAJktNr6I5guKNC7EakGN3C7H1Xtx2kcnmvO+5iU83SMRVjGKURkiFFX60
         dgWb9Pzyez6uUAzrxJ2URBYe1OyCFHmi9gk8/uP/Zj9wS9NiWWEXDsD7KRXVBgZ9kIor
         ibVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=MrwV7YboufuzPmRY7YXXjmmxDQMT3fV4x6LdtCZmti8=;
        b=QvIHC0Kyn3UFkKhiHYTkW7AbPkE0iCj/6VXAN3qUWOljZg5dGFgSkIi4VjfZbTwiCA
         45bYnn/0KLDD8FNa5UUKY3qTY9XOeqPxSTaHQeQOvXVLdDi88tb7iift2OSS5gfc0cV6
         3Et+ZrV4fUjAzGg4+JI36z7D27gBUACj7RnF0Psk/g2zgSGBoyRGkcnccvHeC/1E20r5
         YQgLUH1uBt84U1e2aEyOv9s5ZvqEpkpCYDzxRQUTCh9WIIjAIBYj7USeaU7P13Kdm5CQ
         bNC08rEamMn/o/0EMnoC8HC9VihzpI1DGGv8bPco39onybqcdePnROid5wx1vROefUg8
         otaA==
X-Gm-Message-State: AOAM530u+ebAtj6kQ+r3hWsjANCQhq8R2as59f+Gx7nbTRfMgukb+MjX
        a8XF+cJGvMIBrNMect9TidQ=
X-Google-Smtp-Source: ABdhPJx4Vsg3QPFugLVIui6GS8ZvLhvbbBsX2PxlUIGK8zBVxxZTTFUGnUioSlrvyxNd6MDGOY7Xjg==
X-Received: by 2002:a63:4457:: with SMTP id t23mr7863489pgk.108.1602172704447;
        Thu, 08 Oct 2020 08:58:24 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.58.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:58:23 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 117/117] Bluetooth: set test_ecdh_fops.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:52:09 +0000
Message-Id: <20201008155209.18025-117-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 6de50f9fdb60 ("Bluetooth: Export ECDH selftest result in debugfs")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/bluetooth/selftest.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/selftest.c b/net/bluetooth/selftest.c
index f71c6fa65fb3..445ea247061b 100644
--- a/net/bluetooth/selftest.c
+++ b/net/bluetooth/selftest.c
@@ -194,6 +194,7 @@ static const struct file_operations test_ecdh_fops = {
 	.open		= simple_open,
 	.read		= test_ecdh_read,
 	.llseek		= default_llseek,
+	.owner		= THIS_MODULE,
 };
 
 static int __init test_ecdh(void)
-- 
2.17.1

