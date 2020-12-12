Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 440E02D8A2E
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 22:44:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407990AbgLLVnT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 16:43:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404678AbgLLVnT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Dec 2020 16:43:19 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3520CC0613D3
        for <netdev@vger.kernel.org>; Sat, 12 Dec 2020 13:42:39 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id n26so17281608eju.6
        for <netdev@vger.kernel.org>; Sat, 12 Dec 2020 13:42:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nametag.social; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XGYbf5HoZjjCfGTLJRYSseta7mbJxlkIoulFBcBEUJ0=;
        b=hJUlb2X2LpXCSmiP3yNEux1qrylBCIcAY+7C1sUcSNj3lI666ewE64j1bb2nBaDLAZ
         xuMWHbwoMD+0ur6TbH+exS+ur8s2E2eAyVsQFYeRo9LThjjXpRYf2n4PWW7FnLWoBs5G
         EkleCMvd3uyETByE4dwcrhesGg4Nn7XjIAG3KGCGmWHQh0hXi+amgrXv4CrjxSYLnDgM
         +iQHVziBkhQF8Aj8YfKWkQGPhFs82/GaaAYGO+jZANxdVFpicMbjFcnnc9egof+QaMF1
         yXJSX/n/CXPeZgMGWcnvHJWSGWW0xA4b8wjD7AtBzS+0erTTNRDVQfoYvPvTiW7rXqTj
         lh1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XGYbf5HoZjjCfGTLJRYSseta7mbJxlkIoulFBcBEUJ0=;
        b=pQcjCm9OlfYgCbvAYSasnQoA3U9qZFy3ho/goxRjzPTl+totqYaFE5S+asmeuN2G7h
         XxR4wMwMdlzQsggOkjmugZEwCpiszAe0WxnblbkazPo5g+0NL6XwH4rCD/y0z96YLKpq
         qkbNE4z9uF1isLx11R7DCg8gCIa+JvyuS7z1eFeP6mAHsMtoldMdIKvdlbkYgW/WJyN0
         w4MGJpEA9wLR+Kz0j+eTHUHYdmQvMsUx6oBqIW4xCcAui+QRrFURt0zy1KHHGk7sxnyY
         y7dJPrRA9KlyXZauQJmCz1R+L1QjPZLaNGxHrBFdpgmLoqWO9y7rkCZV5D0cKxeAoTtl
         6Plw==
X-Gm-Message-State: AOAM530xib+ruHfBgpFSYN1eAq8hYZ6fWSV3DrFxEFvnBVr9QeW/YQbZ
        kcqL/hNDQiCInqJvXD3riZQx5mJGSu6p3tXJDmSeIg==
X-Google-Smtp-Source: ABdhPJwclknVIlI+LWmHt5LKCrjDgm8qSmPEtwpDqwKLIpzIdW2GfqMFR6WC3I1N3MMHqq/7qjuGXZ7Kai3o7H2+Gs4=
X-Received: by 2002:a17:906:3704:: with SMTP id d4mr16587233ejc.338.1607809357746;
 Sat, 12 Dec 2020 13:42:37 -0800 (PST)
MIME-Version: 1.0
References: <CAM1kxwgjCJwSvOtESxWwTC_qcXZEjbOSreXUQrG+bOOrPWdbqA@mail.gmail.com>
 <750bc4e7-c2ce-e33d-dc98-483af96ff330@kernel.dk> <CAM1kxwjm9YFJCvqt4Bm0DKQuKz2Qg975YWSnx6RO_Jam=gkQyg@mail.gmail.com>
 <e618d93a-e3c6-8fb6-c559-32c0b854e321@kernel.dk> <CAM1kxwgX5MsOoJfnCFMnkAqCJr8m34XC2Pw1bpGmrdnUFPhY9Q@mail.gmail.com>
 <bfc41aef-d09b-7e94-ed50-34ec3de6163d@kernel.dk>
In-Reply-To: <bfc41aef-d09b-7e94-ed50-34ec3de6163d@kernel.dk>
From:   Victor Stewart <v@nametag.social>
Date:   Sat, 12 Dec 2020 21:42:26 +0000
Message-ID: <CAM1kxwi-P1aVrO9PKj87osvsS4a9PH=hSM+ZJ2mLKJckNeHOWQ@mail.gmail.com>
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

On Sat, Dec 12, 2020 at 6:02 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 12/12/20 10:58 AM, Victor Stewart wrote:
> > On Sat, Dec 12, 2020 at 5:40 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >> On 12/12/20 10:25 AM, Victor Stewart wrote:
> >>> On Sat, Dec 12, 2020 at 5:07 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>>>
> >>>> On 12/12/20 8:31 AM, Victor Stewart wrote:
> >>>>> RE our conversation on the "[RFC 0/1] whitelisting UDP GSO and GRO
> >>>>> cmsgs" thread...
> >>>>>
> >>>>> https://lore.kernel.org/io-uring/CAM1kxwi5m6i8hrtkw7nZYoziPTD-Wp03+fcsUwh3CuSc=81kUQ@mail.gmail.com/
> >>>>>
> >>>>> here are the patches we discussed.
> >>>>>
> >>>>> Victor Stewart (3):
> >>>>>    net/socket.c: add PROTO_CMSG_DATA_ONLY to __sys_sendmsg_sock
> >>>>>    net/ipv4/af_inet.c: add PROTO_CMSG_DATA_ONLY to inet_dgram_ops
> >>>>>    net/ipv6/af_inet6.c: add PROTO_CMSG_DATA_ONLY to inet6_dgram_ops
> >>>>>
> >>>>>    net/ipv4/af_inet.c
> >>>>>      |   1 +
> >>>>>    net/ipv6/af_inet6.c
> >>>>>     |   1 +
> >>>>>    net/socket.c
> >>>>>        |   8 +-
> >>>>>    3 files changed, 7 insertions(+), 3 deletions(-)
> >>>>
> >>>> Changes look fine to me, but a few comments:
> >>>>
> >>>> - I'd order 1/3 as 3/3, that ordering makes more sense as at that point it
> >>>>   could actually be used.
> >>>
> >>> right that makes sense.
> >>>
> >>>>
> >>>> - For adding it to af_inet/af_inet6, you should write a better commit message
> >>>>   on the reasoning for the change. Right now it just describes what the
> >>>>   patch does (which is obvious from the change), not WHY it's done. Really
> >>>>   goes for current 1/3 as well, commit messages need to be better in
> >>>>   general.
> >>>>
> >>>
> >>> okay thanks Jens. i would have reiterated the intention but assumed it
> >>> were implicit given I linked the initial conversation about enabling
> >>> UDP_SEGMENT (GSO) and UDP_GRO through io_uring.
> >>>
> >>>> I'd also CC Jann Horn on the series, he's the one that found an issue there
> >>>> in the past and also acked the previous change on doing PROTO_CMSG_DATA_ONLY.
> >>>
> >>> I CCed him on this reply. Soheil at the end of the first exchange
> >>> thread said he audited the UDP paths and believed this to be safe.
> >>>
> >>> how/should I resubmit the patch with a proper intention explanation in
> >>> the meta and reorder the patches? my first patch and all lol.
> >>
> >> Just post is as a v2 with the change noted in the cover letter. I'd also
> >> ensure that it threads properly, right now it's just coming through as 4
> >> separate emails at my end. If you're using git send-email, make sure you
> >> add --thread to the arguments.
> >
> > oh i didn't know about git send-email. i was manually constructing /
> > sending them lol. thanks!
>
> I'd recommend it, makes sure your mailer doesn't mangle anything either. FWIW,
> this is what I do:
>
> git format-patch sha1..sha2
> mv 00*.patch /tmp/x
>
> git send-email --no-signed-off-by-cc --thread --compose  --to linux-fsdevel@vger.kernel.org --cc torvalds@linux-foundation.org --cc viro@zeniv.linux.org.uk /tmp/x
>
> (from a series I just sent out). And then I have the following section in
> ~/.gitconfig:
>
> [sendemail]
> from = Jens Axboe <axboe@kernel.dk>
> smtpserver = smtp.gmail.com
> smtpuser = axboe@kernel.dk
> smtpencryption = tls
> smtppass = hunter2
> smtpserverport = 587
>
> for using gmail to send them out.
>
> --compose will fire up your editor to construct the cover letter, and
> when you're happy with it, save+exit and git send-email will ask whether
> to proceed or abort.
>
> That's about all there is to it, and provides a consistent way to send out
> patch series.

awesome thanks! i'll be using this workflow from now on.

P.S. hope thats not your real password LOL

>
> --
> Jens Axboe
>
