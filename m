Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 496C93A5E3A
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 10:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232629AbhFNITs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 04:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232530AbhFNITr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 04:19:47 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDC14C061574;
        Mon, 14 Jun 2021 01:17:44 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id l4so6446761ljg.0;
        Mon, 14 Jun 2021 01:17:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f5Jp7erhWbJZ5+XSgSsBZF1Q+dz9Itr2uV4OBRRsdC8=;
        b=bZi5B8thvLyqDRJYtVqVlXEcW/9SPCjHKySHjl5Z3P96ady14ZNgfE5hW9D1NHQlHo
         sZ+xz7jfk7C+pSo1adb78JeSvcKOYFscRLz3C+U6+tOMkMRl/JrX7m0C22ISFqZlsJ3D
         NZG01kq2aDkgwl8RW45yDhR2Yf34gMO4UVrGxChIXyskKfJMXOmuotCdZps+bsJ2rGyJ
         lqtRD00X3shgCvM88jH/F7Z/KzZWeXB+HY0b1sP4ACJafI/ThlqmgmTQJGlj+mab2+gE
         nqxZDwCwishPFA5TsmfvjXOEBv3drNb47dQYwxZRUB5JnL8VRSLTVj17FfUhr4jekLIC
         lg1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f5Jp7erhWbJZ5+XSgSsBZF1Q+dz9Itr2uV4OBRRsdC8=;
        b=VCmpt4rxMZPmmmNw7mpE6eKVBIKlUNjezTAafXFGXjq/5tcUZKtduOCYIuneMj0W5q
         7PYy4TsXclNv5CGw0mb6mk7W5xdpb7iRUI06cc9CsPD+HzjvUTDe8v1lIXRq3pFfEEe1
         6nj5XiHngHqkcwIk2dQVXcXC+dZyrufk9XNiTDt7G73GRDBc3uDe8WFxQiT64GOXYbUc
         4dG12KW5zzeFFac60SKzz4/VBqv9nNgi8ATysBB6QUXcIwfgOysytlDCy+zkRGqbF0Om
         xXAB9KIY1W48xx04d/vaat4DRiqupS/JYiVOBX2aZQrE1080/PVohm4bRW/LkgKKoT7h
         PmEQ==
X-Gm-Message-State: AOAM530KWD7pxNYvrUCDsMTEgTGqd9SGQMX0bms+CY1Mpyhjdal2RnfW
        wlUuw7RgW6I/X5o1QUWI4tYwt7eml3aSdTimGw==
X-Google-Smtp-Source: ABdhPJyRr56ya1c+rK9ezq+7JqOn63buDppcbORgtGLvt571A8HhQHeqv24NcTXaBgSk4SUs8zBHiKzv/DG0ZLshoZ4=
X-Received: by 2002:a2e:b614:: with SMTP id r20mr12881018ljn.382.1623658663145;
 Mon, 14 Jun 2021 01:17:43 -0700 (PDT)
MIME-Version: 1.0
References: <3494dcf6-14ca-be2b-dbf8-dda2e208b70b@ti.com> <20210610004342.4493-1-praneeth@ti.com>
 <YMGP/aim6CD270Yo@lunn.ch> <CAHvQdo0YAmAo_1m7LgLS200a7fNz-vYJkwR74AxckQm-iu0tuA@mail.gmail.com>
 <e4f3a1c2-069e-b58a-eadf-b5505fb42e02@ti.com>
In-Reply-To: <e4f3a1c2-069e-b58a-eadf-b5505fb42e02@ti.com>
From:   Johannes Pointner <h4nn35.work@gmail.com>
Date:   Mon, 14 Jun 2021 10:17:32 +0200
Message-ID: <CAHvQdo1U_L=pETmTJXjdzO+k7vNTxMyujn99Y3Ot9xAyQu=atQ@mail.gmail.com>
Subject: Re: [PATCH v2] net: phy: dp83867: perform soft reset and retain
 established link
To:     "Bajjuri, Praneeth" <praneeth@ti.com>,
        Geet Modi <geet.modi@ti.com>, Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Praneeth,

On Fri, Jun 11, 2021 at 7:05 PM Bajjuri, Praneeth <praneeth@ti.com> wrote:
>
> Hannes,
>
> On 6/10/2021 12:53 AM, Johannes Pointner wrote:
> > Hello,
> >
> > On Thu, Jun 10, 2021 at 6:10 AM Andrew Lunn <andrew@lunn.ch> wrote:
> >>
> >> On Wed, Jun 09, 2021 at 07:43:42PM -0500, praneeth@ti.com wrote:
> >>> From: Praneeth Bajjuri <praneeth@ti.com>
> >>>
> >>> Current logic is performing hard reset and causing the programmed
> >>> registers to be wiped out.
> >>>
> >>> as per datasheet: https://www.ti.com/lit/ds/symlink/dp83867cr.pdf
> >>> 8.6.26 Control Register (CTRL)
> >>>
> >>> do SW_RESTART to perform a reset not including the registers,
> >>> If performed when link is already present,
> >>> it will drop the link and trigger re-auto negotiation.
> >>>
> >>> Signed-off-by: Praneeth Bajjuri <praneeth@ti.com>
> >>> Signed-off-by: Geet Modi <geet.modi@ti.com>
> >>
> >> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> >>
> >>      Andrew
> >
> > I reported a few days ago an issue with the DP83822 which I think is
> > caused by a similar change.
> > https://lore.kernel.org/netdev/CAHvQdo2yzJC89K74c_CZFjPydDQ5i22w36XPR5tKVv_W8a2vcg@mail.gmail.com/
> > In my case I can't get an link after this change, reverting it fixes
> > the problem for me.
>
> Are you saying that instead of reset if sw_restart is done as per this
> patch, there is no issue?
In my case(DP83822 connected to an i.MX6) if the digital(SW) restart
is used (Bit 14) I have the issue that I can' get a link.
ip addr shows:
1: lo: <LOOPBACK> mtu 65536 qdisc noop qlen 1000
   link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: eth0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc pfifo_fast qlen 1000
   link/ether 00:60:65:54:32:10 brd ff:ff:ff:ff:ff:ff

If I revert this back to using the SW reset (Bit 15) it works again.

Regards,
Hannes
