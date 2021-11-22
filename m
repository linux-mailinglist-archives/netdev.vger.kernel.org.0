Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9AE45899C
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 08:06:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232507AbhKVHJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 02:09:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbhKVHJd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 02:09:33 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31685C061574
        for <netdev@vger.kernel.org>; Sun, 21 Nov 2021 23:06:27 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id y14-20020a17090a2b4e00b001a5824f4918so16067110pjc.4
        for <netdev@vger.kernel.org>; Sun, 21 Nov 2021 23:06:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rhg9TzsQGoRy8u1OLujkUnb4ClXkAMqCNEBp1eYj7W4=;
        b=WKXNZRlrfWoEvbd3Mt43sBZcp9wgXb3skAh5izBElWBnr0tpnYwGDQC+yAADHI2lDp
         guE2Q2gc52+yEiuMw1pHyyFssT+vqM8WQpQ1NipliQseEEXYaAPQ01jYM4WAzUkOM0Fy
         uPH0xcHFEHECpzFVJUX5i8n7bSrSOiL8lQVRlWutemDwWH5VeL4Qvsxux45xeaPtw0Pz
         /Dgi9MKBk5NBcCloWvcxKqtDvQExoEq4tsvTryTf6bUOzwEQAfkBGhoBtFN3i/mUTzgZ
         difrDbraEYN5ybP1wVX4W+049BvzleSGzETJWQPx86KyvMwQZM73EYtZ47AJn8pT+L30
         Oc9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rhg9TzsQGoRy8u1OLujkUnb4ClXkAMqCNEBp1eYj7W4=;
        b=4v5CorA41pgW3/D7OZtabeIUf7S32I3ZoYS1Z0DNfdivobyUtDJ8rk9Zje90265xg7
         0DvlfCH7XGg2eHTOkBKp+hTGOU5Ltsm6pRTfERn23oAgE8cwfcyWcecISXwWvRhkQflp
         6VQywDVmb3oQ7QGPG20Q0dphiqn9HyEcBrVJIoQGawMwW57Quo7osvqKkDEnaXVAYin2
         FsFwR32EEtZZi0nULUAqbpWHA3HXkm7benZQ7RXM2S0BDtp+3bbpJ9m4CtoxRcXS4Z2n
         DZvbZu0lwxyQl9sBrNp04IMyDfpZgZjvNGvhZTajgDBz/S7Odtm309poVpoyK2yVGnwI
         wz/g==
X-Gm-Message-State: AOAM5322Ln1+qQE9dWTstXL4kxx7n7zuRjJPoSbd8o5Bvq4cTXAW4ZwS
        MbEN5BYp+ECCuX9JfPk/01agjCAIkgzBfER42A8=
X-Google-Smtp-Source: ABdhPJwAGuNBy2ut5ulgnJSYyO0MNQHn/zLEJfG36fGPimpq7gsDYUwwU4YvFRXGfyX0qYRyqpqKnQ==
X-Received: by 2002:a17:90a:3009:: with SMTP id g9mr28516847pjb.205.1637564786708;
        Sun, 21 Nov 2021 23:06:26 -0800 (PST)
Received: from localhost.localdomain ([156.146.34.70])
        by smtp.gmail.com with ESMTPSA id d9sm14281305pjs.2.2021.11.21.23.06.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Nov 2021 23:06:26 -0800 (PST)
From:   Drew Fustini <dfustini@baylibre.com>
To:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jiri Kosina <trivial@kernel.org>,
        Alan Maguire <alan.maguire@oracle.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Drew Fustini <dfustini@baylibre.com>,
        Hengqi Chen <hengqi.chen@gmail.com>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Gustavo A . R . Silva" <gustavoars@kernel.org>
Subject: [PATCH] selftests/bpf: Fix trivial typo
Date:   Sun, 21 Nov 2021 23:05:30 -0800
Message-Id: <20211122070528.837806-1-dfustini@baylibre.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix trivial typo in comment from 'oveflow' to 'overflow'.

Reported-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Drew Fustini <dfustini@baylibre.com>
---
 tools/testing/selftests/bpf/prog_tests/btf_dump.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/btf_dump.c b/tools/testing/selftests/bpf/prog_tests/btf_dump.c
index aa76360d8f49..87e907add701 100644
--- a/tools/testing/selftests/bpf/prog_tests/btf_dump.c
+++ b/tools/testing/selftests/bpf/prog_tests/btf_dump.c
@@ -761,7 +761,7 @@ static void test_btf_dump_struct_data(struct btf *btf, struct btf_dump *d,
 	/* overflow bpf_sock_ops struct with final element nonzero/zero.
 	 * Regardless of the value of the final field, we don't have all the
 	 * data we need to display it, so we should trigger an overflow.
-	 * In other words oveflow checking should trump "is field zero?"
+	 * In other words overflow checking should trump "is field zero?"
 	 * checks because if we've overflowed, it shouldn't matter what the
 	 * field is - we can't trust its value so shouldn't display it.
 	 */
-- 
2.27.0

