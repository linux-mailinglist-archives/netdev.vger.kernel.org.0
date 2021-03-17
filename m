Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1810333F1DC
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 14:54:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231528AbhCQNxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 09:53:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231512AbhCQNxg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 09:53:36 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC428C06174A;
        Wed, 17 Mar 2021 06:53:35 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id 20so3053244lfj.13;
        Wed, 17 Mar 2021 06:53:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aq/73TPDwz11pwoOS9ndvgWShmQVCgtX2IbCysGWuy8=;
        b=kKzAla3XFykBIfQ/U+UVyQLoTHNF+1yEutb87wa1p9feTM21RhBCeK67YDV/LKT23g
         1N46UiGHyitru2CrH5cYI4S3OaHtJw1BnkJhNWDYQrkFWmtXsLNBUYnagc+e+wP2L7ax
         7pEdbAEuATEJqPz/qHSUjPSFNsQtmRMamEkPeDQ0+DJswLkxpyax4n0xkS2JuG4Rg8ef
         ejn1QXd4Rj8EQduzyRunS7uWpCG4dgld+OdSadWci4CDk8mkaqmaEfAAVHqmYamDKXI0
         y2OteH7hSyi14AFbxCS3qO80D/kJMdrS6O/FMEUfQN2NE2zIPOo81q3GrL2miPw4eS7m
         zYbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aq/73TPDwz11pwoOS9ndvgWShmQVCgtX2IbCysGWuy8=;
        b=IEe9Iz4+tkAviY9qrqhGOx/mdQ3tGzw9C8os3qKzsab9a+jsnYDx1exBbpThBZyFcr
         tK0uI29HpmHpgKAJtOtJdL7pr5i2LhF2/4HX9xGJcieCxoH+0EjIp208sIyb8SO2yq/S
         YE0ILbzp6E4JyZFDTBs6PALBpmCU+Q3kmY2qcgrhmh9/PACdcAkG0l3k2L2XmrVt+5K4
         amicdci55NpsD7dsY/MMqP3WDRfN05TzW3bk0Uox2Utrk8iu2vVqxekA0tBLvcbWfgYn
         OsALybLuvZJAJSbt3WQRCkLiJ05W6r9cDjksqn55daUHhgorm6TUaBy0DPcPmhqVuVDv
         ugTA==
X-Gm-Message-State: AOAM532XyRNYYmGQN238tJwkivKfM5OR2usDa0HQUosafANHdselz43c
        V0fAVcK5gC+26MDRzyIxoJD1vmJlemdJfOyRmyiuXxSB8SM=
X-Google-Smtp-Source: ABdhPJxcO47AXoUjjwUtemm8UYA54YK8YqdEt2PSOdGghyUci4dUNbRxBtB70emIuxvORqoZ4WDk7p2oZerpC4HiyZ8=
X-Received: by 2002:a19:6d07:: with SMTP id i7mr2434139lfc.568.1615989214339;
 Wed, 17 Mar 2021 06:53:34 -0700 (PDT)
MIME-Version: 1.0
References: <20210310015135.293794-1-dong.menglong@zte.com.cn>
 <20210316224820.GA225411@roeck-us.net> <CAHp75VdE3fkCjb53vBso5uJX9aEFtAOAdh5NVOSbK0YR64+jOg@mail.gmail.com>
 <20210317013758.GA134033@roeck-us.net> <CADxym3bu0Ds6dD6OhyvdzbWDW-KqXsqGGxt3HKj-dsedFn9GXg@mail.gmail.com>
 <CAHp75Vfo=rtK0=nRTZNwL3peUXGt5PTo4d_epCgLChSD0CKRVw@mail.gmail.com>
In-Reply-To: <CAHp75Vfo=rtK0=nRTZNwL3peUXGt5PTo4d_epCgLChSD0CKRVw@mail.gmail.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Wed, 17 Mar 2021 21:53:23 +0800
Message-ID: <CADxym3bHyaiy=kOhmxYdoMTZ_QaG9-JWqC1j6ucOBOeobVBoPg@mail.gmail.com>
Subject: Re: [PATCH v4 RESEND net-next] net: socket: use BIT() for MSG_*
To:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>
Cc:     Jakub Kicinski <kuba@kernel.org>,
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

On Wed, Mar 17, 2021 at 5:36 PM Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
>
...
>
> The problematic code is negation of the flags when it's done in
> operations like &.
> It maybe fixed by swapping positions of the arguments, i.e. ~(FOO |
> BAR) & flags.
>
> All this is a beast called "integer promotions" in the C standard.
>
> The best is to try to get flags to be unsigned. By how invasive it may be?

Seems that the inconsistent usages of 'msg_flags' is a lot, for example the
'recvmsg()' in 'struct proto' and 'recvmsg()' in 'struct proto_ops':

int (*recvmsg)(struct sock *sk, struct msghdr *msg,
        size_t len, int noblock, int flags,
        int *addr_len);

This function prototype is used in many places, It's not easy to fix them.
This patch is already reverted, and I think maybe
I can resend it after I fix these 'int' flags.

>
> --
> With Best Regards,
> Andy Shevchenko

Thanks!
Menglong Dong
