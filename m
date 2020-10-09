Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83FA82883AC
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 09:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732071AbgJIHfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 03:35:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726326AbgJIHfQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 03:35:16 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 191B0C0613D2
        for <netdev@vger.kernel.org>; Fri,  9 Oct 2020 00:35:16 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id t12so8359898ilh.3
        for <netdev@vger.kernel.org>; Fri, 09 Oct 2020 00:35:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PaPXS9VT+lYpkpjJinLXWcnp4KLFdSw8VYN9MeahkOk=;
        b=vc+c/HnXsil9RCVjjRH9kMTQepASSQ3iP0pY8hU/I8Denk1MgicOEPNjc9X1jwlHf9
         GGPPC1F85R4jWz97xQnXpDExNtbnnmXybB7nbhff3V6k/qTEg3X/l9pqiOGdFQPBHUcl
         u8557vYVFImOa4zwDH5x/zPwP41qQyuieR3pIvnHWR7SlrhkH+IGu3RMDm8aHb5jUoac
         MjGQgENRUPP+RntU8ToiC15h74xVhzsXHOdxqKm+A95VX1JtxsP32aHIOaSfdRF0cptg
         ciGCwO43SU1fTSleFXILP9IXgpXl0G2x4Uhfee5JA5o5RnRG+UxN3u/Iv6tyEFod1wu6
         V0pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PaPXS9VT+lYpkpjJinLXWcnp4KLFdSw8VYN9MeahkOk=;
        b=TiQY2wyumDDfcDKPXIlN7wV/CXuiUVyNzZOUkvT0RBvEPvLCXhAlOsx+S9nN82xwJE
         luRholMquCR47TvL7zj8/VGw7eEY3ppMFg5umiuCmhz+g/+6SqCsOPrvjSuEnOqCdMdL
         eIAUfj5Gvpcm1du4x8XJwHB/AjRWNHwLni9szZPgcPoUVzExckUvyKhRhJ4+ULmrl4w1
         ojnDXbZVFjJJLKS8MVHWyDzUm8y1EkR7a5xT1LjQiUhmhNaIj5Rf7prmfrn3T5qGinKt
         2Z6waRluwPWenVliOqXy/awJO/MP6W5NGUXQHA582PhJB9LsIijQZq8UCKvR/jxbAV71
         Pkaw==
X-Gm-Message-State: AOAM532dH6t17khsC5Thkoppn8jlMmO4kqfAy6ni3PUP9ysYdU6yagxl
        c/EHSLEnClqJ01kiZTMr/iPjZLH3dGdHwBmHZNmXJmWhR6E=
X-Google-Smtp-Source: ABdhPJxmjZ+oiv+GpfzJEVFzb0pp5bzDfk6DgO8MrORZeprLJDyfxcokgPHKT0kTK2QZP+5M0WwCbTuQiFlm2tkCTZY=
X-Received: by 2002:a92:5e42:: with SMTP id s63mr9822939ilb.205.1602228915147;
 Fri, 09 Oct 2020 00:35:15 -0700 (PDT)
MIME-Version: 1.0
References: <20201007165111.172419-1-eric.dumazet@gmail.com> <20201008171846.335b435a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201008171846.335b435a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 9 Oct 2020 09:35:03 +0200
Message-ID: <CANn89i+A2wBXmu8kPpJraBsaz3ndGYYuKz8=y_6n=_mL+HzhHg@mail.gmail.com>
Subject: Re: [PATCH net-next] net/sched: get rid of qdisc->padded
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Allen Pais <allen.lkml@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 9, 2020 at 2:18 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed,  7 Oct 2020 09:51:11 -0700 Eric Dumazet wrote:
> > diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
> > index 6c762457122fd0091cb0f2bf41bda73babc4ac12..d8fd8676fc724110630904909f64d7789f3a4b47 100644
> > --- a/include/net/sch_generic.h
> > +++ b/include/net/sch_generic.h
> > @@ -91,7 +91,7 @@ struct Qdisc {
> >       struct net_rate_estimator __rcu *rate_est;
> >       struct gnet_stats_basic_cpu __percpu *cpu_bstats;
> >       struct gnet_stats_queue __percpu *cpu_qstats;
> > -     int                     padded;
> > +     int                     pad;
> >       refcount_t              refcnt;
> >
> >       /*
>
> Hi Eric!
>
> Why keep the pad field? the member to lines down is
> __cacheline_aligned, so we shouldn't have to manually
> push things out?
>
>         struct gnet_stats_queue __percpu *cpu_qstats;
>         int                     pad;

I usually prefer adding explicit fields to tell where the holes are,
for future reuse.
Not many developers are aware of pahole existence :/
I renamed it to pad, I could have used padding or something else.
