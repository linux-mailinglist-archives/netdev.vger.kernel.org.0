Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3EA3408DEF
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 15:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240235AbhIMNal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 09:30:41 -0400
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:57740
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240595AbhIMNWD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 09:22:03 -0400
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id C015440264
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 13:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1631539246;
        bh=Lf3U+DHYhMpuIl7nTJH6GPAYe+llXfLG7+wtuS7r1DY=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=C9UVcbIUq3O4jN/3iHXwE6SSuKueuzAPU+yMYAhssYEWhd+HFJKX9NQCyZeGXBBm0
         i542P4TyYCPz9wzsaKw1+fcRKbXbNbDzmnsgaPX6BuyUYa8Hr+Bq+kRESdzohlzahQ
         zzqQAtkNcArCVaQEdKTWb0HvdE/bhhQ4fkEG1Su94IviI5ofwt3RNBlTGsY1kLN+Xm
         G5gh62mfmk1AcRG82xVUhZV+pb5cd7YldXe96TNdn8LBXR6zEx9Hf1f1lHL5gaY2hz
         oYRQK7bN1s9aoNeXAb7oNZeAXtUYB54cpWYSIe0NfD9ynDM9aPioGj45N93QuqxO9G
         +6TFKvJ63c5Fw==
Received: by mail-wm1-f70.google.com with SMTP id 5-20020a1c00050000b02902e67111d9f0so4912823wma.4
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 06:20:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Lf3U+DHYhMpuIl7nTJH6GPAYe+llXfLG7+wtuS7r1DY=;
        b=szR19Crz0Rj5WtzViubzl1odTiHZsJM86Uuj0zuM+3VMDTPhXoTQObG6cTcIm5q7mC
         8g79bkGeOvr020Y59XEWnPvkRBhly2BDvwY7q8i30mZhwUF6zw8Pr7tTddfEFhywyeeK
         rn7NmIUzAX6UmNZw0r7tc7mXtXH735g5sAm0iXCoDqiheil+mawXXN4MOBOORJJWHaf2
         wj00pq6/OMokPVq+LAoz3HTPGIS9wN/tYjTn0HU0mWX7dXlZAQapcMifuqhXs0Zz8Gqo
         May2tV/cgNKVUjFXXkxD9sxVSZurBvFXwZ29ezT2yaVMVuFxS/1wPEsGdVI+KpZT5ugF
         DIWw==
X-Gm-Message-State: AOAM5303yEtoQoOUolZ8sPFDDSznPhF3Zd2CJOFhSxTbvW2LFv5ghVNJ
        1MgPtJsFkwGQ9uX2+a0HXkWSJ+9eYiyRCrkN2QWmhT0IP3RCAAnWljyLXmi9FpekDkhjpdVSMOv
        T2aVB8A43Q+DwPJbEOjiZE7zXGDGKVftBfw==
X-Received: by 2002:adf:f90f:: with SMTP id b15mr12528812wrr.364.1631539246422;
        Mon, 13 Sep 2021 06:20:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwO4lsG5wdmhKIDutLLy9acqil5ZkWEOWZw6YwdcZcxBYqUrgu1dwPeeITR5yS7gtM6A2hFVg==
X-Received: by 2002:adf:f90f:: with SMTP id b15mr12528787wrr.364.1631539246274;
        Mon, 13 Sep 2021 06:20:46 -0700 (PDT)
Received: from kozik-lap.lan (lk.84.20.244.219.dc.cable.static.lj-kabel.net. [84.20.244.219])
        by smtp.gmail.com with ESMTPSA id n3sm7195888wmi.0.2021.09.13.06.20.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 06:20:45 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        Mark Greer <mgreer@animalcreek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH v2 03/15] nfc: nci: replace GPLv2 boilerplate with SPDX
Date:   Mon, 13 Sep 2021 15:20:23 +0200
Message-Id: <20210913132035.242870-4-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210913132035.242870-1-krzysztof.kozlowski@canonical.com>
References: <20210913132035.242870-1-krzysztof.kozlowski@canonical.com>
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

