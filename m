Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20F9668E606
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 03:25:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbjBHCZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 21:25:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjBHCZQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 21:25:16 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83C7A1EBF9;
        Tue,  7 Feb 2023 18:25:15 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id bg10-20020a17090b0d8a00b00230c7f312d4so802767pjb.3;
        Tue, 07 Feb 2023 18:25:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JfqGk5wMOrYNgmKWtE6YY496xj2xTnNZkY5IUVgJtE4=;
        b=XnNpVt7HK4isrOXWfC3uIBCEk3bgPsYneNd4NNSJHHAETMgJQZn1+sOjbtuiNtxdI0
         tpsabV/skmm6Nbn8nBHgPkJOHF+/2cuk/C0h4wvMZU/PigTj9dpUXh6PNue6P/O12XH2
         8UGZS5IaP8rIorfX8EDyDn6bYdR8NAvnVKhxh25o+5DOagotBX+b0FdvOVG6G71zoKVH
         Ytt9Bo19Diu9TXAEMczWNToNWD3V+MeITyvzKdsAhTVLfFXiIao+50gYGqAIwcpMvukv
         z2bm3vrCMGGXmtk52O66/yVBedAzm6rHY3GYCSltM6DL42UmlJFe82Ij+XHsxiEly0hh
         0Row==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JfqGk5wMOrYNgmKWtE6YY496xj2xTnNZkY5IUVgJtE4=;
        b=HH3WWflq24Qbe3WwmbkicKGe+xDzrj0VedLAEOi/KRz4LXY4IpiDDOgf/PKnd682/w
         uwDS909iXk/NPds96yZ9KTqLGrM2zYiouO68bQLu2k6F0XJl5e4Y2ONFwJLlJZ+dfcd5
         +Dm8rgR5HgC4BTgicaLPKK7lcDHUAV48njbUFtLVMJ5PL2MKclbiNdOsF3v0HSn4B9cO
         VTX3d8cc5q+ht0qQ40buO1NW8vBuDtFdrwp6s3kwU7+Ct+0Gn5I6uufRMz7k1COVH8B+
         PW/02M/oj8mvOid+j+LYkomAf27gai4QTQOnT9VPMIaK3YuzFOzvpkfaOdw6lhdwgpNm
         MI0w==
X-Gm-Message-State: AO0yUKVoQ55fDOZsN2t1TnZ/i3Ka2ZqvJ+g+ZTYiueWflkVyBh8RR+9v
        lHb+EyJrUSnZkTu/PIGxa0U=
X-Google-Smtp-Source: AK7set+8oNQfUic1d1B+yOgs/C6Qim/QoLUKk/uACAd6LZ0vn46rSElS9k9uJwutq/gdVYQOZnn94A==
X-Received: by 2002:a17:902:ea01:b0:199:4362:93f2 with SMTP id s1-20020a170902ea0100b00199436293f2mr1030360plg.65.1675823114887;
        Tue, 07 Feb 2023 18:25:14 -0800 (PST)
Received: from macbook-pro-6.dhcp.thefacebook.com ([2620:10d:c090:400::5:98f0])
        by smtp.gmail.com with ESMTPSA id w8-20020a1709027b8800b0019602b2c00csm5174478pll.175.2023.02.07.18.25.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 18:25:14 -0800 (PST)
Date:   Tue, 7 Feb 2023 18:25:11 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Martin KaFai Lau <martin.lau@linux.dev>,
        Joanne Koong <joannelkoong@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Kernel Team <kernel-team@fb.com>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH v9 bpf-next 3/5] bpf: Add skb dynptrs
Message-ID: <20230208022511.qhkyqio2b2jvcaid@macbook-pro-6.dhcp.thefacebook.com>
References: <20230130223141.r24nlg2jp5byvuph@macbook-pro-6.dhcp.thefacebook.com>
 <CAEf4Bzb9=q9TKutW8d7fOtCWaLpA12yvSh-BhL=m3+RA1_xhOQ@mail.gmail.com>
 <4b7b09b5-fd23-2447-7f05-5f903288625f@linux.dev>
 <CAEf4BzaQJe+UZxECg__Aga+YKrxK9KEbAuwdxA4ZBz1bQCEmSA@mail.gmail.com>
 <20230131053042.h7wp3w2zq46swfmk@macbook-pro-6.dhcp.thefacebook.com>
 <CAEf4BzbeUfmE-8Y-mm4RtZ4q=9SZ-_M-K-JF=x84o6cboUneSQ@mail.gmail.com>
 <20230201004034.sea642affpiu7yfm@macbook-pro-6.dhcp.thefacebook.com>
 <CAEf4BzbTXqhsKqPd=hDANKeg75UDbKjtX318ucMGw7a1L3693w@mail.gmail.com>
 <CAADnVQJ3CXKDJ_bZ3u2jOEPfuhALGvOi+p5cEUFxe2YgyhvB4Q@mail.gmail.com>
 <CAEf4Bzabg=YsiR6re3XLxFAptFW3sECA4v2_e0AE_TRNsDWm-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bzabg=YsiR6re3XLxFAptFW3sECA4v2_e0AE_TRNsDWm-w@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 03, 2023 at 01:37:46PM -0800, Andrii Nakryiko wrote:
> On Thu, Feb 2, 2023 at 3:43 AM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Wed, Feb 1, 2023 at 5:21 PM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Tue, Jan 31, 2023 at 4:40 PM Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > >
> > > > On Tue, Jan 31, 2023 at 04:11:47PM -0800, Andrii Nakryiko wrote:
> > > > > >
> > > > > > When prog is just parsing the packet it doesn't need to finalize with bpf_dynptr_write.
> > > > > > The prog can always write into the pointer followed by if (p == buf) bpf_dynptr_write.
> > > > > > No need for rdonly flag, but extra copy is there in case of cloned which
> > > > > > could have been avoided with extra rd_only flag.
> > > > >
> > > > > Yep, given we are designing bpf_dynptr_slice for performance, extra
> > > > > copy on reads is unfortunate. ro/rw flag or have separate
> > > > > bpf_dynptr_slice_rw vs bpf_dynptr_slice_ro?
> > > >
> > > > Either flag or two kfuncs sound good to me.
> > >
> > > Would it make sense to make bpf_dynptr_slice() as read-only variant,
> > > and bpf_dynptr_slice_rw() for read/write? I think the common case is
> > > read-only, right? And if users mistakenly use bpf_dynptr_slice() for
> > > r/w case, they will get a verifier error when trying to write into the
> > > returned pointer. While if we make bpf_dynptr_slice() as read-write,
> > > users won't realize they are paying a performance penalty for
> > > something that they don't actually need.
> >
> > Makes sense and it matches skb_header_pointer() usage in the kernel
> > which is read-only. Since there is no verifier the read-only-ness
> > is not enforced, but we can do it.
> >
> > Looks like we've converged on bpf_dynptr_slice() and bpf_dynptr_slice_rw().
> > The question remains what to do with bpf_dynptr_data() backed by skb/xdp.
> > Should we return EINVAL to discourage its usage?
> > Of course, we can come up with sensible behavior for bpf_dynptr_data(),
> > but it will have quirks that will be not easy to document.
> > Even with extensive docs the users might be surprised by the behavior.
> 
> I feel like having bpf_dynptr_data() working in the common case for
> skb/xdp would be nice (e.g., so basically at least work in cases when
> we don't need to pull).
> 
> But we've been discussing bpf_dynptr_slice() with Joanne today, and we
> came to the conclusion that bpf_dynptr_slice()/bpf_dynptr_slice_rw()
> should work for any kind of dynptr (LOCAL, RINGBUF, SKB, XDP). So
> generic code that wants to work with any dynptr would be able to just
> use bpf_dynptr_slice, even for LOCAL/RINGBUF, even though buffer won't
> ever be filled for LOCAL/RINGBUF.

great

> In application, though, if I know I'm working with LOCAL or RINGBUF
> (or MALLOC, once we have it), I'd use bpf_dynptr_data() to fill out
> fixed parts, of course. bpf_dynptr_slice() would be cumbersome for
> such cases (especially if I have some huge fixed part that I *know* is
> available in RINGBUF/MALLOC case).

bpf_dynptr_data() for local and ringbuf is fine, of course.
It already exists and has to continue working.
bpf_dynptr_data() for xdp is probably ok as well,
but bpf_dynptr_data() for skb is problematic.
data/data_end concept looked great back in 2016 when it was introduced
and lots of programs were written, but we underestimated the impact
of driver's copybreak on programs.
Network parsing progs consume headers one by one and would typically
be written as:
if (header > data_end)
   return DROP;
Some drivers copybreak fixed number of bytes. Others try to be smart
and copy only headers into linear part of skb.
The drivers also change. At one point we tried to upgrade the kernel
and suddenly bpf firewall started blocking valid traffic.
Turned out the driver copybreak heuristic was changed in that kernel.
The bpf prog was converted to use skb_load_bytes() and the fire was extinguished.
It was a hard lesson.
Others learned the danger of data/data_end the hard way as well.
Take a look at cloudflare's progs/test_cls_redirect.c.
It's a complicated combination of data/data_end and skb_load_bytes().
It's essentially implementing skb_header_pointer.
I wish we could use bpf_dynptr_slice only and remove data/data_end,
but we cannot, since it's uapi.
But we shouldn't repeat the same mistake. If we do bpf_dynptr_data()
that returns linear part people will be hitting the same fragility and
difficult to debug bugs.
bpf_dynptr_data() for XDP is ok-ish, since most of XDP is still
page-per-packet, but patches to split headers in HW are starting to appear.
So even for XDP data/data_end concept may bite us.
Hence my preference is to EINVAL in bpf_dynptr_data() at least for skb,
since bpf_dynptr_slice() is a strictly better alternative.
