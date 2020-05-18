Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 584B21D88C2
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 22:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbgERUD0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 16:03:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726250AbgERUD0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 16:03:26 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38A22C061A0C;
        Mon, 18 May 2020 13:03:26 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id k6so12088275iob.3;
        Mon, 18 May 2020 13:03:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=agQ+4wVRhoNV84CE8L8RDwfrGYoUTzWhBPUecoU6cFU=;
        b=GiJIt1Y4ZBzOrTL6Vk8tvGR2iPbK+qzTetK/qCOePrM+9cjRoToENU6WvCKPRndC+w
         U+gsIx/D+A5Mk1mXnhQ+CGgq4nI46Z4e2vi1RnfsFUPd6X7pM80a0DV6BD9Flyadzksy
         uxTUBubzem2D2B1/JsV8t5kvnyKsZP/CbZehIV2b4SItwexa3DNrzSkiCF1qPTwuf2hJ
         X52sOc5eFE8Gb/SsCQIGRWEBDKjmPXE/s8ghHgrDykJ3ES3QcMN5/oenEg712XRWDP5w
         OkXKRzE7PrUAqMIkSMAuwY+Ulk1Lj1qmjz2mizLizg5AH9sRnC1AkmimkfgueSny2egI
         CycQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=agQ+4wVRhoNV84CE8L8RDwfrGYoUTzWhBPUecoU6cFU=;
        b=m4ZmBxztTrn5z1yLXzir2Wp2aBGc1rYy2+S0iSL0rfLdfp3EBurNWy5uT4cLHXgXTm
         xwle/VYGnVmgeC1QimUTnErprzKZPM/Wa6xp90f7HmyIIElU7fQTOvw2BRlMcqTjsOp+
         9AksJE7G7G+FuBLaKGeBD6hhnzxg8CUeJRT2do36OJCwrel1NxuHcDlGWeYFzShuRqWM
         kcbfq2AmeL7siYRmhLMGbmmDAD5ouft7yMKG3kX08biTskHcuRNJzX8FQq8RA7MXTvxN
         Kdkb5BoFgomFR0X6pZbtyuCdbSyfhoJrtAL/UyQhDuad4VzFvjN7O9Ot2FuyRJKvUwXY
         54mQ==
X-Gm-Message-State: AOAM533sbVv6195nTJt3d/gGG+UUrxsibgnxMLquzDTy7mUxc4QN2SqC
        P6uMQ+PlJiM/BzkqQBb7FCJngHjX
X-Google-Smtp-Source: ABdhPJzQWbC+TghvxDozC9S7az+xajKIignd18z0rxgb1NKZHazGA1ZuZTSmaB6Fsp351oTuK/2aZw==
X-Received: by 2002:a05:6602:1616:: with SMTP id x22mr14806513iow.70.1589832204397;
        Mon, 18 May 2020 13:03:24 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id j16sm5220029ild.8.2020.05.18.13.03.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 May 2020 13:03:23 -0700 (PDT)
Subject: [bpf-next PATCH 3/4] bpf: selftests,
 verifier case for non null pointer map value branch
From:   John Fastabend <john.fastabend@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Mon, 18 May 2020 13:03:11 -0700
Message-ID: <158983219168.6512.11784750707821433806.stgit@john-Precision-5820-Tower>
In-Reply-To: <158983199930.6512.18408887419883363781.stgit@john-Precision-5820-Tower>
References: <158983199930.6512.18408887419883363781.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we have pointer type that is known to be non-null we only follow
the non-null branch. This adds tests to cover the map_value pointer
returned from a map lookup. To force an error if both branches are
followed we do an ALU op on R10.

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 .../testing/selftests/bpf/verifier/value_or_null.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/tools/testing/selftests/bpf/verifier/value_or_null.c b/tools/testing/selftests/bpf/verifier/value_or_null.c
index 860d4a7..3ecb70a 100644
--- a/tools/testing/selftests/bpf/verifier/value_or_null.c
+++ b/tools/testing/selftests/bpf/verifier/value_or_null.c
@@ -150,3 +150,22 @@
 	.result_unpriv = REJECT,
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
+{
+	"map lookup and null branch prediction",
+	.insns = {
+	BPF_MOV64_IMM(BPF_REG_1, 10),
+	BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_1, -8),
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
+	BPF_LD_MAP_FD(BPF_REG_1, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
+	BPF_MOV64_REG(BPF_REG_6, BPF_REG_0),
+	BPF_JMP_IMM(BPF_JEQ, BPF_REG_6, 0, 2),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_6, 0, 1),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_10, 10),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_hash_8b = { 4 },
+	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
+	.result = ACCEPT,
+},

