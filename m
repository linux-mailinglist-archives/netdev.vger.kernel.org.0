Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B07153247B5
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 01:00:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234547AbhBYAAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 19:00:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbhBYAAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 19:00:17 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 711D4C061574
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 15:59:37 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id p186so3665707ybg.2
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 15:59:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Wb+lEMXGh0yHdvH4YGoOxOUTkJ2HV8jyu838oo0EdLM=;
        b=XYM8EOUFuYmLf/990dU7DzQT3VzruQMFnDmOJrF3sLUxOmwlWNwOFBd59XjrDCveuv
         m+7o1NMuGAxcg81TVqMAJUtL0Na+LufpHq1ck7+rDFibZYRshBJA47pjS/rYsnEUhTjT
         y+aXt/98zBk8My0d7ortsnM3QFgjal9XWIXTMsWhDnza7U83EajPqAM/O16PfBPvde7F
         0a5ajM083F5YXUNT+2+fIMOaJLmfCyENtnDcEIt1PNi0s0Ju7hgKrupGpcoLnePiVUYb
         Koaum++h7EccGim0LaK0xy2ikJhcUDPOFr7gAj7RksUam4ggYpe9k5s7/PrHWZ4+jGBx
         gTzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Wb+lEMXGh0yHdvH4YGoOxOUTkJ2HV8jyu838oo0EdLM=;
        b=T4PyKUg+UhtWW8cgDhJ/RNQnu6+6LQTcGQJ2+eepXV9SypBvt8tDADYsQvQf9z2PgQ
         YNgnJi+UB6JXIEodUIONilY6zubTwe6j/bedMbbqb3tL6eaa/DX7IH5lE5AxQH5yXWrP
         Ru2z6532l2OWo8WWJv59VOLte75KPYRcgwV5U+HhjhVmPn2CYUXCqaP7S3Xmv7Wa1luK
         GilW9Zq2KYRM85kPF7FuNdWExOfuD7ynuMaH/Nv628COl6amXxZPyboqLkg1zTkMuzIU
         PYmT4cVX2oP98J0L57mlGTw23K2/B8zxIGsYr4FVqAPTRpsQNbAoFd5imCm2Rw3sPAz5
         3pVQ==
X-Gm-Message-State: AOAM530PyPMtJNNGDgSJjrd2xX+FXo2zzLzBnS0YPIzLyR+LnYxLKd7C
        0ZcCkjFIkyC8J0XM3j1iCmu5VS2YOAQxZAXoSdisPw==
X-Google-Smtp-Source: ABdhPJzeJSj5I6lR/UBF6I7bOg1u3pRAifHjZyggMt3xDbT4PZxGQ9KJraBqxx9IdYRw96UqWvjxfeWujdcWkMOuJVk=
X-Received: by 2002:a25:fc3:: with SMTP id 186mr226541ybp.452.1614211176410;
 Wed, 24 Feb 2021 15:59:36 -0800 (PST)
MIME-Version: 1.0
References: <20210223234130.437831-1-weiwan@google.com> <20210224114851.436d0065@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANn89i+jO-ym4kpLD3NaeCKZL_sUiub=2VP574YgC-aVvVyTMw@mail.gmail.com>
 <20210224133032.4227a60c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANn89i+xGsMpRfPwZK281jyfum_1fhTNFXq7Z8HOww9H1BHmiw@mail.gmail.com> <20210224155237.221dd0c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210224155237.221dd0c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 25 Feb 2021 00:59:25 +0100
Message-ID: <CANn89iKYLTbQB7K8bFouaGFfeiVo00-TEqsdM10t7Tr94O_tuA@mail.gmail.com>
Subject: Re: [PATCH net] net: fix race between napi kthread mode and busy poll
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Wei Wang <weiwan@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Martin Zaharinov <micron10@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 25, 2021 at 12:52 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 24 Feb 2021 23:30:23 +0100 Eric Dumazet wrote:
> > On Wed, Feb 24, 2021 at 10:30 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > Just to find out what the LoC is I sketched this out:
> > >
> > > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > > index ddf4cfc12615..77f09ced9ee4 100644
> > > --- a/include/linux/netdevice.h
> > > +++ b/include/linux/netdevice.h
> > > @@ -348,6 +348,7 @@ struct napi_struct {
> > >         struct hlist_node       napi_hash_node;
> > >         unsigned int            napi_id;
> > >         struct task_struct      *thread;
> > > +       struct list_head        thread_poll_list;
> > >  };
> >
> > offlist, since it seems this conversation is upsetting you.
>
> Interesting, vger seems to be CCed but it isn't appearing on the ML.
> Perhaps just a vger delay :S
>
> Not really upsetting. I'm just trying to share what I learned devising
> more advanced pollers. The bits get really messy really quickly.
> Especially that the proposed fix adds a bit for a poor bystander (busy
> poll) while it's the threaded IRQ that is incorrectly not preserving
> its ownership.
>
> > Additional 16 bytes here, possibly in a shared cache line, [1]
> > I prefer using a bit in hot n->state, we have plenty of them available.
>
> Right, presumably the location of the new member could be optimized.
> I typed this proposal up in a couple of minutes.
>
> > We worked hours with Alexander, Wei, I am sorry you think we did a poor job.
> > I really thought we instead solved the issue at hand.
> >
> > May I suggest you defer your idea of redesigning the NAPI model for
> > net-next ?
>
> Seems like you decided on this solution off list and now the fact that
> there is a discussion on the list is upsetting you. May I suggest that
> discussions should be conducted on list to avoid such situations?

We were trying to not pollute the list (with about 40 different emails so far)

(Note this was not something I initiated, I only hit Reply all button)

OK, I will shut up, since you seem to take over this matter, and it is
1am here in France.
