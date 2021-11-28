Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7115946086D
	for <lists+netdev@lfdr.de>; Sun, 28 Nov 2021 19:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358717AbhK1SM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 13:12:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20907 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1358850AbhK1SK0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Nov 2021 13:10:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638122830;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5+tkKMy/hz6PqbZUDbaCw37CPqeGEhuxeI5L74okM74=;
        b=jRu9uzk5q+1tve+OO78khA+RX1izxWpVKNq7C9l5mdCItGoCLUvWzXi/pnT1dP+0/KWNjX
        /H/bq/BKESThfrMD6AWIAotFer8oCwC/y3R/BNlBz0ZHjM3fSf1J5gQvPer5LNSUBBWn3R
        wtWwpw/0qJQH2SAp+ORIPAPDvKctN+o=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-118-4Aid0_WqOfibkj0SZEvz8w-1; Sun, 28 Nov 2021 13:07:09 -0500
X-MC-Unique: 4Aid0_WqOfibkj0SZEvz8w-1
Received: by mail-wm1-f71.google.com with SMTP id m14-20020a05600c3b0e00b0033308dcc933so9148980wms.7
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 10:07:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5+tkKMy/hz6PqbZUDbaCw37CPqeGEhuxeI5L74okM74=;
        b=FCOjccXciQn11QTAryts48KEFTQxAiFfnh4spfMEj0nxebNZ60352hSUXd4FXCViKs
         PtACGAXNV/2vlNG7zGMO5UgD4/YswqoPP6d+542CpuQrE3VA7VcZTW5wNyvB7ayfeWa7
         mC3PpX+go+kxvoztfseGfFIlGjW5I9up/Os0S5mU/xMwpJ9ccUrAee6IUg9/xyxtibcH
         Uj+bvKUtVHS1Op8gEJlhtbVMZ2bm2Gj/YyYn6vmZ31UArjdxOtU36C6MO/6mYrCXvuQa
         bO0Q2GrrRe67E7/4B9S9sZvnO8owgPSCCz1DmIIuqwUKZe8uOydAVqmBcmSEBCyJHDpS
         WEcg==
X-Gm-Message-State: AOAM533fFCfoJPJ2Ig3ZbiEba3shg9Oj2Az33yIqYCuuLmQEuOZIUmtp
        TlhuaXoiExw4jJVeDWcAaMhs3j8H/sr97YtdB/IpSC2IC3vcLG2yzttRwtCNC5ecMNRHH3GCzG9
        9TSltk9copM8oNpkU
X-Received: by 2002:a05:600c:3b8f:: with SMTP id n15mr31054695wms.180.1638122827730;
        Sun, 28 Nov 2021 10:07:07 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyDg8ujVBIy6INtxm+7OXuEVW7J8y/owj+T3ub9T/I8PgfGGu99wek9wmZi0Lbhh2r/m4WLEA==
X-Received: by 2002:a05:600c:3b8f:: with SMTP id n15mr31054666wms.180.1638122827577;
        Sun, 28 Nov 2021 10:07:07 -0800 (PST)
Received: from krava (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id z18sm11388773wrq.11.2021.11.28.10.07.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Nov 2021 10:07:07 -0800 (PST)
Date:   Sun, 28 Nov 2021 19:07:05 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [PATCH bpf-next 06/29] bpf: Add bpf_arg/bpf_ret_value helpers
 for tracing programs
Message-ID: <YaPFSesoR0uiU9DU@krava>
References: <20211118112455.475349-1-jolsa@kernel.org>
 <20211118112455.475349-7-jolsa@kernel.org>
 <CAEf4Bza0UZv6EFdELpg30o=67-Zzs6ggZext4u40+if9a5oQDg@mail.gmail.com>
 <CAADnVQLx_-GuCeE5S3KV5g+YsDfQaFS_BZ8qDCN72gYFLXjj6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQLx_-GuCeE5S3KV5g+YsDfQaFS_BZ8qDCN72gYFLXjj6A@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 25, 2021 at 09:14:15AM -0700, Alexei Starovoitov wrote:
> On Wed, Nov 24, 2021 at 2:43 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> > > +               /* Implement bpf_arg inline. */
> > > +               if (prog_type == BPF_PROG_TYPE_TRACING &&
> > > +                   insn->imm == BPF_FUNC_arg) {
> > > +                       /* Load nr_args from ctx - 8 */
> > > +                       insn_buf[0] = BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8);
> > > +                       insn_buf[1] = BPF_JMP32_REG(BPF_JGE, BPF_REG_2, BPF_REG_0, 4);
> > > +                       insn_buf[2] = BPF_ALU64_IMM(BPF_MUL, BPF_REG_2, 8);
> > > +                       insn_buf[3] = BPF_ALU64_REG(BPF_ADD, BPF_REG_2, BPF_REG_1);
> > > +                       insn_buf[4] = BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_2, 0);
> > > +                       insn_buf[5] = BPF_JMP_A(1);
> > > +                       insn_buf[6] = BPF_MOV64_IMM(BPF_REG_0, 0);
> > > +
> > > +                       new_prog = bpf_patch_insn_data(env, i + delta, insn_buf, 7);
> > > +                       if (!new_prog)
> > > +                               return -ENOMEM;
> > > +
> > > +                       delta    += 6;
> > > +                       env->prog = prog = new_prog;
> > > +                       insn      = new_prog->insnsi + i + delta;
> > > +                       continue;
> >
> > nit: this whole sequence of steps and calculations seems like
> > something that might be abstracted and hidden behind a macro or helper
> > func? Not related to your change, though. But wouldn't it be easier to
> > understand if it was just written as:
> >
> > PATCH_INSNS(
> >     BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8);
> >     BPF_JMP32_REG(BPF_JGE, BPF_REG_2, BPF_REG_0, 4);
> >     BPF_ALU64_IMM(BPF_MUL, BPF_REG_2, 8);
> >     BPF_ALU64_REG(BPF_ADD, BPF_REG_2, BPF_REG_1);
> >     BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_2, 0);
> >     BPF_JMP_A(1);
> >     BPF_MOV64_IMM(BPF_REG_0, 0));
> 
> Daniel and myself tried to do similar macro magic in the past,
> but it suffers unnecessary stack increase and extra copies.
> So eventually we got rid of it.
> I suggest staying with Jiri's approach.
> 
> Independent from anything else...
> Just noticed BPF_MUL in the above...
> Please use BPF_LSH instead. JITs don't optimize such things.
> It's a job of gcc/llvm to do so. JITs assume that all
> normal optimizations were done by the compiler.
> 

will change

thanks,
jirka

