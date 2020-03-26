Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC061942DE
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 16:18:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727916AbgCZPSV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 11:18:21 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35607 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727831AbgCZPSU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 11:18:20 -0400
Received: by mail-pg1-f195.google.com with SMTP id k5so813330pga.2;
        Thu, 26 Mar 2020 08:18:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=SEZC5U5HCQ5IlqX3yXiHzE6xtayGr1pigC/qA5cGrz4=;
        b=Zi3XtTrJW4XTcmZk9BwyqxrlRqpkhuAmqXGlYq6YiVBjRH1rAxwr3d4427Pw/G81UP
         +0nvTFsoQjbkYW4DnmACQFyjaXt8b3YVNVHCXsVDJPUiFKo0u0bYSXu4s5qaQKWLK2nc
         90Q+ERjNxwXscqwkaXn/eBxVY9bZDV5Iv7LBhYC0toVY/qDc6c96vL12hHeSsMfNN9AX
         dW02IVncXhypzEJUB4PLSoN2TcX8kEoQ6qvduqFK3T6CmwKoo1riq1WBsmkDKlAmVi2k
         cbZs8g1/RrTmZHtga2RSmtsNUYMssnM6b7/KYb6Y6DwsWqughIilAndET9YZ4OwfEbOs
         M6UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=SEZC5U5HCQ5IlqX3yXiHzE6xtayGr1pigC/qA5cGrz4=;
        b=XFy1uxPLn2SfMfSlPK868L+mA61MQM5J8LBLuH5GPmRhZdFwFM1Yg3u360BeEjn1QO
         LVO7rAO5qyDyM+rgJYnVgq6is6EtcMNP/AbRnJhuEydIF/URy76K+cqeYFplH85NK1wz
         FYjegTOHqK1qudarxFOrDsLmfYwY4/riqnwLO7G1IllLaf2aSvYD6dD1wfUAniYLCdIw
         2zEvEOIbNdD+0+9euimvRCYeT9OVk//W5FFNPhvq4dKZUkdro2AzMm1ggmDwMgInoOMG
         Mov/ZLoWWI6pLNVZ9vC3E9HrqLnon3LDI+Fw/iNNtKNtHpRKtNlt8DBLNx54rRUQKW4F
         6M5A==
X-Gm-Message-State: ANhLgQ1dHL5c30wMTqyFMfAjrdfL7zJ3dNqDdslBLq505heKWNOOfNw3
        Ra8UGu1UT11sOUSbZVpzfXc=
X-Google-Smtp-Source: ADFU+vsGMzB74d9mC7lMP9fOJflkiV1YjB5mUHEiruJPCDJIkj5abfouqcJAfz3kJIYkohTQoAR69Q==
X-Received: by 2002:a65:5b49:: with SMTP id y9mr8839684pgr.153.1585235899316;
        Thu, 26 Mar 2020 08:18:19 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id c15sm1925026pfo.139.2020.03.26.08.18.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 08:18:18 -0700 (PDT)
Date:   Thu, 26 Mar 2020 08:18:09 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     ecree@solarflare.com, yhs@fb.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Message-ID: <5e7cc7b15c012_65132acbbe7fc5c4e9@john-XPS-13-9370.notmuch>
In-Reply-To: <20200326062001.3j6yqyu7jne4gtfl@ast-mbp>
References: <158507130343.15666.8018068546764556975.stgit@john-Precision-5820-Tower>
 <158507153582.15666.3091405867682349273.stgit@john-Precision-5820-Tower>
 <20200326062001.3j6yqyu7jne4gtfl@ast-mbp>
Subject: Re: [bpf-next PATCH 04/10] bpf: verifier, do explicit ALU32 bounds
 tracking
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov wrote:
> On Tue, Mar 24, 2020 at 10:38:56AM -0700, John Fastabend wrote:
> > -static void __reg_bound_offset32(struct bpf_reg_state *reg)
> > +static void __reg_combine_32_into_64(struct bpf_reg_state *reg)
> >  {
> > -	u64 mask = 0xffffFFFF;
> > -	struct tnum range = tnum_range(reg->umin_value & mask,
> > -				       reg->umax_value & mask);
> > -	struct tnum lo32 = tnum_cast(reg->var_off, 4);
> > -	struct tnum hi32 = tnum_lshift(tnum_rshift(reg->var_off, 32), 32);
> > +	/* special case when 64-bit register has upper 32-bit register
> > +	 * zeroed. Typically happens after zext or <<32, >>32 sequence
> > +	 * allowing us to use 32-bit bounds directly,
> > +	 */
> > +	if (tnum_equals_const(tnum_clear_subreg(reg->var_off), 0)) {
> > +		reg->umin_value = reg->u32_min_value;
> > +		reg->umax_value = reg->u32_max_value;
> > +		reg->smin_value = reg->s32_min_value;
> > +		reg->smax_value = reg->s32_max_value;
> 
> Looks like above will not be correct for negative s32_min/max.
> When upper 32-bit are cleared and we're processing jmp32
> we cannot set smax_value to s32_max_value.
> Consider if (w0 s< -5)
> s32_max_value == -5
> which is 0xfffffffb
> but upper 32 are zeros so smax_value should be (u64)0xfffffffb
> and not (s64)-5

Right, good catch. I'll use below logic here as well.

> 
> We can be fancy and precise with this logic, but I would just use similar
> approach from zext_32_to_64() where the following:
> +       if (reg->s32_min_value > 0)
> +               reg->smin_value = reg->s32_min_value;
> +       else
> +               reg->smin_value = 0;
> +       if (reg->s32_max_value > 0)
> +               reg->smax_value = reg->s32_max_value;
> +       else
> +               reg->smax_value = U32_MAX;
> should work for this case too ?
> 
> > +	if (BPF_SRC(insn->code) == BPF_K) {
> > +		pred = is_branch_taken(dst_reg, insn->imm, opcode, is_jmp32);
> > +	} else if (src_reg->type == SCALAR_VALUE && is_jmp32 && tnum_is_const(tnum_subreg(src_reg->var_off))) {
> > +		pred = is_branch_taken(dst_reg, tnum_subreg(src_reg->var_off).value, opcode, is_jmp32);
> > +	} else if (src_reg->type == SCALAR_VALUE && !is_jmp32 && tnum_is_const(src_reg->var_off)) {
> > +		pred = is_branch_taken(dst_reg, src_reg->var_off.value, opcode, is_jmp32);
> > +	}
> 
> pls wrap these lines. Way above normal.

+1

> 
> The rest is awesome.

Thanks.
