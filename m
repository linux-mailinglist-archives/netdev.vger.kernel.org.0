Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9462C287938
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731080AbgJHP5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:57:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731359AbgJHP5Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:57:16 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88C33C061755;
        Thu,  8 Oct 2020 08:57:16 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id h6so4665783pgk.4;
        Thu, 08 Oct 2020 08:57:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=V8fy3Kq8sOrYayDD4gS9i4nmIERqbx+Dqf5lZvfV3Bg=;
        b=EePmbiHc47uDLXXl0zRfryPRMckVgANu0pwOg+QUHn5bBSVMbEmqKDX01E2p+9g50H
         K2GhUjRa8K7vqX8kxebJjkElC3q1YWGav8cnwQod1P9Y7qZXKCSGYoqlaqt0oSSS88uH
         1Ku43CvzCDMIBmrQzzZrdAxF5w+8KfGStrBTEAvI++uJwoo3POmye3iif9m097H9/K/e
         ieJXkQuw1pcbspfsL73kQtt1IsY7zsmPgiRALE/TiXnAAn+CrGq4bYUqCzehGsDFIYB9
         OK7ZcCvqZ62O0OXnl6c8kmqyCSq+8MGa94td9SHNtsilN0K1iboAmQPHIiJj60VYo+8c
         sypg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=V8fy3Kq8sOrYayDD4gS9i4nmIERqbx+Dqf5lZvfV3Bg=;
        b=ZgXs3HhvV8vRg+DypgPsWTXkCTcsAlI6gdRlJVjfbDIIEWKNCh+Dtkqi+vT3uBrDSG
         g+pbX/BLio63bYLTQuargoUFcKe92C5HNoTFa0T+l4Wwn7ddhZl0p13+SouOuA3NDtoT
         U1ruRk+SV/ozk2q3n3Oc7Esj7cacml6uy+nD1J0mvRnsBbO9Wd3G/VGvub4yrwZ6V68V
         gP5yiDMqWciOff8tCtfKKaP4zjeZlL+QwN8mRsE9pVFRCEOROTlZ9HhFCkxvHmsF4hlG
         lD9MUNXgkRZYOuTQHKK2JZyWgavXGyIB8QV51ZspGBUKxDC87xX6KvBiok13uuG48Ux1
         VBLw==
X-Gm-Message-State: AOAM532QtOEZm2ISa0/c06GRmvQQt2Q/Y+G8a8+1XTE7DiCJJw26KWY6
        ivXnD5VX4/h1JfuAeaKlFNAu3WUcITI=
X-Google-Smtp-Source: ABdhPJxh0OekccuQuEQMrKjOggvT8ShtjjNmea7neH/zGjSLzE3cpaaf53cwAhi37TwNdjVK31jVeQ==
X-Received: by 2002:a17:90a:9904:: with SMTP id b4mr8166498pjp.223.1602172636099;
        Thu, 08 Oct 2020 08:57:16 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.57.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:57:15 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 095/117] brcmfmac: set bus_reset_fops.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:51:47 +0000
Message-Id: <20201008155209.18025-95-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 2f8c8e62cd50 ("brcmfmac: add "reset" debugfs entry for testing reset")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index f89010a81ffb..f3d358a1aa07 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -1184,6 +1184,7 @@ static const struct file_operations bus_reset_fops = {
 	.open	= simple_open,
 	.llseek	= no_llseek,
 	.write	= bus_reset_write,
+	.owner = THIS_MODULE,
 };
 
 static int brcmf_bus_started(struct brcmf_pub *drvr, struct cfg80211_ops *ops)
-- 
2.17.1

