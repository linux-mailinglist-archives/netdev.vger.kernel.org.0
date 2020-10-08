Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 825B528791F
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731682AbgJHP6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731902AbgJHP55 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:57:57 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 324BCC0613D2;
        Thu,  8 Oct 2020 08:57:57 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id o8so2972954pll.4;
        Thu, 08 Oct 2020 08:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=AFWXZVrwcjxb7AV7eZJ7W+RHISEo0yE2Tz/KwoEPeGo=;
        b=ODVSAC1gjTRyWeAMrRdgoNpInTOcrYW3tytPTnntL/ztUKHRFV9LJCvmBGEW5i0OFU
         VMZdGc+0bSppWBm6cSJS7+DSafqo1xdNR+MurWSY4RGIVaeIAQ0wVxGmo1lNFC0vODCm
         v9tTd/C4kX0L3xSGbazTiZEKLAJT7TjFAKYlW2SoEIa90F3dirlQyaar5NBrONZndySd
         JQyAZzjRS86H+i6J5uruaIsHnaoIQoYy5AxqsiH65puw+RwZuh6DQTyrEg9i09BF36CI
         Ozm/2bvpNuvIumzVc9PVvxReVtPkc9R2573lHG2+CiHpJW14OGGNYOzwjmfZD82WWY4I
         zsPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=AFWXZVrwcjxb7AV7eZJ7W+RHISEo0yE2Tz/KwoEPeGo=;
        b=jmEkyyBHfASSI6U3r5Lp/d3Ua1DB8B/X8HXwq3rPpR1cZ93M0UvWGJra1u9SViRF0r
         +U6gqqdx71GjEyZQM0umDUT5CNKcofboHSxdBxOMKvW8FWTXcUvQglEsdKRHAl1x1AJk
         4NZ9BcDY1Wdtq38N5Vp0z8h+p70wcbZL+ArnwZIzkKJ99PgwkOkrIXLl1OZ5rajcoldF
         SdzzxZTU0zjHrVvsMPxcNb+A6h231LMXOAJRwwxZHjn+R459UkplOjlFo3se8Jgt5ptX
         o2yIcqx/zXEXpzFEn6F+e6PeFI2oEMf/sq8tm5/U+cnr9ffqtguOnWDKL6/ciAcIvS7B
         RzMA==
X-Gm-Message-State: AOAM533ckAMSI7f5J7SQrV3/PAA9GO7bSDNMQaC4Ql3tfLiCKkLgEqET
        7RV3G+MbJP0p/AmwklrmVenClHVjN50=
X-Google-Smtp-Source: ABdhPJwbDreiq3WBqi0fVcNFkziqio4DAp5RiyyvpiYFryVGYclEoqrd32lquFc6VS4wuB543AJm2w==
X-Received: by 2002:a17:902:7c0d:b029:d3:de09:a3 with SMTP id x13-20020a1709027c0db02900d3de0900a3mr8023424pll.52.1602172676760;
        Thu, 08 Oct 2020 08:57:56 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.57.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:57:56 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 108/117] Bluetooth: set force_bredr_smp_fops.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:52:00 +0000
Message-Id: <20201008155209.18025-108-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 300acfdec916 ("Bluetooth: Introduce force_bredr_smp debugfs option for testing")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/bluetooth/smp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
index bf4bef13d935..9b96a2d85e86 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -3407,6 +3407,7 @@ static const struct file_operations force_bredr_smp_fops = {
 	.read		= force_bredr_smp_read,
 	.write		= force_bredr_smp_write,
 	.llseek		= default_llseek,
+	.owner		= THIS_MODULE,
 };
 
 int smp_register(struct hci_dev *hdev)
-- 
2.17.1

