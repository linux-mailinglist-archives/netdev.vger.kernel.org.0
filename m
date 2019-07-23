Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51C1A70E08
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 02:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387656AbfGWAUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 20:20:54 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42821 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbfGWAUx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 20:20:53 -0400
Received: by mail-pf1-f195.google.com with SMTP id q10so18154208pff.9;
        Mon, 22 Jul 2019 17:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OAQCMm+LvmDbxVAKgZ82b3sMjfuFQxNO8tF7DCZWALE=;
        b=lZ0j/NuvR5Wv0CgxRgTh4/VUiiVElb4YeiiXLzstbl0LYS9IRon1BQorVanQeJ0Ej1
         gmFIM32eGdcphIg5JWurl+IbF7HlcFdj9Cl3lIwtfADIAWCUGFgH7+uybRUmlp/XmDcZ
         futyampQdOPPFU3CSwCjHulGiQmXWjQ+KIbWi6ID8q2l8LnDjYt+0FC1Dt0sZZS+aFNJ
         0aL7YW9Yki+YNbZ7Hcwg1YleujexvOc750CrmZoBKlKYonpBAC7LXyRu/lRvLQzYcGet
         OSNlSFl0MLI9+kNMq2nOVIpA1iq3sudm89vziURjkMa1TUyAPn/Aqk4h+oWyJG5kU5UN
         jC6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OAQCMm+LvmDbxVAKgZ82b3sMjfuFQxNO8tF7DCZWALE=;
        b=Xez+6MLlJpWEeBrmCJEoJ/63TRppX0VK/I6wevGPKRNXAUE38mryFxsuzTO2FBFZ/i
         hKKjQ51wUhN7hLotitZX+o/01/wm9Uy9QnVTslWXiR1p0/LRTcZpAVNPMDuy6e+z6Da7
         Rnb4RAK7rPjLnWpHXlmE63An4G3tos6CBkfYtFL9//+Xe4aWjtMFsczCWLdhqH+nE1Eo
         QjE3pombUDK56wZUhOVTq1RvTys0QWdCj3hCSO41zjcfvsipXvtv/P28tYEe9i8D+kME
         xaakaPflbrqvfPn7k3E3+Wzaz5OmsTUCnFUD/lNIJxUW3nx78/LP6D8jd4VM7ppxS/q+
         22vA==
X-Gm-Message-State: APjAAAXILSk3ONEjweRgAgNdkjYYGXMQ2dUB47aEk21uWLWVy8M6tDV3
        wOUkQj53h0RgKi0JtCOH/5cV8O6I
X-Google-Smtp-Source: APXvYqwFsgiHMWSMJNrq0UcALH0FFDeMkPYjYcUvXBzqJNLRTM3b0fpUwdyEl5rpy19hDOezBBgjIA==
X-Received: by 2002:a63:3009:: with SMTP id w9mr75920339pgw.260.1563841252476;
        Mon, 22 Jul 2019 17:20:52 -0700 (PDT)
Received: from ppenkov.svl.corp.google.com ([2620:15c:2c4:201:7bd4:4f27:abe4:d695])
        by smtp.gmail.com with ESMTPSA id k64sm21718423pge.65.2019.07.22.17.20.51
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 22 Jul 2019 17:20:52 -0700 (PDT)
From:   Petar Penkov <ppenkov.kernel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        edumazet@google.com, lmb@cloudflare.com, sdf@google.com,
        Petar Penkov <ppenkov@google.com>
Subject: [bpf-next 5/6] selftests/bpf: bpf_tcp_gen_syncookie->bpf_helpers
Date:   Mon, 22 Jul 2019 17:20:41 -0700
Message-Id: <20190723002042.105927-6-ppenkov.kernel@gmail.com>
X-Mailer: git-send-email 2.22.0.657.g960e92d24f-goog
In-Reply-To: <20190723002042.105927-1-ppenkov.kernel@gmail.com>
References: <20190723002042.105927-1-ppenkov.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petar Penkov <ppenkov@google.com>

Expose bpf_tcp_gen_syncookie to selftests.

Signed-off-by: Petar Penkov <ppenkov@google.com>
---
 tools/testing/selftests/bpf/bpf_helpers.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
index 5a3d92c8bec8..19f01e967402 100644
--- a/tools/testing/selftests/bpf/bpf_helpers.h
+++ b/tools/testing/selftests/bpf/bpf_helpers.h
@@ -228,6 +228,9 @@ static void *(*bpf_sk_storage_get)(void *map, struct bpf_sock *sk,
 static int (*bpf_sk_storage_delete)(void *map, struct bpf_sock *sk) =
 	(void *)BPF_FUNC_sk_storage_delete;
 static int (*bpf_send_signal)(unsigned sig) = (void *)BPF_FUNC_send_signal;
+static long long (*bpf_tcp_gen_syncookie)(struct bpf_sock *sk, void *ip,
+					  int ip_len, void *tcp, int tcp_len) =
+	(void *) BPF_FUNC_tcp_gen_syncookie;
 
 /* llvm builtin functions that eBPF C program may use to
  * emit BPF_LD_ABS and BPF_LD_IND instructions
-- 
2.22.0.657.g960e92d24f-goog

