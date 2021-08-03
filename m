Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30C093DEDE4
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 14:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235895AbhHCMdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 08:33:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:48742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234524AbhHCMdc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 08:33:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4751060EB9
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 12:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627994001;
        bh=CpbxfsgKXxPgx/faSjW0BLV+9gZU9dMEqwsdubK2Blw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Xs/VmyJBjECGrU/tNZpvgxTNHSGX8G2vD67D0mRa5AgExuxkf5/z2GTiYqA5pGR2G
         WmU1AIlvElpxU5FFVcvnNOkZkknY0JnX0dHjIi4IBLZ9+0bc81aAVddf+/aTGo8ItO
         Ytcsx/FgmNTVyr9TszKhp9tBk2FsomoYIc7WSj3cirlwUYqdIHAmE62YWmWG/QtRwd
         izgH0MgnTeb+C0s0zOheZlaxrv47uI+kpn0ARcFRJgZvAPCFIkgqWgnHl3Q4qLUYHh
         NseV4Z3w7arTqnztjrpXJm6bt4KJLpA6gFuQ2q4mt5jbS/OzwrlInVmvZSRCW0MrAA
         uZXoiFzh+qf6g==
Received: by mail-wm1-f48.google.com with SMTP id m19so12400376wms.0
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 05:33:21 -0700 (PDT)
X-Gm-Message-State: AOAM532e/8CO5FWd9sp5C3sSq+Iyc/kX0wJ/VALj/6QuBZrSrUvOsSNb
        5juGlH3yhnT+no/emhoG5VCVm4bO9LGTKeFQELs=
X-Google-Smtp-Source: ABdhPJw3qHTqLUvw6YoQlk9rqZQLJ3adOelJj8VF3pcEe24hnlRDy++w/c/rcmOPrFoT7EUbHZ8N9JaNH5p2ZNZ9kyM=
X-Received: by 2002:a1c:208e:: with SMTP id g136mr4109649wmg.142.1627993999889;
 Tue, 03 Aug 2021 05:33:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210726142536.1223744-1-vladimir.oltean@nxp.com>
 <CAK8P3a2HGm7MyUc3N1Vjdb2inS6D3E3HDq4bNTOBaHZQCP9kwA@mail.gmail.com>
 <eab61b8f-fc54-ea63-ad31-73fb13026b1f@ti.com> <20210803115819.sdtdqhmfk5k4olip@skbuf>
In-Reply-To: <20210803115819.sdtdqhmfk5k4olip@skbuf>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Tue, 3 Aug 2021 14:33:04 +0200
X-Gmail-Original-Message-ID: <CAK8P3a3xtC7p_iEcqLpL+uhCBGm31vrrCG5xFCxraCRZiyEWQA@mail.gmail.com>
Message-ID: <CAK8P3a3xtC7p_iEcqLpL+uhCBGm31vrrCG5xFCxraCRZiyEWQA@mail.gmail.com>
Subject: Re: [PATCH net-next] net: build all switchdev drivers as modules when
 the bridge is a module
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Networking <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Linux Kernel Functional Testing <lkft@linaro.org>,
        Vignesh Raghavendra <vigneshr@ti.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 3, 2021 at 1:58 PM Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
>
> On Tue, Aug 03, 2021 at 02:18:38PM +0300, Grygorii Strashko wrote:
> > In my opinion, the problem is a bit bigger here than just fixing the build :(
> >
> > In case, of ^cpsw the switchdev mode is kinda optional and in many cases
> > (especially for testing purposes, NFS) the multi-mac mode is still preferable mode.
> >
> > There were no such tight dependency between switchdev drivers and bridge core before and switchdev serviced as
> > independent, notification based layer between them, so ^cpsw still can be "Y" and bridge can be "M".
> > Now for mostly every kernel build configuration the CONFIG_BRIDGE will need to be set as "Y", or we will have
> > to update drivers to support build with BRIDGE=n and maintain separate builds for networking vs non-networking testing.
> > But is this enough? Wouldn't it cause 'chain reaction' required to add more and more "Y" options (like CONFIG_VLAN_8021Q)?
> >
> > PS. Just to be sure we on the same page - ARM builds will be forced (with this patch) to have CONFIG_TI_CPSW_SWITCHDEV=m
> > and so all our automation testing will just fail with omap2plus_defconfig.
>
> I didn't realize it is such a big use case to have the bridge built as
> module and cpsw as built-in.

I don't think anybody realistically cares about doing, I was only interested in
correctly expressing what the dependency is.

> I will send a patch that converts the
> switchdev_bridge_port_{,un}offload functions to simply emit a blocking
> switchdev notifier which the bridge processes (a la SWITCHDEV_FDB_ADD_TO_BRIDGE),
> therefore making switchdev and the bridge loosely coupled in order to
> keep your setup the way it was before.

That does sounds like it can avoid future build regressions, and simplify the
Kconfig dependencies, so that would probably be a good solution.

       arnd
