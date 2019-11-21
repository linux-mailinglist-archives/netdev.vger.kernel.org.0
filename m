Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E50D61054C8
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 15:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbfKUOor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 09:44:47 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:43875 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbfKUOor (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 09:44:47 -0500
Received: by mail-lf1-f66.google.com with SMTP id l14so2838348lfh.10;
        Thu, 21 Nov 2019 06:44:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VXzx9aTYeMQl18LE4uxvxrgXEVm/FTvT7LouxOHpbMQ=;
        b=TGuAsPNxZIOi0BiAVSPyzbWWKoSZoS1L8Cz+haDYOSMklBR+DWYI4RKgqpsqbcye04
         R3hqlOwHQVqKs2yc/wp9LpHYlmz66NiVPyblTYlWal10g1In1XNsHIO0n+iL8GZWia+z
         Y6O5mE/7aW6j5nbU5/C8KfEi6CBcIwfppx6j9X1xKLpLKH4lQqhi1+G/OiJuFl/klz+Q
         OyInQQNir6trcmP1uiaQOqMGd5BDEPPcdOlEQDFHS5FCm2GNyAkdtScTFymV0pQU+bMx
         idmQVKhthdewPpu5lWoTzDVEtkM2Q1Z4kuQMmfI9yLl58hs0lemvP4AfKccUoBGPd69z
         C8EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VXzx9aTYeMQl18LE4uxvxrgXEVm/FTvT7LouxOHpbMQ=;
        b=Bxe2tOe13ROAIsC0F3HyX+PyVK45+HB9jM4f5KEIziDe6I8Xyl21JHivPnvnmQsCLD
         /MCvJsEGS6ndLXgt+/8ZuM7+G5DXYhdLBYTThh/PfCAiCB3ekIhbVoW7iNpd4bHJ0nAI
         BCGWEkmu+a6JIy9hY7noQuZAB9HqvQcjT+RU/S3l5SkxbF0yTRRrwjC3a4+RCgc8pWYp
         KfGvh8r9f79CUCYjMNXhtjCUtPncqzvuA7cK9XDBAhxoHfzXV8e4D4TMIIK1xcQmMkPt
         YR/AZvB5s22kuHvso71rQvv6EB8uvB451vMM3TMlRcYsoV4U28YjvLl3wPRk9u7ipioS
         0baQ==
X-Gm-Message-State: APjAAAXO5fmzpF0hvYYvbX6Ah8SukhaqFbPqG3EhBsw0RAtO3NcQ92uk
        MTfTZ1hzqU+MaOoBKSu2Llom0TddZdnwLMTCYMs=
X-Google-Smtp-Source: APXvYqzD4PNqVRcS5zHB0VNgXjeposUpPgmg7qw+BbT+QY3NiPTZ5wQKYTBMR5cEMS0bjInbclgss5aB67f/Zy3yE2k=
X-Received: by 2002:a19:f701:: with SMTP id z1mr2971084lfe.133.1574347485888;
 Thu, 21 Nov 2019 06:44:45 -0800 (PST)
MIME-Version: 1.0
References: <20191120203538.199367-1-Jason@zx2c4.com> <877e3t8qv7.fsf@toke.dk> <CAHmME9rmFw7xGKNMURBUSiezbsBEikOPiJxtEu=i2Quzf+JNDg@mail.gmail.com>
In-Reply-To: <CAHmME9rmFw7xGKNMURBUSiezbsBEikOPiJxtEu=i2Quzf+JNDg@mail.gmail.com>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Thu, 21 Nov 2019 15:44:34 +0100
Message-ID: <CANiq72mGPmMVBCmOMc_xJbKuOvbmmPAotGx67nSVQrYmXd2x3A@mail.gmail.com>
Subject: Re: [PATCH RFC net-next] net: WireGuard secure network tunnel
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <thoiland@redhat.com>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jason,

On Thu, Nov 21, 2019 at 12:09 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> [...]

Any reason for the .clang-format in drivers/? If yes, it would be nice
to state it in the comment of the file.

Cheers,
Miguel
