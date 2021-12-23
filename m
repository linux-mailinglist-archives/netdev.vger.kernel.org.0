Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98B8347E1F9
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 12:08:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347858AbhLWLIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 06:08:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232847AbhLWLIF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 06:08:05 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90AE9C061401;
        Thu, 23 Dec 2021 03:08:04 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id j11so9875027lfg.3;
        Thu, 23 Dec 2021 03:08:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=f78OHizdSqkieU+gvXnx+72ezSg/jv19k6AuheS2zOU=;
        b=Pj9UG/Y/o9c5+eqHC9KA0Q3ImqEcmX212ft2GGDPqHPP0BsAdNehTZDL1/mWZ00uwo
         l26BdFsSn3UulVGtOIm7lYoCjYWmCKKJXIcN2q87vCZf75QXAVJVqBjexZNmHIcJ7/2a
         PNGX7mhqBCIVNyROpSAuEHqpq87tToN9B7S3HIbNdR3rXfKZrC/bKLKA0y//fA66NaJA
         q5g/YwzQj0noSth6tvc/mYkNK6HJZz5l7PmQwqE6H6oO51aDQy9aiLcEtKk2MrZ5rGkr
         AZ9FfTXAtuqEnLqOJRyvdXoEt9saJrKjb1R/ssHa4CEz8HQAb8v0TF+/DEf80hxzKNbk
         T/Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=f78OHizdSqkieU+gvXnx+72ezSg/jv19k6AuheS2zOU=;
        b=VJu9Sp7VqS6J3/1zBxfam8Ro+B9KcFmDnwKbAvJ3ZGQSxOrAAXEzQDSErr9UhdK9ux
         KOrpLSsthNrkkuAXe9ut+HF79cwFBl6+ZRg/6E0W6D+zWvBVEsScVdFq5SKXBMg5fic2
         3P6AwAvlocEragqtoJMVM9leP/Dfe082fNx0XeAoZJ8MA8xK+XW1QMjaf4jIWKvF3bp9
         02JgNjptEEBu4LGXPLxpFePUXz4D4Z5MpybuFSuMLvckSpyp/NRPoBMfLSV0VSSztHFn
         rB5hZefQpMZWqg3AIQD7SSu7QRBGGATfS3RLEhppH843jygweQywMxIRPYMAplAcM4Gm
         5Htw==
X-Gm-Message-State: AOAM530m8QdtMl4QOHOlrM9RaQ1Ok1rAuLB7CRMfPl98ezyTg6JqzGeR
        HPqA9Vs5Ryc5/WL4LwWSNMQBoxY/pyQ=
X-Google-Smtp-Source: ABdhPJxecF5JpqY7/M1nkQeaOEzcwPAwxa5Kq4FhuIrvPbIRM8kCyxGvjwonGUfdwYaHFPKLZ0j6hA==
X-Received: by 2002:a05:6512:1395:: with SMTP id p21mr1584374lfa.98.1640257682906;
        Thu, 23 Dec 2021 03:08:02 -0800 (PST)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id t7sm473047lfg.115.2021.12.23.03.08.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Dec 2021 03:08:02 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH 0/5] nvmem: support more NVMEM cells variants
Date:   Thu, 23 Dec 2021 12:07:50 +0100
Message-Id: <20211223110755.22722-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

Some NVMEM devices don't have NVMEM cells at hardcoded offsets and they
can't be strictly specified in a binding. Those devices usually store
NVMEM cells in some internal format. We still need a way of referencing
such hidden / dynamic NVMEM cells.

This patchset adds support for bindings like:

nvram@1eff0000 {
	compatible = "brcm,nvram";
	reg = <0x1eff0000 0x10000>;

	mac_addr: cell-0 {
		label = "et0macaddr";
	};
};

ethernet@18024000 {
	compatible = "brcm,amac";
	reg = <0x18024000 0x800>;

	nvmem-cells = <&mac_addr>;
	nvmem-cell-names = "mac-address";
};

Rafał Miłecki (5):
  dt-bindings: nvmem: add "label" property to allow more flexible cells
    names
  nvmem: core: read OF defined NVMEM cell name from "label" property
  dt-bindings: nvmem: allow referencing device defined cells by names
  dt-bindings: nvmem: brcm,nvram: add NVMEM cell to example
  nvmem: core: add cell name based matching of DT cell nodes

 .../devicetree/bindings/nvmem/brcm,nvram.yaml |  8 +++--
 .../devicetree/bindings/nvmem/nvmem.yaml      | 16 +++++++--
 drivers/nvmem/core.c                          | 36 ++++++++++++++++++-
 3 files changed, 55 insertions(+), 5 deletions(-)

-- 
2.31.1

