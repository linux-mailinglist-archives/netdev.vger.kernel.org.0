Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39E31F3EB8
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 05:08:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729823AbfKHEI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 23:08:27 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:34880 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729641AbfKHEI1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 23:08:27 -0500
Received: by mail-lf1-f68.google.com with SMTP id y6so3351264lfj.2;
        Thu, 07 Nov 2019 20:08:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=H78vnncv8XIX6vF849Af3zw3Wc9WfiSJimph1ZztaME=;
        b=fpUq8lWIe4UfR2n3cwXXSXcybpuWGNUL5F+PEojPiwDOm7ATLoaAtGIQC0NMVNRRD9
         RvN7dk8/HHC+c84rseK0iakiQZWkEu2fXAIJYO3JFqlJD25eothFvgljH4eC+gKlCsWC
         Srq+apMsK9pxRJ4sHuWwFqBSThlULhNtuDjeSz81nkNDdBNVLct9LtqJ0KYpQ0V951E8
         mITHN9z/onLD2dOuj9LLTcr/3m7jCAhkMyxZRNFgLtkFfxKBFqxWKJWFxxe9uwlyGl2T
         lbF5ASoJgyLcmmlhuUnlDDyaETHxW0IOAW2sCntOQByzdWarBXugnvPF8TBJVtgOwm/i
         qLUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=H78vnncv8XIX6vF849Af3zw3Wc9WfiSJimph1ZztaME=;
        b=DMaf9dsOx9c3y0+MlbjMNhtxpBUEq+Jst56215cbfC7X2rCKacuqC27+94kPmQdSlE
         sxYiPvVYxmam0oogOwmKrsMiZ6OIqtZfTFnv6zwN1F/YGBQPnh8uaCaM+DFcaW/iOk0D
         NK7znY0n75hsDDgOtoOqH8c4cZ0Osrpv+XeTpr2EdEVMSvdAufXXZqwV2Lj8lGa5P2XL
         2Uv07S0wnhKcgs5GESN3+nW0zup58CwVRLj/Tde7qs0qLe/HzpQod/9yTOeBDV6lWSxo
         E1LxqqVowrVRTntVEqI5zaxUyiN0qwVYXPizc8u1l0DaC4jF5xtsKXczScL0vien8Uhq
         vgTA==
X-Gm-Message-State: APjAAAWmvksXgJjVMzSJLbN2T9zgHW7BVDCkz+kWsQmnIRL8W4fA98U9
        hI+fkK7ol/szu5BdDtSoWzg0LIfLAxYkKAdMKdc=
X-Google-Smtp-Source: APXvYqx2a2iAtPXorfRicWaTlE8tf2SqitSujGD+li9r8yhlvyyXZLLDcAqgoUqg1VSYe1On3b6sX7LeJNPG8mD7Wu4=
X-Received: by 2002:a19:7511:: with SMTP id y17mr5014469lfe.19.1573186105008;
 Thu, 07 Nov 2019 20:08:25 -0800 (PST)
MIME-Version: 1.0
References: <20191107054644.1285697-1-ast@kernel.org> <20191107054644.1285697-4-ast@kernel.org>
 <5967F93A-235B-447E-9B70-E7768998B718@fb.com> <20191107225553.vnnos6nblxlwx24a@ast-mbp.dhcp.thefacebook.com>
 <FABEB3EB-2AC4-43F8-984B-EFD1DA621A3E@fb.com> <20191107230923.knpejhp6fbyzioxi@ast-mbp.dhcp.thefacebook.com>
 <22015BB9-7A84-4F5E-A8A5-D10CB9DA3AEE@fb.com> <20191108000941.r4umt2624o3j45p7@ast-mbp.dhcp.thefacebook.com>
 <CAPhsuW4gYU=HJTe2ueDXhiyY__V1ZBF1ZEhCasHb5m8XgkTtww@mail.gmail.com>
 <CAADnVQJFNo3wcyMKkOhX-LVYpgg302-K-As9ZKkPUXxRdGN0nw@mail.gmail.com> <3000B3E1-25DE-4653-B11C-AAF61492B0FF@fb.com>
In-Reply-To: <3000B3E1-25DE-4653-B11C-AAF61492B0FF@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 7 Nov 2019 20:08:13 -0800
Message-ID: <CAADnVQLz9fWBm3qYWaw9n60WOHFWtzO1RXheHYj6nd+jg--TkA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 03/17] bpf: Introduce BPF trampoline
To:     Song Liu <songliubraving@fb.com>
Cc:     Song Liu <liu.song.a23@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 7, 2019 at 8:06 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Nov 7, 2019, at 7:11 PM, Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> >
> > On Thu, Nov 7, 2019 at 5:10 PM Song Liu <liu.song.a23@gmail.com> wrote:
> >>>>>>>>> +               goto out;
> >>>>>>>>> +       tr->selector++;
> >>>>>>>>
> >>>>>>>> Shall we do selector-- for unlink?
> >>>>>>>
> >>>>>>> It's a bit flip. I think it would be more confusing with --
> >>>>>>
> >>>>>> Right.. Maybe should use int instead of u64 for selector?
> >>>>>
> >>>>> No, since int can overflow.
> >>>>
> >>>> I guess it is OK to overflow, no?
> >>>
> >>> overflow is not ok, since transition 0->1 should use nop->call patching
> >>> whereas 1->2, 2->3 should use call->call.
> >>>
> >>> In my initial implementation (one I didn't share with anyone) I had
> >>> trampoline_mutex taken inside bpf_trampoline_update(). And multiple link()
> >>> operation were allowed. The idea was to attach multiple progs and update
> >>> trampoline once. But then I realized that I cannot do that since 'unlink +
> >>> update' where only 'update' is taking lock will not guarantee success. Since
> >>> other 'link' operations can race and 'update' can potentially fail in
> >>> arch_prepare_bpf_trampoline() due to new things that 'link' brought in. In that
> >>> version (since there several fentry/fexit progs can come in at once) I used
> >>> separate 'selector' ticker to pick the side of the page. Once I realized the
> >>> issue (to guarantee that unlink+update == always success) I moved mutex all the
> >>> way to unlink and link and left 'selector' as-is. Just now I realized that
> >>> 'selector' can be removed.  fentry_cnt + fexit_cnt can be used instead. This
> >>> sum of counters will change 1 bit at a time. Am I right?
> >>
> >> Yeah, I think fentry_cnt + fexit_cnt is cleaner.
> >
> > ... and that didn't work.
> > It's transition that matters. Either need to remember previous sum value
> > or have separate selector. imo selector is cleaner, so I'm back to that.
>
> Hmm.. is this because of the error handling path?

No. Because of transition 1->2 and 2->1 are the same.
