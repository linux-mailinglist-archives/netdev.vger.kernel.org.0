Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22B7D1FC32A
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 03:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbgFQBE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 21:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726568AbgFQBEY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 21:04:24 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D97CC0613EF
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 18:04:23 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id i82so585532qke.10
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 18:04:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=2CrLirlaHAmpJk5kLUn85BP1eGSiGI6fSEUxktNV0QA=;
        b=ZVhBtc1w6d4rwoHbUdHbgpZ8HX+pGtyWu4h6+apBtM0FLFC8vviz+NpS3PgZm+v3If
         /NZJxDHy8DNIfJQnKbL6lIjVUFGxAI9LkCyj+2TuyXvzBO+gS6r4IX9fUzRWECdMUQqJ
         AkejeV0e0036IjqKExSfZprBvKMU/4nwEwzQH8L7FelmJFMUNVDrrl0aJluZTaeifv6F
         2SBn+GqFJ80v+e6vSA1rzE2P79TKo5QJgtBabdWI8kg6SeSZ6RMjXpeSjEMy+PIbgGyT
         Ko6o9LygqpTG0OH1pmOplaLc0tqDdaARTlHySh3GF4yEWU0HDWutzNYbVXRsohB9zKei
         GFDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=2CrLirlaHAmpJk5kLUn85BP1eGSiGI6fSEUxktNV0QA=;
        b=LZ25ZE+VAeU6uZ42egXoH23Daq2DAMjwAAufeCxLDM0ASt17xdndvwy89/E0X0FvIf
         f9W7XDY5ryyVEMVWpLWB3WE0bTMCHaE3ChhRvGvYeeX5aTunCZdxav8f0IEWSyvRDsPz
         eF4/JWF9IID5tlzJ8ShevcT+3rqLuFKZk0JqYmYP/h6BZ6d2PZ5329r1DgG+ddtU853K
         79yFR3S7uCUuWZfrnoZ3rv2V1utux5L7DoffvK0x0SHc4juSg9HzQGwvRYM7PBrdrmVn
         7MKyjy5Tp34W3k4gxP2VsdrmS7g5XEQ4nKjCFgzhLOJm1he0UupO3ZaiZ0BFHqysEIwK
         F9qQ==
X-Gm-Message-State: AOAM530DE0nxzA50YN2Zlr9p1/Lfrj5Tu+eXfhX9Z+M1InDD/x72NsV6
        GAFaaEc0zIQc+sY63nDDQ9BCkWPgYjiYCcgkZP+GVDw5N8tGOfAwSfp6QmqsBBIdmynwd1ko218
        O1pdmroTENpie/bOdOfQLUIMAMJiUKAJVKuh/Lkmv4TTy/RIc4o0vtg==
X-Google-Smtp-Source: ABdhPJwIdK30fqgjFPehn3672rL1ww9JBMgZJdErUkcgVnk9eCXsg4LZ2AZ4olVtymRGg1FM0Hw4LcA=
X-Received: by 2002:ad4:556e:: with SMTP id w14mr5112805qvy.137.1592355862157;
 Tue, 16 Jun 2020 18:04:22 -0700 (PDT)
Date:   Tue, 16 Jun 2020 18:04:16 -0700
In-Reply-To: <20200617010416.93086-1-sdf@google.com>
Message-Id: <20200617010416.93086-3-sdf@google.com>
Mime-Version: 1.0
References: <20200617010416.93086-1-sdf@google.com>
X-Mailer: git-send-email 2.27.0.290.gba653c62da-goog
Subject: [PATCH bpf v5 3/3] bpf: document optval > PAGE_SIZE behavior for
 sockopt hooks
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend existing doc with more details about requiring ctx->optlen = 0
for handling optval > PAGE_SIZE.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 Documentation/bpf/prog_cgroup_sockopt.rst | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/Documentation/bpf/prog_cgroup_sockopt.rst b/Documentation/bpf/prog_cgroup_sockopt.rst
index c47d974629ae..172f957204bf 100644
--- a/Documentation/bpf/prog_cgroup_sockopt.rst
+++ b/Documentation/bpf/prog_cgroup_sockopt.rst
@@ -86,6 +86,20 @@ then the next program in the chain (A) will see those changes,
 *not* the original input ``setsockopt`` arguments. The potentially
 modified values will be then passed down to the kernel.
 
+Large optval
+============
+When the ``optval`` is greater than the ``PAGE_SIZE``, the BPF program
+can access only the first ``PAGE_SIZE`` of that data. So it has to options:
+
+* Set ``optlen`` to zero, which indicates that the kernel should
+  use the original buffer from the userspace. Any modifications
+  done by the BPF program to the ``optval`` are ignored.
+* Set ``optlen`` to the value less than ``PAGE_SIZE``, which
+  indicates that the kernel should use BPF's trimmed ``optval``.
+
+When the BPF program returns with the ``optlen`` greater than
+``PAGE_SIZE``, the userspace will receive ``EFAULT`` errno.
+
 Example
 =======
 
-- 
2.27.0.290.gba653c62da-goog

