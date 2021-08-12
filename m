Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C6B53EA910
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 19:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234362AbhHLRDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 13:03:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39053 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234251AbhHLRDg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 13:03:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628787791;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=J954MLxa9gOHhPQ2vkkolUzmWyf9ox971ksqXH7Ids8=;
        b=Ni4RRz1vU1qQK6G1HgX1rbmCgcvho08HeLR98oiUQLqLM9zDN3uMoxyvYbXz6Fdepj90oY
        TDgu+Vwzjy9bfqfZCjvoP76yP9BGICY8Va+1ncP2DYxLJnQ11GuJCaXgZECQPTxX1LDv1j
        DWImDrzeB9Dx2Z5O2dCUhDqZN6JIOHE=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-513-wgasWdoTMY-ryYczZR233A-1; Thu, 12 Aug 2021 13:03:09 -0400
X-MC-Unique: wgasWdoTMY-ryYczZR233A-1
Received: by mail-oi1-f199.google.com with SMTP id o5-20020a0568080bc5b029025cbda427bbso3179656oik.5
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 10:03:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J954MLxa9gOHhPQ2vkkolUzmWyf9ox971ksqXH7Ids8=;
        b=RMghKYtdV4RZwfeNlV5aidvgoq2zpX/bfqnwZC1PNjrTlGxtdlkIL4+jh5rxhBy9tW
         70GJg0XjtISDA6MXVy7ANy2VY2MMBi2IsmkyiJC3O9IXeesU9YekEZHqeuSvA4bne3C+
         /c0ub156dgzfknLQOfh05MlX0bfx7AQS7EE3zxW7MSG9wGRhHS/v7v9dFH2WBYIbvF4K
         nNRw7J1sAYNtG/P6QGRPfJ3fWj07DmJSnutbuWuDKzBDjx16GC5J8vmz8mxooYW0esBl
         C98X1Ibt7DKoYnSuxzW3CBJ0tsTPdsd8it4QrpDFmYW1p4Xfwm4/FlIB+YIByEO0cSur
         p7sA==
X-Gm-Message-State: AOAM533cCEinvomaVbRjSCmfLv5paXgcv7uZXcUzuxKidhiKQvUOm24S
        omvb5SWR1d6og/tt4XVlinOgXjeq/lxlXg4WiDNzMEUxnv3pumJ72wu5ej+yZPNxJpA222cxgSo
        G5hwjAa1p4nE0W0rz
X-Received: by 2002:a05:6830:11d4:: with SMTP id v20mr4113228otq.358.1628787789318;
        Thu, 12 Aug 2021 10:03:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJykzvJTl7IgT9ugEjGH3GRxKniSCfzdb1tXmDjHVTSGHXjRu3xi7zcEhXGhRmIzmuNwDKlWyw==
X-Received: by 2002:a05:6830:11d4:: with SMTP id v20mr4113216otq.358.1628787789169;
        Thu, 12 Aug 2021 10:03:09 -0700 (PDT)
Received: from localhost.localdomain.com (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id g20sm733386otj.9.2021.08.12.10.03.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 10:03:08 -0700 (PDT)
From:   trix@redhat.com
To:     aspriel@gmail.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@infineon.com,
        wright.feng@infineon.com, chung-hsien.hsu@infineon.com,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        zhengyongjun3@huawei.com, linus.walleij@linaro.org,
        lee.jones@linaro.org
Cc:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tom Rix <trix@redhat.com>
Subject: [PATCH] brcmfmac: Fix fallback logic to use firmware's canonical path
Date:   Thu, 12 Aug 2021 10:03:00 -0700
Message-Id: <20210812170300.1047330-1-trix@redhat.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

Static analysis reports this problem
firmware.c:709:6: warning: Branch condition evaluates to a garbage value
        if (ret) {
            ^~~

In brcmf_fw_get_firmwares(), ret is only set if the alt_path control
flow is taken.  Initialize ret to -1, so the canonical path is taken
if alt_path is not.

Fixes: 5ff013914c62 ("brcmfmac: firmware: Allow per-board firmware binaries")
Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
index adfdfc654b104..e11f1a3a38a59 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
@@ -680,7 +680,7 @@ int brcmf_fw_get_firmwares(struct device *dev, struct brcmf_fw_request *req,
 	struct brcmf_fw_item *first = &req->items[0];
 	struct brcmf_fw *fwctx;
 	char *alt_path;
-	int ret;
+	int ret = -1;
 
 	brcmf_dbg(TRACE, "enter: dev=%s\n", dev_name(dev));
 	if (!fw_cb)
-- 
2.26.3

