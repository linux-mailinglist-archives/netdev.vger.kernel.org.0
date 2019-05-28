Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C61D22CD26
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 19:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727311AbfE1RHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 13:07:41 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:38669 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbfE1RHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 13:07:40 -0400
Received: by mail-ed1-f65.google.com with SMTP id g13so3028946edu.5;
        Tue, 28 May 2019 10:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=EawqU93wBmalRygPCmmYPRgZMHIPT8D1mdZZr6KiEKY=;
        b=nhj2Vx1i0Sq8qyT/sIo07FZj3Z1C0bHaXH8QQIO0r2l6a92zBMRGnH3udmM9AuuEGV
         /6rWaqxv5AWQ97tj+Nhfk5gvq0RbZtbnM/fEWG/mlifCiCMIVQYSe90V6lsVWl5A5Zga
         iNKXrdfoSAWlmrnoxyXFJ4wtFY5B8p6YHrodvdBAfucW78a5iS55F6Uh8XyrwRoJSwAR
         yEQsroh2LNFH6Ui8TtgT8H/1NIqL7yohBdmt5TYmKG78+0jp24jMw4NuSKOnZX5AICdV
         KPzMugPhWPfU11qoomKOvXFmPw+8hYpsXtFjXd3l30jmAuHx09ixxCsyQKIuH8seILT1
         Q2XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EawqU93wBmalRygPCmmYPRgZMHIPT8D1mdZZr6KiEKY=;
        b=KDEXT54tUBZGSnmYF3KR8g9vH9vqF1ARvCfNxY6u03pRVwsXuerBh+zg4zTgs4uCfb
         N7/SL2+L6sJ5FUMmrUd0LTTl4o9/4qLtDWZbFxkyDNMqJCTjGNF9ajQkXK9SYvNcI9D8
         31Ej/v5fkQbE4uX8mgSojiZJC7GUga3x9qREGL4ahwoCA5sGPrzBHWmwPHy+HsDOU9Aw
         o7VWlmWmW0CC+UyQGWb928gwwdYNF2cNLjVcW8afNc1lnPyq0flRa5AOnyCCedOpEfnN
         VT4RhBni7L1Eujbh037GpYXAXpBITUQRnYazjHIWHCBEOAYBvdWZH0tHw4plPW4rNh6j
         ff5w==
X-Gm-Message-State: APjAAAV3bxjDRMsxpfiWY17DfGr7XHBbD3cuRBF0obwJ9RICHLmGBdw/
        c8bfLjq3Sf/xM6jHx3mMbEyYq7DILOdTu4RQBW8=
X-Google-Smtp-Source: APXvYqzMu93c7mxwnEgvrMgl6w83ROBii/WctkX9znMwVCaRLXkjfVvgtxzLp/rsbkbxTJ59wo+X1JwxvkdpkAzA58o=
X-Received: by 2002:a17:906:aacb:: with SMTP id kt11mr89438361ejb.246.1559063258733;
 Tue, 28 May 2019 10:07:38 -0700 (PDT)
MIME-Version: 1.0
References: <20190523210651.80902-1-fklassen@appneta.com> <20190523210651.80902-5-fklassen@appneta.com>
 <CAF=yD-KBNLr5KY-YQ1KMmZGCpYNefSJKaJkZNOwd8nRiedpQtA@mail.gmail.com>
 <879E5DA6-3A4F-4CE1-9DA5-480EE30109DE@appneta.com> <CAF=yD-LQT7=4vvMwMa96_SFuUd5GywMoae7hGi9n6rQeuhhxuQ@mail.gmail.com>
 <5BB184F2-6C20-416B-B2AF-A678400CFE3E@appneta.com> <CAF=yD-+6CRyqL6Fq5y2zpw5nnDitYC7G1c2JAVHZTjyw68DYJg@mail.gmail.com>
 <903DEC70-845B-4C4B-911D-2F203C191C27@appneta.com> <CAF=yD-Le0XKCfyDBvHmBRVqkwn1D6ZoG=12gss5T62VcN5+1_w@mail.gmail.com>
 <9811659B-6D5A-4C4F-9CF8-735E9CA6DE4E@appneta.com>
In-Reply-To: <9811659B-6D5A-4C4F-9CF8-735E9CA6DE4E@appneta.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 28 May 2019 13:07:02 -0400
Message-ID: <CAF=yD-KcX-zCgZFVVVMU7JFy+gJwRpUoViA_mWdM4QtHNr685g@mail.gmail.com>
Subject: Re: [PATCH net 4/4] net/udpgso_bench_tx: audit error queue
To:     Fred Klassen <fklassen@appneta.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 28, 2019 at 12:57 PM Fred Klassen <fklassen@appneta.com> wrote:
>
>
>
> > On May 28, 2019, at 8:08 AM, Willem de Bruijn <willemdebruijn.kernel@gm=
ail.com> wrote:
> >
>
> I will push up latest patches soon.
>
> I did some testing and discovered that only TCP audit tests failed. They
> failed much less often when enabling poll.  Once in about 20 runs
> still failed. Therefore I commented out the TCP audit tests.

Sounds good, thanks.

> You may be interested that I reduced test lengths from 4 to 3 seconds,
> but I am still getting 3 reports per test. I picked up the extra report b=
y
> changing 'if (tnow > treport)=E2=80=99 to 'if (tnow >=3D treport)=E2=80=
=99

Nice!

> > The only issue specific to GSO is that xmit_more can forego this
> > doorbell until the last segment. We want to complicate this logic with
> > a special case based on tx_flags. A process that cares should either
> > not use GSO, or the timestamp should be associated with the last
> > segment as I've been arguing so far.
>
> This is the area I was thinking of looking into. I=E2=80=99m not sure it =
will work
> or that it will be too messy. It may be worth a little bit of digging to
> see if there is anything there. That will be down the road a bu

Sorry, I meant  we [do not (!)] want to complicate this logic. And
definitely don't want to read skb_shinfo where that cacheline isn't
accessed already.

Given xmit_more, do you still find the first segment the right one to
move the timestamp tx_flags to in __udp_gso_segment?

>
> >>
> >> I=E2=80=99ll get back to you when I have tested this more thoroughly. =
Early results
> >> suggest that adding the -P poll() option has fixed it without any appr=
eciable
> >> performance hit. I=E2=80=99ll share raw results with you, and we can m=
ake a final
> >> decision together.
> >
> > In the main loop? It still is peculiar that notifications appear to go
> > missing unless the process blocks waiting for them. Nothing in
> > sock_zerocopy_callback or the queueing onto the error queue should
> > cause drops, as far as I know.
> >
>
> Now that I know the issue is only in TCP, I can speculate that all bytes =
are
> being reported, but done with fewer messages. It may warrant some
> investigation in case there is some kind of bug.

This would definitely still be a bug and should not happen. We have
quite a bit of experience with TCP zerocopy and I have not run into
this in practice, so I do think that it is somehow a test artifact.

> > Indeed. Ideally even run all tests, but return error if any failed,
> > like this recent patch
> >
> >  selftests/bpf: fail test_tunnel.sh if subtests fail
> >  https://patchwork.ozlabs.org/patch/1105221/
> >
> > but that may be a lot of code churn and better left to a separate patch=
.
>
> I like it. I have it coded up, and it seems to work well. I=E2=80=99ll ma=
ke a
> separate commit in the patch set so we can yank it out if you feel
> it is too much

Great. Yes, it sounds like an independent improvement, in which case
it is easier to review as a separate patch. If you already have it, by
all means send it as part of the larger patchset.
