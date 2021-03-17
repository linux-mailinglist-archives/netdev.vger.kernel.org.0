Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC9D933ED38
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 10:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbhCQJkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 05:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbhCQJkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 05:40:20 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2626C06174A;
        Wed, 17 Mar 2021 02:40:19 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id b184so717130pfa.11;
        Wed, 17 Mar 2021 02:40:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Yr2V3nYTRckIb/1WVjsM9TQ9fvGwbKIRAjE1AIaksiE=;
        b=RAK3a1d4wvuJm9kSfwEoOhEBNe/fRi3jjLS8XfJDb02OFqhNG/bT7WRg86XrM2bDZd
         ZDSWB/YBq0vxTTUOoYa2/DLJIDT+OEGmQ0CE+T0b/oxDPVVKdakgem1vkjuNfO1VW46/
         3dUwuWoFrWW8dSUD/blctYZjbT80/W79IPj06TqaoLTp6rlQBx4Wk8wLD28+inagV03+
         NDI2F4QEMeA9b0pRX86U6ElvORg9W4RvZXeC+mYct8J/9wo/qAJVqRuxIR/JDLS+zLnm
         /uv93r/VW7V8y+deEaSeU7qVzw+3k4/2ttuqRGBN97vAingVacd/l0ONaLHBLmonQPtu
         WbgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Yr2V3nYTRckIb/1WVjsM9TQ9fvGwbKIRAjE1AIaksiE=;
        b=jn/iu53F9NCWtRiyvPTdRj0RHw9b6DgqLxmZr31f8QKD2LrjKCRXIa+sC/6L7kgpD2
         KjOQKutatU1Y+hVn1Ep+atPqZuNw3wbfA6DBqiteEuPEleDoF6TaVpbEHUGj9bZDuFgX
         KEH3rElw0wjs4hWzIBpJL/q3IfWuLnTImhUrCuiKk18EdYwL6IhzFxpaVQo8k1FYxRL7
         84j4GmXtJfaN7gadvVfTatARa4syPZm7kvr5wQaxW7LadkRuhc+g/0MHT5JfWxm01q+q
         IlIlw/Xh3TFtz7WgtQJlPmPgcmDe0Wc50znfPNaITg3IB+UqaUtBBFHG0igu2K8kjbvP
         88Ew==
X-Gm-Message-State: AOAM5323YNMkmswsfUnTY3XK1fZmQOP5IZWobpAWHsIvx+ffn+DFzGOs
        6AyN0SGN20XagFxbeU/cWEclKXayFgPWdkMfrA4=
X-Google-Smtp-Source: ABdhPJxFXCtkOyMJIMoat3D9dT0ybxhuke07iM/5D6AvflAp+WzVaKMvoo51NO9x7izuegwKelTJ8Ol7NZO9CZRO7mM=
X-Received: by 2002:a63:ce15:: with SMTP id y21mr1956324pgf.4.1615974019297;
 Wed, 17 Mar 2021 02:40:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210310015135.293794-1-dong.menglong@zte.com.cn>
 <20210316224820.GA225411@roeck-us.net> <CAHp75VdE3fkCjb53vBso5uJX9aEFtAOAdh5NVOSbK0YR64+jOg@mail.gmail.com>
 <20210317013758.GA134033@roeck-us.net> <CADxym3bu0Ds6dD6OhyvdzbWDW-KqXsqGGxt3HKj-dsedFn9GXg@mail.gmail.com>
 <CAHp75Vfo=rtK0=nRTZNwL3peUXGt5PTo4d_epCgLChSD0CKRVw@mail.gmail.com>
In-Reply-To: <CAHp75Vfo=rtK0=nRTZNwL3peUXGt5PTo4d_epCgLChSD0CKRVw@mail.gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Wed, 17 Mar 2021 11:40:03 +0200
Message-ID: <CAHp75VcS0tEeDmDZA+mXs4mZRt-o39MHkxrgarB-O=6DTRjF1Q@mail.gmail.com>
Subject: Re: [PATCH v4 RESEND net-next] net: socket: use BIT() for MSG_*
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "dong.menglong@zte.com.cn" <dong.menglong@zte.com.cn>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 17, 2021 at 11:36 AM Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
> On Wed, Mar 17, 2021 at 10:21 AM Menglong Dong <menglong8.dong@gmail.com> wrote:

...

> It maybe fixed by swapping positions of the arguments, i.e. ~(FOO |
> BAR) & flags.

...and type casting will be needed anyway here...

I was thinking about this case

drivers/i2c/busses/i2c-designware-common.c:420:
dev->sda_hold_time & ~(u32)DW_IC_SDA_HOLD_RX_MASK
,

but sda_hold_time there is unsigned.

-- 
With Best Regards,
Andy Shevchenko
