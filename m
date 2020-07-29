Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43EAC2316E5
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 02:44:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730902AbgG2Aoa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 20:44:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730668AbgG2Ao3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 20:44:29 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F1A9C061794;
        Tue, 28 Jul 2020 17:44:29 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id s189so15519161iod.2;
        Tue, 28 Jul 2020 17:44:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=vjygI3y795JKAhW6PSPg+ukEQBMaqLi+pV64cQREuNg=;
        b=L0N9qnQ8Kbeb06XKAzaXkg6jmUXCQ/FqgjJa6pDAxaJh6/RpLLC9wRdFjqHKSRV17M
         wv88t6I3iAHrH0d+bN6Y527x56xpBLS3SHrRNWH7MaFqA+EIMJK+YhnIQijUcZdMqJoj
         qIGwUOo2e3OSBba4tKkCMQALWcrqlDBa7qEXK5Q4Yc2WK36Uw2WpBD756i8yIxHNjZ2U
         7M/SX8PhAb383cMHfnQ9pe0BGPoKY0CM2gzwMi8ds+UbZUjhSwM6wPnj6CEOFm+4x6fU
         iJsgDNuWjyEwUgHE5BlR/3I+vv2L6ufsrGAhZ3DFtm7mrJ4KnoHJT8UpFeMVtCom2ErX
         l14w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=vjygI3y795JKAhW6PSPg+ukEQBMaqLi+pV64cQREuNg=;
        b=E3BnCCMF9ytfI1M5L7Qm9IMxztN2qoghXAvuB9HXmQx+HqaTsYx3mxm2hdrj9UztYD
         /Np+3xHAP2Sa1+vGbvp0oEZNp12z8V/ArA4RytlqoFropyi7kAITZYTy+YaE/Nmg3DHZ
         67epJlsetRgfSd+BB+k+SXeY0+SoVCJrff8vI0DSQgbotFZd0bFT0l88mJxfleiHC9m3
         KYtNJc+zrM+zfnOONoYPMb2YSp/5XVIDSKd5Dfa3wDI8hq6NuTrj/eR0UtvvdT4MO2Eo
         xykQ7iv2ycW4JyzCbl8GdQaeetJtXDEE8pVTct2ENkXkFVjI7i4cIDhzTHMC9Yn+HuYv
         CFGQ==
X-Gm-Message-State: AOAM532NEtOYsUfV7N1PwHilaoiUd19YFiSSvlDDLpyAyReqTTM1S/Jt
        0F0HbYw4xgQ8zdLHWVnPdY4=
X-Google-Smtp-Source: ABdhPJwaNwUNCgX2MypQ9zVbeRRqxvLeH+V8L/j1Mzmmt67qk6HZpdDcUh6PK02qBrEdER52JFKi5A==
X-Received: by 2002:a05:6602:2409:: with SMTP id s9mr9170569ioa.98.1595983468858;
        Tue, 28 Jul 2020 17:44:28 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id a24sm204716ioe.46.2020.07.28.17.44.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2020 17:44:28 -0700 (PDT)
Date:   Tue, 28 Jul 2020 17:44:19 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Martin KaFai Lau <kafai@fb.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     daniel@iogearbox.net, ast@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Message-ID: <5f20c663a4106_2fe92b13c67445b4a5@john-XPS-13-9370.notmuch>
In-Reply-To: <20200728211500.zrjzrjg7x2k2gtx2@kafai-mbp>
References: <159595098028.30613.5464662473747133856.stgit@john-Precision-5820-Tower>
 <159595102637.30613.6373296730696919300.stgit@john-Precision-5820-Tower>
 <20200728172317.zdgkzfrones6pa54@kafai-mbp>
 <5f2090bac65ef_2fe92b13c67445b47d@john-XPS-13-9370.notmuch>
 <20200728211500.zrjzrjg7x2k2gtx2@kafai-mbp>
Subject: Re: [bpf PATCH 1/3] bpf: sock_ops ctx access may stomp registers in
 corner case
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin KaFai Lau wrote:
> On Tue, Jul 28, 2020 at 01:55:22PM -0700, John Fastabend wrote:
> > Martin KaFai Lau wrote:
> > > On Tue, Jul 28, 2020 at 08:43:46AM -0700, John Fastabend wrote:
> > > > I had a sockmap program that after doing some refactoring started spewing
> > > > this splat at me:
> > > > 
> > > > [18610.807284] BUG: unable to handle kernel NULL pointer dereference at 0000000000000001
> > > > [...]
> > > > [18610.807359] Call Trace:
> > > > [18610.807370]  ? 0xffffffffc114d0d5
> > > > [18610.807382]  __cgroup_bpf_run_filter_sock_ops+0x7d/0xb0
> > > > [18610.807391]  tcp_connect+0x895/0xd50
> > > > [18610.807400]  tcp_v4_connect+0x465/0x4e0
> > > > [18610.807407]  __inet_stream_connect+0xd6/0x3a0
> > > > [18610.807412]  ? __inet_stream_connect+0x5/0x3a0
> > > > [18610.807417]  inet_stream_connect+0x3b/0x60
> > > > [18610.807425]  __sys_connect+0xed/0x120
> > > > 
> > 
> > [...]
> > 
> > > > So three additional instructions if dst == src register, but I scanned
> > > > my current code base and did not see this pattern anywhere so should
> > > > not be a big deal. Further, it seems no one else has hit this or at
> > > > least reported it so it must a fairly rare pattern.
> > > > 
> > > > Fixes: 9b1f3d6e5af29 ("bpf: Refactor sock_ops_convert_ctx_access")
> > > I think this issue dated at least back from
> > > commit 34d367c59233 ("bpf: Make SOCK_OPS_GET_TCP struct independent")
> > > There are a few refactoring since then, so fixing in much older
> > > code may not worth it since it is rare?
> > 
> > OK I just did a quick git annotate and pulled out the last patch
> > there. I didn't go any farther back. The failure is rare and has
> > the nice property that it crashes hard always. For example I found
> > it by simply running some of our go tests after doing the refactor.
> > I guess if it was in some path that doesn't get tested like an
> > error case or something you might have an ugly surprise in production.
> > I can imagine a case where tracking this down might be difficult.
> > 
> > OTOH the backport wont be automatic past some of those reworks.
> > 
> > > 
> > > > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> > > > ---
> > > >  net/core/filter.c |   26 ++++++++++++++++++++++++--
> > > >  1 file changed, 24 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/net/core/filter.c b/net/core/filter.c
> > > > index 29e34551..c50cb80 100644
> > > > --- a/net/core/filter.c
> > > > +++ b/net/core/filter.c
> > > > @@ -8314,15 +8314,31 @@ static u32 sock_ops_convert_ctx_access(enum bpf_access_type type,
> > > >  /* Helper macro for adding read access to tcp_sock or sock fields. */
> > > >  #define SOCK_OPS_GET_FIELD(BPF_FIELD, OBJ_FIELD, OBJ)			      \
> > > >  	do {								      \
> > > > +		int fullsock_reg = si->dst_reg, reg = BPF_REG_9, jmp = 2;     \
> > > >  		BUILD_BUG_ON(sizeof_field(OBJ, OBJ_FIELD) >		      \
> > > >  			     sizeof_field(struct bpf_sock_ops, BPF_FIELD));   \
> > > > +		if (si->dst_reg == reg || si->src_reg == reg)		      \
> > > > +			reg--;						      \
> > > > +		if (si->dst_reg == reg || si->src_reg == reg)		      \
> > > > +			reg--;						      \
> > > > +		if (si->dst_reg == si->src_reg) {			      \
> > > > +			*insn++ = BPF_STX_MEM(BPF_DW, si->src_reg, reg,	      \
> > > > +					  offsetof(struct bpf_sock_ops_kern,  \
> > > > +				          temp));			      \
> > > Instead of sock_ops->temp, can BPF_REG_AX be used here as a temp?
> > > e.g. bpf_convert_shinfo_access() has already used it as a temp also.

OTOH it looks like we will cause the bpf_jit_blind_insn() to abort on those
instructions.

I'm not sure it matters for performance see'ing we are in a bit of an
edge case. iirc Daniel wrote that code so maybe its best to see if he has
any opinions.

@Daniel, Do you have a preference? If we use REG_RAX it seems the insns
will be skipped over by bpf_jit_blind_insn otoh its slightly faster I guess
to skip the load/store.

> > 
> > Sure I will roll a v2 I agree that rax is a bit nicer. I guess for
> > bpf-next we can roll the load over to use rax as well? Once the
> > fix is in place I'll take a look it would be nice for consistency.
> Agree that it would be nice to do the same in SOCK_OPS_SET_FIELD() also
> and this improvement could be done in bpf-next.
> 
> > 
> > > 
> > > Also, it seems the "sk" access in sock_ops_convert_ctx_access() suffers
> > > a similar issue.
> > 
> > Good catch. I'll fix it up as well. Maybe with a second patch and test.
> > Patches might be a bit verbose but makes it easier to track the bugs
> > I think.
> Thanks for taking care of it!


