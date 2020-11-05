Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66EC82A87D8
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 21:19:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728137AbgKEUTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 15:19:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726214AbgKEUTM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 15:19:12 -0500
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BDC8C0613CF;
        Thu,  5 Nov 2020 12:19:12 -0800 (PST)
Received: by mail-yb1-xb42.google.com with SMTP id c129so2449299yba.8;
        Thu, 05 Nov 2020 12:19:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZRc+lwpQtmI1B2kI1XfJ2V0KbeFadRbQ6DPKKmtERAU=;
        b=nuOQs/u+y4geJClghNI+WMjRymNCen3mHJThoHzO2WfdLLkiz5LyLU89E98thOWJB/
         Mjiyg0YSq0nVzam8uO6k69kp0pj0rhe3bEUTC5+NksobRTbDxx+DrbfhK35fo87daa3v
         mmjOPmcIRTEblleYnO3STXBHMrsr2VXSGXzUSzbfJ9xmNoaAMGf0SEvrnsK99Ncfb+r0
         1hMJwbGHQssuWmrZ60jcSG+xu78cBZTPqLOt6e+za6z120yMpUOY6f8Gvp9xQfwRe+KT
         mRnIsKJNAwD7k3uY5TsrjrrexCWrPGEsKjfoXQguHdKDLR1kITzk+4QQ9DFazeWQicqh
         gwxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZRc+lwpQtmI1B2kI1XfJ2V0KbeFadRbQ6DPKKmtERAU=;
        b=Alrlw0zOkVO/TpjWx2ueNAaSxlgdu4jZ66U/1Hkiwe4bcejb/86I/Nvjz/X7pJbrsf
         krlOjDmShoQ/jrev4N2SI1l7dbkMFSRDh033NUtnWZElyo4SeWpwrf9roomgOHvynUUu
         GgPXjjUxzcyir8e7plevnPduZIu5R4TRRbmNshO3aujs5YUG+rh54WfwkMsKpbgPeRWW
         VAlIeP0NzOgKTUsrz3Yp19gTo5hYFdmCuVQciRtSd30zoCZTBe/lpEMRz7KYeQVPN5SH
         zWxU7lnoKD8uCBfk57uNOXwCGfOYqxfNrRJUKXZHKISiKZRFP0rWG+Ra2iOY0T7RqZ9i
         soEw==
X-Gm-Message-State: AOAM5335X9mv82oVdWaLVTalA+teVZDbnVpdXDFBqpRG409holwFNbJL
        ScGwtFs//YiWWtdGQmDV82i3/SaZm2BXa+DEUT8=
X-Google-Smtp-Source: ABdhPJyR//iCYVDy0SiWfHnQK1KODaO1shA1G38SNp6g2ougV1qSR3mIsJVyaGqY+kZAApV+xtlbIX+DON6BjnPvUu0=
X-Received: by 2002:a25:c7c6:: with SMTP id w189mr6125144ybe.403.1604607551242;
 Thu, 05 Nov 2020 12:19:11 -0800 (PST)
MIME-Version: 1.0
References: <20201028132529.3763875-1-haliu@redhat.com> <20201029151146.3810859-1-haliu@redhat.com>
 <646cdfd9-5d6a-730d-7b46-f2b13f9e9a41@gmail.com> <CAEf4BzYupkUqfgRx62uq3gk86dHTfB00ZtLS7eyW0kKzBGxmKQ@mail.gmail.com>
 <edf565cf-f75e-87a1-157b-39af6ea84f76@iogearbox.net> <3306d19c-346d-fcbc-bd48-f141db26a2aa@gmail.com>
 <CAADnVQ+EWmmjec08Y6JZGnan=H8=X60LVtwjtvjO5C6M-jcfpg@mail.gmail.com>
 <71af5d23-2303-d507-39b5-833dd6ea6a10@gmail.com> <20201103225554.pjyuuhdklj5idk3u@ast-mbp.dhcp.thefacebook.com>
 <20201104021730.GK2408@dhcp-12-153.nay.redhat.com> <20201104031145.nmtggnzomfee4fma@ast-mbp.dhcp.thefacebook.com>
 <bb04a01a-8a96-7a6a-c77e-28ee63983d9a@solarflare.com> <CAADnVQKu7usDXbwwcjKChcs0NU3oP0deBsGGEavR_RuPkht74g@mail.gmail.com>
 <07f149f6-f8ac-96b9-350d-b289ef16d82f@solarflare.com>
In-Reply-To: <07f149f6-f8ac-96b9-350d-b289ef16d82f@solarflare.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 5 Nov 2020 12:19:00 -0800
Message-ID: <CAEf4BzaSfutBt3McEPjmu_FyxyzJa_xVGfhP_7v0oGuqG_HBEw@mail.gmail.com>
Subject: Re: [PATCHv3 iproute2-next 0/5] iproute2: add libbpf support
To:     Edward Cree <ecree@solarflare.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Hangbin Liu <haliu@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 4, 2020 at 3:05 PM Edward Cree <ecree@solarflare.com> wrote:
>
> On 04/11/2020 22:10, Alexei Starovoitov wrote:
> > On Wed, Nov 4, 2020 at 1:16 PM Edward Cree <ecree@solarflare.com> wrote:
> >> On 04/11/2020 03:11, Alexei Starovoitov wrote:
> >>> The user will do 'tc -V'. Does version mean anything from bpf loading pov?
> >>> It's not. The user will do "ldd `which tc`" and then what?
> >> Is it beyond the wit of man for 'tc -V' to output somethingabout
> >>  libbpf version?
> >> Other libraries seem to solve these problems all the time, I
> >>  haven't seen anyone explain what makes libbpf so special that it
> >>  has to be different.
> > slow vger? Please see Daniel and Andrii detailed explanations.
> Nah, I've seen that subthread(vger is fine).  I felt that subthread
>  was missing this point about -V which is why I replied where it was
>  brought up.
> Daniel and Andrii have only explained why users will want to have an
>  up-to-date libbpf, they (and you) haven't connected it to any
>  argument about why static linking is the way to achieve that.

I'll just quote myself here for your convenience.

  Submodule is a way that I know of to make this better for end users.
  If there are other ways to pull this off with shared library use, I'm
  all for it, it will save the security angle that distros are arguing
  for. E.g., if distributions will always have the latest libbpf
  available almost as soon as it's cut upstream *and* new iproute2
  versions enforce the latest libbpf when they are packaged/released,
  then this might work equivalently for end users. If Linux distros
  would be willing to do this faithfully and promptly, I have no
  objections whatsoever. Because all that matters is BPF end user
  experience, as Daniel explained above.

No one replied to that, unfortunately.


> > libbpf is not your traditional library.
> This has only been asserted, not explained.
> I'm fully willing to entertain the possibility that libbpf is indeed
>  special.  But if you want to win people over, you'll need to
>  explain *why* it's special.
> "Look at bfd and think why" is not enough, be more explicit.
>
> AIUI the API between iproute2 and libbpf isn't changing, all that's
>  happening is that libbpf is gaining new capabilities in things that
>  are totally transparent to iproute2 (e.g. BTF fixups).  So the
>  reasonable thing for users to expect is "I need new BPF features,
>  I'll upgrade my libbpf", and with dynamic linking that works fine
>  whether they upgrade iproute2 too or not.
> This narrative is, on the face of it, just as plausible as "I'm
>  getting an error from iproute2, I'll upgrade that".  And if distros
>  decide that that's a common enough mistake to matter, then they can
>  make the newer iproute2 package depend on a newer libbpf package,
>  and apt or yum or whatever will automagically DTRT.
> Whereas if you tightly couple them from the start, distros can't
>  then go the other way if it turns out you made the wrong choice.
>  (What if someone can't use the latest iproute2 release because it
>  has a regression bug that breaks their use-case, but they need the
>  latest libbpf for one of your shiny new features?)
>
> Don't get me wrong, I'd love a world in which static linking was the
>  norm and we all rebuilt our binaries locally every time we upgraded
>  a piece.  But that's not the world we live in, and consistency
>  *within* a distro matters too...
>
> -ed
