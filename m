Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5363AF4B5
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 20:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231964AbhFUSRm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 14:17:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231833AbhFUSQ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 14:16:57 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88AF2C08ED83
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 10:56:35 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id p66so16839000iod.8
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 10:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PTTHSOVXexKSxKQpfvVOtl3Ci56/avUWgDl+NfjQ6/4=;
        b=AnONkDWeZBMGQEzfvUxpc1lVInHZ3+vSW5gveECtFKuFlcdfqt0jbk9SQeaJoz9v0o
         0cuIGhSLtNOHYRhBVf3mCzcbC1xHUnp7LYVeBfqYRkrbH4QJBGqs6E1DlNDOOGzM/j8H
         2Ijo4eMZaD3UAc8+xvtXhOgtFOOTU54txVbZIcLCK/nTcU5fpCd25Mo8RIpMWha8PRFj
         gfWBHS+g+th+kLQB2aydqEJuL8oy72JueINRpEZmb2it9S1AynWDDc+2XgRALtzuvpk3
         H0Z0TU9OqHIMVcvm/b/TlBbbSsbx42+mrLqgEy7JFsIXvZ4KJ0Kte7zt9ENn3VIK3pwO
         jkyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PTTHSOVXexKSxKQpfvVOtl3Ci56/avUWgDl+NfjQ6/4=;
        b=nu+4h3I5UPanaWE/iE1vUPK1cRIcWF5icP/JeO0OhVcQhweuOaaQa8h0yFCZuYXhpY
         f6+zO6qzywf3YJFM9NMCcJkr/ztjzx/rt4ecQalJg+1q260ew9sE/TmxJiCP7Ss+4tkR
         egLJgrziBKB88OHdbGU/wgwjz8z2uLD/VPnkxsrZfDMosXYy4hSekp/fg06hOv2GdQpk
         gLVToiLGrIQX1Mr1FDWXyJTGSnlYcJgxbN20jwqf98jI37P8Qx36VLkDZw012MRc4y3y
         peoqP7XRlLamOyX8dXIXU2eOt/8TX9fuPsghwlhgyWfncW6ZJlGqyL4+TyIhvNCNFH6b
         88/A==
X-Gm-Message-State: AOAM531HzaL8omZudLmedD2PVLj9/snCVHq4QOPFTA6bkaf8oXwpoAY1
        VcnlKRA6BsMhPSBgmVuhnUNbSw==
X-Google-Smtp-Source: ABdhPJzVdzySf0yUti4z5+eyQfFqOIv2XKrWLB+V9dFx4ynrpVHUwct/lRroaz5SKnI9V659KmWhbw==
X-Received: by 2002:a6b:6813:: with SMTP id d19mr7034410ioc.35.1624298195034;
        Mon, 21 Jun 2021 10:56:35 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id m13sm6259264iob.35.2021.06.21.10.56.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 10:56:34 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     robh+dt@kernel.org, angelogioacchino.delregno@somainline.org,
        jamipkettunen@gmail.com, bjorn.andersson@linaro.org,
        agross@kernel.org, elder@kernel.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/6] net: ipa: FLAVOR_0 register doesn't exist until IPA v3.5
Date:   Mon, 21 Jun 2021 12:56:25 -0500
Message-Id: <20210621175627.238474-5-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210621175627.238474-1-elder@linaro.org>
References: <20210621175627.238474-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The FLAVOR_0 version first appears in IPA v3.5, so avoid attempting
to read it for versions prior to that.

This register contains a concise definition of the number and
direction of endpoints supported by the hardware, and without it
we can't verify endpoint configuration in ipa_endpoint_config().
In this case, just indicate that any endpoint number is available
for use.

Originally proposed by AngeloGioacchino Del Regno.

Link: https://lore.kernel.org/netdev/20210211175015.200772-3-angelogioacchino.delregno@somainline.org
Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 3520852936ed1..ab02669bae4e6 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -1731,6 +1731,21 @@ int ipa_endpoint_config(struct ipa *ipa)
 	u32 max;
 	u32 val;
 
+	/* Prior to IPAv3.5, the FLAVOR_0 register was not supported.
+	 * Furthermore, the endpoints were not grouped such that TX
+	 * endpoint numbers started with 0 and RX endpoints had numbers
+	 * higher than all TX endpoints, so we can't do the simple
+	 * direction check used for newer hardware below.
+	 *
+	 * For hardware that doesn't support the FLAVOR_0 register,
+	 * just set the available mask to support any endpoint, and
+	 * assume the configuration is valid.
+	 */
+	if (ipa->version < IPA_VERSION_3_5) {
+		ipa->available = ~0;
+		return 0;
+	}
+
 	/* Find out about the endpoints supplied by the hardware, and ensure
 	 * the highest one doesn't exceed the number we support.
 	 */
-- 
2.27.0

