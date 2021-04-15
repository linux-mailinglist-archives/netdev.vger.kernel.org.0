Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20EB1361159
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 19:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234428AbhDORr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 13:47:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233395AbhDORr1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 13:47:27 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95B74C061574;
        Thu, 15 Apr 2021 10:47:00 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id f12so18844577qtf.2;
        Thu, 15 Apr 2021 10:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3DUapBlFjGRDJpFp34wiWQN/kbUJN43b6f1p6IDIwe8=;
        b=EVH8wj78V9r6uk1IbL4TTKoiOR4l22X8t8TAZWIbqh2Yl6oXksEcG3EOIYgj5sxh3A
         jsC1XpZnbQf7NjXK6PQhZ+qJ2FSQ0dnOJuTxnCqtbrvuhfOx6viKvrEtCx6hPCVwiNkv
         dQwRebSyByR3xmwVF20kPz3PmrkH34+nVMMw93MUIVGZVNB/LQEJ+319J2S9qdjlUCw7
         pROdhJGIOC1vH6Dl3lFxVXVzpkPZ1/6irNs/iB1+Hx058ihTdN5xWfLakZjd3XJLG5GP
         W1yUDnLGTXUz1rrZa1O03u78YT73ovzMb9BlTKRfNzGxKpAblHNoVYOcuqpeKLjemPX+
         jD1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3DUapBlFjGRDJpFp34wiWQN/kbUJN43b6f1p6IDIwe8=;
        b=YGpMzsp5lXEa+FtIUTbXPszxT91FXKYt9vWP4dws+TRI4FTNJpIZyGb93FNP89HfQo
         puTR1lW5l0Tf4MNMxpYfE/DkUaWcOR3NCMFjYU4hzAR8tzUt2f6Af2eOrFZmx3JDL7YD
         v+Sz5o8idmrx4TVCB/VoTA/4poBE5G/jedq3xYXrht1mDOwXyiIPb1/qNPQMclTqgqAc
         eaI+E3s78H3xN2XmuPk5k4hPhKHG+Srmo3O7b/+wuyCi+xYqlLPTZ9lM2E9CLsP5bjWr
         Dk202OUQEbp9W7x5JHOZsrSdek2Y/w4QPsLvXeDyd2Um99BAee8GMnArDRIgQ/VQ8iSt
         wdyw==
X-Gm-Message-State: AOAM5323NQ9CwE5G2k4iYqZRbr2jqxV+IjT3/4M2iCroUyeiVRhnkyeL
        zU5btvgYxc/x+zFW2p09WXlIifCYbqRNjiLz
X-Google-Smtp-Source: ABdhPJzZ8KMFIioA7Fh4b1adJkRomwWKWUH9gU3cbZ/CvRz3iMX1PjbvFs0Z+ANQlJ/NCqt/WqYjfw==
X-Received: by 2002:ac8:7217:: with SMTP id a23mr4127708qtp.308.1618508819883;
        Thu, 15 Apr 2021 10:46:59 -0700 (PDT)
Received: from localhost.localdomain ([179.218.4.27])
        by smtp.gmail.com with ESMTPSA id a4sm2186800qta.19.2021.04.15.10.46.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 10:46:59 -0700 (PDT)
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
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>
Subject: [PATCH bpf-next v4 1/3] bpf: add batched ops support for percpu array
Date:   Thu, 15 Apr 2021 14:46:17 -0300
Message-Id: <20210415174619.51229-2-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210415174619.51229-1-pctammela@mojatatu.com>
References: <20210415174619.51229-1-pctammela@mojatatu.com>
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

