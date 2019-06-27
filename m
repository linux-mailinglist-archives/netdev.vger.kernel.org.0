Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FAE858BC8
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 22:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726619AbfF0UjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 16:39:10 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:46952 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726445AbfF0UjJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 16:39:09 -0400
Received: by mail-pg1-f202.google.com with SMTP id s195so1904478pgs.13
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 13:39:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=axzDTyujNDDUo8hYgpJ8wFZojv2hAsxN7xd8iorthG4=;
        b=ClAAJn3dnqZJXhl6rH+nelVPYc52FZq4Q+ahWd9XGROCHNQLQQ+GGUAjz59D6OR1Jk
         jpwCSzwV1n9zXHjxI0A1wRoT9R3eqMBR4hXL0QiNR0gimT6Ywa/uSjO6X+frBmv5uW8l
         6lUKqepSE9bQbhVZEOmd3DmqKu8wE1ZzlYNdvHQYLrfQXX13oPiqFz/bv9baVAxBIW5A
         PlV+tVa+vQmqju1yjlE0SDs6TvPybwj/o50VD7RNJLywu8XC02uwBE+Lr5jjJrER6MLc
         3QLVr9Nr+Blcp1ul+puF5Fv1u6HdIryh2zoilbgCY+dmGBNRhCbkU8J6/T5a4bzONUXx
         GErw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=axzDTyujNDDUo8hYgpJ8wFZojv2hAsxN7xd8iorthG4=;
        b=Z6btYFd7+Oovt4BU+2ADmAsUS+ux9e4lF9HBYksce4RKvwbqGHiQNwuhMy1BEOBVbt
         Q6Ak9mDVBZrTCCM7+c6hyt47LDOhvGPQoh0FTTKxgEyGHPECgwLMtynhTI1mXLKewcK+
         ML2/FLdiWiiDZwvhyo5OIdU7TTba4Mh0KPlKuAwO+DlS3wIF/etxjSWuXSEHGlufwA2W
         Y/BYyvnWqdJl462EaTdye6cyK/OveIe11wFe8fy+y7YiJEiP5VoEhEI2cPCOIPn5rp/W
         cKcz9hSHfdK5PvfxL8f9Ec5GHZzeuSSaJsu/w5sDM7UBK9htLcTSabYt9Clm0fuezmw6
         zm6w==
X-Gm-Message-State: APjAAAUH1m07femWQp4o9py+zHOlRwQEfGjwnqRSIAWZ32B0Ld51O2FK
        krz7oR5sAtJKR4olqW/87SLUZy0e8ItNHaLcIxmWAP695DsnYU3lVROOVbUtTL6XTU/5gZ2aXYm
        iVB5pLlrwrFkkRcea7g9Uq2HmsGOhd2p8GmOPAzREBmpEv/cpplnI1A==
X-Google-Smtp-Source: APXvYqyZuc2PcUfyMb4ySy+6N/D3iTk05tFHPRGM6ASL2gC/m/WRBDFtG0P2gLT9wFL0fLlOyCGpoeI=
X-Received: by 2002:a63:4c52:: with SMTP id m18mr5086260pgl.302.1561667948206;
 Thu, 27 Jun 2019 13:39:08 -0700 (PDT)
Date:   Thu, 27 Jun 2019 13:38:50 -0700
In-Reply-To: <20190627203855.10515-1-sdf@google.com>
Message-Id: <20190627203855.10515-5-sdf@google.com>
Mime-Version: 1.0
References: <20190627203855.10515-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH bpf-next v9 4/9] selftests/bpf: test sockopt section name
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Andrii Nakryiko <andriin@fb.com>, Martin Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add tests that make sure libbpf section detection works.

Cc: Andrii Nakryiko <andriin@fb.com>
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

