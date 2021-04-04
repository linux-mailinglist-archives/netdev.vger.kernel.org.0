Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 984EE35399F
	for <lists+netdev@lfdr.de>; Sun,  4 Apr 2021 22:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231512AbhDDUEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 16:04:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231485AbhDDUES (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Apr 2021 16:04:18 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE20CC061756;
        Sun,  4 Apr 2021 13:04:12 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id 1so7253237qtb.0;
        Sun, 04 Apr 2021 13:04:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iJcQBQHa3ArWQfSBBBDBzWo2MXQV30RHUu9YjEMiTK4=;
        b=ISAZAYauh5kupfAWdUMkKIljxhjYC7VC2YMeOkipGUCATbNc/mIaFhmYnUSJdxwylK
         dCXaPMVBtzpXlvEBWpLEoaD9J60dNrFtcYzUJjn0cEkTL0ot6IXhfhQRK3ZWK4mYN4GK
         XpIhtiL/fNzQKAFIXwddQXNJYOHMi57LEXw/bEtk1u2WCVwbFOs9xT7E1ft/kQDoZENi
         m8B4C4Tm1BYa97eLwONdT/ZmBiM6rFqHy7SGm05YzdDj7jpJVn7LcMR9GSG2M7fMnVju
         zj72PJ1LuPDZGYGQH2wTubM5A+1/YqQIJPzdOiXGFC9mz40aQfRyMXy34h6rtyUkf3nk
         D3ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iJcQBQHa3ArWQfSBBBDBzWo2MXQV30RHUu9YjEMiTK4=;
        b=k/8bdPjbb7PGiRFCi68m9RNX4llF0NL0vEKBNrILbVQ3UeGjQtkYwN2blAa/5MhG3B
         tfd/4tboxbi9DqZwALF1gLx8WmJ/nJtqBRuJXTrZGWeScRMcHSYDGFNQ/lgIEiqSDGXn
         3fSx4UxmG6ZGtxe1AhR+Jr9UvywABBXaKvMEj4qEsvzioWO63C7zVRdmWWBfjqzakcJl
         mfuw2K9gAutg5PWmv+t+tlTMlSWYM2l3km0EQurzzvDnBWvR8eyVFMm4ucqQPTeLRAhh
         CFH2hgBpwh6qT4Y2bj3rUxZIAxsFFUR2Mso15z6Oe5CEHa0qTDs1YZ0WHUDB9uLsBknK
         7L6w==
X-Gm-Message-State: AOAM532rM0tCkU+SBrXClawZ8pKK2ikvaJhLr0ni1TuoMGxpAPmCY+Dh
        kWRTLxI2z/vr/yYsTYbgGJ8=
X-Google-Smtp-Source: ABdhPJyeoJsjeb9pSbR+iyvQSGB7f0JjlDEP4MTKhmGmBQBabgYz8BgVu6SKmhf4HX+k31hiu375zw==
X-Received: by 2002:ac8:787:: with SMTP id l7mr19255501qth.280.1617566651479;
        Sun, 04 Apr 2021 13:04:11 -0700 (PDT)
Received: from localhost.localdomain ([179.218.4.27])
        by smtp.gmail.com with ESMTPSA id d24sm12163480qkl.49.2021.04.04.13.04.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Apr 2021 13:04:11 -0700 (PDT)
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
        David Verbeiren <david.verbeiren@tessares.net>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        netdev@vger.kernel.org (open list:BPF (Safe dynamic programs and tools)),
        bpf@vger.kernel.org (open list:BPF (Safe dynamic programs and tools)),
        linux-kernel@vger.kernel.org (open list),
        linux-kselftest@vger.kernel.org (open list:KERNEL SELFTEST FRAMEWORK)
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>
Subject: [PATCH bpf-next 1/3] bpf: add batched ops support for percpu array
Date:   Sun,  4 Apr 2021 17:02:46 -0300
Message-Id: <20210404200256.300532-2-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210404200256.300532-1-pctammela@mojatatu.com>
References: <20210404200256.300532-1-pctammela@mojatatu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

