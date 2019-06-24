Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BFE451886
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 18:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730076AbfFXQYp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 12:24:45 -0400
Received: from mail-pl1-f201.google.com ([209.85.214.201]:52559 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730031AbfFXQYn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 12:24:43 -0400
Received: by mail-pl1-f201.google.com with SMTP id q2so7586637plr.19
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 09:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=2L5BO3TFAcuTUXuUy+gszkDxGDsun5OV31BgOFWHrj4=;
        b=UCuqefck5fwKfeSsXDKvVGT8+ZWbljGseRIo+hA37zKLozaDfG6fZATXAM00NHzcl+
         Dpmv35pUGNfo5VZA4mTwONVcJF2at2WqFWUnQFzt7iA4tGa5HXIDRf9KN17C9UPQPNHn
         hBBTbcqcndHBAWx0UOI47k9uuXZN6FfEZHn3SnRoZRyMKhRhKDTi6UG6+YrRWqFs5rkF
         BGaCBYpeQGeUfPar8ouPXf4Qz307Ic1FBe7QAaaCD+Cwta9tTgiS7Z3O/+NkV1HSbLjg
         4d1jO088WfWAa9wn4AV3cE7NjOx8mTDvT23YFXzQqyS/p+rMwqoo8RM2Yf8Cfc0i9UQJ
         qdZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=2L5BO3TFAcuTUXuUy+gszkDxGDsun5OV31BgOFWHrj4=;
        b=A/1tYvTL60JieRyNyadOIuaX/vjNslIyFLcXCKoJ6vQagi1lk4ngicuYpXXZI0P/VO
         HuYCa0EQVQsDIQ17rtok86FK0l9mwfNZiBsLpD9jK+YsXz6OQ3RI/gii1HRbuzJYT8jH
         WcCE5xVe3GoNinYj7Ve0qzh4PthQ9rmujmRmNevScTgq9V3hLKDZjnaimUo37x74bYUP
         iZ4PYiH955RKpu+TlWpqBS2MZkwZ03AkQvqueSQoBnW39Kem7/EgdoE6Y17w0jP2VqA/
         XhxJ7PKs3mq5/IF7xPGpaxkiA4b9Diduqds4kcEVYkvoI8tgIoYyFpLhVhs5kFz9qfaz
         wU3g==
X-Gm-Message-State: APjAAAU2fcpS7md71ZN3IErN3ObFwm/yY1KVvjRmvHZ6m+2z5SdA3wnf
        WRQmFSopYq5lxfWguVWcfUo9zLZ4A1WndczFtOFH01G+g0fiNk0pPzmxiM/tFFfyidchx3j5P7Q
        X0Mc8DznXbNHwdoxrKBqpUYNaIAUNYBjpdx8VF8gmdXxpqCc93LLqIw==
X-Google-Smtp-Source: APXvYqyqVC0q1+YWgzdB5oDO3h7jmL8WpYtJdIhhW3YFTtJ/r9brcI2jgWkDOqgrpQrZvrsNRcUq7z0=
X-Received: by 2002:a63:3683:: with SMTP id d125mr11329611pga.252.1561393482878;
 Mon, 24 Jun 2019 09:24:42 -0700 (PDT)
Date:   Mon, 24 Jun 2019 09:24:24 -0700
In-Reply-To: <20190624162429.16367-1-sdf@google.com>
Message-Id: <20190624162429.16367-5-sdf@google.com>
Mime-Version: 1.0
References: <20190624162429.16367-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH bpf-next v8 4/9] selftests/bpf: test sockopt section name
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
index dee2f2eceb0f..29833aeaf0de 100644
--- a/tools/testing/selftests/bpf/test_section_names.c
+++ b/tools/testing/selftests/bpf/test_section_names.c
@@ -134,6 +134,16 @@ static struct sec_name_test tests[] = {
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

