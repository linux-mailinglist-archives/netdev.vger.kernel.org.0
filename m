Return-Path: <netdev+bounces-3813-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FAA8708EB7
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 06:14:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2F159281883
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 04:13:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D47E36137;
	Fri, 19 May 2023 04:07:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF9D1651;
	Fri, 19 May 2023 04:07:26 +0000 (UTC)
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FECB10CF;
	Thu, 18 May 2023 21:07:25 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-64d3578c25bso66908b3a.3;
        Thu, 18 May 2023 21:07:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684469244; x=1687061244;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=srUsONv1+BtA+seq8Jh4M9M/ZYn/sI/8M3Ij3rhpTaI=;
        b=Be7akhCJUfV5fkHB5/UpF9jQD4RsYfU92vDvyttP2p1FX023WcXkBBAIdblYsSQXId
         vqlCFj+scgUgzf5dWeTrCP2+Xmk1JX7hJPcW2s1I3Ck2i0MhyOe2wBnYfOacyZf3HJVd
         K4r8ysppjvFu5AJ2MKEc/xSOBEo14MEk28USsNPO43Dc6ZRQ6dSY0Otb7+dzrpGRjhv9
         uBMSM8Es1L4gObN2FZr+l4dLNSfaJYcfJUn+GjBx1/WEbl0j/QDPOOIB0xVYerhBywnZ
         v/ROaKzxmL6j9ToAu0zgq22WOjVhW5/i0GQ/73EMJFjm19Ds+wGph/f4ceQYsb/I/Amk
         noOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684469244; x=1687061244;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=srUsONv1+BtA+seq8Jh4M9M/ZYn/sI/8M3Ij3rhpTaI=;
        b=C+C51LZIk8Hp3zcqpHp90870glxXveiFUbRdHMtOm3/U6Y/N6RjbPJ0NKPoyKzqkpw
         IejmL0XzrOnRcbCySTSS3GGlSWKGN+jFQBPp3/wlgRfzN4UxvDzKnInYDL08WIU5NDoO
         Xblc7zyr+Jx4WYM8En03gF36YKQ9P1gSxBKdSX49t6MB0qAlPHRDPQwYqswjkViMEr1c
         +sJyj/ruxsN4/vUJukaUC2VXG/p9icmG5a2Ye6wQVt2Uwicu8xbUyh7WniYtGAk/5Dnl
         mcnOAQyoKVd4re1ndyP/kJ5qNe0csM0sr1A6CzhpL1tvzls9ULJIxsQPNufRuhIJu4ik
         H/7A==
X-Gm-Message-State: AC+VfDw0hL5mWegudn7FnGCTzLacOK3NkAoDcX6ZWAhaBCpcXtAUr3BU
	apL03sIqLPE0VH/zteI8bbuA90UjG8A=
X-Google-Smtp-Source: ACHHUZ6kffR844BYAm18m8i+Q90qf4Qu48hndwOGeszXVC6XFhgT1RonZY4xC0JbilVeDJf9tduVkg==
X-Received: by 2002:a05:6a00:2e06:b0:643:aa2:4dcd with SMTP id fc6-20020a056a002e0600b006430aa24dcdmr1555078pfb.16.1684469244535;
        Thu, 18 May 2023 21:07:24 -0700 (PDT)
Received: from john.lan ([2605:59c8:148:ba10:706:628a:e6ce:c8a9])
        by smtp.gmail.com with ESMTPSA id x11-20020aa784cb000000b00625d84a0194sm434833pfn.107.2023.05.18.21.07.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 May 2023 21:07:24 -0700 (PDT)
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
Subject: [PATCH bpf v9 14/14] bpf: sockmap, test progs verifier error with latest clang
Date: Thu, 18 May 2023 21:06:59 -0700
Message-Id: <20230519040659.670644-15-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230519040659.670644-1-john.fastabend@gmail.com>
References: <20230519040659.670644-1-john.fastabend@gmail.com>
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


