Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4C461986AF
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 23:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729106AbgC3ViR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 17:38:17 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:34598 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728471AbgC3ViQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 17:38:16 -0400
Received: by mail-pl1-f194.google.com with SMTP id a23so7281694plm.1;
        Mon, 30 Mar 2020 14:38:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=YhiLqIoYtWaeo+b59KQvNZJFmnotR12vApEKv2KkKKg=;
        b=HlXso+9xRfsD0micsCv+glMu/T50KP7LEmZPb3J7Qq+cLHh5TAlypRLfkXGTN+4mdl
         ehklNTgLmnu5Ydi96qiiD7qNNG1Rw/c4WsAvDqAbZbgcdtMjKWZLp43CSJgE5NJVvreP
         i9+z/oXfzonZ7NA8YouuX3gy0ndqZ0BXwhQFMJYdZR26RREWuHKMd3N068+eDaXhd/3W
         CvR2vtmJLEBU5T/tZHle/y5paLYCaEuy48zOBd7EAWZ5QHnoLAs+ikkqaBUQgO0ntfnZ
         PMIJqV/PZyCzYZdWl6IbwBznqIH9InMaGvcdIWIU2eIM1Mp/+eKPOdiwgLNL+xERmwKz
         NqQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=YhiLqIoYtWaeo+b59KQvNZJFmnotR12vApEKv2KkKKg=;
        b=Fb63So7C9t8z9hUz32PyY9Lsb1ajXBUvgsS4zi/VgNFiXOoyKuujpecKXNincJIBBU
         yVSrMz7vmxevw17Ptqt6Xfiu+B8RipWE2zWLvzNZm4zQ9WG8qULRRm2HAhnaWlXVTY2e
         FM4G1ySMEZgg/vXgl7HziXnAGMb9pvk2XFBSlSkqp42c3WC+vd0iG2udVhkZXaPcRWJg
         Acc41lMOOGKT69VyBS12hn2c6nUn0T5amt0xjALmMMwn9NY0aJJBIafyLZ8dh+TUq7fH
         26fqnst7A/M9FW1TzqSqlXdezVl7149vkKoqSZ/Rd34lX3gRz1Lyw8b9XIUYtuyYnf6M
         5fEw==
X-Gm-Message-State: AGi0PuarHNJ5d5YBX0bnZQQf9Q5tKENFXD4Wleh2j+1KPRyIcIp7CS5G
        QeNeEKUlfe86nQ5CQxTFkX0=
X-Google-Smtp-Source: APiQypKXXRIURoodz7l5J1pSrXc8d0l1kKBxFznSltTtnbkzIbJr4D/k1RACS91YzuSH+H1RboxvZg==
X-Received: by 2002:a17:90b:3645:: with SMTP id nh5mr171455pjb.104.1585604295439;
        Mon, 30 Mar 2020 14:38:15 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id 132sm11032676pfc.183.2020.03.30.14.38.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Mar 2020 14:38:14 -0700 (PDT)
Subject: [bpf-next PATCH v2 6/7] bpf: test_verifier,
 #65 error message updates for trunc of boundary-cross
From:   John Fastabend <john.fastabend@gmail.com>
To:     ecree@solarflare.com, yhs@fb.com, alexei.starovoitov@gmail.com,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Mon, 30 Mar 2020 14:38:01 -0700
Message-ID: <158560428103.10843.6316594510312781186.stgit@john-Precision-5820-Tower>
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

After changes to add update_reg_bounds after ALU ops and 32-bit bounds
tracking truncation of boundary crossing range will fail earlier and with
a different error message. Now the test error trace is the following

11: (17) r1 -= 2147483584
12: R0_w=map_value(id=0,off=0,ks=8,vs=8,imm=0)
    R1_w=invP(id=0,smin_value=-2147483584,smax_value=63)
    R10=fp0 fp-8_w=mmmmmmmm
12: (17) r1 -= 2147483584
13: R0_w=map_value(id=0,off=0,ks=8,vs=8,imm=0)
    R1_w=invP(id=0,
              umin_value=18446744069414584448,umax_value=18446744071562068095,
              var_off=(0xffffffff00000000; 0xffffffff))
    R10=fp0 fp-8_w=mmmmmmmm
13: (77) r1 >>= 8
14: R0_w=map_value(id=0,off=0,ks=8,vs=8,imm=0)
    R1_w=invP(id=0,
              umin_value=72057594021150720,umax_value=72057594029539328,
              var_off=(0xffffffff000000; 0xffffff),
              s32_min_value=-16777216,s32_max_value=-1,
              u32_min_value=-16777216)
    R10=fp0 fp-8_w=mmmmmmmm
14: (0f) r0 += r1
value 72057594021150720 makes map_value pointer be out of bounds

Because we have 'umin_value == umax_value' instead of previously
where 'umin_value != umax_value' we can now fail earlier noting
that pointer addition is out of bounds.

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 tools/testing/selftests/bpf/verifier/bounds.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/bpf/verifier/bounds.c b/tools/testing/selftests/bpf/verifier/bounds.c
index 7c9b659..cf72fcc 100644
--- a/tools/testing/selftests/bpf/verifier/bounds.c
+++ b/tools/testing/selftests/bpf/verifier/bounds.c
@@ -257,17 +257,15 @@
 	 *      [0x00ff'ffff'ff00'0000, 0x00ff'ffff'ffff'ffff]
 	 */
 	BPF_ALU64_IMM(BPF_RSH, BPF_REG_1, 8),
-	/* no-op or OOB pointer computation */
+	/* error on OOB pointer computation */
 	BPF_ALU64_REG(BPF_ADD, BPF_REG_0, BPF_REG_1),
-	/* potentially OOB access */
-	BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_0, 0),
 	/* exit */
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
 	.fixup_map_hash_8b = { 3 },
 	/* not actually fully unbounded, but the bound is very high */
-	.errstr = "R0 unbounded memory access",
+	.errstr = "value 72057594021150720 makes map_value pointer be out of bounds",
 	.result = REJECT
 },
 {
@@ -299,17 +297,15 @@
 	 *      [0x00ff'ffff'ff00'0000, 0x00ff'ffff'ffff'ffff]
 	 */
 	BPF_ALU64_IMM(BPF_RSH, BPF_REG_1, 8),
-	/* no-op or OOB pointer computation */
+	/* error on OOB pointer computation */
 	BPF_ALU64_REG(BPF_ADD, BPF_REG_0, BPF_REG_1),
-	/* potentially OOB access */
-	BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_0, 0),
 	/* exit */
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
 	.fixup_map_hash_8b = { 3 },
 	/* not actually fully unbounded, but the bound is very high */
-	.errstr = "R0 unbounded memory access",
+	.errstr = "value 72057594021150720 makes map_value pointer be out of bounds",
 	.result = REJECT
 },
 {

