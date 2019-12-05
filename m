Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5CC11466E
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 19:00:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729653AbfLESA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 13:00:28 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:36479 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729535AbfLESA1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 13:00:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575568826;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PsMUrcptgLZllFQYKcHN+FaEzooPDAcjVlRorH9lUhQ=;
        b=TtwAbQoGYFRljqkuGDF3EcYO33zY1FImHqE2SR6kIG6Q1sv8bmrFUp2hRwhqexpRGzN/g8
        P7+CC6GHDt7tvhmr1ZypUCAJnO+hjJkjIzh1qVbZZ6wP/Zor81P1bC5LSiaJ2vD2SQLMsn
        LfVVV2PaPIy2hnosEr5geon7TffgYgo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-315-_yVnHIXcMyuy1n1XdCjcWg-1; Thu, 05 Dec 2019 13:00:23 -0500
Received: by mail-wm1-f70.google.com with SMTP id g78so1133090wme.8
        for <netdev@vger.kernel.org>; Thu, 05 Dec 2019 10:00:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=r/YUsBVgc9cTHWdAb68ZXvg30spF9/80ribAVDF7YF0=;
        b=mVGaCaWnbSfQ9NZDfSvw6o3+P2EfuFWunsBJ5p6iD3Bf8INnz3+YRL1eJGgHdb74CU
         kh+VuBNFXCCpOojcgzbT5+fU2MNCP6F9X35RfrZo0Jq05NV8AGfKMMIClBh4LfNTHdmF
         5TxiHWKcyFmmwHpBJQp8pPX3DW8qaQd8bHJR6qxZuknyG7CO+6BrLes4dT4Rl2jQPSUk
         QljxuU9M/2Q5oRI6z50E+dbtunQDEPlReTKP2ywPEW4vhDkMSmyxxIo8tK8Blpoh74zu
         eHuoQNOSls/Wuw6GU7+9fZnTxEI7SM61HnaNQcO6rJUgHYyQp7b4fEYsgQHLwqmse/wd
         VZLw==
X-Gm-Message-State: APjAAAXEuxAyJRoAwdDBBIuR7qj2CIBdycC/MasNe6VB2B/ViTf3Sk4q
        CKmUoSBelYDVZqdRbR5YMRjxEdMDslngLEPkccLlF860RcVl8pinU37A1QHm0LSEUMjQFpO8dw/
        4h0Gi9S/ugOfNWb4X
X-Received: by 2002:adf:eb0a:: with SMTP id s10mr12180393wrn.320.1575568822204;
        Thu, 05 Dec 2019 10:00:22 -0800 (PST)
X-Google-Smtp-Source: APXvYqy7IBJPqSRoJy/msZyi4Mgq3Yp4QKJWqY2xrXBkr54zadKWB7zszumMsW3653qs4iGBQ9GoPw==
X-Received: by 2002:adf:eb0a:: with SMTP id s10mr12180376wrn.320.1575568821972;
        Thu, 05 Dec 2019 10:00:21 -0800 (PST)
Received: from linux.home (2a01cb0585290000c08fcfaf4969c46f.ipv6.abo.wanadoo.fr. [2a01:cb05:8529:0:c08f:cfaf:4969:c46f])
        by smtp.gmail.com with ESMTPSA id t78sm130077wmt.24.2019.12.05.10.00.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Dec 2019 10:00:21 -0800 (PST)
Date:   Thu, 5 Dec 2019 19:00:19 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net v2 2/2] tcp: tighten acceptance of ACKs not matching
 a child socket
Message-ID: <20191205180019.GA16185@linux.home>
References: <cover.1575503545.git.gnault@redhat.com>
 <1d7e9bc77fb68706d955e4089a801ace0df5d771.1575503545.git.gnault@redhat.com>
 <80ffa7b6-bbaf-ce52-606f-d10e45644bcd@gmail.com>
MIME-Version: 1.0
In-Reply-To: <80ffa7b6-bbaf-ce52-606f-d10e45644bcd@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-MC-Unique: _yVnHIXcMyuy1n1XdCjcWg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 04, 2019 at 07:08:49PM -0800, Eric Dumazet wrote:
>=20
>=20
> On 12/4/19 4:59 PM, Guillaume Nault wrote:
> > When no synflood occurs, the synflood timestamp isn't updated.
> > Therefore it can be so old that time_after32() can consider it to be
> > in the future.
> >=20
> > That's a problem for tcp_synq_no_recent_overflow() as it may report
> > that a recent overflow occurred while, in fact, it's just that jiffies
> > has grown past 'last_overflow' + TCP_SYNCOOKIE_VALID + 2^31.
> >=20
> > Spurious detection of recent overflows lead to extra syncookie
> > verification in cookie_v[46]_check(). At that point, the verification
> > should fail and the packet dropped. But we should have dropped the
> > packet earlier as we didn't even send a syncookie.
> >=20
> > Let's refine tcp_synq_no_recent_overflow() to report a recent overflow
> > only if jiffies is within the
> > [last_overflow, last_overflow + TCP_SYNCOOKIE_VALID] interval. This
> > way, no spurious recent overflow is reported when jiffies wraps and
> > 'last_overflow' becomes in the future from the point of view of
> > time_after32().
> >=20
> > However, if jiffies wraps and enters the
> > [last_overflow, last_overflow + TCP_SYNCOOKIE_VALID] interval (with
> > 'last_overflow' being a stale synflood timestamp), then
> > tcp_synq_no_recent_overflow() still erroneously reports an
> > overflow. In such cases, we have to rely on syncookie verification
> > to drop the packet. We unfortunately have no way to differentiate
> > between a fresh and a stale syncookie timestamp.
> >=20
> > Signed-off-by: Guillaume Nault <gnault@redhat.com>
> > ---
> >  include/net/tcp.h | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/include/net/tcp.h b/include/net/tcp.h
> > index f0eae83ee555..005d4c691543 100644
> > --- a/include/net/tcp.h
> > +++ b/include/net/tcp.h
> > @@ -520,12 +520,14 @@ static inline bool tcp_synq_no_recent_overflow(co=
nst struct sock *sk)
> >  =09=09if (likely(reuse)) {
> >  =09=09=09last_overflow =3D READ_ONCE(reuse->synq_overflow_ts);
> >  =09=09=09return time_after32(now, last_overflow +
> > -=09=09=09=09=09    TCP_SYNCOOKIE_VALID);
> > +=09=09=09=09=09    TCP_SYNCOOKIE_VALID) ||
> > +=09=09=09=09time_before32(now, last_overflow);
> >  =09=09}
> >  =09}
> > =20
> >  =09last_overflow =3D tcp_sk(sk)->rx_opt.ts_recent_stamp;
> > -=09return time_after32(now, last_overflow + TCP_SYNCOOKIE_VALID);
> > +=09return time_after32(now, last_overflow + TCP_SYNCOOKIE_VALID) ||
> > +=09=09time_before32(now, last_overflow);
> >  }
>=20
>=20
> There is a race I believe here.
>=20
> CPU1                                 CPU2
> =20
> now =3D jiffies.
>     ...
>                                      jiffies++
>                                      ...
>                                      SYN received, last_overflow is updat=
ed to the new jiffies.
>=20
>=20
> CPU1=20
>  timer_before32(now, last_overflow) is true, because last_overflow was se=
t to now+1
>=20
>=20
> I suggest some cushion here.
>=20
Yes, we should wrap access to ->rx_opt.ts_recent_stamp into READ_ONCE(),
to ensure that last_overflow won't be reloaded between the
time_after32() and the time_before32() calls. Is that what you had in
mind?

-=09last_overflow =3D tcp_sk(sk)->rx_opt.ts_recent_stamp;
+=09last_overflow =3D READ_ONCE(tcp_sk(sk)->rx_opt.ts_recent_stamp);

Patch 1 would need the same fix BTW.

> Also we TCP uses between() macro, we might add a time_between32(a, b, c) =
macro
> to ease code review.
>=20
I didn't realise that. I'll define it in v3.

> ->
>   return !time_between32(last_overflow - HZ, now, last_overflow + TCP_SYN=
COOKIE_VALID);
>=20
'last_overflow - HZ'? I don't get why we'd take HZ into account here.

