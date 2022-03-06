Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF2F4CEEB3
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 00:43:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233516AbiCFXo2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 18:44:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234479AbiCFXo1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 18:44:27 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4ED341636;
        Sun,  6 Mar 2022 15:43:28 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id d17so12316262pfl.0;
        Sun, 06 Mar 2022 15:43:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SK5eJWwdny4MgSa99M4Dd7h9oZBl1uRtjfGWpEWW6Xs=;
        b=p15VkK1Jm11t+6iLUfSsmmRo8ggtct6+ebAlDnbgtuSjbOttJs90I5IhDL6Xw90tld
         fXrNbAaRi9rzia+/RbaE0IshMnPV7ywD6IWb7tiiJnoxvq8X582lB5m0/UbWgsD1HHvO
         rCfQgEYNIysZp04fTW0hmYx3fEAYfiX0o2L49uJxFcxhnV5nezCM4TkDS5LtTjQYpQZV
         MmVig9d5LGIX9hH4IupM9QZmEhR7Rmsl8fNiGqGmHJkD35X4jUwaF4CTLYunibq4Oj0P
         GXbtWFF9O50n2nkfznQcY04iNGb6GKNLGhwJA5hoMjqOYg1gb+iPhXp4AMEaUPUcM/q7
         GzvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SK5eJWwdny4MgSa99M4Dd7h9oZBl1uRtjfGWpEWW6Xs=;
        b=QNSl0Ahmn8+wdTrHLg1cNfqYtHFjquLGSa7GSn0SQcVyt4DUTd2MZ6vKtbOJ8Ut8JI
         XEIv0T44D4XLMybfuCBaIYS5T0xE4UrwD78ii5QV0XZwt/KWQM9xC1mIRKSbnZ6/nCzq
         eZZm2bJ67BASb2L1q2Nr4SP+VkGrjFbl5xaF3BSWwjA/jY5hrj5Vbwx86+PcI6/T/RVk
         bLVwNDPiQrhVRaFSh+ZcKjQM8RknAEpzc/rgRUEaWpP5vDa6pJWWkRhHMHKIKYkmyhg8
         uqPl4L7Xqjz7eDc8YFd5/CTRIlKhsXBi4jOxDbaHfw5EKtoihZaGaPcoDrkeN6gitBN9
         9FwA==
X-Gm-Message-State: AOAM5321CORdpBkTqxLY2X8KtQ0dBxKSKZYCx0/4vs1vcG4Zk3OUPoN+
        pMGvxvwxbmEQHjTdm23mqMkQX9Ez/kI=
X-Google-Smtp-Source: ABdhPJx7SA2MTL6Q/7xJoebnAcbyQs28ZXljIGLt+wgzZs9QrBme47ZkO4/dlW3ykrY+aXzsAVLiRw==
X-Received: by 2002:a65:6a8e:0:b0:378:b62d:f397 with SMTP id q14-20020a656a8e000000b00378b62df397mr7762246pgu.239.1646610208057;
        Sun, 06 Mar 2022 15:43:28 -0800 (PST)
Received: from localhost ([2405:201:6014:d0c0:6243:316e:a9e1:adda])
        by smtp.gmail.com with ESMTPSA id x1-20020a637c01000000b0038007eeee0bsm4024983pgc.22.2022.03.06.15.43.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Mar 2022 15:43:27 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Lorenz Bauer <linux@lmb.io>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v1 4/5] selftests/bpf: Add verifier tests for pkt pointer with pkt_uid
Date:   Mon,  7 Mar 2022 05:13:10 +0530
Message-Id: <20220306234311.452206-5-memxor@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220306234311.452206-1-memxor@gmail.com>
References: <20220306234311.452206-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6037; h=from:subject; bh=v2oPD/898mip5EnchYtYAcaGnb/9AXn9iiWsqg8DQh4=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBiJUWoITMEHp/+IE2alU3k+E1XjmQEBgvhNyEeLIJX n0oZJ4eJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYiVFqAAKCRBM4MiGSL8Ryov0D/ 9PaohaNpddLWKELefPVlZaa+uBXz9m2WKda2RSx2Zd4oQZGsi5sQgnqeB6TWZNrB3GjqTYog1D2yd9 uBGJG3J5BsnUzXHfYT14kLyZ5NdPr8y0KLB2xqsaExPGdS4eYYwSB2FiTDbeOPDFwwsEny5JyeTNir NjbZOua1e6M2CaNmGnm5dw3Cddq5CCyT39iiranKmTgomeg0a8HjunaFrof08uFPVCVoGrYdaQxKtt jJNoKpWI3WPiqVT2QDqmr0xEk6LZsQon1rtVx0tPzA4qv8zFHessvxvGeituqsrFe1qVx3mryHYJ7I G2pDWf8DSt4E8NmE7gljalVax5r7J/W9do8vj1jQJSIRZCpA9iyiv5hSfesi3lOliftriHjzfww5S4 CrMA3UwALnUl3aCT+1a2gG7qCB8+rexRygp4TFdUceAHCBm9RsaY28tdUJl21ytD/ZfTUu2SDyzv+6 hX2hZhMeyoG/6Rq6IGfQ3l3AKc1kTY/o3W16IA7OxNL5nEQU7LMU+XRka//ZsKp+yqLoBNkmCH/sMG yxBjevKOqd6xFLSdRgeOk+Mf9ziGeh0nfdqDsIC3PikHAZpeMXoxEh/AGUZi0Uuiat0WbB6gg4WhU9 HSxsgCft6ZzkGpr6k/m93w/Kt8OWDmwCPylcdJg+zFsPXdYft5Vz/lDLZJBg==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use bpf_packet_pointer to obtain such pkt pointers, and verify various
behaviors, like find_good_pkt_pointers skipping pkt pointers with
unequal pkt_uid, ensuring that offset, len to bpf_packet_pointer are
within limits imposed statically by verifier, rejecting comparion of pkt
pointer with pkt_uid against unequal pkt_uid, ensuring
clear_all_pkt_pointers doens't skip pkt_uid pkts.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/testing/selftests/bpf/verifier/xdp.c | 146 +++++++++++++++++++++
 1 file changed, 146 insertions(+)

diff --git a/tools/testing/selftests/bpf/verifier/xdp.c b/tools/testing/selftests/bpf/verifier/xdp.c
index 5ac390508139..580b294cde11 100644
--- a/tools/testing/selftests/bpf/verifier/xdp.c
+++ b/tools/testing/selftests/bpf/verifier/xdp.c
@@ -12,3 +12,149 @@
 	.prog_type = BPF_PROG_TYPE_XDP,
 	.retval = 1,
 },
+{
+	"XDP bpf_packet_pointer offset cannot be > 0xffff",
+	.insns = {
+	BPF_MOV64_IMM(BPF_REG_2, 0x10000),
+	BPF_MOV64_IMM(BPF_REG_3, 42),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_packet_pointer),
+	BPF_MOV64_IMM(BPF_REG_0, 1),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.result_unpriv = REJECT,
+	.result = REJECT,
+	.errstr = "R2 must be in range [0, 0xffff]",
+},
+{
+	"XDP bpf_packet_pointer len must be constant",
+	.insns = {
+	BPF_MOV64_IMM(BPF_REG_0, 1),
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, offsetof(struct xdp_md, ingress_ifindex)),
+	BPF_JMP32_IMM(BPF_JSGE, BPF_REG_2, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_JMP32_IMM(BPF_JSLE, BPF_REG_2, 0xffff, 1),
+	BPF_EXIT_INSN(),
+	BPF_MOV64_REG(BPF_REG_3, BPF_REG_2),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_packet_pointer),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.result_unpriv = REJECT,
+	.result = REJECT,
+	.errstr = "R3 is not a known constant",
+},
+{
+	"XDP bpf_packet_pointer len cannot be 0",
+	.insns = {
+	BPF_MOV64_IMM(BPF_REG_0, 1),
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, offsetof(struct xdp_md, ingress_ifindex)),
+	BPF_JMP32_IMM(BPF_JSGE, BPF_REG_2, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_JMP32_IMM(BPF_JSLE, BPF_REG_2, 0xffff, 1),
+	BPF_EXIT_INSN(),
+	BPF_MOV64_IMM(BPF_REG_3, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_packet_pointer),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.result_unpriv = REJECT,
+	.result = REJECT,
+	.errstr = "R3 must be in range [1, 0xffff]",
+},
+{
+	"XDP bpf_packet_pointer R0 cannot be compared with xdp_md pkt ptr",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_6, BPF_REG_1),
+	BPF_MOV64_IMM(BPF_REG_2, 0),
+	BPF_MOV64_IMM(BPF_REG_3, 42),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_packet_pointer),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_LDX_MEM(BPF_W, BPF_REG_1, BPF_REG_6, offsetof(struct xdp_md, data_end)),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_0, 16),
+	BPF_JMP_REG(BPF_JGE, BPF_REG_0, BPF_REG_1, 1),
+	BPF_EXIT_INSN(),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, 0),
+	BPF_MOV64_IMM(BPF_REG_0, 1),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.result_unpriv = REJECT,
+	.result = REJECT,
+	.errstr = "R0, R1 pkt pointer comparison prohibited",
+},
+{
+	"XDP bpf_packet_pointer R0 range propagation skips unequal pkt_uid",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_6, BPF_REG_1),
+	BPF_MOV64_IMM(BPF_REG_2, 0),
+	BPF_MOV64_IMM(BPF_REG_3, 1),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_packet_pointer),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_LDX_MEM(BPF_W, BPF_REG_1, BPF_REG_6, offsetof(struct xdp_md, data)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_6, offsetof(struct xdp_md, data)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_6, offsetof(struct xdp_md, data)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_4, BPF_REG_6, offsetof(struct xdp_md, data_end)),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 16),
+	BPF_JMP_REG(BPF_JLT, BPF_REG_1, BPF_REG_4, 1),
+	BPF_EXIT_INSN(),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_1, -16),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_2, 4),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_3, BPF_REG_3, 8),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, 0),
+	BPF_MOV64_IMM(BPF_REG_0, 1),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.result_unpriv = REJECT,
+	.result = REJECT,
+	.errstr = "invalid access to packet, off=0 size=8, R0(id=0,off=0,r=1)",
+},
+{
+	"XDP clear_all_pkt_pointers doesn't skip pkt_uid != 0",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_6, BPF_REG_1),
+	BPF_MOV64_IMM(BPF_REG_2, 0),
+	BPF_MOV64_IMM(BPF_REG_3, 16),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_packet_pointer),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_MOV64_REG(BPF_REG_7, BPF_REG_0),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_6),
+	BPF_MOV64_IMM(BPF_REG_2, 1),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_xdp_adjust_tail),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_7, BPF_REG_7, 0),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.result_unpriv = REJECT,
+	.result = REJECT,
+	.errstr = "R7 invalid mem access 'scalar'",
+},
+{
+	"XDP pkt_uid preserved when resetting range on rX += var",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_6, BPF_REG_1),
+	BPF_MOV64_IMM(BPF_REG_2, 0),
+	BPF_MOV64_IMM(BPF_REG_3, 16),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_packet_pointer),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_LDX_MEM(BPF_W, BPF_REG_1, BPF_REG_6, offsetof(struct xdp_md, ingress_ifindex)),
+	BPF_JMP32_IMM(BPF_JGE, BPF_REG_1, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_JMP32_IMM(BPF_JLE, BPF_REG_1, 4, 1),
+	BPF_EXIT_INSN(),
+	BPF_ALU64_REG(BPF_ADD, BPF_REG_1, BPF_REG_0),
+	BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_6, offsetof(struct xdp_md, data_end)),
+	BPF_JMP_REG(BPF_JLT, BPF_REG_1, BPF_REG_0, 1),
+	BPF_EXIT_INSN(),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.result_unpriv = REJECT,
+	.result = REJECT,
+	.errstr = "R1, R0 pkt pointer comparison prohibited",
+},
-- 
2.35.1

