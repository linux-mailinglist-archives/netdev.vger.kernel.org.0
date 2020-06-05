Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABFC71EEF2A
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 03:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbgFEBgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 21:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725863AbgFEBgx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 21:36:53 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA820C08C5C0
        for <netdev@vger.kernel.org>; Thu,  4 Jun 2020 18:36:51 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id e5so6334419ote.11
        for <netdev@vger.kernel.org>; Thu, 04 Jun 2020 18:36:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RPG8UqXXECyaYnGqNe/yQbtmWWJ9M9GUYhMuelhj7w4=;
        b=evQdthvqS9i0CX/AHJay7yhDJcr3AbFk+iZYk7Q2qCM+/PuIcFwWac1OSZ1nrBg5U/
         XgbqZfgvIHtTcoZBv8D/REYfjb9rUInuIBUz6bMNtJc/0Z7rbCi4qJVp5BcHLMOiYIQ3
         n/D79vHU5T4f7H+U+YX1x+VZ9eJTQ0dXlfkR1fZLWnhMmnxZqm/TViw3RuoDB9T9wWFV
         OGNM+frZwcolJfAFW7X/+INvthDvMV+5ePlihJAkLLM+T6GTvPaUxtLZz+dle4UyHu2j
         xmutFSzT+3neP/pTbLYDT7iD4MPRZQX6M5c1PZspVvnPVpzFvc1HhmPqLxk4tpEuTTnX
         WyMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RPG8UqXXECyaYnGqNe/yQbtmWWJ9M9GUYhMuelhj7w4=;
        b=t18KIq6Nl0n4u92beXNjv9WE93oH0DciVUHKSiGwK9NyZYQ7H3P38JUGfRR2g6kxq0
         I+8T9QYT/xM9eMH8pmU/uZ/WrGNLURqoPYstOsxf7vuYV8sSMxFJTp/ppDgbTibmlBAE
         lX80Ax9noZUs5hpn0Nvq6+giWuvaHQf4HMU7zOZhvb3M8k0K2d/Mky/g8Sj87OLaNCb5
         l+ehWA2IxoKG99VjJ8MHu60Mb+7QCxym9ysxXYZtHszojqJ0YjZQJ7vgwYtbvuK40T1/
         mydDXRLLPzfDEJkuXuq+wWcNrhakkc5B9CBY+W3zcnR6jr/Ox0ufNiz7w1shMnGCu8Ma
         5N0w==
X-Gm-Message-State: AOAM53017oeaDnMBkM/Guc1g3TLL/fpgF4mM2j0gMU35m9sXRVf8BRmQ
        i5qva/89U6Y4NqhlS/MiD6ggNIe1+9E=
X-Google-Smtp-Source: ABdhPJwUMzGM7nRDIZsV6yweVKqo7Tzu/ui2JQGsAbt9R4QcMz2OlHk5PUWn3IAb/Y1A1/9BUOjcQw==
X-Received: by 2002:a9d:190:: with SMTP id e16mr5969554ote.179.1591321011029;
        Thu, 04 Jun 2020 18:36:51 -0700 (PDT)
Received: from proxmox.local.lan ([2605:6000:1b0c:4825:226:b9ff:fe41:ba6b])
        by smtp.googlemail.com with ESMTPSA id k14sm463670oof.48.2020.06.04.18.36.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2020 18:36:50 -0700 (PDT)
From:   Tom Seewald <tseewald@gmail.com>
To:     netdev@vger.kernel.org
Cc:     tseewald@gmail.com, Vishal Kulkarni <vishal@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v2] cxgb4: Fix 'defined but not used' warning for cxgb4_uld_in_use()
Date:   Thu,  4 Jun 2020 20:36:32 -0500
Message-Id: <20200605013632.781-1-tseewald@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200605000748.31442-1-tseewald@gmail.com>
References: <20200605000748.31442-1-tseewald@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The only user of cxgb4_uld_in_use() is cxgb4_set_ktls_feature() which is
only available when CONFIG_CHELSIO_TLS_DEVICE=y. To avoid this compiler
warning when CONFIG_CHELSIO_TLS_DEVICE=n, place cxgb4_uld_in_use() behind
the same ifdef.

Signed-off-by: Tom Seewald <tseewald@gmail.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
index 0307e9c69a47..08439e215efe 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
@@ -663,6 +663,7 @@ static int uld_attach(struct adapter *adap, unsigned int uld)
 	return 0;
 }
 
+#ifdef CONFIG_CHELSIO_TLS_DEVICE
 static bool cxgb4_uld_in_use(struct adapter *adap)
 {
 	const struct tid_info *t = &adap->tids;
@@ -670,7 +671,6 @@ static bool cxgb4_uld_in_use(struct adapter *adap)
 	return (atomic_read(&t->conns_in_use) || t->stids_in_use);
 }
 
-#ifdef CONFIG_CHELSIO_TLS_DEVICE
 /* cxgb4_set_ktls_feature: request FW to enable/disable ktls settings.
  * @adap: adapter info
  * @enable: 1 to enable / 0 to disable ktls settings.
-- 
2.20.1

