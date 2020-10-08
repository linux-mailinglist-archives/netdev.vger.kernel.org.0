Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B219328784C
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731490AbgJHPx0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:53:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729756AbgJHPxT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:53:19 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05EE9C0613D2;
        Thu,  8 Oct 2020 08:53:18 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id i2so4648038pgh.7;
        Thu, 08 Oct 2020 08:53:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=EcDa6KOGsJCcoaPe10DT4p+FUs9itSeI4GGoEuDHSo4=;
        b=vSlQuBMrdZDas4CqBHX5YrI6hk23cxNw/suOKDH/j1jAufFxyK00YLovFC5AxSfL/q
         lT4QiPz2cfYNp98rbpJgbgzLsmjW+BLPGyfw8RA31sRyexT1fb+1ZXlqzzroO7pq0jle
         dSuwuTqfF8KOSw8NQiCwxkOy7IlihJ87rinfXKue9pYO99ZHP1VD4q1DMkb3cgn1tHOp
         4pYOKdjuTksbDmxtFwTh0SE5Rhb6o9IXpizTolA/ZmajJWOH1hgNOHiUd7C3yZ3GrXCD
         YCbkbYX7kmm0s3DEL92J9/F893LC/XLzB2roMbaNjAFTJwk1Rlff7Hsz1qMNDI8vU0e3
         WaCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=EcDa6KOGsJCcoaPe10DT4p+FUs9itSeI4GGoEuDHSo4=;
        b=t0TLSHGLXKkTh7R7wuiimQ8id3eZFmqElxrARdKMZNZDQBtND5yvu5UsvGEDgGcat1
         YgXNpil7q03Tlov1GvTm3knF50k1gvXC2/BfPYldj534LLPKw+fpyqf1PEXWDUENg+T8
         IWDaZZE1Ks3knyYCpg6LO8jkaFKiroA7H2IU1C6swlJAj4rqdD/xA0yQv0jfsSlQZW5i
         R2omrQ0zpRLwM6azxPFtoVjplyCxFRb+1PuewifQIw/5JkxJhR9p0a3OWzSLK7CklLA7
         GQSqKBvlTpNogAV6bZbHdemVwAUsEUYUyscFCtZzRMcL+akyHjufgdquAtA5NahjjA0c
         Gt/A==
X-Gm-Message-State: AOAM531vDTRVr0dguySAzqj6/k1e2Fcs/Lv5s4Yy+ZyobMc8WHpJOUQ2
        OLwobCzrKP1PDsBoV9oYxcE=
X-Google-Smtp-Source: ABdhPJyFtmD+VtMyQxUAl0wtRtQH624pHEYgAd0m2vp2/wS7XULTAfcRJCrLcMozlCUj3wYNxqp+cw==
X-Received: by 2002:a17:90a:aa90:: with SMTP id l16mr8918851pjq.0.1602172397553;
        Thu, 08 Oct 2020 08:53:17 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.53.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:53:16 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 018/117] cfg80211: set ht40allow_map_ops.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:50:30 +0000
Message-Id: <20201008155209.18025-18-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 80a3511d70e8 ("cfg80211: add debugfs HT40 allow map")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/wireless/debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/debugfs.c b/net/wireless/debugfs.c
index a00ebcc552e9..eb54c0ac4728 100644
--- a/net/wireless/debugfs.c
+++ b/net/wireless/debugfs.c
@@ -98,6 +98,7 @@ static const struct file_operations ht40allow_map_ops = {
 	.read = ht40allow_map_read,
 	.open = simple_open,
 	.llseek = default_llseek,
+	.owner = THIS_MODULE,
 };
 
 #define DEBUGFS_ADD(name)						\
-- 
2.17.1

