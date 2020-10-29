Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38B6829F4B4
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 20:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725778AbgJ2TQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 15:16:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbgJ2TP7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 15:15:59 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 861B9C0613D2
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 12:08:14 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id 133so3134661pfx.11
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 12:08:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y24m8J6XRXiyU/lA5xhr9i8ViGqiIsVKI+T4tQrFiYQ=;
        b=iGaIf0Pww+DBgxR4uNtu6DELMsXn7DwkW6+mmgWWopQWnxOdLGkrCSxKTkqNaFkdjG
         uP/w7wsGz+iikuXo/4rWx2Mf8lYgzrEMUxQ8krr0vC6ia3FXy71FF0bpnWIKaj9IRuPS
         WSR5H4eFAlzW+AK00tLa2AiqEaj895ibP2+BjbUhQUBsZuMhJNsAjwcFv600dnrlGwN2
         gExKxjJiXmx/ZtsuyAp9039nKXwagcGe2jZ9jVDqWAiFCX55I7OtUdWDn2aH/NBz6wEe
         PJbMzntkev3zrdaXGb7w0VfA6Zsi+OjNXN1Yu+KuMMFAgOJLyJvShnNxzfktSfNUmHhD
         koUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y24m8J6XRXiyU/lA5xhr9i8ViGqiIsVKI+T4tQrFiYQ=;
        b=QxNS7lhDl7SwKnDNu6FVR143RDhosKIuh/Ipj2bMrK5LFZv+UngV9avozDgUVXE2lG
         2G9jS2+l8jQa2KQsXRPJ2UT73jsZQSn6MfssocOFqndvnq8C0zqag+LevD+Vob847jEs
         gUs+XSD7sKX0uTLW640dozPsrhyrMuIhPPI1GIGudX5z3Wv38vpsgyREGoUnYuzac7W6
         aRBTJ2SL/AK41pacHz8dc3Sqe2Zy/oVgmLmuJWT3DpRaxZuASSBGWv7lcJSmfraSjVvN
         9EIRgQAZTEerVmVa3X7mpj6Hz6yU1bYMThYqsRNDv9AuZWb8onb18cZihow8Q2XYuON+
         FVBA==
X-Gm-Message-State: AOAM530DSMq59RLYBG/+VYVGVux3RvSiCOvz4MazvwMJ8d1NTjWM+vXm
        GbWviQaejz9h8t/jJmQUGBT25uJnkoQ+5iMlGic6EA==
X-Google-Smtp-Source: ABdhPJxByvB+bTE6GDspSqKz9NSozj/5iO5HNuFnfk3VPSFirPRVE2h9Tk/tSYiGqZfgxrcNcgmis/iIHjG6PI5Queo=
X-Received: by 2002:a17:90a:cb92:: with SMTP id a18mr1246719pju.136.1603998493813;
 Thu, 29 Oct 2020 12:08:13 -0700 (PDT)
MIME-Version: 1.0
References: <20201029173620.2121359-1-aleksandrnogikh@gmail.com>
 <20201029173620.2121359-4-aleksandrnogikh@gmail.com> <40e7ef15f3ffd32567c1dd74edae982c53b0fb06.camel@sipsolutions.net>
 <CANpmjNP3Jadj3r27Y+GhxUD_cboqn_d2BYKiqM4BzktezgjRYw@mail.gmail.com>
In-Reply-To: <CANpmjNP3Jadj3r27Y+GhxUD_cboqn_d2BYKiqM4BzktezgjRYw@mail.gmail.com>
From:   Andrey Konovalov <andreyknvl@google.com>
Date:   Thu, 29 Oct 2020 20:08:02 +0100
Message-ID: <CAAeHK+zj8yx8SJB_yy7GrQPiLuAKBTPfTV14-pEhZsiyPBEVbA@mail.gmail.com>
Subject: Re: [PATCH v5 3/3] mac80211: add KCOV remote annotations to incoming
 frame processing
To:     Marco Elver <elver@google.com>
Cc:     Dmitry Vyukov <dvyukov@google.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Aleksandr Nogikh <aleksandrnogikh@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Aleksandr Nogikh <nogikh@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 7:00 PM Marco Elver <elver@google.com> wrote:
>
> On Thu, 29 Oct 2020 at 18:44, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Thu, 2020-10-29 at 17:36 +0000, Aleksandr Nogikh wrote:
> > > From: Aleksandr Nogikh <nogikh@google.com>
> > >
> > > Add KCOV remote annotations to ieee80211_iface_work() and
> > > ieee80211_rx_list(). This will enable coverage-guided fuzzing of
> > > mac80211 code that processes incoming 802.11 frames.
> >
> > I have no idea how we'll get this merged - Jakub, do you want to take
> > the whole series? Or is somebody else responsible for the core kcov
> > part?
>
> Typically core kcov changes have been going via the -mm tree.
>
> Andrey has been making most changes to KCOV recently, so if there are
> no pending changes that conflict, I don't see it's a problem for this
> whole series to go through networking. I think the other series that
> Andrey had been working on has been changed to only touch
> drivers/usb/, so there should be no conflicts pending.
>
> Dmitry, Andrey, is that reasonable?

Yes, sounds good. FTR, USB kcov changes go through the usb tree.
