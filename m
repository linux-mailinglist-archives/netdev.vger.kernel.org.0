Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FBA7355BD1
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 20:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240739AbhDFSzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 14:55:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240440AbhDFSzB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 14:55:01 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23A22C061760;
        Tue,  6 Apr 2021 11:54:51 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id x11so16041438qkp.11;
        Tue, 06 Apr 2021 11:54:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3DUapBlFjGRDJpFp34wiWQN/kbUJN43b6f1p6IDIwe8=;
        b=i1WY2Ug2tFRBZgzifWooGop1E6iUhysuLakRevI5r8exqjYI/zskTudGR+h+7H2EHY
         qhKybldYk//RiVNmZ8nf5xwXhzhSnI3TuYiGshP86n1sIEAurka+JKWC3mr6NAQLEfFg
         e4bjw6UKbfk9KI0BhAhjQX8UpgiB0Kh06HPGoIUoNdLkV9TDZaxWd0hdnuHkTuH0yHu5
         5w23rwesdCPCg4LUD/UgJcVLUup6MyzF875NWOyE1Q3T6iloy46N2azH0lhfSAbMOnRd
         8w9IibeevuBQGlcHIIT3AtPlxC3pjMJr2jP2BBY25h5uohygNO5RmXYJgmLgcCjB//kn
         bmAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3DUapBlFjGRDJpFp34wiWQN/kbUJN43b6f1p6IDIwe8=;
        b=c7v3IWTAC9AK0o6JNYFty5KfOwDJgy5D0vjbHlGlMedyx12ri/Nc/2lMqLvykYrYmE
         RXtz1nCg5HMzHC+fio/JZ6D4GqMaRwhsyrh4vaaEb+L7oNQD6/5CLOFKgtHzKJSVmyjb
         ZlefDwzDYiPvW5ROjmB0bij+IXtZvr6cBQ/XCSK2vdkBES0wkTYNmHaqbbAlySpz+t90
         i/61MdYcC0AZACy+x8fL6PQjT4icQUfG1hgXnLnFQVCHaaxm0pPTyEHQ4wGF6iqryQ4x
         If0BKKB9CGS5Dyv/iA8KlauNNU4j1OTkQaeIKEXHlMU4X+U2wo0MOfF1wC0n1NKC+RnT
         E+fQ==
X-Gm-Message-State: AOAM530L5I26AVIHKRUD9PWekBgva/Ybmjf7DLCbHqM1EX9CnCkotmaM
        LMz/2Kfg4r28gX5JQKexRKTPFEhJsvt52g==
X-Google-Smtp-Source: ABdhPJxCM8cSfJqpuK2nXjjfp5/PZjUf8+igBTwJ/Uloy2x0rTyxvyLmmOEZEseV40WlAkYieeTbgg==
X-Received: by 2002:a37:6104:: with SMTP id v4mr31081350qkb.429.1617735290430;
        Tue, 06 Apr 2021 11:54:50 -0700 (PDT)
Received: from localhost.localdomain ([179.218.4.27])
        by smtp.gmail.com with ESMTPSA id a19sm16581652qkl.126.2021.04.06.11.54.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 11:54:50 -0700 (PDT)
From:   Pedro Tammela <pctammela@gmail.com>
X-Google-Original-From: Pedro Tammela <pctammela@mojatatu.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Pedro Tammela <pctammela@mojatatu.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        David Verbeiren <david.verbeiren@tessares.net>,
        netdev@vger.kernel.org (open list:BPF (Safe dynamic programs and tools)),
        bpf@vger.kernel.org (open list:BPF (Safe dynamic programs and tools)),
        linux-kernel@vger.kernel.org (open list),
        linux-kselftest@vger.kernel.org (open list:KERNEL SELFTEST FRAMEWORK)
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>
Subject: [PATCH bpf-next v2 1/3] bpf: add batched ops support for percpu array
Date:   Tue,  6 Apr 2021 15:53:52 -0300
Message-Id: <20210406185400.377293-2-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210406185400.377293-1-pctammela@mojatatu.com>
References: <20210406185400.377293-1-pctammela@mojatatu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Uses the already in-place infrastructure provided by the
'generic_map_*_batch' functions.

No tweak was needed as it transparently handles the percpu variant.

As arrays don't have delete operations, let it return a error to
user space (default behaviour).

Suggested-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 kernel/bpf/arraymap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index 463d25e1e67e..3c4105603f9d 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -698,6 +698,8 @@ const struct bpf_map_ops percpu_array_map_ops = {
 	.map_delete_elem = array_map_delete_elem,
 	.map_seq_show_elem = percpu_array_map_seq_show_elem,
 	.map_check_btf = array_map_check_btf,
+	.map_lookup_batch = generic_map_lookup_batch,
+	.map_update_batch = generic_map_update_batch,
 	.map_set_for_each_callback_args = map_set_for_each_callback_args,
 	.map_for_each_callback = bpf_for_each_array_elem,
 	.map_btf_name = "bpf_array",
-- 
2.25.1

