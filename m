Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 439A71E4DC0
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 20:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728603AbgE0S5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 14:57:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbgE0S5g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 14:57:36 -0400
Received: from mail-oo1-xc44.google.com (mail-oo1-xc44.google.com [IPv6:2607:f8b0:4864:20::c44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9F65C08C5C1;
        Wed, 27 May 2020 11:57:35 -0700 (PDT)
Received: by mail-oo1-xc44.google.com with SMTP id v3so575236oot.1;
        Wed, 27 May 2020 11:57:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=r46D0cfhvOhWWQ3wuo1JGTI5mTXEa2xSDV25qx6cAKk=;
        b=IcCGEHwh6VfbORhnPgDkpXIEqASSNM6+Dy5fNAYhoMaqUwYzRyY2PLTJbYrUDfoyAO
         reP2FE0YljDiGL3KMwEUMilq3ThaHIkNeOTdv2cCnM7zjE4NNXddO4UQnbwni8qb2fUX
         6lZX8tVc43EGjFxWqEeCLEsX6ZO/lWbBXAPVzNMQJ6LZTIjmqKh8raLLYG06iutyoWbR
         xRT/XINpNtPB4gySXxiPq339x9iO/FtFJ+YL9Gk6VbwD6+a1YJKtzEjg0jiHmJgES6sW
         SPkb/ZxUeEgp1uMHuhlR+25VB2++Byfdnu5oFbEfQYfkQ6qnDYAmFvkXnbJsMUfwxnIx
         ayPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=r46D0cfhvOhWWQ3wuo1JGTI5mTXEa2xSDV25qx6cAKk=;
        b=cde1GrR6zFyUnFdLP9tId+y66zcOBhv1MB3vGmboIy81LlF+w5GH2h7xDClnq/Klw2
         nwgZRBUPTpId6gNMUVaiVxx0VbtM5A52mT2Kj4QeA+M5yTk8FkpRf0dvcDxeP2LQUUE3
         YSPIqs9PePwhmtjKtR7+nNTnD8eApp5M7FwlBxw+IWRujTUztPkwLCwgLvAgcW0VX6F3
         M+0SFui6+09+plBvG6uSt9YVa7gFGNnsiVyG6U510BzpPns/fnXYVP7Of4MIDh9Ie8bK
         G4V/KG78BI7oxpxb0HW+oy5KuAYvj7whC1qj+9cHBuBf+Jn6kh7ujIwgAS6njnyqXtB5
         Iv8g==
X-Gm-Message-State: AOAM532HKiejRtn2IuiV6Vp49I5p3nxN2nnRvOU64fndEWfTu1Va1b1t
        t6novdpXroMcxda739AQ7Uo=
X-Google-Smtp-Source: ABdhPJwY0kLd6Qt/cOzyeaTF+lRjh66ysW6Shhec+3r7seZ08dLvdYfT34asas6wWsct9uKRnljAMw==
X-Received: by 2002:a4a:244e:: with SMTP id v14mr4182967oov.57.1590605855296;
        Wed, 27 May 2020 11:57:35 -0700 (PDT)
Received: from localhost.members.linode.com ([2600:3c00::f03c:92ff:fe3e:1759])
        by smtp.gmail.com with ESMTPSA id i127sm1074596oih.38.2020.05.27.11.57.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 11:57:34 -0700 (PDT)
From:   Anton Protopopov <a.s.protopopov@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Shuah Khan <shuah@kernel.org>
Cc:     Anton Protopopov <a.s.protopopov@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH bpf 1/5] selftests/bpf: fix a typo in test_maps
Date:   Wed, 27 May 2020 18:56:56 +0000
Message-Id: <20200527185700.14658-2-a.s.protopopov@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200527185700.14658-1-a.s.protopopov@gmail.com>
References: <20200527185700.14658-1-a.s.protopopov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Trivial fix to a typo in the test_map_wronly test: "read" -> "write"

Signed-off-by: Anton Protopopov <a.s.protopopov@gmail.com>
---
 tools/testing/selftests/bpf/test_maps.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_maps.c b/tools/testing/selftests/bpf/test_maps.c
index c6766b2cff85..f717acc0c68d 100644
--- a/tools/testing/selftests/bpf/test_maps.c
+++ b/tools/testing/selftests/bpf/test_maps.c
@@ -1410,7 +1410,7 @@ static void test_map_wronly(void)
 	fd = bpf_create_map(BPF_MAP_TYPE_HASH, sizeof(key), sizeof(value),
 			    MAP_SIZE, map_flags | BPF_F_WRONLY);
 	if (fd < 0) {
-		printf("Failed to create map for read only test '%s'!\n",
+		printf("Failed to create map for write only test '%s'!\n",
 		       strerror(errno));
 		exit(1);
 	}
-- 
2.20.1

