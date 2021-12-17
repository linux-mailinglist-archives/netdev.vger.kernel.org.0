Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6172647975C
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 23:52:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231326AbhLQWwa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 17:52:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:45208 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229741AbhLQWwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 17:52:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639781549;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KIfNPg4Ek23uymHcrCBfHoRb/qMjaiLTX5OGzFweZo4=;
        b=f3/xsQA+XRtar8po5PQ/eNlPakyeXnp3MBbp3gHw6F6ts780TSnnGlZqTJtFo6aDICQbvs
        /dVGMEKaSwd6a4I6DEu++p9MDIK6N0aXWH10WJRiGTMKtdCp5rFlQ8GUfC4rCoAwp0QSAJ
        UzNd0e6wVPoI9Zq2miqCkSPxEVCekEw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-591-kuMHDG7IONG3Dr_xERVgfA-1; Fri, 17 Dec 2021 17:52:28 -0500
X-MC-Unique: kuMHDG7IONG3Dr_xERVgfA-1
Received: by mail-wr1-f71.google.com with SMTP id x20-20020adfbb54000000b001a0d044e20fso1025709wrg.11
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 14:52:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=KIfNPg4Ek23uymHcrCBfHoRb/qMjaiLTX5OGzFweZo4=;
        b=W5Lq4k8npzkCAHSS4ms16WOgKe/njtXpzjAuFEmThwEwWfyUmX85W4/ywP/hKHXR38
         v+L5tgiw9mtlKdhnC0yTmBTpsY+RGwF5kkA/gnnRiv7EdIMNuvaLa4ztfz98l9eO4+w/
         GiDBvzip3BiaalrccHf17OfQPJdt0814C4+9oZoDtJZGBjQY13BcQpW55TDrWaRda68w
         5JeVC4GoqUbnYiPWmQBWtD9N8UPe5Q4iVcKZL/kb4DaiA2JkbHD7A7VKF1VwADNMS3g4
         2JHWN2QxqkIU3Xi1BcEsAWBFFJV6WO+50vY7exd9a8voKV/sB1QaNAyOrkg3iB9mhkQB
         F6fw==
X-Gm-Message-State: AOAM533MRgu+DjW47mhyYE3QXxrW65YoOfCQ34NchFRJgQdrGiHQ7QX4
        YtuMa2f+jh345qB/eaZj5AlEBPiRkkiim19Qdq0wwudEZnBtLFomjmqqJ2bd3BHE/U9GOFS7LTo
        ePJLSRPnV3ze1dE2o
X-Received: by 2002:a1c:ed18:: with SMTP id l24mr11550718wmh.99.1639781547114;
        Fri, 17 Dec 2021 14:52:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwwALiLkwvqaFyonj424pmN3h/HftDNX/HbZeHnQu3cvx2ZcwnbobBZJDJ/j+s68q/gjPzyoQ==
X-Received: by 2002:a1c:ed18:: with SMTP id l24mr11550712wmh.99.1639781546924;
        Fri, 17 Dec 2021 14:52:26 -0800 (PST)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id u15sm7111573wmq.13.2021.12.17.14.52.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Dec 2021 14:52:26 -0800 (PST)
Date:   Fri, 17 Dec 2021 23:52:24 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Russell Strong <russell@strong.id.au>
Subject: Re: [PATCH net-next 0/4] inet: Separate DSCP from ECN bits using new
 dscp_t type
Message-ID: <20211217225224.GA4135@pc-4.home>
References: <cover.1638814614.git.gnault@redhat.com>
 <87k0g8yr9w.fsf@toke.dk>
 <20211215164826.GA3426@pc-1.home>
 <87czlvazfk.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87czlvazfk.fsf@toke.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 17, 2021 at 06:55:43PM +0100, Toke Høiland-Jørgensen wrote:
> >> > Note that there's no equivalent of patch 3 for IPv6 (ip route), since
> >> > the tos/dsfield option is silently ignored for IPv6 routes.
> >> 
> >> Shouldn't we just start rejecting them, like for v4?
> >
> > I had some thoughs about that, but didn't talk about them in the cover
> > letter since I felt there was already enough edge cases to discuss, and
> > this one wasn't directly related to this series (the problem is there
> > regardless of this RFC).
> >
> > So, on the one hand, we have this old policy of ignoring unknown
> > netlink attributes, so it looks consistent to also ignore unused
> > structure fields.
> >
> > On the other hand, ignoring rtm_tos leads to a different behaviour than
> > what was requested. So it certainly makes sense to at least warn the
> > user. But a hard fail may break existing programs that don't clear
> > rtm_tos by mistake.
> >
> > I'm not too sure which approach is better.
> 
> So I guess you could argue that those applications were broken in the
> first place, and so an explicit reject would only expose this? Do you
> know of any applications that actually *function* while doing what you
> describe?

I don't know of any existing application that actually does. But it's
easy to imagine a developer setting only parts of the rtmsg structure
and leaving the rest uninitialised. Exposing the problem might not help
the end user, who may have no way to modify the broken program.

Also, for people using ifupdown (/etc/network/interfaces on Debian and
derivatives), rejecting a command can cancel the configuration of an
entire device section. So a stray tos option on an ip -6 route command
would now leave the network interface entirely unconfigured.

I'm not saying these situations exist, just trying to anticipate all
possible side effects.

> One thought could be to add the rejection but be prepared to back it out
> if it does turn out (during the -rc phase) that it breaks something?

Given that it's something that'd be easy to revert, maybe we can try
this approach.

> -Toke
> 

