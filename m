Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91FCE2C9375
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 00:59:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730757AbgK3X7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 18:59:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730746AbgK3X7Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 18:59:16 -0500
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57E9EC0613D3;
        Mon, 30 Nov 2020 15:58:30 -0800 (PST)
Received: by mail-ot1-x342.google.com with SMTP id f16so13107082otl.11;
        Mon, 30 Nov 2020 15:58:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=19obYtiEoANDXfw8TQxHN8TKiK3RihhXUr7p4K37zSg=;
        b=FdoUeC8tvJPllRTvtTebQuH9ZLBI72rvP6KlMjW1wtIezQuE1ydEnRHxiD/P7Ysv68
         YWC8zOErlyOQfb6ISo4BkYGVxHhv2wB58UiY8WVmKEgRprsH1M7F4OF8QLNRXyCzLZdH
         QkP0XUOOz2HEBTWW0c3YO/HnnaCTdZIegAzgf3XzPzhApMnfVFts27JcBbI5twC6gVej
         oxNtqw0cQmQy32fFW/o0IqwJMbPrBacTbLHG4ipPtR/GyP5bMrQSLyEiXIH0/ktKhDmX
         gE64UBMhS7oLC/6sT8FwtcivJ7M+z9nCAJPplixif+ox1tHVTyZMjTDZ1b2aGkB3lTPs
         koYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=19obYtiEoANDXfw8TQxHN8TKiK3RihhXUr7p4K37zSg=;
        b=ZqHzUdh4K5sn3CytIu45XogGtf1mCYf+3tQFAdA7kQRBTopFKBkQO/xPdadWZVF/X3
         oPVXcQVzX3MwKAtHa6y8Og/8x8r8Y5T715HaOMAh8rGPb/zORCvZGRnnh2uI318kMy/e
         LSNBLe0DLC5ztuxhSWfgDDCBZ0pwUt31WKZLZcr2T8tFuFAxK12YkaXiy/Mgc0Ch6R0h
         sB1apC60V4VvbDkPyp1cDC/CRS75mTpC722yDQrVMKcMxb13029p4lYO1Aou2iixwdfc
         2nrOQAsmXvBqYPR/bTNcBQ2TFm6LYYJpeE4WM97L/TPb1jJmlJ6ym/zPdySxBPFbucgZ
         Z/kg==
X-Gm-Message-State: AOAM530I9wI9AddEiXAqfo9JdSchX6xms4xqbq7GKKGvjhMB68cnZ+PI
        302vuiPYsa/FMHnWDT6B/Six1VHJie/d3BMOEA==
X-Google-Smtp-Source: ABdhPJybHi/oBmvGwIXe7HN9sskKwGocZqhQWGVCtALsHULjs+JLcJbRyZIfzUcbQpXCGOS5G9OG5DQWp+0+OyDZrA0=
X-Received: by 2002:a05:6830:1f11:: with SMTP id u17mr19132850otg.287.1606780709746;
 Mon, 30 Nov 2020 15:58:29 -0800 (PST)
MIME-Version: 1.0
References: <20201127195057.ac56bimc6z3kpygs@skbuf> <CAFSKS=Pf6zqQbNhaY=A_Da9iz9hcyxQ8E1FBp2o7a_KLBbopYw@mail.gmail.com>
 <20201127133753.4cf108cb@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <20201127233048.GB2073444@lunn.ch> <20201127233916.bmhvcep6sjs5so2e@skbuf>
 <20201128000234.hwd5zo2d4giiikjc@skbuf> <20201128003912.GA2191767@lunn.ch>
 <20201128014106.lcqi6btkudbnj3mc@skbuf> <20201127181525.2fe6205d@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <CAFSKS=O-TDPax1smCPq=b1w3SVqJokesWx02AUGUXD0hUwXbAg@mail.gmail.com> <20201130235031.cdxkp344ph7uob7o@skbuf>
In-Reply-To: <20201130235031.cdxkp344ph7uob7o@skbuf>
From:   George McCollister <george.mccollister@gmail.com>
Date:   Mon, 30 Nov 2020 17:58:17 -0600
Message-ID: <CAFSKS=NR6Toww7xj797Z09FNDXYawPFbbavv8hTzXJ2KFki=hg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 2/3] net: dsa: add Arrow SpeedChips XRS700x driver
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 30, 2020 at 5:50 PM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Mon, Nov 30, 2020 at 10:52:35AM -0600, George McCollister wrote:
> > Another possible option could be replacing for_each_netdev_rcu with
> > for_each_netdev_srcu and using list_for_each_entry_srcu (though it's
> > currently used nowhere else in the kernel). Has anyone considered
> > using sleepable RCUs or thought of a reason they wouldn't work or
> > wouldn't be desirable? For more info search for SRCU in
> > Documentation/RCU/RTFP.txt
>
> Want to take the lead?

I certainly could take a stab at it. It would be nice to get a
"doesn't sound like a terrible idea at first glance" from Jakub (and
anyone else) before starting on it. Maybe someone has brought this up
before and was shot down for $reason. If so that would be nice to
know. Of course it's possible I could also find some reason it won't
work after investigating/implementing/testing.
