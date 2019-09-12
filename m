Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D179B0B0B
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 11:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730623AbfILJOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 05:14:38 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:39413 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730268AbfILJOh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 05:14:37 -0400
Received: by mail-io1-f66.google.com with SMTP id d25so52859957iob.6
        for <netdev@vger.kernel.org>; Thu, 12 Sep 2019 02:14:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ygKfqSSd57eb5CwAvJXPH5V2Ht73ot9zIPw0gR2s/g8=;
        b=rykBqli5OE8OyaZfdhmvIZYdPRI79hO/4kN0q3l4nXKKL2ZUPb2VO/eOBQUhahYCK1
         Lh6l2BFYnqo4qWST06KzhhDylcfCuY09rUSetVPsdlXAveDo1OdEKDVTf+g9rWGoS+77
         kYFO1TeVnP8mqvHhefG7eB4T4ko/hSdGVdlWZKiSf89ncn08hajlsv4FnTtuELONSWPa
         nxBL9/LvfF9Qd1w65CrlZOEutUmjUCcxYOQ8V3iQgqK6aNygq5lqL+DqYnrl/7cYBYzL
         icOurRah0qphp4NDVHAXrWbjiZGAnfJg+sHGUknN701Xhr+EJ/ZHU5tNIC5rjeQri8zg
         kFVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ygKfqSSd57eb5CwAvJXPH5V2Ht73ot9zIPw0gR2s/g8=;
        b=eQX0JNX3OSFuE/J3EhQf4rFxakuyRY7LEkneB1s3uSA90EwU7aWQXu8xEDle0XSkk/
         Fx2wG3Sw8aNnDJyuyFJocqaglaM6WCzf3TYvaXGFW0PyR6EVBLUvBgEmhgpIqfUVmBOr
         uvTEMR47LGalTTiaWORLTA30HUKL3/Y4oXLQCoIS0KBi2RTnO8z+ItdqYS1d7wBlHl6P
         ra2rlUlXoEvNRcPIYdcxbn0GEluJl3iFe3dS+w6h/riiqcFeLD0xqSt4eGCso6mx66Wg
         yQz3n+GMJYHRjJKsQV5B3pt1dUfSKfki4mUKrRombIaQ+sGGnMVZsiYy2T3EYt2uL39k
         QcqA==
X-Gm-Message-State: APjAAAX+eaBS79StFdGGDd1/g4GjuNS7U0pHtzlT8lkdGaHan9AWs9Ht
        BVrrlawVHiUZGid7kfLDG7bcEga8ywuIkKd1LCU=
X-Google-Smtp-Source: APXvYqz8PZep2S6QnAYi/c8np/8k4FitHT6e4+XqnmzZngzmFt1CKB0UCN2eB05Yig0m0l+2tjz7T1Kx/VsxSQC5Y4Q=
X-Received: by 2002:a6b:7a09:: with SMTP id h9mr3401304iom.0.1568279676788;
 Thu, 12 Sep 2019 02:14:36 -0700 (PDT)
MIME-Version: 1.0
References: <20190911223148.89808-1-tph@fb.com> <20190911223148.89808-2-tph@fb.com>
 <CADVnQynNiTEAmA-++JL7kMeht+dzfh2b==R_UJnEdnX3W=3k8g@mail.gmail.com>
In-Reply-To: <CADVnQynNiTEAmA-++JL7kMeht+dzfh2b==R_UJnEdnX3W=3k8g@mail.gmail.com>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Thu, 12 Sep 2019 10:14:33 +0100
Message-ID: <CAA93jw7q71mpenRMD0dWiVNap1WKD6O4+GCBagcPa5OhHTMErw@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] tcp: Add rcv_wnd to TCP_INFO
To:     Neal Cardwell <ncardwell@google.com>
Cc:     Thomas Higdon <tph@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Dave Jones <dsj@fb.com>, Eric Dumazet <edumazet@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 12, 2019 at 1:59 AM Neal Cardwell <ncardwell@google.com> wrote:
>
> On Wed, Sep 11, 2019 at 6:32 PM Thomas Higdon <tph@fb.com> wrote:
> >
> > Neal Cardwell mentioned that rcv_wnd would be useful for helping
> > diagnose whether a flow is receive-window-limited at a given instant.
> >
> > This serves the purpose of adding an additional __u32 to avoid the
> > would-be hole caused by the addition of the tcpi_rcvi_ooopack field.
> >
> > Signed-off-by: Thomas Higdon <tph@fb.com>
> > ---
>
> Thanks, Thomas.
>
> I know that when I mentioned this before I mentioned the idea of both
> tp->snd_wnd (send-side receive window) and tp->rcv_wnd (receive-side
> receive window) in tcp_info, and did not express a preference between
> the two. Now that we are faced with a decision between the two,
> personally I think it would be a little more useful to start with
> tp->snd_wnd. :-)
>
> Two main reasons:
>
> (1) Usually when we're diagnosing TCP performance problems, we do so
> from the sender, since the sender makes most of the
> performance-critical decisions (cwnd, pacing, TSO size, TSQ, etc).
> From the sender-side the thing that would be most useful is to see
> tp->snd_wnd, the receive window that the receiver has advertised to
> the sender.

I am under the impression, that particularly in the mobile space, that
network behavior
is often governed by rcv_wnd. At least, there's been so many papers on
this that I'd
tended to assume so.

Given a desire to do both vars, is there a *third* u32 we could add to
fill in the next hole? :)
ecn marks?

>
> (2) From the receiver side, "ss" can already show a fair amount of
> info about receive-side buffer/window limits, like:
> info->tcpi_rcv_ssthresh, info->tcpi_rcv_space,
> skmeminfo[SK_MEMINFO_RMEM_ALLOC], skmeminfo[SK_MEMINFO_RCVBUF]. Often
> the rwin can be approximated by combining those.
>
> Hopefully Eric, Yuchung, and Soheil can weigh in on the question of
> snd_wnd vs rcv_wnd. Or we can perhaps think of another field, and add
> the tcpi_rcvi_ooopack, snd_wnd, rcv_wnd, and that final field, all
> together.
>
> thanks,
> neal



--=20

Dave T=C3=A4ht
CTO, TekLibre, LLC
http://www.teklibre.com
Tel: 1-831-205-9740
