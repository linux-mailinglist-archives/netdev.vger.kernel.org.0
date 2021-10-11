Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91FC6428E36
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 15:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237103AbhJKNlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 09:41:24 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:42286
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231565AbhJKNlT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 09:41:19 -0400
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com [209.85.167.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id AE00440019
        for <netdev@vger.kernel.org>; Mon, 11 Oct 2021 13:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1633959558;
        bh=8wnvnlFr7Z9I1aV6d98j8RCw9C64nkeTjGiPt6idSBY=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=Kg6M+/VzyrruV4oqFThM1uruFoMVzBOuK6fGtBZP3yn3/lQBzUqAKLBivqqUvvTrP
         W8MrmzUfqZnr9rvenkEdJZLcZoHwLGXppKVzvA444H93Tuvbk6oh0BA9b2E5OVu7xo
         IWb0+cGBcg/yIHWqUZFEs+cFCEEWMgh/B2N1qr8ZIrDfCGsu7My0usP2dv+wGXcHHq
         G+kTRvYJOuIRDa1PU9ZKJk855UlwJeBiOU+MkrrUJBkpyl44Lm96ztBi3JUhjp1Jg8
         qO/kvQm1Tda/aiPDENqTWTaaSbLwoDchQQY6dId0AGsJ13GKxwbtbdzWcwWyOdFkNh
         CIY1vbcde+Tog==
Received: by mail-lf1-f69.google.com with SMTP id x7-20020a056512130700b003fd1a7424a8so12739461lfu.5
        for <netdev@vger.kernel.org>; Mon, 11 Oct 2021 06:39:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8wnvnlFr7Z9I1aV6d98j8RCw9C64nkeTjGiPt6idSBY=;
        b=QFdlPu628ZpedMPA5hJe5a71P3RtW1A4fODEhoHhRGZULIie3CGi48YsPfR/YxpmK0
         2E7GRq8USVIBtyjguyi4qINbjSGLJXQpSHRCFFnj91KCtXxBs0ZPD/ffva2poVASyaRe
         n7eczeD0BI+78p0JIeCa6FJpVUy8xXxSjLzalW7qyPZjS6OEhidUVzpzasGD5Mp4Q4ur
         N4SAy+Y+ARt8h9N0u5llntBZdEpOxyFG8uJLrI6imna7Flt9PeCJLpvvlrV/tihSUtik
         jFK/i156TsQ1Du5N41gAdxDbdMIFRAHLSlh+xpGQ/bJz8mIAdf0CvOIy65kpPYDumM3B
         xXjg==
X-Gm-Message-State: AOAM530+Iz0npLvzAVagKa45UHYPorVG1JdfPpLiI+jfZ8vlRmXnVSsI
        3ZcQECvruQZWMcx8f0BW+dx8bV1XeHO8+PmTU431bg/NgML7T4CYF2+YcTLrM/TGyaZVlFtKPHs
        sPKyv15lOscjDlE5WOoh2g5xcPdK7PHEy2w==
X-Received: by 2002:a2e:6e0d:: with SMTP id j13mr23981190ljc.91.1633959558151;
        Mon, 11 Oct 2021 06:39:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy1mjKnXef4PGGuh6A2lQ0EMTl+ZwPQ5YLz++4hccLWfHMjPwyjX1r4pco9/JD2L+P+ga9cPg==
X-Received: by 2002:a2e:6e0d:: with SMTP id j13mr23981169ljc.91.1633959557980;
        Mon, 11 Oct 2021 06:39:17 -0700 (PDT)
Received: from localhost.localdomain (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id a21sm738971lff.37.2021.10.11.06.39.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Oct 2021 06:39:16 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        Mark Greer <mgreer@animalcreek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Cc:     joe@perches.com
Subject: [PATCH v3 2/7] nfc: nci: replace GPLv2 boilerplate with SPDX
Date:   Mon, 11 Oct 2021 15:38:30 +0200
Message-Id: <20211011133835.236347-3-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211011133835.236347-1-krzysztof.kozlowski@canonical.com>
References: <20211011133835.236347-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace standard GPLv2 license text with SPDX tag.  Although the comment
mentions GPLv2-only, it refers to the full license file which allows
later GPL versions.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 net/nfc/nci/uart.c | 16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/net/nfc/nci/uart.c b/net/nfc/nci/uart.c
index 9bdd9a7d187e..c027c76d493c 100644
--- a/net/nfc/nci/uart.c
+++ b/net/nfc/nci/uart.c
@@ -1,20 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
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

