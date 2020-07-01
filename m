Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6235421141D
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 22:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbgGAUNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 16:13:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727082AbgGAUNQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 16:13:16 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C77DEC08C5DB
        for <netdev@vger.kernel.org>; Wed,  1 Jul 2020 13:13:15 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id s9so27365770ybj.18
        for <netdev@vger.kernel.org>; Wed, 01 Jul 2020 13:13:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=i6gJyiIxYw3Mhy0FXom58Ey1CcFrWZFXEjpF7LY96KI=;
        b=oMaPlUn9w3Drti1hkWqPDJfHfosD8TdQP1j5/C7ZDcZxHCFiFIeNb5mNwXjzlNw9mZ
         L8EXTFXn2OUW0VLsKkjOjRj8qYryygMfyNXAxJCmGupKStqkSWjaBvRwru020dOB3JFJ
         Bflp4gfjelZbVhClCxKE6K3VaZr8oysMU7/iljso+gc8VzTJctjVuaY2g/lLe1wwBRtX
         4qGFXl8FNu0Ne+trUwv4eWMS+F3mu1UrUMh/ltLtmOHf7ZnG5Nezni5ipgvdLd0EeXrk
         7fiXfdpz09NYFprMf46BzmnZpoMcerhXBdGrtgRNTbFhwl0FsnLpuEYA/Etgrbu5DW/k
         5s7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=i6gJyiIxYw3Mhy0FXom58Ey1CcFrWZFXEjpF7LY96KI=;
        b=I6QoaGnvfPeJotdfz6OBpzsKBgNjVdE5EksvZ/Wfkf+RekoUU5KAmZSbpj9bruOJJC
         OR6xK34qcWPx7Yyj1wpBp9iaONEQARsmIJLzZkzZvpYiaxp9EfVf8Fb/JKKAbW7qtnGZ
         tOxZMhqS9YRM+6mDWAn4reHa5T1+Ar6wusBjbS/S7oxt/XD3YFit/IK0Mxakf4giampl
         1Yl61544TMDKqt/Tqf4D27zcxbzjkK/GG6azO6WCMd7tIhrn1GUVKJNnRAM0Ujfe2w1C
         4EnRSRW75wWSTih0Qj0ehpUZZPHBdhNOAgXMPrKvtX6+eWEynj4VLNBxJiCyl/cfTu4V
         Iq8Q==
X-Gm-Message-State: AOAM532ZxwPLp8MJREuasE+i/5yIUXmQ/juowxFa3v6zjohLESziYfeU
        TtBdZzIfnRWvGavc7+CUurHe5EJixnctkTSbF5jGOx6lZHpAximJatF6oSVVfBfAbzTHLJ67DCG
        Sr5M40/KV29lAeCNATQ66xc7CpvGb3p8R4sXGxuwSdkxKo1kZJKQQYg==
X-Google-Smtp-Source: ABdhPJyzLFeUucBVyixZXQtS+WX38VhzapIV0jvyJ5BCvGLslz1afjYtPuf7rTszC3nmDXsBql0QdKo=
X-Received: by 2002:a05:6902:4a2:: with SMTP id r2mr46048265ybs.176.1593634395023;
 Wed, 01 Jul 2020 13:13:15 -0700 (PDT)
Date:   Wed,  1 Jul 2020 13:13:06 -0700
In-Reply-To: <20200701201307.855717-1-sdf@google.com>
Message-Id: <20200701201307.855717-4-sdf@google.com>
Mime-Version: 1.0
References: <20200701201307.855717-1-sdf@google.com>
X-Mailer: git-send-email 2.27.0.212.ge8ba1cc988-goog
Subject: [PATCH bpf-next v3 3/4] bpftool: add support for BPF_CGROUP_INET_SOCK_RELEASE
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support attaching to BPF_CGROUP_INET_SOCK_RELEASE and properly
display attach type upon prog dump.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/bpf/bpftool/common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
index 18e5604fe260..29f4e7611ae8 100644
--- a/tools/bpf/bpftool/common.c
+++ b/tools/bpf/bpftool/common.c
@@ -33,6 +33,7 @@ const char * const attach_type_name[__MAX_BPF_ATTACH_TYPE] = {
 	[BPF_CGROUP_INET_INGRESS]	= "ingress",
 	[BPF_CGROUP_INET_EGRESS]	= "egress",
 	[BPF_CGROUP_INET_SOCK_CREATE]	= "sock_create",
+	[BPF_CGROUP_INET_SOCK_RELEASE]	= "sock_release",
 	[BPF_CGROUP_SOCK_OPS]		= "sock_ops",
 	[BPF_CGROUP_DEVICE]		= "device",
 	[BPF_CGROUP_INET4_BIND]		= "bind4",
-- 
2.27.0.212.ge8ba1cc988-goog

