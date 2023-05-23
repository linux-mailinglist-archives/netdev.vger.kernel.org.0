Return-Path: <netdev+bounces-4503-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DA0E570D223
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 05:03:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9CFC11C208DE
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 03:03:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C8FC1801F;
	Tue, 23 May 2023 02:56:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B0117FF8;
	Tue, 23 May 2023 02:56:48 +0000 (UTC)
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CEBFFD;
	Mon, 22 May 2023 19:56:45 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1ae79528d4dso44829835ad.2;
        Mon, 22 May 2023 19:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684810604; x=1687402604;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=srUsONv1+BtA+seq8Jh4M9M/ZYn/sI/8M3Ij3rhpTaI=;
        b=ZZ/a68bUghvUvsOMQ6uS9KomRQCd7n8PypB/cYu3ufTiS/dI4OeoTZdpMYorqLL1AK
         VfZ+rf3QaD5jCsfYNMtZGSqsVj3rqJz+ktLxp7GY18tKqRhoXEVaDWCpZX82NXYme2pd
         pS/8TesdjtNuZJs2rrzH2VqNiKVxmfz/H65aXPDER7I/IlhiWQHPhOA/zTURZckfuDnX
         0b0/4jm5ZZ6t10CjXp9a8B93ezT/lka+X4X/AqeShCQh7T2usGI+E9R/CRfDxVdEFQHN
         Wa1FzqgC5emy3b9tWqZv/ob+0HiZyYMgOahZ1x7KxVKd7iBPRYSNPf9QudP7S6znQqVW
         iF+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684810604; x=1687402604;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=srUsONv1+BtA+seq8Jh4M9M/ZYn/sI/8M3Ij3rhpTaI=;
        b=DgxwM9wtlnj+miTFKXHZdpcJxeOXdFCVHV/uqiKHPfN9tsU6fcwAaMoKw2HF+50Zob
         cqg1wMPiQPVEDYrNysZrKDrKaZtK9z1VTz7ZZonekOxlW278VWG2ttfiM44Qnvf2/KBE
         vCXzLZPTk5oA8I6wZWnb+q5DBgL7EimF5QtcKPBXW+aBbhQ6btHIzbnA2EZXl3WwsNHI
         qPMpGMrYASirv3CHenHdaXShMaeFqxx7/d4WJ9ZcmJ3HWCnO9jmndMlSgKWC16c0gs1m
         fMMee74ierD/QcJxLrsIu7sGP+bUnTVRw44BjLN/cxpD7V2a03D0FLZF5ExzV5YwtByP
         sTPw==
X-Gm-Message-State: AC+VfDxAKMec4SDuCTkbDuG+/Tlr3JqbPwFskWlz5xd9AfkEbgeBfnef
	oIcihMlXDY115jTMawHvuVcXAirb1o4=
X-Google-Smtp-Source: ACHHUZ46CruItPMvj0jEGz4i8MrYWiA4w82MQNTZWkXPSl0bmWnW3IWRon83hMKUUBKzAgm3GYfYMQ==
X-Received: by 2002:a17:902:e9d5:b0:1ab:b120:8efe with SMTP id 21-20020a170902e9d500b001abb1208efemr12833780plk.22.1684810604657;
        Mon, 22 May 2023 19:56:44 -0700 (PDT)
Received: from john.lan ([2605:59c8:148:ba10:82a6:5b19:9c99:3aad])
        by smtp.gmail.com with ESMTPSA id h10-20020a170902748a00b001a67759f9f8sm5508285pll.106.2023.05.22.19.56.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 19:56:44 -0700 (PDT)
From: John Fastabend <john.fastabend@gmail.com>
To: jakub@cloudflare.com,
	daniel@iogearbox.net
Cc: john.fastabend@gmail.com,
	bpf@vger.kernel.org,
	netdev@vger.kernel.org,
	edumazet@google.com,
	ast@kernel.org,
	andrii@kernel.org,
	will@isovalent.com
Subject: [PATCH bpf v10 14/14] bpf: sockmap, test progs verifier error with latest clang
Date: Mon, 22 May 2023 19:56:18 -0700
Message-Id: <20230523025618.113937-15-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230523025618.113937-1-john.fastabend@gmail.com>
References: <20230523025618.113937-1-john.fastabend@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

With a relatively recent clang (7090c10273119) and with this commit
to fix warnings in selftests (c8ed668593972) that uses __sink(err)
to resolve unused variables. We get the following verifier error.

root@6e731a24b33a:/host/tools/testing/selftests/bpf# ./test_sockmap
libbpf: prog 'bpf_sockmap': BPF program load failed: Permission denied
libbpf: prog 'bpf_sockmap': -- BEGIN PROG LOAD LOG --
0: R1=ctx(off=0,imm=0) R10=fp0
; op = (int) skops->op;
0: (61) r2 = *(u32 *)(r1 +0)          ; R1=ctx(off=0,imm=0) R2_w=scalar(umax=4294967295,var_off=(0x0; 0xffffffff))
; switch (op) {
1: (16) if w2 == 0x4 goto pc+5        ; R2_w=scalar(umax=4294967295,var_off=(0x0; 0xffffffff))
2: (56) if w2 != 0x5 goto pc+15       ; R2_w=5
; lport = skops->local_port;
3: (61) r2 = *(u32 *)(r1 +68)         ; R1=ctx(off=0,imm=0) R2_w=scalar(umax=4294967295,var_off=(0x0; 0xffffffff))
; if (lport == 10000) {
4: (56) if w2 != 0x2710 goto pc+13 18: R1=ctx(off=0,imm=0) R2=scalar(umax=4294967295,var_off=(0x0; 0xffffffff)) R10=fp0
; __sink(err);
18: (bc) w1 = w0
R0 !read_ok
processed 18 insns (limit 1000000) max_states_per_insn 0 total_states 2 peak_states 2 mark_read 1
-- END PROG LOAD LOG --
libbpf: prog 'bpf_sockmap': failed to load: -13
libbpf: failed to load object 'test_sockmap_kern.bpf.o'
load_bpf_file: (-1) No such file or directory
ERROR: (-1) load bpf failed
libbpf: prog 'bpf_sockmap': BPF program load failed: Permission denied
libbpf: prog 'bpf_sockmap': -- BEGIN PROG LOAD LOG --
0: R1=ctx(off=0,imm=0) R10=fp0
; op = (int) skops->op;
0: (61) r2 = *(u32 *)(r1 +0)          ; R1=ctx(off=0,imm=0) R2_w=scalar(umax=4294967295,var_off=(0x0; 0xffffffff))
; switch (op) {
1: (16) if w2 == 0x4 goto pc+5        ; R2_w=scalar(umax=4294967295,var_off=(0x0; 0xffffffff))
2: (56) if w2 != 0x5 goto pc+15       ; R2_w=5
; lport = skops->local_port;
3: (61) r2 = *(u32 *)(r1 +68)         ; R1=ctx(off=0,imm=0) R2_w=scalar(umax=4294967295,var_off=(0x0; 0xffffffff))
; if (lport == 10000) {
4: (56) if w2 != 0x2710 goto pc+13 18: R1=ctx(off=0,imm=0) R2=scalar(umax=4294967295,var_off=(0x0; 0xffffffff)) R10=fp0
; __sink(err);
18: (bc) w1 = w0
R0 !read_ok
processed 18 insns (limit 1000000) max_states_per_insn 0 total_states 2 peak_states 2 mark_read 1
-- END PROG LOAD LOG --
libbpf: prog 'bpf_sockmap': failed to load: -13
libbpf: failed to load object 'test_sockhash_kern.bpf.o'
load_bpf_file: (-1) No such file or directory
ERROR: (-1) load bpf failed
libbpf: prog 'bpf_sockmap': BPF program load failed: Permission denied
libbpf: prog 'bpf_sockmap': -- BEGIN PROG LOAD LOG --
0: R1=ctx(off=0,imm=0) R10=fp0
; op = (int) skops->op;
0: (61) r2 = *(u32 *)(r1 +0)          ; R1=ctx(off=0,imm=0) R2_w=scalar(umax=4294967295,var_off=(0x0; 0xffffffff))
; switch (op) {
1: (16) if w2 == 0x4 goto pc+5        ; R2_w=scalar(umax=4294967295,var_off=(0x0; 0xffffffff))
2: (56) if w2 != 0x5 goto pc+15       ; R2_w=5
; lport = skops->local_port;
3: (61) r2 = *(u32 *)(r1 +68)         ; R1=ctx(off=0,imm=0) R2_w=scalar(umax=4294967295,var_off=(0x0; 0xffffffff))
; if (lport == 10000) {
4: (56) if w2 != 0x2710 goto pc+13 18: R1=ctx(off=0,imm=0) R2=scalar(umax=4294967295,var_off=(0x0; 0xffffffff)) R10=fp0
; __sink(err);
18: (bc) w1 = w0
R0 !read_ok
processed 18 insns (limit 1000000) max_states_per_insn 0 total_states 2 peak_states 2 mark_read 1
-- END PROG LOAD LOG --

To fix simply remove the err value because its not actually used anywhere
in the testing. We can investigate the root cause later. Future patch should
probably actually test the err value as well. Although if the map updates
fail they will get caught eventually by userspace.

Fixes: c8ed668593972 ("selftests/bpf: fix lots of silly mistakes pointed out by compiler")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 .../testing/selftests/bpf/progs/test_sockmap_kern.h  | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/test_sockmap_kern.h b/tools/testing/selftests/bpf/progs/test_sockmap_kern.h
index baf9ebc6d903..99d2ea9fb658 100644
--- a/tools/testing/selftests/bpf/progs/test_sockmap_kern.h
+++ b/tools/testing/selftests/bpf/progs/test_sockmap_kern.h
@@ -191,7 +191,7 @@ SEC("sockops")
 int bpf_sockmap(struct bpf_sock_ops *skops)
 {
 	__u32 lport, rport;
-	int op, err, ret;
+	int op, ret;
 
 	op = (int) skops->op;
 
@@ -203,10 +203,10 @@ int bpf_sockmap(struct bpf_sock_ops *skops)
 		if (lport == 10000) {
 			ret = 1;
 #ifdef SOCKMAP
-			err = bpf_sock_map_update(skops, &sock_map, &ret,
+			bpf_sock_map_update(skops, &sock_map, &ret,
 						  BPF_NOEXIST);
 #else
-			err = bpf_sock_hash_update(skops, &sock_map, &ret,
+			bpf_sock_hash_update(skops, &sock_map, &ret,
 						   BPF_NOEXIST);
 #endif
 		}
@@ -218,10 +218,10 @@ int bpf_sockmap(struct bpf_sock_ops *skops)
 		if (bpf_ntohl(rport) == 10001) {
 			ret = 10;
 #ifdef SOCKMAP
-			err = bpf_sock_map_update(skops, &sock_map, &ret,
+			bpf_sock_map_update(skops, &sock_map, &ret,
 						  BPF_NOEXIST);
 #else
-			err = bpf_sock_hash_update(skops, &sock_map, &ret,
+			bpf_sock_hash_update(skops, &sock_map, &ret,
 						   BPF_NOEXIST);
 #endif
 		}
@@ -230,8 +230,6 @@ int bpf_sockmap(struct bpf_sock_ops *skops)
 		break;
 	}
 
-	__sink(err);
-
 	return 0;
 }
 
-- 
2.33.0


