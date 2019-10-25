Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4794BE451B
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 10:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437633AbfJYICh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 04:02:37 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42525 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437519AbfJYICg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 04:02:36 -0400
Received: by mail-wr1-f67.google.com with SMTP id r1so1164179wrs.9;
        Fri, 25 Oct 2019 01:02:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eoe1jm+S/J7sLO7uqwBuLWMAwNPuBQISVnb82FJ2SwI=;
        b=ITBLMXzxsfgASrU2BFTFAbDzUSKaeAvaVihaOZeuExOygFUPcqxmeibyH/YaHOQXGV
         bmATIHeE0brs/QUdlLoUDk4HfaSyYz5Zd/yYJUskISJ8as1a+6cIJEkvLgGsFDd4IixW
         PIAMMRqlRuVILswf0N0+1astoiPP2qVCfi0rEcn+wjdrY+f9wxVmObepuUwashkD8WGh
         vH0qWk99Y1FOnOUyqLXlYUCyjCmh3sJDmu9N1CkLLKAGNZpyhWxgWCGr577me1AU56v1
         ntRIyWjBxv2AAZBvsGfYwrbS0QH95ukc56yASNSBv46K9CskzWBZLp+sPHzx2ECYuOkc
         njRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eoe1jm+S/J7sLO7uqwBuLWMAwNPuBQISVnb82FJ2SwI=;
        b=dN6ZSxCr+9e9an9DAA6kQgn/Al37PF1uNcQlSxL0zo8K02CCyeNCYST8c2VRNGifCv
         gmCc2Yw3b6sGxe0d+OvM+QNx/ei+Sc/IwOPAre6XbVgc3qyxclE53WW+Io1XTTb2/m6N
         W5P4EYD8pcE731vbiSjEUwF8s+omu3SjDuw8Sbrpr3m2KKf/WSNWFFqpBKRePmSJnr70
         gLalbFKkbjwafhGxOLkjSv5Uh7NyNCfsZ9F7oILMxvWW9/OQMCFsmyU0HKQ9WpbuyWUV
         qH0lo5Z87Izp4mm7ckJl5eXP7D7eQ49pcIXP6nBEQBupXDXCQXrcU01gRBuZQBxBO9La
         fKyg==
X-Gm-Message-State: APjAAAWSV1vEOfpq9rL7vvq+Z1DIVrn1h7Qs/bMX8Y4j9AM+TfsUDQix
        ZVieXVFW1N6j+8WyaKhNnd2YoN6mFKhQ5h3kuj8=
X-Google-Smtp-Source: APXvYqzkigecxyl5WV8qufxu2TDn1hxGJ2Q3WBCV4xcfrF2p55FLQ9pXXSPDot+9FA/1cgTyRyvo/nVl0D2F+C+DIWs=
X-Received: by 2002:a5d:4945:: with SMTP id r5mr1593258wrs.37.1571990552949;
 Fri, 25 Oct 2019 01:02:32 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1571033544.git.lucien.xin@gmail.com> <f4c99c3d918c0d82f5d5c60abd6abcf381292f1f.1571033544.git.lucien.xin@gmail.com>
 <20191025032337.GC4326@localhost.localdomain>
In-Reply-To: <20191025032337.GC4326@localhost.localdomain>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Fri, 25 Oct 2019 16:02:22 +0800
Message-ID: <CADvbK_f4zSD6e3JYEKRuFx2CnSqo+0HmnYC0iinyGM63aep7HQ@mail.gmail.com>
Subject: Re: [PATCHv3 net-next 2/5] sctp: add pf_expose per netns and sock and asoc
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Neil Horman <nhorman@tuxdriver.com>,
        davem <davem@davemloft.net>,
        David Laight <david.laight@aculab.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 25, 2019 at 11:23 AM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Mon, Oct 14, 2019 at 02:14:45PM +0800, Xin Long wrote:
> > As said in rfc7829, section 3, point 12:
> >
> >   The SCTP stack SHOULD expose the PF state of its destination
> >   addresses to the ULP as well as provide the means to notify the
> >   ULP of state transitions of its destination addresses from
> >   active to PF, and vice versa.  However, it is recommended that
> >   an SCTP stack implementing SCTP-PF also allows for the ULP to be
> >   kept ignorant of the PF state of its destinations and the
> >   associated state transitions, thus allowing for retention of the
> >   simpler state transition model of [RFC4960] in the ULP.
> >
> > Not only does it allow to expose the PF state to ULP, but also
> > allow to ignore sctp-pf to ULP.
> >
> > So this patch is to add pf_expose per netns, sock and asoc. And in
> > sctp_assoc_control_transport(), ulp_notify will be set to false if
> > asoc->expose is not set.
> >
> > It also allows a user to change pf_expose per netns by sysctl, and
> > pf_expose per sock and asoc will be initialized with it.
>
> I also do see value on this sysctl. We currently have an
> implementation that sits in between the states that the RFC defines
> and this allows the system to remain using the original Linux
> behavior, while also forcing especially the disabled state. This can
> help on porting applications to Linux.
Agreed.

>
> >
> > Note that pf_expose also works for SCTP_GET_PEER_ADDR_INFO sockopt,
> > to not allow a user to query the state of a sctp-pf peer address
> > when pf_expose is not enabled, as said in section 7.3.
> >
> > v1->v2:
> >   - Fix a build warning noticed by Nathan Chancellor.
> > v2->v3:
> >   - set pf_expose to UNUSED by default to keep compatible with old
> >     applications.
>
> Hmmm UNUSED can be quite confusing.
> What about "UNSET" instead? (though I'm not that happy with UNSET
> either, but couldn't come up with a better name)
> And make UNSET=0. (first on the enum)
>
> So we have it like:
> "If unset, the exposure is done as Linux used to do it, while setting
> it to 1 blocks it and 2, enables it, according to the RFC."
>
> Needs a new entry on Documentation/ip-sysctl.txt, btw. We have
> pf_enable in there.
will add it meanwhile. Thanks.

>
> ...
>
> > @@ -5521,8 +5522,16 @@ static int sctp_getsockopt_peer_addr_info(struct sock *sk, int len,
> >
> >       transport = sctp_addr_id2transport(sk, &pinfo.spinfo_address,
> >                                          pinfo.spinfo_assoc_id);
> > -     if (!transport)
> > -             return -EINVAL;
> > +     if (!transport) {
> > +             retval = -EINVAL;
> > +             goto out;
> > +     }
> > +
> > +     if (transport->state == SCTP_PF &&
> > +         transport->asoc->pf_expose == SCTP_PF_EXPOSE_DISABLE) {
> > +             retval = -EACCES;
> > +             goto out;
> > +     }
>
> As is on v3, this is NOT an UAPI violation. The user has to explicitly
> set the system or the socket into the disabled state in order to
> trigger this new check.
Agreed.

>
> >
> >       pinfo.spinfo_assoc_id = sctp_assoc2id(transport->asoc);
> >       pinfo.spinfo_state = transport->state;
> > diff --git a/net/sctp/sysctl.c b/net/sctp/sysctl.c
> > index 238cf17..5d1ad44 100644
> > --- a/net/sctp/sysctl.c
> > +++ b/net/sctp/sysctl.c
> > @@ -34,6 +34,7 @@ static int rto_alpha_min = 0;
> >  static int rto_beta_min = 0;
> >  static int rto_alpha_max = 1000;
> >  static int rto_beta_max = 1000;
> > +static int pf_expose_max = SCTP_PF_EXPOSE_MAX;
> >
> >  static unsigned long max_autoclose_min = 0;
> >  static unsigned long max_autoclose_max =
> > @@ -318,6 +319,15 @@ static struct ctl_table sctp_net_table[] = {
> >               .mode           = 0644,
> >               .proc_handler   = proc_dointvec,
> >       },
> > +     {
> > +             .procname       = "pf_expose",
> > +             .data           = &init_net.sctp.pf_expose,
> > +             .maxlen         = sizeof(int),
> > +             .mode           = 0644,
> > +             .proc_handler   = proc_dointvec_minmax,
> > +             .extra1         = SYSCTL_ZERO,
> > +             .extra2         = &pf_expose_max,
> > +     },
> >
> >       { /* sentinel */ }
> >  };
> > --
> > 2.1.0
> >
