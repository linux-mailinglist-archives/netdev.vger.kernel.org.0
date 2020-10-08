Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9665E287859
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731551AbgJHPxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:53:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731539AbgJHPxn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:53:43 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E1C5C061755;
        Thu,  8 Oct 2020 08:53:42 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id y20so2946506pll.12;
        Thu, 08 Oct 2020 08:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=PT+2dTQKPMAMm7soeIkw9GAbj1teON7hA2mLpYNf8Q0=;
        b=gU1jKUlOFB84z6apiwrq7P7F1Mps2iG23daSKL225Kty+XV8LoGMnmN8KC/LnZ4mzz
         TMfXTXhxiw3i7fbAHWR4gsUWgmykcJzbOHqhM34u5++YAuFJ5Yg9w6vapiboK2ci3Gmq
         esegYPt77yd68yHDcpszlAkfbcXrBAgl8M6lf66tnZjqUr/P1pu2ZEhZPWuxAOHaqj5G
         p0U+GszSCRZrzjjVPyuX0ZXP++YSkvhLtMJabxS9fM078j4YMGXkuhqtZEHIUTSOK9M6
         0GjBMj1IjZADPx6fVujPuZ/TpARtgGHIbMQabniD93+avHKO0QWcrEGxO9wb/GoPahRA
         J5Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=PT+2dTQKPMAMm7soeIkw9GAbj1teON7hA2mLpYNf8Q0=;
        b=eFfksudojaFNUmllcvEDWmktmdLs6sB/K7XR5mLNK4iaOUMWdmO0xPwDvi/RTWVlU4
         PLDo5G3ujfOlEGdcyQO/ki8GscqTalFIYTicbWG8JVwmX+yGffiw5U5o3eQF66CpKZET
         KhSHpFQIFAsa1o53CQ5VJqWT+PQwfKC8Cs/ENR6nLRxE7spJbVtwGWuY59X3riIQPkeW
         LNq9W8zR362+G+91/5/CeW7KWvV8L7O1gADDmWarYbiTlWkcS3UXbSZ+dWCuyETRfo9h
         pI5B5eXYuuuz37xCeE0m0I79xn5H1xuDADnRzf/5Fp17Zj8MsynBRoNQ6KtXLt7U8Bfe
         Bfnw==
X-Gm-Message-State: AOAM532SmntY/8iFtUNpnwz9gpquf1oLfDEyrzntmrHY4uS+cYWFymtN
        zLigeyaOQ6WMcj/NPCzUO54=
X-Google-Smtp-Source: ABdhPJw1MoEZwrIFqxFHIWA6nBXAdhnsMdvbNpSvHPijD3oKblKJUXU3Quh/Pj0YijC3zWxlz7bE1A==
X-Received: by 2002:a17:902:c143:b029:d3:f20c:ed84 with SMTP id 3-20020a170902c143b02900d3f20ced84mr7979028plj.76.1602172422120;
        Thu, 08 Oct 2020 08:53:42 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.53.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:53:41 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 026/117] ieee802154: set test_int_fops.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:50:38 +0000
Message-Id: <20201008155209.18025-26-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: ded845a781a5 ("ieee802154: Add CA8210 IEEE 802.15.4 device driver")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/ieee802154/ca8210.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
index 4eb64709d44c..d7b68c1279e6 100644
--- a/drivers/net/ieee802154/ca8210.c
+++ b/drivers/net/ieee802154/ca8210.c
@@ -2672,7 +2672,8 @@ static const struct file_operations test_int_fops = {
 	.open =           ca8210_test_int_open,
 	.release =        NULL,
 	.unlocked_ioctl = ca8210_test_int_ioctl,
-	.poll =           ca8210_test_int_poll
+	.poll =           ca8210_test_int_poll,
+	.owner =	  THIS_MODULE,
 };
 
 /* Init/Deinit */
-- 
2.17.1

