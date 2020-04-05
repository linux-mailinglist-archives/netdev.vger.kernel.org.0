Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A38C19EA0A
	for <lists+netdev@lfdr.de>; Sun,  5 Apr 2020 10:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbgDEIhA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Apr 2020 04:37:00 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34881 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726308AbgDEIhA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Apr 2020 04:37:00 -0400
Received: by mail-pf1-f193.google.com with SMTP id a13so6007474pfa.2;
        Sun, 05 Apr 2020 01:36:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Ncl8XXtzp8goItvEp2ww15C1VisVJr6bKa4zYnBNmX0=;
        b=UiBbl3JgXB+WXPn0PDlm6JGE4zUA0Lk+w2SyBVnGyw+dtI3fMZAwpQvxLQLp1zocmc
         cbZAjRELnDckLbIDej8cQ9TYieSow+wb5wXbORwlZevebns6eo8/z0JWd8gu9J6eQvcw
         hazEBqpkdC/xBC+YGvNdp/RryMhQ/PVr5bSPI/hnLNMKTMSs9uJrrKbom6qKwt53EDl6
         DcRcqE9SMUU8sMl3p5awrJZf2xuCdUStIN8IFN3vUpYauz/B1Me3zUaDSTYiU1K/RbSb
         fzUtxc7jlXr99CrDzjo6H1+wCRql+6stLwwjt9iiefUmyJqE7D+H6jnjoPQcAsxrXOVl
         ZGFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Ncl8XXtzp8goItvEp2ww15C1VisVJr6bKa4zYnBNmX0=;
        b=IVIxM5N2nZf2mFqVHJknxklv6Tozfk8SMDwcv9j956+LEdk+pKN7R3QArlfYX6WWvg
         Hk0R2ouoazFK1irysfp3DtVp8nF3r0m6Rx+MqAsq+qWxGo1R9Qp9OsEfvK5pV49vUdXQ
         H8s+7o1gJmwji70hX4O6cM1qrrFtveq6YAaIaCITm6t0Ah80kLiqohz8hGcCT9nLeEG6
         kJeZhhmMnEbzcrejqXtHfpiD7cyQG5ieBHzO1tnAcJKgScDgfvYF1fcCGFJZGznowZCN
         a/0yUSIXgsyvaElOOrbln2fSu5eXDkHTkYbV5CU5KuL5iajctvrJre1oQ6YaHuGcmR69
         0aPg==
X-Gm-Message-State: AGi0Pubx71WSMvGnvlOUz0g1uNenb3YTfEEyjkoi0x2LLW65VR0tjzwj
        Vb6pdicLoN57msxlyAfC2OM=
X-Google-Smtp-Source: APiQypLwjpQ8/2K2EhOZmMPEwHuHozeHT2LsHn3MvCuDvbg8478/A6s7FGnWlBvSyPQ5EeyjF7JA+w==
X-Received: by 2002:a63:602:: with SMTP id 2mr15774896pgg.356.1586075818769;
        Sun, 05 Apr 2020 01:36:58 -0700 (PDT)
Received: from localhost (n112120135125.netvigator.com. [112.120.135.125])
        by smtp.gmail.com with ESMTPSA id y3sm8991405pfy.158.2020.04.05.01.36.57
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 05 Apr 2020 01:36:58 -0700 (PDT)
From:   Qiujun Huang <hqjagain@gmail.com>
To:     jdike@addtoit.com, richard@nod.at, anton.ivanov@cambridgegreys.com
Cc:     ast@kernel.org, daniel@iogearbox.net, linux-um@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Qiujun Huang <hqjagain@gmail.com>
Subject: [PATCH] um: delete an unnecessary check before the kfree
Date:   Sun,  5 Apr 2020 16:36:52 +0800
Message-Id: <20200405083652.29462-1-hqjagain@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NULL check before kfree is unnecessary so remove it.

This issue was detected by using the Coccinelle software.

Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
---
 arch/um/drivers/vector_user.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/arch/um/drivers/vector_user.c b/arch/um/drivers/vector_user.c
index ddcd917be0af..aa28e9eecb7b 100644
--- a/arch/um/drivers/vector_user.c
+++ b/arch/um/drivers/vector_user.c
@@ -221,8 +221,7 @@ static struct vector_fds *user_init_tap_fds(struct arglist *ifspec)
 	return result;
 tap_cleanup:
 	printk(UM_KERN_ERR "user_init_tap: init failed, error %d", fd);
-	if (result != NULL)
-		kfree(result);
+	kfree(result);
 	return NULL;
 }
 
@@ -266,8 +265,7 @@ static struct vector_fds *user_init_hybrid_fds(struct arglist *ifspec)
 	return result;
 hybrid_cleanup:
 	printk(UM_KERN_ERR "user_init_hybrid: init failed");
-	if (result != NULL)
-		kfree(result);
+	kfree(result);
 	return NULL;
 }
 
@@ -344,10 +342,8 @@ static struct vector_fds *user_init_unix_fds(struct arglist *ifspec, int id)
 unix_cleanup:
 	if (fd >= 0)
 		os_close_file(fd);
-	if (remote_addr != NULL)
-		kfree(remote_addr);
-	if (result != NULL)
-		kfree(result);
+	kfree(remote_addr);
+	kfree(result);
 	return NULL;
 }
 
@@ -382,8 +378,7 @@ static struct vector_fds *user_init_raw_fds(struct arglist *ifspec)
 	return result;
 raw_cleanup:
 	printk(UM_KERN_ERR "user_init_raw: init failed, error %d", err);
-	if (result != NULL)
-		kfree(result);
+	kfree(result);
 	return NULL;
 }
 
-- 
2.17.1

