Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D9E01986AD
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 23:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729203AbgC3Vh6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 17:37:58 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:46623 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728471AbgC3Vh5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 17:37:57 -0400
Received: by mail-pg1-f194.google.com with SMTP id k191so9287240pgc.13;
        Mon, 30 Mar 2020 14:37:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=YrBAWoo3SMiPXOaKmI+i8ERX9EB7rMtOWlvRQl55U0Q=;
        b=d6djhF9zAK252WBf9DCfVuQTjJjvUjOPlJkguUW0yaMSyjEjowOIFr+kftKlIGGSoX
         rptfAX2FEdpc/pghSkG9WbIT512F6bxqGnCPK5kf4rs7sN5h3fGa5XxFrCPjtDRExP//
         tB8DAvE6OuBWnWj2W+moecUeTe3i5dttpjTFVC84WrPK9V4xiR+Oxwg1dRSkM6VJfWuW
         ljgUAp0QPBdwAxViOLvV8xsC+BiyDTizmz+7uuQKfw/bLRd2ztoeYWFgNXL4Xpr4P8k5
         K+D7P3E7qizbPxeKKKDpQH2qUKuHmB1tG/79H69kt266QUwnnCPXjQubr2N9v7OVF10h
         S9UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=YrBAWoo3SMiPXOaKmI+i8ERX9EB7rMtOWlvRQl55U0Q=;
        b=f/gyANJ6fDqqJWk5fPmioS2souzMV3BCBeGsaZzmJB01l0AC8PAwHku2wPDMGiJxxr
         bje1/SG78wkypIT9MkpG8RwpKoh/+9AVv8lxyalDgxoswL/+7X3yBqLLkv5W8EBx3lvZ
         4aRhWVasvbt2mCMt3M15Hw29xLxS5mRI5ASguL/f75wYIibUiG+kQp9m+FRJZIo4s1hv
         t80Qyqnfrz1a+5EsoeqYfMdkvpmdH90k7RG/IKh+jysH3sUX4PQiOUW0ajwadS6D1KGD
         GBLAHXb8ArkuwP/OLNyIE+r8pLE66GuUXT/5QSncsT6GQa+0+eUJOapGLxHzfO+cicaZ
         Imwg==
X-Gm-Message-State: AGi0PuZuQ+FZ43m6XVHauksOqQaPvcEQXVUVWxxYC3pAaFyYNUNd+RRj
        ggL+m5hkvF2cIeJ8BLqWvXc=
X-Google-Smtp-Source: APiQypJRlT7Bm+KoZjqNoobG5R1dRMDONpYtO552aIwIIl54BCKmQLODO22bFCORhmhO58d+FLw3AQ==
X-Received: by 2002:a65:55c6:: with SMTP id k6mr1116280pgs.52.1585604274643;
        Mon, 30 Mar 2020 14:37:54 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id e7sm10984885pfj.97.2020.03.30.14.37.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Mar 2020 14:37:54 -0700 (PDT)
Subject: [bpf-next PATCH v2 5/7] bpf: test_verifier,
 bpf_get_stack return value add <0
From:   John Fastabend <john.fastabend@gmail.com>
To:     ecree@solarflare.com, yhs@fb.com, alexei.starovoitov@gmail.com,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Mon, 30 Mar 2020 14:37:40 -0700
Message-ID: <158560426019.10843.3285429543232025187.stgit@john-Precision-5820-Tower>
In-Reply-To: <158560409224.10843.3588655801186916301.stgit@john-Precision-5820-Tower>
References: <158560409224.10843.3588655801186916301.stgit@john-Precision-5820-Tower>
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
is free to return any negative error in the 32-bit register space. The
C helper is returning an int so will use lower 32-bits.

Lines 17 and 18 clear the top 32 bits with a left/right shift but use
ARSH so we still have worst case min bound before line 19 of -2147483648.
At this point the signed check 'r1 s< r8' meant to protect the addition
on line 22 where dst reg is a map_value pointer may very well return
true with a large negative number. Then the final line 22 will detect
this as an invalid operation and fail the program. What we want to do
is proceed only if r8 is positive non-error. So change 'r1 s< r8' to
'r1 s> r8' so that we jump if r8 is negative.

Next we will throw an error because we access past the end of the map
value. The map value size is 48 and sizeof(struct test_val) is 48 so
we walk off the end of the map value on the second call to
get bpf_get_stack(). Fix this by changing sizeof(struct test_val) to
24 by using 'sizeof(struct test_val) / 2'. After this everything passes
as expected.

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 .../testing/selftests/bpf/verifier/bpf_get_stack.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/verifier/bpf_get_stack.c b/tools/testing/selftests/bpf/verifier/bpf_get_stack.c
index f24d50f..69b048c 100644
--- a/tools/testing/selftests/bpf/verifier/bpf_get_stack.c
+++ b/tools/testing/selftests/bpf/verifier/bpf_get_stack.c
@@ -9,17 +9,17 @@
 	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
 	BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 28),
 	BPF_MOV64_REG(BPF_REG_7, BPF_REG_0),
-	BPF_MOV64_IMM(BPF_REG_9, sizeof(struct test_val)),
+	BPF_MOV64_IMM(BPF_REG_9, sizeof(struct test_val)/2),
 	BPF_MOV64_REG(BPF_REG_1, BPF_REG_6),
 	BPF_MOV64_REG(BPF_REG_2, BPF_REG_7),
-	BPF_MOV64_IMM(BPF_REG_3, sizeof(struct test_val)),
+	BPF_MOV64_IMM(BPF_REG_3, sizeof(struct test_val)/2),
 	BPF_MOV64_IMM(BPF_REG_4, 256),
 	BPF_EMIT_CALL(BPF_FUNC_get_stack),
 	BPF_MOV64_IMM(BPF_REG_1, 0),
 	BPF_MOV64_REG(BPF_REG_8, BPF_REG_0),
 	BPF_ALU64_IMM(BPF_LSH, BPF_REG_8, 32),
 	BPF_ALU64_IMM(BPF_ARSH, BPF_REG_8, 32),
-	BPF_JMP_REG(BPF_JSLT, BPF_REG_1, BPF_REG_8, 16),
+	BPF_JMP_REG(BPF_JSGT, BPF_REG_1, BPF_REG_8, 16),
 	BPF_ALU64_REG(BPF_SUB, BPF_REG_9, BPF_REG_8),
 	BPF_MOV64_REG(BPF_REG_2, BPF_REG_7),
 	BPF_ALU64_REG(BPF_ADD, BPF_REG_2, BPF_REG_8),
@@ -29,7 +29,7 @@
 	BPF_MOV64_REG(BPF_REG_3, BPF_REG_2),
 	BPF_ALU64_REG(BPF_ADD, BPF_REG_3, BPF_REG_1),
 	BPF_MOV64_REG(BPF_REG_1, BPF_REG_7),
-	BPF_MOV64_IMM(BPF_REG_5, sizeof(struct test_val)),
+	BPF_MOV64_IMM(BPF_REG_5, sizeof(struct test_val)/2),
 	BPF_ALU64_REG(BPF_ADD, BPF_REG_1, BPF_REG_5),
 	BPF_JMP_REG(BPF_JGE, BPF_REG_3, BPF_REG_1, 4),
 	BPF_MOV64_REG(BPF_REG_1, BPF_REG_6),

