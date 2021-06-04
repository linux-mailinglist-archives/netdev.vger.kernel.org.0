Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B633D39B29F
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 08:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbhFDGeU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 02:34:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbhFDGeR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 02:34:17 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37411C06174A;
        Thu,  3 Jun 2021 23:32:32 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id r1so7053598pgk.8;
        Thu, 03 Jun 2021 23:32:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=utBE6t+L3cLZyqbBDSJJ7b7TIbKF6w8BoOa9Pvg4Aec=;
        b=WfcucwrV9ZSwi5Tnk9yPkJURQLFpxn81xB6s6C5EBoWheIjs7NLPw7iANfThmKRqNW
         aqIj84MqCBp4/rMPCI+kFQoCJpdeGNDGRAnU/XNNCqqCjjFI+raWu7RbIH9sqTg+7/i4
         3GgZFj7rjsHTJcfggd8xHdz8pVaO1kgyK90jcuJu9TxeZBzgzpHsRzWADpeTwVDMJEM4
         lhIWYG2Lo/oW6fLMeHO4VwJG3+Q6jRUT8olSsWVAtWTAuzcNhIv2Ba+Hx7UTYOQxMbU7
         4MYJ8y7y2ynK7WNGi6WQ59siCD4T9LzvVyDA2P5asFlnQvWdYX+buwLlY+C14IWKiqTj
         9sxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=utBE6t+L3cLZyqbBDSJJ7b7TIbKF6w8BoOa9Pvg4Aec=;
        b=SC1v4PB0mJjKkOSUn+v2jy2oNTthojZvRwgXj6dVkv1rcuRrRu1v/immwHAJ4Nu4hq
         wEf7wRDNAe+Q/VJn+Vc+h/cp/y7ShMeQJCwHL9TdtNO0kKpmKICII2RCLFmM0GOOFkR3
         CBy0olofolSxsWPGeLvjkA1uw6LOKl2sqI6c/R/uw47c5NKzm8vRQ1kLIptoEt/E9vTs
         D0vl4QFSIq5+r1uA/CrY2MqT0vsPBHtBH7W5UzjFWe1XIhYBkC/zwFjHu9VOLEjW90wB
         RhMN17mgmCrroglS2BUSqR1TmkOmVHbleyAoYaKXDtMsARwfxIzZVSXBK9zczyA8pXoO
         YJJA==
X-Gm-Message-State: AOAM532r19lJGTaDc//EwCGC9/V28V1+1//NgLWHWoKyHp0Fy9pzOAAV
        E3lEg9rJWEDYo+aIkJybHm6tKMPGW0Y=
X-Google-Smtp-Source: ABdhPJy4HgWFInYRSoDvm4cjYzITF7WQM+J6FJWqGzb2oEFWSomxYwRAVC5RJV3AW5/HQhotJrAhvA==
X-Received: by 2002:aa7:99c9:0:b029:2e9:e084:e1de with SMTP id v9-20020aa799c90000b02902e9e084e1demr3090207pfi.80.1622788349912;
        Thu, 03 Jun 2021 23:32:29 -0700 (PDT)
Received: from localhost ([2402:3a80:11cb:b599:c759:2079:3ef5:1764])
        by smtp.gmail.com with ESMTPSA id t19sm927431pfg.70.2021.06.03.23.32.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 23:32:29 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v2 2/7] bpf: export bpf_link functions for modules
Date:   Fri,  4 Jun 2021 12:01:11 +0530
Message-Id: <20210604063116.234316-3-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210604063116.234316-1-memxor@gmail.com>
References: <20210604063116.234316-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are required in a subsequent patch to implement the bpf_link
command for cls_bpf. Since the bpf_link object is tied to the
cls_bpf_prog object, it has to be initialized and managed from inside
the module.

Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>.
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 kernel/bpf/syscall.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 50457019da27..e5934b748ced 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2338,6 +2338,7 @@ void bpf_link_init(struct bpf_link *link, enum bpf_link_type type,
 	link->ops = ops;
 	link->prog = prog;
 }
+EXPORT_SYMBOL_GPL(bpf_link_init);
 
 static void bpf_link_free_id(int id)
 {
@@ -2363,6 +2364,7 @@ void bpf_link_cleanup(struct bpf_link_primer *primer)
 	fput(primer->file);
 	put_unused_fd(primer->fd);
 }
+EXPORT_SYMBOL_GPL(bpf_link_cleanup);
 
 void bpf_link_inc(struct bpf_link *link)
 {
@@ -2510,6 +2512,7 @@ int bpf_link_prime(struct bpf_link *link, struct bpf_link_primer *primer)
 	primer->id = id;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(bpf_link_prime);
 
 int bpf_link_settle(struct bpf_link_primer *primer)
 {
@@ -2522,6 +2525,7 @@ int bpf_link_settle(struct bpf_link_primer *primer)
 	/* pass through installed FD */
 	return primer->fd;
 }
+EXPORT_SYMBOL_GPL(bpf_link_settle);
 
 int bpf_link_new_fd(struct bpf_link *link)
 {
-- 
2.31.1

