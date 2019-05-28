Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54D8C2CCC1
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 18:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727318AbfE1Q5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 12:57:38 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38940 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726512AbfE1Q5i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 12:57:38 -0400
Received: by mail-pf1-f195.google.com with SMTP id z26so11849263pfg.6
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 09:57:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=appneta.com; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=lFicemnrxZJjOmAogTHnQIM2MtSG5wRpTZojge/oE6s=;
        b=UUNfmVG+dl4dsV8GCJXdvUnq74HpLPc5cl3YuUVk4GPLntZVTxPBjZfWYIkjiOzwvi
         zs5qeIrC1fIXH1W7PYyqTjICOngvh34WOuANDVsZgYdU9IuYMoqzEeoEEKXYIVMaV5Ui
         f99nhgBOAcoT4Pge69hhdYt4kivvKfZ78Qnoo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=lFicemnrxZJjOmAogTHnQIM2MtSG5wRpTZojge/oE6s=;
        b=FjM/i2QcG6BiEPbLPc1MZS5lMMLMDiXdTiEDtCBWT5sK3QctVnVApulY6BubJVM4O9
         mBw5elzJ93ldqRl/qMzQy/n0RI2RCG7e6zXLgSYlNreABCLFsdP7UW3OKqn8tCaF5XaY
         bPjURAtmZU7MoadkcDmorhVyEDMYh/fKwMdR6kHC6dm9H2Qunw2U7wm8eUs6jbInyK1x
         LFZ3sN70nUJjM+NG9MsRBDgRioqshXrmREBeCKWSTnDpm8RQloV5Ynpt2ejaGk0vRTJx
         QXfMEsPZhFOiG5lvgs6r+0EDcDvPUH9OsIg+QfxQ2VHiyuamWuyCMGZLorGJEswdMPLM
         JX6Q==
X-Gm-Message-State: APjAAAX/03eCZ4De3NWrmE7sya6ubtv335ma8wo2IJxJ6pVnj/TFnd7b
        2kJTAwjZry6YA5SxZcIvuGSm0w==
X-Google-Smtp-Source: APXvYqx5jjVcgp8A0NWp+9txe3Qup8abnAwaoeeODau1vlVKM4m9vzUFxHigDyzUk6yBCJxrG4Y9mA==
X-Received: by 2002:a62:4dc5:: with SMTP id a188mr93983392pfb.8.1559062657044;
        Tue, 28 May 2019 09:57:37 -0700 (PDT)
Received: from jltm109.jaalam.net (vancouver-a.appneta.com. [209.139.228.33])
        by smtp.gmail.com with ESMTPSA id t5sm10996695pgh.46.2019.05.28.09.57.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 09:57:36 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH net 4/4] net/udpgso_bench_tx: audit error queue
From:   Fred Klassen <fklassen@appneta.com>
In-Reply-To: <CAF=yD-Le0XKCfyDBvHmBRVqkwn1D6ZoG=12gss5T62VcN5+1_w@mail.gmail.com>
Date:   Tue, 28 May 2019 09:57:35 -0700
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <9811659B-6D5A-4C4F-9CF8-735E9CA6DE4E@appneta.com>
References: <20190523210651.80902-1-fklassen@appneta.com>
 <20190523210651.80902-5-fklassen@appneta.com>
 <CAF=yD-KBNLr5KY-YQ1KMmZGCpYNefSJKaJkZNOwd8nRiedpQtA@mail.gmail.com>
 <879E5DA6-3A4F-4CE1-9DA5-480EE30109DE@appneta.com>
 <CAF=yD-LQT7=4vvMwMa96_SFuUd5GywMoae7hGi9n6rQeuhhxuQ@mail.gmail.com>
 <5BB184F2-6C20-416B-B2AF-A678400CFE3E@appneta.com>
 <CAF=yD-+6CRyqL6Fq5y2zpw5nnDitYC7G1c2JAVHZTjyw68DYJg@mail.gmail.com>
 <903DEC70-845B-4C4B-911D-2F203C191C27@appneta.com>
 <CAF=yD-Le0XKCfyDBvHmBRVqkwn1D6ZoG=12gss5T62VcN5+1_w@mail.gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On May 28, 2019, at 8:08 AM, Willem de Bruijn =
<willemdebruijn.kernel@gmail.com> wrote:
>=20

I will push up latest patches soon.

I did some testing and discovered that only TCP audit tests failed. They
failed much less often when enabling poll.  Once in about 20 runs
still failed. Therefore I commented out the TCP audit tests.

As for the other tests, this is what I got with poll() disabled=E2=80=A6

udp gso zerocopy timestamp audit
udp rx:   1611 MB/s  1148129 calls/s
udp tx:   1659 MB/s    28146 calls/s  28146 msg/s
udp rx:   1686 MB/s  1201494 calls/s
udp tx:   1685 MB/s    28579 calls/s  28579 msg/s
udp rx:   1685 MB/s  1200402 calls/s
udp tx:   1683 MB/s    28552 calls/s  28552 msg/s
Summary over 3.000 seconds...
sum udp tx:   1716 MB/s      85277 calls (28425/s)      85277 msgs =
(28425/s)
Tx Timestamps:               85277 received                 0 errors
Zerocopy acks:               85277 received                 0 errors

Here you see that with poll() enabled, it is a bit slower, so I don=E2=80=99=
t have it
enabled in udpgso_bench.sh =E2=80=A6

udp gso zerocopy timestamp audit
udp rx:   1591 MB/s  1133945 calls/s
udp tx:   1613 MB/s    27358 calls/s  27358 msg/s
udp rx:   1644 MB/s  1171674 calls/s
udp tx:   1643 MB/s    27869 calls/s  27869 msg/s
udp rx:   1643 MB/s  1170666 calls/s
udp tx:   1641 MB/s    27845 calls/s  27845 msg/s
Summary over 3.000 seconds...
sum udp tx:   1671 MB/s      83072 calls (27690/s)      83072 msgs =
(27690/s)
Tx Timestamps:               83072 received                 0 errors
Zerocopy acks:               83072 received                 0 errors


You may be interested that I reduced test lengths from 4 to 3 seconds,
but I am still getting 3 reports per test. I picked up the extra report =
by
changing 'if (tnow > treport)=E2=80=99 to 'if (tnow >=3D treport)=E2=80=99=


> The only issue specific to GSO is that xmit_more can forego this
> doorbell until the last segment. We want to complicate this logic with
> a special case based on tx_flags. A process that cares should either
> not use GSO, or the timestamp should be associated with the last
> segment as I've been arguing so far.

This is the area I was thinking of looking into. I=E2=80=99m not sure it =
will work
or that it will be too messy. It may be worth a little bit of digging to
see if there is anything there. That will be down the road a bu

>>=20
>> I=E2=80=99ll get back to you when I have tested this more thoroughly. =
Early results
>> suggest that adding the -P poll() option has fixed it without any =
appreciable
>> performance hit. I=E2=80=99ll share raw results with you, and we can =
make a final
>> decision together.
>=20
> In the main loop? It still is peculiar that notifications appear to go
> missing unless the process blocks waiting for them. Nothing in
> sock_zerocopy_callback or the queueing onto the error queue should
> cause drops, as far as I know.
>=20

Now that I know the issue is only in TCP, I can speculate that all bytes =
are
being reported, but done with fewer messages. It may warrant some
investigation in case there is some kind of bug.

> Indeed. Ideally even run all tests, but return error if any failed,
> like this recent patch
>=20
>  selftests/bpf: fail test_tunnel.sh if subtests fail
>  https://patchwork.ozlabs.org/patch/1105221/
>=20
> but that may be a lot of code churn and better left to a separate =
patch.

I like it. I have it coded up, and it seems to work well. I=E2=80=99ll =
make a
separate commit in the patch set so we can yank it out if you feel
it is too much=
