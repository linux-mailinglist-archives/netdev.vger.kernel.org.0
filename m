Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50A7A1DB20A
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 13:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbgETLo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 07:44:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726933AbgETLoZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 07:44:25 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE3D0C061A0F
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 04:44:24 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id g12so1613870wrw.1
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 04:44:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=v4BoYkqJ2NsZ2nSSjChgUqJJCyqhbfFRrbuVJ3n7szg=;
        b=G2HzL5rdxl8gOOIQV4qlZMw3KWQcZxPW/z+oED1akrqOkokebIn2QxctEc0qMGDENR
         fnBBgU7agpoX1odvaMiQMUaCWrKwE3w7DwOPyGoM5q07zcNglYB1JReA7BQ9Lnf7Ho5N
         X+dwG8oPPExdKj/4jVBNByIeraaDXpT0uVTtEvtSUeuC6Pe7J47V/bSYcOkQD87Jaqdo
         gvrlYFLb2bO/N5ysRqcO1/aOVVirM77Zra0to9qgOQxKpGhC/2rl6GcazkmeCMmjTo/U
         ofBPPKGz0CMTClSICNtkP+NiGp4om1xqGgOZGmUe6v7G9i3pjDQcnm4Hty7lEAXw6smR
         10vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v4BoYkqJ2NsZ2nSSjChgUqJJCyqhbfFRrbuVJ3n7szg=;
        b=iT5u5tLZHmtpotc917U+nA8eNluA1fXm7/yBmk2FZ0KbdmDDNZJd+U0o60k5DVpxot
         H0xf3enyLHYJ/SXMmpn7UdWnYmGGR6AvTMbL4SuhInIQkmj6iInLFiqEmrLSA73NRSf1
         ryVkIArfX+ih3ETOjGpZ45Tbvb5+XsSTPWFGEmeJhbLc2tF9TrASiAtTorYjcLIKEkdH
         eEMXXn0qldQWkG3/68YbgAi37kRnXGMISaOzYoqn6H2y+6fPZXe1lCt/+uSuVC7P6PXj
         9FNWRJ7sceNkIPGJGeJNzto7p6yllPWhT/M7zLroXoGwxeCUwrB7gWOyywIMaKGSSARj
         XO1A==
X-Gm-Message-State: AOAM531n/OT1MSbfkEVAm45j6wTZDxiP6HCGJC+/Ko6/dTp9i/tYberU
        bmr52jCVrlsHIXKcujE9Eftizw==
X-Google-Smtp-Source: ABdhPJwCKG6qiFzuF7aH6jSWA6csbzJ8395j7lIhL5oX0eAbSe/2g9fc+9TJo6lUPU9TiTHyfgaB9g==
X-Received: by 2002:adf:afe9:: with SMTP id y41mr4193800wrd.56.1589975063620;
        Wed, 20 May 2020 04:44:23 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id q2sm2530782wrx.60.2020.05.20.04.44.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 04:44:23 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Jonathan Corbet <corbet@lwn.net>,
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
Subject: [PATCH 1/5] Documentation: devres: add a missing section for networking helpers
Date:   Wed, 20 May 2020 13:44:11 +0200
Message-Id: <20200520114415.13041-2-brgl@bgdev.pl>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200520114415.13041-1-brgl@bgdev.pl>
References: <20200520114415.13041-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Add a new section for networking devres helpers to devres.rst and list
the two existing devm functions.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 Documentation/driver-api/driver-model/devres.rst | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/driver-api/driver-model/devres.rst b/Documentation/driver-api/driver-model/devres.rst
index 46c13780994c..50df28d20fa7 100644
--- a/Documentation/driver-api/driver-model/devres.rst
+++ b/Documentation/driver-api/driver-model/devres.rst
@@ -372,6 +372,10 @@ MUX
   devm_mux_chip_register()
   devm_mux_control_get()
 
+NET
+  devm_alloc_etherdev()
+  devm_alloc_etherdev_mqs()
+
 PER-CPU MEM
   devm_alloc_percpu()
   devm_free_percpu()
-- 
2.25.0

