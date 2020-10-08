Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9A928799B
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 18:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731751AbgJHQAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 12:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731552AbgJHPxr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:53:47 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4455C061755;
        Thu,  8 Oct 2020 08:53:45 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id t18so2972407plo.1;
        Thu, 08 Oct 2020 08:53:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=mpqItggcpYz/LrcOXwKl2QwcGIxlW/MlJ/nYtcRg6DQ=;
        b=cRpIjyrU7p3ezNM1NDiDQ/+mcYw3tl4umm8u/tnOBrYymfaXjNgdL53DG1xTyTsjp8
         Uv5jXsVJbifn1TTur5jta71WFhP3akXDiOpleFKa1VMvXTEdOvAswHivlEldhamHQ3H1
         u634zBREYerUDzz63649EeHdCWgW1VKGMUv2tcw9vmkB187Mv3amzy3ZLhOJkXzuqyXO
         81RUryRhdzjgWwz1y+gCE0dpbI84pwbao2zMuo8kBVaB+ELfg3lJ5PRT88N19ozHspEq
         eYSeMZdIJf0ZN/L2FTAi3E5B2mX6mxJNH3JQvM91zToHe/VcR1fxsvDeTsSLMQxAPb/S
         dCnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=mpqItggcpYz/LrcOXwKl2QwcGIxlW/MlJ/nYtcRg6DQ=;
        b=mE2GJynsVGYQnkFTjkRN8uXmyYx+L5ramcPvJhP5JLdayth0F+IMkUEB8lBgxLmaXb
         n51wE2g3d154aTiKeAeFS5q7QYqDlE/+pce4D6UTEFkBADJHCUWzcnp/N80axO3+KF2G
         VbuFu/DLKYjmjvpmcyF1esmxwLYbPK/S1/Wgy0Kl+NmlrNz2fso1fGHqsA2ij78z2Ff8
         rAc2yEjtjxOh0HzI31sFH0/hMK+OS55W0Es5U+8s+/yK67VGGRwGvA0tK3gamuWPka+8
         sPCU0j8iRggCj1cbv0Ks82qcqwv6PnOG1ARqkOwn5CjGqGe+S+hp1AxaSKuTYG0kfbYl
         5KJA==
X-Gm-Message-State: AOAM5323TqKnbZo+/YO7EzbAsvV+fP4Y3LfkIUJBbn6IbnxYmu7c5dpv
        MFgRh91zue4A5bbsnSrBctU=
X-Google-Smtp-Source: ABdhPJwZSt4j/hpGDHQCbpMCry62EJVwG3JnboYcw/SAtcKXDw/vNpzzvcH9ME3pgnU7fs+5wOEsLw==
X-Received: by 2002:a17:902:ab89:b029:d3:9c6b:9d9a with SMTP id f9-20020a170902ab89b02900d39c6b9d9amr8062095plr.58.1602172425280;
        Thu, 08 Oct 2020 08:53:45 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.53.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:53:44 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 027/117] i2400m: set i2400m_rx_stats_fops.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:50:39 +0000
Message-Id: <20201008155209.18025-27-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: c71228caf91e ("i2400m: debugfs controls")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wimax/i2400m/debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wimax/i2400m/debugfs.c b/drivers/net/wimax/i2400m/debugfs.c
index 1c640b41ea4c..9eda1535f777 100644
--- a/drivers/net/wimax/i2400m/debugfs.c
+++ b/drivers/net/wimax/i2400m/debugfs.c
@@ -87,6 +87,7 @@ const struct file_operations i2400m_rx_stats_fops = {
 	.read =		i2400m_rx_stats_read,
 	.write =	i2400m_rx_stats_write,
 	.llseek =	default_llseek,
+	.owner =	THIS_MODULE,
 };
 
 
-- 
2.17.1

