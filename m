Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96AA157D07C
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 18:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbiGUQAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 12:00:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiGUQAp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 12:00:45 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A550A868A2;
        Thu, 21 Jul 2022 09:00:44 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id y24so2222834plh.7;
        Thu, 21 Jul 2022 09:00:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JuIHwz3RkYF7rkj+FsqTcQEnxEppDCpcRUBWvSutdgc=;
        b=ZByCULSTOU5yhfC/x3yOqAjox4WNGU92LFn/EIzCL3F5gzkLvI9M+Mpa9SbRExfuMF
         8FRjFXbJBHba+anWMWud/ZOP4yb74aT48usajAOoFagcKz9TeXTWo5L/25UtaVqP0+1+
         UzTyyLq9WyN2XQvc3udk8vBXPCk78oYs7GKzr+s7tcJWhhMC71t+ufPK2LAbvUHWYovV
         5NwdETd+WiiWvYYrmcf5MH7dnt3F+hk/LQh9PwobHDkA+XxreJdMsXFoy4wgSWGvfhmd
         sMauRMgsoS9m4xipMyi2cKTlabLrN2eLD+hkJz0sVwPQffle7r24L0rtw/KbKscw8J+T
         GV9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=JuIHwz3RkYF7rkj+FsqTcQEnxEppDCpcRUBWvSutdgc=;
        b=Z62M1BR/c8bamchnKRVMkjgyEyPyFuP5WEmrtMig/q/lgea24Bhajm+67pxDhTTDtK
         DYc7VIdUq0dZMValj5QJri7YOON6ibXGQwQqN+9jEj3yJvWJnJOW+w/LeDZDAz4J8Zg5
         aC5kpdWf5WXgICGKipuHfAmypFBtG5hd4e+8uDJg3/zPhlvLuJHaEJIJfWVfyNiMKUbn
         OiqcsKrMvENWPQqvKxxH94JxQhSBiNB9CxyY++eMMA2ZGqN7rN9yKDJT9lifugPD4GwN
         6GBSDTJG4crpVhFZxmqIip13xJt5FhM0hXCQMYl3t0gpxD9TxKMo19xaPiDWjnPapWZY
         YpLA==
X-Gm-Message-State: AJIora+KXCTiZNKOKVZxIUXbH4HVRmOUA89KJz8f259irwZ+y4KcIKx1
        mQOzE0TGIUX+TSf+v4/IU9pRpQQBmpbyQg==
X-Google-Smtp-Source: AGRyM1tmjCjVjuz7PbD1fsn9JySdUBw//MgQZlYicn28XRC9Cl9GZ1/HR2g63KLEyOsHb3ycXkMnaA==
X-Received: by 2002:a17:90b:4c4e:b0:1f0:48e7:7258 with SMTP id np14-20020a17090b4c4e00b001f048e77258mr12250891pjb.223.1658419243611;
        Thu, 21 Jul 2022 09:00:43 -0700 (PDT)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id k11-20020a170902c40b00b0016c97d59f6asm1975310plk.93.2022.07.21.09.00.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 09:00:43 -0700 (PDT)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Nathan Chancellor <nathan@kernel.org>, linux-can@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Frank Jungclaus <frank.jungclaus@esd.eu>,
        =?UTF-8?q?Stefan=20M=C3=A4tje?= <Stefan.Maetje@esd.eu>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH] can: pch_can: initialize errc before using it
Date:   Fri, 22 Jul 2022 01:00:32 +0900
Message-Id: <20220721160032.9348-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <YtlwSpoeT+nhmhVn@dev-arch.thelio-3990X>
References: <YtlwSpoeT+nhmhVn@dev-arch.thelio-3990X>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit 3a5c7e4611dd, the variable errc is accessed before being
initialized, c.f. below W=2 warning:

| In function 'pch_can_error',
|     inlined from 'pch_can_poll' at drivers/net/can/pch_can.c:739:4:
| drivers/net/can/pch_can.c:501:29: warning: 'errc' may be used uninitialized [-Wmaybe-uninitialized]
|   501 |                 cf->data[6] = errc & PCH_TEC;
|       |                             ^
| drivers/net/can/pch_can.c: In function 'pch_can_poll':
| drivers/net/can/pch_can.c:484:13: note: 'errc' was declared here
|   484 |         u32 errc, lec;
|       |             ^~~~

Moving errc initialization up solves this issue.

Fixes: 3a5c7e4611dd ("can: pch_can: do not report txerr and rxerr during bus-off")
Reported-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 drivers/net/can/pch_can.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/pch_can.c b/drivers/net/can/pch_can.c
index 50f6719b3aa4..32804fed116c 100644
--- a/drivers/net/can/pch_can.c
+++ b/drivers/net/can/pch_can.c
@@ -489,6 +489,7 @@ static void pch_can_error(struct net_device *ndev, u32 status)
 	if (!skb)
 		return;
 
+	errc = ioread32(&priv->regs->errc);
 	if (status & PCH_BUS_OFF) {
 		pch_can_set_tx_all(priv, 0);
 		pch_can_set_rx_all(priv, 0);
@@ -502,7 +503,6 @@ static void pch_can_error(struct net_device *ndev, u32 status)
 		cf->data[7] = (errc & PCH_REC) >> 8;
 	}
 
-	errc = ioread32(&priv->regs->errc);
 	/* Warning interrupt. */
 	if (status & PCH_EWARN) {
 		state = CAN_STATE_ERROR_WARNING;
-- 
2.35.1

