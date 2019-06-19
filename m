Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8444BF26
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 19:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729659AbfFSRAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 13:00:11 -0400
Received: from mail-vk1-f202.google.com ([209.85.221.202]:46663 "EHLO
        mail-vk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726628AbfFSRAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 13:00:11 -0400
Received: by mail-vk1-f202.google.com with SMTP id p64so7959819vkp.13
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 10:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=aMAVJjYPVW0LDE+1k3jh4sYPHN+8Kpd0vTrAOfnc5og=;
        b=NR+Tcsvnd6raptmD17C9IZB8amlVB0DPEfby19huupj8AUMzsHZm3WAhHwDreER/Ef
         5FeD6Eax30cL56UP0gO2KMSpJwQsSSNHtf2+/Lovq6KYoVj+hcTcnLpApEmpJbeVqqGr
         7FGdHzOZBhruYDtq5gO787VtGNv4MsktdvpWekmn1D4Drklh76K5cXA477GJVAFUwERf
         l4IFvyvdMZ31yZGvbPlzF9Chx3yvgySf0+/ivVejonznnu17Xm2b11S6PAAHD+RmAGMI
         lGjILseuzZWkWPbEFFa3NGGoSr3jkLTYHVCGheQjvOrRUyPEdXDgY5V7WIK8y4H6aK44
         i8AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=aMAVJjYPVW0LDE+1k3jh4sYPHN+8Kpd0vTrAOfnc5og=;
        b=bjKg0aK/3EEOkdm8fk2uz2O4TA5UYLx60sw0Al+wFrW7Lf3IYnortG3mede6eCZ+Ad
         IptaVtg6GvwFLK/NGBRc9RMAaODYy0ubT4YyFAiSIcRUMQiXBNZQW9xYerpuNiPASbjc
         0reQvLHKAyM9Esi5oyANCeEEZttCb6Z7pQa6u6g4i9fYAmko0Q5mMWtULtZDsc9oTh6e
         kOgkFwweDVhUMEla34LB6UBE9tVVAGFmFWCKv438rf8zldnaMf+suezTl448g8Y7AxpC
         dCd3ousEIE70HUQKnLcPZ1bFg2OkfL3RE2ymPnbrUL0llZpdFyWcmap5K3p+LkaKA4Y1
         h5pg==
X-Gm-Message-State: APjAAAXTLbKmo7JOCRXs1oiHIb2e5CsoYgdHp1RaIIyzjDs19QpVQGRR
        RzXBurXnSlDVRpGnm1ThTLAPIye+rpj8GanzhdQDelydSSsUQYXdoeeFvpn6TRINVxlhadO4wpT
        fDrXmfprijs/xVIvuGoL1u3sJMmlnFpEF1KaHJXOlN+Qt2Zz8YqLUWw==
X-Google-Smtp-Source: APXvYqwJlS5Tix4as0unV4lH0IF/ZTiXuJllbLdGgY5TOCXXD38551JMEKYFmc02vbYrmI9LWhtgK5w=
X-Received: by 2002:ab0:4108:: with SMTP id j8mr10028578uad.104.1560963609775;
 Wed, 19 Jun 2019 10:00:09 -0700 (PDT)
Date:   Wed, 19 Jun 2019 09:59:52 -0700
In-Reply-To: <20190619165957.235580-1-sdf@google.com>
Message-Id: <20190619165957.235580-5-sdf@google.com>
Mime-Version: 1.0
References: <20190619165957.235580-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH bpf-next v7 4/9] selftests/bpf: test sockopt section name
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

