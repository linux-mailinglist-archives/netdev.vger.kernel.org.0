Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C36CA4107DB
	for <lists+netdev@lfdr.de>; Sat, 18 Sep 2021 19:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240045AbhIRRbp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Sep 2021 13:31:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235682AbhIRRbo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Sep 2021 13:31:44 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44162C061574
        for <netdev@vger.kernel.org>; Sat, 18 Sep 2021 10:30:20 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id v24so42630450eda.3
        for <netdev@vger.kernel.org>; Sat, 18 Sep 2021 10:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VJ9K4Ss0fO8sq3w3fi+s1XQy4Iv3mwXh4Uemm8nutng=;
        b=HtuwRZUCtjojC6VdTZELWNXgY00qcbptQey5+LTejhwWo5g8CMmknjSym9G74RH6Ma
         oPcVOCFM0bvoDz0JDWFOmLoHw2mzTecjQrEShzwr3fyltdeg/Yk3k9bXEJyFI8+DILmo
         Zn76QBbRztSInJyQGaDYETcYPmfh81XD1W72o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VJ9K4Ss0fO8sq3w3fi+s1XQy4Iv3mwXh4Uemm8nutng=;
        b=7t2b5wDCvyLSrTmtuc+wV51/qQ0swoH5Un7olkyQ2RWIKGCAXaCOdUOVtj9d1+2nnd
         sXcq3Of96jxVWdKXUZGbPKQDerxKvd8Ow030GcQMWB2UtReU8tp6Fm/Ys0lwvKwBW0r9
         iB5ZfsvQvhS2ZvfHlLqF8vDpLYTqR4G8p7fWnlhBFdXj80GNRfcRyg4Nyh0XGs4lPs0L
         yLbNYwUBN4AUHtPDB8nmwHowozIWaUefOwxZcanD3DLSxIZAhqh6jsUSoSA0bAJtRCzK
         bI6tt7KX6XK9JzgWary+w9fHknjqBqN/+QIlXv5/g7EaG2dMef9VjkIpHkSSHy9B8vJ8
         aVjg==
X-Gm-Message-State: AOAM5310Y8PzDWCUVvFgslkPzIrVJ++nEPLx+9SPbeUbGS69EMh4tY6I
        HTzYOYYVmTPpuIxDs5Z84At0tbcY1Y3C/hSTu3o=
X-Google-Smtp-Source: ABdhPJxt/CAFEjGVxlodo4otfX6swiSP8165TBDDkIsAuY2PFp4Rdqyb/j4DqbHGET96fbOv9CP3Wg==
X-Received: by 2002:a17:906:c1c9:: with SMTP id bw9mr19325102ejb.3.1631986218662;
        Sat, 18 Sep 2021 10:30:18 -0700 (PDT)
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com. [209.85.208.54])
        by smtp.gmail.com with ESMTPSA id a5sm4675625edm.37.2021.09.18.10.30.18
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Sep 2021 10:30:18 -0700 (PDT)
Received: by mail-ed1-f54.google.com with SMTP id eg28so19768290edb.1
        for <netdev@vger.kernel.org>; Sat, 18 Sep 2021 10:30:18 -0700 (PDT)
X-Received: by 2002:a05:6512:94e:: with SMTP id u14mr12398440lft.173.1631985720656;
 Sat, 18 Sep 2021 10:22:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210918095134.GA5001@tower> <202109181311.18IDBKQB005215@valdese.nms.ulrich-teichert.org>
 <CAHk-=whY5mLggPSr2U00mqgUbRJYnYSxtNZm4FnEtQrHftYr8Q@mail.gmail.com> <56956079-19c3-d67e-d3f-92e475c71f6b@tarent.de>
In-Reply-To: <56956079-19c3-d67e-d3f-92e475c71f6b@tarent.de>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 18 Sep 2021 10:21:44 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgj=fFDt6mkiOmRs7pdcYJSibqpVvwcG9_0rbVJEjBCsw@mail.gmail.com>
Message-ID: <CAHk-=wgj=fFDt6mkiOmRs7pdcYJSibqpVvwcG9_0rbVJEjBCsw@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] Introduce and use absolute_pointer macro
To:     Thorsten Glaser <t.glaser@tarent.de>
Cc:     Ulrich Teichert <krypton@ulrich-teichert.org>,
        Michael Cree <mcree@orcon.net.nz>,
        Guenter Roeck <linux@roeck-us.net>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
        Helge Deller <deller@gmx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        alpha <linux-alpha@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-parisc@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Sparse Mailing-list <linux-sparse@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 18, 2021 at 10:17 AM Thorsten Glaser <t.glaser@tarent.de> wrote=
:
>
> Considering you can actually put ISA cards, 8 and 16 bit both,
> into EISA slots, I=E2=80=99d have assumed so. I don=E2=80=99t understand =
the
> =E2=80=9CEISA only=E2=80=9D question above.

Oh, it's so long since I had one of those machines I didn't even
remember that EISA took ISA cards too.

But yeah, there are also apparently PCI-based alpha machines with
actual ISA card slots.

            Linus
