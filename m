Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51DA93A7300
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 02:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230377AbhFOAcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 20:32:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230291AbhFOAcm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 20:32:42 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D058C0617AF
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 17:30:25 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id d2so22433890ljj.11
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 17:30:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=quswy1jB+1Xar493tlXRtmhFxHeNkxTYoFdb5cftjDI=;
        b=KL2r9pmhFOUcjuuPJcs7T41YrrFQYM6dgB4thl2x6wIsWGdR75m/cMFhJ2OnfkJdlA
         CGL2VvLUqfDTwND2ggzVBruutUeOXutSTShw/pyBZq8zFxowQj1hkOtRVyz54ClOtdcO
         LLA+Y/i+PAKC5d1UljBvYwXdJ1DNrOnFJ4bwSsQ7j5roFTsamnpTyMSDBsPoM4EoNVkY
         m7RWoGu9iNeUq5UisCz9QVsE9h/DnfnA9jYqS5nT/N8e2qmVaG3pYHhQNW55aY7x4n8C
         y74bqXFcd7tA5D9tugxyay85SFaHJGyt0sXveSwoaw3JFXgGokkhvCr8y/1QxIg3l/7H
         F72g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=quswy1jB+1Xar493tlXRtmhFxHeNkxTYoFdb5cftjDI=;
        b=eSHDXxZKNIEmhSDxWrpHhdU3UjljPDdH+Go2zw7y5Ei5hNUXQVG+09uHT+PumMbMCL
         QxrkGpXA3hGYzvuXSWskgO1Ki9N6v4CeJj/Ixcleq9hgfIhaZHce5bT8+s+IOr3u3hrp
         MDnsfAR1HLDk11ZEJf979XWm0OmqvfQ0OxglUjpzUnWprO0kwXo0MOZ1wePPuEzkt2D4
         eih3OMWudSeGCACPE7wEjjQlnrIrEMI5XqPTLmAo2gE7m2Bjx22a39sIVb+EHz/sg1fV
         A10gfVCxoj66ptb26RsU0xGnxshUNvp3e1WE+cpfc0bfcrVUf3h8NzNtkIlEe1oKZHSs
         8kiA==
X-Gm-Message-State: AOAM532BYoH2o0CeyHeh+ZDAg69oIbbrXAbxa5phhtVOWVgSYGKIQ4Tb
        9fCjFETPbjdaQ7CuOTPjKsE=
X-Google-Smtp-Source: ABdhPJyhY547xBSuimmYzWR3HokQU6WMCpuSvl6s8RQP1UIeTnMDHeGWN2gspBRNVAjbwM9lgVP/kA==
X-Received: by 2002:a2e:7a1a:: with SMTP id v26mr15785026ljc.362.1623717023055;
        Mon, 14 Jun 2021 17:30:23 -0700 (PDT)
Received: from rsa-laptop.internal.lan ([217.25.229.52])
        by smtp.gmail.com with ESMTPSA id 9sm1635522lfy.41.2021.06.14.17.30.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 17:30:22 -0700 (PDT)
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
To:     Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 03/10] wwan: core: require WWAN netdev setup callback existence
Date:   Tue, 15 Jun 2021 03:30:09 +0300
Message-Id: <20210615003016.477-4-ryazanov.s.a@gmail.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210615003016.477-1-ryazanov.s.a@gmail.com>
References: <20210615003016.477-1-ryazanov.s.a@gmail.com>
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
 drivers/net/wwan/wwan_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
index 00b514b01d91..259d49f78998 100644
--- a/drivers/net/wwan/wwan_core.c
+++ b/drivers/net/wwan/wwan_core.c
@@ -909,7 +909,7 @@ int wwan_register_ops(struct device *parent, const struct wwan_ops *ops,
 {
 	struct wwan_device *wwandev;
 
-	if (WARN_ON(!parent || !ops))
+	if (WARN_ON(!parent || !ops || !ops->setup))
 		return -EINVAL;
 
 	wwandev = wwan_create_dev(parent);
-- 
2.26.3

