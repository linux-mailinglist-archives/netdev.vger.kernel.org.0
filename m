Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14686308E14
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 21:08:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233181AbhA2UHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 15:07:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233033AbhA2Txb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 14:53:31 -0500
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4301BC0613D6;
        Fri, 29 Jan 2021 11:52:51 -0800 (PST)
Received: by mail-qt1-x82b.google.com with SMTP id d15so7551210qtw.12;
        Fri, 29 Jan 2021 11:52:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7fVbGNql8fbM24WicwqR5l8k2H47U7DaRICOGVwNnLU=;
        b=hdhcZw3olGLsEdGhZ3gow6JOKe3PKQFMZyJGfWdUVOxSPj58arRfqyjqbCztYJfZTn
         9Sn/JGUlxamGsQzhELEOxYxVBuuVsoZtjSnX7t9NXO/GxxhoIoJCkbmkh4ZVbID4Ho4m
         f2L0/UYmZBXMofxR+SeCco/Jl+VeoFNQ4T0AoCyofM0IuBYhFbweGQEP1CjhHmtV0D++
         06fNhbWbcp7AkVi36LnhSGjdUV8E3YPqX+0BNx6g3R8rWiME0wjRhBulxU6WQw4SlZKd
         IED3LMHsOW+BBGylFp7C6jYYTeZG8xCq8zTCr/EyAOv3eFv52JNjWtoqu/iaTOZnpxmi
         Psbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7fVbGNql8fbM24WicwqR5l8k2H47U7DaRICOGVwNnLU=;
        b=FV89ywzXTDkTvSxmqRyhzSMnWDAekub6H8LYJPkBDQDUP/JKCSNnbIS4PdyoZ4m2NA
         BinrUZVfMXpCsCFFPFJAYil5J+CtvWb1/fWGEqsyj+xB4X79yCZYKoPDj2+z2V45yIzM
         6XlQ9w7P/9a0F32hIUE8aPP5WwB6TFHEuD48Fi1YuP1ZMDEVGBlAO9oBnpTnntfIuYug
         gl8fWQrc5fzsMgMSMImWmT70FlIJ4PyXHGEVRW788bf4xohxQchOUhl3V4/2F7XkFisK
         lJwqKRrRjaq2eOEkbPsmwKN32MGvNfC9ClbMuxu/GQsz/k1QRLNr6nC3MKZBMK7B9CAM
         3AoA==
X-Gm-Message-State: AOAM532LaoE8SmvmHu8Kf7nHxbk2wa2I+E0m97ODXBlDKqOcbkpnuefz
        9jIZBIrAgqmMpKWlQF5RFZw=
X-Google-Smtp-Source: ABdhPJxMTIt4opqGB3q1wi+2z3hDi555Ieo1PrBfa6K0Eb7wXb61S0UGk7brTaTRUeRUXzCeatXOiQ==
X-Received: by 2002:ac8:ecc:: with SMTP id w12mr5698078qti.371.1611949970337;
        Fri, 29 Jan 2021 11:52:50 -0800 (PST)
Received: from localhost.localdomain ([198.52.185.246])
        by smtp.gmail.com with ESMTPSA id s136sm6558994qka.106.2021.01.29.11.52.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jan 2021 11:52:50 -0800 (PST)
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
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v1 4/6] TEST ONLY: lan743x: limit rx ring buffer size to 500 bytes
Date:   Fri, 29 Jan 2021 14:52:38 -0500
Message-Id: <20210129195240.31871-5-TheSven73@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210129195240.31871-1-TheSven73@gmail.com>
References: <20210129195240.31871-1-TheSven73@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Van Asbroeck <thesven73@gmail.com>

Signed-off-by: Sven Van Asbroeck <thesven73@gmail.com>
---

Tree: git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git # 46eb3c108fe1

To: Bryan Whitehead <bryan.whitehead@microchip.com>
To: UNGLinuxDriver@microchip.com
To: "David S. Miller" <davem@davemloft.net>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Alexey Denisov <rtgbnm@gmail.com>
Cc: Sergej Bauer <sbauer@blackbox.su>
Cc: Tim Harvey <tharvey@gateworks.com>
Cc: Anders Rønningen <anders@ronningen.priv.no>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org (open list)

 drivers/net/ethernet/microchip/lan743x_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 618f0714a2cf..ed4959ad9237 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -1973,7 +1973,7 @@ static int lan743x_rx_init_ring_element(struct lan743x_rx *rx, int index)
 	dma_addr_t dma_ptr;
 	int length;
 
-	length = netdev->mtu + ETH_HLEN + 4 + RX_HEAD_PADDING;
+	length = 500 + ETH_HLEN + 4 + RX_HEAD_PADDING;
 
 	descriptor = &rx->ring_cpu_ptr[index];
 	buffer_info = &rx->buffer_info[index];
-- 
2.17.1

