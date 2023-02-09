Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3147568FC0C
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 01:40:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230360AbjBIAkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 19:40:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjBIAkE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 19:40:04 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 902411717F;
        Wed,  8 Feb 2023 16:40:02 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id rp23so1886822ejb.7;
        Wed, 08 Feb 2023 16:40:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Lg6RtsS948v/Nk7SSNMm0UjBXINqzO5aMdYqDJB5sKg=;
        b=XDbG+Pa5MejTfXOYmu/DnhPkKc8F09fou4EJZRMdZOjAJ5wc8ShAkMU5HJ2mxd47nh
         t2L9S3QboD9arz13mLhVgDlzB8JPumRsLec9/75Q0/vEWmQxMZkz6YC4saWr6eCwOabH
         ICyLEGR0ImedKvEd1wAFoq0PRFU9qJBQoeEWW8t+9DvXo4bZyZmGZWGvSGx4X7nW3zkw
         QfhKfPxYGEwISIpTMjIJ6EY9bfCpSe457yvz99C2AALzuFeCM1ue892oVUGHvBcyN4XO
         k407QOmsbWkTM2PBAAk/C1fjmFnKWoDr66wTsqZvonwu52WEsRAvaAPXV5r4327ZCVRF
         P2Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Lg6RtsS948v/Nk7SSNMm0UjBXINqzO5aMdYqDJB5sKg=;
        b=w/MNfc+GO/s0HS2VZww9gazMPn9efjB3119bwahMaZWv2wwN2nFXaQpMqjBDu+r/h/
         2KLM2Wn/FmJVFsmoAe0vVGQnWSIOjHmp53/05qAeAlK2kwgMGyuG1dFB6xniXGchSxML
         zJLn0U3yg4lIlaxGQy0zAAtAlly8i8Uzofp+IrXxJpUgDrN0w35/pbwpEAKCOAOAINja
         LCP7aPHjrUccdR01oZOIJKH6wjEk7wyoAm95oMXStGzvnsS8h8dFkRkLl/gDx+f+OKgc
         iPyIUhWF/D7DLjgxjq7yEjKpqEAk4tUdI0jD/Yhz4e37xJLFxeaaxj1A0kqeVGGGCuLy
         2HxA==
X-Gm-Message-State: AO0yUKXinjFrI0itEAtbTw86FOwlFoFS84Sx8D8jpRJuchkFzpLCDmxX
        VanAzs/MM7PDaFSFAJatKsy6QNjDB5gjvHQ6bqPeGc1O
X-Google-Smtp-Source: AK7set+CtbGR2QOtGe0CqzS+CZ+IDz/DNEc0T7Snpid5CnR3A0/URhNWp6HezLRk98nm5Pe+/IacIQZsIV1fcG9woMQ=
X-Received: by 2002:a17:906:5a60:b0:8aa:bdec:d9ae with SMTP id
 my32-20020a1709065a6000b008aabdecd9aemr1327000ejc.12.1675903201061; Wed, 08
 Feb 2023 16:40:01 -0800 (PST)
MIME-Version: 1.0
References: <20230130223141.r24nlg2jp5byvuph@macbook-pro-6.dhcp.thefacebook.com>
 <CAEf4Bzb9=q9TKutW8d7fOtCWaLpA12yvSh-BhL=m3+RA1_xhOQ@mail.gmail.com>
 <4b7b09b5-fd23-2447-7f05-5f903288625f@linux.dev> <CAEf4BzaQJe+UZxECg__Aga+YKrxK9KEbAuwdxA4ZBz1bQCEmSA@mail.gmail.com>
 <20230131053042.h7wp3w2zq46swfmk@macbook-pro-6.dhcp.thefacebook.com>
 <CAEf4BzbeUfmE-8Y-mm4RtZ4q=9SZ-_M-K-JF=x84o6cboUneSQ@mail.gmail.com>
 <20230201004034.sea642affpiu7yfm@macbook-pro-6.dhcp.thefacebook.com>
 <CAEf4BzbTXqhsKqPd=hDANKeg75UDbKjtX318ucMGw7a1L3693w@mail.gmail.com>
 <CAADnVQJ3CXKDJ_bZ3u2jOEPfuhALGvOi+p5cEUFxe2YgyhvB4Q@mail.gmail.com>
 <CAEf4Bzabg=YsiR6re3XLxFAptFW3sECA4v2_e0AE_TRNsDWm-w@mail.gmail.com>
 <20230208022511.qhkyqio2b2jvcaid@macbook-pro-6.dhcp.thefacebook.com> <CAJnrk1Ym+3QH0xFaBOGvY=nU2ohL4EDZ0kv5jMtvR_YzNsiRiw@mail.gmail.com>
In-Reply-To: <CAJnrk1Ym+3QH0xFaBOGvY=nU2ohL4EDZ0kv5jMtvR_YzNsiRiw@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 8 Feb 2023 16:39:48 -0800
Message-ID: <CAEf4Bzby522xzpCLWMnD708j+ihxUhVEniPoDLbYZVwbVueRSw@mail.gmail.com>
Subject: Re: [PATCH v9 bpf-next 3/5] bpf: Add skb dynptrs
To:     Joanne Koong <joannelkoong@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
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

On Wed, Feb 8, 2023 at 12:13 PM Joanne Koong <joannelkoong@gmail.com> wrote:
>
> On Tue, Feb 7, 2023 at 6:25 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Fri, Feb 03, 2023 at 01:37:46PM -0800, Andrii Nakryiko wrote:
> > > On Thu, Feb 2, 2023 at 3:43 AM Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > >
> > > > On Wed, Feb 1, 2023 at 5:21 PM Andrii Nakryiko
> > > > <andrii.nakryiko@gmail.com> wrote:
> > > > >
> > > > > On Tue, Jan 31, 2023 at 4:40 PM Alexei Starovoitov
> > > > > <alexei.starovoitov@gmail.com> wrote:
> > > > > >
> > > > > > On Tue, Jan 31, 2023 at 04:11:47PM -0800, Andrii Nakryiko wrote:
> > > > > > > >
> > > > > > > > When prog is just parsing the packet it doesn't need to finalize with bpf_dynptr_write.
> > > > > > > > The prog can always write into the pointer followed by if (p == buf) bpf_dynptr_write.
> > > > > > > > No need for rdonly flag, but extra copy is there in case of cloned which
> > > > > > > > could have been avoided with extra rd_only flag.
> > > > > > >
> > > > > > > Yep, given we are designing bpf_dynptr_slice for performance, extra
> > > > > > > copy on reads is unfortunate. ro/rw flag or have separate
> > > > > > > bpf_dynptr_slice_rw vs bpf_dynptr_slice_ro?
> > > > > >
> > > > > > Either flag or two kfuncs sound good to me.
> > > > >
> > > > > Would it make sense to make bpf_dynptr_slice() as read-only variant,
> > > > > and bpf_dynptr_slice_rw() for read/write? I think the common case is
> > > > > read-only, right? And if users mistakenly use bpf_dynptr_slice() for
> > > > > r/w case, they will get a verifier error when trying to write into the
> > > > > returned pointer. While if we make bpf_dynptr_slice() as read-write,
> > > > > users won't realize they are paying a performance penalty for
> > > > > something that they don't actually need.
> > > >
> > > > Makes sense and it matches skb_header_pointer() usage in the kernel
> > > > which is read-only. Since there is no verifier the read-only-ness
> > > > is not enforced, but we can do it.
> > > >
> > > > Looks like we've converged on bpf_dynptr_slice() and bpf_dynptr_slice_rw().
> > > > The question remains what to do with bpf_dynptr_data() backed by skb/xdp.
> > > > Should we return EINVAL to discourage its usage?
> > > > Of course, we can come up with sensible behavior for bpf_dynptr_data(),
> > > > but it will have quirks that will be not easy to document.
> > > > Even with extensive docs the users might be surprised by the behavior.
> > >
> > > I feel like having bpf_dynptr_data() working in the common case for
> > > skb/xdp would be nice (e.g., so basically at least work in cases when
> > > we don't need to pull).
> > >
> > > But we've been discussing bpf_dynptr_slice() with Joanne today, and we
> > > came to the conclusion that bpf_dynptr_slice()/bpf_dynptr_slice_rw()
> > > should work for any kind of dynptr (LOCAL, RINGBUF, SKB, XDP). So
> > > generic code that wants to work with any dynptr would be able to just
> > > use bpf_dynptr_slice, even for LOCAL/RINGBUF, even though buffer won't
> > > ever be filled for LOCAL/RINGBUF.
> >
> > great
> >
> > > In application, though, if I know I'm working with LOCAL or RINGBUF
> > > (or MALLOC, once we have it), I'd use bpf_dynptr_data() to fill out
> > > fixed parts, of course. bpf_dynptr_slice() would be cumbersome for
> > > such cases (especially if I have some huge fixed part that I *know* is
> > > available in RINGBUF/MALLOC case).
> >
> > bpf_dynptr_data() for local and ringbuf is fine, of course.
> > It already exists and has to continue working.
> > bpf_dynptr_data() for xdp is probably ok as well,
> > but bpf_dynptr_data() for skb is problematic.
> > data/data_end concept looked great back in 2016 when it was introduced
> > and lots of programs were written, but we underestimated the impact
> > of driver's copybreak on programs.
> > Network parsing progs consume headers one by one and would typically
> > be written as:
> > if (header > data_end)
> >    return DROP;
> > Some drivers copybreak fixed number of bytes. Others try to be smart
> > and copy only headers into linear part of skb.
> > The drivers also change. At one point we tried to upgrade the kernel
> > and suddenly bpf firewall started blocking valid traffic.
> > Turned out the driver copybreak heuristic was changed in that kernel.
> > The bpf prog was converted to use skb_load_bytes() and the fire was extinguished.
> > It was a hard lesson.
> > Others learned the danger of data/data_end the hard way as well.
> > Take a look at cloudflare's progs/test_cls_redirect.c.
> > It's a complicated combination of data/data_end and skb_load_bytes().
> > It's essentially implementing skb_header_pointer.
> > I wish we could use bpf_dynptr_slice only and remove data/data_end,
> > but we cannot, since it's uapi.
> > But we shouldn't repeat the same mistake. If we do bpf_dynptr_data()
> > that returns linear part people will be hitting the same fragility and
> > difficult to debug bugs.
> > bpf_dynptr_data() for XDP is ok-ish, since most of XDP is still
> > page-per-packet, but patches to split headers in HW are starting to appear.
> > So even for XDP data/data_end concept may bite us.
> > Hence my preference is to EINVAL in bpf_dynptr_data() at least for skb,
> > since bpf_dynptr_slice() is a strictly better alternative.
>
> This makes sense to me, I will have the next version of this patchset
> return -EINVAL if bpf_dynptr_data() is used on a skb or xdp dynptr

+1, sounds reasonable to me as well
