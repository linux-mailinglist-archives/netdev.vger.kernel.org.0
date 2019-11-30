Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0101110DCB7
	for <lists+netdev@lfdr.de>; Sat, 30 Nov 2019 06:39:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725825AbfK3Fjm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Nov 2019 00:39:42 -0500
Received: from mail-oi1-f170.google.com ([209.85.167.170]:46348 "EHLO
        mail-oi1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbfK3Fjl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Nov 2019 00:39:41 -0500
Received: by mail-oi1-f170.google.com with SMTP id a124so4135931oii.13
        for <netdev@vger.kernel.org>; Fri, 29 Nov 2019 21:39:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q/hy16ieaAkbFI/xEX93KuHwjI5EpxTeuAlhz8FxldM=;
        b=nx9vJElMcZJehegwb99jLW/48kXSwR0p9SBYnb7TW0bJVe2g5yxjMEz+SvhrCW3YWp
         uUifSndlvM7ikNvGQzdaVeH/k/7E7DXFyC2QbXhu1kc7Cp2IGru32ftz6SHd17SSb83C
         fRic0IuOU3RHq9H7/bYunMauy1qH0RBdGq/foVNbxT4m6jna9o7zzi8JIMT1Ds9CcEpX
         H/W5zbuNmd7nD2kuGabkW0joHvAQqNTc4zGQfW1SjuNklFzltR43SGb7BOHduJJT31w7
         3OurhWDt+RNZnZNywmd2kVSHD2BdXSPESGgc16ZgWYIzxTqCt6BYZstKQu3LPFESRe9U
         r9ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q/hy16ieaAkbFI/xEX93KuHwjI5EpxTeuAlhz8FxldM=;
        b=eyxCB+08PakgpG5gRYuvJaJIFmBKSVCfOyDKgvGI4XG7Fd8UPvoDh373Q2l7sVIhen
         7R4g8F/sJIsnRa+IM7OSeWt9fCzgOeF/lqEw/xYnFFfuHpTBrETLDu344+B7VgWodWxt
         94flt92oY8+DKfpuwOCDaK+2ELqiDV61TtdHS8V+8k1hFV6mRjRG1CSR4+ax/gL7+rAY
         lUrNzYNKCFPg/uHmm4hLW4G7OVFm/o509KFp/Xxf8+F778Q2UQ+ovj4oplu/R9Jrftkc
         DVvKev2BDE/iz/AJ3J2zNHdetQSP2lc+rSTJ1yhjUFqyH5QPSPac5ZEK8gBBfYoQsa1j
         IcEw==
X-Gm-Message-State: APjAAAW5uKjceDtiEKH0wAtyDo+L31ty0InQ4IGNYS2WFoK9qxj4uKyM
        ziWLzY1YGwMavYTLYJDFWmmZCumpD6KJo4O8wCI=
X-Google-Smtp-Source: APXvYqz4FXzrlxHJv61ZR4y+mjDx37HpW4dI5Le+AKtLW2z7KGXjoQFxi4fiqD9ho46WwKMNO0xAA04PRYJSe586QaI=
X-Received: by 2002:a05:6808:ab4:: with SMTP id r20mr15566900oij.166.1575092380748;
 Fri, 29 Nov 2019 21:39:40 -0800 (PST)
MIME-Version: 1.0
References: <68ad6fb82c0edfb788c7ce1a3bdc851b@codeaurora.org>
 <CADVnQynFeJCpv4irANd8O63ck0ewUq66EDSHHRKdv-zieGZ+UA@mail.gmail.com>
 <f7a0507ce733dd722b1320622dfd1caa@codeaurora.org> <CADVnQy=SDgiFH57MUv5kNHSjD2Vsk+a-UD0yXQKGNGY-XLw5cw@mail.gmail.com>
 <2279a8988c3f37771dda5593b350d014@codeaurora.org> <CADVnQykjfjPNv6F1EtWWvBT0dZFgf1QPDdhNaCX3j3bFCkViwA@mail.gmail.com>
 <f9ae970c12616f61c6152ebe34019e2b@codeaurora.org> <CADVnQymqKpMh3iRfrdiAYjb+2ejKswk8vaZCY6EW4-3ppDnv_w@mail.gmail.com>
 <81ace6052228e12629f73724236ade63@codeaurora.org> <CADVnQymDSZb=K8R1Gv=RYDLawW9Ju1tuskkk8LZG4fm3yxyq3w@mail.gmail.com>
 <74827a046961422207515b1bb354101d@codeaurora.org> <827f0898-df46-0f05-980e-fffa5717641f@akamai.com>
 <cae50d97-5d19-7b35-0e82-630f905c1bf6@gmail.com> <5a267a9d-2bf5-4978-b71d-0c8e71a64807@gmail.com>
 <0101016eba384308-7dd6b335-8b75-4890-8733-a4dde8064d11-000000@us-west-2.amazonses.com>
In-Reply-To: <0101016eba384308-7dd6b335-8b75-4890-8733-a4dde8064d11-000000@us-west-2.amazonses.com>
From:   Avinash Patil <avinashapatil@gmail.com>
Date:   Fri, 29 Nov 2019 21:39:33 -0800
Message-ID: <CAJwzM1mkR1dO-Jq7XH40MQz6CxU97YON5tembVL2DRPD6RYy9g@mail.gmail.com>
Subject: Re: Crash when receiving FIN-ACK in TCP_FIN_WAIT1 state
To:     subashab@codeaurora.org
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Josh Hunt <johunt@akamai.com>,
        Neal Cardwell <ncardwell@google.com>,
        Netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

This crash looks quite similar to the one I am experiencing [1] and
reported already.

[1] https://www.spinics.net/lists/netdev/msg611694.html

Thanks,
Avinash

On Fri, Nov 29, 2019 at 6:52 PM <subashab@codeaurora.org> wrote:
>
> >>> Since tcp_write_queue_purge() calls tcp_rtx_queue_purge() and we're
> >>> deleting everything in the retrans queue there, doesn't it make sense
> >>> to zero out all of those associated counters? Obviously clearing
> >>> sacked_out is helping here, but is there a reason to keep track of
> >>> lost_out, retrans_out, etc if retrans queue is now empty? Maybe
> >>> calling tcp_clear_retrans() from tcp_rtx_queue_purge() ?
> >>
> >> First, I would like to understand if we hit this problem on current
> >> upstream kernels.
> >>
> >> Maybe a backport forgot a dependency.
> >>
> >> tcp_write_queue_purge() calls tcp_clear_all_retrans_hints(), not
> >> tcp_clear_retrans(),
> >> this is probably for a reason.
> >>
> >> Brute force clearing these fields might hide a serious bug.
> >>
> >
> > I guess we are all too busy to get more understanding on this :/
>
> Our test devices are on 4.19.x and it is not possible to switch to a
> newer
> version. Perhaps Josh has seen this on a newer kernel.
