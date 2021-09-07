Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C664402879
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 14:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344553AbhIGMUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 08:20:13 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:36930
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344163AbhIGMTg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 08:19:36 -0400
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 780A23F046
        for <netdev@vger.kernel.org>; Tue,  7 Sep 2021 12:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1631017109;
        bh=YdMV9AtCFFKriT3c6sHpvFf+xJsEOIFlGHmRsaTySis=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=qBG5xL/oSh+vjTMtWlhOVF1PjcphDvGfT2MWWZbNeUBn2q97PuoG9oUcfVj2FvMUO
         Hx71Klqa3Ztgs3zedRHZde1/LOR0uiAJZBj7ZnKLWZuCtXa82iH9r7eEgRnEo5oMRz
         f3r/t5TDgWB8R8tZv8AzlWcEOhJ6tBSgUMRsZopU0eEFIcRVJQaDQf0UlG1WwIOgtn
         7Xkmb5l0lLroXmvKoPZOC8zhkPzq1jhD7ecfthdp6jBW0BQv9YVbHhzJ5nyXLVePv0
         MFtPdysCq2uP6PqYhVQpGqlJBs/IfccdwaZ/1ZCfYUBa71h+QKdJ7I50sUkgDXQDYi
         ifsPdel0CLJFA==
Received: by mail-wm1-f69.google.com with SMTP id r4-20020a1c4404000000b002e728beb9fbso1102720wma.9
        for <netdev@vger.kernel.org>; Tue, 07 Sep 2021 05:18:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YdMV9AtCFFKriT3c6sHpvFf+xJsEOIFlGHmRsaTySis=;
        b=avbADy1cPpLLUTfSa/CpGZ7RPqOg/qdBafPRy/g2PVo79SBalKYm9HuvDbPLqCvJU7
         O3JidZj3j81otwbJ8uNsvPl/79FsFO5gcjgvkK8Ga+fqrgzjfD6kGVruM7+SKh9lTgvW
         f6D1vXkXyAkW+W7/kfboMPg0X9PtwxlTVf2m7HAnyQ5vM+SjVOP198R94jRwmgsZX94e
         NKrRq3US6d+CmEA6o33DOAS0YJi53WiJC3iB7tSA6vcX/C3TpbjwR4vGXfxiZ/gqfuAD
         3cOwepwrXyNmIQslmxVpT0AwYY/ijG1XQUjSgZD7D5sb/pirnyCkrYynDb+LX7VJEC4+
         PNKA==
X-Gm-Message-State: AOAM533TyVGmSi00IpH3LOwwZweMu6nMWmw4JJlG1n2O5Z4qHC/S6chr
        YSDATpDha6rVTEyqXCoE7j/n87e3Q637LB8vEge8iCJpgo6UYRWHzz4KwpjCEoP8lyVreoPG8W0
        RvAAxGP8eYOs4KYIoaBOy1D205kEfkvPBKQ==
X-Received: by 2002:a05:600c:350b:: with SMTP id h11mr3654026wmq.101.1631017109259;
        Tue, 07 Sep 2021 05:18:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzeRcCdgrHtnMCO7A+nbg1gEw4limhbMFTd6XoH8BCc4zr+JcLbKNmTHmhDOb/OCnlEj6YCKw==
X-Received: by 2002:a05:600c:350b:: with SMTP id h11mr3654008wmq.101.1631017109127;
        Tue, 07 Sep 2021 05:18:29 -0700 (PDT)
Received: from kozik-lap.lan ([79.98.113.47])
        by smtp.gmail.com with ESMTPSA id m3sm13525216wrg.45.2021.09.07.05.18.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 05:18:28 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        Mark Greer <mgreer@animalcreek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH 06/15] nfc: pn533: use dev_err() instead of pr_err()
Date:   Tue,  7 Sep 2021 14:18:07 +0200
Message-Id: <20210907121816.37750-7-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210907121816.37750-1-krzysztof.kozlowski@canonical.com>
References: <20210907121816.37750-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Print error message with reference to a device.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/nfc/pn533/pn533.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/pn533/pn533.c b/drivers/nfc/pn533/pn533.c
index c5f127fe2d45..da180335422c 100644
--- a/drivers/nfc/pn533/pn533.c
+++ b/drivers/nfc/pn533/pn533.c
@@ -2171,7 +2171,7 @@ void pn533_recv_frame(struct pn533 *dev, struct sk_buff *skb, int status)
 	}
 
 	if (skb == NULL) {
-		pr_err("NULL Frame -> link is dead\n");
+		dev_err(dev->dev, "NULL Frame -> link is dead\n");
 		goto sched_wq;
 	}
 
-- 
2.30.2

