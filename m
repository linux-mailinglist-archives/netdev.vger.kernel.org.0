Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6E312A0D8
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 00:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404368AbfEXWB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 18:01:27 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:35364 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404315AbfEXWB0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 18:01:26 -0400
Received: by mail-pg1-f193.google.com with SMTP id t1so5748837pgc.2
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 15:01:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=appneta.com; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Nt1Bto+RuKAe8F0XKPOQ+MhI4MGCp3IBcqE1bNWm624=;
        b=CP3pG9ifqRjFBc0YzSgRZhosVC3X/Gn1RGmFGqOzuMcKIczmIs/OCyyjYxWltNsfFk
         4mycd8lZIITJoEB+fcpjf8FT1kv+xkBDmO6lK+fhB4wuUjsW2BKF02fS2SVSabb57vwh
         ANBUCNIjYnb5tPURfcu15IQNfhbH/7OJVk0es=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Nt1Bto+RuKAe8F0XKPOQ+MhI4MGCp3IBcqE1bNWm624=;
        b=umRemHeivW6xI3mT6VSmvoOrK36xVfZQV3n86+uCaACONtc3Qb/XIxIiY9udfaENsZ
         sqCxi4Vjq5kHmi9CTVAuSQ73fbXK3nAGRfwBsUIk5OcAyG1zmdy9n6J1NqZzf74e0fYT
         7Eh8EYWkL2MdrKrPCrDuMTlGkKxKJkOk5XUck+IUNAOTl4j0KIGxvfMgeRBjn43iDMC4
         AuIf6NG11X1YCKyErnv3mR2K4PVxtqVzs8lWOdHZHd3PkWPGYIe9GxuVFlyS+2vB6D40
         ss14u7KVEUCNRHfsXx5X+sOFhEr3Kcev2DVC3ukgsX+pR3M4wj3kG6z+28zOr6toW8yF
         jJmw==
X-Gm-Message-State: APjAAAU6yLExKYqGw0emuJTTWEwOSIy3l0Mw69KN06xBfH38fIdcZuWW
        /P6dHD/xY19cuvzM/nYrkBchzw==
X-Google-Smtp-Source: APXvYqx1AU7WlE+4JCn2Y/DvThwLZLnoOhh2EBVLKjNWpqmzprHergerEz/Wt2MlbcL6sAcU78Bqng==
X-Received: by 2002:a17:90a:216d:: with SMTP id a100mr12026144pje.6.1558735285565;
        Fri, 24 May 2019 15:01:25 -0700 (PDT)
Received: from jltm109.jaalam.net (vancouver-a.appneta.com. [209.139.228.33])
        by smtp.gmail.com with ESMTPSA id e123sm3645702pgc.29.2019.05.24.15.01.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 May 2019 15:01:24 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.8\))
Subject: Re: [PATCH net 1/4] net/udp_gso: Allow TX timestamp with UDP GSO
From:   Fred Klassen <fklassen@appneta.com>
In-Reply-To: <CAF=yD-Le-eTadOi7PL8WFEQCG=yLqb5gvKiks+s5Akeq8TenBQ@mail.gmail.com>
Date:   Fri, 24 May 2019 15:01:24 -0700
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <90E3853F-107D-45BA-93DC-D0BE8AC6FCBB@appneta.com>
References: <20190523210651.80902-1-fklassen@appneta.com>
 <20190523210651.80902-2-fklassen@appneta.com>
 <CAF=yD-Jf95De=z_nx9WFkGDa6+nRUqM_1PqGkjwaFPzOe+PfXg@mail.gmail.com>
 <AE8E0772-7256-4B9C-A990-96930E834AEE@appneta.com>
 <CAF=yD-LtAKpND601LQrC1+=iF6spSUXVdUapcsbJdv5FYa=5Jg@mail.gmail.com>
 <AFC1ECC8-BFAC-4718-B0C9-97CC4BD1F397@appneta.com>
 <CAF=yD-Le-eTadOi7PL8WFEQCG=yLqb5gvKiks+s5Akeq8TenBQ@mail.gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
X-Mailer: Apple Mail (2.3445.104.8)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On May 24, 2019, at 12:29 PM, Willem de Bruijn =
<willemdebruijn.kernel@gmail.com> wrote:
>=20
> It is the last moment that a timestamp can be generated for the last
> byte, I don't see how that is "neither the start nor the end of a GSO
> packet=E2=80=9D.

My misunderstanding. I thought TCP did last segment timestamping, not
last byte. In that case, your statements make sense.

>> It would be interesting if a practical case can be made for =
timestamping
>> the last segment. In my mind, I don=E2=80=99t see how that would be =
valuable.
>=20
> It depends whether you are interested in measuring network latency or
> host transmit path latency.
>=20
> For the latter, knowing the time from the start of the sendmsg call to
> the moment the last byte hits the wire is most relevant. Or in absence
> of (well defined) hardware support, the last byte being queued to the
> device is the next best thing.
>=20
> It would make sense for this software implementation to follow
> established hardware behavior. But as far as I know, the exact time a
> hardware timestamp is taken is not consistent across devices, either.
>=20
> For fine grained timestamped data, perhaps GSO is simply not a good
> mechanism. That said, it still has to queue a timestamp if requested.

I see your point. Makes sense to me.

>> When using hardware timestamping, I think you will find that nearly =
all
>> adapters only allow one timestamp at a time. Therefore only one
>> packet in a burst would get timestamped.
>=20
> Can you elaborate? When the host queues N packets all with hardware
> timestamps requested, all N completions will have a timestamp? Or is
> that not guaranteed?
>=20

It is not guaranteed. The best example is in ixgbe_main.c and search for
=E2=80=98SKBTX_HW_TSTAMP=E2=80=99.  If there is a PTP TX timestamp in =
progress,
=E2=80=98__IXGBE_PTP_TX_IN_PROGRESS=E2=80=99 is set and no other =
timestamps
are possible. The flag is cleared after transmit softirq, and only then
can another TX timestamp be taken. =20

>> There are exceptions, for
>> example I am playing with a 100G Mellanox adapter that has
>> per-packet TX timestamping. However, I suspect that when I am
>> done testing, all I will see is timestamps that are representing wire
>> rate (e.g. 123nsec per 1500 byte packet).
>>=20
>> Beyond testing the accuracy of a NIC=E2=80=99s timestamping =
capabilities, I
>> see very little value in doing per-segment timestamping.
>=20
> Ack. Great detailed argument, thanks.

Thanks. I=E2=80=99m a timestamping nerd and have learned lots with this=20=

discussion.

