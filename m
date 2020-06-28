Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1F020CA18
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 21:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726941AbgF1TyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 15:54:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726834AbgF1Tx5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 15:53:57 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1966EC03E97B;
        Sun, 28 Jun 2020 12:53:57 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id rk21so14544833ejb.2;
        Sun, 28 Jun 2020 12:53:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=b9kv/WRpFNxhscBQ0mp9gvC658NN3RHBgTIAlVk4Lmo=;
        b=QlgOiKYmjXAmGMVksdlwj06M102fXqaDHrqcbFl74zJlTv0xwj1vrhjvDDCDfemqft
         6mtYiVK5Cy2YLkLDAggsCVYz2TBEjdEY3SdynA3TPdSYDiEKgzl6N+4KvgcSqqnEEX2I
         0KVY7m6X7KpY1uyEJYGswOrrQ8N2NkJOhVybIV5Wu9eITZ2V36IjxYuP3qCvDnxvhs72
         rLrxYLM0fI2ybFkfLpYv3x5GKiXyhXyAtI652hAsFc8TZZvCFOHmH8UCzkn4fIMJzNri
         VWhyIpet71q6XZMlp3daV6QbWbIqqDVDqc9kuexHxB5sf9el04dpqWc1bS+EJH6AFihL
         4SHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b9kv/WRpFNxhscBQ0mp9gvC658NN3RHBgTIAlVk4Lmo=;
        b=IoK+G4MkCupjatW1uV0dStl7CMJLZX18jwZqUXCW8+MmdduoHgZZI5v+HmQSRUoW7Q
         8b1s7mSNAgX5Gr76nFx7rxQCo+on71eclQtcIshcmTYPfX6ErURWRWC4i7l0Xe/rgVns
         EomQhrsEWx4Mb439ENH29IYn+KY2iT2sP1GXmf2tEKX0tKdhmTu3/JRaweLmONGGcpNQ
         bv/UyVSeETXkpiQ+7/qAbpsAEUWbvMmaZfmp+2lldYcXH0J6/LLlL5UeW9Q1/KGtBzsG
         lA2aD2Yg+bGNDPXnK+tfsrVPOFBepcOemt6lKhCsQTEZKdkQN3pIyGLeMH79jg9luo3X
         FiSA==
X-Gm-Message-State: AOAM533IcZhuMw6i5s4uKz66tB8l5msfnA66/5LN+elmILuWBfdh1h3z
        I01NK1tin7tIPmuZtz+tXUY=
X-Google-Smtp-Source: ABdhPJwz+/sfJQ25wk8u3i0JEQcC45AjemvN/kuwHpDeY34B7oXVJ0M5WF3iVu1gHiUUWHZPdCMUZg==
X-Received: by 2002:a17:906:ce32:: with SMTP id sd18mr11630711ejb.228.1593374035852;
        Sun, 28 Jun 2020 12:53:55 -0700 (PDT)
Received: from localhost.localdomain ([2a02:a03f:b7f9:7600:f145:9a83:6418:5a5c])
        by smtp.gmail.com with ESMTPSA id z8sm15669531eju.106.2020.06.28.12.53.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2020 12:53:55 -0700 (PDT)
From:   Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        oss-drivers@netronome.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Subject: [PATCH 12/15] usbnet: ipheth: fix ipheth_tx()'s return type
Date:   Sun, 28 Jun 2020 21:53:34 +0200
Message-Id: <20200628195337.75889-13-luc.vanoostenryck@gmail.com>
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
 drivers/net/usb/ipheth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/ipheth.c b/drivers/net/usb/ipheth.c
index c792d65dd7b4..b09b45382faf 100644
--- a/drivers/net/usb/ipheth.c
+++ b/drivers/net/usb/ipheth.c
@@ -358,7 +358,7 @@ static int ipheth_close(struct net_device *net)
 	return 0;
 }
 
-static int ipheth_tx(struct sk_buff *skb, struct net_device *net)
+static netdev_tx_t ipheth_tx(struct sk_buff *skb, struct net_device *net)
 {
 	struct ipheth_device *dev = netdev_priv(net);
 	struct usb_device *udev = dev->udev;
-- 
2.27.0

