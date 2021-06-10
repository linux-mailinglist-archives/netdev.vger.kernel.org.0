Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3E0C3A3677
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 23:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231357AbhFJVrx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 17:47:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54364 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231341AbhFJVrk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 17:47:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623361543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Sg0e7jXQsTWhtJdkPVNcldGSCJQVzZfo88rGKEyxbVM=;
        b=jF0km8g4p89mBhncdGbC1/Vg5ETEzZF00pe+w/WdilVR7Ux17nxM3V3BO//XUmDMZQUg2H
        22p8+VrTeI3qjV/ffpXIy8nIt1CG8s0Kw2UrVS7x35vHgfDwkC4I1sk8vnMbah81ugmy7X
        S8n0kWWgQlxIG3COtd67pFg2iRtKcAA=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-447-VjvJaOmTMjusi_hPwVbaCA-1; Thu, 10 Jun 2021 17:45:42 -0400
X-MC-Unique: VjvJaOmTMjusi_hPwVbaCA-1
Received: by mail-oi1-f197.google.com with SMTP id o65-20020acaf0440000b02901f5112008e6so1878814oih.17
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 14:45:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Sg0e7jXQsTWhtJdkPVNcldGSCJQVzZfo88rGKEyxbVM=;
        b=Z24P6HKUuAnvBPihQzl2mJ280FWIveupjCdJ727bXssQqe3c9K41MYq/EKzpNmGJoO
         FeVh7rYozhnZTb0ElCOLszXwxhOZVMiFltUC2C3SWMRAIxVIk/99FBGaRUG1N/Z1qZze
         J+D6Ha0fIqHKS+Rie8cdIF/969znCqz3ScbPl2wWC4eUmTpXIXh7ECGLvzzudGmyfnln
         LGy+bQTDZlt1eR+VfoQHiO39q5ywkXcKlZTe88l6/+R6foaWVrtGqr1nmCpSQax9SKRJ
         gZ4O4+hFLLJCxsfUsES9jMlR4KvBF9yVpLMMqx6irxUi9oDuNwkpDf72bC+817hVZvZK
         GdLA==
X-Gm-Message-State: AOAM533V1Mc8DszAyTwSy3QV46ahcUUSMbyuo0Hy05iOxGXQId7Snq59
        +xwR4FsoP5xX1x6HsMuBlq9dNpahUp2DocwAkDoqKsigYXBQ1i4lNObRlVriBb8fSr1dq/RFbtA
        h+yt5DJSgypH8jXeT
X-Received: by 2002:a9d:6087:: with SMTP id m7mr370773otj.318.1623361541282;
        Thu, 10 Jun 2021 14:45:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwXb9l1V2GdEF4zDsZ9LozrWKOCTW8y6roYjcLTL2ZDJoW3I+XShj/h6JSCX5VGU9bVCgQ4yA==
X-Received: by 2002:a9d:6087:: with SMTP id m7mr370744otj.318.1623361541117;
        Thu, 10 Jun 2021 14:45:41 -0700 (PDT)
Received: from localhost.localdomain.com (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id i15sm881839ots.39.2021.06.10.14.45.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 14:45:40 -0700 (PDT)
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
Subject: [PATCH 3/7] drivers/soc/litex: fix spelling of SPDX tag
Date:   Thu, 10 Jun 2021 14:44:34 -0700
Message-Id: <20210610214438.3161140-5-trix@redhat.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210610214438.3161140-1-trix@redhat.com>
References: <20210610214438.3161140-1-trix@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

checkpatch looks for SPDX-License-Identifier.
So change the '_' to '-'

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/soc/litex/Kconfig  | 2 +-
 drivers/soc/litex/Makefile | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/litex/Kconfig b/drivers/soc/litex/Kconfig
index e7011d665b151..c03b1f816cc08 100644
--- a/drivers/soc/litex/Kconfig
+++ b/drivers/soc/litex/Kconfig
@@ -1,4 +1,4 @@
-# SPDX-License_Identifier: GPL-2.0
+# SPDX-License-Identifier: GPL-2.0
 
 menu "Enable LiteX SoC Builder specific drivers"
 
diff --git a/drivers/soc/litex/Makefile b/drivers/soc/litex/Makefile
index 98ff7325b1c07..aeae1f4165a70 100644
--- a/drivers/soc/litex/Makefile
+++ b/drivers/soc/litex/Makefile
@@ -1,3 +1,3 @@
-# SPDX-License_Identifier: GPL-2.0
+# SPDX-License-Identifier: GPL-2.0
 
 obj-$(CONFIG_LITEX_SOC_CONTROLLER)	+= litex_soc_ctrl.o
-- 
2.26.3

