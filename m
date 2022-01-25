Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4783A49BAE5
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 19:04:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353243AbiAYSDx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 13:03:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357908AbiAYSB0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 13:01:26 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C34BC061744;
        Tue, 25 Jan 2022 10:01:22 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id z14so16468238ljc.13;
        Tue, 25 Jan 2022 10:01:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GM66wyVEQfYH7PQMt46Z5bne3N5mqgIHb4gE5XOX3QU=;
        b=qyX4+YOYstvWZ1ZiNLgvZY9TpsI07bcy1pSRR/tryKGf6eHosT3nY2XJ3VnftoWE6D
         lFstLOcE3HaNjlqisM5DI9KtnQ5isJdsloqol6DpAHFh1PmGmpT/TzGhA92zXgcSlCw8
         vO80Ebh+IF2kJ2vQddoGyUSUAK/Eqia13m27m83QkJa7F4WBniAk81U0cxWDtkwoCKVQ
         cCLH1nBHXCbpg0cinEymgD/SZYqtgH7w/UvyEmBClP6JFwNigbVt525c24FGLyDKWscv
         7iQGHRpVIxrDrBLD9QTQvnbQm9ljrqtJTRN/3aeGeRy77WK0woITYfSeoSCIaQm2PT3c
         2gHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GM66wyVEQfYH7PQMt46Z5bne3N5mqgIHb4gE5XOX3QU=;
        b=5QtsVjvFhcd6UfCrGoZcyiNowAPrFkkO9yj+6Q3cTVPXKWwL9a7LpTXNBeDglNYAqf
         Ut3zhNEsHhkmrfxySCxctMdE+es5gI+DgoBaMi6obHotpqX0g5Yx/lZHD+E+kh5SsHEQ
         RtBSW4tp0ax0COmgpgMr4HJcs6bstVoPzlQ6LXIoSGgkgqhJE67K1cBrC/tV/yXb210Q
         OD0tfZkYQyGqkxOPHWoJW927QN6nA6JM+/sEcTzSuAiI9Bs7Q8NIVHc9Mo/+rhO5ffMf
         d1lpv/RzQmBZNrgzreMf+my589ht0OCnrFZEzXHlbTo6HkS9dSyJg7oNRgtflMZYY4L2
         XxHw==
X-Gm-Message-State: AOAM530cvycVrBNQKxe9+lW9AbzD4k1t/JK/PkRLM/x5ob+5G0szUTPk
        7L4sEy1VBjRx+IubOQPtVUfPncl+xGc=
X-Google-Smtp-Source: ABdhPJwoWthi4gg4kuMx//yhY6O7ZoD9EuAirCd3tjV+pL+5cXulMUAH0DG7CEqZRyZnq1GcejGO2Q==
X-Received: by 2002:a2e:8e21:: with SMTP id r1mr6874390ljk.433.1643133679587;
        Tue, 25 Jan 2022 10:01:19 -0800 (PST)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id z24sm1149121lfb.206.2022.01.25.10.01.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 10:01:19 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Rob Herring <robh+dt@kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Michael Walle <michael@walle.cc>
Cc:     linux-mtd@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Frank Rowand <frowand.list@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH 0/2] dt-bindings: nvmem: support describing cells
Date:   Tue, 25 Jan 2022 19:01:12 +0100
Message-Id: <20220125180114.12286-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

Michael has recently posted a cleaned up patchset for NVMEM
transformations support:
[PATCH 0/8] nvmem: add ethernet address offset support
https://lore.kernel.org/lkml/20211228142549.1275412-1-michael@walle.cc/T/
https://patchwork.ozlabs.org/project/linux-mtd/list/?series=278644&state=*

I find it very important & fully support it. In home routers we very
often deal with just one MAC address that:
1. Is a base for calculating multiple Ethernet addresses
2. Can be stored in binary as well as ASCII format

I'd like to suggest just a slightly different solution though. I think
that using something like:

otp-1 {
        compatible = "kontron,sl28-vpd", "user-otp";
        #address-cells = <1>;
        #size-cells = <1>;

        base_mac_address: base-mac-address@17 {
                #nvmem-cell-cells = <1>;
                reg = <17 6>;
        };
};

isn't clear enough and requires too much conditional code in Linux /
whatever implementation. DT doesn't make it clear which NVMEM cells
are used for what and how should be handled. That has to be hardcoded in
a Linux / whatever driver.

My idea is to add "compatible" & additional flags to NVMEM cells.
Example:

otp-1 {
        compatible = "user-otp";
        #address-cells = <1>;
        #size-cells = <1>;

        base_mac_address: base-mac-address@17 {
                compatible = "mac-address";
                reg = <17 6>;
                #nvmem-cell-cells = <1>;
        };
};

(for more examples see PATCH 2/2 and its mac-address.yaml .

Rafał Miłecki (2):
  dt-bindings: nvmem: extract NVMEM cell to separated file
  dt-bindings: nvmem: cells: add MAC address cell

 .../devicetree/bindings/nvmem/cells/cell.yaml | 35 +++++++
 .../bindings/nvmem/cells/mac-address.yaml     | 94 +++++++++++++++++++
 .../devicetree/bindings/nvmem/nvmem.yaml      | 25 +----
 3 files changed, 131 insertions(+), 23 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/nvmem/cells/cell.yaml
 create mode 100644 Documentation/devicetree/bindings/nvmem/cells/mac-address.yaml

-- 
2.31.1

