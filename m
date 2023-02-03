Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 093CB68A4D0
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 22:38:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233788AbjBCViD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 16:38:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233743AbjBCViB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 16:38:01 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEBB81BF3;
        Fri,  3 Feb 2023 13:37:59 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id qw12so19036433ejc.2;
        Fri, 03 Feb 2023 13:37:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/ZxFQE2LBmgQJ5car0QtxgR3Ka3TtNP91Nkf6qbF3aw=;
        b=q0zfd883yy3fKrJDxWlwj9GZ9SfD8W/5CG9jv4cjCvXGIDKVhVKMjweUd180CHUrP7
         MCbA45t6k5qq0wNPx3gZG4/y0cpgrthqezoYDKiHHTobcj+WmuNS2ckRjZS7RvZXGpv2
         WcjyUctflr93l11KFW1QmEzMtf21y7WYDHufZPcJAT4dThAkECHVTJuykUr3BppyQwgq
         LalcWT6nSuQ5eyE0LSBxJ2kjfQ/yPFvGPdXfGM8cIm1cS7wqvsXNjrlsmpbDv/9FeKbP
         5eUsf1EFsk2kepOt9jbsAHnGRBdXo/YEODz9ctHcIIfNtpOD+WA0ucDZCF3dtxy/f5eO
         1Buw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/ZxFQE2LBmgQJ5car0QtxgR3Ka3TtNP91Nkf6qbF3aw=;
        b=pTYiKexFc6vOCiROuZy/e7Qs+z6u+5s3EAv3GlluPOBYUra9P4zda+V1hhON6llz5R
         Eb67X25XBqDYr8Smb0VuuOfJUuhHCrh/pgl6GzfUnhHvr0Accn78W1coHT0Jhu6/PB7Q
         SbyK6OF+2xDDVE95lUmn1U6rlZ5xO1ei3YTtiaOyqyRvnb2cMqGpPBbLreh7kwAF3mzw
         U0iMFmQUwkYIny5Njr8SyW031ZYBybIFXmUsCJnTMQwgFDYPBia18Ei/WxbEbEAC3FqX
         TwMtbbOr34lW8NXaT/D+a6bkYCKZynJcFa2zhK71pIvifdjv18hnVHms6z7QBj8dv+g2
         wD5Q==
X-Gm-Message-State: AO0yUKXmuK2B6myjCAkCF6eEGJdH8Uad0tA82YdhGDH9MB+Cu3v5GXyS
        Ylkr/hGldF/4LWeClVPXfGxWNnDwNNvEFYq6tD0=
X-Google-Smtp-Source: AK7set9J52eDguZLiTNxT/1ew99SDEMnY7+LLzaq5O4+nG5HSsAsGTpkqjGe5y5uTLlHpbhw0M0Q4rnV7rmpCza6Dy4=
X-Received: by 2002:a17:906:cb9a:b0:877:5b9b:b426 with SMTP id
 mf26-20020a170906cb9a00b008775b9bb426mr3127536ejb.12.1675460279299; Fri, 03
 Feb 2023 13:37:59 -0800 (PST)
MIME-Version: 1.0
References: <20230127191703.3864860-1-joannelkoong@gmail.com>
 <20230127191703.3864860-4-joannelkoong@gmail.com> <5715ea83-c4aa-c884-ab95-3d5e630cad05@linux.dev>
 <20230130223141.r24nlg2jp5byvuph@macbook-pro-6.dhcp.thefacebook.com>
 <CAEf4Bzb9=q9TKutW8d7fOtCWaLpA12yvSh-BhL=m3+RA1_xhOQ@mail.gmail.com>
 <4b7b09b5-fd23-2447-7f05-5f903288625f@linux.dev> <CAEf4BzaQJe+UZxECg__Aga+YKrxK9KEbAuwdxA4ZBz1bQCEmSA@mail.gmail.com>
 <20230131053042.h7wp3w2zq46swfmk@macbook-pro-6.dhcp.thefacebook.com>
 <CAEf4BzbeUfmE-8Y-mm4RtZ4q=9SZ-_M-K-JF=x84o6cboUneSQ@mail.gmail.com>
 <20230201004034.sea642affpiu7yfm@macbook-pro-6.dhcp.thefacebook.com>
 <CAEf4BzbTXqhsKqPd=hDANKeg75UDbKjtX318ucMGw7a1L3693w@mail.gmail.com> <CAADnVQJ3CXKDJ_bZ3u2jOEPfuhALGvOi+p5cEUFxe2YgyhvB4Q@mail.gmail.com>
In-Reply-To: <CAADnVQJ3CXKDJ_bZ3u2jOEPfuhALGvOi+p5cEUFxe2YgyhvB4Q@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 3 Feb 2023 13:37:46 -0800
Message-ID: <CAEf4Bzabg=YsiR6re3XLxFAptFW3sECA4v2_e0AE_TRNsDWm-w@mail.gmail.com>
Subject: Re: [PATCH v9 bpf-next 3/5] bpf: Add skb dynptrs
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Martin KaFai Lau <martin.lau@linux.dev>,
        Joanne Koong <joannelkoong@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Kernel Team <kernel-team@fb.com>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 2, 2023 at 3:43 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Feb 1, 2023 at 5:21 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Tue, Jan 31, 2023 at 4:40 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Tue, Jan 31, 2023 at 04:11:47PM -0800, Andrii Nakryiko wrote:
> > > > >
> > > > > When prog is just parsing the packet it doesn't need to finalize with bpf_dynptr_write.
> > > > > The prog can always write into the pointer followed by if (p == buf) bpf_dynptr_write.
> > > > > No need for rdonly flag, but extra copy is there in case of cloned which
> > > > > could have been avoided with extra rd_only flag.
> > > >
> > > > Yep, given we are designing bpf_dynptr_slice for performance, extra
> > > > copy on reads is unfortunate. ro/rw flag or have separate
> > > > bpf_dynptr_slice_rw vs bpf_dynptr_slice_ro?
> > >
> > > Either flag or two kfuncs sound good to me.
> >
> > Would it make sense to make bpf_dynptr_slice() as read-only variant,
> > and bpf_dynptr_slice_rw() for read/write? I think the common case is
> > read-only, right? And if users mistakenly use bpf_dynptr_slice() for
> > r/w case, they will get a verifier error when trying to write into the
> > returned pointer. While if we make bpf_dynptr_slice() as read-write,
> > users won't realize they are paying a performance penalty for
> > something that they don't actually need.
>
> Makes sense and it matches skb_header_pointer() usage in the kernel
> which is read-only. Since there is no verifier the read-only-ness
> is not enforced, but we can do it.
>
> Looks like we've converged on bpf_dynptr_slice() and bpf_dynptr_slice_rw().
> The question remains what to do with bpf_dynptr_data() backed by skb/xdp.
> Should we return EINVAL to discourage its usage?
> Of course, we can come up with sensible behavior for bpf_dynptr_data(),
> but it will have quirks that will be not easy to document.
> Even with extensive docs the users might be surprised by the behavior.

I feel like having bpf_dynptr_data() working in the common case for
skb/xdp would be nice (e.g., so basically at least work in cases when
we don't need to pull).

But we've been discussing bpf_dynptr_slice() with Joanne today, and we
came to the conclusion that bpf_dynptr_slice()/bpf_dynptr_slice_rw()
should work for any kind of dynptr (LOCAL, RINGBUF, SKB, XDP). So
generic code that wants to work with any dynptr would be able to just
use bpf_dynptr_slice, even for LOCAL/RINGBUF, even though buffer won't
ever be filled for LOCAL/RINGBUF.

In application, though, if I know I'm working with LOCAL or RINGBUF
(or MALLOC, once we have it), I'd use bpf_dynptr_data() to fill out
fixed parts, of course. bpf_dynptr_slice() would be cumbersome for
such cases (especially if I have some huge fixed part that I *know* is
available in RINGBUF/MALLOC case).

With this setup we probably won't ever need bpf_dynptr_data_rdonly(),
because we can say to use bpf_dynptr_slice() for that (even with an
unnecessary buffer).
