Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BBF83FA133
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 23:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231998AbhH0Ve3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 17:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231807AbhH0Ve2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 17:34:28 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FC3EC06179A
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 14:33:39 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id x140so15169922ybe.0
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 14:33:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RZNyHeDVs2mzNxDgTuglWtbJQudBi+AgMRN4SZ0C/nY=;
        b=jVqEIc455Wtcw8ODTyXfnO/FQsEQDMK/It9z9OeJqHqx8p3YH0rnsTE3JppBBQ71ic
         hFAjlj8BEwrMpHu5dY26GEJrq9XNElRyt2SaSTsQQPeNiGInacBfUIwM47yAwiv52Cx6
         cb5GcXIKp71l+SHcuTn0XmplTlgeszW/UdUC5gCMt1xJKxkcd9fGDlAao5HTZ6N1Xrka
         x1jACeUhmZYPrTZV4Sdl2PwtBWU2wCwz958GvC5DQjFa8/08MAVUxdRtI1csFaIvGlK+
         lC13HteG3Oka7xoTpaaAHoKgIUm8l7vHSWN0P6G5nVDvLsPsESrPFwGNXA+XnpKiANxH
         gLzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RZNyHeDVs2mzNxDgTuglWtbJQudBi+AgMRN4SZ0C/nY=;
        b=GSsSImN7N4btIxcGHFkVIglPtG8hL/ftwSegErjIteuyqr13BUMQqap4xx7sJWOcgU
         agvCDBdFzXs1ziUpXJu/XKuEsjIhNPdgJp7HoP2RtTh0MZZM23TmaO/hCqTcIdKebuVo
         aEHcGHalm5D7Dfvp4d0gMvdf1KVwo+q5ul9GItATbSnBffQhQ9AMZCOMSL7bOhxlpPyt
         rQUXd4BdAuyMFmCNSrBP9WBe9HUDaOKBzErttcQhCpa6m+iS0pN2M9AqVz9K7P8Yc1PM
         b6a+F9W+5ZpjHUmm0tuJnPorxEw4bOzBIMKgJ4pc2RvXfSBkLg4kVOXEtUJwGhaO6D1b
         /0fQ==
X-Gm-Message-State: AOAM5332iwxq2aHh0CEnMQNW9TPgtExgzfsssA3JnzrmY4pZf/Gy+/9o
        MITWWBbDngXzklezQ6cKUT/JWYuuA2Y8R/SYcAAbSg==
X-Google-Smtp-Source: ABdhPJz5+dNvgc2ixHXOwcDeo8jDfMW8Ql6QvMwMVQ6iLfDyfXrrjgP9Mg+KHQk+aYDhygWXhbGhxIhyAShRq9e5qmw=
X-Received: by 2002:a25:d2c8:: with SMTP id j191mr8213434ybg.412.1630100018502;
 Fri, 27 Aug 2021 14:33:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210826074526.825517-1-saravanak@google.com> <20210826074526.825517-2-saravanak@google.com>
 <YSeTdb6DbHbBYabN@lunn.ch> <CAGETcx-pSi60NtMM=59cve8kN9ff9fgepQ5R=uJ3Gynzh=0_BA@mail.gmail.com>
 <YSf/Mps9E77/6kZX@lunn.ch> <CAGETcx_h6moWbS7m4hPm6Ub3T0tWayUQkppjevkYyiA=8AmACw@mail.gmail.com>
 <YSg+dRPSX9/ph6tb@lunn.ch> <CAGETcx_r8LSxV5=GQ-1qPjh7qGbCqTsSoSkQfxAKL5q+znRoWg@mail.gmail.com>
 <YSjsQmx8l4MXNvP+@lunn.ch> <CAGETcx_vMNZbT-5vCAvvpQNMMHy-19oR-mSfrg6=eSO49vLScQ@mail.gmail.com>
 <YSlG4XRGrq5D1/WU@lunn.ch>
In-Reply-To: <YSlG4XRGrq5D1/WU@lunn.ch>
From:   Saravana Kannan <saravanak@google.com>
Date:   Fri, 27 Aug 2021 14:33:02 -0700
Message-ID: <CAGETcx-ZvENq8tFZ9wb_BCPZabpZcqPrguY5rsg4fSNdOAB+Kw@mail.gmail.com>
Subject: Re: [PATCH v1 1/2] driver core: fw_devlink: Add support for FWNODE_FLAG_BROKEN_PARENT
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        Alvin Sipraga <ALSI@bang-olufsen.dk>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 27, 2021 at 1:11 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > > I've not yet looked at plain Ethernet drivers. This pattern could also
> > > exist there. And i wonder about other complex structures, i2c bus
> > > multiplexors, you can have interrupt controllers as i2c devices,
> > > etc. So the general case could exist in other places.
> >
> > I haven't seen any generic issues like this reported so far. It's only
> > after adding phy-handle that we are hitting these issues with DSA
> > switches.
>
> Can you run your parser over the 2250 DTB blobs and see how many
> children have dependencies on a parent? That could give us an idea how
> many moles need whacking. And maybe, where in the tree they are
> hiding?

You are only responding to part of my email. As I said in my previous
email: "There are plenty of cases where it's better to delay the child
device's probe until the parent finishes. You even gave an example[7]
where it would help avoid unnecessary deferred probes." Can you please
give your thoughts on the rest of the points I made too?

-Saravana
