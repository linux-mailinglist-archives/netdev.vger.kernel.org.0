Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 350382D88D8
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 18:59:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439644AbgLLR7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 12:59:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436681AbgLLR7T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Dec 2020 12:59:19 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0366AC0613D3
        for <netdev@vger.kernel.org>; Sat, 12 Dec 2020 09:58:39 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id dk8so12853437edb.1
        for <netdev@vger.kernel.org>; Sat, 12 Dec 2020 09:58:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nametag.social; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w9wA8pvuLFNHnVRsXy7sHEJrsqyWrHLgJ6VAbhFUT3c=;
        b=xU27+JEaunbHQlMEYNHOmDt+5f+SxEm9NggJzM7nrPSZq7jU7KgnfPa6hQ1bEIQJKV
         fYX1vHFOw3VuoP3xCZbfhYB/eG2/ngjBu4+q6mFkPkbwq8+DBha7riNZW+/rH22oxeDc
         ap2YW3hjDnwcu5aAwvryCE2D77CpW1cp1am7luFUm6GJkttz5fMV9hHQm8pi5FQxIaQl
         VTu8qZYo33qPxNtVHA22/uh0WXFR5h6ciwbvIlz6W5mLfNWLRHHOYU7YyRXhjC9jh86c
         vrCNq9F5NVXGiGCajbyk3FCgHY13aYpU2OefNP0FCtX4Nl4VwZL2hqykS8Kgm19TxyiO
         QCBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w9wA8pvuLFNHnVRsXy7sHEJrsqyWrHLgJ6VAbhFUT3c=;
        b=kjN5GMoxQW5lfAlSegSsf20inuzK/RviLR5CJ0Xn/bTVvXPoAimwGYfXIYSfUiEQ8Q
         PC6b2G+fOAPaMPlLlt9hlOa9ikYRFf5bdGX2r6qtS1dyGg+MRXT0EVpQfMrTr3HfVAnV
         A0wpThUXrdzshRFoYIGf+ij0BiqDp9zaMXvclde4aSLqQF0kaj0WUg7Zzi9taVYBNe8N
         ikNbbXzoFq8HhuVCLXVx0oqdEmYzkGo9eI7IsoM68ePIjoE+Rt+XyxZjClWHfzhO83k0
         aQfLdt+ax8ALTrk9XwAyTykV/K5SDXjKbnBq9Q/a40l9f8lXaAp+NcBh4Ay0drICDIRz
         ZShQ==
X-Gm-Message-State: AOAM532Dx2Kftdm1LYtBAxzsSr64Se30DwhGQj2qplzmvCbFIGua8f2N
        woSfvl0+CHvMV3K573cPlYm/8c0RUKsO3O71S7QvXA==
X-Google-Smtp-Source: ABdhPJxPU+T6Xu63awD2j/omKu+aMd3x7xXtfH5sHPJILDRGWafpPV9Jmw9uIOGKySNOBsl+AaHHt0DiDhLAoO5klk8=
X-Received: by 2002:a05:6402:1ad1:: with SMTP id ba17mr17204660edb.51.1607795917686;
 Sat, 12 Dec 2020 09:58:37 -0800 (PST)
MIME-Version: 1.0
References: <CAM1kxwgjCJwSvOtESxWwTC_qcXZEjbOSreXUQrG+bOOrPWdbqA@mail.gmail.com>
 <750bc4e7-c2ce-e33d-dc98-483af96ff330@kernel.dk> <CAM1kxwjm9YFJCvqt4Bm0DKQuKz2Qg975YWSnx6RO_Jam=gkQyg@mail.gmail.com>
 <e618d93a-e3c6-8fb6-c559-32c0b854e321@kernel.dk>
In-Reply-To: <e618d93a-e3c6-8fb6-c559-32c0b854e321@kernel.dk>
From:   Victor Stewart <v@nametag.social>
Date:   Sat, 12 Dec 2020 17:58:26 +0000
Message-ID: <CAM1kxwgX5MsOoJfnCFMnkAqCJr8m34XC2Pw1bpGmrdnUFPhY9Q@mail.gmail.com>
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

On Sat, Dec 12, 2020 at 5:40 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 12/12/20 10:25 AM, Victor Stewart wrote:
> > On Sat, Dec 12, 2020 at 5:07 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >> On 12/12/20 8:31 AM, Victor Stewart wrote:
> >>> RE our conversation on the "[RFC 0/1] whitelisting UDP GSO and GRO
> >>> cmsgs" thread...
> >>>
> >>> https://lore.kernel.org/io-uring/CAM1kxwi5m6i8hrtkw7nZYoziPTD-Wp03+fcsUwh3CuSc=81kUQ@mail.gmail.com/
> >>>
> >>> here are the patches we discussed.
> >>>
> >>> Victor Stewart (3):
> >>>    net/socket.c: add PROTO_CMSG_DATA_ONLY to __sys_sendmsg_sock
> >>>    net/ipv4/af_inet.c: add PROTO_CMSG_DATA_ONLY to inet_dgram_ops
> >>>    net/ipv6/af_inet6.c: add PROTO_CMSG_DATA_ONLY to inet6_dgram_ops
> >>>
> >>>    net/ipv4/af_inet.c
> >>>      |   1 +
> >>>    net/ipv6/af_inet6.c
> >>>     |   1 +
> >>>    net/socket.c
> >>>        |   8 +-
> >>>    3 files changed, 7 insertions(+), 3 deletions(-)
> >>
> >> Changes look fine to me, but a few comments:
> >>
> >> - I'd order 1/3 as 3/3, that ordering makes more sense as at that point it
> >>   could actually be used.
> >
> > right that makes sense.
> >
> >>
> >> - For adding it to af_inet/af_inet6, you should write a better commit message
> >>   on the reasoning for the change. Right now it just describes what the
> >>   patch does (which is obvious from the change), not WHY it's done. Really
> >>   goes for current 1/3 as well, commit messages need to be better in
> >>   general.
> >>
> >
> > okay thanks Jens. i would have reiterated the intention but assumed it
> > were implicit given I linked the initial conversation about enabling
> > UDP_SEGMENT (GSO) and UDP_GRO through io_uring.
> >
> >> I'd also CC Jann Horn on the series, he's the one that found an issue there
> >> in the past and also acked the previous change on doing PROTO_CMSG_DATA_ONLY.
> >
> > I CCed him on this reply. Soheil at the end of the first exchange
> > thread said he audited the UDP paths and believed this to be safe.
> >
> > how/should I resubmit the patch with a proper intention explanation in
> > the meta and reorder the patches? my first patch and all lol.
>
> Just post is as a v2 with the change noted in the cover letter. I'd also
> ensure that it threads properly, right now it's just coming through as 4
> separate emails at my end. If you're using git send-email, make sure you
> add --thread to the arguments.

oh i didn't know about git send-email. i was manually constructing /
sending them lol. thanks!

>
> --
> Jens Axboe
>
