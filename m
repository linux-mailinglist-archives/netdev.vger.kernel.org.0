Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38E5933F262
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 15:16:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231726AbhCQOPq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 10:15:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231648AbhCQOPc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 10:15:32 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E0ECC06174A;
        Wed, 17 Mar 2021 07:15:32 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id u4so3362051ljo.6;
        Wed, 17 Mar 2021 07:15:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gpCEjkMZEUC+j/o8wrSlaggSpGIA33fcqJm29MZK2L0=;
        b=QBGrnHjac18WK28E2rOZL5cV5Ia6MYPSykeLh81qaIbzp6GCFf2u2WCOEcKoJVpVR4
         hC6bqNvNQWltHeuEI6drnzoxmQ0t2Rdsgz4cxx5BBfWLQXdET9AYG0+HlMJnx/jEfUq6
         cHY6mKar0AUFhHu1Ke/OQYHW6OdnfxDW5p+WxJXKfMrDjBL4CB93//NPIC/npT6Nj9ot
         XXYIz5k0lFKfFBy9AYjQZg93lhmHEp+IvL4eo4JGibHZC9WRW2vyA3JdpWKk8Fn7/xuM
         FAQlSssyKhJKIcsfFnfPIQK7V0WnEfK85va7RAD5nxOw9emv48TsmVUBkqrOkycTudxV
         y8MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gpCEjkMZEUC+j/o8wrSlaggSpGIA33fcqJm29MZK2L0=;
        b=duhRE/KLVu/VTkdMW3n9QAj64EaUqurRTNfKbJct7FxhDxrtv0rAaTADgsvOlT1Ybp
         3IEgkvkV/DK4EG9UEkajfobl0RYOMbLD1CjkQGZZ7YJi/97UgOzze81KSB6S5kb0iFgi
         4YrTRoSCoOeI5d2zJGLClzzqgthh3e8xEcU/MwgPvAAUftcTJpcu6QQlMaYA4uVte6Vc
         FaT+NzOACWsHZFocNdI3DTrZ/c6THDUFIey05buugvQbIIELgOb9s2lKy3vb2S5LG8k6
         tx9Sz1SGozc+UrI6VcUhcaCAvjzfTrrqI/fiGzSkTlH3qx5byPHYyrnxNRGONdACQYKX
         pBbQ==
X-Gm-Message-State: AOAM533+QbfLKzDJuXLvNx1bsEhgoDsZl4xGIEbZ2bnpUnmNUlmUn0mZ
        vuSEtnuPhCAwBgnJEM457aeVIYbUdRvSr7lPs8TSS2tsv1o=
X-Google-Smtp-Source: ABdhPJyvTDdf8GNCcx3d2xJN323xPcFjXiTwpn5Es0DOdIuxeEJYBoUc/UZu7TXySMEzzj3iVyx1nOUMJQQWfAZRDCY=
X-Received: by 2002:a05:651c:1214:: with SMTP id i20mr2552046lja.423.1615990531034;
 Wed, 17 Mar 2021 07:15:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210310015135.293794-1-dong.menglong@zte.com.cn>
 <20210316224820.GA225411@roeck-us.net> <CAHp75VdE3fkCjb53vBso5uJX9aEFtAOAdh5NVOSbK0YR64+jOg@mail.gmail.com>
 <20210317013758.GA134033@roeck-us.net> <CADxym3bu0Ds6dD6OhyvdzbWDW-KqXsqGGxt3HKj-dsedFn9GXg@mail.gmail.com>
 <CAHp75Vfo=rtK0=nRTZNwL3peUXGt5PTo4d_epCgLChSD0CKRVw@mail.gmail.com> <CADxym3bHyaiy=kOhmxYdoMTZ_QaG9-JWqC1j6ucOBOeobVBoPg@mail.gmail.com>
In-Reply-To: <CADxym3bHyaiy=kOhmxYdoMTZ_QaG9-JWqC1j6ucOBOeobVBoPg@mail.gmail.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Wed, 17 Mar 2021 22:15:19 +0800
Message-ID: <CADxym3YKnwFce1D9w4xz83E8cRot1BMeTES8azJc1U3EJEeh7A@mail.gmail.com>
Subject: Re: [PATCH v4 RESEND net-next] net: socket: use BIT() for MSG_*
To:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Guenter Roeck <linux@roeck-us.net>,
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

On Wed, Mar 17, 2021 at 9:53 PM Menglong Dong <menglong8.dong@gmail.com> wrote:
>
...
>
> Seems that the inconsistent usages of 'msg_flags' is a lot, for example the
> 'recvmsg()' in 'struct proto' and 'recvmsg()' in 'struct proto_ops':
>
> int (*recvmsg)(struct sock *sk, struct msghdr *msg,
>         size_t len, int noblock, int flags,
>         int *addr_len);
>
> This function prototype is used in many places, It's not easy to fix them.
> This patch is already reverted, and I think maybe
> I can resend it after I fix these 'int' flags.
>

I doubt it now...there are hundreds of functions that are defined as
'proto_ops->recvmsg()'.
enn...will this kind of patch be acceptable? Is it the time to give up?

With Best Regards,
Menglong Dong
