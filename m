Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D28EB47FA77
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 07:14:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235273AbhL0GOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 01:14:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235267AbhL0GOY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 01:14:24 -0500
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE98BC06173E;
        Sun, 26 Dec 2021 22:14:23 -0800 (PST)
Received: by mail-qv1-xf2f.google.com with SMTP id ke6so13111690qvb.1;
        Sun, 26 Dec 2021 22:14:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u+dFE/6V8YlZA37R5EdGCSZl3b3izh9waYOV/+DOAiA=;
        b=NsfVTUuMS5ai5U7Nu3Zn7Bv1nmgI3lW5RlCQ3w2GrHEt4XzxF8qtx3r6DphwBZZkU/
         d5UcoeYma6ORy+kdBdGcMdJ3y8oY4mwShj5xnG/1KdS3+WbI1qd0iAq1rVKIk08EWXwk
         A4YcUcwdhard8raSsODxopTShJuqXUWpGunTuJxFI2KIAhrGk9EaGeEzYTrU+PMxM+Kx
         0dnCUGPIgHwRR46WPlS61nErsnswoBORn8L42YApvmRWh2TZVuM7YttAfThRvb7ylwt8
         Fr9vy0eHYSnTmoIMZW+pcK8Aaer1nklqfHs3i4iHd0WZuQ0VkGYwcn0YexVW2xsfKREl
         eaqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u+dFE/6V8YlZA37R5EdGCSZl3b3izh9waYOV/+DOAiA=;
        b=OCFWYPIBqMJR2BS16sRYvugEUYRYIJjIy6gg3RENcADlA/1tiiUnfXfjeiSWBBZPyd
         CbX+9aaq62VPSbedxIT/fLQhMmsS0wj9bYAGymGuphLKNkAljl5BhfPu31e/jVGVjqIg
         wBxfln7kGtFEw7hi0gFZZG0GRqfIc7KoWUsPo6rrFbLjGvU7OULv7j7vrp1E1MfmRdEo
         XXCV5N6UFxSMsd0Fdd+IN3OCWENlPYqkaiM2fAq8Fl19yN+U43fB5/DVQgTvdbUKTDUp
         3mwbPSLH9kHTZCKrmXYXTJ5pv/EQk2vmI0/cv3PXlMEgdeEO9mmlyk5RRq67zGeHdy0Q
         1JtA==
X-Gm-Message-State: AOAM533AWHsYLlfoK+A0mGW3cXQY0fzSWjpiY6mrpM8RSxGWdtOalnvJ
        hKPvyo+ZY7fMg3sqRvZuECUwIk/6pP0vORmO1U2L3oTeMJAG9A==
X-Google-Smtp-Source: ABdhPJzwfbXmQgXhLB2hjSWy9HTlJXt0fphlDMkgtleB2CJzEiDIT995tXIPrpdaTfkRSS54/ns6c1sIVRpZk0nAMqQ=
X-Received: by 2002:ad4:5aac:: with SMTP id u12mr10003470qvg.105.1640585662738;
 Sun, 26 Dec 2021 22:14:22 -0800 (PST)
MIME-Version: 1.0
References: <1640224567-3014-1-git-send-email-huangzhaoyang@gmail.com> <20211223091100.4a86188f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20211223091100.4a86188f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Zhaoyang Huang <huangzhaoyang@gmail.com>
Date:   Mon, 27 Dec 2021 14:14:02 +0800
Message-ID: <CAGWkznHcjrM2kth8uWtuu+H-LOdPGXAN70nBYJax7aqcuHkECg@mail.gmail.com>
Subject: Re: [PATCH] net: remove judgement based on gfp_flags
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Zhaoyang Huang <zhaoyang.huang@unisoc.com>,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 24, 2021 at 1:11 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 23 Dec 2021 09:56:07 +0800 Huangzhaoyang wrote:
> > From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> >
> > The parameter allocation here is used for indicating if the memory
> > allocation can stall or not. Since we have got the skb buffer, it
> > doesn't make sense to check if we can yield on the net's congested
> > via gfp_flags. Remove it now.
>
> This is checking if we can sleep AFAICT. What are you trying to fix?
Yes and NO. gfp means *get free pages* which indicate if the embedded
memory allocation among the process can sleep or not, but without any
other meanings. The driver which invokes this function could have to
use GFP_KERNEL for allocating memory as the critical resources but
don't want to sleep on the netlink's congestion.

>
> > diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
> > index 4c57532..af5b6af 100644
> > --- a/net/netlink/af_netlink.c
> > +++ b/net/netlink/af_netlink.c
> > @@ -1526,7 +1526,7 @@ int netlink_broadcast(struct sock *ssk, struct sk_buff *skb, u32 portid,
> >       consume_skb(info.skb2);
> >
> >       if (info.delivered) {
> > -             if (info.congested && gfpflags_allow_blocking(allocation))
> > +             if (info.congested)
> >                       yield();
> >               return 0;
> >       }
>
