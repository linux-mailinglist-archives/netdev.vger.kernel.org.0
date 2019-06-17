Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49CA548B27
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 20:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbfFQSBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 14:01:53 -0400
Received: from mail-oi1-f201.google.com ([209.85.167.201]:55938 "EHLO
        mail-oi1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726607AbfFQSBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 14:01:53 -0400
Received: by mail-oi1-f201.google.com with SMTP id r7so1704037oie.22
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 11:01:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=aMAVJjYPVW0LDE+1k3jh4sYPHN+8Kpd0vTrAOfnc5og=;
        b=FvdtVe3Vbc39dmix+NbXtFO0MuPToF39PwPdhhwcCGBjaXhcsjoA1cZ/nxNgHkXDzs
         bDh7EnOcFzrQFcGVb1ZYN8oQypdkRkfrmpttn1B4VuXFewqPFXKnPZWLicYPWufdgZxV
         NizLHYuh/GucFT0L7dVVIWgGRmVraYJMqpwp1XZYTHgFZ7Sf/jNqalwqKfgv3KF8eZ6X
         iT9mJS4RU/1C89Gma3S87e8VViiFzMczPDPrjD46QAzv9QAokmdk+syLfcFiuDolECmH
         rv0QVS9sJxSIkbs89KVok78IEESMPTD1FIPikZvdyB9CcX8XDb0WTvzhIGgy4wLurg4r
         MiZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=aMAVJjYPVW0LDE+1k3jh4sYPHN+8Kpd0vTrAOfnc5og=;
        b=T/Jk4cizNSgaJHIIyyLULy6iYSB5B66K/duSJhzMpzzNmyoMnkPviLmVje2uFeqoG/
         calaFI5VCbTTdZAgul3Vmtc/XeW34iC1+5ryVKhHo6lssRVEIbTvPMcCQbTOpDhkdho2
         nYjzGH4mKn36+3Z881ex4GYxv4ZiRXKoLXkyO/y6/r2qyziR4Rb0lYN7Y1K3bH0G3V8u
         ByM/lj8BqGeDeMhNvj778a4UlUswtmTb/t5wLPjUN0Zp2jKKigdwUSOU/JdTaNAih5EE
         AXs58tcRKqQPT+7v14WeSGsvVSqVW65pcqGb7sj074jBF81f6XpAyWsVjixMsn3E4OwH
         n5Ew==
X-Gm-Message-State: APjAAAU8rQmVwlfKdYXczshACLIq/F5TSgn987mgl7TVhMuM9UkoTPVS
        Yc43SOtrj6D7St8B0XfWn0DTlKg/JPxkzwZSYL6i/cVUGTcZ5XOpC6vs+BCWjjdzkvGZ7v804v6
        rfKP6p4+vcL9ZZnD2j7rXv7xh82DJyT4jhwTn9vFMD5uxRCUH67zitA==
X-Google-Smtp-Source: APXvYqz0mqk9GIDPC4J50t86rZtPLM7U1vEjox029PZVgNZ5MlaXtPjOaPVh9OkXzxEyrgOK4HnCTrw=
X-Received: by 2002:aca:cc85:: with SMTP id c127mr123475oig.81.1560794512480;
 Mon, 17 Jun 2019 11:01:52 -0700 (PDT)
Date:   Mon, 17 Jun 2019 11:01:04 -0700
In-Reply-To: <20190617180109.34950-1-sdf@google.com>
Message-Id: <20190617180109.34950-5-sdf@google.com>
Mime-Version: 1.0
References: <20190617180109.34950-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH bpf-next v6 4/9] selftests/bpf: test sockopt section name
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>, Martin Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add tests that make sure libbpf section detection works.

Cc: Martin Lau <kafai@fb.com>
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
2.22.0.410.gd8fdbe21b5-goog

