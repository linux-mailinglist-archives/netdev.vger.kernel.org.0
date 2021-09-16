Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB09D40E52D
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 19:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350045AbhIPRIl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 13:08:41 -0400
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:54134
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349623AbhIPRGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 13:06:33 -0400
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 1877C4025C
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 17:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1631811911;
        bh=rJLndy7vYT8KK3DyfsRiA9NiE5njla3gXvJ0MjK8FFQ=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=AA6A4GkZWMAE5Q0jXK9qZJw5aGDocZDqrzEEaP4iUbiShcdpZ53HWqAF5Pg6EShuA
         +wDG9m2hdGzc0OhdlyD12yOooo7Y1anVHUSMHG80s2xyWwJ6X83oXTXI78H05NGgli
         ORevqNRBon82UgJuHXId2/IjKbk5PGNfvB01JgVMMiG2Un+6IfK3YS1xCb9Ew5BGr5
         ZtHifXEPxUlNdMnfkygfywhNf/y0PWdUONru29n9HfpcBhgI4UDucCneeQHbvdQv+Q
         LbAZVC8ycb7szcap/VyJ9SNv3vkOLfEJONkEmzrCJdWwkL5CAmUoo7peQisXvdy92y
         7a9I5Ubq5OYqw==
Received: by mail-wm1-f69.google.com with SMTP id x10-20020a7bc76a000000b002f8cba3fd65so2817002wmk.2
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 10:05:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rJLndy7vYT8KK3DyfsRiA9NiE5njla3gXvJ0MjK8FFQ=;
        b=1efxZObt3dD0ieDlrfbuuQsPaz7mRu16udeiLeEuLAgFK2hAAJ77EjfyhhLARyYQPu
         3zeTAOIJ4FvAR8qDcYfPOuZ5beJHglTpXy9nX2XBCHQVqt8XFXc8jXWXmRkUhQ+WdQq/
         b4SznN8onREvYZ+RzjbwT3Dh9NYFzMJ+iWX4QaakrvY+WiD4aOglUB7jyHJ4MtKRT1ud
         8FRrJE8Myex5/LURvL8xIPTBJOZ1g/ACE99geiTXm84yJvBn54RB3A56qQ3RdQGRAdPq
         hhNsJi1nry/NBQnjXKbImLvurZhyQ3iqs369r+LZ0GLU2h0EKtq5YjPtzHGJ7flkouyE
         dpmg==
X-Gm-Message-State: AOAM533+nM9lbng/jDZ+VWKbX2aNJSEKMGyhMXHjAo4KLBShJqvysb55
        VyzesRjhWmugd3BWTP0AIZ4XtUTtf41LaUVSnJ3/V/POK458ZBzkPnkmlYbV4xHidCH9pzW5TLc
        SE6PeA37CEujWUtmdCUflJl6FwOYOySCF7g==
X-Received: by 2002:adf:c550:: with SMTP id s16mr7421755wrf.25.1631811910775;
        Thu, 16 Sep 2021 10:05:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxFYtHcY/pCrEnne5d5sj3Tc+0m4I8Dcf1ztUXT2sEDAI/adJeu3Bu9HXH0roVlg18oA0IcyA==
X-Received: by 2002:adf:c550:: with SMTP id s16mr7421732wrf.25.1631811910658;
        Thu, 16 Sep 2021 10:05:10 -0700 (PDT)
Received: from kozik-lap.lan (lk.84.20.244.219.dc.cable.static.lj-kabel.net. [84.20.244.219])
        by smtp.gmail.com with ESMTPSA id c15sm4139190wrc.83.2021.09.16.10.05.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Sep 2021 10:05:10 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH] net: microchip: encx24j600: drop unneeded MODULE_ALIAS
Date:   Thu, 16 Sep 2021 19:05:08 +0200
Message-Id: <20210916170508.137820-1-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MODULE_DEVICE_TABLE already creates proper alias for spi driver.
Having another MODULE_ALIAS causes the alias to be duplicated.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/net/ethernet/microchip/encx24j600.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/encx24j600.c b/drivers/net/ethernet/microchip/encx24j600.c
index ee921a99e439..c548e6372352 100644
--- a/drivers/net/ethernet/microchip/encx24j600.c
+++ b/drivers/net/ethernet/microchip/encx24j600.c
@@ -1122,4 +1122,3 @@ module_spi_driver(encx24j600_spi_net_driver);
 MODULE_DESCRIPTION(DRV_NAME " ethernet driver");
 MODULE_AUTHOR("Jon Ringle <jringle@gridpoint.com>");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS("spi:" DRV_NAME);
-- 
2.30.2

