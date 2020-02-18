Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21D40162BFA
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 18:14:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727662AbgBRRNj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 12:13:39 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:38278 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727393AbgBRRNe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 12:13:34 -0500
Received: by mail-oi1-f194.google.com with SMTP id r137so1267245oie.5;
        Tue, 18 Feb 2020 09:13:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kW31qHj/OGRN2L4TXUUKIQPN57zbu2axU6XP0HsWl20=;
        b=A00RgPnZTtgZXHrAdc6iFFkLWWmYcBvnyU8Y9x4KrQOMS2iySfepez+Hm9HSjrOgZy
         4ybC7S86lz8wm2+Y/Snp9bVdxEpxtSgnwu9DbG+6DbV64XOJi7TuA/3hB9DmInfmE5vq
         nlgOiF8+fxCTjrMIpFMhpcZLDgSlxiEoQfHjCz8OdLCi+wHYD1HdPXNNRGeKqbueQerr
         Crk7kKtpPgcHyAxJ3DHtkwPMyJ2m0M+3vrCE8B/XdehNzQ7ZCdo3i+Hjpp5K6ZKRqLdY
         YIVkWTwaIFe1kliERSlJhyo864sFAyNhjO6wjxsQCfsYao0BwwW1jSKPgq81MbijlmAJ
         nQyQ==
X-Gm-Message-State: APjAAAWbrp5gq2FTsX8aHaW6Y/f7rK2Keu2b/G8gE+2grPF+kJzh7rmE
        L4JHPPIRMhMP8P/T2J84TQ==
X-Google-Smtp-Source: APXvYqzM1O5/oeWQHJ8gT8Z9L53EKPDEEuwksZtS3dmhCEXg8KSK+0rIqhxLhSP9RCgQyZtde069lg==
X-Received: by 2002:a05:6808:9ba:: with SMTP id e26mr1936616oig.81.1582046013542;
        Tue, 18 Feb 2020 09:13:33 -0800 (PST)
Received: from xps15.herring.priv (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.googlemail.com with ESMTPSA id y25sm1545755oto.27.2020.02.18.09.13.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 09:13:33 -0800 (PST)
From:   Rob Herring <robh@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        soc@kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Robert Richter <rrichter@marvell.com>,
        Jon Loeliger <jdl@jdl.com>, Alexander Graf <graf@amazon.com>,
        Matthias Brugger <mbrugger@suse.com>,
        Mark Langsdorf <mlangsdo@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Eric Auger <eric.auger@redhat.com>,
        iommu@lists.linux-foundation.org,
        James Morse <james.morse@arm.com>,
        Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
        kvm@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-pm@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        netdev@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Robin Murphy <robin.murphy@arm.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Will Deacon <will@kernel.org>
Subject: [RFC PATCH 06/11] iommu: arm-smmu: Remove Calxeda secure mode quirk
Date:   Tue, 18 Feb 2020 11:13:16 -0600
Message-Id: <20200218171321.30990-7-robh@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200218171321.30990-1-robh@kernel.org>
References: <20200218171321.30990-1-robh@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cc: Will Deacon <will@kernel.org>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: iommu@lists.linux-foundation.org
Signed-off-by: Rob Herring <robh@kernel.org>
---
Do not apply yet.

 drivers/iommu/arm-smmu-impl.c | 43 -----------------------------------
 1 file changed, 43 deletions(-)

diff --git a/drivers/iommu/arm-smmu-impl.c b/drivers/iommu/arm-smmu-impl.c
index 74d97a886e93..a3be8712d27f 100644
--- a/drivers/iommu/arm-smmu-impl.c
+++ b/drivers/iommu/arm-smmu-impl.c
@@ -9,45 +9,6 @@

 #include "arm-smmu.h"

-
-static int arm_smmu_gr0_ns(int offset)
-{
-	switch(offset) {
-	case ARM_SMMU_GR0_sCR0:
-	case ARM_SMMU_GR0_sACR:
-	case ARM_SMMU_GR0_sGFSR:
-	case ARM_SMMU_GR0_sGFSYNR0:
-	case ARM_SMMU_GR0_sGFSYNR1:
-	case ARM_SMMU_GR0_sGFSYNR2:
-		return offset + 0x400;
-	default:
-		return offset;
-	}
-}
-
-static u32 arm_smmu_read_ns(struct arm_smmu_device *smmu, int page,
-			    int offset)
-{
-	if (page == ARM_SMMU_GR0)
-		offset = arm_smmu_gr0_ns(offset);
-	return readl_relaxed(arm_smmu_page(smmu, page) + offset);
-}
-
-static void arm_smmu_write_ns(struct arm_smmu_device *smmu, int page,
-			      int offset, u32 val)
-{
-	if (page == ARM_SMMU_GR0)
-		offset = arm_smmu_gr0_ns(offset);
-	writel_relaxed(val, arm_smmu_page(smmu, page) + offset);
-}
-
-/* Since we don't care for sGFAR, we can do without 64-bit accessors */
-static const struct arm_smmu_impl calxeda_impl = {
-	.read_reg = arm_smmu_read_ns,
-	.write_reg = arm_smmu_write_ns,
-};
-
-
 struct cavium_smmu {
 	struct arm_smmu_device smmu;
 	u32 id_base;
@@ -166,10 +127,6 @@ struct arm_smmu_device *arm_smmu_impl_init(struct arm_smmu_device *smmu)
 		break;
 	}

-	if (of_property_read_bool(smmu->dev->of_node,
-				  "calxeda,smmu-secure-config-access"))
-		smmu->impl = &calxeda_impl;
-
 	if (of_device_is_compatible(smmu->dev->of_node, "qcom,sdm845-smmu-500"))
 		return qcom_smmu_impl_init(smmu);

--
2.20.1
