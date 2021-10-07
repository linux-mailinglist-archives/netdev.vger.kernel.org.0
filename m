Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD19C42544C
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 15:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241697AbhJGNkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 09:40:17 -0400
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:36838
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241683AbhJGNkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 09:40:15 -0400
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 4B1B23FFF3
        for <netdev@vger.kernel.org>; Thu,  7 Oct 2021 13:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1633613901;
        bh=P9fpmr5HVieD46S8E5o8kyy5EhCx6ykcZHTMM5JxYIs=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=uFu9fqReyrlvhYZ45IDxmqQj99Kj9vm6d9iEe1oiRk9TPzBlYgzfC2iySG9yR21hg
         g9RqctzYUH82dBLyqa+9JyJ33jBR5DkT1SYth+gQiqaHW7VbvsDEmcieg1vR5pFMAb
         4ZGzDwvU5NfH19gC34AH5uJUUuO69grfZKPdI+XCEkJIQasPxUnQhIdPZIXyYKkOy4
         bHa5XuZx6GbjuoneoWrV0IHNP8z0hGB/DtjCss8PWSrO8F512kNN9w7zLwTWxKQ+LM
         GxEkVtFof8u0zd+lLU1wouWJgm8amA7ULwF6rVips/cwdDpg0BzhJe8uKf/Yu3uXPK
         iNDeC/WLLkogQ==
Received: by mail-ed1-f70.google.com with SMTP id p13-20020a056402044d00b003db3256e4f2so5969077edw.3
        for <netdev@vger.kernel.org>; Thu, 07 Oct 2021 06:38:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P9fpmr5HVieD46S8E5o8kyy5EhCx6ykcZHTMM5JxYIs=;
        b=lJ2eVBPPxAa+pFWZPlm61PnA32z1QPGclALAdmfgyzyrGp95z2wBvTgXSkOLHcvR1P
         I5vdatnrjyL1PPVn4zFfoj7JpzhohYRKtsk8f51gowUIb6M5VQRXWoft6LgW/ur6y9s/
         fJJtB9xVz2SwUtpLUTUk1HpnmdMSxmtR1TPamqsCKSfDidB7/v8s+UvIjxEx4rmbX0zU
         EHNcJ+dgjc+KXIiEUwNcpf5cWOilHJodD+odUo61148AIeFbnh+bxPqNrEffdwM86d4c
         9TfllhpCNbEINYwaQcDQSV9NihRm16+cwo7Uct0WO5eTQTGcCB43FPjet93N8I/vzB5a
         b7pQ==
X-Gm-Message-State: AOAM531C4lJnB9VdcA5OIlArpzuw3XZwtPCkn2eElqtWoH7mG+PYokL3
        EO8AmavkxL5reUVAWgyYu+84AtrxgUgCacsP7nRg5kXP7AA3QD1Wp/Qpf+kHVDow2cKBAHyPdDD
        59dr4CZ9lJwz/iZmgvbB30CdWP0Odq/mdzg==
X-Received: by 2002:a17:906:d92e:: with SMTP id rn14mr5665112ejb.526.1633613900987;
        Thu, 07 Oct 2021 06:38:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzrLgayaQycMXHVAE11eReupmBB4F2YlHzdIYfeZ/DMNQZjj8xXof0XbzXsnm7VmJ48E1Zapw==
X-Received: by 2002:a17:906:d92e:: with SMTP id rn14mr5665084ejb.526.1633613900782;
        Thu, 07 Oct 2021 06:38:20 -0700 (PDT)
Received: from localhost.localdomain (xdsl-188-155-186-13.adslplus.ch. [188.155.186.13])
        by smtp.gmail.com with ESMTPSA id ay19sm8585613edb.20.2021.10.07.06.38.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 06:38:20 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        Mark Greer <mgreer@animalcreek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [RESEND PATCH v2 2/7] nfc: nci: replace GPLv2 boilerplate with SPDX
Date:   Thu,  7 Oct 2021 15:30:16 +0200
Message-Id: <20211007133021.32704-3-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211007133021.32704-1-krzysztof.kozlowski@canonical.com>
References: <20211007133021.32704-1-krzysztof.kozlowski@canonical.com>
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
index 9bdd9a7d187e..9f7bae51404e 100644
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

