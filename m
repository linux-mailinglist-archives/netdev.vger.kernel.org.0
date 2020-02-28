Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0E6517368F
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 12:54:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbgB1Lyt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 06:54:49 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46628 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726918AbgB1Lys (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 06:54:48 -0500
Received: by mail-wr1-f67.google.com with SMTP id j7so2563017wrp.13
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 03:54:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=olVifyTMleE2iedo0uCkocgafSknigkP2OP2Ek8xo9Y=;
        b=lsd7u/wbZ+WEtU7Zu/blNg6YCQE6j6PcKMK7Ynz/VrYdm9MpeXcL47A6XPJZSubLI8
         B72tsfM8iIGm2DikmdXwYByhjVNC7eaK7VTQmdfXwCVqaK4gJn8e0jfHBD0Jjp3mi6Hb
         pOR5x6Xgg2B22tFcttYzzEEMY9hb0e6CI7Vg4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=olVifyTMleE2iedo0uCkocgafSknigkP2OP2Ek8xo9Y=;
        b=bPOuYsOqw1zeTd5oos3/Nq9GNrRO8bAodX9ulp2OqUqoKwEvVfw69cZRRc/JQrySXK
         umIAAPM/w1z1XPb+bFS3IBuwwNGA7aQVk7JfNpCBi0JAorA+IMNjf6EON44ItGiqvSoU
         vu1888IOaxZlK/k8OaQDtJviFi5Q4v9+79QNUgzcBlodn/hEvd9qkK2VhHpIqRi5+QWQ
         4qPGl8C8n28Y8ccXl1xvKb5J+s228YfqNpmAXrZBO+Y75oNyYw7j8zOVDdBH/i1RM76u
         4gkUiNpd06jf17grj7+dRUuDEh647Nfn1tFnjPAdi+N0yPS6pudyIG5xOxH+7zPHwnHI
         0JCA==
X-Gm-Message-State: APjAAAWvp7PB504g7teB7NiMZCL7VpbnS6ulq/4efnVRTebzLEabkU63
        Kkv0j2mFbPZkBaH9ib5O+svONA==
X-Google-Smtp-Source: APXvYqxJOCIBurk6Jls7sZVmorMG3mSVBtjX2iT3L6h2322sJJpOuLtQdNYKQUfCqV/GYafskYxluA==
X-Received: by 2002:adf:ebca:: with SMTP id v10mr4553098wrn.307.1582890887425;
        Fri, 28 Feb 2020 03:54:47 -0800 (PST)
Received: from antares.lan (b.2.d.a.1.b.1.b.2.c.5.e.0.3.d.4.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:4d30:e5c2:b1b1:ad2b])
        by smtp.gmail.com with ESMTPSA id q125sm2044284wme.19.2020.02.28.03.54.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 03:54:46 -0800 (PST)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     john.fastabend@gmail.com, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v2 8/9] selftests: bpf: enable UDP sockmap reuseport tests
Date:   Fri, 28 Feb 2020 11:53:43 +0000
Message-Id: <20200228115344.17742-9-lmb@cloudflare.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200228115344.17742-1-lmb@cloudflare.com>
References: <20200228115344.17742-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the guard that disables UDP tests now that sockmap
has support for them.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 tools/testing/selftests/bpf/prog_tests/select_reuseport.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/select_reuseport.c b/tools/testing/selftests/bpf/prog_tests/select_reuseport.c
index a1dd13b34d4b..821b4146b7b6 100644
--- a/tools/testing/selftests/bpf/prog_tests/select_reuseport.c
+++ b/tools/testing/selftests/bpf/prog_tests/select_reuseport.c
@@ -805,12 +805,6 @@ static void test_config(int sotype, sa_family_t family, bool inany)
 	char s[MAX_TEST_NAME];
 	const struct test *t;
 
-	/* SOCKMAP/SOCKHASH don't support UDP yet */
-	if (sotype == SOCK_DGRAM &&
-	    (inner_map_type == BPF_MAP_TYPE_SOCKMAP ||
-	     inner_map_type == BPF_MAP_TYPE_SOCKHASH))
-		return;
-
 	for (t = tests; t < tests + ARRAY_SIZE(tests); t++) {
 		if (t->need_sotype && t->need_sotype != sotype)
 			continue; /* test not compatible with socket type */
-- 
2.20.1

