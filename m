Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02CF735D105
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 21:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237157AbhDLTZz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 15:25:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237137AbhDLTZz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 15:25:55 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E9A9C061574;
        Mon, 12 Apr 2021 12:25:36 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id 7so15449492qka.7;
        Mon, 12 Apr 2021 12:25:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EAOBbEIZlFDzXoi0Sp9FWL3CYelnvTw/J4PVfYOgrZk=;
        b=uNznQpSuXYdrtTvTibDNk1OknoGzngDinSUmjuZbcAFNgiy/aocOUTMEdbFnRig3yz
         cBe4DVF/4ykUXy7zVFVV4FgeZ/CK+rBBbFCvkdwBchDcgbZS40t6I/gH7nbAbdhxB+lf
         MwO2Ffg++S0JRl2lrL8sK0HOQpPOXAI57XFiu6vkkR7C4DHR2qDKdHTZOk7G/eiMaOzc
         xbgj/xmdoUFS+4ycK5E54VP3yBZtvToH/0UaMxZJwoZ/B3c+0R06PMSJPemAjvJ7qBvO
         esYnF4AD0T5YFg74d05qAgqtGbzhId/7OYh7a8otS+X5GpdPmHLmrF2RlUWHPLj+jzi+
         Cn4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EAOBbEIZlFDzXoi0Sp9FWL3CYelnvTw/J4PVfYOgrZk=;
        b=So6pZAZzqj/rp9Qhx09KvNsjXepkWJJvzWVwQwFfo+P+rXwAShF2YQfYxDfGGcvBO+
         Q+tXRHS4M1sEFZzq3QvGADvXa5VkQDd/qbBJBjHkAhRQHQAV+lQ+I/A6G+WA+RQRXHST
         B3pTasxkioOaf+beBKzseym4JtdCNrnahLkW2wtb71jYp1IZmT1xfe5kWu2h9cYG+Gyg
         Zpx2m4XYubkF/WR38y8lSTPK5BvPAWod4JKcHgWhJ3xQvGLRDGrvW1sbxwzO70xURLZy
         7m4m5XFfj/btRS0o13axs7ZQ2NTKRW5QVlEpXXnKRXDHUmjseojG3FgQ28UEoDfyf0LS
         enXw==
X-Gm-Message-State: AOAM5314L5E33npwXht8d7PF671rtRRqBuGPmL1z+mdxa5xleSME/lWH
        pkl4U4pzY3GrnKo1vu639XE=
X-Google-Smtp-Source: ABdhPJyzQZvikmtooDGKaaUlhXS4ZfppmEozmQBQ86q8I57sjs+dzXsaVe1JlRdJHwNH102o1asWdA==
X-Received: by 2002:a37:e30c:: with SMTP id y12mr11556664qki.33.1618255535792;
        Mon, 12 Apr 2021 12:25:35 -0700 (PDT)
Received: from localhost.localdomain ([179.218.4.27])
        by smtp.gmail.com with ESMTPSA id l16sm3841679qtr.65.2021.04.12.12.25.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 12:25:35 -0700 (PDT)
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
Subject: [PATCH bpf-next v2] libbpf: clarify flags in ringbuf helpers
Date:   Mon, 12 Apr 2021 16:24:32 -0300
Message-Id: <20210412192434.944343-1-pctammela@mojatatu.com>
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
 include/uapi/linux/bpf.h       | 16 ++++++++++++++++
 tools/include/uapi/linux/bpf.h | 16 ++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 49371eba98ba..24593fd72f9d 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4061,12 +4061,20 @@ union bpf_attr {
  * 		of new data availability is sent.
  * 		If **BPF_RB_FORCE_WAKEUP** is specified in *flags*, notification
  * 		of new data availability is sent unconditionally.
+ * 		If **0** is specified in *flags*, an adaptive notification
+ * 		of new data availability is sent.
+ *
+ * 		An adaptive notification is a notification sent whenever the user-space
+ * 		process has caught up and consumed all available payloads. In case the user-space
+ * 		process is still processing a previous payload, then no notification is needed
+ * 		as it will process the newly added payload automatically.
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
@@ -4078,6 +4086,10 @@ union bpf_attr {
  * 		of new data availability is sent.
  * 		If **BPF_RB_FORCE_WAKEUP** is specified in *flags*, notification
  * 		of new data availability is sent unconditionally.
+ * 		If **0** is specified in *flags*, an adaptive notification
+ * 		of new data availability is sent.
+ *
+ * 		See 'bpf_ringbuf_output()' for the definition of adaptive notification.
  * 	Return
  * 		Nothing. Always succeeds.
  *
@@ -4088,6 +4100,10 @@ union bpf_attr {
  * 		of new data availability is sent.
  * 		If **BPF_RB_FORCE_WAKEUP** is specified in *flags*, notification
  * 		of new data availability is sent unconditionally.
+ * 		If **0** is specified in *flags*, an adaptive notification
+ * 		of new data availability is sent.
+ *
+ * 		See 'bpf_ringbuf_output()' for the definition of adaptive notification.
  * 	Return
  * 		Nothing. Always succeeds.
  *
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 69902603012c..8debc8280f3e 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -4061,12 +4061,20 @@ union bpf_attr {
  * 		of new data availability is sent.
  * 		If **BPF_RB_FORCE_WAKEUP** is specified in *flags*, notification
  * 		of new data availability is sent unconditionally.
+ * 		If **0** is specified in *flags*, an adaptive notification
+ * 		of new data availability is sent.
+ *
+ * 		An adaptive notification is a notification sent whenever the user-space
+ * 		process has caught up and consumed all available payloads. In case the user-space
+ * 		process is still processing a previous payload, then no notification is needed
+ * 		as it will process the newly added payload automatically.
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
@@ -4078,6 +4086,10 @@ union bpf_attr {
  * 		of new data availability is sent.
  * 		If **BPF_RB_FORCE_WAKEUP** is specified in *flags*, notification
  * 		of new data availability is sent unconditionally.
+ * 		If **0** is specified in *flags*, an adaptive notification
+ * 		of new data availability is sent.
+ *
+ * 		See 'bpf_ringbuf_output()' for the definition of adaptive notification.
  * 	Return
  * 		Nothing. Always succeeds.
  *
@@ -4088,6 +4100,10 @@ union bpf_attr {
  * 		of new data availability is sent.
  * 		If **BPF_RB_FORCE_WAKEUP** is specified in *flags*, notification
  * 		of new data availability is sent unconditionally.
+ * 		If **0** is specified in *flags*, an adaptive notification
+ * 		of new data availability is sent.
+ *
+ * 		See 'bpf_ringbuf_output()' for the definition of adaptive notification.
  * 	Return
  * 		Nothing. Always succeeds.
  *
-- 
2.25.1

