Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60EE842366C
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 05:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237366AbhJFD4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 23:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236054AbhJFD4F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 23:56:05 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 043C1C061760
        for <netdev@vger.kernel.org>; Tue,  5 Oct 2021 20:54:14 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id j5so4511284lfg.8
        for <netdev@vger.kernel.org>; Tue, 05 Oct 2021 20:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0QbCWpC0YUHd4oM8ALhGkUXV2GRwREBEvhvGaNVxQyo=;
        b=he2kT439AhNtxiuqDLrNaZpNYt38+4H16zAkk/pYeKvytO6jQI9YrfDulq+/ku2ae6
         QcjskLIWgJBzMoIQi0R91D2cctBB27lEMBdcuYBNl1HRLoyuq5WQRO/M8fZI0e/eaEWd
         sINOv6L6kKh0sh5q3Gj4F1V2jcH1vNu7KSKbOJFm7UG2hdj6vvWkvE73ie0jGA+nIM0Y
         t6Z1V4bddNVkkWhw8u7pOiI2jhSPajejhaCgdcxmdmpZkHfz35vCMKx36LYu5awMpEY2
         nVj9Hb4/4m9nCEHG9DRzBH3FEma/IlB2fgdRMh3xMWOJE1+ti3mLeKUTppV80/OiPgZ5
         eS1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0QbCWpC0YUHd4oM8ALhGkUXV2GRwREBEvhvGaNVxQyo=;
        b=q7bSxajSe+0lGNJTVnrLAns4ccvk6tXRUE70xO0gicJsPMOfJnP8xXtQ8YkQq19s0c
         8uzH2jvCfs6qfALOFqdOgAMdiOj6y5FCXH+Nu9zTrsi3PH2ke8yLoJsi/GH8da9QhIqh
         jT07fpruN7A5oepFxVNoM0RWjHayiyqH/fT9nDEAIwVSsidHDAogvD3z6ta4qyFu3Esq
         B+wVXKr8L+qew/cAQy68iYAI1gOOqsH0QQW2o2ioj1eUzek+jQrbkVy0/wmrBruQdCPs
         nvmJJxcBkUEW/4BYXdZLved6ylc5G7Jn67w5af+4mi376T6tgBI/dZqzAJ1gOdM93b1U
         npHA==
X-Gm-Message-State: AOAM531bptyGBztGZoPDZiEV9KfVKZ2I2Y9DOjQf7SorqTttW/MZOfbN
        xx5ewyuU3ew3IhIE1JY4GRf58g==
X-Google-Smtp-Source: ABdhPJzUyTSbGQqEZmbXX4rYk8Wj34+52wMw1vr6OKUpbP6w62OKwylW2IUSus9+fPfMVxbFfNEITg==
X-Received: by 2002:a2e:550:: with SMTP id 77mr27560874ljf.478.1633492452244;
        Tue, 05 Oct 2021 20:54:12 -0700 (PDT)
Received: from eriador.lan ([37.153.55.125])
        by smtp.gmail.com with ESMTPSA id s4sm2142967lfd.103.2021.10.05.20.54.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 20:54:11 -0700 (PDT)
From:   Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stanimir Varbanov <svarbanov@mm-sol.com>
Cc:     linux-arm-msm@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v1 01/15] dt-bindings: add pwrseq device tree bindings
Date:   Wed,  6 Oct 2021 06:53:53 +0300
Message-Id: <20211006035407.1147909-2-dmitry.baryshkov@linaro.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211006035407.1147909-1-dmitry.baryshkov@linaro.org>
References: <20211006035407.1147909-1-dmitry.baryshkov@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add device tree bindings for the new power sequencer subsystem.
Consumers would reference pwrseq nodes using "foo-pwrseq" properties.
Providers would use '#pwrseq-cells' property to declare the amount of
cells in the pwrseq specifier.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
---
 .../bindings/power/pwrseq/pwrseq.yaml         | 32 +++++++++++++++++++
 1 file changed, 32 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/power/pwrseq/pwrseq.yaml

diff --git a/Documentation/devicetree/bindings/power/pwrseq/pwrseq.yaml b/Documentation/devicetree/bindings/power/pwrseq/pwrseq.yaml
new file mode 100644
index 000000000000..4a8f6c0218bf
--- /dev/null
+++ b/Documentation/devicetree/bindings/power/pwrseq/pwrseq.yaml
@@ -0,0 +1,32 @@
+# SPDX-License-Identifier: GPL-2.0
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/power/pwrseq/pwrseq.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Power Sequencer devices
+
+maintainers:
+  - Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
+
+properties:
+  "#powerseq-cells":
+    description:
+      Number of cells in a pwrseq specifier.
+
+patternProperties:
+  ".*-pwrseq$":
+    description: Power sequencer supply phandle(s) for this node
+
+additionalProperties: true
+
+examples:
+  - |
+    qca_pwrseq: qca-pwrseq {
+      #pwrseq-cells = <1>;
+    };
+
+    bluetooth {
+      bt-pwrseq = <&qca_pwrseq 1>;
+    };
+...
-- 
2.33.0

