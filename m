Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0DA355BE3
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 20:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233118AbhDFS6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 14:58:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231315AbhDFS6l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 14:58:41 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51782C06174A;
        Tue,  6 Apr 2021 11:58:31 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id j7so11971059qtx.5;
        Tue, 06 Apr 2021 11:58:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0k9ST6Sqw/pWXllPyrKJXa/iA6xjIOi51e4J0l+LPoY=;
        b=S8a/uDh3395wy3FV13q5iCO6nyhLa9VrO7pKfSZAvZHD1ck29dng/z9i8HohDB4AgS
         wRhxw8hIyg6miTVDoR5CmiHbPEKwEI8Xlz7KtloZJyvTEf+EWR6cjzYHZLgqu9uHSOJt
         0lXJ38C/4nprr+D74jPeaTNzJNH4V6vTZ9g5S0bN5jmLkyorHN/7lAVYHoqo8mqBTNem
         0XHlY9cySUGAk4xZ8eGPj76tZ0ABsZ5JBCEe407BXjzYOX3tTVvqv6GKq0x0yu/fF2us
         mdXzvEifGmtYxh1uDpRPFuD4e3Boz773k6p7Mb/l2ShxBjxcGfvPueuIQdgQ9lXYBlMe
         v7bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0k9ST6Sqw/pWXllPyrKJXa/iA6xjIOi51e4J0l+LPoY=;
        b=At2H6kqCZjmC00aDA5GvFPibm/arW6Epzxo7oABReUeOyokXnOi7jDvYgZejbPyb77
         3Qnid6PWzITwc8SdK/jEuZ7Ixde5/9zfudgTRuJKZkReduDrxbzD7HOMroB73BoiFsMo
         AkTfEdbYfGh9rC6N755/n3f5FPOSTeoItuEgq0XDnGB1ogLMdFZh05lrCOgZrvMG6H3z
         BP7T/oc7TsRBG9ZABypnKR+fobSov9tA2ENZUIn9+rTRh94lM2GhkEBEXfchY9j6Fmoo
         z9p92o3eOGRmRExf3K4xZrHbnpsyRvgQJGAn3E3AF4KwHeOrPTOFbtwX1A0raz5xEFGW
         S/Fg==
X-Gm-Message-State: AOAM531ySSd0Dy2QWoh3IBaDVLvvZFPpTrdPIf+whHYejY5fBF6g6urY
        5NTKzzDxbFqRc0tBSqixkUE=
X-Google-Smtp-Source: ABdhPJyf4bh9mz1y2J9Ik3gOUrtlRX3H2f8/H/McnUhMS4BYcOINMZH8MpEVx3JStN2zZs6L6CwtCw==
X-Received: by 2002:ac8:43cb:: with SMTP id w11mr29308676qtn.84.1617735510550;
        Tue, 06 Apr 2021 11:58:30 -0700 (PDT)
Received: from localhost.localdomain ([179.218.4.27])
        by smtp.gmail.com with ESMTPSA id 19sm14209579qtt.32.2021.04.06.11.58.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 11:58:30 -0700 (PDT)
From:   Pedro Tammela <pctammela@gmail.com>
X-Google-Original-From: Pedro Tammela <pctammela@mojatatu.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Joe Stringer <joe@cilium.io>,
        Quentin Monnet <quentin@isovalent.com>,
        netdev@vger.kernel.org (open list:BPF (Safe dynamic programs and tools)),
        bpf@vger.kernel.org (open list:BPF (Safe dynamic programs and tools)),
        linux-kernel@vger.kernel.org (open list)
Cc:     Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH bpf-next] libbpf: clarify flags in ringbuf helpers
Date:   Tue,  6 Apr 2021 15:58:04 -0300
Message-Id: <20210406185806.377576-1-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In 'bpf_ringbuf_reserve()' we require the flag to '0' at the moment.

For 'bpf_ringbuf_{discard,submit,output}' a flag of '0' might send a
notification to the process if needed.

Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 include/uapi/linux/bpf.h       | 7 +++++++
 tools/include/uapi/linux/bpf.h | 7 +++++++
 2 files changed, 14 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 49371eba98ba..8c5c7a893b87 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4061,12 +4061,15 @@ union bpf_attr {
  * 		of new data availability is sent.
  * 		If **BPF_RB_FORCE_WAKEUP** is specified in *flags*, notification
  * 		of new data availability is sent unconditionally.
+ * 		If **0** is specified in *flags*, notification
+ * 		of new data availability is sent if needed.
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
  * void *bpf_ringbuf_reserve(void *ringbuf, u64 size, u64 flags)
  * 	Description
  * 		Reserve *size* bytes of payload in a ring buffer *ringbuf*.
+ * 		*flags* must be 0.
  * 	Return
  * 		Valid pointer with *size* bytes of memory available; NULL,
  * 		otherwise.
@@ -4078,6 +4081,8 @@ union bpf_attr {
  * 		of new data availability is sent.
  * 		If **BPF_RB_FORCE_WAKEUP** is specified in *flags*, notification
  * 		of new data availability is sent unconditionally.
+ * 		If **0** is specified in *flags*, notification
+ * 		of new data availability is sent if needed.
  * 	Return
  * 		Nothing. Always succeeds.
  *
@@ -4088,6 +4093,8 @@ union bpf_attr {
  * 		of new data availability is sent.
  * 		If **BPF_RB_FORCE_WAKEUP** is specified in *flags*, notification
  * 		of new data availability is sent unconditionally.
+ * 		If **0** is specified in *flags*, notification
+ * 		of new data availability is sent if needed.
  * 	Return
  * 		Nothing. Always succeeds.
  *
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 69902603012c..51df1bd45cef 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -4061,12 +4061,15 @@ union bpf_attr {
  * 		of new data availability is sent.
  * 		If **BPF_RB_FORCE_WAKEUP** is specified in *flags*, notification
  * 		of new data availability is sent unconditionally.
+ * 		If **0** is specified in *flags*, notification
+ * 		of new data availability is sent if needed.
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
  * void *bpf_ringbuf_reserve(void *ringbuf, u64 size, u64 flags)
  * 	Description
  * 		Reserve *size* bytes of payload in a ring buffer *ringbuf*.
+ * 		*flags* must be 0.
  * 	Return
  * 		Valid pointer with *size* bytes of memory available; NULL,
  * 		otherwise.
@@ -4078,6 +4081,8 @@ union bpf_attr {
  * 		of new data availability is sent.
  * 		If **BPF_RB_FORCE_WAKEUP** is specified in *flags*, notification
  * 		of new data availability is sent unconditionally.
+ * 		If **0** is specified in *flags*, notification
+ * 		of new data availability is sent if needed.
  * 	Return
  * 		Nothing. Always succeeds.
  *
@@ -4088,6 +4093,8 @@ union bpf_attr {
  * 		of new data availability is sent.
  * 		If **BPF_RB_FORCE_WAKEUP** is specified in *flags*, notification
  * 		of new data availability is sent unconditionally.
+ * 		If **0** is specified in *flags*, notification
+ * 		of new data availability is sent if needed.
  * 	Return
  * 		Nothing. Always succeeds.
  *
-- 
2.25.1

