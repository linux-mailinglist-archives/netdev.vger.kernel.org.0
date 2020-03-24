Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 884411917D5
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 18:40:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727717AbgCXRkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 13:40:11 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:46062 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727223AbgCXRkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 13:40:11 -0400
Received: by mail-pg1-f195.google.com with SMTP id o26so2874295pgc.12;
        Tue, 24 Mar 2020 10:40:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=SRgQi1yMuseYBwVWxPnOfPzlkltS46MTnR9winZRfXY=;
        b=GB8cQNXyunz4yMh8d2IqEkh4LuVaFet36SwZEMAlqlBEItLF1oxF0TaWZ3AtyON1C9
         nJgXpcyvn5e9K2e+MFHLVAwYJH0Wl3747sRzmDwLeO9NFAZO+bOmwTHSPjXNJkZr0PLM
         9+8YfPXpjUU02+7oZXB8+AWjkiFtxh7+Am/vU1UJDTxkWaQu2v9DhA9oTyLIbd1VCQVa
         By0eLa2qMXk0gET89rYpsBkf8valh/BOXHj9HTjTLdWkL1bz8cKLDmokP/YKtrinZTbx
         q6ZJ6kBb1XqRSOXnrr/Q7w8U4kbWdbTb/Zu856i0RPsdGSuNFKTgOZItpMcLt5O/NDws
         tFpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=SRgQi1yMuseYBwVWxPnOfPzlkltS46MTnR9winZRfXY=;
        b=I2uCJVKvU+2bgcG1C0MSDvDvP5Pw/pipnVtkkBnqs3vpJ0Kq9elRA4yUx1eqtSykcW
         UNW3Kxaf6Ou7GCAPPhTq0++4K9bexgP/bwZtdpjBGKON6KOiEOYuH9LbuOi+l0kghfMt
         h+vJGLye85BsLsXVYncTJkuZG13By7G9JUGjDQYrPpSoalunuTg0EpQ/gGHYtiFPXZZz
         9PhrrErO6BobX+JNbx4Ai1O7A5Gpr8sWDobXZbywuVGqExlM9gtkA5zbAQ9/8SJ2pvyj
         bUDV1sDeUyBnJDBGzaetlC5Vv6FqC2+7Na8M8lXvUQ5SBwfNgXuBOuXz+p6cRATmbxd/
         NX6Q==
X-Gm-Message-State: ANhLgQ3ofHNW6XklfNNMJ9MmZeibMa0o+x5sYezCDzNrCXEuasfUWz/x
        gWwWMPsdl1uwVJbWlvfSMl4=
X-Google-Smtp-Source: ADFU+vsNolvOt+10m4bsspjEIdaNryGz3+LTNygFWIRuXyeVgChpPLG8trPAv5YhQxwGM0G8hkYeew==
X-Received: by 2002:a63:2e49:: with SMTP id u70mr27843237pgu.202.1585071608594;
        Tue, 24 Mar 2020 10:40:08 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id ck23sm2828948pjb.14.2020.03.24.10.40.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Mar 2020 10:40:08 -0700 (PDT)
Subject: [bpf-next PATCH 07/10] bpf: test_verifier,
 bpf_get_stack return value add <0
From:   John Fastabend <john.fastabend@gmail.com>
To:     ecree@solarflare.com, yhs@fb.com, alexei.starovoitov@gmail.com,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Tue, 24 Mar 2020 10:39:55 -0700
Message-ID: <158507159511.15666.6943798089263377114.stgit@john-Precision-5820-Tower>
In-Reply-To: <158507130343.15666.8018068546764556975.stgit@john-Precision-5820-Tower>
References: <158507130343.15666.8018068546764556975.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With current ALU32 subreg handling and retval refine fix from last
patches we see an expected failure in test_verifier. With verbose
verifier state being printed at each step for clarity we have the
following relavent lines [I omit register states that are not
necessarily useful to see failure cause],

#101/p bpf_get_stack return R0 within range FAIL
Failed to load prog 'Success'!
[..]
14: (85) call bpf_get_stack#67
 R0_w=map_value(id=0,off=0,ks=8,vs=48,imm=0)
 R3_w=inv48
15:
 R0=inv(id=0,smax_value=48,var32_off=(0x0; 0xffffffff))
15: (b7) r1 = 0
16:
 R0=inv(id=0,smax_value=48,var32_off=(0x0; 0xffffffff))
 R1_w=inv0
16: (bf) r8 = r0
17:
 R0=inv(id=0,smax_value=48,var32_off=(0x0; 0xffffffff))
 R1_w=inv0
 R8_w=inv(id=0,smax_value=48,var32_off=(0x0; 0xffffffff))
17: (67) r8 <<= 32
18:
 R0=inv(id=0,smax_value=48,var32_off=(0x0; 0xffffffff))
 R1_w=inv0
 R8_w=inv(id=0,smax_value=9223372032559808512,
               umax_value=18446744069414584320,
               var_off=(0x0; 0xffffffff00000000),
               s32_min_value=0,
               s32_max_value=0,
               u32_max_value=0,
               var32_off=(0x0; 0x0))
18: (c7) r8 s>>= 32
19
 R0=inv(id=0,smax_value=48,var32_off=(0x0; 0xffffffff))
 R1_w=inv0
 R8_w=inv(id=0,smin_value=-2147483648,
               smax_value=2147483647,
               var32_off=(0x0; 0xffffffff))
19: (cd) if r1 s< r8 goto pc+16
 R0=inv(id=0,smax_value=48,var32_off=(0x0; 0xffffffff))
 R1_w=inv0
 R8_w=inv(id=0,smin_value=-2147483648,
               smax_value=0,
               var32_off=(0x0; 0xffffffff))
20:
 R0=inv(id=0,smax_value=48,var32_off=(0x0; 0xffffffff))
 R1_w=inv0
 R8_w=inv(id=0,smin_value=-2147483648,
               smax_value=0,
 R9=inv48
20: (1f) r9 -= r8
21: (bf) r2 = r7
22:
 R2_w=map_value(id=0,off=0,ks=8,vs=48,imm=0)
22: (0f) r2 += r8
value -2147483648 makes map_value pointer be out of bounds

After call bpf_get_stack() on line 14 and some moves we have at line 16
an r8 bound with max_value 48 but an unknown min value. This is to be
expected bpf_get_stack call can only return a max of the input size but
is free to return any negative error in the 32-bit register space.
And further C signature returns 'int' which provides no guarantee on
the upper 32-bits of the register.

Lines 17 and 18 clear the top 32 bits with a left/right shift but use
ARSH so we still have worst case min bound before line 19 of -2147483648.
At this point the signed check 'r1 s< r8' meant to protect the addition
on line 22 where dst reg is a map_value pointer may very well return
true with a large negative number. Then the final line 22 will detect
this as an invalid operation and fail the program.

To fix add a signed less than check to ensure r8 is greater than 0 at
line 19 so the bounds check works as expected. Programs _must_ check
for negative return codes or they will fail to load now. But on the
other hand they were buggy before so for correctness the check really
is needed.

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 .../testing/selftests/bpf/verifier/bpf_get_stack.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/verifier/bpf_get_stack.c b/tools/testing/selftests/bpf/verifier/bpf_get_stack.c
index f24d50f..24aa6a0 100644
--- a/tools/testing/selftests/bpf/verifier/bpf_get_stack.c
+++ b/tools/testing/selftests/bpf/verifier/bpf_get_stack.c
@@ -7,7 +7,7 @@
 	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
 	BPF_LD_MAP_FD(BPF_REG_1, 0),
 	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
-	BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 28),
+	BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 29),
 	BPF_MOV64_REG(BPF_REG_7, BPF_REG_0),
 	BPF_MOV64_IMM(BPF_REG_9, sizeof(struct test_val)),
 	BPF_MOV64_REG(BPF_REG_1, BPF_REG_6),
@@ -16,6 +16,7 @@
 	BPF_MOV64_IMM(BPF_REG_4, 256),
 	BPF_EMIT_CALL(BPF_FUNC_get_stack),
 	BPF_MOV64_IMM(BPF_REG_1, 0),
+	BPF_JMP32_REG(BPF_JSLT, BPF_REG_0, BPF_REG_1, 20),
 	BPF_MOV64_REG(BPF_REG_8, BPF_REG_0),
 	BPF_ALU64_IMM(BPF_LSH, BPF_REG_8, 32),
 	BPF_ALU64_IMM(BPF_ARSH, BPF_REG_8, 32),

