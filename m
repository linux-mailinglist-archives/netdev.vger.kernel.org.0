Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A427294E7B
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 16:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2443447AbgJUOXN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 10:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2442847AbgJUOXM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 10:23:12 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4B43C0613CE;
        Wed, 21 Oct 2020 07:23:12 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id m22so1974572ots.4;
        Wed, 21 Oct 2020 07:23:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qjwRFR9+DVMdexTdUNgx5g1bJ7um932k+2im+PVjM5M=;
        b=Cec+XKIjuVF7NrU5Jn3c1em3s/DtISpzwZaoGp2I5S8IuT7dr+SApPrZ22JjIVydUB
         GvxFYScjirjwR5106VcVWSU8RELtz2bfAJQAqnx+m/Wtzjv9eL74X899yTMHLAh6C1lk
         0ivLgDLGEQCs4gjyY+utrybPgZsoKj063UZdpAoiIzXFxmxsyZvh/jozOeNrvN/dZNBU
         2Q36Rc0jV5pBJ9xFMWB4cyQqHnamM4qfYw1+X7Ahih2Q+jjaARmFm6VLFtRP5+vIo8sh
         QC8sdTT2dYvPFU8/hl8f2X7aStvY6TqrT0rfY+/c7sQI8OusKbegNtfhYUnti5FLbl/y
         mqeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qjwRFR9+DVMdexTdUNgx5g1bJ7um932k+2im+PVjM5M=;
        b=fJ8IQK4CaBzIc4J9V2Ol97hepjrdtVoaXnqZlfCZdn7X7O/yuOU2iQEaOXanuee8jh
         Sz/IC48anQJiISBZmQjiyMD9PpjTCzK6KNS0vUS289ZRFZY7v4gkluI+KcU7wl1jPkQe
         7I92kMwBPTfbhaiw13kO1Ogd589RFvGkBCrtNyflFv5bHM2YEQPQd7u9NHKcWVhF64F6
         5C6kdbutWhh1y2zB9wL1mDjRWU9n3vvNzGvcsiKILkJ3BqhmwcZdOD7hzvGidwikn17s
         PBZsUz6OJt54XYTVl7fkab+VZo6tMZi1wAwsu+eTue/Sy3Zwlg6TIE+NFVr2HyY4uOTq
         wjnA==
X-Gm-Message-State: AOAM533cwUFW/p4p3jer0rLXIX47rAoRz0WfjdcgKzd11CrCNFaTS7gU
        ZyA2LKsIov9s8v9bNU3myqZa8iLKTxBoVWD9onQ=
X-Google-Smtp-Source: ABdhPJy14GHvBmnHtWpHKx8pr7r4KJMhVCOvw8lp9YX3oK/seimfYX7CNXf7X0g+mQK9jsk2DBdr0E0CJTluG7UwYCo=
X-Received: by 2002:a05:6830:2153:: with SMTP id r19mr2690572otd.207.1603290191675;
 Wed, 21 Oct 2020 07:23:11 -0700 (PDT)
MIME-Version: 1.0
References: <20201021135140.51300-1-alexandru.ardelean@analog.com>
 <20201021135802.GM139700@lunn.ch> <CA+U=DsoRVt66cANFJD896R-aOJseAF-1VkgcvLZHQ1rUTks3Eg@mail.gmail.com>
 <20201021141342.GO139700@lunn.ch>
In-Reply-To: <20201021141342.GO139700@lunn.ch>
From:   Alexandru Ardelean <ardeleanalex@gmail.com>
Date:   Wed, 21 Oct 2020 17:23:00 +0300
Message-ID: <CA+U=DsoEbrYn8i+GcLBzNHLY7xbKLOnZOLo00r7YwcQ_rXF94w@mail.gmail.com>
Subject: Re: [PATCH 1/2] net: phy: adin: clear the diag clock and set
 LINKING_EN during autoneg
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Alexandru Ardelean <alexandru.ardelean@analog.com>,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>, linux@armlinux.org.uk,
        David Miller <davem@davemloft.net>, kuba@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 21, 2020 at 5:13 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > The frame-generator is an interesting feature of the PHY, that's not
> > useful for the current phylib; the PHY can send packages [like a
> > signal generator], and then these can be looped back, or sent over the
> > wire.
>

removed my typo-ed [work] email
i use gmail as a mirror-email for my work email, because.... reasons
and i added my work-email to the --cc list with a typo, because the
universe seems to have wanted that [in a manner of saying it]

> Many PHYs that that. I posted some patches to the list a few years ago
> adding basic support for the Marvell PHY frame generator. They got
> NACKed. The netlink API, and some of the infrastructure i added for
> cable testing would make it possible to fix the issues that caused the
> NACK.

i'll think about the frame-generator;

i was super-happy when the cable-test support was added;
when i first wrote the PHY, i actually wrote this logic for
cable-testing, then scrapped it because the code [without any
framework around it] just looked bad, and like it was asking to cause
trouble;

with this minimal framework in place, cable-testing looks like a neat
feature [and neatly implemented];
and it took me less than a day to write and test it;
so, thank you for this :)

>
> > Having said this, I'll include some comments for these in a V2 of this patchset.
>
> Thanks.
>
>         Andrew
>
> P.S.
>
> Your mail is broken somehow:
>
> Delivery has failed to these recipients or groups:
>
> alexaundru.ardelean@analog.com
> The email address you entered couldn't be found. Please check the recipient's
> email address and try to resend the message. If the problem continues, please
> contact your email admin.
