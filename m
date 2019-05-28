Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 919722BCBC
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 03:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727754AbfE1BQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 21:16:09 -0400
Received: from mail-ed1-f42.google.com ([209.85.208.42]:37713 "EHLO
        mail-ed1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727090AbfE1BQJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 21:16:09 -0400
Received: by mail-ed1-f42.google.com with SMTP id w37so29080553edw.4;
        Mon, 27 May 2019 18:16:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JSsEhEqaRLOeUyOv3kqRTkpJB2sycYE1Xy7YiI46B4g=;
        b=XxXjaSO5IfAGKTWEuhQhjfuV3NO5yQNPutTuNwsYUrKu2U7MUyGQ4RjZ4mw90B8sDM
         nUR3anPhdOh2w0oBe4OZpREpIBA7LLdVD+5nYfaY/fbQIGa+kf0emnA02aTbnp8UM7MG
         Y27zatuNbLdWIk8q+JycBs96eK/iJ4ohIY+ufvEfoNrGhNdZ6LZYgSSIfei0fN8SG3s1
         7NQ3xsuauz2Kk9Nb0mKRDD+pUxp15ub8zk8onSDsOjIEtjRHUD0VPgkvgQ+tICSsFxYU
         ppaZUh38/tMfF3s6niExtoqxmi4Xlx0exeT4tifbW1jNVKtJ7Dz3Q8ngSc5mDbn/3gxn
         KNhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JSsEhEqaRLOeUyOv3kqRTkpJB2sycYE1Xy7YiI46B4g=;
        b=YIemQ7CPHXwF8U+IN4e9STQr7mr/u0lpBDtGuK3Sd/5UofBTldDGeMmPzwJKWmJ8H5
         UjW0iBA7Oco16XIsAgQf/jkVmFmhKRD0jJpPA5JcO2ZoWzvm49B5ftdoKztwNKmY2nc+
         SR77tpyor4mq3FAuJjM2pw8WzXdegAdFEP3oj2ENfjWkbRg4nuy5E6CoYdkqz1laZEI7
         /RTUUoqhviAcZB5oX6BJrNiZIcuxCj0DspEN2WmnZJ277ZzXdwBQEUXSgp0JPXu/D3EY
         cIKtaejeq1OPhrIVQ8+oCiBfnkf+6s88ZvHxcP25enuGxoX0KGkHbMtOmn8TrqpvnkeN
         kUdg==
X-Gm-Message-State: APjAAAUWSs6W7zcazKa00V+mzoUEHEybe+ZOF+4UPh9ZVeevphuc4L8l
        wSvnYyCLnZqfWExQoRnHHVc1Z6mqccm1DyjXPekR1yJo
X-Google-Smtp-Source: APXvYqwtY4FgvCGJBe9IunZA08b7xGiFfu2vqXOEPH+PNa4KPE+PeVo+O7yUs5kSmsvhIJydfsd7EjpZUv0M+psZAmY=
X-Received: by 2002:a17:906:aacb:: with SMTP id kt11mr85777535ejb.246.1559006166287;
 Mon, 27 May 2019 18:16:06 -0700 (PDT)
MIME-Version: 1.0
References: <20190523210651.80902-1-fklassen@appneta.com> <20190523210651.80902-5-fklassen@appneta.com>
 <CAF=yD-KBNLr5KY-YQ1KMmZGCpYNefSJKaJkZNOwd8nRiedpQtA@mail.gmail.com>
 <879E5DA6-3A4F-4CE1-9DA5-480EE30109DE@appneta.com> <CAF=yD-LQT7=4vvMwMa96_SFuUd5GywMoae7hGi9n6rQeuhhxuQ@mail.gmail.com>
 <5BB184F2-6C20-416B-B2AF-A678400CFE3E@appneta.com>
In-Reply-To: <5BB184F2-6C20-416B-B2AF-A678400CFE3E@appneta.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 27 May 2019 21:15:30 -0400
Message-ID: <CAF=yD-+6CRyqL6Fq5y2zpw5nnDitYC7G1c2JAVHZTjyw68DYJg@mail.gmail.com>
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

On Mon, May 27, 2019 at 6:56 PM Fred Klassen <fklassen@appneta.com> wrote:
>
>
>
> > On May 27, 2019, at 2:46 PM, Willem de Bruijn <willemdebruijn.kernel@gm=
ail.com> wrote:
> >> Also, I my v2 fix in net is still up for debate. In its current state,=
 it
> >> meets my application=E2=80=99s requirements, but may not meet all of y=
ours.
>
> > I gave more specific feedback on issues with it (referencing zerocopy
> > and IP_TOS, say).
> >
>
> Unfortunately I don=E2=80=99t have a very good email setup, and I found a
> bunch of your comments in my junk folder. That was on Saturday,
> and on Sunday I spent some time implementing your suggestions.
> I have not pushed the changes up yet.
>
> I wanted to discuss whether or not to attach a buffer to the
> recvmsg(fd, &msg, MSG_ERRQUEUE). Without it, I have
> MSG_TRUNC errors in my msg_flags. Either I have to add
> a buffer, or ignore that error flag.

Either sounds reasonable. It is an expected and well understood
message if underprovisioning the receive data buffer.

> > Also, it is safer to update only the relevant timestamp bits in
> > tx_flags, rather that blanket overwrite, given that some bits are
> > already set in skb_segment. I have not checked whether this is
> > absolutely necessary.
> >
>  I agree. See tcp_fragment_tstamp().
>
> I think this should work.
>
> skb_shinfo(seg)->tx_flags |=3D
>                         (skb_shinfo(gso_skb)->tx_flags & SKBTX_ANY_TSTAMP=
);

Agreed. It is more obviously correct. Only drawback is that the RMW is
more expensive than a straight assignment.

> >> I am still open to suggestions, but so far I don=E2=80=99t have an alt=
ernate
> >> solution that doesn=E2=80=99t break what I need working.
> >
> > Did you see my response yesterday? I can live with the first segment.
> > Even if I don't think that it buys much in practice given xmit_more
> > (and it does cost something, e.g., during requeueing).
> >
>
> I=E2=80=99m sorry, I didn=E2=80=99t receive a response. Once again, I am =
struggling
> with crappy email setup. Hopefully as of today my junk mail filters are
> set up properly.
>
> I=E2=80=99d like to see that comment.

The netdev list is archived and available through various websites,
like lore.kernel.org/netdev . As well as the patches with comments at
patchwork.ozlabs.org/project/netdev/list

> I have been wondering about xmit_more
> myself. I don=E2=80=99t think it changes anything for software timestamps=
,
> but it may with hardware timestamps.

It arguably makes the software timestamp too early if taken on the
first segment, as the NIC is only informed of all the new descriptors
when the last segment is written and the doorbell is rung.

> > Can you elaborate on this suspected memory leak?
>
> A user program cannot free a zerocopy buffer until it is reported as free=
.
> If zerocopy events are not reported, that could be a memory leak.
>
> I may have a fix. I have added a -P option when I am running an audit.
> It doesn=E2=80=99t appear to affect performance, and since implementing i=
t I have
> received all error messages expected for both timestamp and zerocopy.
>
> I am still testing.

I see, a userspace leak from lack of completion notification.

If the issue is a few missing notifications at the end of the run,
then perhaps cfg_waittime_ms is too short.

> > On a related note, tests run as part of continuous testing should run
> > as briefly as possible. Perhaps we need to reduce the time per run to
> > accommodate for the new variants you are adding.
> >
>
> I could reduce testing from 4 to 2 seconds. Anything below that and I
> miss some reports. When I found flakey results, I found I could reproduce
> them in as little as 1 second.
> >> Summary over 4.000 seconds...
> >> sum tcp tx:   6921 MB/s     458580 calls (114645/s)     458580 msgs (1=
14645/s)
> >> ./udpgso_bench_tx: Unexpected number of Zerocopy completions:    45858=
0 expected    458578 received
> >
> > Is this the issue you're referring to? Good catch. Clearly this is a
> > good test to have :) That is likely due to some timing issue in the
> > test, e.g., no waiting long enough to harvest all completions. That is
> > something I can look into after the code is merged.
>
> Thanks.
>
> Should the test have failed at this point? I did return an error(), but
> the script kept running.

This should normally be cause for test failure, I think yes. Though
it's fine to send the code for review and possibly even merge, so that
I can take a look.

> As stated, I don=E2=80=99t want to push up until I have tested more fully=
, and
> the fix is accepted (which requires a v3). If you want to review what
> I have, I can push it up now with the understanding that I may still
> fine tune things.

Sounds good, thanks.
