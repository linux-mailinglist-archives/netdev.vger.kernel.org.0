Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F2D53DA13D
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 12:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236155AbhG2Kkq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 06:40:46 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:34432
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236048AbhG2Kkk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 06:40:40 -0400
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPS id 4C3B13F115
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 10:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627555235;
        bh=2+MASfDeMXItUy0KRRU6qIh2N4zib4Lrz4DxPbXJr60=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=A8W42v4KoNY2p8NkFhp0mtMxil1RQC4pu9cte5lTrt1XD0539BEgQB7PK6aN6ZYP6
         uKH8w+ZyweDyj5M0Wz1AUqw8IX+K1BzCHq/7c4ze53HhMYT9RsFxw9PhD5FpXzdMbI
         FEQUyRRrCvYY2fBUtUsebDMlFPly9E7A/WFVUZSrgmrm/It0TKIg95gRzdkdgAy2+e
         ThACAkGKQCGNhA1TuHUlZvOmM30cYPz/Tj97HxxLkuK2q79DuGYTg74wdFS+Lz+etD
         S9yfErz6RP/RmowefzlgXKlnIgtpVqjW9Z3AVnkzUAYQ+VNLOHqFzwq2Noyapq9aX5
         IsuZ4qUNPbY4g==
Received: by mail-ej1-f72.google.com with SMTP id qf6-20020a1709077f06b029057e66b6665aso1840854ejc.18
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 03:40:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2+MASfDeMXItUy0KRRU6qIh2N4zib4Lrz4DxPbXJr60=;
        b=AlEE5Bt3jqdlvylJ/s8xIhAidppvIb7RnQjJpZ8bbeHVp5u0S0WAMygK1SWbFlSO8Y
         UjU7gEw6Wj0GBlq1OHEbWt8jBpB24NwdsQWpXTscMjPZC36e1BalaYsgMLBeSHgiOUrx
         DpHhfIIKP+JQRMpslNl566rkXeT7TizW9fWL/prqw9zqC+CtrdYa+jVs5bz8O5229pHn
         Kkm81tU+f21BrtWbWQKlABs5YCdSjksl76laqZ0Iy010WXCxNM5Y+kIeiZhlCgfBgc+S
         N/qqlJ9z40NpMceFv3VpUd0ZhKQqQT8WmJixto67VjtD2QxZXBAabMp3K1iaO1xqprjk
         l4Ug==
X-Gm-Message-State: AOAM532/VtNZf4dVG9qJHlry14hgEMrBjruM8GMSC6be9Ax97sM7Czx2
        EX++WgWetNwUWJNT3oDNAxWuSzxSKFu/kt9Y4sLubJjp6dQ19Et/Lx6tDVn4TTeRG1MqJFLGp3b
        6HBkgNpREN/4ektHCgJ5w+q7Q2MWK3QCjBg==
X-Received: by 2002:a05:6402:b83:: with SMTP id cf3mr5240269edb.12.1627555235092;
        Thu, 29 Jul 2021 03:40:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwwJDOdp8Ic5sbEoP+ybcJEGMi8R0A1BITHI63lRz6KY4s1GLDvMBVi9ewCQtp/6p2bmUkfPA==
X-Received: by 2002:a05:6402:b83:: with SMTP id cf3mr5240255edb.12.1627555234989;
        Thu, 29 Jul 2021 03:40:34 -0700 (PDT)
Received: from localhost.localdomain ([86.32.47.9])
        by smtp.gmail.com with ESMTPSA id c14sm824475ejb.78.2021.07.29.03.40.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 03:40:34 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Mark Greer <mgreer@animalcreek.com>,
        Bongsu Jeon <bongsu.jeon@samsung.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH 01/12] nfc: constify passed nfc_dev
Date:   Thu, 29 Jul 2021 12:40:11 +0200
Message-Id: <20210729104022.47761-2-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210729104022.47761-1-krzysztof.kozlowski@canonical.com>
References: <20210729104022.47761-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The struct nfc_dev is not modified by nfc_get_drvdata() and
nfc_device_name() so it can be made a const.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 include/net/nfc/nfc.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/nfc/nfc.h b/include/net/nfc/nfc.h
index c9ff341d57e4..5dee575fbe86 100644
--- a/include/net/nfc/nfc.h
+++ b/include/net/nfc/nfc.h
@@ -245,7 +245,7 @@ static inline void nfc_set_drvdata(struct nfc_dev *dev, void *data)
  *
  * @dev: The nfc device
  */
-static inline void *nfc_get_drvdata(struct nfc_dev *dev)
+static inline void *nfc_get_drvdata(const struct nfc_dev *dev)
 {
 	return dev_get_drvdata(&dev->dev);
 }
@@ -255,7 +255,7 @@ static inline void *nfc_get_drvdata(struct nfc_dev *dev)
  *
  * @dev: The nfc device whose name to return
  */
-static inline const char *nfc_device_name(struct nfc_dev *dev)
+static inline const char *nfc_device_name(const struct nfc_dev *dev)
 {
 	return dev_name(&dev->dev);
 }
-- 
2.27.0

