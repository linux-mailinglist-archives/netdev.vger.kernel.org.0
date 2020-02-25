Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D62216C2EB
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 14:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730490AbgBYN4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 08:56:55 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51218 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730491AbgBYN4v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 08:56:51 -0500
Received: by mail-wm1-f68.google.com with SMTP id t23so3102885wmi.1
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 05:56:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tdUpExQ3hzj21QBKAtvqnsJNrL5zKnYkhtRdt8iWk7k=;
        b=s5u3MDHXfeJEdDUkFi2tRNaJM12+acezT/J5c/Y0dUXkBOk/Z9YD1zJLa8EIPBuT6B
         7h7PRy4x1vohUccQmHB+TwhLO9VWNXD0fiWJOJKZU1nlmtsRs+w7A2QaomMVn+NiNi3u
         6GoTma0klKIR0YB8fQI4/PbM1mqrws28FonEQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tdUpExQ3hzj21QBKAtvqnsJNrL5zKnYkhtRdt8iWk7k=;
        b=ooILkXqvHbAE0u5vtWTusne/Dt2bRprDAMwglMZAaR020GPdlRG2dGftf0Y9z+grdy
         irilrgO7lT1t4tj+/Nwc6R5XRX5ffQAbd+NDJuHsOPYcBubfw7+TCaP+8EJlKPgiqNGA
         ILjxmck7t3CAtxeceaJVfXfVMq+M/0xejxFA/vI088TnLaDsTVBZxpsCa1hz+C9anNr2
         nXLxV6FsJt2w4vkKQ/s31x3WOlbRE8iDKk5rX4F0a4F9ernB1lKeDVGjSSNl2yRrkQB7
         IYhLbrzRz+U/xg2XZ8dOGReCthxjF4efCOEP4NujTBFdZ8TyamWMx6mHUCKp6VvkzDr2
         VlEQ==
X-Gm-Message-State: APjAAAWHxDB+70puQsfSlOSEuYQqG55vq7cyZLSwbGN7uELctIJo4kT2
        mMLfbN1rDFExqqAGbUaeO1OIXA==
X-Google-Smtp-Source: APXvYqwmAujwCf7IqxSUcZ5V29CAKHVHg254H8PhRtUSEgNxQ9uaMCXdJUMj69n1j+nAigX8UVaXsg==
X-Received: by 2002:a7b:c450:: with SMTP id l16mr5662485wmi.31.1582639009440;
        Tue, 25 Feb 2020 05:56:49 -0800 (PST)
Received: from localhost.localdomain ([2a06:98c0:1000:8800:3dea:15ba:1870:8e94])
        by smtp.gmail.com with ESMTPSA id t128sm4463580wmf.28.2020.02.25.05.56.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 05:56:48 -0800 (PST)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     ast@kernel.org, daniel@iogearbox.net, john.fastabend@gmail.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH bpf-next 7/7] selftests: bpf: enable UDP sockmap reuseport tests
Date:   Tue, 25 Feb 2020 13:56:36 +0000
Message-Id: <20200225135636.5768-8-lmb@cloudflare.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200225135636.5768-1-lmb@cloudflare.com>
References: <20200225135636.5768-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the guard that disables UDP tests now that sockmap has support for them.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 tools/testing/selftests/bpf/prog_tests/select_reuseport.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/select_reuseport.c b/tools/testing/selftests/bpf/prog_tests/select_reuseport.c
index 68d452bb9fd9..4c09766344a4 100644
--- a/tools/testing/selftests/bpf/prog_tests/select_reuseport.c
+++ b/tools/testing/selftests/bpf/prog_tests/select_reuseport.c
@@ -816,13 +816,6 @@ static void test_config(int sotype, sa_family_t family, bool inany)
 		if (!test__start_subtest(s))
 			continue;
 
-		if (sotype == SOCK_DGRAM &&
-		    inner_map_type != BPF_MAP_TYPE_REUSEPORT_SOCKARRAY) {
-			/* SOCKMAP/SOCKHASH don't support UDP yet */
-			test__skip();
-			continue;
-		}
-
 		setup_per_test(sotype, family, inany, t->no_inner_map);
 		t->fn(sotype, family);
 		cleanup_per_test(t->no_inner_map);
-- 
2.20.1

