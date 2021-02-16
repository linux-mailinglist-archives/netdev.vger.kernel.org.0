Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 952CE31C4D5
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 02:10:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbhBPBJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 20:09:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbhBPBI4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 20:08:56 -0500
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 995F5C061786;
        Mon, 15 Feb 2021 17:08:16 -0800 (PST)
Received: by mail-qk1-x732.google.com with SMTP id f17so8118584qkl.5;
        Mon, 15 Feb 2021 17:08:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0Aes0eoYKnBU/4hkfiAkJ64eQvBdU6N5U0fFVJjBCKI=;
        b=vTlHsUpRTdKrqlC+Ae8ZKyAIJeKkh6CDFCMPfU5h2n24vxIhkXw0ElfxqCvmJNnlDX
         kwuXX/x4o/qydgckI5KFZzhaKDzvnSyHQYvRMMtajeXW0SO0IN1fXL9vn8/ulnSTs+Kb
         x4jAt7y+gbIga+19a1OT31dLggXiNCHwuHGIafwU/str4LI98oVbtD56o+7nlMFbPcUv
         zffkjmualGd0ZjHNtKd2MN3W/YB1wLd80JK2OTbL+cC11nk7ALmpiWWdbVcbmQUMgbdi
         kTXNJeVaO0e/8FstZKpTgUE+7HvHC92h8LM2Lr/Cq5or3u6de4c8SziyYMuFhakGERms
         xfDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0Aes0eoYKnBU/4hkfiAkJ64eQvBdU6N5U0fFVJjBCKI=;
        b=W/1Z9NYtk+LcSW6OY68iVsjfcqPkLxAIewa/0Jh1tZhOgcIEzi/liLqzqPkrI8oPpO
         Qfgg2USTgEAw9uZlOevYUabNeYbvMgubam4edykWKX20yAvmUSEI0AhwnloWMV747qBm
         52n5P4Xu7fNkF4RRAyJKll4fqzwTnDjk7KSUMRDfz3ORMdksDOgDZQQj7zPMGwEdMMOP
         HOnEpWs8/Q1R98UnZoc0Jvc7UaQOS4VES0m6fiX3Y4hi3jBvn+ic0UY//WKng3Dd74U9
         8/UWj1iKSrkXkRsYvRDkJMdt4kK18bCYYRki+LkwG7qAuYflQcSo2nmh3s5p2j0Y3aTb
         hPGQ==
X-Gm-Message-State: AOAM530DHgjd3pKq/HH7OJ99PAKKwAg0swGBFV1HhzoU3/B+r2sYu3eT
        LMnO1e1v5FC9qJ+COwgmYOQ=
X-Google-Smtp-Source: ABdhPJwECynChS5amFPmny7Jdwt/bzBjvSG3kwr2Xw2fZguyWJaXCDSZldULaq2eA/fydga8+wL7SQ==
X-Received: by 2002:a37:5b46:: with SMTP id p67mr8731510qkb.412.1613437695584;
        Mon, 15 Feb 2021 17:08:15 -0800 (PST)
Received: from localhost.localdomain ([198.52.185.246])
        by smtp.gmail.com with ESMTPSA id b20sm508830qto.45.2021.02.15.17.08.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Feb 2021 17:08:15 -0800 (PST)
From:   Sven Van Asbroeck <thesven73@gmail.com>
X-Google-Original-From: Sven Van Asbroeck <TheSven73@gmail.com>
To:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        UNGLinuxDriver@microchip.com, David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Sven Van Asbroeck <thesven73@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexey Denisov <rtgbnm@gmail.com>,
        Sergej Bauer <sbauer@blackbox.su>,
        Tim Harvey <tharvey@gateworks.com>,
        =?UTF-8?q?Anders=20R=C3=B8nningen?= <anders@ronningen.priv.no>,
        Hillf Danton <hdanton@sina.com>,
        Christoph Hellwig <hch@lst.de>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 3/5] TEST ONLY: lan743x: limit rx ring buffer size to 500 bytes
Date:   Mon, 15 Feb 2021 20:08:04 -0500
Message-Id: <20210216010806.31948-4-TheSven73@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210216010806.31948-1-TheSven73@gmail.com>
References: <20210216010806.31948-1-TheSven73@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Van Asbroeck <thesven73@gmail.com>

Signed-off-by: Sven Van Asbroeck <thesven73@gmail.com>
---

To: Bryan Whitehead <bryan.whitehead@microchip.com>
To: UNGLinuxDriver@microchip.com
To: "David S. Miller" <davem@davemloft.net>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Alexey Denisov <rtgbnm@gmail.com>
Cc: Sergej Bauer <sbauer@blackbox.su>
Cc: Tim Harvey <tharvey@gateworks.com>
Cc: Anders Rønningen <anders@ronningen.priv.no>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

 drivers/net/ethernet/microchip/lan743x_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 6b642691a676..90738ec5e7ec 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -1973,7 +1973,7 @@ static int lan743x_rx_init_ring_element(struct lan743x_rx *rx, int index)
 	struct sk_buff *skb;
 	dma_addr_t dma_ptr;
 
-	buffer_length = netdev->mtu + ETH_HLEN + 4 + RX_HEAD_PADDING;
+	buffer_length = 500 + ETH_HLEN + 4 + RX_HEAD_PADDING;
 
 	descriptor = &rx->ring_cpu_ptr[index];
 	buffer_info = &rx->buffer_info[index];
-- 
2.17.1

