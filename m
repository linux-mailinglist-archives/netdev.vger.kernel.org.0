Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A6BA47E1FA
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 12:08:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347867AbhLWLIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 06:08:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347859AbhLWLIG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 06:08:06 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B213C061401;
        Thu, 23 Dec 2021 03:08:06 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id p7so7714354ljj.1;
        Thu, 23 Dec 2021 03:08:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NwiKmETSPCmVX7lPyPmwbKvzH3QbmKWwfTWUmPe7S4Y=;
        b=nQ2KcNvEoz4rICj8RmIV40zF7KqyLlhxvx7ZSsHn24ttAW6l48FaLxsT/tI4+BS8ly
         UTX7lcKxGQx4v59MtfWHVSzeXxJayOr4eeEHja2Rq/bS/Ooefj47oQ4xPAftbgQC6a11
         lSJxPfKz2TZOVoWnpf5dOg8kBz5/UAOxWOHf55gXPdnzz9Q2O2b3A8SynHsvHaAAvVva
         jR4YClO7ZtkasYKBpJYtYEEanqTx8pTn8V3NXMyIfypo5RdIAfqz9Ei/K4pfeFwZ3BPv
         87HppKGYbjk0Ypy5saHuV51KoQs3nCakKjg/9DWEY5dE+DoPZmMS1s4zZZUlHYaxPBev
         D91w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NwiKmETSPCmVX7lPyPmwbKvzH3QbmKWwfTWUmPe7S4Y=;
        b=awn01f4W5qMAD4Ejx8HZv/pwhWBhO6WRoeFom/tiKUiX0yvBetDMHjjxhWjvDiHpIn
         WSs1Wl5Zyx0iAsGR2Sca0Znhy+uYh3lonkvEkjwFgFlEOJy/3yY65bP50nVwK86BXwRe
         3Mm7GPXAK8k20zMdrJjYD+fEp530UmTzPmyk16ccrYZSb530LQ6T3+mz28Kmtt1XbdGv
         0+WZeQ1lUTLp25KeE9DPIKw6FvWAa5jfLnR3hFsYFGlDyq7mQdjMZNkb8M0rF+gsPjgJ
         BKyW6zlUpUKKr/BsmnsQnPmWYgOL55CA/r01SOzbtt1JXzwrc8dkNgqO3OJSRRg2B5Pt
         zY/Q==
X-Gm-Message-State: AOAM533sWldDtxinEBdXl5Mz8lPncxqQp7EE48WurcdWiuaF2jeq0vMP
        bS5BJdbsFMIpNNinJCgK3ss=
X-Google-Smtp-Source: ABdhPJxEh5gjL3BaNJkFvEhL/qh93ZA3qEmy0VIAiCWn3r6UT2AIgNOC4HR+h9KEAMmBgeQexfMf4g==
X-Received: by 2002:a05:651c:2123:: with SMTP id a35mr1402949ljq.285.1640257684316;
        Thu, 23 Dec 2021 03:08:04 -0800 (PST)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id t7sm473047lfg.115.2021.12.23.03.08.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Dec 2021 03:08:04 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH 1/5] dt-bindings: nvmem: add "label" property to allow more flexible cells names
Date:   Thu, 23 Dec 2021 12:07:51 +0100
Message-Id: <20211223110755.22722-2-zajec5@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211223110755.22722-1-zajec5@gmail.com>
References: <20211223110755.22722-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

So far NVMEM cells names were indicated by DT $nodename. That didn't
allow fancy names with characters that are not allowed there.

That wasn't a big problem for cells fully defined in DT. One could just
adjust a name slightly if needed.

This is a problem a however for NVMEM devices with cells defined at
device level. Such vendor defined names can be more fancy and DT needs a
way to match them strictly.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 Documentation/devicetree/bindings/nvmem/nvmem.yaml | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/nvmem/nvmem.yaml b/Documentation/devicetree/bindings/nvmem/nvmem.yaml
index 456fb808100a..3392405ee010 100644
--- a/Documentation/devicetree/bindings/nvmem/nvmem.yaml
+++ b/Documentation/devicetree/bindings/nvmem/nvmem.yaml
@@ -49,6 +49,9 @@ patternProperties:
         description:
           Offset and size in bytes within the storage device.
 
+      label:
+        description: name of NVMEM cell
+
       bits:
         maxItems: 1
         items:
-- 
2.31.1

