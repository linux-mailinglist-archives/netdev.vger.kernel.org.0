Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCD6D40F4D8
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 11:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240949AbhIQJen (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 05:34:43 -0400
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:49102
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239040AbhIQJei (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 05:34:38 -0400
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id EDC1F3F4BE
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 09:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1631871195;
        bh=tTVAXZIbg+nscSqjGmCmN2vkVa6NbzShnNR0nlGi+3E=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=Lrt3zRGvVKloZNT7u3AkiPcujxjZ0AnB80L4yiwdz36Vy4gxA2pJzep6bLKRfAPzR
         UMRxbUJRoDfqW7zvVmUOI3/5nF2MbayzQnCrpM90HbTvfCY2b7WFebg+2rEV/QkKNR
         Q/0jDTGtSya4Q9a2OOc1Vb9tt0o7ICue8cOponxutwzthSf7KKgyT2lW+VXfFGi0Bk
         AQ8OYsYzi3tUAVtDkLIXNMIWM8qhk6El9hrPzbKSpOS8Arr3sOaAcQtCn1uFL+/Il+
         jjLeeR1Ht7vT/hp5lVfsxWWCh524l+Rn3u2DwTvyt9Pt+S7vq01zEptgIJa+GRzyIt
         DqO2lvFP+uqaQ==
Received: by mail-wm1-f71.google.com with SMTP id n17-20020a7bc5d1000000b002f8ca8bacdeso1620726wmk.3
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 02:33:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tTVAXZIbg+nscSqjGmCmN2vkVa6NbzShnNR0nlGi+3E=;
        b=QHzddTDv2NMOhQl8CH0ib1gKr6c1WbCPxjSOMDjoby34Vrc43xnUPXcsdBqTemphMd
         nj+HI2eXO0HF8c6MtCYehM3gBq9Y+RLWg9cMe+NqVn9e15fHXpufg89uR5HVMBHIB1IM
         OTnYGqvpfVw3KjaKzIAfxNIHn3LXvisXfVF6BPIPDjcIpyWjjHOKVjIPIiBL05YqTZbK
         0rnIjePz+ZhVidOK5LeysHhrHipxWzdNnd63GqZefPVXn2mOwUkQ6wVFEvfqvPHd6olO
         2teDhrrdPNdwF69NArBfJSPY8L+WIccTz6qPdY30tqzM3HQq3VIrrZPyAZ0lCqNQf9mc
         JcaA==
X-Gm-Message-State: AOAM530AV0sRS4p/5FSqrpGhtczmRRF1VQ2Ph/WpcRAvBTI3swP83Ee1
        0pXhZFy0LVlw7ppCggfyFDGxANC5iE2c7aU5KBNG0ce+5kkDBSG3i7VwvgyKRRxCl0ejBS8HncB
        Eyk4x1spxNN4AnRTtQKAgYqS1q81jocyEhQ==
X-Received: by 2002:adf:c14c:: with SMTP id w12mr11065388wre.115.1631871195641;
        Fri, 17 Sep 2021 02:33:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzm1hfXlP9qxMJBeO0j1bvcei+pQ6mYrjdqgYy9bQhs+1gR0op82yXutPeFLLb3ukLhOIeHeg==
X-Received: by 2002:adf:c14c:: with SMTP id w12mr11065374wre.115.1631871195486;
        Fri, 17 Sep 2021 02:33:15 -0700 (PDT)
Received: from localhost.localdomain (lk.84.20.244.219.dc.cable.static.lj-kabel.net. [84.20.244.219])
        by smtp.gmail.com with ESMTPSA id n66sm5770333wmn.2.2021.09.17.02.33.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 02:33:14 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Ulrich Kunitz <kune@deine-taler.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, zd1211-devs@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Daniel Drake <drake@endlessos.org>,
        Daniel Drake <dsd@laptop.org>
Subject: [PATCH] MAINTAINERS: zd1211rw: Move Daniel Drake to credits
Date:   Fri, 17 Sep 2021 11:32:36 +0200
Message-Id: <20210917093236.21424-1-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Drake's @gentoo.org email bounces (is listed as retired Gentoo
developer) and there was no activity from him regarding zd1211rw driver.

Cc: Daniel Drake <drake@endlessos.org>
Cc: Daniel Drake <dsd@laptop.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 CREDITS     | 1 +
 MAINTAINERS | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/CREDITS b/CREDITS
index 7ef7b136e71d..d8f63e8329e8 100644
--- a/CREDITS
+++ b/CREDITS
@@ -971,6 +971,7 @@ D: PowerPC
 N: Daniel Drake
 E: dsd@gentoo.org
 D: USBAT02 CompactFlash support in usb-storage
+D: ZD1211RW wireless driver
 S: UK
 
 N: Oleg Drokin
diff --git a/MAINTAINERS b/MAINTAINERS
index 15a5fd8323f7..92326aa23f35 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -20750,7 +20750,6 @@ S:	Maintained
 F:	mm/zbud.c
 
 ZD1211RW WIRELESS DRIVER
-M:	Daniel Drake <dsd@gentoo.org>
 M:	Ulrich Kunitz <kune@deine-taler.de>
 L:	linux-wireless@vger.kernel.org
 L:	zd1211-devs@lists.sourceforge.net (subscribers-only)
-- 
2.30.2

