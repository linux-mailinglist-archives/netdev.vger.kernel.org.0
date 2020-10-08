Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7FA287960
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732041AbgJHP7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:59:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730891AbgJHP6M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:58:12 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B63BC0613D5;
        Thu,  8 Oct 2020 08:58:12 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id n14so4345737pff.6;
        Thu, 08 Oct 2020 08:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4Q3tt6tkPaS/9so7gcfZUREF7SggwCHKWDmvfIExvG8=;
        b=c346zn0sbGCSVkN8iEd+inCP7K241yzuGSNt1lM9EqoPgFxgaawpV+ovruX03gHk7d
         3BSaosAf6S17wONIRKKBeR+cFqRnw5hUDlF3/8Nnf8niDCAfi1UkmCtaTdMnrybGRCZu
         zlqkiUGHUfUpAhdfU4kJWTnUByc6uIREyd3Iqe6B4QaGG8+UQRuqGjpg3JORj4uBytmE
         aC9mliZmcP75v+rzgTyRjybYKosGSWm4tc7bLOj/EJKdMt8VI6KujAQMPaqVsmZRmh62
         QPCe9wRTYuPVScSbwtawz3UWWEh1seOy172H0wLjF4sgEgBdjB9wugIArjl+Vrt2gSd8
         sp+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4Q3tt6tkPaS/9so7gcfZUREF7SggwCHKWDmvfIExvG8=;
        b=pY7capGuSeymafHnNVnqrzwdEXC1RHHqy/khU11LSCM/s8LTtQTe8rNmnYXB64Colz
         pwUWNXHHsk+6QChojE+6LAe0MsnaRh/6rlKToAAbfEQl0j4pGzMtIk0dfSd47G+LcBlH
         sLk+8rLgSv7iKOgR2JMxkhqvWD+lteeMrE/uyev1TfEDuUeIQA8gcmLyXeD/CrTD8QoT
         WRZ6cEH5aMCDnIeNzXh9vLU77CNKlMLqSOsSdrO5prV3OMD2C8NYihCEUHqyw5HKkiqS
         RaQIPIM8ak2vKBWdCjxqKo4gOYxa6QjLdWUOwBAT5RcY87k8ceRtfuSnnqCFJZiDQJMM
         aNeA==
X-Gm-Message-State: AOAM533qjgcEgkPzBQ69QJRTpB8XU6Q/KUdQirOtEHV2kCGPutnGYiVK
        XV5vABdZjUyorfEIQMuh+38=
X-Google-Smtp-Source: ABdhPJyZaVpQYcmNxbB5NUuhW09qI7iqEDvyEVLvGU++XKAdCpEWTFn15X9ZFlNafwlIx5d5Q9f/Yg==
X-Received: by 2002:a63:5c07:: with SMTP id q7mr8180649pgb.222.1602172692199;
        Thu, 08 Oct 2020 08:58:12 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.58.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:58:11 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 113/117] Bluetooth: set ssp_debug_mode_fops.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:52:05 +0000
Message-Id: <20201008155209.18025-113-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 6e07231a80de ("Bluetooth: Expose Secure Simple Pairing debug mode setting in debugfs")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/bluetooth/hci_debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/hci_debugfs.c b/net/bluetooth/hci_debugfs.c
index 4a26cb544635..d162736a5856 100644
--- a/net/bluetooth/hci_debugfs.c
+++ b/net/bluetooth/hci_debugfs.c
@@ -441,6 +441,7 @@ static const struct file_operations ssp_debug_mode_fops = {
 	.open		= simple_open,
 	.read		= ssp_debug_mode_read,
 	.llseek		= default_llseek,
+	.owner		= THIS_MODULE,
 };
 
 static int auto_accept_delay_set(void *data, u64 val)
-- 
2.17.1

