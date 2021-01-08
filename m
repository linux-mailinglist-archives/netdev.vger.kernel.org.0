Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D68C2EEF47
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 10:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727965AbhAHJOy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 04:14:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727706AbhAHJOx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 04:14:53 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4A24C0612F5
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 01:14:13 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id r9so9068458ioo.7
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 01:14:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ANFAxpR1KmVYZRMsBfJrSXGetc0aK7ns7PZcCoobIOI=;
        b=UOMrh4+5ROexH+001+WzvQ0u1k6A/dW5wJ/m3MUc8F17uYjVH3QPwafbBFPnnDS2wl
         MOWa0M8eavSPCaOG3NYMTVHQmhW1IJiUfFUmmFZ4zTJOxpNSv65Et4jCI6mCg+jg9jSO
         w2VhNGKTRIGSHDXrLDeuwlF2c9ekVt9EG8E1U22Ow9XxbiqhO+Y3Fh/DqC5sSrOLHc2D
         +GJMYFP7B3InKVXytaRgug97Nr6soPgQkGwWRZxFFNbSGs6fXrO9KiWSpC4FooZXH9UL
         dvZCiwFsP4bk5aT36atL2g+0/+fy1gXCH0OJQjnOQzoey2dvToIZ0/6JYit+PdryCKV1
         ofkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ANFAxpR1KmVYZRMsBfJrSXGetc0aK7ns7PZcCoobIOI=;
        b=uNQv2zuH9Ca8IVxfvH1+hRn5XALd4ZW4jU1TyD0VBiCOx6RQiWcUFKtz/quzK5snAK
         1DL3V75lQBM0nc83ZUKzhj3zc16uLrMJOtdRxz3zGgHVqlvrBI9CaOh+74+jl6OLNZsK
         9jxeu87b2Td593FGz4Um3ibB/kLZ7zqLEJ9GkNwSXg9TA3QErnwCjJD1feU5LsWH7ZDI
         9ikGOo5Z8PsYF9gwp0ZkP/J35cMordUYjfR6QzAutpVRTVArF3j3w6uLou4dwKoydHP/
         gzrdZXEKUpUFOjk9wjhOhV/amEy9T1ir/beS841IZlxitxDsXA1RIFQarNO9wvnkx/9K
         gsDA==
X-Gm-Message-State: AOAM533biwvDwMDuBrb+yui/u1nEPBuvwprFx7mWYKpL52DBUWoHiq8W
        DfUvEDincgKA7o3SivdqMg3DQhVz728tLmySwzrM7w==
X-Google-Smtp-Source: ABdhPJx0A4lDHhKR35y5UFLLSykpnBnx6NHagQcnvpWeX7VOClmkiyjXBixSlnICGywP981yhAMBux9aiNepR5fvUF4=
X-Received: by 2002:a6b:928b:: with SMTP id u133mr4658179iod.145.1610097252930;
 Fri, 08 Jan 2021 01:14:12 -0800 (PST)
MIME-Version: 1.0
References: <20210107094951.1772183-1-olteanv@gmail.com> <20210107094951.1772183-11-olteanv@gmail.com>
 <CANn89i+NfBw7ZpL-DTDA3QGBK=neT2R7qKYn_pcvDmRAOkaUsQ@mail.gmail.com>
 <20210107113313.q4e42cj6jigmdmbs@skbuf> <CANn89iJ_qbo6dP3YqXCeDPfopjBFZ8h6JxbpufVBGUpsG=D7+Q@mail.gmail.com>
 <ac66e1838894f96d2bb460b7969b6c9b903fee6a.camel@kernel.org>
In-Reply-To: <ac66e1838894f96d2bb460b7969b6c9b903fee6a.camel@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 8 Jan 2021 10:14:01 +0100
Message-ID: <CANn89iLm7nwckUVjoHsH-gYwQwEsscK+D2brG+NgndLZaUy_5g@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 10/12] net: bonding: ensure .ndo_get_stats64
 can sleep
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Arnd Bergmann <arnd@arndb.de>, Taehee Yoo <ap420073@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, Florian Westphal <fw@strlen.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 8, 2021 at 4:59 AM Saeed Mahameed <saeed@kernel.org> wrote:
>
> Eric, about two years ago you were totally against sleeping in
> ndo_get_stats, what happened ? :)
> https://lore.kernel.org/netdev/4cc44e85-cb5e-502c-30f3-c6ea564fe9ac@gmail.com/
>
> My approach to solve this was much simpler and didn't require  a new
> mutex nor RTNL lock, all i did is to reduce the rcu critical section to
> not include the call to the driver by simply holding the netdev via
> dev_hold()
>

Yeah, and how have you dealt with bonding at that time ?

Look, it seems to me Vladimir's work is more polished.

If you disagree, repost a rebased patch series so that we can
test/compare and choose the best solution.

And make sure to test it with LOCKDEP enabled ;)

Thanks.
