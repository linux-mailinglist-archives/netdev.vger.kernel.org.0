Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDF231CDE34
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 17:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730486AbgEKPIl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 11:08:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730460AbgEKPIk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 11:08:40 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F2CEC061A0C
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 08:08:38 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id z72so10108118wmc.2
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 08:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1qePp19LiRiOBXtccpgQ+eI6GUOhz0auoBWQ11adkXY=;
        b=jSfI+/vZR/vNDIop5tYQipIr0sMk/NiKnIXCptTaZ1UCH8HUZKtoJB0OgdBC9z2vBa
         s1xE55pXv652Vn9g5VfKY+a9uy5dJ58vb388YQHIUELGwWKiI2Kklor5r7oNIbEpXyfw
         KV5YwxqgIpXxq6QZxVL59d/K3dLnJ4xHCK9jH8DxWKN9GV74AYB4ifDBaK5c8FIchySB
         jTy+eyVKoq1zegnDbhlXUrBw3PNUSPehwJhxpAelJ3W7RqurHnfFTAdHIpqCDlnFydz2
         ylL+Sv0Z6G9Wnhh7GEJTTL5mfenRpGEj6fqVZUHtSmuR5ND02ayD/nfbulwZMANrTHpk
         vrZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1qePp19LiRiOBXtccpgQ+eI6GUOhz0auoBWQ11adkXY=;
        b=C0dl2dwhO9vQah8Zgf+3UAUGllAAs5gyCnjIhGhbaLEhc59++96HRkvSdDBPkoAwm7
         VK6a70UfdljQC8tplWdzUxdem1eIDuuhZvYBX+FqV7xSSaUzEJFVLm4PuQwA6SIrDUL6
         +YQfSumGdu9yIiPbLWnrXi7JMDcSaGrxu3LuyL+5y6UBXOJyM8I/QhVjaLTNQvJwyuD6
         1rf7fiHy4nQJO5LclQZxWAPtfF8Kg+xFgZFx6QsdUuMEIHDzs/Ntuo0htfKfVRmjByaJ
         f18DbXJuwwcRabE6Mv708KEnmweZZJfkq6wkHVQPJL1LtOr495OEcbS5Lmttppz3VM3Y
         6TBg==
X-Gm-Message-State: AGi0PuaNFmXE4Rj6gqzlal+NjCH6zeUdBtY48THONXRN6i+Mtq+l+SgJ
        J4pPs2RlZtX+wds+w5zMSJ79Gg==
X-Google-Smtp-Source: APiQypKpf/qfe7MFRJIMepNxeMQg7U0eG0wqy9FY4xaWhiap/9Tgl6YqeR1YMWRXjoWZty2TygbXNQ==
X-Received: by 2002:a1c:2457:: with SMTP id k84mr30054044wmk.96.1589209717331;
        Mon, 11 May 2020 08:08:37 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id 94sm3514792wrf.74.2020.05.11.08.08.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 08:08:36 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Fabien Parent <fparent@baylibre.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Edwin Peer <edwin.peer@broadcom.com>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH v2 12/14] ARM64: dts: mediatek: add an alias for ethernet0 for pumpkin boards
Date:   Mon, 11 May 2020 17:07:57 +0200
Message-Id: <20200511150759.18766-13-brgl@bgdev.pl>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200511150759.18766-1-brgl@bgdev.pl>
References: <20200511150759.18766-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Add the ethernet0 alias for ethernet so that u-boot can find this node
and fill in the MAC address.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi b/arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi
index a31093d7142b..97d9b000c37e 100644
--- a/arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi
+++ b/arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi
@@ -9,6 +9,7 @@
 / {
 	aliases {
 		serial0 = &uart0;
+		ethernet0 = &ethernet;
 	};
 
 	chosen {
-- 
2.25.0

