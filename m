Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 506DF28798C
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 18:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731482AbgJHQAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 12:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729669AbgJHPyN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:54:13 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5234C0613D2;
        Thu,  8 Oct 2020 08:54:13 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id 144so4337687pfb.4;
        Thu, 08 Oct 2020 08:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=j2T/f3SwK/3JVH2Yszx+v22HOpXvzZbEXaEu/E+bUZM=;
        b=YignJrA9PUMKJECIxKa9Q+pE7mYZ9CkEeb5P+LlicVa9ErW/L+dpJsQVewXMhep+la
         M/hZOJBEohzRrhy3cRXy0OmpP7h3GmaoK0Bxvy9RhKVLQpMmRaXrqzfX2ZOMA+G+/nRB
         8vVq6MZZzqJ8Uxm1raMQXYVKW/bR7Ke55WFIBcqZM2ekcMmq9j0vwcywIMBb+cE0nJWZ
         hagSK/F6VadfIQFCdEMvHvrBtjJgsmnIW6cUe+wB1+8sT11NLTccF2YUmg9reCIpZV0S
         arzqdvisCcnqqxVbefPvB8uAgwkB7UIGDfhsns3iR/ejZJpWUCHZbvs0Bn8lVNzJX/3S
         zpMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=j2T/f3SwK/3JVH2Yszx+v22HOpXvzZbEXaEu/E+bUZM=;
        b=LcIB5OUWAN68By4EM7lVJJ/NFmeB/Lm5Xjod1ikEwkL/JcMkdAqHZP6qLBwcX0/pLS
         t1pqfN5EYk/CyIZoWpVKjOQ32+WSWbVEkckKTIZpQuMcU+ckg63mK1GIj3s0aq8kNTHD
         Wp5AKrmOM2KfsN2tnEEoJkznCWo9G/NYh2zwGCgARRF/XDT+AeUTlqh8aUiLykk3d+rd
         AHDz/2KKsac5pAyQtA6ZDmbDtKsQiuLSnqQujFlfi7eYLwumQEk+PVa5F00yccMLh6gb
         Yw4nKBGci45NZ/DwYptc74jmqHxQ+eC4GKt7xVRb3zDObpYOuZuXBdSPobQQFfrV9grF
         G4Kw==
X-Gm-Message-State: AOAM5334tYO67XfHbvuxOin9QCV/hfQq0mWXTU6ifWWs2hXcmT36hIdK
        m5vEupY3HP9ZvI0e05fI84Y=
X-Google-Smtp-Source: ABdhPJz9av+T3B4XUsxKufR9TfsP2+JqjaGHUqd9C5v8KNZyVu80HUhaxEB5o2zvbClhkq5KTTL56A==
X-Received: by 2002:a17:90a:fad:: with SMTP id 42mr9114973pjz.108.1602172453207;
        Thu, 08 Oct 2020 08:54:13 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.54.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:54:12 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 036/117] wl12xx: set DEBUGFS_READONLY_FILE.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:50:48 +0000
Message-Id: <20201008155209.18025-36-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 2f01a1f58889 ("wl12xx: add driver")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/ti/wl1251/debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ti/wl1251/debugfs.c b/drivers/net/wireless/ti/wl1251/debugfs.c
index 0b09ffec9027..21d432532bc3 100644
--- a/drivers/net/wireless/ti/wl1251/debugfs.c
+++ b/drivers/net/wireless/ti/wl1251/debugfs.c
@@ -68,6 +68,7 @@ static const struct file_operations sub## _ ##name## _ops = {		\
 	.read = sub## _ ##name## _read,					\
 	.open = simple_open,						\
 	.llseek	= generic_file_llseek,					\
+	.owner = THIS_MODULE,						\
 };
 
 #define DEBUGFS_FWSTATS_ADD(sub, name)				\
-- 
2.17.1

