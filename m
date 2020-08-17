Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADBA52462F0
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 11:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728897AbgHQJTt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 05:19:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726161AbgHQJTp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 05:19:45 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95351C061389;
        Mon, 17 Aug 2020 02:19:45 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id s14so1225261plp.4;
        Mon, 17 Aug 2020 02:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=rg9O+UuIrcRklqdLDyvqN900SVFxVyljAa/s7srCNnQ=;
        b=WvuNpwFGNWbf3ugG14n+zwKOY/otFa6nSLps1Uk3WhYO9QhlgfX29+70gj4yecSVqe
         YmEaWyKwvwZLdqCS1f4rjFzeI/WYV2mrJXFqK7u1fv3j1mD6vv7ArpSQ8eB9kebxavUo
         v4gjm/SQe2dmKaNUs5jSYqEpMcOQLTy1XStSEI/HRZPc81UrOC06O4IvkZlb9P+d+J9+
         6iZP3dRMy48wvQtGHCCdONIoXtX+tgg7bwCEGbZzuseWjZ9rC+VhjkH7FoBRe7RFBqof
         Eu7g0wB9F52zpe5wgpjT7872Gbi0ZB7cwZGvpBfTBYz4nR6UMl9C43xvhapmPwtLTJTg
         rU/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=rg9O+UuIrcRklqdLDyvqN900SVFxVyljAa/s7srCNnQ=;
        b=lxu1YSH7xQ7rjeymp6hcGLdiBpFDXJpBb++whYOD6eGJqYGlTHprBU8L1mVijUbt+/
         NgJSpf7xlFYz1dXWiaVnSTrUhpqwPMTyse/oy5biWNBUnCHpk0zWUkq3CAL/zj1Wi1N+
         GM9fsM5qY2LcVencbbY9/Z/2ZFitQxHImpNRVmEYbTRifhjIzjhp8ZbfFdlzo9D8XS9E
         u1p0Px4RD55UVdBy0rTdBTMx0U/kX63pQz401pF0/bJd0tMdQ0pQytD8nP7dVT1bUFqa
         6er39YhVyfDZCk6h0VPbVPbDvpr7mVUltsB80FCPrwp7oSdKlS4gNUGiJmf5UMYddp9+
         5Srw==
X-Gm-Message-State: AOAM530bjgW6T0a4QWP4EKVcuDqprbzYkxcI2JO9IPOcdA1RkyFg9FSn
        Fps+7UUheC8QA0UHPyfc7vo=
X-Google-Smtp-Source: ABdhPJxVPsBMIEeexKvgRfN8Y85NhtB5FsOgXp8HBPraiCyANuba28QRU7wOPQwsX7fudbCrO/coPA==
X-Received: by 2002:a17:902:6b05:: with SMTP id o5mr10459515plk.173.1597655985094;
        Mon, 17 Aug 2020 02:19:45 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id r25sm15971028pgv.88.2020.08.17.02.19.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 02:19:44 -0700 (PDT)
From:   Allen Pais <allen.cryptic@gmail.com>
To:     jdike@addtoit.com, richard@nod.at, anton.ivanov@cambridgegreys.com,
        3chas3@gmail.com, axboe@kernel.dk, stefanr@s5r6.in-berlin.de,
        airlied@linux.ie, daniel@ffwll.ch, sre@kernel.org,
        James.Bottomley@HansenPartnership.com, kys@microsoft.com,
        deller@gmx.de, dmitry.torokhov@gmail.com, jassisinghbrar@gmail.com,
        shawnguo@kernel.org, s.hauer@pengutronix.de,
        maximlevitsky@gmail.com, oakad@yahoo.com, ulf.hansson@linaro.org,
        mporter@kernel.crashing.org, alex.bou9@gmail.com,
        broonie@kernel.org, martyn@welchs.me.uk, manohar.vanga@gmail.com,
        mitch@sfgoth.com, davem@davemloft.net, kuba@kernel.org
Cc:     keescook@chromium.org, linux-um@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-block@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        openipmi-developer@lists.sourceforge.net,
        linux1394-devel@lists.sourceforge.net,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-hyperv@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-input@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-ntb@googlegroups.com, linux-s390@vger.kernel.org,
        linux-spi@vger.kernel.org, devel@driverdev.osuosl.org,
        Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH 1/2] memstick: jmb38x: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 14:46:09 +0530
Message-Id: <20200817091617.28119-15-allen.cryptic@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200817091617.28119-1-allen.cryptic@gmail.com>
References: <20200817091617.28119-1-allen.cryptic@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <allen.lkml@gmail.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/memstick/host/jmb38x_ms.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/memstick/host/jmb38x_ms.c b/drivers/memstick/host/jmb38x_ms.c
index 4a6b866b0291..2bcf5ce113bd 100644
--- a/drivers/memstick/host/jmb38x_ms.c
+++ b/drivers/memstick/host/jmb38x_ms.c
@@ -603,10 +603,10 @@ static void jmb38x_ms_abort(struct timer_list *t)
 	spin_unlock_irqrestore(&host->lock, flags);
 }
 
-static void jmb38x_ms_req_tasklet(unsigned long data)
+static void jmb38x_ms_req_tasklet(struct tasklet_struct *t)
 {
-	struct memstick_host *msh = (struct memstick_host *)data;
-	struct jmb38x_ms_host *host = memstick_priv(msh);
+	struct jmb38x_ms_host *host = from_tasklet(host, t, notify);
+	struct memstick_host *msh = host->msh;
 	unsigned long flags;
 	int rc;
 
@@ -868,7 +868,7 @@ static struct memstick_host *jmb38x_ms_alloc_host(struct jmb38x_ms *jm, int cnt)
 	host->irq = jm->pdev->irq;
 	host->timeout_jiffies = msecs_to_jiffies(1000);
 
-	tasklet_init(&host->notify, jmb38x_ms_req_tasklet, (unsigned long)msh);
+	tasklet_setup(&host->notify, jmb38x_ms_req_tasklet);
 	msh->request = jmb38x_ms_submit_req;
 	msh->set_param = jmb38x_ms_set_param;
 
-- 
2.17.1

