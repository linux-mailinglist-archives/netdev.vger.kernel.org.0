Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D87449D86
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 11:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729388AbfFRJh3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 05:37:29 -0400
Received: from mail-yb1-f196.google.com ([209.85.219.196]:35191 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729263AbfFRJh3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 05:37:29 -0400
Received: by mail-yb1-f196.google.com with SMTP id v17so5797391ybm.2
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 02:37:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KnB6xK4HiQoJS5/13fsK8xxNIgyVPR5SQYTgXV9IFVg=;
        b=WLhARJowtoGMcEvJRAnKSywn8KHofN+Bj8GZJT2bzMsrTwt/5+QY8YHcQ89VdWvqi1
         Cfz9SoLmtn7gwCmULSi9859h6+B8KTAOdC2J6iQC5TkBwlDgkTqkTgkCZng+feqgRqh/
         K1YXPkWJ59jMZed7P8fvjOuAJBB36/YgwRpRQEdhn/NnWcyb5clNX5wRaflHcMIV+XS+
         5rmkHC4f9CVjoLNdAPU0fPLaDsP4/XjfI9eptJLWFs/W5woXifjhmRzIyhMk1PQypij0
         lkZ4e46ttOu0dkjwIdEGYzpMr5iVnhcmf6YC7yIEJsdCRae1Caw6hvvxGXvIZHZorxWl
         /blw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KnB6xK4HiQoJS5/13fsK8xxNIgyVPR5SQYTgXV9IFVg=;
        b=H9rjvkZXgXwXvZ7ax2Ix6oLyIz8WWFdrysMA5nBKOnSQtqamalmT+w0Vw5IKETZ0U8
         LRGKcTHNzwEL/3071YeZv8TY/ce2Kilnp3KORtKMeSbRGFAFBzeo/Otg3Sh1gYT1dsU1
         Y7dIwH/mCIYtrNiLb6ODAERjVNRdoEPKkmhqPe4scM3klt6JRUZHXZ8yavXsdSOHrrKH
         V9m/ph2W9y6LCEbb/5DPe2MEH/hF32Odp6VMyn2RFI0I4fmm01r3EEiMmZ6ybJ/QxAuq
         /c5BC21OOjR6Oyi6fJ+x70ejc4qExMlFJ7JdMkSuDgtE3IFuYwN9BKYL6JuJXdP6O1N2
         lkhw==
X-Gm-Message-State: APjAAAVO7/PhcK5RZp6NYUJd+1s80w36ip2bDvAB76695aI6bPOwcz2y
        Xjkps3LJsD554otfZgIdB9q9Broyui5wkjW4MxTigwMVuA0wnw==
X-Google-Smtp-Source: APXvYqyON9JJ13ycv/7UNw8g/mJ0iS83UQ+LPfcdhghrZb9ImY7kP41P7TEXf/pLYuS13/imQ8r8Rx5aBbzSL+DO/X0=
X-Received: by 2002:a25:4557:: with SMTP id s84mr56059096yba.504.1560850648071;
 Tue, 18 Jun 2019 02:37:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190618093207.13436-1-ard.biesheuvel@linaro.org>
In-Reply-To: <20190618093207.13436-1-ard.biesheuvel@linaro.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 18 Jun 2019 02:37:16 -0700
Message-ID: <CANn89i+Hcp5nxteWHOq-Uv9VzneCemVEkyyZJD=UG9-wsrLAwQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] net: fastopen: follow-up tweaks for SipHash switch
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jason Baron <jbaron@akamai.com>,
        Christoph Paasch <cpaasch@apple.com>,
        David Laight <David.Laight@aculab.com>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 18, 2019 at 2:32 AM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
>
> A pair of tweaks for issues spotted by Eric Biggers. Patch #1 is
> mostly cosmetic, since the error check it adds is unreachable in
> practice, and the other changes are syntactic cleanups. Patch #2
> adds endian swabbing of the SipHash output for big endian systems
> so that the in-memory representation is the same as on little
> endian systems.
>

Please always add net or net-next in your patches for netdev@

( Documentation/networking/netdev-FAQ.rst )

Thanks.
