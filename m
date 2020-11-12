Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7734A2B047F
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 12:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728237AbgKLL44 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 06:56:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728133AbgKLL4a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 06:56:30 -0500
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 832D1C0613D1
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 03:56:30 -0800 (PST)
Received: by mail-oi1-x235.google.com with SMTP id j7so6034030oie.12
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 03:56:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JikW0E5lsRJnPRCsvgYXL1s+KxjycXqTazSA0QQ+9oQ=;
        b=FeORLFZdVnwaMpyIX7ud700vpygjsOYGndEO/RTMBFOqmcs+MJQk3VJMmaeQHDcteM
         Y3JoLXTBeC7a4pYG995vqvPWwmDTL20DySNmTnoqn2kysdeUmIAcvsKGnLnK0G6IQ33M
         T+p1QzaPKz+SMOmW8nipZ1zzt2TmdPG+ekoucooq+9EWTVU8CUqOBejwSowx/0NiT2jI
         nFCRja4aCPruueRiZ0jPplR7tPc+/FpHKWRWbx3D2A+N1FjjBEV6/BeNTKJTS+Zg8hKd
         yrPYSEoIyvoh/rZEYHMIihU0OSw3BffqC6rlBBJI3yoTp7FPjh8e1n+TU2HQBRrXnUC+
         y8Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JikW0E5lsRJnPRCsvgYXL1s+KxjycXqTazSA0QQ+9oQ=;
        b=bN9/RdGEVtWagarkBPmpxFBx201RWnYJeA5ud4ARECxHOuPOicqDaWivk6I0+Hyjon
         Pz6ZF6NZg+vNAIqQ2KeWn7nXMsI0p6a1i/UcnJ9RwGp+7DY67B/rduLmGzukvyEtZf2u
         eDLGJYRCudcoTjHyaOWDMmGrF7i2xefWkAFrOcPxLgtpQcq6TVe5cJqquFdl+dCYr/2L
         ATc996TCVJbyiX7fqVVegJxjvPmLVA9STgin4IorJa1icZhNChRHudrj0W4kokoP1IEi
         EZX8aB9xCmlJcVpwhi5is7XMiLRA0qLs3p4ldsB0vxOB/NmWoJUb11hCWlwSO6hsIOFc
         byMA==
X-Gm-Message-State: AOAM531n7GGsxCqa3OV6QU/C+MWS23U0VM7AZoIkgNbKmhyvCWvmSRdH
        KEstiZXL9BIKwqNZwkLaCyXddZUOk+PvopsHa2CpduI6oOYPNA==
X-Google-Smtp-Source: ABdhPJysIIED2j7ppNbxEl386HWpmLC+4FZ76TaaesA5L4Y/Ul7BQphXalX0mB00yhBsGjnYkn+cbTfWvNjw/cG2uQ4=
X-Received: by 2002:aca:bc03:: with SMTP id m3mr5332044oif.35.1605182189862;
 Thu, 12 Nov 2020 03:56:29 -0800 (PST)
MIME-Version: 1.0
References: <CAMeyCbh8vSCnr-9-odi0kg3E8BGCiETOL-jJ650qYQdsY0wxeA@mail.gmail.com>
 <CAMeyCbjuj2Q2riK2yzKXRfCa_mKToqe0uPXKxrjd6zJQWaXxog@mail.gmail.com>
 <CAOMZO5CYVDmCh-qxeKw0eOW6docQYxhZ5WA6ruxjcP+aYR6=LA@mail.gmail.com>
 <CAMeyCbhFfdONLEDYtqHxVZ59kBsH6vEaDBsvc5dWRinNY7RSgA@mail.gmail.com>
 <ba3b594f-bfdb-c8d6-ea1e-508040cf0414@gmail.com> <a3caa320811d4399808b6185dff79534@AcuMS.aculab.com>
In-Reply-To: <a3caa320811d4399808b6185dff79534@AcuMS.aculab.com>
From:   Kegl Rohit <keglrohit@gmail.com>
Date:   Thu, 12 Nov 2020 12:56:20 +0100
Message-ID: <CAMeyCbhG7-dCr4bVWP=kNuwLa6CNB9h=SwN_kK7VbJ7YFCY2Ow@mail.gmail.com>
Subject: Re: net: fec: rx descriptor ring out of order
To:     David Laight <David.Laight@aculab.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Fabio Estevam <festevam@gmail.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 12, 2020 at 12:10 PM David Laight <David.Laight@aculab.com> wro=
te:
>
> From: Eric Dumazet
> > Sent: 12 November 2020 10:42
> >
> > On 11/12/20 7:52 AM, Kegl Rohit wrote:
> > > On Wed, Nov 11, 2020 at 11:18 PM Fabio Estevam <festevam@gmail.com> w=
rote:
> > >>
> > >> On Wed, Nov 11, 2020 at 11:27 AM Kegl Rohit <keglrohit@gmail.com> wr=
ote:
> > >>>
> > >>> Hello!
> > >>>
> > >>> We are using a imx6q platform.
> > >>> The fec interface is used to receive a continuous stream of custom =
/
> > >>> raw ethernet packets. The packet size is fixed ~132 bytes and they =
get
> > >>> sent every 250=C2=B5s.
> > >>>
> > >>> While testing I observed spontaneous packet delays from time to tim=
e.
> > >>> After digging down deeper I think that the fec peripheral does not
> > >>> update the rx descriptor status correctly.
> > >>
> > >> What is the kernel version that you are using?
> > >
> > > Sadly stuck at 3.10.108.
>
> If you build a newer kernel it should work with your
> existing userspace.
Not so easily possible because there are custom drivers and some
kernel modifications in the mix.
I have a dirty ported system with a 5.4 kernel ready. I will also try it th=
ere.
But I am afraid the error will not happen but still exist.


> > > https://github.com/gregkh/linux/blob/v3.10.108/drivers/net/ethernet/f=
reescale/fec_main.c
> > > The rx queue status handling did not change much compared to 5.x. Onl=
y
> > > the NAPI handling / clearing IRQs was changed more than once.
> > > I also backported the newer NAPI handling style / clearing irqs not i=
n
> > > the irq handler but in napi_poll() =3D> same issue.
> > > The issue is pretty rare =3D> To reproduce i have to reboot the syste=
m
> > > every 3 min. Sometimes after 1~2min on the first, sometimes on the
> > > ~10th reboot it will happen.
> > >
> >
> > Is seems some rmb() & wmb() are missing.
>
> They are unlikely to make any difference since the 'bad'
> rx status persists between calls to the receive function.

Our kernel already has some patches like the wmb() for the rx path and
the rmb() for the tx path applied.
I tried the rmb() at the rx path, because this is not in master
https://github.com/gregkh/linux/blob/master/drivers/net/ethernet/freescale/=
fec_main.c#L1434.
=3D> Still the same issue, no change

I extended the debugging:
descriptor index, current, empty, desc.status, desc.buffer (mapped
skb->data), desc.length
[  137.758009 <    0.000015>] 409 0xa09d5320 C E 0x8840 0x2c6f0780    0

I also reset the desc.length field to 0 after the packet was received
and before the descriptor was set to empty again.
So I could observe that the length is also not set like the status.

Because i know the content and size of my rx packets, i used
dma_sync_single(mapped skb->data) to get the data even if the status
is empty.
Each packet contains a counter, so i verified that the data is already
there and not lost.
Only the descriptor status and length is not updated.

[  137.757966 <    0.000021>] cnt: 2341          .... counter of
current ("empty") packet; index 409  in example
[  137.757984 <    0.000018>] nxcnt: 2342      .... counter of next
not empty packet; index 410 in example
=3D> content is there but status is not. As next step i will also check
if all bytes are correct, not only the two counter bytes.

[   40.888181 <    0.000344>] --- start test application ---
[  137.757945 <   96.869764>] ring error, next is ready
[  137.757966 <    0.000021>] cnt: 2341
[  137.757984 <    0.000018>] nxcnt: 2342
[  137.757994 <    0.000010>] RX ahead
[  137.758009 <    0.000015>] 409 0xa09d5320 C E 0x8840 0x2c6f0780    0
[  137.758024 <    0.000015>] 410 0xa09d5340     0x0840 0x2c6f0ec0  132
[  137.758038 <    0.000014>] 411 0xa09d5360   E 0x8840 0x2c6f1600    0
[  137.758051 <    0.000013>] 412 0xa09d5380   E 0x8840 0x2c6f1d40    0
[  137.758064 <    0.000013>] 413 0xa09d53a0   E 0x8840 0x2c6f2480    0
[  137.758076 <    0.000012>] 414 0xa09d53c0   E 0x8840 0x2c6f2bc0    0
[  137.758089 <    0.000013>] 415 0xa09d53e0   E 0x8840 0x2c6f3300    0
[  137.758102 <    0.000013>] 416 0xa09d5400   E 0x8840 0x2c6f3a40    0
[  137.758115 <    0.000013>] 417 0xa09d5420   E 0x8840 0x2c6f4180    0
[  137.758127 <    0.000012>] 418 0xa09d5440   E 0x8840 0x2c6f48c0    0
[  137.758140 <    0.000013>] 419 0xa09d5460   E 0x8840 0x2c6f5000    0
[  137.758152 <    0.000012>] 420 0xa09d5480   E 0x8840 0x2c6f5740    0
[  137.758165 <    0.000013>] 421 0xa09d54a0   E 0x8840 0x2c6f5e80    0
[  137.758414 <    0.000025>] ring error, next is ready
[  137.758426 <    0.000012>] cnt: 2341
[  137.758439 <    0.000013>] nxcnt: 2342
[  137.758448 <    0.000009>] RX ahead
[  137.758485 <    0.000037>] 409 0xa09d5320 C E 0x8840 0x2c6f0780    0
[  137.758500 <    0.000015>] 410 0xa09d5340     0x0840 0x2c6f0ec0  132
[  137.758515 <    0.000015>] 411 0xa09d5360     0x0840 0x2c6f1600  132
[  137.758529 <    0.000014>] 412 0xa09d5380     0x0840 0x2c6f1d40  132
[  137.758542 <    0.000013>] 413 0xa09d53a0   E 0x8840 0x2c6f2480    0
[  137.758556 <    0.000014>] 414 0xa09d53c0   E 0x8840 0x2c6f2bc0    0
[  137.758569 <    0.000013>] 415 0xa09d53e0   E 0x8840 0x2c6f3300    0
[  137.758582 <    0.000013>] 416 0xa09d5400   E 0x8840 0x2c6f3a40    0
[  137.758596 <    0.000014>] 417 0xa09d5420   E 0x8840 0x2c6f4180    0
[  137.758609 <    0.000013>] 418 0xa09d5440   E 0x8840 0x2c6f48c0    0
[  137.758622 <    0.000013>] 419 0xa09d5460   E 0x8840 0x2c6f5000    0
[  137.758905 <    0.000031>] ring error, next is ready
[  137.758917 <    0.000012>] cnt: 2341
[  137.758930 <    0.000013>] nxcnt: 2342
[  137.758938 <    0.000008>] RX ahead
[  137.758951 <    0.000013>] 409 0xa09d5320 C E 0x8840 0x2c6f0780    0
[  137.758965 <    0.000014>] 410 0xa09d5340     0x0840 0x2c6f0ec0  132
[  137.758978 <    0.000013>] 411 0xa09d5360     0x0840 0x2c6f1600  132
[  137.758991 <    0.000013>] 412 0xa09d5380     0x0840 0x2c6f1d40  132
[  137.759005 <    0.000014>] 413 0xa09d53a0     0x0840 0x2c6f2480  132
[  137.759018 <    0.000013>] 414 0xa09d53c0     0x0840 0x2c6f2bc0  132
[  137.759031 <    0.000013>] 415 0xa09d53e0   E 0x8840 0x2c6f3300    0
[  137.759044 <    0.000013>] 416 0xa09d5400   E 0x8840 0x2c6f3a40    0
[  137.759057 <    0.000013>] 417 0xa09d5420   E 0x8840 0x2c6f4180    0
[  137.759071 <    0.000014>] 418 0xa09d5440   E 0x8840 0x2c6f48c0    0
[  137.759084 <    0.000013>] 419 0xa09d5460   E 0x8840 0x2c6f5000    0
