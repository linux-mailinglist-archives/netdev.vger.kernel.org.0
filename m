Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 384F43BE16
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 23:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389926AbfFJVIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 17:08:44 -0400
Received: from mail-ua1-f74.google.com ([209.85.222.74]:47761 "EHLO
        mail-ua1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389916AbfFJVIo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 17:08:44 -0400
Received: by mail-ua1-f74.google.com with SMTP id 3so933316uag.14
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 14:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=quMXsD7+H6eze+mngdiYKY5iS4VhqtL6opWx3N39kho=;
        b=nkzFro68TpzhhQRfqeybbSFqxrUBW89R1h0kxttrQetsjXCxJV1H7cukFa6vQiDYy9
         LagMcLs89W39Zm7B3+nk0mB3zLWEmNq/uC4imeSPBs+T50rPSt3omrqTI662H51ctzIh
         HYhqS9F7mrcSFbwXSiRyGar08zLcyPYqVCnwpF3ZObn2N2qfZJy7K1A7xuJKnO5c2D8G
         9arkBtEhmicutQQp/UJyFT6BsoqFYF5Ruyf8wFRf4lEuj96HTXvSeiijzREkpOft3nJB
         Lou7pHt8KZF15ruibfcCb+yzB2i7lAMjmeEQ11K5ci7MtMwisIbveCTd8gyyWO0jpGh1
         vedQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=quMXsD7+H6eze+mngdiYKY5iS4VhqtL6opWx3N39kho=;
        b=TajXlzaqu2Q/woFZIKS4ec1HnIBq+lBpwS9m2J0DU0vboXEOQRgWhI8VXFJkRnnJXM
         dEocoLy9+ze3Zy4mIbqpO+Ms1APjQZK1QUM10SXKPz+tOcGozNRfGz0U/RKgTTp1isAL
         8YCy9lBbw3YYm4J3g6WL37EhNBtvf9b/OT+7EJ0I5a1O7DCA31J42qpZV6OY9I3gNuIW
         iWgJk8gIU6RkFK+yhPiwAvfWAOtYOoGgz0Tx7Hr2rJ/ZcEfiKP1TjMifNfrzurBmmoLw
         9TrT05znufNm5AAYvO3wbBBmsWVeWQ3fSW/fh320acGVf+sZjyYmcF+sDyw3D2r21CYg
         EdgQ==
X-Gm-Message-State: APjAAAVGJXmewlf7/XGinT07VACIi0z4CKAi3fk/ymzT+oqUPufsnMvx
        RYmLG6WSFY54XVb7QudFMG3q1rQiiSW8f/kyH7wzfsZ2laOsc53mkmp85hyqNugfce+Xoi9qq2Y
        +3iKL943uv/tO7Wn/1PrlE0IvQyOcbQq3SBqEpaDLvFAudOCazCiabg==
X-Google-Smtp-Source: APXvYqwgfmabI/aTrH4v2MfDcBFnysCIgV0W+w8bAO/yn5BT6boru0SmVV3wyqIksaMW49uJr4ovyC4=
X-Received: by 2002:ab0:36c:: with SMTP id 99mr4085373uat.105.1560200922842;
 Mon, 10 Jun 2019 14:08:42 -0700 (PDT)
Date:   Mon, 10 Jun 2019 14:08:26 -0700
In-Reply-To: <20190610210830.105694-1-sdf@google.com>
Message-Id: <20190610210830.105694-5-sdf@google.com>
Mime-Version: 1.0
References: <20190610210830.105694-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.rc2.383.gf4fbbf30c2-goog
Subject: [PATCH bpf-next v5 4/8] selftests/bpf: test sockopt section name
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
2.22.0.rc2.383.gf4fbbf30c2-goog

