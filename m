Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D589669FD7
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 02:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733063AbfGPA1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 20:27:07 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40521 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733050AbfGPA1F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 20:27:05 -0400
Received: by mail-pf1-f193.google.com with SMTP id p184so8191890pfp.7;
        Mon, 15 Jul 2019 17:27:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lHXwXU0/ATDXmjadbsFTu4ODiT77+7Iga+kAcGBhKe8=;
        b=py0mACJL7L5TTVvR42E0xxYfnzpz2EGuQQr5T+gcVzTLF4nqKwdD2WLsUT6gst3yiu
         iJQo/19c4/WLUSvv/zogI1KKGBuMgCcKX7uPYZi85G6VIBpjo/BXz9oApZ+yqeT/9zZ8
         BOLGqUo0XXng+de6ud9esooAR0dZ6pDiRxbNc45/F3TdovriKvKzidr9yNIXZt4DeZoO
         RevnTjW8RSmQRMSlDMUCZW93N/4mXz1NJEvjwDUBPr8l894U+qVIy+qD0ScKnhl7CXWv
         5X/KlvDERr+P25reui3d7FE5y/DuZowtJKvaACY0l17Jqw1tEsy8qbyXLNmwrHLM+juK
         8dTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lHXwXU0/ATDXmjadbsFTu4ODiT77+7Iga+kAcGBhKe8=;
        b=k3VbUZnRplpJwYYf7uFGtyk21e/xeUSijDN1FyOKLbSv/e3LikhkWLZxN3NhZ9zjHI
         r5tWAfKGLBh9oW8SJIWduQJSg5ClbZiRvWZoPGIpORV5KsHePul/yQOzDRZSXSD3XnT1
         PL7c0bXlD9Cr9uG/L5bV4jJEqOdgRq9DWVW4/by4vuFf++vgCT3tXAmZH0feAmj2dcqj
         Aw4eYzgH+hPOeskCtJJeCO428bv5UqVyEZSgvUHIUhENjp9DHdhfO46d7OB0xXzQftWz
         Scf474K2dcK2eAXgvO01l28KN8RZypnXsPiLVNU/jNTPzJe/TekkNV93U9sFcD/GkA0j
         /ecQ==
X-Gm-Message-State: APjAAAU95KfdD9pKdHssGBunI+/22P4p9tEULZeTbVDhyAFLaAN0ASo0
        inKIoYHFNZ9iDYSqTDy0l1NTmgTC
X-Google-Smtp-Source: APXvYqzYrsOhiNM1Wy8qfXjjjihBJUOzXL14wazvbwQdbf3n5yfog9dMl52wP8tmOsuvuHv1/bUPKg==
X-Received: by 2002:a17:90a:23ce:: with SMTP id g72mr1233726pje.77.1563236824783;
        Mon, 15 Jul 2019 17:27:04 -0700 (PDT)
Received: from ppenkov.svl.corp.google.com ([2620:15c:2c4:201:7bd4:4f27:abe4:d695])
        by smtp.gmail.com with ESMTPSA id q24sm16775444pjp.14.2019.07.15.17.27.04
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 15 Jul 2019 17:27:04 -0700 (PDT)
From:   Petar Penkov <ppenkov.kernel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        edumazet@google.com, lmb@cloudflare.com, sdf@google.com,
        Petar Penkov <ppenkov@google.com>
Subject: [bpf-next RFC 5/6] selftests/bpf: bpf_tcp_gen_syncookie->bpf_helpers
Date:   Mon, 15 Jul 2019 17:26:49 -0700
Message-Id: <20190716002650.154729-6-ppenkov.kernel@gmail.com>
X-Mailer: git-send-email 2.22.0.510.g264f2c817a-goog
In-Reply-To: <20190716002650.154729-1-ppenkov.kernel@gmail.com>
References: <20190716002650.154729-1-ppenkov.kernel@gmail.com>
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
2.22.0.510.g264f2c817a-goog

