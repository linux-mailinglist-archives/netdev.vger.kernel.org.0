Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B95C73A3698
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 23:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231523AbhFJVsg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 17:48:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24000 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231524AbhFJVsJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 17:48:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623361572;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=70NgQXU1//Wzo0iLFWpl3KegQtCCZiFqqErbm/ywz0w=;
        b=Vrg4XV9hgyphlC4J6SavACOWbYunocoMgGzQMYEVEGpZJ2gaAlbF54D27zkeGJxN3raSad
        OV6LieyfXL9jZWa39pAnDdrZzV99KDo0Jjf1c6GV4rBU+kS3ZBGQPSNXyVQgALHMiMIbrR
        Avx6WvzKl2wJgH+Z4nKj8iKlFKO3m5w=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-585-BylkrAZrPQmpX62eU2qNMw-1; Thu, 10 Jun 2021 17:46:11 -0400
X-MC-Unique: BylkrAZrPQmpX62eU2qNMw-1
Received: by mail-oi1-f200.google.com with SMTP id l1-20020a5441010000b02901ecd2ee1861so1891372oic.13
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 14:46:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=70NgQXU1//Wzo0iLFWpl3KegQtCCZiFqqErbm/ywz0w=;
        b=Xk+oW4VUFBYZBi2wnIkuk8kgya5/1xtb/t5T2f4KMVjR759cjNjjIs7wkxebdzo1gr
         BBrrthSutgODq1obiHZgvsfZ2zJzBcAhVpEOffB5PhqB4vwsubCEuTU2S9VTryg9C1pi
         DD6X9ZQQ3sLrgfgYzNZvH1aeBd8SEN973YyJSvDBpwC9kV1b+N/a72OmfimPM0I76XHX
         jkO6ONM/NnCN+5Hdz1Tdc0dKGKAeEaQ21GH0921dfm9R0iQ/ubrr3TzZZpVOuL8PWyho
         lW2V1JOtTnXKodam2uP1tuw6JP0Y4TaG6VRkeUqHZoh4uQ6BWsXfV9bNO7r7kOerWVa7
         E8KA==
X-Gm-Message-State: AOAM530xvan/MCD4oAJSAp3I3zAzooVIzpw69j4RqIQ/3PVgVH3tfSWt
        tsMRmw9y2xge24Fm08ctUwxlCHqEk4F/XCeoXvzQI9xGbQ/WvMUHh3BkYd2BJ5Nj6KHYBSQGAYY
        HFlROtlEjKbvlpRRs
X-Received: by 2002:a9d:554f:: with SMTP id h15mr358474oti.237.1623361570541;
        Thu, 10 Jun 2021 14:46:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz5xdp4Jwej97Ul1cmx7ubsXWjXdzvP8bKBwCPJ0ttg8L6uH+IckI6kmbkyG1b9obIsJHKQNQ==
X-Received: by 2002:a9d:554f:: with SMTP id h15mr358446oti.237.1623361570280;
        Thu, 10 Jun 2021 14:46:10 -0700 (PDT)
Received: from localhost.localdomain.com (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id i15sm881839ots.39.2021.06.10.14.46.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 14:46:09 -0700 (PDT)
From:   trix@redhat.com
To:     robh+dt@kernel.org, tsbogend@alpha.franken.de, jic23@kernel.org,
        lars@metafoo.de, tomas.winkler@intel.com, arnd@arndb.de,
        gregkh@linuxfoundation.org, nbd@nbd.name,
        lorenzo.bianconi83@gmail.com, ryder.lee@mediatek.com,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        matthias.bgg@gmail.com, mcoquelin.stm32@gmail.com,
        alexandre.torgue@foss.st.com, apw@canonical.com, joe@perches.com,
        dwaipayanray1@gmail.com, lukas.bulwahn@gmail.com,
        chenhuacai@kernel.org, jiaxun.yang@flygoat.com,
        zhangqing@loongson.cn, jbhayana@google.com, sean.wang@mediatek.com,
        shayne.chen@mediatek.com, Soul.Huang@mediatek.com,
        shorne@gmail.com, gsomlo@gmail.com,
        pczarnecki@internships.antmicro.com, mholenko@antmicro.com,
        davidgow@google.com
Cc:     devicetree@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com, Tom Rix <trix@redhat.com>
Subject: [PATCH 7/7] mt76: use SPDX header file comment style
Date:   Thu, 10 Jun 2021 14:44:38 -0700
Message-Id: <20210610214438.3161140-9-trix@redhat.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210610214438.3161140-1-trix@redhat.com>
References: <20210610214438.3161140-1-trix@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

header files should use '/* SPDX ... */
Change from c file comment syle to header style

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt7615/sdio.h     | 2 +-
 drivers/net/wireless/mediatek/mt76/mt7915/testmode.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/sdio.h b/drivers/net/wireless/mediatek/mt76/mt7615/sdio.h
index 05180971de841..03877d89e1520 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/sdio.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/sdio.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: ISC
+/* SPDX-License-Identifier: ISC */
 /* Copyright (C) 2020 MediaTek Inc.
  *
  * Author: Sean Wang <sean.wang@mediatek.com>
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/testmode.h b/drivers/net/wireless/mediatek/mt76/mt7915/testmode.h
index 8f8533ef9859f..397a6b5532bcc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/testmode.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/testmode.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: ISC
+/* SPDX-License-Identifier: ISC */
 /* Copyright (C) 2020 MediaTek Inc. */
 
 #ifndef __MT7915_TESTMODE_H
-- 
2.26.3

