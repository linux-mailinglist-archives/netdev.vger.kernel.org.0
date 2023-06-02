Return-Path: <netdev+bounces-7317-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF08371FA77
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 09:01:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5C829281568
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 07:01:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F72346A8;
	Fri,  2 Jun 2023 07:00:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C3310E5;
	Fri,  2 Jun 2023 07:00:59 +0000 (UTC)
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 701651B9;
	Fri,  2 Jun 2023 00:00:47 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id 6a1803df08f44-628f267aa5aso1177036d6.1;
        Fri, 02 Jun 2023 00:00:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685689246; x=1688281246;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5+Dwvdqn0Nc+03wWkuuIbg+roLTPzxNXIEQmZzt/hu4=;
        b=GTw6Eipm5S+VJeux5pubyt5ODlplECcBv00WjTFzhxwM5uiLPBp0HMHU+q4PaZYJp4
         miKnL9tEPl9Cvug/XCS1Fc16h1s6W8QiX6E6xkntXvUYIERJ33BPFreVKg2XDcRZZiV0
         qNhJr68zq9qeb6eXpqlnEXiGBv0ZzEJfQxRXVSdsP6PM7vssI5SHQFRbxvbnmU+m/Bsb
         BFDmNI9jagVqSU/+JmIauQ0dOAeSjtXhXHrR6tix5J2EEkUx7okarpNE96agpK6tDjWt
         tB7eti1gz/rBqPRTb51QofB4KsinH/4dUH8J3KkIO7n1SnWYlD/g8YwonxjAa5vDE4O9
         3siA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685689246; x=1688281246;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5+Dwvdqn0Nc+03wWkuuIbg+roLTPzxNXIEQmZzt/hu4=;
        b=KRXEayaWpHSh/GOmnoJQ18y/b50aUpZqclrw2EHlccTF22Je2eQBqFadbXulLiWzPE
         FNlcs+s1H5/61uYVns5yKsqMHCzmhA2GIaeQMOin8tlI8syaLUvLnTbjZ2z6A10QosAC
         tVJcNkmoNPAotHXmxM/i0y98RlJvjWHPGbFCfC2gr+KI7Quknum2wnex5yqsBPM/1glu
         mK/5eViUefAMkP2yB1MLm0evkz3Jc/LUV/GbhwoseFJVSZ+6h68JJhkK1wGO0wHbjP5n
         sVigbqfPkQjEq88z2VCfx1NmndgedtyNWHcAqDif8/yxxd4jWPjSboXW7E4arhmNg3bO
         5IPA==
X-Gm-Message-State: AC+VfDzMmTeXTFDB+7a0qL35poJqkZHO9ZJwXqb1CKn6N4hc1ODHHQf/
	/2lrm0doK39iQWtacN8OTizq2nDvDUU++jyH
X-Google-Smtp-Source: ACHHUZ6JzhZeLPUw8GX3KsQoF6VZHf0ewEJBuUixnXCbPihdMYOeiS8ui+TZC0md2WulZw7AvUnvTw==
X-Received: by 2002:a05:6214:c8b:b0:626:1906:bcac with SMTP id r11-20020a0562140c8b00b006261906bcacmr12587680qvr.0.1685689246444;
        Fri, 02 Jun 2023 00:00:46 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.24])
        by smtp.gmail.com with ESMTPSA id jk11-20020a170903330b00b001ac7c725c1asm572716plb.6.2023.06.02.00.00.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jun 2023 00:00:45 -0700 (PDT)
From: menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To: olsajiri@gmail.com
Cc: davem@davemloft.net,
	dsahern@kernel.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	martin.lau@linux.dev,
	song@kernel.org,
	yhs@fb.com,
	john.fastabend@gmail.com,
	kpsingh@kernel.org,
	sdf@google.com,
	haoluo@google.com,
	jolsa@kernel.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	mykolal@fb.com,
	shuah@kernel.org,
	benbjiang@tencent.com,
	iii@linux.ibm.com,
	imagedong@tencent.com,
	xukuohai@huawei.com,
	chantr4@gmail.com,
	zwisler@google.com,
	eddyz87@gmail.com,
	netdev@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH bpf-next v2 0/5] bpf, x86: allow function arguments up to 14 for TRACING
Date: Fri,  2 Jun 2023 14:59:53 +0800
Message-Id: <20230602065958.2869555-1-imagedong@tencent.com>
X-Mailer: git-send-email 2.40.1
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

From: Menglong Dong <imagedong@tencent.com>

For now, the BPF program of type BPF_PROG_TYPE_TRACING can only be used
on the kernel functions whose arguments count less than 6. This is not
friendly at all, as too many functions have arguments count more than 6.

Therefore, let's enhance it by increasing the function arguments count
allowed in arch_prepare_bpf_trampoline(), for now, only x86_64.

In the 1th patch, we make MAX_BPF_FUNC_ARGS 14, according to our
statistics.

In the 2th patch, we make arch_prepare_bpf_trampoline() support to copy
function arguments in stack for x86 arch. Therefore, the maximum
arguments can be up to MAX_BPF_FUNC_ARGS for FENTRY and FEXIT.

And the 3-5th patches are for the testcases of the 2th patch.

Changes since v1:
- change the maximun function arguments to 14 from 12
- add testcases (Jiri Olsa)
- instead EMIT4 with EMIT3_off32 for "lea" to prevent overflow

Menglong Dong (5):
  bpf: make MAX_BPF_FUNC_ARGS 14
  bpf, x86: allow function arguments up to 14 for TRACING
  libbpf: make BPF_PROG support 15 function arguments
  selftests/bpf: rename bpf_fentry_test{7,8,9} to bpf_fentry_test_ptr*
  selftests/bpf: add testcase for FENTRY/FEXIT with 6+ arguments

 arch/x86/net/bpf_jit_comp.c                   | 96 ++++++++++++++++---
 include/linux/bpf.h                           |  9 +-
 net/bpf/test_run.c                            | 40 ++++++--
 tools/lib/bpf/bpf_helpers.h                   |  9 +-
 tools/lib/bpf/bpf_tracing.h                   | 10 +-
 .../selftests/bpf/prog_tests/bpf_cookie.c     | 24 ++---
 .../bpf/prog_tests/kprobe_multi_test.c        | 16 ++--
 .../testing/selftests/bpf/progs/fentry_test.c | 50 ++++++++--
 .../testing/selftests/bpf/progs/fexit_test.c  | 51 ++++++++--
 .../selftests/bpf/progs/get_func_ip_test.c    |  2 +-
 .../selftests/bpf/progs/kprobe_multi.c        | 12 +--
 .../bpf/progs/verifier_btf_ctx_access.c       |  2 +-
 .../selftests/bpf/verifier/atomic_fetch_add.c |  4 +-
 13 files changed, 249 insertions(+), 76 deletions(-)

-- 
2.40.1


