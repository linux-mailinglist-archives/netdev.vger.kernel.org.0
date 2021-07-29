Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68F253DA15B
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 12:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237013AbhG2KlV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 06:41:21 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:47798
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236284AbhG2Kkp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 06:40:45 -0400
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPS id 724863F10E
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 10:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627555241;
        bh=Cti8DGqbNI8YPSuGsMvGoiLdXe5FLuXImkkJsU3HkS0=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=f5A+RajiHfLk8wB2DyLPhBFhc9RkwBvXKx/WWTqFq5DD0TpG5TO/5JATW0U6TrlAs
         VuJAHlSB/36DAUBtsLmGmCSvilO5mvu/KYBwZRwj5Bw9fCeI5Zlm41niNssE0insmk
         9u7akXzfUgCvB7qNSz/sN6BVXpkddyNK13irLfKaA57Moch5+Z9ZflH5b75RM9z3K1
         1dFn+t6+ZHVhJ/wVTACcziT/pNXgV2VoJZhOR4KyodfZf/Kiy/snG0SHfpZccc7fsA
         /i6opkVnifNa8GH/0YjGBlZbndhSczJ0BzxLhvOG4CWGIkFz5aROslMJkFQ3uRGUJR
         mWH43JvF656xA==
Received: by mail-ed1-f71.google.com with SMTP id l10-20020aa7caca0000b02903b874f26036so2713080edt.20
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 03:40:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Cti8DGqbNI8YPSuGsMvGoiLdXe5FLuXImkkJsU3HkS0=;
        b=F+M5QkFy1IyurQGUqBMzD20GvHkR94V9CJMW0t2Ae7jq8EtCJWnVoLsvFEENpcIxnT
         wiVm5oLIyHCwQBvOrr5TCuYN7pf09Dp3vWvPFwaToR7mPumGtGkepLM1D4zPkOleljH2
         dDLjkmCcmiEAZTqgXqdXJY+xZswAYU3sA8YkOT7QuabWUX8vOz7bHZcxOOwQAGle1qUT
         R6aFh0SVfLgvAOqJivQbK9CMjMph1OTHPY2hsN7eW5MVnQIRJf5FxO3ccD1stpYN4oVs
         MUkit01aGmi/3SfrFSwKKYoYJqPpVHdOd/290z12cYkczPC5NJUBZUg4JgXY4Tu+zVnf
         KDqg==
X-Gm-Message-State: AOAM53320w6VCxKH41oLBjlxPUtwpZs8Uakw1fxXomSqDnzrOCwNrcvM
        Dj9sMoGocr+44nNllvo/18+I5Y9B1jL2ngZ3OlHex43IaxiBTBsqrzd86DdmCCT750KRKJwbLAa
        6+1QXNORqsf7UPHQpfpTYj5aVUfx+baNbGQ==
X-Received: by 2002:aa7:d342:: with SMTP id m2mr5302486edr.40.1627555241263;
        Thu, 29 Jul 2021 03:40:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwjxgKl6WmnwX+WqFoKb6oCeo3LEsCBOoKuWEW0W2jjhEWMO4WBVPwCw/S6BOn4eM0m2lGmgg==
X-Received: by 2002:aa7:d342:: with SMTP id m2mr5302475edr.40.1627555241166;
        Thu, 29 Jul 2021 03:40:41 -0700 (PDT)
Received: from localhost.localdomain ([86.32.47.9])
        by smtp.gmail.com with ESMTPSA id c14sm824475ejb.78.2021.07.29.03.40.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 03:40:40 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Mark Greer <mgreer@animalcreek.com>,
        Bongsu Jeon <bongsu.jeon@samsung.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH 06/12] nfc: nfcsim: constify drvdata (struct nfcsim)
Date:   Thu, 29 Jul 2021 12:40:16 +0200
Message-Id: <20210729104022.47761-7-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210729104022.47761-1-krzysztof.kozlowski@canonical.com>
References: <20210729104022.47761-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

nfcsim_abort_cmd() does not modify struct nfcsim, so local variable
can be a pointer to const.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/nfc/nfcsim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/nfcsim.c b/drivers/nfc/nfcsim.c
index 143dc49b815b..15754671eb4d 100644
--- a/drivers/nfc/nfcsim.c
+++ b/drivers/nfc/nfcsim.c
@@ -240,7 +240,7 @@ static int nfcsim_send(struct nfc_digital_dev *ddev, struct sk_buff *skb,
 
 static void nfcsim_abort_cmd(struct nfc_digital_dev *ddev)
 {
-	struct nfcsim *dev = nfc_digital_get_drvdata(ddev);
+	const struct nfcsim *dev = nfc_digital_get_drvdata(ddev);
 
 	nfcsim_link_recv_cancel(dev->link_in);
 }
-- 
2.27.0

