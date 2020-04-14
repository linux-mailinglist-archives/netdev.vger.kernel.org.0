Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D1941A8065
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 16:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405198AbgDNOvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 10:51:03 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:37824 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2405178AbgDNOuz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 10:50:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586875854;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qas9IDv0IanBfBR3+cuIT1ShihbtlWQOnUZBpc9zZPY=;
        b=e/7aa4AvYtSlnXsjcZOs1yQEgws4fwaqP4tRTkGSdNrGrMWYcA3ZVhea9+HnoPDq2jTv12
        SoQLwqIpSLLWNK2W2Ah+mRYH4dXUkRTBzwFFSAASWgtQOAu+KfwNpofM0YvfLmqUglblGK
        d/BtZFYZfznrAtd5kvP+1rj1tCjlsFs=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-403-3QQiEX8iPdmmpqZ3HrjsZw-1; Tue, 14 Apr 2020 10:50:52 -0400
X-MC-Unique: 3QQiEX8iPdmmpqZ3HrjsZw-1
Received: by mail-lf1-f69.google.com with SMTP id v7so11934lfq.11
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 07:50:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Qas9IDv0IanBfBR3+cuIT1ShihbtlWQOnUZBpc9zZPY=;
        b=gOHrz0iPP5+66KTofyKapsku4ATHNMlLf3Fq8OvsV8cy0Wht5y2BM/zFzB8aj7vRUN
         dxPiG0JHF+Q4RN80O7sVi94yFDOl2d9lD1KXqIPVVnobRqzTlwR1H2ZCTo06Coe1M1f6
         yH8pBUTkGgtCVq3O2pCx7oTTkP5bvPX2zwwy2/81jcBF1TyLqocfUzbg8OQEILf0sPfx
         2cXcIkFyNf6BUpgPyciwQ7Q7OnbjX0qsfaKOXLNQxX6l7bLEBqkaKdl4L+Bh4IlNGDyY
         0Y7vQRASUcec3Dzip967erQv2JICqhrKVc78T0OBhkY6Ks1BebQUFGsp/U3R2diCAX2c
         glsA==
X-Gm-Message-State: AGi0PuYW8gP7M7MGhDW3safJ4hz5/40HG0qr6Qwl/lsWf4w3IV/k6WIy
        r9AOQmBRpVH7mtwhVUEuogkxJnhy+tMjTV50hNt7HjM36qgDGd29V1mo7fo1okSfKlrEVeX16jh
        95KyjfJVRbHCPYlWO
X-Received: by 2002:ac2:53a6:: with SMTP id j6mr114359lfh.153.1586875850956;
        Tue, 14 Apr 2020 07:50:50 -0700 (PDT)
X-Google-Smtp-Source: APiQypKsGCtiiZLwKMk2RBKmLg00tz+VAhg0Td+rbm+i9E6y6VOSDGr84vJFZ+WnKvP60w+ORFx+Jg==
X-Received: by 2002:ac2:53a6:: with SMTP id j6mr114346lfh.153.1586875850728;
        Tue, 14 Apr 2020 07:50:50 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id z23sm9414603ljh.55.2020.04.14.07.50.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2020 07:50:49 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 52438181587; Tue, 14 Apr 2020 16:50:49 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     daniel@iogearbox.net, ast@fb.com
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH bpf 2/2] selftests/bpf: Check for correct program attach/detach in xdp_attach test
Date:   Tue, 14 Apr 2020 16:50:25 +0200
Message-Id: <20200414145025.182163-2-toke@redhat.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200414145025.182163-1-toke@redhat.com>
References: <20200414145025.182163-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern noticed that there was a bug in the EXPECTED_FD code so
programs did not get detached properly when that parameter was supplied.
This case was not included in the xdp_attach tests; so let's add it to be
sure that such a bug does not sneak back in down.

Fixes: 87854a0b57b3 ("selftests/bpf: Add tests for attaching XDP programs")
Reported-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 .../selftests/bpf/prog_tests/xdp_attach.c     | 30 ++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_attach.c b/tools/testing/selftests/bpf/prog_tests/xdp_attach.c
index 05b294d6b923..15ef3531483e 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_attach.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_attach.c
@@ -6,19 +6,34 @@
 
 void test_xdp_attach(void)
 {
+	__u32 duration = 0, id1, id2, id0 = 0, len;
 	struct bpf_object *obj1, *obj2, *obj3;
 	const char *file = "./test_xdp.o";
+	struct bpf_prog_info info = {};
 	int err, fd1, fd2, fd3;
-	__u32 duration = 0;
 	DECLARE_LIBBPF_OPTS(bpf_xdp_set_link_opts, opts,
 			    .old_fd = -1);
 
+	len = sizeof(info);
+
 	err = bpf_prog_load(file, BPF_PROG_TYPE_XDP, &obj1, &fd1);
 	if (CHECK_FAIL(err))
 		return;
+	err = bpf_obj_get_info_by_fd(fd1, &info, &len);
+	if (CHECK_FAIL(err))
+		goto out_1;
+	id1 = info.id;
+
 	err = bpf_prog_load(file, BPF_PROG_TYPE_XDP, &obj2, &fd2);
 	if (CHECK_FAIL(err))
 		goto out_1;
+
+	memset(&info, 0, sizeof(info));
+	err = bpf_obj_get_info_by_fd(fd2, &info, &len);
+	if (CHECK_FAIL(err))
+		goto out_2;
+	id2 = info.id;
+
 	err = bpf_prog_load(file, BPF_PROG_TYPE_XDP, &obj3, &fd3);
 	if (CHECK_FAIL(err))
 		goto out_2;
@@ -28,6 +43,11 @@ void test_xdp_attach(void)
 	if (CHECK(err, "load_ok", "initial load failed"))
 		goto out_close;
 
+	err = bpf_get_link_xdp_id(IFINDEX_LO, &id0, 0);
+	if (CHECK(err || id0 != id1, "id1_check",
+		  "loaded prog id %u != id1 %u, err %d", id0, id1, err))
+		goto out_close;
+
 	err = bpf_set_link_xdp_fd_opts(IFINDEX_LO, fd2, XDP_FLAGS_REPLACE,
 				       &opts);
 	if (CHECK(!err, "load_fail", "load with expected id didn't fail"))
@@ -37,6 +57,10 @@ void test_xdp_attach(void)
 	err = bpf_set_link_xdp_fd_opts(IFINDEX_LO, fd2, 0, &opts);
 	if (CHECK(err, "replace_ok", "replace valid old_fd failed"))
 		goto out;
+	err = bpf_get_link_xdp_id(IFINDEX_LO, &id0, 0);
+	if (CHECK(err || id0 != id2, "id2_check",
+		  "loaded prog id %u != id2 %u, err %d", id0, id2, err))
+		goto out_close;
 
 	err = bpf_set_link_xdp_fd_opts(IFINDEX_LO, fd3, 0, &opts);
 	if (CHECK(!err, "replace_fail", "replace invalid old_fd didn't fail"))
@@ -51,6 +75,10 @@ void test_xdp_attach(void)
 	if (CHECK(err, "remove_ok", "remove valid old_fd failed"))
 		goto out;
 
+	err = bpf_get_link_xdp_id(IFINDEX_LO, &id0, 0);
+	if (CHECK(err || id0 != 0, "unload_check",
+		  "loaded prog id %u != 0, err %d", id0, err))
+		goto out_close;
 out:
 	bpf_set_link_xdp_fd(IFINDEX_LO, -1, 0);
 out_close:
-- 
2.26.0

