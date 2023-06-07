Return-Path: <netdev+bounces-8840-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DEBA725FC2
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 14:41:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CC3441C20D9E
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 12:41:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC918BE72;
	Wed,  7 Jun 2023 12:41:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A6C626;
	Wed,  7 Jun 2023 12:41:07 +0000 (UTC)
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3F5D1FCE;
	Wed,  7 Jun 2023 05:40:38 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id 4fb4d7f45d1cf-51492ae66a4so1200351a12.1;
        Wed, 07 Jun 2023 05:40:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686141598; x=1688733598;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oyRCnZIlgTCZS2k2cmw93gRfUkOIg3FCKHPsHdQmeTI=;
        b=lTn59UvZK+9m4otDdCVvmwo232X4opAq22YknH/PcMiXVPVtRJoFEl63k3iNbGvIOL
         j44U9wcpWQ6o+d3+3hshH25V99ElOO+NBe++S80p3y6ZT7/w/ajrGMGZg6tDm8Fide3j
         em7Gu8NhAyAqwTUD9zaWE154sNNrS0BRQx2WTxnz5LeHT3DzqZNaqg4LhoLcUN3meCdH
         NGYCT/spStzrJFzLbBsOMPW12aeg1QpoJNxXBe1BgQgMdthROTnuKTg3GX4EnUs7l1g8
         F+w0G5ZIV7Tn3fs1/roex23dRpv4KPuaqqbpd//X3eKtIxgBQiuOod2whacm6vQYaFzQ
         KzUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686141598; x=1688733598;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oyRCnZIlgTCZS2k2cmw93gRfUkOIg3FCKHPsHdQmeTI=;
        b=hkHdsPME8J6LzPxjkUduVUo5ARD6Bn4wlqg/47o0pf7eIT8/VOwyHlEpwz0OBlpIiD
         te2cyWnCUbeAly9td0ObsOKRUrntAQi19MH2iwfIWy032lJfsSmCT7sy3ChmBY2cF26S
         ZAp1pwf7SpWvp13/EW6MorzxokVTjCJxl+14UIwSygYh1EL7aPT3EbN0uFggaxeiuNg4
         TwmK82FFdOiMu5pdnSsovI3qbfV8ytKtZCwkqPXDNJgKRQyyBj/ou2o6oyBoPPkb9lm9
         hwE1NVQ65hKvx0Qu3NXqaXINRak7TIOGRsEcR6cVvP7dRsET6Vnk+UYt6Efpvd052Q82
         zEZw==
X-Gm-Message-State: AC+VfDw0YJCmrqGxNYbK9pjzBPKhktQN43Qnh00y+DobohDiNGlkrE7o
	7F2pZr3Lrpg46P/TEKF+k9NgfXYwittjtFIklF8=
X-Google-Smtp-Source: ACHHUZ6g9G0Sg19PYJ91PERIrVvtJwYa3xtlsNxjuvp5JETX3NxH955Y9/Y7ynmSsxeFpTciUipMsg==
X-Received: by 2002:a05:6402:31e2:b0:514:8d9a:386 with SMTP id dy2-20020a05640231e200b005148d9a0386mr4498975edb.30.1686141597690;
        Wed, 07 Jun 2023 05:39:57 -0700 (PDT)
Received: from localhost (tor-exit-48.for-privacy.net. [185.220.101.48])
        by smtp.gmail.com with ESMTPSA id c17-20020aa7c751000000b0050bc6d0e880sm5135597eds.61.2023.06.07.05.39.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 05:39:57 -0700 (PDT)
From: Maxim Mikityanskiy <maxtram95@gmail.com>
To: bpf@vger.kernel.org
Cc: netdev@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Maxim Mikityanskiy <maxim@isovalent.com>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yhs@fb.com>,
	KP Singh <kpsingh@kernel.org>,
	Stanislav Fomichev <sdf@google.com>,
	Hao Luo <haoluo@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Mykola Lysenko <mykolal@fb.com>,
	Shuah Khan <shuah@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Jesper Dangaard Brouer <hawk@kernel.org>
Subject: [PATCH bpf v4 1/2] bpf: Fix verifier id tracking of scalars on spill
Date: Wed,  7 Jun 2023 15:39:50 +0300
Message-Id: <20230607123951.558971-2-maxtram95@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230607123951.558971-1-maxtram95@gmail.com>
References: <20230607123951.558971-1-maxtram95@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,RCVD_IN_BL_SPAMCOP_NET,RCVD_IN_DNSWL_NONE,
	RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Maxim Mikityanskiy <maxim@isovalent.com>

The following scenario describes a bug in the verifier where it
incorrectly concludes about equivalent scalar IDs which could lead to
verifier bypass in privileged mode:

1. Prepare a 32-bit rogue number.
2. Put the rogue number into the upper half of a 64-bit register, and
   roll a random (unknown to the verifier) bit in the lower half. The
   rest of the bits should be zero (although variations are possible).
3. Assign an ID to the register by MOVing it to another arbitrary
   register.
4. Perform a 32-bit spill of the register, then perform a 32-bit fill to
   another register. Due to a bug in the verifier, the ID will be
   preserved, although the new register will contain only the lower 32
   bits, i.e. all zeros except one random bit.

At this point there are two registers with different values but the same
ID, which means the integrity of the verifier state has been corrupted.

5. Compare the new 32-bit register with 0. In the branch where it's
   equal to 0, the verifier will believe that the original 64-bit
   register is also 0, because it has the same ID, but its actual value
   still contains the rogue number in the upper half.
   Some optimizations of the verifier prevent the actual bypass, so
   extra care is needed: the comparison must be between two registers,
   and both branches must be reachable (this is why one random bit is
   needed). Both branches are still suitable for the bypass.
6. Right shift the original register by 32 bits to pop the rogue number.
7. Use the rogue number as an offset with any pointer. The verifier will
   believe that the offset is 0, while in reality it's the given number.

The fix is similar to the 32-bit BPF_MOV handling in check_alu_op for
SCALAR_VALUE. If the spill is narrowing the actual register value, don't
keep the ID, make sure it's reset to 0.

Fixes: 354e8f1970f8 ("bpf: Support <8-byte scalar spill and refill")
Signed-off-by: Maxim Mikityanskiy <maxim@isovalent.com>
Acked-by: Yonghong Song <yhs@fb.com>
---
 kernel/bpf/verifier.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 5871aa78d01a..0dd8adc7a159 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3868,6 +3868,9 @@ static int check_stack_write_fixed_off(struct bpf_verifier_env *env,
 				return err;
 		}
 		save_register_state(state, spi, reg, size);
+		/* Break the relation on a narrowing spill. */
+		if (fls64(reg->umax_value) > BITS_PER_BYTE * size)
+			state->stack[spi].spilled_ptr.id = 0;
 	} else if (!reg && !(off % BPF_REG_SIZE) && is_bpf_st_mem(insn) &&
 		   insn->imm != 0 && env->bpf_capable) {
 		struct bpf_reg_state fake_reg = {};
-- 
2.40.1


