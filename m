Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E69219686C
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 19:29:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727191AbgC1S3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 14:29:06 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:34747 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726937AbgC1S3G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Mar 2020 14:29:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585420144;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hYSqmuaRDZY8LPKqio3R9216Ik7EBk2kKqinMFHjJq0=;
        b=Y4FQYZuDRrVpbgjnMoVxTevaoMHtnU679cDlfkSUqp8VngK2Gc2U1xsxck6T/g6uCfw7kl
        NSk8Om6Xf6/uADN3oLFkZWO4Z2oLppUB4Nok/jVrWLQQcq5jDGRHLZFJBdP8QRM6h+aunQ
        67q7tiF+RTB0fIaFw9V9DBtm6FSWqmM=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-305-GAN8H2yCPbK1nAIOzkWb7Q-1; Sat, 28 Mar 2020 14:29:03 -0400
X-MC-Unique: GAN8H2yCPbK1nAIOzkWb7Q-1
Received: by mail-lf1-f71.google.com with SMTP id r20so891852lfm.7
        for <netdev@vger.kernel.org>; Sat, 28 Mar 2020 11:29:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hYSqmuaRDZY8LPKqio3R9216Ik7EBk2kKqinMFHjJq0=;
        b=X5m6S58BrHnT124IWQr9p/QpMzoMIUrAB8kFBzNSjoE+VsA7ACtCJhR+P9KUInsnwn
         bfhcAiE9Z8WZNBD6o+AHgHbrMIKCbttbakHGJ/emdL9qaFxNVxXSkitomWTaXxM0quQO
         I4wKMefq3gUZopFqZJb4HdA2mXYrfdMesANo+Yih0bq3jVVABPuXmofPE4QQAo+L61Tp
         r6YDlU6WMVXkqg8yyjbuh0ay+GqFGD2vMlimsqMN25epQvodx0aL0qqqaEXk05iihQEw
         OAdBRx6agIGzJYtCzE1Sn0OVJwA7Khvvbl/cRXZiOkw085ZDzeq8xuXMeK+/Uu4jXAYt
         7cVg==
X-Gm-Message-State: AGi0PuZUUv7udsFEyV/HGgejyRcqBA3iN7oDx4NRkbbvwE1gXMoQAQIL
        iCbS0bu/vGWUCEHuZAHQG5YdpbdwT28+s90UaueGJBWTxt/FJ2R8R32ISQ9FaZfRAVYxylElRmr
        DJUeyBbMS2YalN8rN
X-Received: by 2002:a2e:6c03:: with SMTP id h3mr2917846ljc.8.1585420141537;
        Sat, 28 Mar 2020 11:29:01 -0700 (PDT)
X-Google-Smtp-Source: APiQypKHOEzeZ7hV+Gj4lYVfq2facxAuNmCjy9eiGYXqZuHCSHupnzBHBoRbDIre8DGJlqob32Z6Bg==
X-Received: by 2002:a2e:6c03:: with SMTP id h3mr2917838ljc.8.1585420141361;
        Sat, 28 Mar 2020 11:29:01 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id 8sm3543324lfk.64.2020.03.28.11.29.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Mar 2020 11:29:00 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 3CA5318158B; Sat, 28 Mar 2020 19:29:00 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     daniel@iogearbox.net, ast@fb.com
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Subject: [PATCH v3 2/2] selftests: Add test for overriding global data value before load
Date:   Sat, 28 Mar 2020 19:28:34 +0100
Message-Id: <20200328182834.196578-2-toke@redhat.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200327125818.155522-1-toke@redhat.com>
References: <20200327125818.155522-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This extends the global_data test to also exercise the new
bpf_map__set_initial_value() function. The test simply overrides the global
data section with all zeroes, and checks that the new value makes it into
the kernel map on load.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 .../selftests/bpf/prog_tests/global_data.c    | 61 +++++++++++++++++++
 1 file changed, 61 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/global_data.c b/tools/testing/selftests/bpf/prog_tests/global_data.c
index c680926fce73..f018ce53a8d1 100644
--- a/tools/testing/selftests/bpf/prog_tests/global_data.c
+++ b/tools/testing/selftests/bpf/prog_tests/global_data.c
@@ -121,6 +121,65 @@ static void test_global_data_rdonly(struct bpf_object *obj, __u32 duration)
 	      "err %d errno %d\n", err, errno);
 }
 
+static void test_global_data_set_rdonly(__u32 duration)
+{
+	const char *file = "./test_global_data.o";
+	int err = -ENOMEM, map_fd, zero = 0;
+	__u8 *buff = NULL, *newval = NULL;
+	struct bpf_program *prog;
+	struct bpf_object *obj;
+	struct bpf_map *map;
+	size_t sz;
+
+	obj = bpf_object__open_file(file, NULL);
+	if (CHECK_FAIL(!obj))
+		return;
+	prog = bpf_program__next(NULL, obj);
+	if (CHECK_FAIL(!prog))
+		goto out;
+	err = bpf_program__set_sched_cls(prog);
+	if (CHECK_FAIL(err))
+		goto out;
+
+	map = bpf_object__find_map_by_name(obj, "test_glo.rodata");
+	if (CHECK_FAIL(!map || !bpf_map__is_internal(map)))
+		goto out;
+
+	sz = bpf_map__def(map)->value_size;
+	newval = malloc(sz);
+	if (CHECK_FAIL(!newval))
+		goto out;
+	memset(newval, 0, sz);
+
+	/* wrong size, should fail */
+	err = bpf_map__set_initial_value(map, newval, sz - 1);
+	if (CHECK(!err, "reject set initial value wrong size", "err %d\n", err))
+		goto out;
+
+	err = bpf_map__set_initial_value(map, newval, sz);
+	if (CHECK_FAIL(err))
+		goto out;
+
+	err = bpf_object__load(obj);
+	if (CHECK_FAIL(err))
+		goto out;
+
+	map_fd = bpf_map__fd(map);
+	if (CHECK_FAIL(map_fd < 0))
+		goto out;
+
+	buff = malloc(sz);
+	if (buff)
+		err = bpf_map_lookup_elem(map_fd, &zero, buff);
+	CHECK(!buff || err || memcmp(buff, newval, sz),
+	      "compare .rodata map data override",
+	      "err %d errno %d\n", err, errno);
+out:
+	free(buff);
+	free(newval);
+	bpf_object__close(obj);
+}
+
 void test_global_data(void)
 {
 	const char *file = "./test_global_data.o";
@@ -144,4 +203,6 @@ void test_global_data(void)
 	test_global_data_rdonly(obj, duration);
 
 	bpf_object__close(obj);
+
+	test_global_data_set_rdonly(duration);
 }
-- 
2.26.0

