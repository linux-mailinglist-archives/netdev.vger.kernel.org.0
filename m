Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C038D684B
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 19:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388470AbfJNRUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 13:20:04 -0400
Received: from mout.web.de ([212.227.15.4]:42123 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731347AbfJNRUE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Oct 2019 13:20:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1571073572;
        bh=ivQq46IZIMJnW4r/ASiDcfPLUdJ55kJIffdk+uY5TXY=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=CAecJ5kP1bIkaUffOdYlLV07AzOXtBoC7LqO4Lua0CifDxcTfeGkmSPeo3aFmdZmq
         JOfi30QON9A6gF2W5q9mujWc2sA9Lau1WYfS98dP2IXWClMnlgHKmQ92BhwY0XHJ5B
         5Htc/Pgf/gPRLq+oqFIVoQtukF+IgSGoIhSIhKLo=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.135.26.106]) by smtp.web.de (mrweb004
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0LhhVB-1hgaW52TU9-00mraW; Mon, 14
 Oct 2019 19:19:32 +0200
Subject: Re: tcp: Checking a kmemdup() call in tcp_time_wait()
To:     Eric Dumazet <edumazet@google.com>,
        netdev <netdev@vger.kernel.org>, kernel-janitors@vger.kernel.org
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki Yoshifuji <yoshfuji@linux-ipv6.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Aditya Pakki <pakki001@umn.edu>, Kangjie Lu <kjlu@umn.edu>,
        Navid Emamdoost <emamd001@umn.edu>,
        Stephen McCamant <smccaman@umn.edu>,
        LKML <linux-kernel@vger.kernel.org>
References: <a219235e-bad5-8a9d-0f3e-c05d5cb11df1@web.de>
 <124b41aa-7ba5-f00c-ab73-cb8e6a2ae75f@gmail.com>
 <fc39488c-f874-5d85-3200-60001e6bda52@web.de>
 <0984a481-f5eb-4346-fb98-718174c55e36@gmail.com>
 <248c2ca6-0c27-dc62-6d20-49c87f0af15f@web.de>
 <CANn89i+WzeMhCysz7QngWM7iMMv1GAuzVez0Gviiud5MZoKO-w@mail.gmail.com>
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <a31967be-b59e-0da8-1119-633c4927a904@web.de>
Date:   Mon, 14 Oct 2019 19:19:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <CANn89i+WzeMhCysz7QngWM7iMMv1GAuzVez0Gviiud5MZoKO-w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:OGn+h5ufNvl9R2r6C23sUvQINWsLaVKW2SqvzExYNWJL4kze04h
 YZvk2F6qonHhspqJ49/lPgd4OZFqnlvGRtJz5Ok0FWzrBOxzajeENHGr0+ESuxKvDB9exzT
 zF637RpaA+WS6ChK67S2S/fm3YEVs94g1VLVU3n3VVjiqPV0ri4Ey9+AtXRHLD9uN4tfXQG
 Jw3lRFz4bcSXK7+PqYS1g==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:imi17Ffo5r0=:0PkBVnjHDXHQeaZGviNSzA
 DBXqSG6XS/Tt8eWeveBpFHzDVeejlq7I5+W36Cn2+dNpUe44kgA3KRu3+IcRMK/wI1KZamJ4R
 rf8X9QZVWr5Vv4heRSnTz9rdDq9aIhZoES/Qit6KbdULAC06B4aN8j6NsXAk4VbazVUnUi5to
 GT/s/ed8sF6Qq0fRf+AKt5J18cK9OLLKbmJg8AuY2E3Bi2H1/HNzd0qg83anov3F2JsO8xIE+
 RE2QaGf8sgPqF5vdtkGEf3/n7K2GOx5rcORfer5ebIAz5lUrY9n8dXN238FpuEfcJ6gG0Pvco
 SRRx+UqtPpI8VOnbcrIJRg8dnK6mxKlSYWtUvEyysQ5lH/4w3skvvAF8faGx8PzJ8AGSvPCKW
 m4KRVQtpmaQeMTgx7e29rd2Ybg8pYau8OOxPNGKq2syTtQUsFxqntIGAiiyUUHyeUv/9PIZaB
 ah+TAAecF9mu8HPkyHbRdXjIGubBjcFoJ6hPs1L0JHGZHR7POu/nAyYdN5I72OTBlDZMf0NW8
 TC+PsuSXvgMP3a75BD/V8kyaRqzOHYs8MnMGNgRcQH6BsYNeVJTLA/3JglQDaMoNZn4VCFsZu
 EcAHJiHaDMll/PtQog2sSmhtqGuIz+YGyQ2ktbw0KCdLfbcQ0aJlbvjOReoR/JLdheyguiRBZ
 nvbmkh97qEfa213lEuY57jwN2YFXI4CiTtR7QM7yCmSqigGDLoDoXUzdFIRXt0JxMrJnGANLw
 R6Wmd8ydcuEwzMWlggpfFxXzvG98uJ6VdkGeyfANDFQ3Kvd6lnLa1zgBMmujLx3iGKU2Ne7U1
 ruNmrEpc5TDaM6QntdLaIoVxgL85W1H7Zg+ZMh40h3E6/TX0tM9r8at8+0WJclc3QvCoGPsU2
 9dL5doiB54YLsI8evQMpBKT5ydOSj5UI7aWU8FHdHLnauj1Cuw6YZvS1UOrKyLmI90ngAJqBS
 g52hWcFNFgAZTkA4smjpUoJRQ/gnzTp6ICdh52/hpHjEYuwgUGehnPxM0Gumuv/Obzr2re5Ds
 eLlS3mwa1pvTViesssV3TcDmk9VYWGL+RRZ49gRfEluX+M7E3tIisqX7Rn8mvW9Tw8Kf/Xj5q
 8htQNH7JumKk8yz3LJLNDGjte65//BZg1A2qf3mBdRh2hz0gm58/GZsprruKTLgEmKDpOWT+S
 ZTBpDkSzZPFhxJCc5YxnfMeaMUZrIo8rx+mjxCoTqqI3n+3sRWfTrvDV3qcSLhAJJvfHEPMxH
 4RocAotBphCMlWot6jqFVqvqkyTR65iUc1hwv05JatFqLP/4PlQPTC8mNN1M=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> This is coding style for newly submitted code.
>
> We do not refactor code to the latest coding style, this would cost a lo=
t.

Were any update candidates left over also in this function implementation?


>> How do you think about to return an error code like =E2=80=9C-ENOMEM=E2=
=80=9D at this place?
>
> tcp_time_wait() is void,

Can the function return type be eventually changed?


> the caller won't care.

Will any other software developers (and source code reviewers) start to
care more for unchecked function calls?


> I told you time_wait is best effort.

Can this approach still be improved another bit?


> What is the problem you want to solve _exactly_ ?

I became curious if the software situation can be adjusted around
a possibly ignored return value from a call of a function like kmemdup().

Regards,
Markus
