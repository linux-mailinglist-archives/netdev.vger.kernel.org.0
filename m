Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 588993173BB
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 23:55:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233201AbhBJWze (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 17:55:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232903AbhBJWzb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 17:55:31 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91311C061574;
        Wed, 10 Feb 2021 14:54:51 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id b187so3705834ybg.9;
        Wed, 10 Feb 2021 14:54:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZXz5YZuf2za/bd0ruVs5jppqFpT1p2Bn/R0pEI/u9IQ=;
        b=lj+c0WB/GD1l6mR/jBRsSo6P8i9gHxgrM/aFg8gaH6XHsO986ceC6e9STpKnSx/PGf
         SlkNDVpsxdpcgSpQNM0dmUbphsFn56OxjqljGLdSoqbE+HvMEO+VdzXlVqjryn90AnI5
         WWioagSLrQWPQv75AosYeP21rMMagK5KJPgyRBB4NfaaQZtfliYxDhNcd+AsbAtqIslr
         580mhoNBEry03cXOfwG28+xQCeUyowAS2qlEMI45w5PFAjcrmZOupjxnx+gfcRE4+KqG
         48JTDHuTLub8dcNlCeBP8yWQ/Nxnu2d81XvT/eLCSAPNr3KKV7/SOVYiBSWWLHlo0iIK
         YKdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZXz5YZuf2za/bd0ruVs5jppqFpT1p2Bn/R0pEI/u9IQ=;
        b=jMa1uTLNhwprXqqloU18CXK4/DiCP02gZr6vF+ag6FlNDYs86kIv1V1QKvpNOP2iog
         shBWLscOvGYmiZcshYtzuBNImPwCMy1GaMhwR5VNklV/jr7n50k53g3S1o0hAuIiwkTo
         KbcaQUVBeGM+OTRQyBlmYqzExLXutGViaOwMGRhFgQGCglgVrOGB5AWWTfqBHlKbL7I8
         DXLlhe9S5DgmlRxhSkrIBMBTYdTHiNEAAl9kNKsJCO7pjT9i7LwfbBCoskm5ZA1dQlb+
         Tm2r130klwzvLcessdqX7/eK0PHasmeIkGBhNmOAqjIQgLSCCUStu95fRHJKee93Mxmt
         BcHg==
X-Gm-Message-State: AOAM533UhDnPVBe7psBd+grj6K2XXEvdB8nwC59ODz8s/o48n+ihpfsm
        2YiuM6JOOOZBXPBQPjR5KKH/F/32AeHHZoi72mA=
X-Google-Smtp-Source: ABdhPJyAw77vCkUqPpcd4/R83NB0+d5zfXC1xBJoceN8WfuRQWIKdcZcZ0xtmclktlsQD1su2w2LRuMHJSYcsO6Q24g=
X-Received: by 2002:a25:f40e:: with SMTP id q14mr7114416ybd.230.1612997690881;
 Wed, 10 Feb 2021 14:54:50 -0800 (PST)
MIME-Version: 1.0
References: <20210209193105.1752743-1-kafai@fb.com> <20210209193112.1752976-1-kafai@fb.com>
 <CAEf4BzbZmmezSxYLCOdeeA4zW+vdDvQH57wQ-qpFSKiMcE1tVw@mail.gmail.com> <20210210211735.4snmhc7gofo6zrp5@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20210210211735.4snmhc7gofo6zrp5@kafai-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 10 Feb 2021 14:54:40 -0800
Message-ID: <CAEf4BzbhBng6k5e_=p0+mFSpQS7=BM_ute9eskViw-VCMTcYYA@mail.gmail.com>
Subject: Re: [PATCH bpf 2/2] bpf: selftests: Add non function pointer test to struct_ops
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 10, 2021 at 1:17 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Wed, Feb 10, 2021 at 12:27:38PM -0800, Andrii Nakryiko wrote:
> > On Tue, Feb 9, 2021 at 12:11 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > >
> > > This patch adds a "void *owner" member.  The existing
> > > bpf_tcp_ca test will ensure the bpf_cubic.o and bpf_dctcp.o
> > > can be loaded.
> > >
> > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > ---
> >
> > Acked-by: Andrii Nakryiko <andrii@kernel.org>
> >
> > What will happen if BPF code initializes such non-func ptr member?
> > Will libbpf complain or just ignore those values? Ignoring initialized
> > members isn't great.
> The latter. libbpf will ignore non-func ptr member.  The non-func ptr
> member stays zero when it is passed to the kernel.
>
> libbpf can be changed to copy this non-func ptr value.
> The kernel will decide what to do with it.  It will
> then be consistent with int/array member like ".name"
> and ".flags" where the kernel will verify the value.
> I can spin v2 to do that.

I was thinking about erroring out on non-zero fields, but if you think
it's useful to pass through values, it could be done, but will require
more and careful code, probably. So, basically, don't feel obligated
to do this in this patch set.

>
> >
> > >  tools/testing/selftests/bpf/bpf_tcp_helpers.h | 1 +
> > >  1 file changed, 1 insertion(+)
> > >
> > > diff --git a/tools/testing/selftests/bpf/bpf_tcp_helpers.h b/tools/testing/selftests/bpf/bpf_tcp_helpers.h
> > > index 6a9053162cf2..91f0fac632f4 100644
> > > --- a/tools/testing/selftests/bpf/bpf_tcp_helpers.h
> > > +++ b/tools/testing/selftests/bpf/bpf_tcp_helpers.h
> > > @@ -177,6 +177,7 @@ struct tcp_congestion_ops {
> > >          * after all the ca_state processing. (optional)
> > >          */
> > >         void (*cong_control)(struct sock *sk, const struct rate_sample *rs);
> > > +       void *owner;
> > >  };
> > >
> > >  #define min(a, b) ((a) < (b) ? (a) : (b))
> > > --
> > > 2.24.1
> > >
