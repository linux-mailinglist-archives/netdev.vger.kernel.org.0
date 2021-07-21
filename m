Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7D63D197B
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 23:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbhGUVRq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 17:17:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29509 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229995AbhGUVRo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 17:17:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626904700;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Rr/KKkd5zXYat1qyJl/djPxgaYzdXYoveXMN2G13uMA=;
        b=T+wtGSo4cSpqsFjgxFT66GUquWTNKU1n2atxKUEtoPD8subBUtFblsXPx6kXk9h0Aag7Lm
        hZ195qMMSQ0+Fh4IhCprzvd5BRbeAFxnyyWhrI4Lkx+vDC82CkaZQl4/OpTKoCjVnX7bzf
        c0m6dK+b5EYs7/zIeJTidTjvvn7O0V0=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-494-6cERN-b_PKGolMekLA4caA-1; Wed, 21 Jul 2021 17:58:18 -0400
X-MC-Unique: 6cERN-b_PKGolMekLA4caA-1
Received: by mail-ej1-f70.google.com with SMTP id rl7-20020a1709072167b02904f7606bd58fso1296426ejb.11
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 14:58:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Rr/KKkd5zXYat1qyJl/djPxgaYzdXYoveXMN2G13uMA=;
        b=Mu5Jx8jIQjWTCRjm4ACT1BY3cKbJ/NLk9hny2KdJV8tPu2yfSHoImDlAQey6pLwdfV
         so06asQfVhTPrGojEz3ocYzQsz3W3r6KN6WG0UKXAE0JsGwiSFwMrOmVDyntLm2LdZ9E
         1mfvquYUaXkupXFgl1U9JrX0P2jwEjVZhznut6Z9q+iNfttQFwOjrBntHj1xAcykUsI4
         nQIjivlwBuodkKi43zPyorep6DQRNZIxfCwyLJYFyOakVMDL+3i92St7TC44p2Sgz03p
         4fFJ63h/IZdu/I7WtjEEuBpLXy/bTON02ompKSHzalr8tUaWZSUyJgsdg4i2Jd9k2kwd
         srxQ==
X-Gm-Message-State: AOAM532Oj70/ONTVUWl1MhCPBAOLnWsm1VZqrujACab9hDGsMZfyaBm7
        MjRz9bH4T+dH5VbpVrvjtBN06JQmjcxv7DPB2yv6QOSnpipkgxuYW4arHBtMTVEDEe8syvn3eVz
        TSFu3ThlZvs+XH50b
X-Received: by 2002:a17:906:34ca:: with SMTP id h10mr41229337ejb.41.1626904697780;
        Wed, 21 Jul 2021 14:58:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxFjsfbkXohPNEK4fDO1ZFmawWIRbsFGTHBmygJ88qfl8uG2fiB8lCyN3uW/+G9mioren58hg==
X-Received: by 2002:a17:906:34ca:: with SMTP id h10mr41229328ejb.41.1626904697653;
        Wed, 21 Jul 2021 14:58:17 -0700 (PDT)
Received: from krava.cust.in.nbox.cz ([83.240.60.59])
        by smtp.gmail.com with ESMTPSA id t5sm5545969eji.113.2021.07.21.14.58.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 14:58:17 -0700 (PDT)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH bpf-next 1/3] libbpf: Fix func leak in attach_kprobe
Date:   Wed, 21 Jul 2021 23:58:08 +0200
Message-Id: <20210721215810.889975-2-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210721215810.889975-1-jolsa@kernel.org>
References: <20210721215810.889975-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding missing free for func pointer in attach_kprobe function.

Reported-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/lib/bpf/libbpf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 4c153c379989..d46c2dd37be2 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -10431,6 +10431,7 @@ static struct bpf_link *attach_kprobe(const struct bpf_sec_def *sec,
 		return libbpf_err_ptr(err);
 	}
 	if (opts.retprobe && offset != 0) {
+		free(func);
 		err = -EINVAL;
 		pr_warn("kretprobes do not support offset specification\n");
 		return libbpf_err_ptr(err);
-- 
2.31.1

