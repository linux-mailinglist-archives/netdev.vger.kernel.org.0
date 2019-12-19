Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8526F125FDA
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 11:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbfLSKuf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 05:50:35 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:46277 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726633AbfLSKuf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Dec 2019 05:50:35 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id c667ec1b;
        Thu, 19 Dec 2019 09:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=GyQANekzB2h7Mmd6y6oCcFxKVhQ=; b=s/qYlt
        PnIM6A6GkurQlk2Ar8T8qSTXpvyPWHiAEVHfURilOwXrjs3NjyyWNxyNrLK4PL+Y
        z2T5Qhb6++Ohx9SpLX39m0ULf91XXHGYp3dbTNPBdc7EHleQrWp74iR2QvlzZlks
        7PEd4Narcu6X0L02O7+WY4CoEpSDhY2QszJBmDyYP/3Df+YSp4uOskXlSMOoe2m2
        M8XX1nktJ1zndrhm/eq4ftTkPU75ZwZnT4sfC5fFILa3ZW9GagNyUkSP3NHEnfRo
        NJx3yV0usVkLzzCw9WYhpHpSDN/eNdYlRye5kdW6Zb/VdD+56rLrR4yV6ysQD52j
        z/dsG686jbmbz9QA==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 135ea1c5 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Thu, 19 Dec 2019 09:53:52 +0000 (UTC)
Received: by mail-ot1-f43.google.com with SMTP id h9so4145295otj.11;
        Thu, 19 Dec 2019 02:50:33 -0800 (PST)
X-Gm-Message-State: APjAAAUVn57XkLUuXcdJWVbFbEWmyzfi2OsMIzwqoi2/8zxdfyGPp8Bh
        sCaPtuxOU6TDabggpT1sajpCpNHvw478RAkgWII=
X-Google-Smtp-Source: APXvYqyOjDE/JGl4JOdsCt2LI14BVtDqDKXAQqVTZdkqtmpAnah60r/cQNnslAxZCzGGekHa84RO/mvbmWXDJrEBApU=
X-Received: by 2002:a9d:674f:: with SMTP id w15mr8304067otm.243.1576752632820;
 Thu, 19 Dec 2019 02:50:32 -0800 (PST)
MIME-Version: 1.0
References: <20191208232734.225161-1-Jason@zx2c4.com> <CACT4Y+bsJVmgbD-WogwU=LfWiPN1JgjBrwx4s8Y14hDd7vqqhQ@mail.gmail.com>
 <CAHmME9o0AparjaaOSoZD14RAW8_AJTfKfcx3Y2ndDAPFNC-MeQ@mail.gmail.com>
 <CACT4Y+Zssd6OZ2-U4kjw18mNthQyzPWZV_gkH3uATnSv1SVDfA@mail.gmail.com>
 <CAHmME9oM=YHMZyg23WEzmZAof=7iv-A01VazB3ihhR99f6X1cg@mail.gmail.com>
 <CACT4Y+aCEZm_BA5mmVTnK2cR8CQUky5w1qvmb2KpSR4-Pzp4Ow@mail.gmail.com>
 <CAHmME9rYstVLCBOgdMLqMeVDrX1V-f92vRKDqWsREROWdPbb6g@mail.gmail.com> <CACT4Y+Zs=SQwYS8yx3ds7HBhr1RHkDwRe_av2XjJty-5wMTFEA@mail.gmail.com>
In-Reply-To: <CACT4Y+Zs=SQwYS8yx3ds7HBhr1RHkDwRe_av2XjJty-5wMTFEA@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 19 Dec 2019 11:50:21 +0100
X-Gmail-Original-Message-ID: <CAHmME9pe1XNfT5LN0---WQgQYEHVaFRC9fkqTBsTYcU6GbGnFA@mail.gmail.com>
Message-ID: <CAHmME9pe1XNfT5LN0---WQgQYEHVaFRC9fkqTBsTYcU6GbGnFA@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net: WireGuard secure network tunnel
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 19, 2019 at 11:42 AM Dmitry Vyukov <dvyukov@google.com> wrote:
> Well, unfortunately it does not test wireguard at the moment. I've
> enabled the config as I saw it appeared in linux-next:
> https://github.com/google/syzkaller/commit/240ba66ba8a0a99f27e1aac01f376331051a65c2
> but that's it for now.

I do see that in the linux-next and net-next instances you have
running, it's at least hitting interface creation and netlink.

> There are 3000 subsystems, are you ready to describe precise interface
> for all of them with all the necessary setup and prerequisites? Nobody
> can do it for all subsystems. Developer of a particular subsystem is
> the best candidate for also describing what it takes to test it ;)

Sure, I'd be happy to help get things rolling on WireGuard. What do
you need from me? A small shell script to set up a few interfaces that
are peered with each other? Sample packets to begin mutations from?
Since most of WireGuard's surface is behind constant-time/branchless
crypto, I doubt you'll fuzz your way to having valid key agreement,
which makes me think some sort of setup is necessary.
