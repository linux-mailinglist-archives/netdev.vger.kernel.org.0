Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 936413D5CBD
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 17:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235003AbhGZOf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 10:35:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234692AbhGZOdW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 10:33:22 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BBE0C061760
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 08:13:51 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id k65so10707924yba.13
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 08:13:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PhKXMm2TiMRHSpwdCxpuqLGCbeOzvIdKGS5OBWsPGTQ=;
        b=ZLMgOGAcO+g15dqnNQKXR3X4Khfh1AHDBNE0LmOX8L/7kZjKuvdt4a6cIWifgVcHf7
         2+pGZU+jRMsDnPqP9U3xS72SjZpcILD10T7eXMKUUoBOFCHdk3tHzXvXIuB3DXsLMcUm
         Zx46vsAIzWnSB7hF9H/nIy+joKqqg1hwfBCBxX1fqRLmC7PWS4YzRq4GpErTjH7s1mKN
         a042XbnRODpHlNdtVG7HYWfRnLSuxlN2x23ya8teVr8gpDzEIqfj+qfmQ0YRryfPtbwV
         dM+DT+kycddjPv8NSFiLka+9CVq3khpllttIMvUwZuCRTUuNoueaeSHwQm7ugk2r20OL
         MdaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PhKXMm2TiMRHSpwdCxpuqLGCbeOzvIdKGS5OBWsPGTQ=;
        b=oxdWcPFSZ9OIIqtvIZ6AiArtjKYVC4s2yIzjAU69qF4Bc4eOSTQWtY3usfjS+JxRjh
         C8hG0U1aUpoL1rQ5+pGINP7sYd+ec1xn+r/zab/PrcixyIxu2fwNEp55EKXlHaA+tFaN
         u9XffTAG9Ok7BBsJvsXGmWKCS6J36OQvYzTuEMVmpqUHkAV8pDAh+XIBUoawD/QxpF0q
         lIyCoP0MSdqC0NOsZtXoQaaNPIRuUK5TOCojSSkVm3kny5ca1FzX4TCnUlRK4zFtUsJr
         vCzASleCejf16vp0h8NhGZCTqONAkxTp4xn3MrggBPxZ+AcXywF3vaHHDI0ve/rkgQKq
         WNUA==
X-Gm-Message-State: AOAM532/+zKxIpTkBS/JAT8g/N5SgWq4KuisVHjJ0TtPBxbVk9VZx9eQ
        wheqYyzn96oCxaW2k9KteTVZ1MGlUU/KcEYyRNY=
X-Google-Smtp-Source: ABdhPJwxxA1DlgE71EbakfpxvQsiRfEoC7YUKZ2xyAm08qiD5ZOe8EFrqyhaFPyFbp9XH/SxhzVYx95HHnCNJh2t2fY=
X-Received: by 2002:a25:b203:: with SMTP id i3mr25303991ybj.260.1627312430431;
 Mon, 26 Jul 2021 08:13:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210705124307.201303-1-m@lambda.lt> <CAEf4Bzb_FAOMK+8J+wyvbR2etYFDU1ae=P3pwW3fzfcWctZ1Xw@mail.gmail.com>
 <df3396c3-9a4a-824d-648f-69f4da5bc78b@lambda.lt> <YPpIeppWpqFCSaqZ@Laptop-X1>
 <CAEf4Bzavevcn=p7iBSH6iXMOCXp5kCu71a1kZ7PSawW=LW5NSQ@mail.gmail.com>
 <0cc404df-078a-686e-c5ce-8473c0e220f5@gmail.com> <CAEf4Bza3gMzfSQcv_QDzVP=vsCzxy=8DHwU-EVqOt8XagK7OHw@mail.gmail.com>
 <cce56767-efbe-e572-6290-111c6c845578@gmail.com>
In-Reply-To: <cce56767-efbe-e572-6290-111c6c845578@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 26 Jul 2021 08:13:39 -0700
Message-ID: <CAEf4BzZHTuq8FhxyoQ-gksXspUqmocsEGyU2D5r6pFibOSSVMw@mail.gmail.com>
Subject: Re: [PATCH iproute2] libbpf: fix attach of prog with multiple sections
To:     David Ahern <dsahern@gmail.com>
Cc:     Hangbin Liu <haliu@redhat.com>, Martynas Pumputis <m@lambda.lt>,
        Networking <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 26, 2021 at 6:58 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 7/23/21 6:25 PM, Andrii Nakryiko wrote:
> >>>>>> This is still problematic, because one section can have multiple BPF
> >>>>>> programs. I.e., it's possible two define two or more XDP BPF programs
> >>>>>> all with SEC("xdp") and libbpf works just fine with that. I suggest
> >>>>>> moving users to specify the program name (i.e., C function name
> >>>>>> representing the BPF program). All the xdp_mycustom_suffix namings are
> >>>>>> a hack and will be rejected by libbpf 1.0, so it would be great to get
> >>>>>> a head start on fixing this early on.
> >>>>>
> >>>>> Thanks for bringing this up. Currently, there is no way to specify a
> >>>>> function name with "tc exec bpf" (only a section name via the "sec" arg). So
> >>>>> probably, we should just add another arg to specify the function name.
> >>>>
> >>>> How about add a "prog" arg to load specified program name and mark
> >>>> "sec" as not recommended? To keep backwards compatibility we just load the
> >>>> first program in the section.
> >>>
> >>> Why not error out if there is more than one program with the same
> >>> section name? if there is just one (and thus section name is still
> >>> unique) -- then proceed. It seems much less confusing, IMO.
> >>>
> >>
> >> Let' see if I understand this correctly: libbpf 1.0 is not going to
> >> allow SEC("xdp_foo") or SEC("xdp_bar") kind of section names - which is
> >> the hint for libbpf to know program type. Instead only SEC("xdp") is
> >> allowed.
> >
> > Right.
> >
> >>
> >> Further, a single object file is not going to be allowed to have
> >> multiple SEC("xdp") instances for each program name.
> >
> > On the contrary. Libbpf already allows (and will keep allowing)
> > multiple BPF programs with SEC("xdp") in a single object file. Which
> > is why section_name is not a unique program identifier.
> >
>
> Does that require BTF? My attempts at loading an object file with 2
> SEC("xdp") programs failed. This is using bpftool from top of tree and
> loadall.

You mean kernel BTF? Not if XDP programs themselves were built
requiring CO-RE. So if those programs use #include "vmlinux.h", or
there is BPF_CORE_READ() use somewhere in the code, or explicit
__attribute__((preserve_access_index)) is used on some of the used
structs, then yes, vmlinux BTF will be needed. But otherwise no. Do
you have verbose error logs? I think with bpftool you can get them
with -d argument.
