Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88F9422EAAC
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 13:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728032AbgG0LFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 07:05:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726357AbgG0LFR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 07:05:17 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B56DC061794
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 04:05:17 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id t15so9170059pjq.5
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 04:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PjNHVM1Ra9PTPk0mluRn7/Mx4maTlYGz8uJqYJXNj5E=;
        b=pqrRTeMf4XufqAmxbA+UCfG5zx6Sq4a9T6rOgm2yk+BAypi0FhmfZ+ZQreI5cAkwXp
         U3poaKMP+lTeSvEhR8aD5WDEBuraEBnUANLGzsLjEuSUgE+7llHK2eLG77zAMH+ds3G/
         AqVVouVzB1CtFqARtt/mp0MrEVh4T3+v58tkUteg+Ks4bKKS1jTdwzOooX265CN5e3Fd
         6kQKRG3wc677y4PGQ9kkXkbVdI4KlNssq9Ihn9wcIzNlyszngoBXEGdoW2hhnkscfHu+
         RTqmi4HQKaqbf6IBRz0gDjrBgTfRPXkSQeBWOqDb7LlosIM12KvJo0PLDTn4Y8weIvNQ
         YHRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PjNHVM1Ra9PTPk0mluRn7/Mx4maTlYGz8uJqYJXNj5E=;
        b=bE+6Vdqt/iQu32XLRyYSHburM7punjXdSpj5kgfUh5kYx5wqQcpZhdSPSFx8XQRwHq
         jC5bX+VuVP49cv4Dd7lATBzFqozX2q6R9zKdyLfj0mfO/gfOs1B+bX+SVTm4glHd22TJ
         Eu+22hqkdplWJBpjlpuGnoJrTIixDHQ/yZk9RBP/sQJ8hPCr/qJc+CrN4ftyCLrwZbHM
         I8Rlnc6EOWdlCAkaysFzZIVhH4hcuPqmNBdv4yTkXu4uliIs0r9zL43Rdw1V5eBooJ/i
         txRCqpPzJTwM25u/lpkdtoMZRhMNmSmN2DjdbIt5gKLlm+IEXuu6DjdI2f/Y6wEBX2yT
         /A4Q==
X-Gm-Message-State: AOAM530cO4j9ygdq0OXvvvh5Hfp9LKZrTU7luut6Ld3cfvs4x4WP1M9t
        3O3O2iz1xgq+E04spZAfDeD0u8LPKsvXrA==
X-Google-Smtp-Source: ABdhPJwC5NQ9KhLm5k/hqMYOrx/Ru63AQO/ZYDr2YnoaY+h+4Zzm0M1Rut94MaD4W1Kaz26llrzmzQ==
X-Received: by 2002:a17:902:d881:: with SMTP id b1mr17995161plz.74.1595847912891;
        Mon, 27 Jul 2020 04:05:12 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w71sm15079921pfd.6.2020.07.27.04.05.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2020 04:05:12 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net] selftests/bpf: fix netdevsim trap_flow_action_cookie read
Date:   Mon, 27 Jul 2020 19:04:55 +0800
Message-Id: <20200727110455.2969281-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When read netdevsim trap_flow_action_cookie, we need to init it first,
or we will get "Invalid argument" error.

Fixes: d3cbb907ae57 ("netdevsim: add ACL trap reporting cookie as a metadata")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tools/testing/selftests/bpf/test_offload.py | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_offload.py b/tools/testing/selftests/bpf/test_offload.py
index 8294ae3ffb3c..43c9cda199b8 100755
--- a/tools/testing/selftests/bpf/test_offload.py
+++ b/tools/testing/selftests/bpf/test_offload.py
@@ -318,6 +318,9 @@ class DebugfsDir:
                 continue
 
             if os.path.isfile(p):
+                # We need to init trap_flow_action_cookie before read it
+                if f == "trap_flow_action_cookie":
+                    cmd('echo deadbeef > %s/%s' % (path, f))
                 _, out = cmd('cat %s/%s' % (path, f))
                 dfs[f] = out.strip()
             elif os.path.isdir(p):
-- 
2.25.4

