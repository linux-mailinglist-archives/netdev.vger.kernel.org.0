Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CFF623A13F
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 10:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726279AbgHCIqb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 04:46:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725806AbgHCIqa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 04:46:30 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC555C06174A;
        Mon,  3 Aug 2020 01:46:30 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id r21so16816173ota.10;
        Mon, 03 Aug 2020 01:46:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ldpq9lUOsWhKwe/FZyOZtBINOPkrHNfkHnfcPwlRPCU=;
        b=WpMWmZ08n26KnNJ8Kee1MYAG1Jm/zPcTsurcm70Oz6QCv5oFfJJeXvq3VcoC9Bqmp3
         ZwUe+YLsT+FIs/9kGKQtxteKlRXHSSQ+XStDVRPK0FJ9rDWqULujkoduvfNvMAyy0GOg
         NoXxh8OaGSL/tRiXvcDRUH0pjdIKGIrcWXdgMqadI1W4uKjz2xIadtm/umq1TPcJ2dwv
         x921GXZ22H8R3fB7B0gACzntSyHHPZ4Uep08cGKEx1pE00WBaNIlW5skBV0VR9xSPFsw
         +/MQUrW8/mEWr+pwjxhIKc3bVJJhFwBIXZ+8+jfHudxJdG2f4k8YUNGYS662utnJkUBW
         AW1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ldpq9lUOsWhKwe/FZyOZtBINOPkrHNfkHnfcPwlRPCU=;
        b=S2i4w17TkTjow/DAUUwUt4cLc0WVNL7DWcViXbTgk/rSb1TPPaqZMWb7GQhnyX/Rvc
         w6YtVicIwgXzpsOGro85vUhiGOcW6kcrr8IQ2o8JMpj8+2zzGjnYtVby1Bwq7OY4Etjw
         Qxz9Efp1zP4sU3G2sR/n0mGpiUplXkc9VmqOkb84Htje6dEgzLx+O1auCVIgZaA2YMxe
         LHPkiQzg6cBO9mWOEQSmo5SJK1VBx43iWtJ7OOwjkUonc/lFa+kEZD+7PDwuEC619K5v
         lm+twLIweE0UMxn9uhrGX2v+atdECWUQ7HMyoGsuk4G/iomj8mgum+X5xRnpi5Z+oWcN
         u/ng==
X-Gm-Message-State: AOAM533mbgZKP9u3qlrG77656FGd2AxYLyIEBX809A1GJteplh9KTB4u
        q5oaQzRXBTfzRJkdD3sQHb5Yb8HNREpFZ3ae6Io=
X-Google-Smtp-Source: ABdhPJywEIvpuyitAoDTtD0/wC6yQxi+TGZF6FmBDXPPZy9GwNZrNEeGyjiIoXvh3WcLO7UKIwA2uajhqG5WgWac/6c=
X-Received: by 2002:a05:6830:1c65:: with SMTP id s5mr12486238otg.264.1596444390081;
 Mon, 03 Aug 2020 01:46:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200716030847.1564131-1-keescook@chromium.org>
 <87h7tpa3hg.fsf@nanos.tec.linutronix.de> <202007301113.45D24C9D@keescook>
In-Reply-To: <202007301113.45D24C9D@keescook>
From:   Allen <allen.lkml@gmail.com>
Date:   Mon, 3 Aug 2020 14:16:15 +0530
Message-ID: <CAOMdWSJQKHAWY1P297b9koOLd8sVtezEYEyWGtymN1YeY27M6A@mail.gmail.com>
Subject: Re: [PATCH 0/3] Modernize tasklet callback API
To:     Kees Cook <keescook@chromium.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Oscar Carter <oscar.carter@gmx.com>,
        Romain Perier <romain.perier@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-usb@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        alsa-devel@alsa-project.org,
        Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kees,

>
> [heavily trimmed CC list because I think lkml is ignoring this
> thread...]
>
> On Thu, Jul 30, 2020 at 09:03:55AM +0200, Thomas Gleixner wrote:
> > Kees,
> >
> > Kees Cook <keescook@chromium.org> writes:
> > > This is the infrastructure changes to prepare the tasklet API for
> > > conversion to passing the tasklet struct as the callback argument instead
> > > of an arbitrary unsigned long. The first patch details why this is useful
> > > (it's the same rationale as the timer_struct changes from a bit ago:
> > > less abuse during memory corruption attacks, more in line with existing
> > > ways of doing things in the kernel, save a little space in struct,
> > > etc). Notably, the existing tasklet API use is much less messy, so there
> > > is less to clean up.
> > >
> > > It's not clear to me which tree this should go through... Greg since it
> > > starts with a USB clean-up, -tip for timer or interrupt, or if I should
> > > just carry it. I'm open to suggestions, but if I don't hear otherwise,
> > > I'll just carry it.
> > >
> > > My goal is to have this merged for v5.9-rc1 so that during the v5.10
> > > development cycle the new API will be available. The entire tree of
> > > changes is here[1] currently, but to split it up by maintainer the
> > > infrastructure changes need to be landed first.
> > >
> > > Review and Acks appreciated! :)
> >
> > I'd rather see tasklets vanish from the planet completely, but that's
> > going to be a daring feat. So, grudgingly:
>
> Understood! I will update the comments near the tasklet API.
>
> > Acked-by: Thomas Gleixner <tglx@linutronix.de>
>

Here's the series re-based on top of 5.8
https://github.com/allenpais/tasklets/tree/V3

Let me know how you would want these to be reviewed.

Also, I was thinking if removing tasklets completely could be a task
on KSPP wiki. If yes, I did like to take ownership of that task. I have a
couple of ideas in mind, which could be discussed in a separate email.

Thanks.

-- 
       - Allen
