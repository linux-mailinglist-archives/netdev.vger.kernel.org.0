Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98AB63DA14A
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 12:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236745AbhG2Kkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 06:40:53 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:34506
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236320AbhG2Kkp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 06:40:45 -0400
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPS id A33173F051
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 10:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627555241;
        bh=So1uUDkE721+BEqMeRM8NOIaRYftuFanUkfPQdOA99A=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=u0jjrKClB9lAfxEnC3BPeK/21mXBBAY/dUsu55HIiip9FeWVwDD9hLpvpNrV2p8WY
         A+V4z+55VhIP8Rt1QLZwB+0YwbPjOBPsJCpgKdD5+RdCFezYei+C3nCGpQGco5aVBJ
         FDVCZX0W2yHfcRiICYN5ZFgWOekdrDht67W8FVjkjwLfDywc2qMDtzAE7kf4hGOsXH
         i581WHEd4bU9kRn+r7AFexTBXfHioAWLzJ8CNDyFL8wDnxK/Mg6q9jx31LEf1Ug8zQ
         tMEN4X01kURbUR5kKZ4xI9+hRIKxPIQHyOCOyxH556XUZhU8LxJbnpR7GmMwaW5DIa
         EIjImHCHsVlqw==
Received: by mail-ej1-f70.google.com with SMTP id lu19-20020a170906fad3b029058768348f55so1847690ejb.12
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 03:40:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=So1uUDkE721+BEqMeRM8NOIaRYftuFanUkfPQdOA99A=;
        b=Na99Gebqi/G0kQyIwmPLHrE2sNbXbt+EjABwS7IvZN+tqblYZcmkTnmc+OdkSeH/Bm
         EIX39RT9voc3Do39IDLF4SMrNSftc7NwsrDKBuPhCTbmZpROilYAw/UkoMrkHc96/6JW
         X/np99gv1zFmA7AE/NYnpV7qveYNL48wx2YfRhHxA62Pns6JHGRcdsNXWrss6FoTzJHE
         q8+hdHleU9ZM4BvvWTFVL55GYXwqfiFnBoKhG0mixGHLHwdgp8X7viqPyy2C1jNfUTrr
         rqNiZMrUpB5qq3K06bZlVyST9ocUVACH1Gz1M8IqHyMsLLOtJTUSz8HBPDvo47ndyk40
         1oTQ==
X-Gm-Message-State: AOAM531gRu/DbDkg+3n/NKj5fgi+IkKvSZ3HqNredA75ibJgk/lQW2oM
        B+xShEICbPkIwVOf/wAGGLeG8jHMzs8MkzfTV2DmGIyRe8l/+6aCuycDInhSOUdHAyB+WGPYHYK
        PgJzB8Ooa7B4imTNTWKAsKw3/J4o1NhuDbg==
X-Received: by 2002:a05:6402:cb9:: with SMTP id cn25mr4576418edb.271.1627555240172;
        Thu, 29 Jul 2021 03:40:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwg8gQFeBPTWOxeoK6KYjuQRUdToXFwmH6p9ZgcYdRRS/mw4BXtIUndBzQfGalBkLacI2jz9A==
X-Received: by 2002:a05:6402:cb9:: with SMTP id cn25mr4576407edb.271.1627555240070;
        Thu, 29 Jul 2021 03:40:40 -0700 (PDT)
Received: from localhost.localdomain ([86.32.47.9])
        by smtp.gmail.com with ESMTPSA id c14sm824475ejb.78.2021.07.29.03.40.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 03:40:39 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Mark Greer <mgreer@animalcreek.com>,
        Bongsu Jeon <bongsu.jeon@samsung.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH 05/12] nfc: virtual_ncidev: constify pointer to nfc_dev
Date:   Thu, 29 Jul 2021 12:40:15 +0200
Message-Id: <20210729104022.47761-6-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210729104022.47761-1-krzysztof.kozlowski@canonical.com>
References: <20210729104022.47761-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

virtual_ncidev_ioctl() does not modify struct nfc_dev, so local variable
can be a pointer to const.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/nfc/virtual_ncidev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/virtual_ncidev.c b/drivers/nfc/virtual_ncidev.c
index b914ab2c2109..2ee0ec4bb739 100644
--- a/drivers/nfc/virtual_ncidev.c
+++ b/drivers/nfc/virtual_ncidev.c
@@ -170,7 +170,7 @@ static int virtual_ncidev_close(struct inode *inode, struct file *file)
 static long virtual_ncidev_ioctl(struct file *flip, unsigned int cmd,
 				 unsigned long arg)
 {
-	struct nfc_dev *nfc_dev = ndev->nfc_dev;
+	const struct nfc_dev *nfc_dev = ndev->nfc_dev;
 	void __user *p = (void __user *)arg;
 
 	if (cmd != IOCTL_GET_NCIDEV_IDX)
-- 
2.27.0

