Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3144C3920A
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 18:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730695AbfFGQ3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 12:29:33 -0400
Received: from mail-ua1-f74.google.com ([209.85.222.74]:40850 "EHLO
        mail-ua1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730689AbfFGQ3c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 12:29:32 -0400
Received: by mail-ua1-f74.google.com with SMTP id t2so251149uao.7
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 09:29:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=k+Brm8PUBExjWcHqIDpG6xNNa/FsZCQsubsibU0l2Vk=;
        b=sOXYSi+5U8cxxuJHa05hRE3qp3Xc1FIJMgYPOfoYIPj1OZkAik8kEIy8bU77mVsM9E
         q7hYuZmq6Urt8FpDm2KSwshrKmkT90LmK/qbvsKapgLIkfc9HVd/+cp1qJ5dkpMUSHx+
         N1603sNPGGUJoGTwEVTrg0ZM8iXgmGVmcfFKGRMU5jL47v4LXqGHti4X076hBJnGtrRm
         OkIbmrhF+J7NRPPET5jQeiXtILIDkNpr6wJyEyp14lalxSYKtWGFmrRHpha/Eea7VGwc
         /HkD5CIlEDPcBndpRN1v3B4uPNr2A6HvnKz/4VthEjhfH38T7GXyzO0jG06B9bcTKWip
         6Tcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=k+Brm8PUBExjWcHqIDpG6xNNa/FsZCQsubsibU0l2Vk=;
        b=rFrh7nU4NVH0iYV/y23Jqr0qzFUoJgP/k0M/ZOhLgqD1RZMf4NbwRusGRdy78gr+/1
         JHCun5vvjuH4dPXWShEhiqEK+L6TqivAuMeHfPv0m8Mz2vv3f6l7IL3ga+lA4ikmt4Cg
         8k3dVI1LrYe3s6sBbHAGZ6T4JFqqhfZhy5lokseqqQOeCDWYlevur/sAa2t2nQuizcu6
         47U5OtgGcpUFv0atIxUs58OxryEYZ/0ICDqWPYAc2LRoWpT4NzJfMnhu2UvAytA6CQuW
         z1VoW4x7Esg3aY/xu0rhmyxAI7Gt1WvWjnUitjh8MSZxJI4W82KTR2xniciRvFh7vD9e
         zz0Q==
X-Gm-Message-State: APjAAAUzoZAzFzxD+qtNC5ijktSC9RJvOPEhOq9ZZGTWMygKgc9+o57s
        z6noXYAsnB2lgcIUj/eY9s2wQhdUYbcW7CNccyEaYzrkkDdeMBU2IIAnBKQlN/MskN28Chkz2si
        GazcLjtEK2Od+PxEAiGHSzlQ5Io3e5vTEly8B0I/AFqDG4jZVrX4s5w==
X-Google-Smtp-Source: APXvYqy7APXu2pViRAchIo81d4MdqBTu3mKeKwrX406KrIjtLGlGRDLzY/0i013jCert0qcmAhBnhOM=
X-Received: by 2002:ac5:c2d2:: with SMTP id i18mr12326998vkk.36.1559924971103;
 Fri, 07 Jun 2019 09:29:31 -0700 (PDT)
Date:   Fri,  7 Jun 2019 09:29:16 -0700
In-Reply-To: <20190607162920.24546-1-sdf@google.com>
Message-Id: <20190607162920.24546-5-sdf@google.com>
Mime-Version: 1.0
References: <20190607162920.24546-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.rc1.311.g5d7573a151-goog
Subject: [PATCH bpf-next v3 4/8] selftests/bpf: test sockopt section name
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

