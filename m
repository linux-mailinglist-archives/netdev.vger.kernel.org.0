Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75D6240286C
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 14:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344188AbhIGMTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 08:19:38 -0400
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:33468
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344141AbhIGMTd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 08:19:33 -0400
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 0046240779
        for <netdev@vger.kernel.org>; Tue,  7 Sep 2021 12:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1631017105;
        bh=Lf3U+DHYhMpuIl7nTJH6GPAYe+llXfLG7+wtuS7r1DY=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=nnymz8kp/mgzjScIEynJSLO0Mz2YcEfaFbhDyohlg4NxN8OWavup8s34wsYvdgt2+
         Sps/J7Upxp7riu4drfB6OlQ9kwBSRfv1vcMAC34509xEIQP/iIXsiOkOpZooL7VArD
         HOgmVq12UXlLzuv8bmtgbjWS4u4JvsVGkEhTtk33yWchKmOd53MjTAZoPMCqy/0MJX
         uTJMSQHAKzLaTBfMUoMGXJM4qfk9lWxSis1yxZb+GRjzQMlAXJq+uaF4I7Ta5JqG4I
         yyQAfDyorNATsnr2h4eNVIuoif7U9ZdVPQToTbUgRGs09JsFAHamlvtuk6VW+ryl3y
         hVs99MdtojFoA==
Received: by mail-wm1-f69.google.com with SMTP id z18-20020a1c7e120000b02902e69f6fa2e0so3317136wmc.9
        for <netdev@vger.kernel.org>; Tue, 07 Sep 2021 05:18:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Lf3U+DHYhMpuIl7nTJH6GPAYe+llXfLG7+wtuS7r1DY=;
        b=Rcq+UuObmBxxIyIBJkw1sMPQy3UbKwG3aA8jPret03Rh5D5JRwQVrH6zMo5UkENnkl
         az8U0iOa+AeEsZiOOp++b+p1+S69H2pezrgS3M0d5M1TJMbCf+SKCWrioQ1HNKw+QPsd
         q2GSuWMUStfXpi7uxrOV8EQgRGqwalS8YbR3vEQQDm72duQkjRo02upb6bzE2FovGkUy
         MolXRe6kv0x/msfNe7UlNqnGDg0qS29GSKm2/+DjrR7qTaNuMaNHEwBdW3smSuF0ACPa
         YH6M6gXWxegEkE7t/fzfo4RU6bVtd74UqpJOxF3vr75Qt/x/LIVvCCsKVYzirs20spLO
         ermA==
X-Gm-Message-State: AOAM531OnNv7ZcG9JpJA850oHhc+Y0uAsajlJdvJNELbQEXrQODJxyVF
        XaKJK/52mYi7jjx6C0YSqM/zYokK7FUqOOqMmEMRggBW9HXsNROdNXdgvQTxuO25ztmE3tlPAG9
        yAxTwF5rLUxW/vmJiaz7DVvZWJToz59zz3w==
X-Received: by 2002:a05:600c:a49:: with SMTP id c9mr3543981wmq.159.1631017105645;
        Tue, 07 Sep 2021 05:18:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwGnITbLQyBPqv15Y5qGEl25iI8Aaoxxgo0CFdcBuZBhKAuVcx8mn1j6CPUzijO1vm85/0Uww==
X-Received: by 2002:a05:600c:a49:: with SMTP id c9mr3543965wmq.159.1631017105503;
        Tue, 07 Sep 2021 05:18:25 -0700 (PDT)
Received: from kozik-lap.lan ([79.98.113.47])
        by smtp.gmail.com with ESMTPSA id m3sm13525216wrg.45.2021.09.07.05.18.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 05:18:25 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        Mark Greer <mgreer@animalcreek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH 03/15] nfc: nci: replace GPLv2 boilerplate with SPDX
Date:   Tue,  7 Sep 2021 14:18:04 +0200
Message-Id: <20210907121816.37750-4-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210907121816.37750-1-krzysztof.kozlowski@canonical.com>
References: <20210907121816.37750-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace standard GPLv2 only license text with SPDX tag.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 net/nfc/nci/uart.c | 16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/net/nfc/nci/uart.c b/net/nfc/nci/uart.c
index 502e7a3f8948..65814dd72618 100644
--- a/net/nfc/nci/uart.c
+++ b/net/nfc/nci/uart.c
@@ -1,20 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2015, Marvell International Ltd.
  *
- * This software file (the "File") is distributed by Marvell International
- * Ltd. under the terms of the GNU General Public License Version 2, June 1991
- * (the "License").  You may use, redistribute and/or modify this File in
- * accordance with the terms and conditions of the License, a copy of which
- * is available on the worldwide web at
- * http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
- *
- * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
- * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
- * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
- * this warranty disclaimer.
- */
-
-/* Inspired (hugely) by HCI LDISC implementation in Bluetooth.
+ * Inspired (hugely) by HCI LDISC implementation in Bluetooth.
  *
  *  Copyright (C) 2000-2001  Qualcomm Incorporated
  *  Copyright (C) 2002-2003  Maxim Krasnyansky <maxk@qualcomm.com>
-- 
2.30.2

