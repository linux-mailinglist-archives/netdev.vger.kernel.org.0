Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A66F9305172
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 05:52:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239178AbhA0Ece (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 23:32:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232525AbhA0DEW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 22:04:22 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59D3FC0617A7;
        Tue, 26 Jan 2021 18:25:20 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id o20so229777pfu.0;
        Tue, 26 Jan 2021 18:25:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=joDhYr4WwYIa6lTFlqLJ0z3vbyBAAz6QSsz7f9MoAT0=;
        b=IQHJWZYVacOMsK096C8npqb57WhF9GsyIaKrsd2VR5on07xkS3mYrUm7ry3hHTyGzv
         kslNVsQNyIvsTaXnEpvcqjT3I0LOf1fvW+YbF7eQrE24Ukpd9yvwsQBSS06BGRbnpzpS
         3hHH/+yHrTpOKYsmdHmgacKwyxYHtnZ1qgP/5A0EQ80DDUt8lYtg3h7iVya/+gZobnEg
         hoFiXnYo4FCsSH1J8qiNDIzHPjozqgaGT2Jp5UZNNqDQbpmvGk1jA1oyIauCvvy/J9kD
         iJ8WEGfdX12W8p9LuuOq8AVT57fWZkfATrteTyNcC4yqp0Xv0uz4Yh0KV1+sr+crVQN3
         8guw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=joDhYr4WwYIa6lTFlqLJ0z3vbyBAAz6QSsz7f9MoAT0=;
        b=Ch+XYVk2WE5KCkTr4sPAgeU+mZ8kAjapFiElSWOJIS1uwe9NnZPLv6SOVQqWMbP3DN
         GWLWQ8teEYOgWQjyDBR7BxNajVli1Ymv80n3kbmz7Dw6n+ztJzBks9qVtz1yPb0R4Dkk
         MXCalG9ggWw2Gf7wThI5t4ykRPgiEMc3XrH1Rxi3Q2gfZDGr+JueM0dAhrDDxhw/RAMm
         uDJfbpaPOqZY7uF0uNmjlEbP7TCtO4BuY4z4sfMxezsEZcSWOP1tMZkL1G+vi25IKnzq
         hS0n8wnHqC11I2qkxn+cgVpIfNfwv46fPH2zmduKmlhu5NG6t9FIMoRiTkiFMRCinmaF
         ew4w==
X-Gm-Message-State: AOAM5334AnLEdkOQjDZ0TeUEXuWmVeymW52FGqNkFReMg4JHQEAPqmmu
        2wojYJdUTw8Sk+nDY0pYWgs=
X-Google-Smtp-Source: ABdhPJzDMD5pkEHDo4gipRdTGkjHcADKE3lHimALyEXvIwt/WyGdyMf+YeCjyYKXgbt2YaEYCVWEuQ==
X-Received: by 2002:aa7:9ad3:0:b029:1b7:8afc:d9bd with SMTP id x19-20020aa79ad30000b02901b78afcd9bdmr7980137pfp.45.1611714319755;
        Tue, 26 Jan 2021 18:25:19 -0800 (PST)
Received: from localhost ([178.236.46.205])
        by smtp.gmail.com with ESMTPSA id b21sm390023pfb.45.2021.01.26.18.25.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 18:25:19 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: dong.menglong@zte.com.cn
To:     ast@kernel.org
Cc:     daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, jackmanb@google.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Menglong Dong <dong.menglong@zte.com.cn>
Subject: [PATCH bpf-next] bpf: change 'BPF_ADD' to 'BPF_AND' in print_bpf_insn()
Date:   Tue, 26 Jan 2021 18:25:07 -0800
Message-Id: <20210127022507.23674-1-dong.menglong@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <dong.menglong@zte.com.cn>

This 'BPF_ADD' is duplicated, and I belive it should be 'BPF_AND'.

Fixes: 981f94c3e921 ("bpf: Add bitwise atomic instructions")
Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
---
 kernel/bpf/disasm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/disasm.c b/kernel/bpf/disasm.c
index 19ff8fed7f4b..3acc7e0b6916 100644
--- a/kernel/bpf/disasm.c
+++ b/kernel/bpf/disasm.c
@@ -161,7 +161,7 @@ void print_bpf_insn(const struct bpf_insn_cbs *cbs,
 				insn->dst_reg,
 				insn->off, insn->src_reg);
 		else if (BPF_MODE(insn->code) == BPF_ATOMIC &&
-			 (insn->imm == BPF_ADD || insn->imm == BPF_ADD ||
+			 (insn->imm == BPF_ADD || insn->imm == BPF_AND ||
 			  insn->imm == BPF_OR || insn->imm == BPF_XOR)) {
 			verbose(cbs->private_data, "(%02x) lock *(%s *)(r%d %+d) %s r%d\n",
 				insn->code,
-- 
2.25.1

