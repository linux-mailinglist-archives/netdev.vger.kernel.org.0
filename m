Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E72727F13F
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 20:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbgI3SXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 14:23:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgI3SXC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 14:23:02 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F595C061755;
        Wed, 30 Sep 2020 11:23:02 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id a2so2017366ybj.2;
        Wed, 30 Sep 2020 11:23:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+oAjUaBmTDSFweJ2spyhLPD+8qBmhbFnzS+WMRrVI/E=;
        b=a43eLByfFs8Y0wuZcVpxxxk3iP+ORX802Sekb0vqRgAT4jUfvyMEh8w2EdE2D8Hqul
         MsJjxwpCa04jJG7MQjwjf1/tmsl4As2AECXz4yWnHx3emqEOPshCL2h8oVC26HjG491N
         sDow5nDvozNYuiP3QiN/bauVMlkUcRTN/rAWZgXD3ajF6g+VQnJQnMZ8rOfbXbdfu79f
         yLzfIUF86PiXWFLqupWaEegRE9FeknBf39cdl/z9pQ+YOb8Kf4uJF7vL1VOopBa2PDhB
         XQIDRYEAwAU5wnEozr98167FXVLJinQpk2wpohpLnCVTgdj27DO8Wjsjwrn8kLrgyJuU
         KesA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+oAjUaBmTDSFweJ2spyhLPD+8qBmhbFnzS+WMRrVI/E=;
        b=MoLJjzbh4mFLoPNSEvs7RLa6Zq2SPZcYEdHVf1PnYBLK/jv0ylV7XJ93WeUHeCvcWa
         6u1t7fPQvaj2jvBhgwR0YKTurL7Z1jtK0KhJb7Z3z0yXQJWpI3wDZe0WPGnplPTzu7BZ
         NWvu/r3561Uuy8xFGI5qTtHHojubinqV5zaJbFEyZsDwhOAE2nrvfyF7gVD32g6xJECA
         ycnOH2rIrT5dm7z1tmu2oNphu6mqBIGHdu6vaykTanveTyr0aPXei27DTb7bQrFNGx6W
         J4fxvZtYlfYQwiqXNXVRxeOHqNvldIGHk7G9jcKyWf8itX6TWCnz/E1ldaydGD2xmE2u
         I9fA==
X-Gm-Message-State: AOAM530aUsVL3Q18m2RpfsnKC44sddhMRAI/h1lMP0ZYyd9eXqiIrDcq
        cGOgWyAZEOpzFdSpWiIHlYeE+AvBgSshxvZ0vOs=
X-Google-Smtp-Source: ABdhPJycSzxOBsu52ti1q8dixbC367Fs11C1qcN6U/fJJajklnpP3fbNMtrFL8vDNHBLTh6t+uOubZft9s1tvKeYQe8=
X-Received: by 2002:a25:8541:: with SMTP id f1mr4721563ybn.230.1601490181508;
 Wed, 30 Sep 2020 11:23:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200929232843.1249318-1-andriin@fb.com> <20200930000329.bfcrg6qqvmbmlawk@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzYByimHd+FogxVHdq2-L_GLjdGEa_ku7p_c1V-hpyJrWA@mail.gmail.com> <20200930031809.lto7v7e7vtyivjon@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200930031809.lto7v7e7vtyivjon@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 30 Sep 2020 11:22:50 -0700
Message-ID: <CAEf4BzYBccn5eMNeTZDgU62kokkdTEK3wv5422_kDky3c_KWHw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/4] libbpf: add raw BTF type dumping
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 8:18 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Sep 29, 2020 at 05:44:48PM -0700, Andrii Nakryiko wrote:
> > On Tue, Sep 29, 2020 at 5:03 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Tue, Sep 29, 2020 at 04:28:39PM -0700, Andrii Nakryiko wrote:
> > > > Add btf_dump__dump_type_raw() API that emits human-readable low-level BTF type
> > > > information, same as bpftool output. bpftool is not switched to this API
> > > > because bpftool still needs to perform all the same BTF type processing logic
> > > > to do JSON output, so benefits are pretty much zero.
> > >
> > > If the only existing user cannot actually use such api it speaks heavily
> > > against adding such api to libbpf. Comparing strings in tests is nice, but
> > > could be done with C output just as well.
> >
> > It certainly can, it just won't save much code, because bpftool would
> > still need to have a big switch over BTF type kinds to do JSON output.
>
> So you're saying that most of the dump_btf_type() in bpftool/btf.c will stay as-is.
> Only 'if (json_output)' will become unconditional? Hmm.

Yes.

> I know you don't want json in libbpf, but I think it's the point of
> making a call on such things. Either libbpf gets to dump both
> json and text dump_btf_type()-like output or it stays with C only.

Right, I don't think JSON belongs in libbpf. But I fail to see why
this is the point where we need to make such a decision.

> Doing C and this text and not doing json is inconsistent.

Inconsistent with what? I've never found bpftool's raw BTF dump in
JSON format useful. At all. Saying raw BTF dump is useful and
consistent (?) only if it's both human-readable text and JSON makes no
sense to me. Libbpf doesn't have to re-implement entire bpftool
functionality.

> Either libbpf can print btf in many different ways or it stays with C.
> 2nd format is not special in any way.

I don't understand your point. With my patch it now can dump it as
valid C language definition or as a textual low-level BTF
representation.

If you are saying it should emit it in Go format, Rust format, or
other language-specific way, then sure, maybe, but it sure won't
re-use C-specific logic of btf_dump__dump_type() as is, because it is
C language specific. For Go there would be different logic, just as
for any other language. And someone will have to implement it (and
there would need to be a compelling use case for that, of course). And
it will be a different API, or at least a generic API with some enum
specifying "format" (which is the same thing, really, but inferior for
customizability reasons).

But JSON is different from that. It's just a more machine-friendly
output of textual low-level BTF dump. It could have been BSON or YAML,
but I hope you don't suggest to emit in those formats as well.

> I don't think that text and json formats bring much value comparing to C,
> so I would be fine with C only.

Noted. I disagree and find it very useful all the time, it's pretty
much the only way I look at BTF. C output is not complete: it doesn't
show functions, data sections and variables. It's not a replacement
for raw BTF dump. I don't even consider it as a different "format".
It's an entirely different and complementary (not alternative) view
(interpretation) of BTF.

> But if we allow 2nd format we should
> do json at the same time too to save bpftool the hassle.

There is no hassle for bpftool, code is written and working. Libbpf's
goal is not to minimize bpftool code either. So I hear you, but I
don't think about this the same way.

> And in the future we should allow 4th and 5th formats.

Ok, but there is no contradiction with what I'm doing here.



Regardless, feel free to drop patches #2 and #3, but patch #1 fixes
real issue, so would be nice to land it anyways. Patch #4 adds test
for changes in patch #1. Let me know if you want me to respin with
just those 2 patches.
