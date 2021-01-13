Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACE722F4402
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 06:41:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbhAMFjg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 00:39:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725831AbhAMFjf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 00:39:35 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 883BAC061575;
        Tue, 12 Jan 2021 21:38:55 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id y187so445873wmd.3;
        Tue, 12 Jan 2021 21:38:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sOEdwXA/h+SBmwBHnYP/ZvUfcO/YreqoifWYhsKYDOQ=;
        b=JxV5jc+I66VH6OnmSZ0DNsEivAzVgVEE2RZbFpfKUUtgKB8eH0EI6HiveOkMWv/WBI
         ERKZn/kQDVgHXkMDPRY1JY3/8e/5RmNqsXMAUbhJ2uQQ2V+WfnEqDi6WMTj1SpdjI5os
         +cweG6JJF2oozui8zZvgRXNBnD/uG4JSnkovyjqeH5iIeu5ZDnMRfKNiGwR7bebA8+yq
         4d3a1TP1vE3gSrwhQqoQGytJv/nJw5yEmohMrF2xrDXZUeq2bI8iKSdEwt+rKraqLokX
         vcdcnX4gwjO99vOpvl6TAK6f+NX++iiHPq9Yo1Q1V+opDA3J4T3ROCVR7tG6IDrLdHQq
         CeEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sOEdwXA/h+SBmwBHnYP/ZvUfcO/YreqoifWYhsKYDOQ=;
        b=PfIZaTwGXuLIm1tWXRX5WPITPoEVqT4zqRG/O5YqqtzQHtzgc3EKNK5doNpx8MSyJl
         b9SA6S1c/458UnlaK4Y3/8GBNxxtyXxCOXC6LKAgLvdmLNf8iJloqBfe0GZXYySWkxIo
         Gr+P7m+qPaV0XGBJCv4LgaorE9VRPt7ctva79r0Li5XTAx/cLK5dlFgDt+xRyW6S59oQ
         KpY65XVwzTu7w5pkLgyLfroq0kLkaxeQaphwTIj2+28bDkC1xBgigAdRoVtrPIPbnwT5
         cJtlwYhJ8u1Uz3Gmu85zjKopPVIg6bfEPnj6r9lJ+5VeZKKXetRjk41Mu6nUQXR7JIKG
         KOkQ==
X-Gm-Message-State: AOAM530ewR0VzOlU2+EKdxj0uZhMwtafnUqfMEDJgT/8vAVp1YmYrCN7
        BS7cwHDjefbOT6x4xnMiseJCBJxntRJPXHuoazQ=
X-Google-Smtp-Source: ABdhPJzbX+Yub4MaNqX/Ku7mH06fw+kodnjPll4VTJcGNwDZzP2jCXMwl8hTcmvcPTsN3gl+tmjlSw==
X-Received: by 2002:a7b:c8c5:: with SMTP id f5mr441105wml.106.1610516333825;
        Tue, 12 Jan 2021 21:38:53 -0800 (PST)
Received: from ubuntu.localdomain (bzq-233-168-31-62.red.bezeqint.net. [31.168.233.62])
        by smtp.googlemail.com with ESMTPSA id 138sm1136487wma.41.2021.01.12.21.38.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 21:38:53 -0800 (PST)
From:   Gilad Reti <gilad.reti@gmail.com>
To:     bpf@vger.kernel.org
Cc:     gilad.reti@gmail.com, Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH bpf v2 1/2] bpf: support PTR_TO_MEM{,_OR_NULL} register spilling
Date:   Wed, 13 Jan 2021 07:38:07 +0200
Message-Id: <20210113053810.13518-1-gilad.reti@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for pointer to mem register spilling, to allow the verifier
to track pointers to valid memory addresses. Such pointers are returned
for example by a successful call of the bpf_ringbuf_reserve helper.

The patch was partially contributed by CyberArk Software, Inc.

Fixes: 457f44363a88 ("bpf: Implement BPF ring buffer and verifier support for it")
Suggested-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Gilad Reti <gilad.reti@gmail.com>
---
 kernel/bpf/verifier.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 17270b8404f1..36af69fac591 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2217,6 +2217,8 @@ static bool is_spillable_regtype(enum bpf_reg_type type)
 	case PTR_TO_RDWR_BUF:
 	case PTR_TO_RDWR_BUF_OR_NULL:
 	case PTR_TO_PERCPU_BTF_ID:
+	case PTR_TO_MEM:
+	case PTR_TO_MEM_OR_NULL:
 		return true;
 	default:
 		return false;
-- 
2.27.0

