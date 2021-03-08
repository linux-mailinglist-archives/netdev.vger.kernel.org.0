Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36A33330F09
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 14:21:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbhCHNUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 08:20:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbhCHNUv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 08:20:51 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5FDEC06174A
        for <netdev@vger.kernel.org>; Mon,  8 Mar 2021 05:20:50 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id d13so14744858edp.4
        for <netdev@vger.kernel.org>; Mon, 08 Mar 2021 05:20:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zhCiN8fI1/KzlZ5INmA1OSCbj6B41Sh5hvx8ikQAQ0M=;
        b=E7HxvMmpJwY26NhSvjO5eJzUhgkhL8E5jpuCNt8ZPxhay2h5Jq531MOfGauUeOHVOO
         V+GnhxIewtTroPj3mimfcG4RcbQgZfnfM8eNNbm7zCSSWg5UXu/JgwVGrgJ9Vf3ftVuh
         vEr6+SLBfyddWxHvf5vgaSLcPLZ5qlnETu56/9ocrYVcpbrJbDj6/QdfnYBjVkuFS+xn
         UojRZEw2vDiK5HLriBdt992yFN7q54rje87Pc+blWxbFCK85+lemP8AdXCd2vP15csVP
         2Inykn+zqlqTvqg3+0+DeFNuBcLi3J5YwcPuIQkDnhTaUWuCOJ/Drb3640jTS55ceVsX
         LxbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zhCiN8fI1/KzlZ5INmA1OSCbj6B41Sh5hvx8ikQAQ0M=;
        b=dqfEi+tfuWlLARYPga9e0H4o2Z1ZOt/9+EaFe+N8kkuyzN6DBasTen47HItcyln6ya
         0hYkkd1zDLkpXBnR55ChAuI37K4CtQCtLw1AJ8SdZ+glnfIslIEavq7wI/k8CPh/EoRY
         SSKWzGKalbIHe0t8PMY9+tbctQNwXFy6AXGQYldzhGYytbiGjzNtfHkARHD2tVfKnjtz
         QFxnUNjtR5vrnI3as19Wlooicugokciwf7n12ezLo+57BQlij9EIYypgHWBZGNMt5mzV
         Kzy4kfK7XKZetD6uDkxKr2nyHgPu6KUB187zEC0h2KXPFIb7n669fUeP/DCtKi5oNLUv
         WZzg==
X-Gm-Message-State: AOAM530kOmyKDBRx3LvSGP7CxYkWtqdIYZryKT9Cko9yewYGlNBqstK6
        H5dpPpeJcrGD2JGmx7qjSsMDfDvBJfmKsdjh6uc=
X-Google-Smtp-Source: ABdhPJz0rMwYeUhu2U/xsQyKkdJ2JL6g1+8iNgBWBB6GcH9NLZZKGYYqA3pCtHIb32FB7JHOplmg3tUisjY62vjITQ4=
X-Received: by 2002:aa7:df84:: with SMTP id b4mr11405632edy.240.1615209649551;
 Mon, 08 Mar 2021 05:20:49 -0800 (PST)
MIME-Version: 1.0
References: <CA+sq2CdJf0FFMAMbh0OZ67=j2Fo+C2aqP3qTKcYkcRgscfTGiw@mail.gmail.com>
 <20210305150702.1c652fe2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CA+sq2CfwCTZ1zXpBkYHZpKfWSFABuOrHpGqdG+4uRRip+O+pYQ@mail.gmail.com>
 <20210306125427.tzt42itdwukz2cto@skbuf> <87a6rgq8yr.fsf@waldekranz.com>
In-Reply-To: <87a6rgq8yr.fsf@waldekranz.com>
From:   Sunil Kovvuri <sunil.kovvuri@gmail.com>
Date:   Mon, 8 Mar 2021 18:50:38 +0530
Message-ID: <CA+sq2Cc+b9kPxmK3qu7ET37bxMDBHWE8zROGUgyULCDh0HjKng@mail.gmail.com>
Subject: Re: Query on new ethtool RSS hashing options
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        George Cherian <gcherian@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 7, 2021 at 2:46 AM Tobias Waldekranz <tobias@waldekranz.com> wrote:
>
> On Sat, Mar 06, 2021 at 14:54, Vladimir Oltean <olteanv@gmail.com> wrote:
> > On Sat, Mar 06, 2021 at 05:38:14PM +0530, Sunil Kovvuri wrote:
> >> > Can you share the format of the DSA tag? Is there a driver for it
> >> > upstream? Do we need to represent it in union ethtool_flow_union?
> >> >
> >>
> >> No, there is no driver for this tag in the kernel.
> >> I have attached the tag format.
> >> There are multiple DSA tag formats and representing them ethtool_flow
> >> union would be difficult.
> >> Hence wondering if it would be okay to add a more flexible way ie
> >> offset and num_bytes from the start of packet.
> >
> > How sure are you that the tag format you've shared is not identical to
> > the one parsed by net/dsa/tag_dsa.c?
>
> That is indeed the format parsed by tag_dsa.c. Based on the layout in
> the image, I am pretty sure that it is from the functional spec. of the
> Amethyst (6393X). So while the format is supported, that specific device
> is not. Hopefully that will change soon:
>
> https://lore.kernel.org/netdev/cover.1610071984.git.pavana.sharma@digi.com/

Thanks for the info.

>
> As for the NIC: Marvell has an EVK for the Amethyst, connected to a
> CN9130 SoC. The ethernet controllers in those can parse DSA tags in
> hardware, so I would put my money on that.
>
> The upstream driver (mvpp2) does not seem to support it though, AFAIK.

This is not for the mvpp2 driver, but for RVU driver
drivers/net/ethernet/marvell/octeontx2.

Thanks,
Sunil.
