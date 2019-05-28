Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8A8D2C9A7
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 17:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727358AbfE1PIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 11:08:53 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:33216 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbfE1PIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 11:08:53 -0400
Received: by mail-ed1-f68.google.com with SMTP id n17so32324372edb.0;
        Tue, 28 May 2019 08:08:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=jDdJ/NRaP92Ox58Zhjk692io8dr+523CgmX10VYba/k=;
        b=Xgt390RJIOeuEaZWZ83yyVSoRjvEf6KsiWFb7JM45ddWl4FaH0PRjOgU301TB5fP7C
         nTE3jo11iY7vTD3zObE0aYnYmtMYreFA/gRsnsgcreOlLwmPTOj6NBP+JnkjWmYxVGOX
         BA8ifI5+muF5efo5PZvz6WrRu4kPCBn/3H4XeMZVP7ftAW7Hd1zGCceVIEGOTnCsUZK7
         GzRLutJYy12o9jRUiSvmJ+zWNYJg36m8/r1yVJrV4O+Soi3rO3e1jQM4JoB4UJqQhnVF
         5/1wa/N+6P/zTgBQCQnrhOc8mtnE1dbaGXgCtV0tW9LTTOtNlt5kyWZnBGk95ane/660
         G1Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=jDdJ/NRaP92Ox58Zhjk692io8dr+523CgmX10VYba/k=;
        b=s30NscFIcOce4bwqi3fUS4HsN8t6Ngw83RWM5zUVbpm13t6/fLdFKLyeRfNgVqXLGJ
         iE5U86O/qUBCMUXd5sagAo4HYwy2Js9pHHA19gVf4Z0D9TXHc5Pyf1eTj4SDedsbX32N
         z/Ax4RVTG6V4dh8KbdLddhaufBtpHueP9zpDk/o2+WDD6KdGbd3SoxuPyctbP7y2iFO+
         ej7zrNqNXPr1hGOhwVmvyhwwvl61mXz2E/1dyCWc2kLYExM6d8+FtSLNLORM/t1uRAIS
         vxk5p6DPZhyMzDD38i+bKrrR0Gb/4ShOIPAbDb7mwNwfwGgPIy80Q+LmV93otH3/HosT
         SoLw==
X-Gm-Message-State: APjAAAUs+aaHuLwhy7Z459icTVboHt758rIIei1z8d3YC/rJvrw3bU2S
        iSE70oJJu1HA5NCzKMle4KdVhuy0GC8CcgarT60=
X-Google-Smtp-Source: APXvYqweIelL6MQ2Wpx7+71MEU3iT4OcAg/Sc+V/fWOxiY0eNihtdLD4XF79A4cpdSkjbJ0Xr1Baeuj6EDmbqjcyMKE=
X-Received: by 2002:a17:906:2acf:: with SMTP id m15mr86421981eje.31.1559056131034;
 Tue, 28 May 2019 08:08:51 -0700 (PDT)
MIME-Version: 1.0
References: <20190523210651.80902-1-fklassen@appneta.com> <20190523210651.80902-5-fklassen@appneta.com>
 <CAF=yD-KBNLr5KY-YQ1KMmZGCpYNefSJKaJkZNOwd8nRiedpQtA@mail.gmail.com>
 <879E5DA6-3A4F-4CE1-9DA5-480EE30109DE@appneta.com> <CAF=yD-LQT7=4vvMwMa96_SFuUd5GywMoae7hGi9n6rQeuhhxuQ@mail.gmail.com>
 <5BB184F2-6C20-416B-B2AF-A678400CFE3E@appneta.com> <CAF=yD-+6CRyqL6Fq5y2zpw5nnDitYC7G1c2JAVHZTjyw68DYJg@mail.gmail.com>
 <903DEC70-845B-4C4B-911D-2F203C191C27@appneta.com>
In-Reply-To: <903DEC70-845B-4C4B-911D-2F203C191C27@appneta.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 28 May 2019 11:08:14 -0400
Message-ID: <CAF=yD-Le0XKCfyDBvHmBRVqkwn1D6ZoG=12gss5T62VcN5+1_w@mail.gmail.com>
Subject: Re: [PATCH net 4/4] net/udpgso_bench_tx: audit error queue
To:     Fred Klassen <fklassen@appneta.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >> I have been wondering about xmit_more
> >> myself. I don=E2=80=99t think it changes anything for software timesta=
mps,
> >> but it may with hardware timestamps.
> >
> > It arguably makes the software timestamp too early if taken on the
> > first segment, as the NIC is only informed of all the new descriptors
> > when the last segment is written and the doorbell is rung.
> >
>
> Totally makes sense. Possibly this can be improved software TX
> timestamps by delaying until just before ring buffer is advanced.
> It would have to be updated in each driver. I may have a look at
> this once I am complete this patch. Hopefully that one will be a bit
> smoother.

How do you see that? The skb_tstamp_tx call currently is already the
last action before ringing the doorbell, after setting up the
descriptor. It cannot be set later.

The only issue specific to GSO is that xmit_more can forego this
doorbell until the last segment. We want to complicate this logic with
a special case based on tx_flags. A process that cares should either
not use GSO, or the timestamp should be associated with the last
segment as I've been arguing so far.

> >>> Can you elaborate on this suspected memory leak?
> >>
> >> A user program cannot free a zerocopy buffer until it is reported as f=
ree.
> >> If zerocopy events are not reported, that could be a memory leak.
> >>
> >> I may have a fix. I have added a -P option when I am running an audit.
> >> It doesn=E2=80=99t appear to affect performance, and since implementin=
g it I have
> >> received all error messages expected for both timestamp and zerocopy.
> >>
> >> I am still testing.
> >
> > I see, a userspace leak from lack of completion notification.
> >
> > If the issue is a few missing notifications at the end of the run,
> > then perhaps cfg_waittime_ms is too short.
> >
>
> I=E2=80=99ll get back to you when I have tested this more thoroughly. Ear=
ly results
> suggest that adding the -P poll() option has fixed it without any appreci=
able
> performance hit. I=E2=80=99ll share raw results with you, and we can make=
 a final
> decision together.

In the main loop? It still is peculiar that notifications appear to go
missing unless the process blocks waiting for them. Nothing in
sock_zerocopy_callback or the queueing onto the error queue should
cause drops, as far as I know.

>
> >> Should the test have failed at this point? I did return an error(), bu=
t
> >> the script kept running.
> >
> > This should normally be cause for test failure, I think yes. Though
> > it's fine to send the code for review and possibly even merge, so that
> > I can take a look.
> >
>
> Sounds like udpgso_bench.sh needs a =E2=80=99set -e=E2=80=99 to ensure it=
 stops on
> first error.

Indeed. Ideally even run all tests, but return error if any failed,
like this recent patch

  selftests/bpf: fail test_tunnel.sh if subtests fail
  https://patchwork.ozlabs.org/patch/1105221/

but that may be a lot of code churn and better left to a separate patch.
