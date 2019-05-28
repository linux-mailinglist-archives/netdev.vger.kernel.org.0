Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6FB52BE92
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 07:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727430AbfE1FTy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 01:19:54 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:32889 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727193AbfE1FTy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 01:19:54 -0400
Received: by mail-pf1-f193.google.com with SMTP id z28so10723137pfk.0
        for <netdev@vger.kernel.org>; Mon, 27 May 2019 22:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=appneta.com; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Pjs+SKKxwsbAECDYSiJjntgAxkrMGaxQdTe+f2oaXzA=;
        b=vbdw2kfiuuVu/iK1KRrWmOpzZzpelJGsznZT59GImYpnT8VRZmOT40OZyjHKCzY4Ld
         OcJ5J8IOtu/ulckS5LLcNgVzyygOYMJk+wl+2rh/jGYgATrICI+AoHHagdtKruTaLPgK
         H4iVaVYJfr3R6Y7njuNkWTSDA3Eojil6qLl+A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Pjs+SKKxwsbAECDYSiJjntgAxkrMGaxQdTe+f2oaXzA=;
        b=lCiEIWmfHksSD0eWPLt5EsdaRcfwEvczUkGGKtRJzCT85GX7K33mGO/N3v6JzXnMqy
         Dgc54rfbr9GUO0lDv/kFkS6gyfppltVkxCq1XPHa5psIwZvP8+heltWNZkgAwnb8qIK6
         xE+Njv95tkDDVqkg2jvOGZ5hqJGdUdojiIVIRy/JIBKlkH9zMNi/cJodWYlIEylfeRwS
         EeZH/nF+cQtKPjAmKgIjfjTex/EGkYRG//p5WeLh74V/ZDHUuYwZpbLBBb8znyXvd6Xi
         TOqPW8x0iTeS0HagQ6x+wXXD/5kQ0k071GrDZK+5/XpzjrX5mlWuSGFYbdr0nINkiGP9
         wVzA==
X-Gm-Message-State: APjAAAU1MzDEjQHPvIcaYiWNfaJjOClnX95lRGbQJEX9EBydcbIioBd6
        QgWAUqhJnP8V7D6qPQ9UV2l3ng==
X-Google-Smtp-Source: APXvYqyOzNS+Jfc0QhW5Y0oHKcvuUOPye4unhuhwkSA1xrTl2ZmkQ9b1IOBKfBxFIZ4CLpt43Cd/aA==
X-Received: by 2002:a63:dc09:: with SMTP id s9mr90195227pgg.425.1559020793656;
        Mon, 27 May 2019 22:19:53 -0700 (PDT)
Received: from [10.0.1.19] (S010620c9d00fc332.vf.shawcable.net. [70.71.167.160])
        by smtp.gmail.com with ESMTPSA id h3sm12098133pfq.66.2019.05.27.22.19.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 May 2019 22:19:52 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH net 4/4] net/udpgso_bench_tx: audit error queue
From:   Fred Klassen <fklassen@appneta.com>
In-Reply-To: <CAF=yD-+6CRyqL6Fq5y2zpw5nnDitYC7G1c2JAVHZTjyw68DYJg@mail.gmail.com>
Date:   Mon, 27 May 2019 22:19:51 -0700
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <903DEC70-845B-4C4B-911D-2F203C191C27@appneta.com>
References: <20190523210651.80902-1-fklassen@appneta.com>
 <20190523210651.80902-5-fklassen@appneta.com>
 <CAF=yD-KBNLr5KY-YQ1KMmZGCpYNefSJKaJkZNOwd8nRiedpQtA@mail.gmail.com>
 <879E5DA6-3A4F-4CE1-9DA5-480EE30109DE@appneta.com>
 <CAF=yD-LQT7=4vvMwMa96_SFuUd5GywMoae7hGi9n6rQeuhhxuQ@mail.gmail.com>
 <5BB184F2-6C20-416B-B2AF-A678400CFE3E@appneta.com>
 <CAF=yD-+6CRyqL6Fq5y2zpw5nnDitYC7G1c2JAVHZTjyw68DYJg@mail.gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On May 27, 2019, at 6:15 PM, Willem de Bruijn =
<willemdebruijn.kernel@gmail.com> wrote:
>> I wanted to discuss whether or not to attach a buffer to the
>> recvmsg(fd, &msg, MSG_ERRQUEUE). Without it, I have
>> MSG_TRUNC errors in my msg_flags. Either I have to add
>> a buffer, or ignore that error flag.
>=20
> Either sounds reasonable. It is an expected and well understood
> message if underprovisioning the receive data buffer.
>=20

I=E2=80=99ll stick with setting up buffers. It will fail if there are =
any bugs=20
introduced in buffer copy routines.

>=20
> The netdev list is archived and available through various websites,
> like lore.kernel.org/netdev . As well as the patches with comments at
> patchwork.ozlabs.org/project/netdev/list
>=20

Much better. Sure beats hunting down lost emails.


>> I have been wondering about xmit_more
>> myself. I don=E2=80=99t think it changes anything for software =
timestamps,
>> but it may with hardware timestamps.
>=20
> It arguably makes the software timestamp too early if taken on the
> first segment, as the NIC is only informed of all the new descriptors
> when the last segment is written and the doorbell is rung.
>=20

Totally makes sense. Possibly this can be improved software TX
timestamps by delaying until just before ring buffer is advanced.
It would have to be updated in each driver. I may have a look at
this once I am complete this patch. Hopefully that one will be a bit
smoother.=20

>>> Can you elaborate on this suspected memory leak?
>>=20
>> A user program cannot free a zerocopy buffer until it is reported as =
free.
>> If zerocopy events are not reported, that could be a memory leak.
>>=20
>> I may have a fix. I have added a -P option when I am running an =
audit.
>> It doesn=E2=80=99t appear to affect performance, and since =
implementing it I have
>> received all error messages expected for both timestamp and zerocopy.
>>=20
>> I am still testing.
>=20
> I see, a userspace leak from lack of completion notification.
>=20
> If the issue is a few missing notifications at the end of the run,
> then perhaps cfg_waittime_ms is too short.
>=20

I=E2=80=99ll get back to you when I have tested this more thoroughly. =
Early results
suggest that adding the -P poll() option has fixed it without any =
appreciable
performance hit. I=E2=80=99ll share raw results with you, and we can =
make a final
decision together.

>> Should the test have failed at this point? I did return an error(), =
but
>> the script kept running.
>=20
> This should normally be cause for test failure, I think yes. Though
> it's fine to send the code for review and possibly even merge, so that
> I can take a look.
>=20

Sounds like udpgso_bench.sh needs a =E2=80=99set -e=E2=80=99 to ensure =
it stops on
first error.

