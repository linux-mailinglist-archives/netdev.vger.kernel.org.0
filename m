Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A3E9351F4
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 23:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbfFDVfk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 17:35:40 -0400
Received: from mail-qt1-f202.google.com ([209.85.160.202]:33502 "EHLO
        mail-qt1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726541AbfFDVfj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 17:35:39 -0400
Received: by mail-qt1-f202.google.com with SMTP id r40so11876996qtk.0
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 14:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=k+Brm8PUBExjWcHqIDpG6xNNa/FsZCQsubsibU0l2Vk=;
        b=XHf/glE4ni0WviEYHvfe9wiunzEnvmh8fzmqbe5jooh6SEWKvkiXQXnu1SVtEKKU4i
         uinKz+vVVJVEsylzhrLqC1mjAfsHnXgb4vkNAlKs8EPWmocmTO8hZYC3674LqPYJXOL6
         PhshlNC4AaOkVUWwjh2NWpBC84MDC8FisdtzHfww9/FhHOCuIm1q3Sa3zTPTn4VIBkW5
         rHLN83KxT9zYpi5y2QPDPugI8Wi2Sp6CIEI4DXYy3bPyQZfkgJ7XlxJDFRTHqVwoW4DW
         8AwITMvyONHc4x3EKaoGkYnmSlH6GaDi3ZPzeAKLl3X9ak1UngysnY0ctlNR5IszLWU/
         nd+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=k+Brm8PUBExjWcHqIDpG6xNNa/FsZCQsubsibU0l2Vk=;
        b=N7oLZBedvcOL7L7J8aISkkYYr9CDYekm8/AwMEWsYoPSnwXALBrvtW8oTGq8DSWJFJ
         VmQlUJVcgCQG7BG7rm4GFcvRIF7uu0d8v+BZlInI72z2BZSYVU3Gpoa73u6IwLxA5qDZ
         qOUAxKLzqbHmCBNT45igpUiAjYvSWWjqTTBLrqq/KkXaJl60JqToh0+6Rrupd5YRmzof
         pauOiZGqT1dCOoY8nkuNE9EO5f8DURcCG4jCVZlgy+QoYXX7BWh15qyji7UqOyPzoDNh
         uglL644llrBrXL9r2wGpcgT1qxcyjD+UndoC7aYfRyXOv55kL+pkmpMTLIdTHg25dSdN
         KB7w==
X-Gm-Message-State: APjAAAVJg+mH1VS+hrLu6Y9sOK/VZwkhO6ApMGZSH5JXJEQOQNg6oxD6
        JrppxEyJZsK3nXxjCKVwj56EeSZslG0i6boYYIYAQMUoX1A28hyG26iOJv1nRebqr1/TgF15Fap
        KiVdCzdnehg9162a8PUz/HyLAqBOeqLJ2/GttXl/WiZgYjAb0rwo/Xw==
X-Google-Smtp-Source: APXvYqx3eKRGs+WHd5014kl0ak5fS7b92mmUSSeTMELQ4qVRs+H0bIoMpRsVzkTiWmoRqvVa3d0cQN8=
X-Received: by 2002:aed:3f1a:: with SMTP id p26mr30282187qtf.113.1559684139069;
 Tue, 04 Jun 2019 14:35:39 -0700 (PDT)
Date:   Tue,  4 Jun 2019 14:35:21 -0700
In-Reply-To: <20190604213524.76347-1-sdf@google.com>
Message-Id: <20190604213524.76347-5-sdf@google.com>
Mime-Version: 1.0
References: <20190604213524.76347-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.rc1.311.g5d7573a151-goog
Subject: [PATCH bpf-next 4/7] selftests/bpf: test sockopt section name
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add tests that make sure libbpf section detection works.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/testing/selftests/bpf/test_section_names.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_section_names.c b/tools/testing/selftests/bpf/test_section_names.c
index bebd4fbca1f4..5f84b3b8c90b 100644
--- a/tools/testing/selftests/bpf/test_section_names.c
+++ b/tools/testing/selftests/bpf/test_section_names.c
@@ -124,6 +124,16 @@ static struct sec_name_test tests[] = {
 		{0, BPF_PROG_TYPE_CGROUP_SYSCTL, BPF_CGROUP_SYSCTL},
 		{0, BPF_CGROUP_SYSCTL},
 	},
+	{
+		"cgroup/getsockopt",
+		{0, BPF_PROG_TYPE_CGROUP_SOCKOPT, BPF_CGROUP_GETSOCKOPT},
+		{0, BPF_CGROUP_GETSOCKOPT},
+	},
+	{
+		"cgroup/setsockopt",
+		{0, BPF_PROG_TYPE_CGROUP_SOCKOPT, BPF_CGROUP_SETSOCKOPT},
+		{0, BPF_CGROUP_SETSOCKOPT},
+	},
 };
 
 static int test_prog_type_by_name(const struct sec_name_test *test)
-- 
2.22.0.rc1.311.g5d7573a151-goog

