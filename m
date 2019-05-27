Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 200722ACED
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 04:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbfE0CJn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 May 2019 22:09:43 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:40884 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725923AbfE0CJn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 May 2019 22:09:43 -0400
Received: by mail-ed1-f68.google.com with SMTP id j12so24284893eds.7;
        Sun, 26 May 2019 19:09:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=q4HXWJmocoqEFtedlcYgjjxcr1QIQlFzfUFPmoOlTHU=;
        b=rh+GDAHK6pQFGGZrQW3bod/cUf5xtBHMN+oj7xv1Q2VansilSKTdHS79XLtPNeCQXo
         Ds1E6ccW/srRA3BdoV8jN0+xGUD5AJ5qjjmi7lB6GX/E9ju+t7/bj0yWqn8Rabd9QAz/
         E9w1FcPvzGr/sHE2w32mxIOlEgeY8Ia41gMGjBnL08puPizsl3rIaEYEYhIIKpZJqH0Q
         21O1phfatUNJ6nYNtQiv0Fq1RGzjI3ajUkh9T2PGQT+2GhlVasPY/kQntYtpB9Ml2BeQ
         /kfwn+hCEbYAnGw+HC9dwfsgSMNq667E25epsdzCZOXsXFVV+j0FbECmo4JV4TbZp4qA
         E+9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=q4HXWJmocoqEFtedlcYgjjxcr1QIQlFzfUFPmoOlTHU=;
        b=tVk4j9A1o9F+vaF9IDIAoATgFuQI7VByzVMeNmBJzTJ3rgbQtY0LI5Ymjc5rMGC9PA
         Tdo/x+xHk41j2AU8tlHJva2wIH/mG+oG7U6ihD7oMI6B7PgjF7cfaNG17xMBadTxVc3i
         yVGGirC/5kbDUwymOglHz/Kejfljw5+z14QUUrn5GlYmMfUAjKDImgiCwx6772+4sfWO
         fuZohEUrRfJkdnEf4OmD+3SpidbluGhxxmyUWhwKgdwCvi7uVOMrGBFrSoTHgvrYz3eF
         p/hPn3Bg394Az6rN3gb5YWn9p37BiRPYgm71yNacOdRzzgQ1CrmJ83t1RmbACHxUqVmT
         Zvcw==
X-Gm-Message-State: APjAAAXq1fnf6IrbvSnbQpINRHl0Pe4cveMV6yTDyxGYwMG+8+MqYqFQ
        F77GXH5awcgNnsOymVbMnKCRsXChIqbEaFlQx94=
X-Google-Smtp-Source: APXvYqz6NpK9v0jnj25FgAEd4xIKWArx0VCRzCH5JRTsYSZsbiJHVBNaK7Hq2t2Kjk0mqbclRpKlEFNL+Vwvdy7sX2U=
X-Received: by 2002:a17:906:aacb:: with SMTP id kt11mr80812082ejb.246.1558922980858;
 Sun, 26 May 2019 19:09:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190523210651.80902-1-fklassen@appneta.com> <20190523210651.80902-2-fklassen@appneta.com>
 <CAF=yD-Jf95De=z_nx9WFkGDa6+nRUqM_1PqGkjwaFPzOe+PfXg@mail.gmail.com>
 <AE8E0772-7256-4B9C-A990-96930E834AEE@appneta.com> <CAF=yD-LtAKpND601LQrC1+=iF6spSUXVdUapcsbJdv5FYa=5Jg@mail.gmail.com>
 <AFC1ECC8-BFAC-4718-B0C9-97CC4BD1F397@appneta.com> <CAF=yD-Le-eTadOi7PL8WFEQCG=yLqb5gvKiks+s5Akeq8TenBQ@mail.gmail.com>
 <90E3853F-107D-45BA-93DC-D0BE8AC6FCBB@appneta.com> <CA+FuTScNr9Srsn9QFBSj=oT4TnMh1QuOZ2h40g=joNjSwccqMg@mail.gmail.com>
 <4032C02B-EA43-4540-8283-8466CDD0B8D2@appneta.com> <CAF=yD-KTJGYY-yf=+zwa8SyrCNAfZjqjomJ=B=yFcs+juDeShA@mail.gmail.com>
In-Reply-To: <CAF=yD-KTJGYY-yf=+zwa8SyrCNAfZjqjomJ=B=yFcs+juDeShA@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 26 May 2019 21:09:03 -0500
Message-ID: <CAF=yD-+h2qJP0M5XQrcFVfyn3TP7Jd0UJ1zFf0kbUeC9uKKNxQ@mail.gmail.com>
Subject: Re: [PATCH net 1/4] net/udp_gso: Allow TX timestamp with UDP GSO
To:     Fred Klassen <fklassen@appneta.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 26, 2019 at 8:30 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Sat, May 25, 2019 at 1:47 PM Fred Klassen <fklassen@appneta.com> wrote=
:
> >
> >
> >
> > > On May 25, 2019, at 8:20 AM, Willem de Bruijn <willemdebruijn.kernel@=
gmail.com> wrote:
> > >
> > > On Fri, May 24, 2019 at 6:01 PM Fred Klassen <fklassen@appneta.com> w=
rote:
> > >>
> > >>
> > >>
> > >>> On May 24, 2019, at 12:29 PM, Willem de Bruijn <willemdebruijn.kern=
el@gmail.com> wrote:
> > >>>
> > >>> It is the last moment that a timestamp can be generated for the las=
t
> > >>> byte, I don't see how that is "neither the start nor the end of a G=
SO
> > >>> packet=E2=80=9D.
> > >>
> > >> My misunderstanding. I thought TCP did last segment timestamping, no=
t
> > >> last byte. In that case, your statements make sense.
> > >>
> > >>>> It would be interesting if a practical case can be made for timest=
amping
> > >>>> the last segment. In my mind, I don=E2=80=99t see how that would b=
e valuable.
> > >>>
> > >>> It depends whether you are interested in measuring network latency =
or
> > >>> host transmit path latency.
> > >>>
> > >>> For the latter, knowing the time from the start of the sendmsg call=
 to
> > >>> the moment the last byte hits the wire is most relevant. Or in abse=
nce
> > >>> of (well defined) hardware support, the last byte being queued to t=
he
> > >>> device is the next best thing.
> > >
> > > Sounds to me like both cases have a legitimate use case, and we want
> > > to support both.
> > >
> > > Implementation constraints are that storage for this timestamp
> > > information is scarce and we cannot add new cold cacheline accesses i=
n
> > > the datapath.
> > >
> > > The simplest approach would be to unconditionally timestamp both the
> > > first and last segment. With the same ID. Not terribly elegant. But i=
t
> > > works.
> > >
> > > If conditional, tx_flags has only one bit left. I think we can harves=
t
> > > some, as not all defined bits are in use at the same stages in the
> > > datapath, but that is not a trivial change. Some might also better be
> > > set in the skb, instead of skb_shinfo. Which would also avoids
> > > touching that cacheline. We could possibly repurpose bits from u32
> > > tskey.
> > >
> > > All that can come later. Initially, unless we can come up with
> > > something more elegant, I would suggest that UDP follows the rule
> > > established by TCP and timestamps the last byte. And we add an
> > > explicit SOF_TIMESTAMPING_OPT_FIRSTBYTE that is initially only
> > > supported for UDP, sets a new SKBTX_TX_FB_TSTAMP bit in
> > > __sock_tx_timestamp and is interpreted in __udp_gso_segment.
> > >
> >
> > I don=E2=80=99t see how to practically TX timestamp the last byte of an=
y packet
> > (UDP GSO or otherwise). The best we could do is timestamp the last
> > segment,  or rather the time that the last segment is queued. Let me
> > attempt to explain.
> >
> > First let=E2=80=99s look at software TX timestamps which are for are ge=
nerated
> > by skb_tx_timestamp() in nearly every network driver=E2=80=99s xmit rou=
tine. It
> > states:
> >
> > =E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=
=94=E2=80=94=E2=80=94 cut =E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=
=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94
> >  * Ethernet MAC Drivers should call this function in their hard_xmit()
> >  * function immediately before giving the sk_buff to the MAC hardware.
> > =E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=
=94=E2=80=94=E2=80=94 cut =E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=
=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94
> >
> > That means that the sk_buff will get timestamped just before rather
> > than just after it is sent. To truly capture the timestamp of the last
> > byte, this routine routine would have to be called a second time, right
> > after sending to MAC hardware. Then the user program would have
> > sort out the 2 timestamps. My guess is that this isn=E2=80=99t somethin=
g that
> > NIC vendors would be willing to implement in their drivers.
> >
> > So, the best we can do is timestamp is just before the last segment.
> > Suppose UDP GSO sends 3000 bytes to a 1500 byte MTU adapter.
> > If we set SKBTX_HW_TSTAMP flag on the last segment, the timestamp
> > occurs half way through the burst. But it may not be exactly half way
> > because the segments may get queued much faster than wire rate.
> > Therefore the time between segment 1 and segment 2 may be much
> > much smaller than their spacing on the wire. I would not find this
> > useful.
>
> For measuring host queueing latency, a timestamp at the existing
> skb_tx_timestamp() for the last segment is perfectly informative.

In most cases all segments will be sent in a single xmit_more train.
In which case the device doorbell is rung when the last segment is
queued.

A device may also pause in the middle of a train, causing the rest of
the list to be requeued and resent after a tx completion frees up
descriptors and wakes the device. This seems like a relevant exception
to be able to measure.

That said, I am not opposed to the first segment, if we have to make a
binary choice for a default. Either option has cons. See more specific
revision requests in the v2 patch.
