Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E80B485D2C
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 01:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343736AbiAFAaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 19:30:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343869AbiAFAaJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 19:30:09 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D1B4C061201
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 16:30:09 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id c14-20020a17090a674e00b001b31e16749cso4891818pjm.4
        for <netdev@vger.kernel.org>; Wed, 05 Jan 2022 16:30:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bluerivertech.com; s=google;
        h=from:to:cc:subject:date:message-id:reply-to:mime-version
         :content-transfer-encoding;
        bh=sItKhyjYiBTIjJbWyCsjJdRLFFEaR2+GFLFbvvEQQ8g=;
        b=sXNtGJJAQGNGLYM3ZJbRzUrX2NXrOAoLBfdN4Zp/iPp+uusm2oqybEc5NfQC0PYgQB
         969nm4Al16dFnS7Wft0RHUI16jeFwBlHYSb8qqmIvNqghC7HPdYonl/mblupKnoB2B+G
         IEEGJKBhKx5I9IkutugK1JWF5SG9EAGZ56w/Xyb739WkGNw8CT/tzGwWBq9XWRSTeM8o
         oXeS3kqDTqY66tlG1Mkl4b7HpuFpAyTzIU/DNL/IifBxjlURL8dlUqIRinnQdRXFvuj+
         FXRExsJkRjEkb1FkLxTIYhxVukUdVhjiP9inogL1PaCE7I86KU3lIDFbaHPQFL34fwV8
         bF2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :mime-version:content-transfer-encoding;
        bh=sItKhyjYiBTIjJbWyCsjJdRLFFEaR2+GFLFbvvEQQ8g=;
        b=HYWFzm9Hrvu9LeR0dox7vJn/G8dpCLALmTxDoXn1ilKlC3lKUEso2IY9omp2fWrULg
         aLdhil2WPoUv7Hs+CGWbzaza1084Quuxa+owNYlwHK/aBIxcavJk6Vt9mnP9bEFmYARC
         Pu0m73JwZryM3wIZlj9wTR3iWNZPcMiQ62+V1hKuWXOM7/GoX7Z4KstAaTDMNjEC7Zgd
         W9MFxIO6ZFzhLZ9Zzq8m0KgFA5rQNTyIwP2BddFgVeMPAeyFngVtqGL4AwWmg815e5IP
         ro00hg+5eWsIHdlfkQv6HZrKLpSyYQcqWQBKSd2M6uwWbjFxXaU6CzkRaJfvvIieiM7i
         6R/A==
X-Gm-Message-State: AOAM533HlpYq/0wc3KVl0KCDLQqXwF8DQow6qlO24wsyjwuoPlm8Itkz
        bggI6W8QY0uTWt42aCp/Ws9J2Q==
X-Google-Smtp-Source: ABdhPJxTyCrS99bXEs/Aq31tycZyMFH9/2cuo3exypyaTaOHipoMZ+y1Metycy+IFqMStfXLdiR+Rg==
X-Received: by 2002:a17:90b:1c91:: with SMTP id oo17mr7104592pjb.58.1641429009060;
        Wed, 05 Jan 2022 16:30:09 -0800 (PST)
Received: from localhost.localdomain (c-73-231-33-37.hsd1.ca.comcast.net. [73.231.33.37])
        by smtp.gmail.com with ESMTPSA id x19sm162272pgi.19.2022.01.05.16.30.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 16:30:08 -0800 (PST)
From:   Brian Silverman <brian.silverman@bluerivertech.com>
Cc:     Brian Silverman <bsilver16384@gmail.com>,
        Brian Silverman <brian.silverman@bluerivertech.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org (open list:CAN NETWORK DRIVERS),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] can: gs_usb: Zero-initialize flags
Date:   Wed,  5 Jan 2022 16:29:50 -0800
Message-Id: <20220106002952.25883-1-brian.silverman@bluerivertech.com>
X-Mailer: git-send-email 2.20.1
Reply-To: Brian Silverman <bsilver16384@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No information is deliberately sent here in host->device communications,
but the open-source candleLight firmware echoes it back, which can
result in the GS_CAN_FLAG_OVERFLOW flag being set and generating
spurious ERRORFRAMEs.

Signed-off-by: Brian Silverman <brian.silverman@bluerivertech.com>
---
 drivers/net/can/usb/gs_usb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index 1b400de00f51..cc4ad8d59bd7 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -507,6 +507,7 @@ static netdev_tx_t gs_can_start_xmit(struct sk_buff *skb,
 
 	hf->echo_id = idx;
 	hf->channel = dev->channel;
+	hf->flags = 0;
 
 	cf = (struct can_frame *)skb->data;
 

base-commit: d2f38a3c6507b2520101f9a3807ed98f1bdc545a
-- 
2.20.1

