Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 248FD33FCCF
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 02:50:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230433AbhCRBtB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 21:49:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbhCRBs2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 21:48:28 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 141C0C06174A;
        Wed, 17 Mar 2021 18:48:28 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id ce10so1390378ejb.6;
        Wed, 17 Mar 2021 18:48:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t3RAT6WWF12iLuNKN5O9izN5JXYqyFOKmhP4w/1gIvs=;
        b=KAf5vCHxZ+LGWnvAF0wNSlJSJS8M05UAhK2M4K7gbWquHsJ8Q5m/RoBDKwYeTjuOgw
         zYZFAUYM7OLhlMNlLKR4LPUoH13QTLqwU8qaLRQxyw5xN+Hk9vOr/u6Pxbcg/3FWy13J
         m6/WimxWPc4CuLF8QCUAH4qgsJ8glzAuj9UkSaalqmqzCzSL1IFK91vI8XpjUUn9QOQl
         4ceTlXja6TCpdpPT6bfeU18Ks4LiYlhf4KOkfQdGJHmzJVCz2UXVs6hGm+bLKri8rmxn
         2z7GegXcIVwc+sdil+49ge+6mo62ai+42Wx/sUVkM0P+IEf2zYZ0a7cvhvP+zeONYJV/
         CUYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t3RAT6WWF12iLuNKN5O9izN5JXYqyFOKmhP4w/1gIvs=;
        b=L3HVTc+SWpGd4fW1DpboKiBO68uziySI7m8r6dBrLm7Im2YMBbDF4cJakBXCfz2vxq
         387N+rYOaJqsaCwVXnMmP0i2kkGigAKO/ZqCdH5RaZujkKVfz6JZhc35FAFe+5qtzyrr
         qNxgYP12xN4xigIJxdqk8SpUq8eMLwZnl6MwbnHAVQ2PR/h64ulxoRDJC7CIB99QilSf
         83zANsgztl7O+GEhhbVjqkn+pHqfWnV4+KwzVs7Fqrg4RHQxu2ATHx7ixntwbfxH3+M0
         t5uyz3o82H+0FShLD6z9lxh3Tp2HgT+kt3U2ovkWUCJ+esWAPuqhmhbb4xu6/Rp+TGvD
         5Aqg==
X-Gm-Message-State: AOAM530Z/sPMue4V959vTTcIIQiujAfDjVhWkM32U2q4q31r45P9op9Q
        gNcpzzyOPYZ38thOV+1NBoeTFnGRY2oU3FLxaQ0=
X-Google-Smtp-Source: ABdhPJzVg6tWqJuhA3G7pRj27RasPQpe0z/NFJ9MvcD9uD4dzpp/dEka8azvqQLCdMOV8IFvzuyEZDKWqL5sEydAVUI=
X-Received: by 2002:a17:907:162b:: with SMTP id hb43mr39426369ejc.41.1616032106913;
 Wed, 17 Mar 2021 18:48:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210310015135.293794-1-dong.menglong@zte.com.cn>
 <20210316224820.GA225411@roeck-us.net> <CAHp75VdE3fkCjb53vBso5uJX9aEFtAOAdh5NVOSbK0YR64+jOg@mail.gmail.com>
 <20210317013758.GA134033@roeck-us.net> <a4dbb6f5b86649e2a46878eb00853f44@AcuMS.aculab.com>
In-Reply-To: <a4dbb6f5b86649e2a46878eb00853f44@AcuMS.aculab.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Thu, 18 Mar 2021 09:48:14 +0800
Message-ID: <CADxym3bwqs9e2WKX8uOTzyYKnyTgmW4FT+N2m5hydfBJV3fqXQ@mail.gmail.com>
Subject: Re: [PATCH v4 RESEND net-next] net: socket: use BIT() for MSG_*
To:     David Laight <David.Laight@aculab.com>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
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

On Wed, Mar 17, 2021 at 11:12 PM David Laight <David.Laight@aculab.com> wrote:
>
...
>
> Isn't MSG_CMSG_COMPAT an internal value?
> Could it be changed to 1u << 30 instead of 1u << 31 ?
> Then it wouldn't matter if the high bit of flags got replicated.
>

Yeah, MSG_CMSG_COMPAT is an internal value, and maybe
it's why it is defined as 1<< 31, to make it look different.

I think it's a good idea to change it to other value which is
not used, such as 1u<<21.

I will test it and resend this patch later, thanks~

With Regards,
Menglong Dong
