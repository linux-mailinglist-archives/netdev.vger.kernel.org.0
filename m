Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE388F3E51
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 04:11:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729328AbfKHDLk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 22:11:40 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:33685 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbfKHDLk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 22:11:40 -0500
Received: by mail-lj1-f196.google.com with SMTP id t5so4603259ljk.0;
        Thu, 07 Nov 2019 19:11:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rO8PWH86rEULEG3Z32w/xnCW9m7mnv5f5DT7fUHq5lg=;
        b=vMznWiXynsj/01aU2ohlA6kXFOQ9DunohAvUJolwddZ3eKQhWce/93lNFgPyjfEtpZ
         p3pjQA1nEF9BAuV+ynUChNwpdz7tBZB1qR8mrXR9m0pSBhIWvX0v0MWFDbxjkv5SXYjC
         6CE+Q5wA1ii/dQa7/s8RC3NHTLTStyfj4gChjARjkEpkDO8diU6ba5EMVwNcH5OP0BLu
         HDZHM3Ts3JXlmPPZjkD2Nq0BAVoar8X+T0y3u5J4rNdGOm3YbfMlJKRcny+m3Zbq5Hj1
         ZNaK+L7Kc/C0Mn32CsD2LbaEzctmw3vq6H4b8VTRGbTATBog0MUEE23q8djxPOOwiSV4
         pKiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rO8PWH86rEULEG3Z32w/xnCW9m7mnv5f5DT7fUHq5lg=;
        b=rBcE0vxI+y4ItZpx0yioBikmtc9cAOXCe8eM8B9T0ufihWKGg71q48Jmg6rcbT3GSj
         ug2U1uY8B1IDvyUDaeAqIkIM4873P05oRZB5lQMr7vKzHUII6nZIDR8+CdbRK1MlcPci
         gknWWTk3D3x6BRqkNjXE1x9bhuof5svdyXuMCfKyz0UVqAzukyO28JfW/bwNQaAHBnNB
         8t+xD/bjIpg1W1PoT6PMY3mIXebiI75J4JzOZp8QapaVQ9GdV6nR9lrV4BSjjHc/VvqZ
         dd1eFGNsMZ87auJi/BZM2Tms6WNJ5f/Z03qKlv+Uw9F3BZqkwVsW50/Zdk5HNLrlk9CL
         5T/Q==
X-Gm-Message-State: APjAAAXoiv9tEABdEcfnrojB9aeuYVtcJIILgVXYaXQIEYvzEJ52lhUP
        Tz4hR3zytQ8W7hFD1W8McCYRVDzbe30fHW7pPcg=
X-Google-Smtp-Source: APXvYqywNdTKa16OQ0arS/L1heY5wYcSqlKGWroM5w8n12kBZxJ97sPBbPFFod40Ah0DXO/jxZvRb5Y91s5219kBqtc=
X-Received: by 2002:a2e:8508:: with SMTP id j8mr4816342lji.136.1573182696439;
 Thu, 07 Nov 2019 19:11:36 -0800 (PST)
MIME-Version: 1.0
References: <20191107054644.1285697-1-ast@kernel.org> <20191107054644.1285697-4-ast@kernel.org>
 <5967F93A-235B-447E-9B70-E7768998B718@fb.com> <20191107225553.vnnos6nblxlwx24a@ast-mbp.dhcp.thefacebook.com>
 <FABEB3EB-2AC4-43F8-984B-EFD1DA621A3E@fb.com> <20191107230923.knpejhp6fbyzioxi@ast-mbp.dhcp.thefacebook.com>
 <22015BB9-7A84-4F5E-A8A5-D10CB9DA3AEE@fb.com> <20191108000941.r4umt2624o3j45p7@ast-mbp.dhcp.thefacebook.com>
 <CAPhsuW4gYU=HJTe2ueDXhiyY__V1ZBF1ZEhCasHb5m8XgkTtww@mail.gmail.com>
In-Reply-To: <CAPhsuW4gYU=HJTe2ueDXhiyY__V1ZBF1ZEhCasHb5m8XgkTtww@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 7 Nov 2019 19:11:24 -0800
Message-ID: <CAADnVQJFNo3wcyMKkOhX-LVYpgg302-K-As9ZKkPUXxRdGN0nw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 03/17] bpf: Introduce BPF trampoline
To:     Song Liu <liu.song.a23@gmail.com>
Cc:     Song Liu <songliubraving@fb.com>,
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

On Thu, Nov 7, 2019 at 5:10 PM Song Liu <liu.song.a23@gmail.com> wrote:
> > > >>>>> +               goto out;
> > > >>>>> +       tr->selector++;
> > > >>>>
> > > >>>> Shall we do selector-- for unlink?
> > > >>>
> > > >>> It's a bit flip. I think it would be more confusing with --
> > > >>
> > > >> Right.. Maybe should use int instead of u64 for selector?
> > > >
> > > > No, since int can overflow.
> > >
> > > I guess it is OK to overflow, no?
> >
> > overflow is not ok, since transition 0->1 should use nop->call patching
> > whereas 1->2, 2->3 should use call->call.
> >
> > In my initial implementation (one I didn't share with anyone) I had
> > trampoline_mutex taken inside bpf_trampoline_update(). And multiple link()
> > operation were allowed. The idea was to attach multiple progs and update
> > trampoline once. But then I realized that I cannot do that since 'unlink +
> > update' where only 'update' is taking lock will not guarantee success. Since
> > other 'link' operations can race and 'update' can potentially fail in
> > arch_prepare_bpf_trampoline() due to new things that 'link' brought in. In that
> > version (since there several fentry/fexit progs can come in at once) I used
> > separate 'selector' ticker to pick the side of the page. Once I realized the
> > issue (to guarantee that unlink+update == always success) I moved mutex all the
> > way to unlink and link and left 'selector' as-is. Just now I realized that
> > 'selector' can be removed.  fentry_cnt + fexit_cnt can be used instead. This
> > sum of counters will change 1 bit at a time. Am I right?
>
> Yeah, I think fentry_cnt + fexit_cnt is cleaner.

... and that didn't work.
It's transition that matters. Either need to remember previous sum value
or have separate selector. imo selector is cleaner, so I'm back to that.
