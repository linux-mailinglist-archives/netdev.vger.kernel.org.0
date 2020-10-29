Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7133429F15B
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 17:26:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726172AbgJ2Q0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 12:26:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:45312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725764AbgJ2Q02 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 12:26:28 -0400
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A74321481;
        Thu, 29 Oct 2020 16:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603988787;
        bh=AGbrClZ+VS8MDj4+qu/P79fbZI0a9Y/wZY03UqXvbIQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=1J75wL+fenl4QtKgToscDvcdRQgeJ9ckPQzCnFCgel1JGTOeHbz6thszvlkzq7Yc0
         afy5SOlJVefndRFGV2SkdGCmJhln4lVP1Vq8/bs74oxMQ9ihBEJRfif0zHcMKHy4By
         5P4ZjX7werGj7uRVG5cn2B9QiF1paJuVsL9yFAfs=
Received: by mail-qk1-f177.google.com with SMTP id x20so2457693qkn.1;
        Thu, 29 Oct 2020 09:26:27 -0700 (PDT)
X-Gm-Message-State: AOAM532oZamSEpPYosHYFHQHUkwyYgYUxY5Lm21ImTSJdy9BaEYArJ5h
        HE0ZknshwMjCJBJGMId7nHUPIVJKUR68E6tnii4=
X-Google-Smtp-Source: ABdhPJyKhwYeabEUTLeiqjDrdTiy26Ddcp+Fv2Yu27W3qNBlCpIN9wtSAH4ct8Pp5ZNA5hi9rwB4IlEYlt8RC94tdJo=
X-Received: by 2002:a05:620a:b13:: with SMTP id t19mr4215522qkg.3.1603988786437;
 Thu, 29 Oct 2020 09:26:26 -0700 (PDT)
MIME-Version: 1.0
References: <20201027212448.454129-1-arnd@kernel.org> <20201028055628.GB244117@kroah.com>
 <20201029085627.698080a7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201029085627.698080a7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Thu, 29 Oct 2020 17:26:09 +0100
X-Gmail-Original-Message-ID: <CAK8P3a0+C450705M2-mHtvoS1Ogb4YiBCq830d1KAgodKpWK4A@mail.gmail.com>
Message-ID: <CAK8P3a0+C450705M2-mHtvoS1Ogb4YiBCq830d1KAgodKpWK4A@mail.gmail.com>
Subject: Re: [RFC] wimax: move out to staging
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        driverdevel <devel@driverdev.osuosl.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

n Thu, Oct 29, 2020 at 4:56 PM Jakub Kicinski <kuba@kernel.org> wrote:
> On Wed, 28 Oct 2020 06:56:28 +0100 Greg Kroah-Hartman wrote:
> > On Tue, Oct 27, 2020 at 10:20:13PM +0100, Arnd Bergmann wrote:
> >
> > Is this ok for me to take through the staging tree?  If so, I need an
> > ack from the networking maintainers.
> >
> > If not, feel free to send it through the networking tree and add:
> >
> > Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> Thinking about it now - we want this applied to -next, correct?
> In that case it may be better if we take it. The code is pretty dead
> but syzbot and the trivial fix crowd don't know it, so I may slip,
> apply something and we'll have a conflict.

I think git will deal with a merge between branches containing
the move vs fix, so it should work either way.

A downside of having the move in net-next would be that
you'd get trivial fixes send to Greg, but him being unable to
apply them to his tree because the code is elsewhere.

If you think it helps, I could prepare a pull request with this one
patch (and probably the bugfix I sent first that triggered it), and
then you can both merge the branch into net-next as well
as staging-next.

      Arnd
