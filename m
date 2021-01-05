Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D98C02EAAAC
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 13:28:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729525AbhAEM0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 07:26:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729000AbhAEMZ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 07:25:56 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9079C0617A4
        for <netdev@vger.kernel.org>; Tue,  5 Jan 2021 04:24:35 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id r3so36018599wrt.2
        for <netdev@vger.kernel.org>; Tue, 05 Jan 2021 04:24:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=u0kBDkZSof0LwbMWuYCOPhj4hHVMvwb36KmGU51ii7Y=;
        b=ND819YouqBX2OWqXMdqdQeyowrfISKhBPc2XrLPMSsEl7svulPDlyyq3EkBtNbL33u
         TDaKNAZRhQCDcM6g7W1VV86CZMsGPo/Xj6o9ovlgTu1Dkia9VLQEAhbNY9nR9vAFrfOF
         fgoEuPBj4FgxID677UG7GgUc9XU/RXpFh/gbm7eTWT5Nri3rbP72bDPpaO6Sm9HCNgI3
         3NSpgM2+U6guAItcMAeEWlToNz5eKPh3fU1yovidq2zYfknj0ya64YVX6h9x0A8df3W+
         2aGD7YS/4qoFccPopziAfM1EXWE23Jv2Hdf4xMOmznant61CMaghciMWLZOQMjrSc6PP
         LOEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=u0kBDkZSof0LwbMWuYCOPhj4hHVMvwb36KmGU51ii7Y=;
        b=BYQ5vS6Acx3ONhgexG6TC+dxiSTbnHNHJDUBzWKFYmtV1aCsbpc61KQ9dpxiR2EgJd
         bMybaNDWdZ7JsfQAmtJlln1QuPKfxaKGWxWJtMGi6XGFzIry7DMvM3nwuyBvxyHdXDB8
         vi73IIzrLwfH/q6NX9UehvyD1eqvcUHMSmlaAHbuZjtNtKMYA6Uh3wVki9WSemXE6O61
         /lLUKiVWV6liKEHDqtMXpB0IKw1XJ57k5/e5TIAgUbeVAcGWq66uofAFdu+aPu12KB/W
         /3xnaHpZEOxEiddZKiErpzzvAf/tnFXIzuX7YHGoHz1YJnJp2fmvmVda1tseOJ2JT8AD
         ptmA==
X-Gm-Message-State: AOAM533ZxW4tw/QdEAJoWZg2xiY1A8+3mV7DgauE2x6ZR06uA9sO9/Is
        InKfVFuIXOD05tZRn8Y22n/43Q==
X-Google-Smtp-Source: ABdhPJyJfqvsRJHDTSpaa9QAkR2GGFTavM6RbFaNNqtKETNWn4GmNRmrqwUcSVEVi1csBmRIq/qoBg==
X-Received: by 2002:a5d:56c3:: with SMTP id m3mr84858735wrw.419.1609849474478;
        Tue, 05 Jan 2021 04:24:34 -0800 (PST)
Received: from f2.redhat.com (bzq-79-183-72-147.red.bezeqint.net. [79.183.72.147])
        by smtp.gmail.com with ESMTPSA id 138sm4242281wma.41.2021.01.05.04.24.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 05 Jan 2021 04:24:33 -0800 (PST)
From:   Yuri Benditovich <yuri.benditovich@daynix.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     yan@daynix.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: [RFC PATCH 4/7] tun: free bpf_program by bpf_prog_put instead of bpf_prog_destroy
Date:   Tue,  5 Jan 2021 14:24:13 +0200
Message-Id: <20210105122416.16492-5-yuri.benditovich@daynix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210105122416.16492-1-yuri.benditovich@daynix.com>
References: <20210105122416.16492-1-yuri.benditovich@daynix.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The module never creates the bpf program with bpf_prog_create
so it shouldn't free it with bpf_prog_destroy.
The program is obtained by bpf_prog_get and should be freed
by bpf_prog_put. For BPF_PROG_TYPE_SOCKET_FILTER both
methods do the same but for other program types they don't.

Signed-off-by: Yuri Benditovich <yuri.benditovich@daynix.com>
---
 drivers/net/tun.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 455f7afc1f36..18c1baf1a6c1 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -2218,7 +2218,7 @@ static void tun_prog_free(struct rcu_head *rcu)
 {
 	struct tun_prog *prog = container_of(rcu, struct tun_prog, rcu);
 
-	bpf_prog_destroy(prog->prog);
+	bpf_prog_put(prog->prog);
 	kfree(prog);
 }
 
-- 
2.17.1

