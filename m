Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D185C114791
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 20:23:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729022AbfLETXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 14:23:02 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:57569 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726028AbfLETXB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 14:23:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575573779;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SOzzGPuJUDzUsHqgk0w4BCBqqM/WGLdmfkQdJ1mLHMY=;
        b=QfiDHPL1Fm739a8jIp7fLGCxiZyBTAGXdhKXYZDSznalRUytOw3ZUwS3qvBkWb6ORX1gcX
        SH9nsYsy/SqbitDAxv8STEQeABptZDfBX8Nn6ocopmKwSGreJsuJiy5XWDgE8XiTFkMtr5
        vG7sBYbxdhF4RlylttG7+LDkfm6GJY8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-118-g_oPo3J6PvqF1LDM8JyhKA-1; Thu, 05 Dec 2019 14:22:56 -0500
Received: by mail-wm1-f72.google.com with SMTP id o135so1193784wme.2
        for <netdev@vger.kernel.org>; Thu, 05 Dec 2019 11:22:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=A3fJQrpk/xbQG9NV+nsJ/wxZRw+7K6NEosDnojfaXw8=;
        b=TPNBCB1153MOEhXCgmgMdHYS8u/Hp+jLRuMHllZUACpZ366b3orpwuLllxWuYzgHar
         dHpCXQCTGTXO7hzuVCutXtrjqNGdii2wirQ3k7IWoRXA7yu8F0N3i+A1Slgqt0uatXvw
         RMGlXkymmeFNLedj9voaBHWQzzSXbzbsiuTOvcrKzIQVIlYZzWp/vWKKGo4zK9AKZtAj
         ijwBfYLsgj+h3CWzRKDNJqr1+CEGL39ogwFGDtCnwy/k0LiSaw8zs3U3Nk/rCe88XxUA
         V+Q+pIp6Ra7szdjz2tYCezT/YdPYIlRKKkxLDbe5IgnXl3MSxzguMBDX/73g+Jf4fihb
         xi+g==
X-Gm-Message-State: APjAAAUGQD6Z3mo2AvZE03bt14YdvMFfPthjePzq6/jjgZ1f0zDMIltB
        CZeERzqTc4NyYgivkF7pgOclN0ZfJLwT2uPe+UTK7keoRQOs2jNWFIaPuWitbJBnMLLtoJtsR8i
        LRE2RHPB9EDWt1bdS
X-Received: by 2002:a1c:c917:: with SMTP id f23mr6523549wmb.95.1575573774967;
        Thu, 05 Dec 2019 11:22:54 -0800 (PST)
X-Google-Smtp-Source: APXvYqy2JiiPFiATCJ9Yt5jYfD4LFXKaPo9ynbNq/XhttuTDkpSLg6fATSz/aCvS8ZhbRiL/F/ysHw==
X-Received: by 2002:a1c:c917:: with SMTP id f23mr6523536wmb.95.1575573774687;
        Thu, 05 Dec 2019 11:22:54 -0800 (PST)
Received: from linux.home (2a01cb0585290000c08fcfaf4969c46f.ipv6.abo.wanadoo.fr. [2a01:cb05:8529:0:c08f:cfaf:4969:c46f])
        by smtp.gmail.com with ESMTPSA id f1sm13657810wrp.93.2019.12.05.11.22.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Dec 2019 11:22:54 -0800 (PST)
Date:   Thu, 5 Dec 2019 20:22:52 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net v2 2/2] tcp: tighten acceptance of ACKs not matching
 a child socket
Message-ID: <20191205192252.GA18203@linux.home>
References: <cover.1575503545.git.gnault@redhat.com>
 <1d7e9bc77fb68706d955e4089a801ace0df5d771.1575503545.git.gnault@redhat.com>
 <80ffa7b6-bbaf-ce52-606f-d10e45644bcd@gmail.com>
 <20191205180019.GA16185@linux.home>
 <CANn89i+RHVmA2Mc8x0NdHZjWsw4UtgZ5ymbWBBxLgv_YczUjvg@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CANn89i+RHVmA2Mc8x0NdHZjWsw4UtgZ5ymbWBBxLgv_YczUjvg@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-MC-Unique: g_oPo3J6PvqF1LDM8JyhKA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 05, 2019 at 10:14:15AM -0800, Eric Dumazet wrote:
> On Thu, Dec 5, 2019 at 10:00 AM Guillaume Nault <gnault@redhat.com> wrote=
:
> >
> > On Wed, Dec 04, 2019 at 07:08:49PM -0800, Eric Dumazet wrote:
> > >
> > >
> > > On 12/4/19 4:59 PM, Guillaume Nault wrote:
> > > > When no synflood occurs, the synflood timestamp isn't updated.
> > > > Therefore it can be so old that time_after32() can consider it to b=
e
> > > > in the future.
> > > >
> > > > That's a problem for tcp_synq_no_recent_overflow() as it may report
> > > > that a recent overflow occurred while, in fact, it's just that jiff=
ies
> > > > has grown past 'last_overflow' + TCP_SYNCOOKIE_VALID + 2^31.
> > > >
> > > > Spurious detection of recent overflows lead to extra syncookie
> > > > verification in cookie_v[46]_check(). At that point, the verificati=
on
> > > > should fail and the packet dropped. But we should have dropped the
> > > > packet earlier as we didn't even send a syncookie.
> > > >
> > > > Let's refine tcp_synq_no_recent_overflow() to report a recent overf=
low
> > > > only if jiffies is within the
> > > > [last_overflow, last_overflow + TCP_SYNCOOKIE_VALID] interval. This
> > > > way, no spurious recent overflow is reported when jiffies wraps and
> > > > 'last_overflow' becomes in the future from the point of view of
> > > > time_after32().
> > > >
> > > > However, if jiffies wraps and enters the
> > > > [last_overflow, last_overflow + TCP_SYNCOOKIE_VALID] interval (with
> > > > 'last_overflow' being a stale synflood timestamp), then
> > > > tcp_synq_no_recent_overflow() still erroneously reports an
> > > > overflow. In such cases, we have to rely on syncookie verification
> > > > to drop the packet. We unfortunately have no way to differentiate
> > > > between a fresh and a stale syncookie timestamp.
> > > >
> > > > Signed-off-by: Guillaume Nault <gnault@redhat.com>
> > > > ---
> > > >  include/net/tcp.h | 6 ++++--
> > > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/include/net/tcp.h b/include/net/tcp.h
> > > > index f0eae83ee555..005d4c691543 100644
> > > > --- a/include/net/tcp.h
> > > > +++ b/include/net/tcp.h
> > > > @@ -520,12 +520,14 @@ static inline bool tcp_synq_no_recent_overflo=
w(const struct sock *sk)
> > > >             if (likely(reuse)) {
> > > >                     last_overflow =3D READ_ONCE(reuse->synq_overflo=
w_ts);
> > > >                     return time_after32(now, last_overflow +
> > > > -                                       TCP_SYNCOOKIE_VALID);
> > > > +                                       TCP_SYNCOOKIE_VALID) ||
> > > > +                           time_before32(now, last_overflow);
> > > >             }
> > > >     }
> > > >
> > > >     last_overflow =3D tcp_sk(sk)->rx_opt.ts_recent_stamp;
> > > > -   return time_after32(now, last_overflow + TCP_SYNCOOKIE_VALID);
> > > > +   return time_after32(now, last_overflow + TCP_SYNCOOKIE_VALID) |=
|
> > > > +           time_before32(now, last_overflow);
> > > >  }
> > >
> > >
> > > There is a race I believe here.
> > >
> > > CPU1                                 CPU2
> > >
> > > now =3D jiffies.
> > >     ...
> > >                                      jiffies++
> > >                                      ...
> > >                                      SYN received, last_overflow is u=
pdated to the new jiffies.
> > >
> > >
> > > CPU1
> > >  timer_before32(now, last_overflow) is true, because last_overflow wa=
s set to now+1
> > >
> > >
> > > I suggest some cushion here.
> > >
> > Yes, we should wrap access to ->rx_opt.ts_recent_stamp into READ_ONCE()=
,
> > to ensure that last_overflow won't be reloaded between the
> > time_after32() and the time_before32() calls. Is that what you had in
> > mind?
> >
> > -       last_overflow =3D tcp_sk(sk)->rx_opt.ts_recent_stamp;
> > +       last_overflow =3D READ_ONCE(tcp_sk(sk)->rx_opt.ts_recent_stamp)=
;
> >
> > Patch 1 would need the same fix BTW.
> >
> > > Also we TCP uses between() macro, we might add a time_between32(a, b,=
 c) macro
> > > to ease code review.
> > >
> > I didn't realise that. I'll define it in v3.
> >
> > > ->
> > >   return !time_between32(last_overflow - HZ, now, last_overflow + TCP=
_SYNCOOKIE_VALID);
> > >
> > 'last_overflow - HZ'? I don't get why we'd take HZ into account here.
> >
>=20
> Please read carefuly my prior feedback.
>=20
> Even with READ_ONCE(), you still have a race.
>=20
>=20
> CPU1                                 CPU2
>=20
> now =3D jiffies.
>  <some long interrupt>
>                                      jiffies++  (or jiffies +=3D 3 or 4
> if CPU1 has been interrupted by a long interrupt)
>                                      ...
>                                      SYN received, last_overflow is
> updated to the new jiffies.
>=20
>=20
> CPU1
>=20
>  @now still has a stale values (an old jiffies value)
>  timer_before32(now, last_overflow) is true, because last_overflow was
> set to now+1 (or now + 2 or now + 3)
>=20
Ok, I get it now. Thanks!
Will send v3 using 'last_overflow - HZ' as lower bound.

I think READ_ONCE()/WRITE_ONCE() are still necessary to prevent reloading
and imaginary write of last_overflow. At least that's my understanding
after reading memory-barriers.txt again.

