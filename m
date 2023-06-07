Return-Path: <netdev+bounces-8845-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 697E1726027
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 14:59:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C6ACC1C20DFD
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 12:59:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A412CC8C3;
	Wed,  7 Jun 2023 12:59:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 917758F57;
	Wed,  7 Jun 2023 12:59:23 +0000 (UTC)
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01980173A;
	Wed,  7 Jun 2023 05:59:22 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id d2e1a72fcca58-651ffcc1d3dso4220980b3a.3;
        Wed, 07 Jun 2023 05:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686142761; x=1688734761;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=txvj5oWtc/P31GV0Uh1xo1g1fJq1FY4eNv//yMt29W4=;
        b=YEmcdpxFcB9I3H+YO71oKMJvqeEPaPcKcpdXTTDvzrTc7gGD8VD4dGMLnaMfPGrlEK
         kgd/2SmEYn0uauk1LiXglu9G5fkPmtGTQwBYi3Vh5UJHui64HY8Y7OxkJqq5NsUksjDV
         SuNMs7eTRqhxTk47UMXzVWZPdGWghqJ9+cG21kmfzB3Exxa+3WN8XUBC/AlI7mWZWZhT
         wifR3esCLt84eJqCP+UOTIEcd0MymXErhnLDIZOEYH0aDMMuvippZcq3LG5QtjEYl6Ag
         +XVOgenvomX9fmzX+rjQTVMR5NbrX9UeLMe6O1O1SlEsbKMcTMsWnU620A84ovYMLUhP
         2MvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686142761; x=1688734761;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=txvj5oWtc/P31GV0Uh1xo1g1fJq1FY4eNv//yMt29W4=;
        b=VOAWvqZmrv8J4RXRGWW2OBsUFdXKv55AK1daE/6/fayEF1Iz4DIC9ltcoGSy7Uy/uB
         3twsOsG5OYBtO4B+GuuhTL+DV7yIXIid8+F6mR9G+RN0DdsnB66mWOFHLWq+BMrzHrAJ
         2gw3cmDLvyJlxBuKq5Tvr9ph85tm0tOdO7UQDyAH98rB0mb2GoQktcqJZcAOz1YLj6D+
         BXYidzSSmP29Y2VEFmNCCxzigGfzBv0kiZYft3tqbtMJLjdJphQVAdO+HGsbq14VdG/b
         UaV25d9mJ83JBxsQO60bQ4e2y7l2I+Wh7oNBQCc17sKg2R08V3Ri9rHTdxcHvwEJ8SV9
         WP5Q==
X-Gm-Message-State: AC+VfDy7XqIVxM0aAhEXxVK7BB3Lb/QIo3E93SwI/To49eduWn4+8Kqc
	d57N/aoMh0Wjw1o9M/IaoGU=
X-Google-Smtp-Source: ACHHUZ468ZYczZiHpClqRTXLv/5ahvrbiFFb9eGS1+/PHOQ/d1103CXBz38d+Eo892TcGqARMCXQAQ==
X-Received: by 2002:a05:6a00:14d4:b0:646:b165:1b29 with SMTP id w20-20020a056a0014d400b00646b1651b29mr4246139pfu.23.1686142761234;
        Wed, 07 Jun 2023 05:59:21 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.83])
        by smtp.gmail.com with ESMTPSA id p1-20020a62ab01000000b0065434edd521sm7094982pff.196.2023.06.07.05.59.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 05:59:20 -0700 (PDT)
From: menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To: alexei.starovoitov@gmail.com
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
	x86@kernel.org,
	imagedong@tencent.com,
	benbjiang@tencent.com,
	netdev@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH bpf-next v3 0/3] bpf, x86: allow function arguments up to 12 for TRACING
Date: Wed,  7 Jun 2023 20:59:08 +0800
Message-Id: <20230607125911.145345-1-imagedong@tencent.com>
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

In the 1st patch, we make arch_prepare_bpf_trampoline() support to copy
function arguments in stack for x86 arch. Therefore, the maximum
arguments can be up to MAX_BPF_FUNC_ARGS for FENTRY and FEXIT.

In the 2nd patch, we clean garbage value in upper bytes of the trampoline
when we store the arguments from regs into stack.

And the 3rd patches are for the testcases of the 1st patch.

Changes since v2:
- keep MAX_BPF_FUNC_ARGS still
- clean garbage value in upper bytes in the 2nd patch
- move bpf_fentry_test{7,12} to bpf_testmod.c and rename them to
  bpf_testmod_fentry_test{7,12} meanwhile in the 3rd patch

Changes since v1:
- change the maximun function arguments to 14 from 12
- add testcases (Jiri Olsa)
- instead EMIT4 with EMIT3_off32 for "lea" to prevent overflow


Menglong Dong (3):
  bpf, x86: allow function arguments up to 12 for TRACING
  bpf, x86: clean garbage value in the stack of trampoline
  selftests/bpf: add testcase for FENTRY/FEXIT with 6+ arguments

 arch/x86/net/bpf_jit_comp.c                   | 105 +++++++++++++++---
 .../selftests/bpf/bpf_testmod/bpf_testmod.c   |  19 +++-
 .../selftests/bpf/prog_tests/fentry_fexit.c   |   4 +-
 .../selftests/bpf/prog_tests/fentry_test.c    |   2 +
 .../selftests/bpf/prog_tests/fexit_test.c     |   2 +
 .../testing/selftests/bpf/progs/fentry_test.c |  21 ++++
 .../testing/selftests/bpf/progs/fexit_test.c  |  33 ++++++
 7 files changed, 169 insertions(+), 17 deletions(-)

-- 
2.40.1


