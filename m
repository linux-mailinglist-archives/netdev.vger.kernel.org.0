Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 874322C025D
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 10:39:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbgKWJg5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 04:36:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725275AbgKWJg4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 04:36:56 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CB30C0613CF;
        Mon, 23 Nov 2020 01:36:56 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id b6so3935497pfp.7;
        Mon, 23 Nov 2020 01:36:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LoHYGvz7BTMS2beu4vcf2km2aXO54uIdqhk7iR0tRXo=;
        b=gjKK+jfD3wcBFkFwYwGRGqY2VZyOTNowyhcwkXXJVW+/62mwFrHik+SbBG3lqiQm2h
         nTwwxoOG+i61bAwRePrnuYSO+x30xWNAdkoTX8gvm/byF56yoyHaKJJ6LiRN+Nr6a9jn
         8D8WsAfAPl97V9WhsxwPqL/VvYF4sE9noj2fPqngcfHh0hFueP7KPe0cNsBgmci2TDTV
         HFSEV0d3EoMQ79G6XeUbYxEmYvNRxetdoQTHTY3j4T6YPelQGEXB+xvw+74SvxIbj3Yr
         otwIUXJxxqQKcnhSYZt3l0h8zp/fe2LEZy1DZtpRRKojZSh1wZF8yuzI85v54vMZh6SR
         vVCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LoHYGvz7BTMS2beu4vcf2km2aXO54uIdqhk7iR0tRXo=;
        b=GI1UlJShwhzUlQnCJ4s9R4qxr1sbOnZ3dQBrMG2OCI+a57gVV0k5s3slKPKSxzNtHD
         Mc+bRcjHcr1VN8syqQwLCZQc8q/iWC3NcMQMG6GGp7rKBKZ9x4OSkWrOxI4VTewI2kP6
         0VrNEZN4Z7gLIjsL3R00Isv7vPQUS2SQvNU5+mGokpvSfA2Zw+ATT6WzUxr0mOjzRMcY
         KHwNo9zdXlstrz0/eSjXvUOpjJ83jFVkOlcysnJwkxeEIk8gz7IUY+kE3jpYs6P+s5z/
         Ifl7X+JqHY5TN1fOUYVx25M2ld+BOdV/1W81AyXSgII/6zYlSW30VRAtoqwdRC6qN/XL
         zyNQ==
X-Gm-Message-State: AOAM532UObRyBp8tBz0HQwpsG7GLKiQw4wIxeBdhcFElERr1fFE4K1C6
        6obU+J3Tcd5xHpzeRj8ZYb66SAa1rls0j7DQwzI=
X-Google-Smtp-Source: ABdhPJz5Fi/Lh1bG32uk+0n0ZpwsEhQ3t6C7Bi2G1uiZ8iMUMiH9VfPQfzB5M0sXkvPe6A/kSUV1KyB5V0uDWh5vWhQ=
X-Received: by 2002:a65:560b:: with SMTP id l11mr27840038pgs.63.1606124215873;
 Mon, 23 Nov 2020 01:36:55 -0800 (PST)
MIME-Version: 1.0
References: <20201120054036.15199-1-ms@dev.tdt.de> <20201120054036.15199-3-ms@dev.tdt.de>
 <CAJht_EONd3+S12upVPk2K3PWvzMLdE3BkzY_7c5gA493NHcGnA@mail.gmail.com>
 <CAJht_EP_oqCDs6mMThBZNtz4sgpbyQgMhKkHeqfS_7JmfEzfQg@mail.gmail.com>
 <87a620b6a55ea8386bffefca0a1f8b77@dev.tdt.de> <CAJht_EPc8MF1TjznSjWTPyMbsrw3JVqxST5g=eF0yf_zasUdeA@mail.gmail.com>
 <d85a4543eae46bac1de28ec17a2389dd@dev.tdt.de>
In-Reply-To: <d85a4543eae46bac1de28ec17a2389dd@dev.tdt.de>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Mon, 23 Nov 2020 01:36:45 -0800
Message-ID: <CAJht_EMjO_Tkm93QmAeK_2jg2KbLdv2744kCSHiZLy48aXiHnw@mail.gmail.com>
Subject: Re: [PATCH net-next v4 2/5] net/lapb: support netdev events
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     Andrew Hendry <andrew.hendry@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 23, 2020 at 1:00 AM Martin Schiller <ms@dev.tdt.de> wrote:
>
> AFAIK the carrier can't be up before the device is up. Therefore, there
> will be a NETDEV_CHANGE event after the NETDEV_UP event.
>
> This is what I can see in my tests (with the HDLC interface).
>
> Is the behaviour different for e.g. lapbether?

Some drivers don't support carrier status and will never change it.
Their carrier status will always be UP. There will not be a
NETDEV_CHANGE event.

lapbether doesn't change carrier status. I also have my own virtual
HDLC WAN driver (for testing) which also doesn't change carrier
status.

I just tested with lapbether. When I bring up the interface, there
will only be NETDEV_PRE_UP and then NETDEV_UP. There will not be
NETDEV_CHANGE. The carrier status is alway UP.

I haven't tested whether a device can receive NETDEV_CHANGE when it is
down. It's possible for a device driver to call netif_carrier_on when
the interface is down. Do you know what will happen if a device driver
calls netif_carrier_on when the interface is down?
