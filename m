Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57E832DA134
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 21:14:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503089AbgLNUMi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 15:12:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503078AbgLNUMO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 15:12:14 -0500
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9AADC06179C;
        Mon, 14 Dec 2020 12:11:33 -0800 (PST)
Received: by mail-ot1-x32c.google.com with SMTP id j20so12559577otq.5;
        Mon, 14 Dec 2020 12:11:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GJIQSb408Ty07UVJPZWzak1MwnXpH47wjbyMmA0spq4=;
        b=qNHkGvqK+IKHMiz8hQn6ahIFoHOp9NYvrFtggOrt68UHmpe9hN/QlXQOAmToUcZjTl
         jo3jTSNv48icSB/8gHOygKKBbzBtl+gYWb05bx7/v6DCDUTBVNU8RL7lpx5zEr+RjuMR
         RQqvrCWc3sxk6NR0549X56SZoVgnwyeZO7wdJHnn6+u2J3Fh7CpJQH6tynZSAK9oPilj
         QMlu9m6jqrS27xW4heImiMNNbG8EIq6EaGtpc/sLle8uTRzOBuMuNz4bacAyhRe11Rqx
         nO9I/zhsiwMUL0wPzwVDEtmJSl+SX80YQI1YveBehzN1gTkl30zvqAzhJBq6iAREO+wT
         fKeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GJIQSb408Ty07UVJPZWzak1MwnXpH47wjbyMmA0spq4=;
        b=B7mVcdEQmrTXCZawUdSperw5ubP/8UEKpCEU4vvnz7i/R98z1hfOBX4Le47vrbcIZ5
         rypcDdXQ69p2x7JAfREu4p8o+ClKgO5XtWfZ6m0qxgEpWzToPSxSIrRvoNLwx6faH9nZ
         3sI1U7Ih4Oz9+0+ADTk43kWzq4axSK/+xyA4GawYomUKPHxn368DDEpoP1nqMtFnqoI1
         j9pfX9DbdpqaaRZjF8ZzrIw64QUBq9fBj2ucFQDfCRagPPqb01uUQM3kPIYC8HEeDdcH
         M2I4HTHywz0bkgKXiyZdA56Hxu4KuO2E0hYYIxU/IW0/QUHHZz2nHjC78kuBY0Pu8mTl
         WvYg==
X-Gm-Message-State: AOAM531GPGkLdutmKu5NLOTW4zAVmCiTHBHc26h/UOssl3W15kRiEjel
        pEGPVli/XkK/3OkPCqpMZKg6Rk7n9jkuew==
X-Google-Smtp-Source: ABdhPJzYi5jZ+ElEupPhmr7mTv/+CDm0Gk7x9oUTD1f4+ngcii3H2+t5cOCtTtMlzPxrO4z4NEhdmQ==
X-Received: by 2002:a9d:3d64:: with SMTP id a91mr20435167otc.144.1607976693095;
        Mon, 14 Dec 2020 12:11:33 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:3825:1c64:a3d3:108])
        by smtp.gmail.com with ESMTPSA id h26sm3905850ots.9.2020.12.14.12.11.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 12:11:32 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Andrey Ignatov <rdna@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dongdong Wang <wangdongdong.6@bytedance.com>
Subject: [Patch bpf-next v2 3/5] selftests/bpf: update elem_size check in map ptr test
Date:   Mon, 14 Dec 2020 12:11:16 -0800
Message-Id: <20201214201118.148126-4-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201214201118.148126-1-xiyou.wangcong@gmail.com>
References: <20201214201118.148126-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

In map ptr test, a hard-coded 64 is used to check hash element size.
Increase it to 72 as we increase the size of struct htab_elem. It
seems struct htab_elem is not visible here.

Cc: Andrey Ignatov <rdna@fb.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Dongdong Wang <wangdongdong.6@bytedance.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 tools/testing/selftests/bpf/progs/map_ptr_kern.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/progs/map_ptr_kern.c b/tools/testing/selftests/bpf/progs/map_ptr_kern.c
index d8850bc6a9f1..34f9880a1903 100644
--- a/tools/testing/selftests/bpf/progs/map_ptr_kern.c
+++ b/tools/testing/selftests/bpf/progs/map_ptr_kern.c
@@ -111,7 +111,7 @@ static inline int check_hash(void)
 	VERIFY(check_default_noinline(&hash->map, map));
 
 	VERIFY(hash->n_buckets == MAX_ENTRIES);
-	VERIFY(hash->elem_size == 64);
+	VERIFY(hash->elem_size == 72);
 
 	VERIFY(hash->count.counter == 0);
 	for (i = 0; i < HALF_ENTRIES; ++i) {
-- 
2.25.1

