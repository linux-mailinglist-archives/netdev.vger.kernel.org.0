Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8291452C7EC
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 01:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbiERXtM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 19:49:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbiERXtL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 19:49:11 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE642A466;
        Wed, 18 May 2022 16:49:10 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id o190so4088309iof.10;
        Wed, 18 May 2022 16:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ud+QA/ARNed/7Sysp4Ba2/DDtJgmT6FrhKuZQJZLqrg=;
        b=l29nhmTHoc9j7TYGNASTOi+cL2GLBndh8TsCxn9kX8Eyxa4sleln5MwyxEWSmFmVNr
         vljsPinYr27p/4LcBNS1YokKyqjPDg3YjkjRAOzuu4C0rzVSpgMRfPlKpWJIz/ACva/O
         Tn0rfYWMmZC495TdqCqmyPV2ZDxRLkUWJgC1mL/SsuoRgzYIjsSp2xk9WhxYih6QJ4HS
         hlKZwKBe6Waksmq3BsadTaTaGWKJsilF5ElRy71Bsn8FEWDdCzANRm23T9vzmRkJJGE1
         gncXaUmpRUB73h/3jqMZ1/5tA2IZ9Az84eCUXIsabjaAenZaOx1MJb+GOtHpr+TuiHSP
         BU9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ud+QA/ARNed/7Sysp4Ba2/DDtJgmT6FrhKuZQJZLqrg=;
        b=fpP0uFjO6ZgjoI5zIQuOt61e/nXTqdk4MPl4gJLVLeRcoT85OW++jylpZSlIt3r2w6
         /7pnd6cqm0ytFPk36OlAnfXJpyFx3uMrUCMAKa9+n0eF6qzzC1wQy47mMODDMOZjA6Rz
         RZGmjXf3HRAFVZ6WLqlqsrI9v25Tp2estpgH3fVjLP9eMeVBCW5K6J+EPbm0XW2AzKUC
         tGN1dmE98p+ID2OfTH52h6SdfCPVXyJI2lB6YHDYK5d9zipctSr0e2h2RUwffIVXxGOu
         A7BzdqRsIgL/ZHwDpCvKfF+XYLKOS8god/nGMCG867+hdK+Xw+HfN5flJ045MEdHvzHx
         LRsA==
X-Gm-Message-State: AOAM531LtHrBLuqvjdmAQWGkawOQ7e33mINhy37RJiuFlig8GaV4wXj4
        mdtF/ypx2JeVVSchMnOzNJ/Xpp92r1aPZK5d+Ac=
X-Google-Smtp-Source: ABdhPJw5qkxuPtMpH2uETRks3QQuEQgahrcY5gcUHWem8GX3VmXTH+P0XONkKC6w7rX3lS2U51Dr8Qq3dnA0XveFol8=
X-Received: by 2002:a05:6638:33a1:b0:32b:8e2b:f9ba with SMTP id
 h33-20020a05663833a100b0032b8e2bf9bamr1104425jav.93.1652917750301; Wed, 18
 May 2022 16:49:10 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1652772731.git.esyr@redhat.com> <6ef675aeeea442fa8fc168cd1cb4e4e474f65a3f.1652772731.git.esyr@redhat.com>
 <YoNnAgDsIWef82is@krava> <20220517123050.GA25149@asgard.redhat.com>
 <YoP/eEMqAn3sVFXf@krava> <7c5e64f2-f2cf-61b7-9231-fc267bf0f2d8@fb.com>
 <YoTXiAk1EpZ0rLKE@krava> <20220518123022.GA5425@asgard.redhat.com>
In-Reply-To: <20220518123022.GA5425@asgard.redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 18 May 2022 16:48:59 -0700
Message-ID: <CAEf4BzbRYT4ykpxzXKGQ03REoVRKm_q8=oVEVCXfE+4zVDb=8A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 4/4] bpf_trace: pass array of u64 values in kprobe_multi.addrs
To:     Eugene Syromiatnikov <esyr@redhat.com>
Cc:     Jiri Olsa <olsajiri@gmail.com>, Yonghong Song <yhs@fb.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
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

On Wed, May 18, 2022 at 5:30 AM Eugene Syromiatnikov <esyr@redhat.com> wrote:
>
> On Wed, May 18, 2022 at 01:24:56PM +0200, Jiri Olsa wrote:
> > On Tue, May 17, 2022 at 02:34:55PM -0700, Yonghong Song wrote:
> > > On 5/17/22 1:03 PM, Jiri Olsa wrote:
> > > > On Tue, May 17, 2022 at 02:30:50PM +0200, Eugene Syromiatnikov wrote:
> > > > > On Tue, May 17, 2022 at 11:12:34AM +0200, Jiri Olsa wrote:
> > > > > > On Tue, May 17, 2022 at 09:36:47AM +0200, Eugene Syromiatnikov wrote:
> > > > > > > With the interface as defined, it is impossible to pass 64-bit kernel
> > > > > > > addresses from a 32-bit userspace process in BPF_LINK_TYPE_KPROBE_MULTI,
> > > > > > > which severly limits the useability of the interface, change the ABI
> > > > > > > to accept an array of u64 values instead of (kernel? user?) longs.
> > > > > > > Interestingly, the rest of the libbpf infrastructure uses 64-bit values
> > > > > > > for kallsyms addresses already, so this patch also eliminates
> > > > > > > the sym_addr cast in tools/lib/bpf/libbpf.c:resolve_kprobe_multi_cb().
> > > > > >
> > > > > > so the problem is when we have 32bit user sace on 64bit kernel right?
> > > > > >
> > > > > > I think we should keep addrs as longs in uapi and have kernel to figure out
> > > > > > if it needs to read u32 or u64, like you did for symbols in previous patch
> > > > >
> > > > > No, it's not possible here, as addrs are kernel addrs and not user space
> > > > > addrs, so user space has to explicitly pass 64-bit addresses on 64-bit
> > > > > kernels (or have a notion whether it is running on a 64-bit
> > > > > or 32-bit kernel, and form the passed array accordingly, which is against
> > > > > the idea of compat layer that tries to abstract it out).
> > > >
> > > > hum :-\ I'll need to check on compat layer.. there must
> > > > be some other code doing this already somewhere, right?
> >
> > so the 32bit application running on 64bit kernel using libbpf won't
> > work at the moment, right? because it sees:
> >
> >   bpf_kprobe_multi_opts::addrs as its 'unsigned long'
> >
> > which is 4 bytes and it needs to put there 64bits kernel addresses
> >
> > if we force the libbpf interface to use u64, then we should be fine
>
> Yes, that's correct.
>
> > > I am not familiar with all these compatibility thing. But if we
> > > have 64-bit pointer for **syms, maybe we could also have
> > > 64-bit pointer for *syms for consistency?
> >
> > right, perhaps we could have one function to read both syms and addrs arrays
>
> The distinction here it that syms are user space pointers (so they are
> naturally 32-bit for 32-bit applications) and addrs are kernel-space
> pointers (so they may be 64-bit even when the application is 32-bit).
> Nothing prevents from changing the interface so that syms is an array
> of 64-bit values treated as user space pointers, of course.
>
> > > > > > we'll need to fix also bpf_kprobe_multi_cookie_swap because it assumes
> > > > > > 64bit user space pointers
> >
> > if we have both addresses and cookies 64 then this should be ok
> >
> > > > > >
> > > > > > would be gret if we could have selftest for this
> >
> > let's add selftest for this
>
> Sure, I'll try to write one.
>

Not sure how you can do that without having extra test_progs variant
that's running in compat mode?
