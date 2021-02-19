Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1769320213
	for <lists+netdev@lfdr.de>; Sat, 20 Feb 2021 01:00:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbhBTAAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 19:00:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbhBTAAF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 19:00:05 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92393C061797;
        Fri, 19 Feb 2021 15:58:50 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id b16so6726905otq.1;
        Fri, 19 Feb 2021 15:58:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RcbluTouVB6/rFLYgmpItY/JPds73C5Ori6pD1ifdmo=;
        b=adAErgkkGUS15VndtNJdUuEk1GjpSBXINxKEEZbfC41EQkOcXiT+0eVAfyZBKyxaTu
         zhijQ/tnLGWqZnHwGiXRnXpkyJlxbZSnRUMOQsF4+AzHNEF9dIpOAk5gT/DXDLNSLLvU
         r5WsaIpG5U+T6gA75+nrPyGKTAWblCD6MF9xWJeyHxNwep+TTlnhZZcWqV+CmcfQsMie
         qW9nRUxMif93IU9t/O7iryD9TeURzlQEBs4x3ezsY9uu2GiMxx/Lu+pL8fk+ZKxZiNGR
         jxP/uEm51d8slStcEydTP9FRreYyFZwgqkNZAUgvWsM1DU9qxjM6EXO5w5XsirQgDs4+
         zfhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RcbluTouVB6/rFLYgmpItY/JPds73C5Ori6pD1ifdmo=;
        b=MKWgxvU2b7m5hht69GdZ/dOah/z2lLtzF+2fbBhUQatpLdaGXllU9d6RJ6Z7iznc8l
         Bh6x7SGgYj+Uq1bZF362s4td4acsu9k0gisnp/+rh/RcZrkXOZZvmycjpEIBBiY+HwFa
         ERJCmz2EEFdeF5xwV4cEcrASB3HdC88MmCE1oY+Hjq2MVNPY4qagf3nl2Aeqg3v57jtP
         JXoQ/d8Q2XdYuLOF/KjCYwhQcUr/f+FlE7VrxdbjzEN6uNrF11zfHoHu/nyaH4AmY53C
         HxgmUmO7l/Oug210scmnZ1NSR2T50FeCM7ZKmRiq/75yYEPHHpgIwgQDRSA0wXUcflPg
         6bRw==
X-Gm-Message-State: AOAM532HXxEQDlPlRLRTP9EulyemCr/kjZr9KA6pjCSFEk7dZ7STQ7CG
        FPfpVKtiiNQYc2tyEq29NF4RHuTLuyQILw==
X-Google-Smtp-Source: ABdhPJxxDE+3OFqzxdO46OzDlgSxdnSvwk971rQFlm/cSBsHjavzu7+hbtxZRzsYktoINi0ztmHpyg==
X-Received: by 2002:a05:6830:118a:: with SMTP id u10mr246779otq.112.1613779129882;
        Fri, 19 Feb 2021 15:58:49 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:1d72:18:7c76:92e4])
        by smtp.gmail.com with ESMTPSA id h11sm2064186ooj.36.2021.02.19.15.58.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 15:58:49 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [Patch bpf-next v5 7/8] skmsg: make __sk_psock_purge_ingress_msg() static
Date:   Fri, 19 Feb 2021 15:58:35 -0800
Message-Id: <20210219235836.100416-8-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210219235836.100416-1-xiyou.wangcong@gmail.com>
References: <20210219235836.100416-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

It is only used within skmsg.c so can become static.

Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/linux/skmsg.h | 2 --
 net/core/skmsg.c      | 2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index ab3f3f2c426f..9f838bdf2db3 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -344,8 +344,6 @@ static inline void sk_psock_free_link(struct sk_psock_link *link)
 
 struct sk_psock_link *sk_psock_link_pop(struct sk_psock *psock);
 
-void __sk_psock_purge_ingress_msg(struct sk_psock *psock);
-
 static inline void sk_psock_cork_free(struct sk_psock *psock)
 {
 	if (psock->cork) {
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index dbb176427c14..286a95304e03 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -620,7 +620,7 @@ struct sk_psock_link *sk_psock_link_pop(struct sk_psock *psock)
 	return link;
 }
 
-void __sk_psock_purge_ingress_msg(struct sk_psock *psock)
+static void __sk_psock_purge_ingress_msg(struct sk_psock *psock)
 {
 	struct sk_msg *msg, *tmp;
 
-- 
2.25.1

