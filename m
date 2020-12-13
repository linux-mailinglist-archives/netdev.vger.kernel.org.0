Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 179AE2D904F
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 21:01:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391777AbgLMUAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 15:00:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726881AbgLMUAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Dec 2020 15:00:20 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05C9DC0613D3
        for <netdev@vger.kernel.org>; Sun, 13 Dec 2020 11:59:34 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id 6so5058619ejz.5
        for <netdev@vger.kernel.org>; Sun, 13 Dec 2020 11:59:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nametag.social; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bxL9fgO1ep+UUIAhuCCQKbMzHDFAMCdJgRo0ODasuBs=;
        b=l/2Nh9Lsxwi3XVddgVzE9+UMtRe29Ar/p9sB9KxeGMiXUT/bVILq8jBD1JWiYC2uU9
         3mIR5MKubw+4NJKTQHdUrdx6x9HapMPOANmdS/ciUvmJ4BCGhlOogkL7wApqWzrIuny6
         e1oTh0AGXoq0VZg5F8gWdIc4JH+JS6N59x1msY906Azee83IPD6uMaPxvRrFN0iP6Yan
         +iPhx+p3USPcQPAqBgL6WVkDHqm2MJrIrjlwKtzmTOwpHqcsQTQgRBO0SpEauHGwcNyy
         c71SbcakmdyCxCRYEPQ8nwEumTIoqyvbCOL4FBwhFUbMB175l0y0VuCYrMoXBvMuLWlc
         mi3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bxL9fgO1ep+UUIAhuCCQKbMzHDFAMCdJgRo0ODasuBs=;
        b=s46GC4g2y1TEuTuC2uhXF5NTZJKvftSwBdV8VQRM0xOj0Gu1sgfvGEA0ZFZrbf2yWo
         xgPvDZLouZPUBKOtmbkoVg7EIB/J3tBXYKpkmaoiL7WLKrhnRIuAX4ykqJLowksEzDuE
         ZvMwXcJp/9RosIA8Aq7LbJaywqZZAwH2wzIWoo76FW+1PUKoGgMsJZ6s7DoISpqZSife
         ETBHI9a7sWPcIcdlPAtbZjU+h2pfCVf7aC4tB3xagFwYjVbrZIVziSZgiQ3F7LZok2ao
         xPiIuqJX3jAte4WNoVZVUDALAUjVLyKNj13usBLDFLeIdU0yXByidEFDSgZoDjmt6OLI
         F2Ew==
X-Gm-Message-State: AOAM531dA5Ttq8+IjD13Mq3duGPfus5VNbJsG7wzfmICE3C+jLmpTtrc
        B271/8d7XUumYpN8tru2392zHcdEM34eHnZQtMvJIA==
X-Google-Smtp-Source: ABdhPJx6uY+NKR2ZMWCuqqVZQcdG+tobTGZ0wLgG2UzeC4NAvQswCHSV4g3DWfNuA02BEzECOuJvWnAAMJjLc5k+b/k=
X-Received: by 2002:a17:906:1e0c:: with SMTP id g12mr20262848ejj.214.1607889573574;
 Sun, 13 Dec 2020 11:59:33 -0800 (PST)
MIME-Version: 1.0
References: <CAM1kxwgjCJwSvOtESxWwTC_qcXZEjbOSreXUQrG+bOOrPWdbqA@mail.gmail.com>
 <750bc4e7-c2ce-e33d-dc98-483af96ff330@kernel.dk> <CAM1kxwjm9YFJCvqt4Bm0DKQuKz2Qg975YWSnx6RO_Jam=gkQyg@mail.gmail.com>
 <e618d93a-e3c6-8fb6-c559-32c0b854e321@kernel.dk> <CAM1kxwgX5MsOoJfnCFMnkAqCJr8m34XC2Pw1bpGmrdnUFPhY9Q@mail.gmail.com>
 <bfc41aef-d09b-7e94-ed50-34ec3de6163d@kernel.dk> <CAM1kxwi-P1aVrO9PKj87osvsS4a9PH=hSM+ZJ2mLKJckNeHOWQ@mail.gmail.com>
 <37ccec74-8a7c-b5c6-c11f-aaa9e7113461@kernel.dk>
In-Reply-To: <37ccec74-8a7c-b5c6-c11f-aaa9e7113461@kernel.dk>
From:   Victor Stewart <v@nametag.social>
Date:   Sun, 13 Dec 2020 19:59:22 +0000
Message-ID: <CAM1kxwikq=D5xwckq5Gwb9hgwQER6NQA9JooDkbgf=QRZVbNJw@mail.gmail.com>
Subject: Re: [PATCH 0/3] PROTO_CMSG_DATA_ONLY for Datagram (UDP)
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        netdev <netdev@vger.kernel.org>,
        Stefan Metzmacher <metze@samba.org>,
        Jann Horn <jannh@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

FYI for anyone who happens upon this...

for gmail you have to first turn on 2-factor authentication then
generate a custom app password for this to work. then use that
password, all the rest the same.

On Sat, Dec 12, 2020 at 9:44 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 12/12/20 2:42 PM, Victor Stewart wrote:
> > On Sat, Dec 12, 2020 at 6:02 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >> On 12/12/20 10:58 AM, Victor Stewart wrote:
> >>> On Sat, Dec 12, 2020 at 5:40 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>>>
> >>>> On 12/12/20 10:25 AM, Victor Stewart wrote:
> >>>>> On Sat, Dec 12, 2020 at 5:07 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>>>>>
> >>>>>> On 12/12/20 8:31 AM, Victor Stewart wrote:
> >>>>>>> RE our conversation on the "[RFC 0/1] whitelisting UDP GSO and GRO
> >>>>>>> cmsgs" thread...
> >>>>>>>
> >>>>>>> https://lore.kernel.org/io-uring/CAM1kxwi5m6i8hrtkw7nZYoziPTD-Wp03+fcsUwh3CuSc=81kUQ@mail.gmail.com/
> >>>>>>>
> >>>>>>> here are the patches we discussed.
> >>>>>>>
> >>>>>>> Victor Stewart (3):
> >>>>>>>    net/socket.c: add PROTO_CMSG_DATA_ONLY to __sys_sendmsg_sock
> >>>>>>>    net/ipv4/af_inet.c: add PROTO_CMSG_DATA_ONLY to inet_dgram_ops
> >>>>>>>    net/ipv6/af_inet6.c: add PROTO_CMSG_DATA_ONLY to inet6_dgram_ops
> >>>>>>>
> >>>>>>>    net/ipv4/af_inet.c
> >>>>>>>      |   1 +
> >>>>>>>    net/ipv6/af_inet6.c
> >>>>>>>     |   1 +
> >>>>>>>    net/socket.c
> >>>>>>>        |   8 +-
> >>>>>>>    3 files changed, 7 insertions(+), 3 deletions(-)
> >>>>>>
> >>>>>> Changes look fine to me, but a few comments:
> >>>>>>
> >>>>>> - I'd order 1/3 as 3/3, that ordering makes more sense as at that point it
> >>>>>>   could actually be used.
> >>>>>
> >>>>> right that makes sense.
> >>>>>
> >>>>>>
> >>>>>> - For adding it to af_inet/af_inet6, you should write a better commit message
> >>>>>>   on the reasoning for the change. Right now it just describes what the
> >>>>>>   patch does (which is obvious from the change), not WHY it's done. Really
> >>>>>>   goes for current 1/3 as well, commit messages need to be better in
> >>>>>>   general.
> >>>>>>
> >>>>>
> >>>>> okay thanks Jens. i would have reiterated the intention but assumed it
> >>>>> were implicit given I linked the initial conversation about enabling
> >>>>> UDP_SEGMENT (GSO) and UDP_GRO through io_uring.
> >>>>>
> >>>>>> I'd also CC Jann Horn on the series, he's the one that found an issue there
> >>>>>> in the past and also acked the previous change on doing PROTO_CMSG_DATA_ONLY.
> >>>>>
> >>>>> I CCed him on this reply. Soheil at the end of the first exchange
> >>>>> thread said he audited the UDP paths and believed this to be safe.
> >>>>>
> >>>>> how/should I resubmit the patch with a proper intention explanation in
> >>>>> the meta and reorder the patches? my first patch and all lol.
> >>>>
> >>>> Just post is as a v2 with the change noted in the cover letter. I'd also
> >>>> ensure that it threads properly, right now it's just coming through as 4
> >>>> separate emails at my end. If you're using git send-email, make sure you
> >>>> add --thread to the arguments.
> >>>
> >>> oh i didn't know about git send-email. i was manually constructing /
> >>> sending them lol. thanks!
> >>
> >> I'd recommend it, makes sure your mailer doesn't mangle anything either. FWIW,
> >> this is what I do:
> >>
> >> git format-patch sha1..sha2
> >> mv 00*.patch /tmp/x
> >>
> >> git send-email --no-signed-off-by-cc --thread --compose  --to linux-fsdevel@vger.kernel.org --cc torvalds@linux-foundation.org --cc viro@zeniv.linux.org.uk /tmp/x
> >>
> >> (from a series I just sent out). And then I have the following section in
> >> ~/.gitconfig:
> >>
> >> [sendemail]
> >> from = Jens Axboe <axboe@kernel.dk>
> >> smtpserver = smtp.gmail.com
> >> smtpuser = axboe@kernel.dk
> >> smtpencryption = tls
> >> smtppass = hunter2
> >> smtpserverport = 587
> >>
> >> for using gmail to send them out.
> >>
> >> --compose will fire up your editor to construct the cover letter, and
> >> when you're happy with it, save+exit and git send-email will ask whether
> >> to proceed or abort.
> >>
> >> That's about all there is to it, and provides a consistent way to send out
> >> patch series.
> >
> > awesome thanks! i'll be using this workflow from now on.
> >
> > P.S. hope thats not your real password LOL
>
> Haha it's not, google hunter2 and password and you'll see :-)
>
> --
> Jens Axboe
>
