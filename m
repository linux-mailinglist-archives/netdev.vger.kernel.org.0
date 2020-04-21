Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13F8B1B1C99
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 05:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728140AbgDUDXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 23:23:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728117AbgDUDXd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 23:23:33 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D5BAC061A0E;
        Mon, 20 Apr 2020 20:23:33 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id w65so5967225pfc.12;
        Mon, 20 Apr 2020 20:23:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=hAkHMsgW8GMOATHz1y5uXLHZRbJthuEQUyFwW1zRZQM=;
        b=VPXUahDC4egr5T5AOQWCcO4zp+GKmqPNumciQBEnRpnZbz9csSEtIbonJvKgNgbNAC
         /26RtixkoiejDvxn5y5XE+0PoTMvwCzM+pmbIPBX50MKcxzCkABeQbwMpmTIqU5HdcMI
         tGF2eAq/W2XwbV3etne63aQT4EtjHtPRs+22FyNTB7VBrcIHyAK2U9Fx21ZnojRvl8et
         0x5FPnq2+1qBC3V8vqgaWUnuT2x3opB1vKKq2uUJAJnUeNWlbi3+BwSyf0NZoPCDV6/P
         dlilEaFTlMgUR+gMg5gpvz/Jqpc5xCy5e6SvWDnWH9oPCP15vUTRrZdhHq3fBdyX7Ljp
         noNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=hAkHMsgW8GMOATHz1y5uXLHZRbJthuEQUyFwW1zRZQM=;
        b=FVcikftf/MX7uL23/gVC84jd2B31pQO/CfW3JLgHFeTeqrnVqutbBZ6vicB3jqaq2j
         R6MqDuAxiGVQzlAPsVztC+48UqIeBPS5DDJVc3bOxsNyp4GMBUZXyY4BYmgwJ5lX4Kvv
         5v2WbF6wjmhuqdok0KF4j2EOG4gAjTn/XPpAnSXzhMVU9T0M8gyyf36IlG+8iYC5+eib
         YlworEJLL09eABM1wmonlTqAeMMNtGS5WN4pJaa1Bgpb1b3A0abtvbyXbmawF85tPvBo
         73QPc0wlTCqonMh53Hix5y2+ajHHUAGLxFoZz3DIfSYPAx5S2XYGUIdFH2hZtBl5j7d4
         y9Sg==
X-Gm-Message-State: AGi0PuaRApg566bADF7IU8WX/y4Es+Mz2Mj0HACHtjGjdThQ1a2TrNod
        jdf4jVll258Fa/aiFurA800=
X-Google-Smtp-Source: APiQypLhKGgG/jGFDVrWB+3ZbTxFK/mnqBBi4Q7+MoUlz67fb9NBBXaTrapsFcW+jfbqx8p5W2arGw==
X-Received: by 2002:a63:6d4a:: with SMTP id i71mr19464270pgc.445.1587439412118;
        Mon, 20 Apr 2020 20:23:32 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:f163])
        by smtp.gmail.com with ESMTPSA id i4sm866747pjg.4.2020.04.20.20.23.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 20:23:31 -0700 (PDT)
Date:   Mon, 20 Apr 2020 20:23:28 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Song Liu <songliubraving@fb.com>
Cc:     Mao Wenan <maowenan@huawei.com>, "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@chromium.org" <kpsingh@chromium.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        kernel-team@fb.com
Subject: Re: [PATCH bpf-next v2] bpf: remove set but not used variable
 'dst_known'
Message-ID: <20200421032328.fglmpdmnwnjts375@ast-mbp.dhcp.thefacebook.com>
References: <8855e82a-88d0-8d1e-e5e0-47e781f9653c@huawei.com>
 <20200418013735.67882-1-maowenan@huawei.com>
 <C7067847-8EDB-49B5-8DDF-C8504BB82962@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <C7067847-8EDB-49B5-8DDF-C8504BB82962@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 18, 2020 at 06:13:48AM +0000, Song Liu wrote:
> 
> 
> > On Apr 17, 2020, at 6:37 PM, Mao Wenan <maowenan@huawei.com> wrote:
> > 
> > Fixes gcc '-Wunused-but-set-variable' warning:
> > 
> > kernel/bpf/verifier.c:5603:18: warning: variable ‘dst_known’
> > set but not used [-Wunused-but-set-variable], delete this
> > variable.
> > 
> > Signed-off-by: Mao Wenan <maowenan@huawei.com>
> 
> Acked-by: Song Liu <songliubraving@fb.com>
> 
> With one nit below. 
> 
> > ---
> > v2: remove fixes tag in commit log. 
> > kernel/bpf/verifier.c | 4 +---
> > 1 file changed, 1 insertion(+), 3 deletions(-)
> > 
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index 04c6630cc18f..c9f50969a689 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -5600,7 +5600,7 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
> > {
> > 	struct bpf_reg_state *regs = cur_regs(env);
> > 	u8 opcode = BPF_OP(insn->code);
> > -	bool src_known, dst_known;
> > +	bool src_known;
> 
> This is not a hard rule, but we prefer to keep variable definition in 
> "reverse Christmas tree" order. Since we are on this function, let's 
> reorder these definitions to something like:
> 
>         u64 insn_bitness = (BPF_CLASS(insn->code) == BPF_ALU64) ? 64 : 32;
>         struct bpf_reg_state *regs = cur_regs(env);
>         u8 opcode = BPF_OP(insn->code);
>         u32 dst = insn->dst_reg;
>         s64 smin_val, smax_val;
>         u64 umin_val, umax_val;
>         bool src_known;
>         int ret;

I don't want folks to keep re-sorting variables and making patches difficult
to backport, do git blame, causing bpf vs bpf-next conflicts, etc.

reverse xmas tree is not mandatory. It's a style preference.
I personally do it for new code, but very rarely for fixes.
And certainly not for this kind of cleanup.

Applied. Thanks
