Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 667E5D7882
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 16:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732757AbfJOO36 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 10:29:58 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:44834 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732747AbfJOO36 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 10:29:58 -0400
Received: by mail-qt1-f195.google.com with SMTP id u40so30785016qth.11
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 07:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mbuki-mvuki-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Us0jVTF/ADtQT2j8gMTm5DtwFmXQZ8qwSUXsBsFnBg4=;
        b=0abBBlaRpemdgdv02WjnPkEUPawre50fzy71oqZYyop3dcmyCtdmU2qC9NlKl7/0Pm
         4NI5dc0sJMtbEQ1bKDtb8/gsZxJiNdARJmVb96ifg4tuwmSEG2rPFDnsa+YKCCvj63is
         qFHlCkruVh1VYwWf54FrAR4TsueB+hvoj6n1np/hh5FBkV44tjmub3LFR2rQOvgW0Tcy
         j/5v9F4DDNrAXyQQtgfuEMCGyp5I/G3JeIewmxGNWsctYD4/TmRcX5eBm6fnc85Nhm2a
         i/7uFzikm/OztiHhJ3k6O1MLfB5t3cKzDnptno1JRhTnIfERiXjpM0HroK123vv1N1xu
         MKTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Us0jVTF/ADtQT2j8gMTm5DtwFmXQZ8qwSUXsBsFnBg4=;
        b=BbubzqCPxi4N0CUvhoBqvl7vmI2lrHFJeQS8EtVaxpUUMdWBCK2Ia7BznFVPCRm07U
         8n51gI3nxy3ozyRtR1TwrOqfy0BikDzM+ehCsyIPmLuZ8DHIdJDCqcX0r6JVtCay3g5C
         xC3ny2nzF2IeMrcy3hvBwpfFNaW4TiBokVp88WDmQVnVtmQwNV7A8F8sfN00TI1aw902
         2hQVAMYX3en4DZSdHqfDirMQ/i16MQKTOEkGHIuDSBri6zhb0hzHN69oWMlyuaa0X0vc
         FeRoXV9H/17+G7Swy3ha8osKI32RnEm/rCMiHelIsa9n8ao4bMZAhCrmqS6PV0YG2PM9
         S0Mw==
X-Gm-Message-State: APjAAAVCGThm0Xc+XcRselpowXIsTmTzZRsnt9bGFo3HWwNDxR4GoiQ/
        HoOXYv89kjhfqiJhY4JhsEUmSYJKvypl3Y3Dpun43Iahk1k=
X-Google-Smtp-Source: APXvYqwo1XN4tL1YmORKpmijxbmSrBOlf6kGhDEiYS5QMGK390clESo+vq8l2l324c4EK6nkCAp7EB8q7U3mhdws2Qc=
X-Received: by 2002:ac8:3048:: with SMTP id g8mr38510463qte.286.1571149795694;
 Tue, 15 Oct 2019 07:29:55 -0700 (PDT)
MIME-Version: 1.0
References: <CANSNSoV1M9stB7CnUcEhsz3FHi4NV_yrBtpYsZ205+rqnvMbvA@mail.gmail.com>
 <20191010083102.GA1336@splinter> <CANSNSoVM1Uo106xfJtGpTyXNed8kOL4JiXqf3A1eZHBa7z3=yg@mail.gmail.com>
 <20191011154224.GA23486@splinter> <CAEA6p_AFKwx_oLqNOjMw=oXcAX4ftJvEQWLo0aWCh=4Hs=QjVw@mail.gmail.com>
In-Reply-To: <CAEA6p_AFKwx_oLqNOjMw=oXcAX4ftJvEQWLo0aWCh=4Hs=QjVw@mail.gmail.com>
From:   Jesse Hathaway <jesse@mbuki-mvuki.org>
Date:   Tue, 15 Oct 2019 09:29:44 -0500
Message-ID: <CANSNSoVMXcPpnHBYvDJ9P4PVB2pLGEBHW2j-iD7QqQrFmGFt_Q@mail.gmail.com>
Subject: Re: Race condition in route lookup
To:     Wei Wang <weiwan@google.com>
Cc:     Ido Schimmel <idosch@idosch.org>, Martin KaFai Lau <kafai@fb.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 11, 2019 at 12:54 PM Wei Wang <weiwan@google.com> wrote:
> Hmm... Yes... I would think a per-CPU input cache should work for the
> case above.
> Another idea is: instead of calling dst_dev_put() in rt_cache_route()
> to switch out the dev, we call, rt_add_uncached_list() to add this
> obsolete dst cache to the uncached list. And if the device gets
> unregistered, rt_flush_dev() takes care of all dst entries in the
> uncached list. I think that would work too.
>
> diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> index dc1f510a7c81..ee618d4234ce 100644
> --- a/net/ipv4/route.c
> +++ b/net/ipv4/route.c
> @@ -1482,7 +1482,7 @@ static bool rt_cache_route(struct fib_nh_common
> *nhc, struct rtable *rt)
>         prev = cmpxchg(p, orig, rt);
>         if (prev == orig) {
>                 if (orig) {
> -                       dst_dev_put(&orig->dst);
> +                       rt_add_uncached_list(orig);
>                         dst_release(&orig->dst);
>                 }
>         } else {
>

Thanks Wei for your work on this issue,

Any chance this patch will make it into 5.4?
