Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 502F2132EC
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 19:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728467AbfECRMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 13:12:07 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39738 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727780AbfECRMH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 13:12:07 -0400
Received: by mail-wm1-f67.google.com with SMTP id n25so7529371wmk.4
        for <netdev@vger.kernel.org>; Fri, 03 May 2019 10:12:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=JItq0clnNbfwGksYOOxSTYXceJfwEzdYsFQEskY5j2k=;
        b=1J+OplU5Tnh+crpHj/GVxsLIP6r4LWP83QVA+FcHyfq4QOg8bAG32gyX+QvDvuhfJk
         LGlufS8LbtY1WSZUFLBPLtuK82uh+96kajYQwMR0rBvkvNiZk3OvRaDlp8TecSfz3qLD
         Oz6oQRnfalCxX9ozHLUMA/i+MeAdf8c1CTCKRI5REkflC4+E9Vy8soUHyihqsQsz0Iu0
         UgQBBcYHIY2f96JODFa7rwmJ9O7aLZkmLFDW3fW7uF+AWXSKOdMy457Vu9ZuGFJkrZKm
         oYJqJz3voc6dh91r0WnfTOa+Nezxu94/8EjbEb5uNN9AXCq1LYz6dJCJWS91+vjXmVy2
         C4hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=JItq0clnNbfwGksYOOxSTYXceJfwEzdYsFQEskY5j2k=;
        b=ZQ0I7MYhZ2h90LHRSOfO9a5u/dXOXa+DcXauTRIphBrY/oFTgfja6d+U45hOuedqTY
         wESz+uYIw53mkhlUxqOPx3ZzM21kfuyEICe3MqgCT1BDKIhTRdxMt+DywLSQ+pN1JHTb
         gnt4TK5Nn7JEIuhzNPPnV2fhQQ3Jn9Of74lRBgqjFwij9tci/SmT7XjL/eWGwDDrHWLl
         vjpSDCeGyKrHMcKjsan4vtLF/WS8Gvy7UfweV+mwHqszHWObNl/aWOifmWQFeoecxpEM
         Ev6Gf30AHKR/cOBbrAWnshvjymPGEmk8nY7GpujkFwEZhlza+IP8XhnnWbDs7C6TcIBK
         jnzA==
X-Gm-Message-State: APjAAAVnwqHBLvhJx4YhsJe8VmOHDTO3ylp51GlG1ISI2MxGtzCQyEHI
        HTMR/pUvhYfpKu+rE6KGzh/k0g==
X-Google-Smtp-Source: APXvYqxf0QfaoLryA6SbPdQzJLwjOE/uoEE6nyEfNTY02EQUgNE+Z2Ej7LcHjzvrJoxxiVAbNQjEdw==
X-Received: by 2002:a1c:4d04:: with SMTP id o4mr7177413wmh.126.1556903525613;
        Fri, 03 May 2019 10:12:05 -0700 (PDT)
Received: from LAPTOP-V3S7NLPL ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id a22sm1759446wmb.47.2019.05.03.10.12.04
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 03 May 2019 10:12:04 -0700 (PDT)
References: <20190412214132.2726285-1-ast@kernel.org> <lyimv3hujp.fsf@netronome.com> <20190425043347.pxrz5ln4m7khebt6@ast-mbp.dhcp.thefacebook.com> <lylfzyeebr.fsf@netronome.com> <20190425221021.ov2jj4piann7wmid@ast-mbp.dhcp.thefacebook.com> <lyk1fgrk4m.fsf@netronome.com> <20190427030512.zs3tfdudjbfpyawh@ast-mbp> <760D400C-2548-41B6-AE34-F89A66397A75@netronome.com> <CAMsOgNDumbU7EWmOpwUoXdM5QWZ8h=W5nG3_JTFU5Tju-ofg_A@mail.gmail.com>
User-agent: mu4e 0.9.18; emacs 25.2.2
From:   Jiong Wang <jiong.wang@netronome.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        "oss-drivers\@netronome.com" <oss-drivers@netronome.com>
Subject: Re: 32-bit zext JIT efficiency (Was Re: [PATCH bpf-next] selftests/bpf: two scale tests)
In-reply-to: <CAMsOgNDumbU7EWmOpwUoXdM5QWZ8h=W5nG3_JTFU5Tju-ofg_A@mail.gmail.com>
Date:   Fri, 03 May 2019 18:12:02 +0100
Message-ID: <871s1fsbrx.fsf@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jiong Wang writes:

>> > if you can craft a test that shows patch_insn issue before your set,
>> > then it's ok to hack bpf_fill_scale1 to use alu64.
>>
>> As described above, does the test_verifier 732 + jit blinding looks convincing?
>>
>> > I would also prefer to go with option 2 (new zext insn) for JITs.
>>
>> Got it.
>
> I followed option 2 and have sent out v5 with latests changes/fixes:

Had done second look at various back-ends, now noticed one new issue,
some arches are not consistent on implicit zext. For example, for s390,
alu32 move could be JITed using single instruction "llgfr" which will do
implicit zext, but alu32 move on PowerPC needs explicit zext. Then for
riscv, all BPF_ALU | BPF_K needs zext but not for some of BPF_ALU | BPF_X.
So, while these arches are generally better off after verifier zext
insertion enabled, but there do have unnecessary zext inserted by verifier
for them case by case.

Also, for 64-bit arches like PowerPC, S390 etc, they normally has zero
extended load, so narrowed load doesn't need extra zext insn, but for
32-bit arches like arm, narrowed load always need explicit zext.

All these differences are because of BPF_ALU32 or BPF_LDX + B | H | W
will be eventually mapped to diversified back-ends which do not have
consistent ISA semantics.

Given all these, looks like pass down the analysis info to back-ends
and let them do the decision become the choice again?

Regards,
Jiong

> The major changes are:
>   - introduced BPF_ZEXT, even though it doesn't resolve insn patch in-efficient,
>     but could let JIT back-ends do optimal code-gen, and the change is small,
>     so perhap just better to support it in this set.
>   - while look insn patch code, I feel patched-insn need to be conservatiely
>     marked if any insn inside patch buffer define sub-register.
>   - Also fixed helper function return value handling bug. I am thinking helper
>     function should have accurate return value type description, otherwise
>     there could be bug. For example arm32 back-end just executes the native
>     helper functions and doesn't do anything special on the return value. So
>     a function returns u32 would only set native reg r0, not r1 in the pair.
>     Then if the outside eBPF insn is casting it into u64, there needs to be
>     zext.
>   - adjusted test_verifier to make sure it could pass on hosts w and w/o hw
>     zext.
>
> For more info, please see the cover letter and patch description at v5.
>
> Thanks.
> Regards,
> Jiong

