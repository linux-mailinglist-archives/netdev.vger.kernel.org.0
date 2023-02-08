Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7A1D68F8A3
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 21:13:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232018AbjBHUNp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 15:13:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbjBHUNo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 15:13:44 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA2931719;
        Wed,  8 Feb 2023 12:13:43 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id 184so1854279ybw.5;
        Wed, 08 Feb 2023 12:13:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KeboAakLVLBiSIvJl58LN4LxFxUvh+qeNPj6+b+HVGk=;
        b=nn/YMy4MUvoczCzos5d1l242swd87J4ILs5DfsLK0ZXkx7ebY5Jy1f6TezeDHHyyB5
         7SOlxNChQHUAQyJPxGgmUDTpJLa47HhaD4QLMcsx+HYh2f4WgE5tJU3agmLuqHe73vzR
         7CrTkz6eSy2xN5pLAU+XyPMuvbrFphggbdhSYimokszlujFKE3uZVZ61TFp8IaryvezK
         gGCR5JEBcCNdAQXkwEMjb4hLvPQqEuX+3y35RCE1FQ1I/0oyQi2Wp2T/KqSNH5Zr3ONv
         h/KuCv1yqGEZlbx9+Q4209fl+EE6p0Vfx3s9kOhRLKasNJGM8VuCHvKJAy26S91XmmyA
         ks7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KeboAakLVLBiSIvJl58LN4LxFxUvh+qeNPj6+b+HVGk=;
        b=lv1PXpo44aargCG5R8h7qU+hUg+0V0bmqXsTkX3iSbhWb/5tvenN/lG67f3qa5Tusd
         x76HUEDylJIe4qldGXkcqsrpbaLOwcZY2khCRrZbB5zhO12XcX2Yqhrn8DAQRSAiAUsS
         s0znBvqCUTvgv8GWXduVQxvi/vreELvFnUUb2nCH+fD6DL/iOnGxDCsZrF42ydWwNr+l
         ueJMmfPUFN5t1RVxbPt9NH/LSQKkWxc/ThT9tacIci8jzhHglUUkwYT3vELaBaXNxyXG
         06Hz2polptgsw9HyxqV3qEFDFmpVuPBXutYW5lz5Yljo5gadiP9oaiAunXwNF+kJuqFd
         5u0Q==
X-Gm-Message-State: AO0yUKVXOpou3652STr+T1KcgpDcErOttGMKWbilFmgr/tJvwqFUspsd
        Cu2B0hberEVaXWknx1e/RH5flp53kprT61Jx2ZcofTOf
X-Google-Smtp-Source: AK7set9rpXKEDea+FBKpCnY98D/lhIKH4bOIhYDmZixKqmfSMvsWxsCsv61C3XaLaQTa+qt1bZ0Xblc5v0KAkiZvqWU=
X-Received: by 2002:a25:830f:0:b0:80b:8dd0:7b35 with SMTP id
 s15-20020a25830f000000b0080b8dd07b35mr826161ybk.322.1675887222853; Wed, 08
 Feb 2023 12:13:42 -0800 (PST)
MIME-Version: 1.0
References: <20230130223141.r24nlg2jp5byvuph@macbook-pro-6.dhcp.thefacebook.com>
 <CAEf4Bzb9=q9TKutW8d7fOtCWaLpA12yvSh-BhL=m3+RA1_xhOQ@mail.gmail.com>
 <4b7b09b5-fd23-2447-7f05-5f903288625f@linux.dev> <CAEf4BzaQJe+UZxECg__Aga+YKrxK9KEbAuwdxA4ZBz1bQCEmSA@mail.gmail.com>
 <20230131053042.h7wp3w2zq46swfmk@macbook-pro-6.dhcp.thefacebook.com>
 <CAEf4BzbeUfmE-8Y-mm4RtZ4q=9SZ-_M-K-JF=x84o6cboUneSQ@mail.gmail.com>
 <20230201004034.sea642affpiu7yfm@macbook-pro-6.dhcp.thefacebook.com>
 <CAEf4BzbTXqhsKqPd=hDANKeg75UDbKjtX318ucMGw7a1L3693w@mail.gmail.com>
 <CAADnVQJ3CXKDJ_bZ3u2jOEPfuhALGvOi+p5cEUFxe2YgyhvB4Q@mail.gmail.com>
 <CAEf4Bzabg=YsiR6re3XLxFAptFW3sECA4v2_e0AE_TRNsDWm-w@mail.gmail.com> <20230208022511.qhkyqio2b2jvcaid@macbook-pro-6.dhcp.thefacebook.com>
In-Reply-To: <20230208022511.qhkyqio2b2jvcaid@macbook-pro-6.dhcp.thefacebook.com>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Wed, 8 Feb 2023 12:13:31 -0800
Message-ID: <CAJnrk1Ym+3QH0xFaBOGvY=nU2ohL4EDZ0kv5jMtvR_YzNsiRiw@mail.gmail.com>
Subject: Re: [PATCH v9 bpf-next 3/5] bpf: Add skb dynptrs
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
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

On Tue, Feb 7, 2023 at 6:25 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Feb 03, 2023 at 01:37:46PM -0800, Andrii Nakryiko wrote:
> > On Thu, Feb 2, 2023 at 3:43 AM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Wed, Feb 1, 2023 at 5:21 PM Andrii Nakryiko
> > > <andrii.nakryiko@gmail.com> wrote:
> > > >
> > > > On Tue, Jan 31, 2023 at 4:40 PM Alexei Starovoitov
> > > > <alexei.starovoitov@gmail.com> wrote:
> > > > >
> > > > > On Tue, Jan 31, 2023 at 04:11:47PM -0800, Andrii Nakryiko wrote:
> > > > > > >
> > > > > > > When prog is just parsing the packet it doesn't need to finalize with bpf_dynptr_write.
> > > > > > > The prog can always write into the pointer followed by if (p == buf) bpf_dynptr_write.
> > > > > > > No need for rdonly flag, but extra copy is there in case of cloned which
> > > > > > > could have been avoided with extra rd_only flag.
> > > > > >
> > > > > > Yep, given we are designing bpf_dynptr_slice for performance, extra
> > > > > > copy on reads is unfortunate. ro/rw flag or have separate
> > > > > > bpf_dynptr_slice_rw vs bpf_dynptr_slice_ro?
> > > > >
> > > > > Either flag or two kfuncs sound good to me.
> > > >
> > > > Would it make sense to make bpf_dynptr_slice() as read-only variant,
> > > > and bpf_dynptr_slice_rw() for read/write? I think the common case is
> > > > read-only, right? And if users mistakenly use bpf_dynptr_slice() for
> > > > r/w case, they will get a verifier error when trying to write into the
> > > > returned pointer. While if we make bpf_dynptr_slice() as read-write,
> > > > users won't realize they are paying a performance penalty for
> > > > something that they don't actually need.
> > >
> > > Makes sense and it matches skb_header_pointer() usage in the kernel
> > > which is read-only. Since there is no verifier the read-only-ness
> > > is not enforced, but we can do it.
> > >
> > > Looks like we've converged on bpf_dynptr_slice() and bpf_dynptr_slice_rw().
> > > The question remains what to do with bpf_dynptr_data() backed by skb/xdp.
> > > Should we return EINVAL to discourage its usage?
> > > Of course, we can come up with sensible behavior for bpf_dynptr_data(),
> > > but it will have quirks that will be not easy to document.
> > > Even with extensive docs the users might be surprised by the behavior.
> >
> > I feel like having bpf_dynptr_data() working in the common case for
> > skb/xdp would be nice (e.g., so basically at least work in cases when
> > we don't need to pull).
> >
> > But we've been discussing bpf_dynptr_slice() with Joanne today, and we
> > came to the conclusion that bpf_dynptr_slice()/bpf_dynptr_slice_rw()
> > should work for any kind of dynptr (LOCAL, RINGBUF, SKB, XDP). So
> > generic code that wants to work with any dynptr would be able to just
> > use bpf_dynptr_slice, even for LOCAL/RINGBUF, even though buffer won't
> > ever be filled for LOCAL/RINGBUF.
>
> great
>
> > In application, though, if I know I'm working with LOCAL or RINGBUF
> > (or MALLOC, once we have it), I'd use bpf_dynptr_data() to fill out
> > fixed parts, of course. bpf_dynptr_slice() would be cumbersome for
> > such cases (especially if I have some huge fixed part that I *know* is
> > available in RINGBUF/MALLOC case).
>
> bpf_dynptr_data() for local and ringbuf is fine, of course.
> It already exists and has to continue working.
> bpf_dynptr_data() for xdp is probably ok as well,
> but bpf_dynptr_data() for skb is problematic.
> data/data_end concept looked great back in 2016 when it was introduced
> and lots of programs were written, but we underestimated the impact
> of driver's copybreak on programs.
> Network parsing progs consume headers one by one and would typically
> be written as:
> if (header > data_end)
>    return DROP;
> Some drivers copybreak fixed number of bytes. Others try to be smart
> and copy only headers into linear part of skb.
> The drivers also change. At one point we tried to upgrade the kernel
> and suddenly bpf firewall started blocking valid traffic.
> Turned out the driver copybreak heuristic was changed in that kernel.
> The bpf prog was converted to use skb_load_bytes() and the fire was extinguished.
> It was a hard lesson.
> Others learned the danger of data/data_end the hard way as well.
> Take a look at cloudflare's progs/test_cls_redirect.c.
> It's a complicated combination of data/data_end and skb_load_bytes().
> It's essentially implementing skb_header_pointer.
> I wish we could use bpf_dynptr_slice only and remove data/data_end,
> but we cannot, since it's uapi.
> But we shouldn't repeat the same mistake. If we do bpf_dynptr_data()
> that returns linear part people will be hitting the same fragility and
> difficult to debug bugs.
> bpf_dynptr_data() for XDP is ok-ish, since most of XDP is still
> page-per-packet, but patches to split headers in HW are starting to appear.
> So even for XDP data/data_end concept may bite us.
> Hence my preference is to EINVAL in bpf_dynptr_data() at least for skb,
> since bpf_dynptr_slice() is a strictly better alternative.

This makes sense to me, I will have the next version of this patchset
return -EINVAL if bpf_dynptr_data() is used on a skb or xdp dynptr
