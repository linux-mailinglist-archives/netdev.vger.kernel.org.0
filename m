Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6217C644F2
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 12:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbfGJKKz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 10 Jul 2019 06:10:55 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:40239 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726198AbfGJKKz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 06:10:55 -0400
Received: by mail-ed1-f67.google.com with SMTP id k8so1616660eds.7
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 03:10:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9lOC/Yw3CkEcVCwTLFzVkSf4Vv+P39equtPGHjipURw=;
        b=DnLlIFA7c3Hfnyl1YDQCDfH5wbkNbxKGXSjCsupy72a5g9ggzV5d81guyZe4bKWaD0
         BDv55hhZ73dgo09413ngH0G/PcnfM1Rs/IP5k1WQB3/1nSw5ZWlwL9dG9E7sV/cLpRtv
         Pt2czYujuhKPYzYt/9yDf75I/BIOr8SwhSGtdV3v9pDYHK6T4YZra8s+GNM1hUsSoJTo
         sRkfqta6OtY5y9HugpXeOiaOQmKdUYLP4QyuN52EJnBkjKMQaVG924BLURJvvrdxGEdL
         lvBOIpbq3WZw6lX8VaVSYnb3Z0zOAxGSqGR6L/EY3xusiFA8MIX8DZv9dgk4yEmyIrkY
         90lw==
X-Gm-Message-State: APjAAAUEJ67YCw2Kyu5D2AIyqq782WpmSd7xGLCAjr4npf30jupPnF6K
        8lN0xmbbXErdPCAgf9MyP94knM+eCh05CneoBpM53h1H
X-Google-Smtp-Source: APXvYqyMDJb9+WM2IWCjdjhRD7XnCqaCB+oiKf0mBAXYx1Y1yM5X6HYHqVWlAAzKt/1I2IHh9x94KG6BUsvOZ+DsAWU=
X-Received: by 2002:a17:906:948c:: with SMTP id t12mr25813776ejx.222.1562753453713;
 Wed, 10 Jul 2019 03:10:53 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1562667648.git.aclaudi@redhat.com> <5caaac096e5bbbf88ad3aedcc50ff2451f94105c.1562667648.git.aclaudi@redhat.com>
 <CAF2d9jiGnR-A-A-mEv-84Mu6xfwFNvWt5jp+iiBhMGNPMkaDZg@mail.gmail.com>
In-Reply-To: <CAF2d9jiGnR-A-A-mEv-84Mu6xfwFNvWt5jp+iiBhMGNPMkaDZg@mail.gmail.com>
From:   Andrea Claudi <aclaudi@redhat.com>
Date:   Wed, 10 Jul 2019 12:11:46 +0200
Message-ID: <CAPpH65yxRk2A06XCe9KL9W89EsaGj3GTyDi7gxWjt=Z4UUZO5Q@mail.gmail.com>
Subject: Re: [PATCH iproute2 1/2] Revert "ip6tunnel: fix 'ip -6 {show|change}
 dev <name>' cmds"
To:     =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?= 
        <maheshb@google.com>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 9, 2019 at 7:31 PM Mahesh Bandewar (महेश बंडेवार)
<maheshb@google.com> wrote:
>
> On Tue, Jul 9, 2019 at 6:16 AM Andrea Claudi <aclaudi@redhat.com> wrote:
> >
> > This reverts commit ba126dcad20e6d0e472586541d78bdd1ac4f1123.
> > It breaks tunnel creation when using 'dev' parameter:
> >
> > $ ip link add type dummy
> > $ ip -6 tunnel add ip6tnl1 mode ip6ip6 remote 2001:db8:ffff:100::2 local 2001:db8:ffff:100::1 hoplimit 1 tclass 0x0 dev dummy0
> > add tunnel "ip6tnl0" failed: File exists
> >
> > dev parameter must be used to specify the device to which
> > the tunnel is binded, and not the tunnel itself.
> >
> > Reported-by: Jianwen Ji <jiji@redhat.com>
> > Reviewed-by: Matteo Croce <mcroce@redhat.com>
> > Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
> > ---
> >  ip/ip6tunnel.c | 2 --
> >  1 file changed, 2 deletions(-)
> >
> > diff --git a/ip/ip6tunnel.c b/ip/ip6tunnel.c
> > index 56fd3466ed062..999408ed801b1 100644
> > --- a/ip/ip6tunnel.c
> > +++ b/ip/ip6tunnel.c
> > @@ -298,8 +298,6 @@ static int parse_args(int argc, char **argv, int cmd, struct ip6_tnl_parm2 *p)
> >                 p->link = ll_name_to_index(medium);
> >                 if (!p->link)
> >                         return nodev(medium);
> > -               else
> > -                       strlcpy(p->name, medium, sizeof(p->name));
> NACK
>
> I see that ba126dcad20e6d0e472586541d78bdd1ac4f1123 has broke
> something but that doesn't mean revert of the original fix is correct
> way of fixing it. The original fix is fixing the show and change
> command. Shouldn't you try fixing the add command so that all (show,
> change, and add) work correctly?
>

Hi Mahesh,
Thanks for sharing your opinion. I think I already answered this
replying to your review of patch 2/2 of this series.
To summarize that up I think there is a misunderstanding on the
meaning of "dev" param, and "name" param (which is the default) must
be used instead in the cases highlighted in your commit.

Regards,
Andrea

> >         }
> >         return 0;
> >  }
> > --
> > 2.20.1
> >
