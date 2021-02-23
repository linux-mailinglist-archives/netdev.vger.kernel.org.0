Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB731323102
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 19:52:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233994AbhBWSvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 13:51:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233981AbhBWSvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 13:51:12 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C011C061794;
        Tue, 23 Feb 2021 10:49:55 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id k13so6139913otn.13;
        Tue, 23 Feb 2021 10:49:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=L0iZbl437yra/gk9MNWYtkrCav7oz/HquwZHzP1xLuI=;
        b=fLNzGyNeQLWR7xDZ/Pf/iaa02rlGoou9oPQVSkuft9qYc2Z+6kqJMbHkf4ldsFjz/3
         HNYsvMJsK2Hx65vZz3QVu/yY2yf0eFZFdcvv7xchh/9tIynq6YsMARJAPQjJVu94hkOI
         aFUcbQnJ3kW+/xQYdXKPAY7HlbWt08IjAnLYiHKn1KZJOM9RsPOVEcucCkgHwcEiZepV
         UGEfvLdSvFgjZ0XMsCy6lttPqLF/uIAL4R+vtLy0TMoLyWL1jZIKFTWoAgfN5CpVecdj
         Bqk27+M2DX5heuPmDnrRivwiv1KzqBp7eXviOwBy1gM+jvictVundtnNOk+n1ljrdakZ
         vtNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L0iZbl437yra/gk9MNWYtkrCav7oz/HquwZHzP1xLuI=;
        b=sPL8RwdxFYQHkYWL/rws7zZ8ZNxMF4etrBwpeH4YwAWuGsPd0wJybOKfeQOZxLeaol
         UZvpXUwVdvU8zOjryKwIrbHIh7gHWJR7YO2L2fh+GugAROZmW7/2nlL4Z6Ka7hPkJV4I
         0SBVSWFZPSA4DtNnL99xObjtnjJLj59ZFVF/2u22PmVMZVkxUFMb8PwjfSEYwMX4lv1f
         fGvuVrZcRR0ZTlEkJdegm1jX2i5rskorlpyEeAQoH1+DXcmM7mXgaS9WYex+3d74IjCV
         z/qmCN2KQYDRbPHT72kPREcKnisPD1+t06gFbq9n0kQMI2zjzRr+lmRqEdMntqvDdoTe
         zU8Q==
X-Gm-Message-State: AOAM532dAjmG1b09sbaWJdVqN1dWEnYSBsdrpG5k3Z1OkfTjoBnQ1Dm3
        VmhyeikTkYg+lVgYHkXH9zvjZMJLGvpk4Q==
X-Google-Smtp-Source: ABdhPJzc3LpPRLSQJsrQKJlkjANy6rWMzi0ke5aCv9BzhwcptpOaVU7ETxLrZQ2l9rmU+wlI1btWlg==
X-Received: by 2002:a05:6830:14cc:: with SMTP id t12mr12084337otq.109.1614106194551;
        Tue, 23 Feb 2021 10:49:54 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:4543:ab2:3bf6:ce41])
        by smtp.gmail.com with ESMTPSA id p12sm4387094oon.12.2021.02.23.10.49.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 10:49:54 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: [Patch bpf-next v7 7/9] skmsg: make __sk_psock_purge_ingress_msg() static
Date:   Tue, 23 Feb 2021 10:49:32 -0800
Message-Id: <20210223184934.6054-8-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210223184934.6054-1-xiyou.wangcong@gmail.com>
References: <20210223184934.6054-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

It is only used within skmsg.c so can become static.

Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/linux/skmsg.h | 2 --
 net/core/skmsg.c      | 2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index d9f6ec4a9cf2..676d48e08159 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -340,8 +340,6 @@ static inline void sk_psock_free_link(struct sk_psock_link *link)
 
 struct sk_psock_link *sk_psock_link_pop(struct sk_psock *psock);
 
-void __sk_psock_purge_ingress_msg(struct sk_psock *psock);
-
 static inline void sk_psock_cork_free(struct sk_psock *psock)
 {
 	if (psock->cork) {
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 35f9caa3b125..46e29d2c0c48 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -619,7 +619,7 @@ struct sk_psock_link *sk_psock_link_pop(struct sk_psock *psock)
 	return link;
 }
 
-void __sk_psock_purge_ingress_msg(struct sk_psock *psock)
+static void __sk_psock_purge_ingress_msg(struct sk_psock *psock)
 {
 	struct sk_msg *msg, *tmp;
 
-- 
2.25.1

