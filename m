Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBFA120CA19
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 21:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbgF1TyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 15:54:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726924AbgF1Tx4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 15:53:56 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAB5EC03E97A;
        Sun, 28 Jun 2020 12:53:55 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id w6so14532413ejq.6;
        Sun, 28 Jun 2020 12:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lG9S6rgc6S6pXat0eM+7/QoqnspqcoylWLbEJTWZuTA=;
        b=RSBTdQW8TfOZ6oE8hWinHSh4w1/3phHfHSs8L93fVaBW9cxnPtsmfMaT6lLhyyRm8t
         N+in1akzVu4Si6Rr98Zq5kXDFEuPnOAkRKyAYd2KFzqvgZhljD+Jc1jeQFbhosUxQAqt
         XTnEHXLuHDah/Q7O7jwN3gDxcF1x0RUPP8U5P5jho8nhkdg8t9DSkbpuCVaSl27CvYgY
         Cy10Wr0TQ/B25KbZnuW7bxdb8fSMqvFcqPELJ5LQ+4bpkFuFA9hi8b6N0i2fWnwtoJSW
         ViuQHhfJGCbe6c4Mm1tI8uSBFHAi9r1g+VVjoG6rry4KzLZtdfWUBa52JtJfA7tixpf+
         jy9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lG9S6rgc6S6pXat0eM+7/QoqnspqcoylWLbEJTWZuTA=;
        b=mXkRsTs88/p2EO/7lgy3L3qNnh3/huF/wX8q3paDfCA1hpYG2jBZdO0JBuA8S6EPC/
         FRxhw+ip4xb7KstBoKk+kinxVRSkQ8FRlYDLYvluKP6c2f/6BjwWRjBJT8d9FxTgJuuR
         2i5Sc+loLYtOL62a4hPgzo5N0kPPtS7RXfVmqdcHoQtG1itAJcJOtu8v4NSuTJwr2rTr
         XI+P58WR+C429atSfHdhCToA83+MJQgK29bApax5NRdzESuB2qEUz49aOdJHiQr6RJrC
         dy8cgsmVYSRTlC59/AyAl4Zb8dNHU+swpdc+xzH4Bo+UpoiZjLlsXhyar3j4EGXRPZc4
         NXMg==
X-Gm-Message-State: AOAM530pPo2ccrsvXpqNdQmt/Rng1AmPmJWACwqStKm26FD+XaE+Wb1n
        G7IHLWTAafZrSMLDBKrHdE4=
X-Google-Smtp-Source: ABdhPJzFTsjHxDUS0X+9s1aMZdMme6m9QCTGIdVRVOluKrLNEQRpGod5gH/ba3CPWAvfc2zXf0iqaw==
X-Received: by 2002:a17:906:7751:: with SMTP id o17mr11775877ejn.111.1593374034751;
        Sun, 28 Jun 2020 12:53:54 -0700 (PDT)
Received: from localhost.localdomain ([2a02:a03f:b7f9:7600:f145:9a83:6418:5a5c])
        by smtp.gmail.com with ESMTPSA id z8sm15669531eju.106.2020.06.28.12.53.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2020 12:53:54 -0700 (PDT)
From:   Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        oss-drivers@netronome.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Subject: [PATCH 11/15] net: plip: fix plip_tx_packet()'s return type
Date:   Sun, 28 Jun 2020 21:53:33 +0200
Message-Id: <20200628195337.75889-12-luc.vanoostenryck@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200628195337.75889-1-luc.vanoostenryck@gmail.com>
References: <20200628195337.75889-1-luc.vanoostenryck@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The method ndo_start_xmit() is defined as returning an 'netdev_tx_t',
which is a typedef for an enum type, but the implementation in this
driver returns an 'int'.

Fix this by returning 'netdev_tx_t' in this driver too.

Signed-off-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
---
 drivers/net/plip/plip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/plip/plip.c b/drivers/net/plip/plip.c
index e89cdebae6f1..d82016dcde3b 100644
--- a/drivers/net/plip/plip.c
+++ b/drivers/net/plip/plip.c
@@ -142,7 +142,7 @@ static void plip_timer_bh(struct work_struct *work);
 static void plip_interrupt(void *dev_id);
 
 /* Functions for DEV methods */
-static int plip_tx_packet(struct sk_buff *skb, struct net_device *dev);
+static netdev_tx_t plip_tx_packet(struct sk_buff *skb, struct net_device *dev);
 static int plip_hard_header(struct sk_buff *skb, struct net_device *dev,
                             unsigned short type, const void *daddr,
 			    const void *saddr, unsigned len);
@@ -958,7 +958,7 @@ plip_interrupt(void *dev_id)
 	spin_unlock_irqrestore(&nl->lock, flags);
 }
 
-static int
+static netdev_tx_t
 plip_tx_packet(struct sk_buff *skb, struct net_device *dev)
 {
 	struct net_local *nl = netdev_priv(dev);
-- 
2.27.0

