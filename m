Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B594180D26
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 02:09:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727909AbgCKBJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 21:09:28 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51029 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbgCKBJ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 21:09:28 -0400
Received: by mail-wm1-f68.google.com with SMTP id a5so298546wmb.0;
        Tue, 10 Mar 2020 18:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=s3SzbnYdZVe4q+XUx8QQoIEDKuVKKcXtBja4UTxQRV0=;
        b=Rp6AhCQPw6Q9uSi5FnFtArlq9SF2DJXKfWE6xjdcm4quRXLBO7TMo4/Xb3vsNDfwlm
         /5+g5yC5BuV65BZ/DW2YRxffwP67uGD2cqIFS5dgiCmJdKUnMV9PE+0SlnGMGHVAgjTw
         2XuorM3JJf241UPzWyYvqi0Tt6i/2fcDHyI53sCJl7tYYDPw6Jj1mrbfbCnkOKOZTInq
         rFyRHoV8zNSDfsPioOsmWuKOWZdWbLUVH/uXUyVRUNBKs2xmnlhgzkonN7ySFUge/dTv
         D7HTRoKRlkpkAB11fGLhK4vLhRgj0ZFyOSUIbMrHdUd5VDi2Qmxnxfr72LPiQ5boS9CA
         G8+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s3SzbnYdZVe4q+XUx8QQoIEDKuVKKcXtBja4UTxQRV0=;
        b=W+VZCifMOoGzeFnMZdQ+vv+tGqVRjXIcZvOrf7gzGsGZ59JyFuZU3ijLYDc+KJvti2
         alMGD4RFsdOecsie0pzPguLHEv5uNXLVKxTVkjl4+J99uXvg4wXds6hlPMxhhq9yn1T2
         Rz3UoBv7WeDT2ku3qCOfvVseSBPlnltE5MSCVU/bcnErGsHJ3m0ErGD/CFtxUpYBktKZ
         0hfruKjqNR0CmgZQ/KYIw515EJsOwuhzbb/sFU3k53X3nnrFnJhR2xMGT2M1+zE+zDFZ
         xWm+5DBfV9O0Ib2QoFynk36eBwMjpncXL5jlytwMUMRvFIu9W6/PfkAG2kDTZO8rB+Hw
         tJ5g==
X-Gm-Message-State: ANhLgQ2NI77Z9wa0dExkYlWd0PRBLf6nJWzBsGIOy3VfaTF90grd1d7F
        mW2M6mPO/DhyktmaqFdMZw==
X-Google-Smtp-Source: ADFU+vvzlowYAs4eRbIs70YZ79xWs/WTRV60RYU3X8HmQ7dSN3ddd9my0M3iC1UGksqc0Epvw8R1fA==
X-Received: by 2002:a1c:f606:: with SMTP id w6mr409287wmc.109.1583888965751;
        Tue, 10 Mar 2020 18:09:25 -0700 (PDT)
Received: from ninjahost.lan (host-2-102-15-144.as13285.net. [2.102.15.144])
        by smtp.googlemail.com with ESMTPSA id i6sm36658097wra.42.2020.03.10.18.09.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 18:09:25 -0700 (PDT)
From:   Jules Irenge <jbi.octave@gmail.com>
To:     boqun.feng@gmail.com
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH 1/8] bpf: Add missing annotations for __bpf_prog_enter() and  __bpf_prog_exit()
Date:   Wed, 11 Mar 2020 01:09:01 +0000
Message-Id: <20200311010908.42366-2-jbi.octave@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200311010908.42366-1-jbi.octave@gmail.com>
References: <0/8>
 <20200311010908.42366-1-jbi.octave@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sparse reports a warning at __bpf_prog_enter() and __bpf_prog_exit()

warning: context imbalance in __bpf_prog_enter() - wrong count at exit
warning: context imbalance in __bpf_prog_exit() - unexpected unlock

The root cause is the missing annotation at __bpf_prog_enter()
and __bpf_prog_exit()

Add the missing __acquires(RCU) annotation
Add the missing __releases(RCU) annotation

Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
---
 kernel/bpf/trampoline.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 6b264a92064b..09bce10ad1cc 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -374,6 +374,7 @@ void bpf_trampoline_put(struct bpf_trampoline *tr)
  * call __bpf_prog_exit
  */
 u64 notrace __bpf_prog_enter(void)
+	__acquires(RCU)
 {
 	u64 start = 0;
 
@@ -385,6 +386,7 @@ u64 notrace __bpf_prog_enter(void)
 }
 
 void notrace __bpf_prog_exit(struct bpf_prog *prog, u64 start)
+	__releases(RCU)
 {
 	struct bpf_prog_stats *stats;
 
-- 
2.24.1

