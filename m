Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0C1833AB0E
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 06:38:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbhCOFiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 01:38:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbhCOFhy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 01:37:54 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74352C06175F
        for <netdev@vger.kernel.org>; Sun, 14 Mar 2021 22:37:54 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id kr3-20020a17090b4903b02900c096fc01deso14108268pjb.4
        for <netdev@vger.kernel.org>; Sun, 14 Mar 2021 22:37:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aYq0J+9b4tKDZXBHw2wOWvtavxgBRahDPr03liFECw0=;
        b=puwumHcKmr61wNYUFotpbK2IfHnTbHcpCnzievNuhMmjO4+Eo52l2U71CPjXORPQz0
         YWaZVO/rDFNIZGuUgdkCM/DYmhSJACrGuGbgZ96S0h8GYCQo6udNxn/gTu3jjeOrPW7W
         hVbFsIw4Q4NwTZtm31kC2rzC+rWg9rO4G5tG79ebQG6fU5JB9zEI0EEx75Cx+YFRO6IT
         As3HPa1UlB63m9oLqpFab0cmMrrodrVeOKP/AkxkFjU5tWMyxjzRvXIYkER++lr4Q7zv
         l/oDALFuxF6tADxCV5wqSCQc+zPtkKBdt0k5n/nVcBHSOyLMB23OQQcHkXC8zoumc/tL
         RIAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aYq0J+9b4tKDZXBHw2wOWvtavxgBRahDPr03liFECw0=;
        b=KqeQ0HIJNXBZWwYNCm/tygLl/i5U4jBfmPlmVqTIrsg+z9Uxr8mdjPv3iwHIGUha85
         hBsMvupC2Jl6cmgayTzCT8kH9JEyjhDYNYMaXEdsmzw51hoYOJ9cqrfiEzPDInK/fQzi
         DIy71fBke80eiDys+B7ex2dkWkUsRL8nqzlpI02+Ser6arB5oh7AdQppDcSACfBCLYiR
         cktvnrk0xQDvLCTRrH7GjmRi6igbghios5bjhO+7Idp0gChhofmT/BGddCSst8b6AEZc
         pSA8PP0TfJ/9Fby2CQ3i9zQmJjGzKqF4uQUYGLNAXWulF9F1NaCGxgBP2lpIyX10zrlM
         qCdw==
X-Gm-Message-State: AOAM530hC1NUm/m2EXgUlZ632jZSuhvP7Ema4qMg7CjumLUMxKxKNagc
        Qh39JIEfqMhOg0Ath341akt5
X-Google-Smtp-Source: ABdhPJy4+A1RYkcNV8xwLGkTiZKllYZiilY4Bu0DGetxutWdy9edDqFjAl4qPO0fDEr21OfnR4xE2Q==
X-Received: by 2002:a17:902:ecc3:b029:e5:d7cc:2a20 with SMTP id a3-20020a170902ecc3b02900e5d7cc2a20mr9865008plh.11.1615786674068;
        Sun, 14 Mar 2021 22:37:54 -0700 (PDT)
Received: from localhost ([139.177.225.227])
        by smtp.gmail.com with ESMTPSA id h16sm8544215pfc.194.2021.03.14.22.37.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 22:37:53 -0700 (PDT)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, bob.liu@oracle.com,
        hch@infradead.org, rdunlap@infradead.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, axboe@kernel.dk, bcrl@kvack.org,
        corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH v5 01/11] file: Export __receive_fd() to modules
Date:   Mon, 15 Mar 2021 13:37:11 +0800
Message-Id: <20210315053721.189-2-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210315053721.189-1-xieyongji@bytedance.com>
References: <20210315053721.189-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Export __receive_fd() so that some modules can use
it to pass file descriptor between processes.

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
---
 fs/file.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/file.c b/fs/file.c
index dab120b71e44..a2e5bcae63ba 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -1107,6 +1107,7 @@ int __receive_fd(int fd, struct file *file, int __user *ufd, unsigned int o_flag
 	__receive_sock(file);
 	return new_fd;
 }
+EXPORT_SYMBOL(__receive_fd);
 
 static int ksys_dup3(unsigned int oldfd, unsigned int newfd, int flags)
 {
-- 
2.11.0

