Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C45F4E3841
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 06:19:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236698AbiCVFTq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 01:19:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236653AbiCVFTm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 01:19:42 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 214AEDFD4;
        Mon, 21 Mar 2022 22:18:16 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id c23so3436018plo.0;
        Mon, 21 Mar 2022 22:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zj0a8iCuZT7u7wHmcYUPl4M0YrDNUxtwZIfHRK8GPWE=;
        b=AHoNe3gkppcRexArdqaUq+NlCuYltTSmaKojRagWIEWtbTeNCHms80tGfjxnt9vP+r
         ftlR4OCKctqj1EGDA29DYEa49j6rdmR9eA4xAROYK8sl+4MmeW/294dEmp8mFPkuxMCT
         b4nSYDuO9Lp6l/itrvwZ28sdcTmsgN0s4WIXV+TbT80apZZrTElIX+kgGNuXYvUXaPEf
         aM+APpTlV3nZ0IbxFi19kZqdGbcwmYYNJvMrJfi6yX7ZXzQnQBvgkXrA/MCVhtOcIogH
         CaeS5TrNQ/77CaKwcNxZUrW1wlQKaKzrPI8wbYI0kxWaPZ46u93cLSXvZ9ZGQMT23K9l
         GpZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zj0a8iCuZT7u7wHmcYUPl4M0YrDNUxtwZIfHRK8GPWE=;
        b=rW9jRAPQGAlBIwwBnDigsCCrzQV5UEvDEbedlsrfphxiGtM58vGqM+03hZcCc/vqnz
         746TjR1U++KOOKFh2K9RJHkFg4Z+byBHyWTKk9zvby4jB7/p7dYmkU7DbZjPskd27umr
         627fKE4sCoKZSeafmVq3LM9+7c5S57TfSsr2WLJBQ/XqCP6x6CRT2VEddkSATAJVsTGn
         ABkm6YAVNTKT7iYKDNFGWmV0kgnZY5Bb1Z+0jp9iifNzIy9pUcwUwcIXy34m0OdDG2Da
         9CSMOpz8pKittKmQzcP4oVUbR80+x0jbfoArjQ0srMOy1JKTCKEo4Qy+MljV63wz+Bzl
         AaMg==
X-Gm-Message-State: AOAM531mWf2XNsxlmLXgkH9IqCtNQc+wzvhwmaL5frpKc3SaJv95qLfR
        KIhcrT8XEiHjwawBWWZDU4U1Osy3O3UubLv6X0k=
X-Google-Smtp-Source: ABdhPJwKim2p5ZiUAZaMUgUUt1wpv67R6G9MYl5FgVyyk1dmMui6uNQHCidaquxZPb1zHgGIwWINlrAzApLooc/sG2o=
X-Received: by 2002:a17:90b:1a81:b0:1bc:c3e5:27b2 with SMTP id
 ng1-20020a17090b1a8100b001bcc3e527b2mr2941997pjb.20.1647926295541; Mon, 21
 Mar 2022 22:18:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220321224608.55798-1-alexei.starovoitov@gmail.com>
 <CAHk-=wheGrBxOfMpWhQg1iswCKYig8vADnFVsA4oFWTY9NU5jA@mail.gmail.com>
 <CAADnVQK=JsytH_OtT6Q6fnijkTyv7NANV2902woQ6XT-fwWXQA@mail.gmail.com>
 <CAHk-=wi0fNH+FS-ng2Nvq2p1Jbfn+-G1AsK-XY7MD4gTJZg5ZA@mail.gmail.com>
 <CAADnVQKreLtGkfAVXxwLGUVKobqYhBS5r+GtNa6Oc8BUzYa92Q@mail.gmail.com>
 <20220322113641.763885257f741ac5c0cb2c06@kernel.org> <CAADnVQ+HEeBXm0qXdnxn1of-dPr7THcVZxb9Adud0t9epVsWKQ@mail.gmail.com>
 <20220322140537.d3f3fa3600d3b80c4f226e7c@kernel.org>
In-Reply-To: <20220322140537.d3f3fa3600d3b80c4f226e7c@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 21 Mar 2022 22:18:04 -0700
Message-ID: <CAADnVQKXi_sO-3ouBM0DnGvtEp0SjdzctPRD-E_ODv=XxH+SFw@mail.gmail.com>
Subject: Re: pull-request: bpf-next 2022-03-21
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 21, 2022 at 10:05 PM Masami Hiramatsu <mhiramat@kernel.org> wrote:
>
> On Mon, 21 Mar 2022 21:35:55 -0700
> Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
>
> > On Mon, Mar 21, 2022 at 7:36 PM Masami Hiramatsu <mhiramat@kernel.org> wrote:
> > >
> > > Hi Linus and Alexei,
> > >
> > > At first, sorry about this issue. I missed to Cc'ed to arch maintainers.
> > >
> > > On Mon, 21 Mar 2022 17:31:28 -0700
> > > Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> > >
> > > > On Mon, Mar 21, 2022 at 4:59 PM Linus Torvalds
> > > > <torvalds@linux-foundation.org> wrote:
> > > > >
> > > > > On Mon, Mar 21, 2022 at 4:11 PM Alexei Starovoitov
> > > > > <alexei.starovoitov@gmail.com> wrote:
> > > > > >
> > > > > > Did you look at the code?
> > > > > > In particular:
> > > > > > https://lore.kernel.org/bpf/164735286243.1084943.7477055110527046644.stgit@devnote2/
> > > > > >
> > > > > > it's a copy paste of arch/x86/kernel/kprobes/core.c
> > > > > >
> > > > > > How is it "bad architecture code" ?
> > > > >
> > > > > It's "bad architecture code" because the architecture maintainers have
> > > > > made changes to check ENDBR in the meantime.
> > > > >
> > > > > So it used to be perfectly fine. It's not any longer - and the
> > > > > architecture maintainers were clearly never actually cc'd on the
> > > > > changes, so they didn't find out until much too late.
> > >
> > > Let me retry porting fprobe on top of ENDBR things and confirm with
> > > arch maintainers.
> >
> > Just look at linux-next.
> > objtool warning is the only issue.
>
> Actually, there are conflicts with arm tree and Rust tree too.
> I found I missed the objtool annotation patch on IBT series and fixed it.

4 arch patches were reverted.

> >
> > > >
> > > > Not denying that missing cc was an issue.
> > > >
> > > > We can drop just arch patches:
> > > >       rethook: x86: Add rethook x86 implementation
> > > >       arm64: rethook: Add arm64 rethook implementation
> > > >       powerpc: Add rethook support
> > > >       ARM: rethook: Add rethook arm implementation
> > > >
> > > > or everything including Jiri's work on top of it.
> > > > Which would be a massive 27 patches.
> > > >
> > > > We'd prefer the former, of course.
> > > > Later during the merge window we can add a single
> > > > 'rethook: x86' patch that takes endbr into account,
> > > > so that multi-kprobe feature will work on x86.
> > > > For the next merge window we can add other archs.
> > > > Would that work?
> > >
> > > BTW, As far as I can see the ENDBR things, the major issue on fprobe
> > > is that the ftrace'ed ip address will be different from the symbol
> > > address (even) on x86. That must be ensured to work before merge.
> > > Let me check it on Linus's tree at first.
> >
> > That's not an issue. Peter tweaked ftrace logic and fprobe plugs
> > into that.
> > The fprobe/multi-kprobe works fine in linux-next.
>
> Yeah, I think fprobe should work because it uses
> ftrace_location_range(func-entry, func-end) for non-x86 arch.
>
> >
> > bpf selftest for multi kprobe needs this hack:
> > diff --git a/tools/testing/selftests/bpf/progs/kprobe_multi.c
> > b/tools/testing/selftests/bpf/progs/kprobe_multi.c
> > index af27d2c6fce8..530a64e2996a 100644
> > --- a/tools/testing/selftests/bpf/progs/kprobe_multi.c
> > +++ b/tools/testing/selftests/bpf/progs/kprobe_multi.c
> > @@ -45,7 +45,7 @@ static void kprobe_multi_check(void *ctx, bool is_return)
> >         __u64 addr = bpf_get_func_ip(ctx);
> >
> >  #define SET(__var, __addr, __cookie) ({                        \
> > -       if (((const void *) addr == __addr) &&          \
> > +       if (((const void *) addr == __addr + 4) &&              \
> >              (!test_cookie || (cookie == __cookie)))    \
>
> Hmm, this is an ugly hack... You need to use actual ftrace addr, instead of
> symbol addr. With IBT series, you can use ftrace_location(symbol-addr) to
> get the ftrace-addr. (e.g. addr == ftrace_location(__addr) should work)

It's a temporary hack.
bpf prog cannot call an arbitrary function like ftrace_location.

> >
> > to pass when both CONFIG_FPROBE=y and CONFIG_X86_KERNEL_IBT=y.
> > The test is too strict. It didn't account for the possibility of endbr.
> >
> > So I'm inclined to drop only 4 arch patches instead of the whole thing.
>
> OK, but it is hard to understand how it works without knowing rethook itself.
> I would like to send whole v13 patch series to arch maintainers.

fprobe is a glorified kprobe and pretty simple code by itself.
It's too late for v13. Please send 'rethook: x86' patch only
with endbr annotations and get it acked.
The other archs will wait until the next merge window.
