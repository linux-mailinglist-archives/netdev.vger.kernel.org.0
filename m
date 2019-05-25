Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD3612A697
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 20:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727441AbfEYSro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 May 2019 14:47:44 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44144 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726007AbfEYSro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 May 2019 14:47:44 -0400
Received: by mail-pf1-f196.google.com with SMTP id g9so7222403pfo.11
        for <netdev@vger.kernel.org>; Sat, 25 May 2019 11:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=appneta.com; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=YDOaRpq6cneaxNOt199jCWjQbuCNeTQ0/HDa1/buiiI=;
        b=IV1fxz+fdPOULLAy8vhVdakqb5/2dFHvC6XZr4vvrb/fa/UcOhSW0ZE6ZgES3r3DIK
         Y9GboccTSoyHrV/YF6d1am9zq1vo/eycJWEuXygGW8EA9jWEwHe2l4n7HUvyqXwtGMa8
         mc7z+XXI6xYBQ7bPJiYm6mRfJOcPcq9qiurmA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=YDOaRpq6cneaxNOt199jCWjQbuCNeTQ0/HDa1/buiiI=;
        b=r/YdYrMXgBPxIWVKPOI3mmYm5udRfNT0c1tz3FZNFXM1FABZ3QlO+rsFp0lkX1WreA
         p0W9MGDLtLtB/d2/MsAFqnyRpdCK1aQuuIhgq5Xnql0Ndei9jsBYLUwSQKw22ZTriIAy
         77eGdBkSHdDPRe3MoBhhn8RIAF3ec9Y7DM/Q9/rE+FVdWsRB6Yo8/YUm49GcQtDIO3LW
         35UzwnUZnZvko8T4KntsW9C4ThA0yBpXLE2I2WK2ZK0icale0eIGvmktwJdLSLNlBvSZ
         nVSrpRiyX+QUF/huXLrPt5vM0otdjV3BBlKsYEsh6tvXxpq6JREAqxHDHx+n+hvp7+C9
         5k7g==
X-Gm-Message-State: APjAAAU3pGQeQxdxOQ2+fhGu2JKNwneMMU/Px5/4AgK05+qtC/ESt1ED
        cE/hACWZTg1OkisVGB+ybdLduHmtPN1b+A==
X-Google-Smtp-Source: APXvYqyMLYOtBbRXBLKKejVKV0kG1+iyNGtisu5tqZGtwaDIV20GdsXNVUhoGhWi8kxRq/9P4UTeog==
X-Received: by 2002:aa7:9a99:: with SMTP id w25mr28840800pfi.249.1558810063530;
        Sat, 25 May 2019 11:47:43 -0700 (PDT)
Received: from [10.0.1.19] (S010620c9d00fc332.vf.shawcable.net. [70.71.167.160])
        by smtp.gmail.com with ESMTPSA id u123sm7337414pfu.67.2019.05.25.11.47.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 25 May 2019 11:47:42 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH net 1/4] net/udp_gso: Allow TX timestamp with UDP GSO
From:   Fred Klassen <fklassen@appneta.com>
In-Reply-To: <CA+FuTScNr9Srsn9QFBSj=oT4TnMh1QuOZ2h40g=joNjSwccqMg@mail.gmail.com>
Date:   Sat, 25 May 2019 11:47:41 -0700
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <4032C02B-EA43-4540-8283-8466CDD0B8D2@appneta.com>
References: <20190523210651.80902-1-fklassen@appneta.com>
 <20190523210651.80902-2-fklassen@appneta.com>
 <CAF=yD-Jf95De=z_nx9WFkGDa6+nRUqM_1PqGkjwaFPzOe+PfXg@mail.gmail.com>
 <AE8E0772-7256-4B9C-A990-96930E834AEE@appneta.com>
 <CAF=yD-LtAKpND601LQrC1+=iF6spSUXVdUapcsbJdv5FYa=5Jg@mail.gmail.com>
 <AFC1ECC8-BFAC-4718-B0C9-97CC4BD1F397@appneta.com>
 <CAF=yD-Le-eTadOi7PL8WFEQCG=yLqb5gvKiks+s5Akeq8TenBQ@mail.gmail.com>
 <90E3853F-107D-45BA-93DC-D0BE8AC6FCBB@appneta.com>
 <CA+FuTScNr9Srsn9QFBSj=oT4TnMh1QuOZ2h40g=joNjSwccqMg@mail.gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On May 25, 2019, at 8:20 AM, Willem de Bruijn =
<willemdebruijn.kernel@gmail.com> wrote:
>=20
> On Fri, May 24, 2019 at 6:01 PM Fred Klassen <fklassen@appneta.com> =
wrote:
>>=20
>>=20
>>=20
>>> On May 24, 2019, at 12:29 PM, Willem de Bruijn =
<willemdebruijn.kernel@gmail.com> wrote:
>>>=20
>>> It is the last moment that a timestamp can be generated for the last
>>> byte, I don't see how that is "neither the start nor the end of a =
GSO
>>> packet=E2=80=9D.
>>=20
>> My misunderstanding. I thought TCP did last segment timestamping, not
>> last byte. In that case, your statements make sense.
>>=20
>>>> It would be interesting if a practical case can be made for =
timestamping
>>>> the last segment. In my mind, I don=E2=80=99t see how that would be =
valuable.
>>>=20
>>> It depends whether you are interested in measuring network latency =
or
>>> host transmit path latency.
>>>=20
>>> For the latter, knowing the time from the start of the sendmsg call =
to
>>> the moment the last byte hits the wire is most relevant. Or in =
absence
>>> of (well defined) hardware support, the last byte being queued to =
the
>>> device is the next best thing.
>=20
> Sounds to me like both cases have a legitimate use case, and we want
> to support both.
>=20
> Implementation constraints are that storage for this timestamp
> information is scarce and we cannot add new cold cacheline accesses in
> the datapath.
>=20
> The simplest approach would be to unconditionally timestamp both the
> first and last segment. With the same ID. Not terribly elegant. But it
> works.
>=20
> If conditional, tx_flags has only one bit left. I think we can harvest
> some, as not all defined bits are in use at the same stages in the
> datapath, but that is not a trivial change. Some might also better be
> set in the skb, instead of skb_shinfo. Which would also avoids
> touching that cacheline. We could possibly repurpose bits from u32
> tskey.
>=20
> All that can come later. Initially, unless we can come up with
> something more elegant, I would suggest that UDP follows the rule
> established by TCP and timestamps the last byte. And we add an
> explicit SOF_TIMESTAMPING_OPT_FIRSTBYTE that is initially only
> supported for UDP, sets a new SKBTX_TX_FB_TSTAMP bit in
> __sock_tx_timestamp and is interpreted in __udp_gso_segment.
>=20

I don=E2=80=99t see how to practically TX timestamp the last byte of any =
packet
(UDP GSO or otherwise). The best we could do is timestamp the last
segment,  or rather the time that the last segment is queued. Let me
attempt to explain.

First let=E2=80=99s look at software TX timestamps which are for are =
generated
by skb_tx_timestamp() in nearly every network driver=E2=80=99s xmit =
routine. It
states:

=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=
=80=94=E2=80=94 cut =E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=
=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94
 * Ethernet MAC Drivers should call this function in their hard_xmit()
 * function immediately before giving the sk_buff to the MAC hardware.
=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=
=80=94=E2=80=94 cut =E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=
=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94

That means that the sk_buff will get timestamped just before rather
than just after it is sent. To truly capture the timestamp of the last
byte, this routine routine would have to be called a second time, right
after sending to MAC hardware. Then the user program would have
sort out the 2 timestamps. My guess is that this isn=E2=80=99t something =
that
NIC vendors would be willing to implement in their drivers.

So, the best we can do is timestamp is just before the last segment.
Suppose UDP GSO sends 3000 bytes to a 1500 byte MTU adapter.
If we set SKBTX_HW_TSTAMP flag on the last segment, the timestamp
occurs half way through the burst. But it may not be exactly half way
because the segments may get queued much faster than wire rate.
Therefore the time between segment 1 and segment 2 may be much
much smaller than their spacing on the wire. I would not find this
useful.

I propose that we stick with the method used for IP fragments, which
is timestamping just before the first byte is sent. Put another way, I=20=

propose that we start the clock in an automobile race just before the
front of the first car crosses the start line rather than when the front
of the last car crosses the start line.

TX timestamping in hardware has even more limitations. For the most
part, we can only do one timestamp per packet or burst.  If we requested
a timestamp of only the last segment of a packet, we would have work
backwards to calculate the start time of the packet, but that would
only be be a best guess. For extremely time sensitive applications
(such as the one we develop), this would not be practical.

We could still consider setting a flag that would allow the timestamping
the last segment rather than the first. However since we cannot=20
truly measure the timestamp of the last byte, I would question the value
in doing so.

