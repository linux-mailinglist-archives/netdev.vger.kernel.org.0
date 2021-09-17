Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E704E40F4BE
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 11:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241110AbhIQJ1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 05:27:36 -0400
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:48746
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245583AbhIQJXN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 05:23:13 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id EB7FB4029E
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 09:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1631870510;
        bh=8kRdq1h/rOcp7tDUe+pfYyXLAzVzwB4YRYsXoc7emlw=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=Ocm0CEQtD72JeY9Gz2auIp6JaeNizCb2LGMJdduwOVpyIsnfffZE68vocQDf9gWDd
         P8Ds26h2Ylo5dZfbs3TIH6TxiNsxPX5VFFLLE1MhGtilIfaGHcRS1uIA/s4Q1mabUq
         GKCXIDAlRuVDPqHHiG5AGpqwF9envdm+xKj6HvcpUFjrUXfrUX29KrxJnMwhwLYPB5
         OFCvrg2gmkRXlqF013LBoVgl/p76Dmd/66LtC4JcKuBEMWDXquOfWzeR89jgofiDsn
         /SvH21VHDYKF1IoS00DhglxAbd+PEjMmUWaC5NXmm11cQjRDP+Ra6hRRUvUdiJsLME
         IXsjuvodBWPSA==
Received: by mail-wr1-f72.google.com with SMTP id c15-20020a5d4ccf000000b0015dff622f39so3478653wrt.21
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 02:21:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8kRdq1h/rOcp7tDUe+pfYyXLAzVzwB4YRYsXoc7emlw=;
        b=d9IkncWb9iXzhvX79ikN5MhdW85/CMk+Ix/tUcaHLRVudH026j8HFNc8zvpmgF5rVw
         um8JJ7GYq8W+45745t9KnKJ0YrFd74rA/PWlh5GmOvtDjN9u2YW2WeLUCopxPpvOHPdU
         x3T7qokp5Zw192e58oScyD5+EjqrtsEn3RdNZrkICWtTVAj78iA8AQSd88pfeuFY5CV9
         fMKPsKbZBR5v8L3XpcVCH49xPLDUTpeO1aNsPecaAMqK8aptTt1zVBZ41t0eENQ68v76
         TRp/xu2VVF32i0+WtdAbBt0MNQFWbvqoyHMgL9MUZ5v4wNKKzNZRfLRT0I9o5RuVBsST
         UP1A==
X-Gm-Message-State: AOAM532ZFtXCKuCLBLbDrY9qjFtH0LIwt+czUiZA9GfjXoYwsWgs5exa
        +gUlhAsyy2YyMeLk2di5nVnZE4u39MQ+AGWLkIuab+LDknMKEp+SYDA6l0OVyKt0usSXlt2IHaK
        uJybdPnr7eXdVuiSpHwwN5nA5XaIuJaHGjA==
X-Received: by 2002:a1c:4b15:: with SMTP id y21mr9069042wma.183.1631870510135;
        Fri, 17 Sep 2021 02:21:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwHa4EHrl3+qnJ9pDMOBd42Fw6stTQhTc5YNaXUo3xg5W4hvB+dYpYzD3TTfy1so3q3hGtBuw==
X-Received: by 2002:a1c:4b15:: with SMTP id y21mr9068979wma.183.1631870509293;
        Fri, 17 Sep 2021 02:21:49 -0700 (PDT)
Received: from localhost.localdomain (lk.84.20.244.219.dc.cable.static.lj-kabel.net. [84.20.244.219])
        by smtp.gmail.com with ESMTPSA id n3sm5921163wmi.0.2021.09.17.02.21.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 02:21:48 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Pontus Fuchs <pontus.fuchs@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Daniel Drake <dsd@gentoo.org>,
        Ulrich Kunitz <kune@deine-taler.de>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, zd1211-devs@lists.sourceforge.net
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: [PATCH 2/3] ar5512: remove duplicate USB device ID
Date:   Fri, 17 Sep 2021 11:21:07 +0200
Message-Id: <20210917092108.19497-2-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210917092108.19497-1-krzysztof.kozlowski@canonical.com>
References: <20210917092108.19497-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The device 0x157e,0x3006 is already on the list.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/net/wireless/ath/ar5523/ar5523.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ar5523/ar5523.c b/drivers/net/wireless/ath/ar5523/ar5523.c
index 49cc4b7ed516..0e9bad33fac8 100644
--- a/drivers/net/wireless/ath/ar5523/ar5523.c
+++ b/drivers/net/wireless/ath/ar5523/ar5523.c
@@ -1772,9 +1772,8 @@ static const struct usb_device_id ar5523_id_table[] = {
 	AR5523_DEVICE_UG(0x0846, 0x5f00),	/* Netgear / WPN111 */
 	AR5523_DEVICE_UG(0x083a, 0x4506),	/* SMC / EZ Connect
 						   SMCWUSBT-G2 */
-	AR5523_DEVICE_UG(0x157e, 0x3006),	/* Umedia / AR5523_1 */
+	AR5523_DEVICE_UG(0x157e, 0x3006),	/* Umedia / AR5523_1, TEW444UBEU*/
 	AR5523_DEVICE_UX(0x157e, 0x3205),	/* Umedia / AR5523_2 */
-	AR5523_DEVICE_UG(0x157e, 0x3006),	/* Umedia / TEW444UBEU */
 	AR5523_DEVICE_UG(0x1435, 0x0826),	/* Wistronneweb / AR5523_1 */
 	AR5523_DEVICE_UX(0x1435, 0x0828),	/* Wistronneweb / AR5523_2 */
 	AR5523_DEVICE_UG(0x0cde, 0x0012),	/* Zcom / AR5523 */
-- 
2.30.2

