Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5E3831D3A0
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 02:12:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231518AbhBQBKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 20:10:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231403AbhBQBJS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 20:09:18 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E66F2C061756;
        Tue, 16 Feb 2021 17:08:37 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id z7so6499040plk.7;
        Tue, 16 Feb 2021 17:08:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6/SzyQ0ReKPIhC/d4qfT0iwh1ZBZem+Ch9avlwoAplk=;
        b=gVnZvIlKzpHKIv/8B++qGAch2hWjjuAY1tyLdFMDnzQfrhLdF5U8XbT83gLbcI/dUd
         fqxX6Xq/fSQJZjgEiqCoqL5IUF3WXD4c/nrrVdKMT+bwJoS3ufwu6aaB7BouMg5dpWAn
         dCtcA/Q5OC250smc2vFahPGHDCQGt7HO8c4KexdFYTOzNPezGxq/sQMxsTRCuWocobtT
         XqcQkPkYg9w9TjFpsQkXbSl9fSpkxE7gNMfA7GYDB/zx21SAOcgASlu6uW16Q3jxbNIi
         YoWKCUEnFb/3iEGGiMi08btgfMW9nnKE/pWd5SVh9bkE1t6yscWy85dku8ot1q1ybWjv
         lyzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=6/SzyQ0ReKPIhC/d4qfT0iwh1ZBZem+Ch9avlwoAplk=;
        b=VU/oSesLVM2Iievs6jeVQeqkpAkU66GzVpA1BXZCYj6l0N8lnJs19DWS38ofZ5PQjO
         hAp9E5M/RHTogRD07cFJckPKt3kuHnncZjlajsdIrvU5UuE7PGBk7s9WcgmTzOAEclKy
         GAjS/ffbxKM+aOQZrWtoXHuOcqNYXvI74ggMKwVbUi9Ya6k+INu+e/DzkbL/c7ooM/c3
         isYzlTfkt2UjBTH6sdNv2koxQ2JoApmNLuYG9ZQD+rGGkhNury4+ko9ZnUdt0dVwyxBx
         l5wcsh84rCNbNNcChG+9dF8jQZPYpb/GS7VtHoVCGAjFbBco/TiGZUD4ifwTAv7foTju
         7HCA==
X-Gm-Message-State: AOAM532lSgbJyfcHB2A1IfbYw9r8Ux62YDZ4ZA3aw8a/kkDdh5gURORb
        JpKBmgKzoGeZ2thRpJtAe26u9kpTC5xwXA==
X-Google-Smtp-Source: ABdhPJyE0N+JiSpIVEpOkxXqEYEalGq51I4TjyvRLTNjKOHAYiwjIcyuuX2nLBaznQsTcVxsetj4Yg==
X-Received: by 2002:a17:90a:7025:: with SMTP id f34mr6640089pjk.116.1613524117225;
        Tue, 16 Feb 2021 17:08:37 -0800 (PST)
Received: from localhost.localdomain (c-73-93-5-123.hsd1.ca.comcast.net. [73.93.5.123])
        by smtp.gmail.com with ESMTPSA id c22sm175770pfc.12.2021.02.16.17.08.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 17:08:36 -0800 (PST)
Sender: Joe Stringer <joestringernz@gmail.com>
From:   Joe Stringer <joe@wand.net.nz>
To:     bpf@vger.kernel.org
Cc:     Joe Stringer <joe@cilium.io>, netdev@vger.kernel.org,
        daniel@iogearbox.net, ast@kernel.org, mtk.manpages@gmail.com,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 06/17] bpf: Document BPF_PROG_TEST_RUN syscall command
Date:   Tue, 16 Feb 2021 17:08:10 -0800
Message-Id: <20210217010821.1810741-7-joe@wand.net.nz>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210217010821.1810741-1-joe@wand.net.nz>
References: <20210217010821.1810741-1-joe@wand.net.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Stringer <joe@cilium.io>

Based on a brief read of the corresponding source code.

Reviewed-by: Quentin Monnet <quentin@isovalent.com>
Signed-off-by: Joe Stringer <joe@cilium.io>
---
 include/uapi/linux/bpf.h | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 603605c5ca03..86fe0445c395 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -303,14 +303,22 @@ union bpf_iter_link_info {
  *
  * BPF_PROG_TEST_RUN
  *	Description
- *		Run an eBPF program a number of times against a provided
- *		program context and return the modified program context and
- *		duration of the test run.
+ *		Run the eBPF program associated with the *prog_fd* a *repeat*
+ *		number of times against a provided program context *ctx_in* and
+ *		data *data_in*, and return the modified program context
+ *		*ctx_out*, *data_out* (for example, packet data), result of the
+ *		execution *retval*, and *duration* of the test run.
  *
  *	Return
  *		Returns zero on success. On error, -1 is returned and *errno*
  *		is set appropriately.
  *
+ *		**ENOSPC**
+ *			Either *data_size_out* or *ctx_size_out* is too small.
+ *		**ENOTSUPP**
+ *			This command is not supported by the program type of
+ *			the program referred to by *prog_fd*.
+ *
  * BPF_PROG_GET_NEXT_ID
  *	Description
  *		Fetch the next eBPF program currently loaded into the kernel.
-- 
2.27.0

