Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11CA33AF8CA
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 00:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232335AbhFUWx1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 18:53:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232283AbhFUWxY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 18:53:24 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2E67C061756
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 15:51:08 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id a21so2280966ljj.1
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 15:51:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8YszF+KJknlKGnazgpJVo3N5S+om/qdEPsz9YOytr4g=;
        b=lDA3R2JGrMcf1sfoSXfEDo9PNFukwoYNwOlM0+I4UlqQGzFyFzUsE0NnLcCEqQ5vgm
         f8Pe4RX7yhI97ZD6S6ARtKcCeK0BCX6H7FqPSkKVCEnPor/NKGNi/rcN3LR22HRYAJeO
         JCksutqX6ep1psWW9TS99FFu2k3hICyBanoa/4j2U6XkQ7KKGR9NI1XSfCGmDJf8mdTG
         MjqzhIaGLZ50bwdDkq2b7e7DB4wslj/4ipuyyCkyXMLftp6VFOIMFhb7u5HgrZptZNY7
         w32rPIHEhZrYenQUkwXFguoLjWQsyRHIBELVhBAWXZB3843FQLR7lGt2TsvFEp5FzJz3
         MRkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8YszF+KJknlKGnazgpJVo3N5S+om/qdEPsz9YOytr4g=;
        b=n9p/balbA8sjmjzsmCGcQ7QU1vSmwvnlh/pDqKtgsW4jLVjwsB3ovGJ6LucxvAewZA
         hZUEOtvsY1WV7uVKOUxFU2DI8LMZYAjN63zKuBauU1G/4/R0pam0l/6URG2t9D2qaqNJ
         EsnqpkFuD7SasWl52UNRrZr9qHsy27m9bX78AhTfMNbwEeS1pGa32APTObAxT+22NJEi
         KIhEfragcXFG455RTULGbgHsncCK3Oxan0Daq7QfXEj27cmtTol4de7gC9pr+fKA8vdH
         BeUwzLXOobblS0rghNORz0/yLPvgWATpGiK74XhoKptTpUDDDaCLOB1VT/SldR+/4ZkC
         qTTQ==
X-Gm-Message-State: AOAM531xOy0S7X5IhOV3xEEcz9CETXQJOYHeBWfwJIkozbVdOK7M+TB7
        eB5Vw2TO83DTRVrp99NtLFc=
X-Google-Smtp-Source: ABdhPJwDN4n5ofMk84XSXCOZAfGzGSKu2NXnxhmVYqkW4fWVBoI/q6/4cv2a0wFpQadIdjfRa050lg==
X-Received: by 2002:a2e:b618:: with SMTP id r24mr452310ljn.48.1624315867381;
        Mon, 21 Jun 2021 15:51:07 -0700 (PDT)
Received: from rsa-laptop.internal.lan ([217.25.229.52])
        by smtp.gmail.com with ESMTPSA id x207sm124826lff.53.2021.06.21.15.51.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 15:51:07 -0700 (PDT)
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
To:     Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next v2 03/10] wwan: core: require WWAN netdev setup callback existence
Date:   Tue, 22 Jun 2021 01:50:53 +0300
Message-Id: <20210621225100.21005-4-ryazanov.s.a@gmail.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210621225100.21005-1-ryazanov.s.a@gmail.com>
References: <20210621225100.21005-1-ryazanov.s.a@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The setup callback will be unconditionally passed to the
alloc_netdev_mqs(), where the NULL pointer dereference will cause the
kernel panic. So refuse to register WWAN netdev ops with warning
generation if the setup callback is not provided.

Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
---

v1 -> v2:
 * no changes

 drivers/net/wwan/wwan_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
index 688a7278a396..1bd472195813 100644
--- a/drivers/net/wwan/wwan_core.c
+++ b/drivers/net/wwan/wwan_core.c
@@ -917,7 +917,7 @@ int wwan_register_ops(struct device *parent, const struct wwan_ops *ops,
 {
 	struct wwan_device *wwandev;
 
-	if (WARN_ON(!parent || !ops))
+	if (WARN_ON(!parent || !ops || !ops->setup))
 		return -EINVAL;
 
 	wwandev = wwan_create_dev(parent);
-- 
2.26.3

