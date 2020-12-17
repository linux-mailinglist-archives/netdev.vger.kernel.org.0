Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 507E92DCC5F
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 07:12:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726547AbgLQGMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 01:12:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbgLQGMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 01:12:17 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A52A3C061794;
        Wed, 16 Dec 2020 22:11:37 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id r4so14553809pls.11;
        Wed, 16 Dec 2020 22:11:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JJLPgf2Y0mDkkc1vkHFYGNB370dPas8KyACzY3FeqzM=;
        b=vL7fHqO0ocxoX4dWHMTH6KNpp87dPd0r38MbUvgR4gCkuQs/y90jrKVH8Poz6i1Gpn
         x/vo5Lnk/uZoE3vTPABxrvIzmNzl/DHzCd+KGx8Wc9MSF4eGxeHq/ndreKB+a7KltsAt
         Bev9L30t7HbRmXL149D+mr5NhMDDRcwl+Sy1q7PQFByFzRMkojk7MLPXIO17j4TH2fCl
         6yS5yVLB7yaXyPVNnF7ba30KMpMjqqAijyRlBmI5XbcgSC1b0BWdsVzwVYBVb79zSQQe
         yzcNRezdeqfM9irSiSTNYmnWOmZGsnvRt3mD/6eNEp5vjvX79yjv6VmDX1Hq9ijfuW5L
         FZHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JJLPgf2Y0mDkkc1vkHFYGNB370dPas8KyACzY3FeqzM=;
        b=G8L6jOlwxzue3gXeh6bcy1xMabXusXx0HqgyZDUvS5J3Pourhz5dzdnfK9a+Vl3mHK
         NzMYonZ6/jJoJ0Mz0hdZK6JWrbMy5IkzKdAI53/hIBrIRhObC/Ut6CYoE/fYcBylZk8l
         IHxPAI/8lFtQjgTmdoAwNQ0Ts3S7tPmwgFQLkySiFQnSmTnt/lk3k2dgDfy9EzZHUFHE
         eywhrhs4/GU7+kdo02Zl7KDPaRJlWFNCUFqOJa1+7BUcJvYm4biOpdb+gmlBM80my/gy
         B/TPM/Gh1tJEvq1AJtADrAFOU2f1Yop0tYjtOQDCdmOi4h/RZ2Kd1UM6K6Z9A1K0cPC7
         k8iw==
X-Gm-Message-State: AOAM5318t7ZpQz1Nm7XX1lsFbaujfIM7xgGBK2896elTLkUPU9MQy0R+
        P2te1LdTkllHNxGJO+rDZTU=
X-Google-Smtp-Source: ABdhPJzh6V3z7p7nJ1vaEisJTTrE1URn14pIf3oVCHL1wcbE9UoQ7+WJlT220V+87qqpph+fQYJgZw==
X-Received: by 2002:a17:90a:66ce:: with SMTP id z14mr6398972pjl.153.1608185497134;
        Wed, 16 Dec 2020 22:11:37 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:5c8d])
        by smtp.gmail.com with ESMTPSA id j17sm4225112pfh.183.2020.12.16.22.11.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Dec 2020 22:11:36 -0800 (PST)
Date:   Wed, 16 Dec 2020 22:11:33 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org, naveen.n.rao@linux.ibm.com,
        sandipan@linux.ibm.com, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [RFC PATCH v1 7/7] powerpc/bpf: Implement extended BPF on PPC32
Message-ID: <20201217061133.lnfnhbzvikgtjb3i@ast-mbp>
References: <cover.1608112796.git.christophe.leroy@csgroup.eu>
 <1fed5e11ba08ee28d12f3f57986e5b143a6aa937.1608112797.git.christophe.leroy@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1fed5e11ba08ee28d12f3f57986e5b143a6aa937.1608112797.git.christophe.leroy@csgroup.eu>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 16, 2020 at 10:07:37AM +0000, Christophe Leroy wrote:
> Implement Extended Berkeley Packet Filter on Powerpc 32
> 
> Test result with test_bpf module:
> 
> 	test_bpf: Summary: 378 PASSED, 0 FAILED, [354/366 JIT'ed]

nice!

> Registers mapping:
> 
> 	[BPF_REG_0] = r11-r12
> 	/* function arguments */
> 	[BPF_REG_1] = r3-r4
> 	[BPF_REG_2] = r5-r6
> 	[BPF_REG_3] = r7-r8
> 	[BPF_REG_4] = r9-r10
> 	[BPF_REG_5] = r21-r22 (Args 9 and 10 come in via the stack)
> 	/* non volatile registers */
> 	[BPF_REG_6] = r23-r24
> 	[BPF_REG_7] = r25-r26
> 	[BPF_REG_8] = r27-r28
> 	[BPF_REG_9] = r29-r30
> 	/* frame pointer aka BPF_REG_10 */
> 	[BPF_REG_FP] = r31
> 	/* eBPF jit internal registers */
> 	[BPF_REG_AX] = r19-r20
> 	[TMP_REG] = r18
> 
> As PPC32 doesn't have a redzone in the stack,
> use r17 as tail call counter.
> 
> r0 is used as temporary register as much as possible. It is referenced
> directly in the code in order to avoid misuse of it, because some
> instructions interpret it as value 0 instead of register r0
> (ex: addi, addis, stw, lwz, ...)
> 
> The following operations are not implemented:
> 
> 		case BPF_ALU64 | BPF_DIV | BPF_X: /* dst /= src */
> 		case BPF_ALU64 | BPF_MOD | BPF_X: /* dst %= src */
> 		case BPF_STX | BPF_XADD | BPF_DW: /* *(u64 *)(dst + off) += src */
> 
> The following operations are only implemented for power of two constants:
> 
> 		case BPF_ALU64 | BPF_MOD | BPF_K: /* dst %= imm */
> 		case BPF_ALU64 | BPF_DIV | BPF_K: /* dst /= imm */

Those are sensible limitations. MOD and DIV are rare, but XADD is common.
Please consider doing it as a cmpxchg loop in the future.

Also please run test_progs. It will give a lot better coverage than test_bpf.ko
