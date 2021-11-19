Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85DDD456DC1
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 11:48:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234792AbhKSKvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 05:51:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232576AbhKSKvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 05:51:08 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CDCFC061574
        for <netdev@vger.kernel.org>; Fri, 19 Nov 2021 02:48:07 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id f18so41580927lfv.6
        for <netdev@vger.kernel.org>; Fri, 19 Nov 2021 02:48:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lZvcqRDR/wFbGgiLl0OeeuRhjEvzG4aUsRar7i4Ga4I=;
        b=pXlxrX42Tk7/KQvwNY2YcXDX1YaCSrv3LAVEODvx+s11SW3ETynB9/ECWGVbElx11n
         4i2GGPiiWrdFBA3ZDlPsZ27WH/s5r2YlRR4dD51g0T1y9AWbCCq4YkIvg71Sd/jwb5ZS
         qFJ3xBeYnCfkLqnPqVgA27soTDdswOei0WWEW1wEef58YqFmCAjBQDjwaDDZ/P99pUhp
         X8sGd5oOoLk8nOs54dc9nx6ZSgcox6VIP3P/77R/Z+Dwm8B2cXEusizxGNjVGBTJ5xr3
         9ga8Ue/fNosXrvzzaulom1kWPzj82ogsgGWwPE2qxUZ5MxkIkrqYuRgp1x4Aab6oXUoj
         etwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lZvcqRDR/wFbGgiLl0OeeuRhjEvzG4aUsRar7i4Ga4I=;
        b=OBW5AjLpTvRodogKL/9S5MfWcIBC36EMobsH7O9xk3fS11AH6np1he/ny8FmG/7YXg
         yoV2e+tRyGpvUyeoutrciIk6wtFMOQx4r8y3KFCLG/PqHIk+rIHr8K71t4aTPf/QcNHO
         E7cjLJkG6nwqJhgq4kdIrYoIe/l7WFCy+xp0pkgd30UyEs5thb71Y3TZBiF4nOYUCWUu
         jtl0CI5dGwSspIFH2m1Usx3Pfy1E+J6gCGPSTKm1RjpBYMDkMMbDiw01vAAiFb+7lfB1
         uT1cpoMuC3w4fztGpss4H5N22ytAAseMPTwd9U3n0zFgSkd+gMTKzWa1fycVd7dM1KkY
         Y0sA==
X-Gm-Message-State: AOAM532UsVilc4AMOWrMW3lffokZ1sDQVr4EjUkGdorU2IGnkzyjec39
        k0p1IKp2Qkr9HpZhh23tJhDB5wNbMqay40yjh80=
X-Google-Smtp-Source: ABdhPJz39NvOOp9zpRku+idtw6lWfk++p3Db5UNR95KR8TSd5qjpEw2qrZDxvvFZFEpXwMBkj0QWbMfu9Ts1Kg49Vu8=
X-Received: by 2002:a05:6512:2255:: with SMTP id i21mr31543257lfu.438.1637318885641;
 Fri, 19 Nov 2021 02:48:05 -0800 (PST)
MIME-Version: 1.0
References: <YXmWb2PZJQhpMfrR@shredder> <BY3PR18MB473794E01049EC94156E2858C6859@BY3PR18MB4737.namprd18.prod.outlook.com>
 <YXnRup1EJaF5Gwua@shredder> <CALHRZuqpaqvunTga+8OK4GSa3oRao-CBxit6UzRvN3a1-T0dhA@mail.gmail.com>
 <YXqq19HxleZd6V9W@shredder> <CALHRZuoOWu0sEWjuanrYxyAVEUaO4-wea5+mET9UjPyoOrX5NQ@mail.gmail.com>
 <YYeajTs6d4j39rJ2@shredder> <20211108075450.1dbdedc3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YY0uB7OyTRCoNBJQ@shredder> <20211111084719.600f072d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YZDK6JxwcoPvk/Zx@shredder> <952e8bb0-bc1e-5600-92f2-de4d6744fcb0@nvidia.com> <20211115071109.1bf4875b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211115071109.1bf4875b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   sundeep subbaraya <sundeep.lkml@gmail.com>
Date:   Fri, 19 Nov 2021 16:17:53 +0530
Message-ID: <CALHRZura-Vav599FTVkMb33uY0xtpNkotxU-q8FUiBxoHqXh7Q@mail.gmail.com>
Subject: Re: [EXT] Re: [net-next PATCH 1/2] octeontx2-pf: Add devlink param to
 init and de-init serdes
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Roopa Prabhu <roopa@nvidia.com>, Ido Schimmel <idosch@idosch.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        Rakesh Babu Saladi <rsaladi2@marvell.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Andrew Lunn <andrew@lunn.ch>, argeorge@cisco.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Nov 15, 2021 at 8:41 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Sun, 14 Nov 2021 20:19:59 -0800 Roopa Prabhu wrote:
> > On 11/14/21 12:38 AM, Ido Schimmel wrote:
> > > On Thu, Nov 11, 2021 at 08:47:19AM -0800, Jakub Kicinski wrote:
> > >> Hm. How do we come up with the appropriate wording here...
> > >>
> > >> I meant keeping the "PHY level link" up? I think we agree that all the
> > >> cases should behave like SFP power behaves today?
> > >>
> > >> The API is to control or query what is forcing the PHY link to stay up
> > >> after the netdev was set down. IOW why does the switch still see link
> > >> up if the link is down on Linux.
> > > The SFP power policy doesn't affect that. In our systems (and I believe
> > > many others), by default, the transceivers are transitioned to high
> > > power mode upon plug-in, but the link is still down when the netdev is
> > > down because the MAC/PHY are not operational.
>
> Ah, GTK!
>
> > > With SRIOV/Multi-Host, the MAC/PHY are always operational which is why
> > > your link partner has a carrier even when the netdev is down.
>
> I see, I think you're talking about something like IFLA_VF_LINK_STATE_*
> but for the PF. That could make sense, although I don't think it was
> ever requested.
>
> > >> I don't think we should report carrier up when netdev is down?
> > > This is what happens today, but it's misleading because the carrier is
> > > always up with these systems. When I take the netdev down, I expect my
> > > link partner to lose carrier. If this doesn't happen, then I believe the
> > > netdev should always report IFF_UP. Alternatively, to avoid user space
> > > breakage, this can be reported via a new attribute such as "protoup".
>
> Sounds sensible.
>
> > >> "proto" in "protodown" refers to STP, right?
> > > Not really. I believe the main use case was vrrp / mlag.
>
> VRRP is a proto, mlag maybe a little less clear-cut.
>
> > > The "protdown_reason" is just a bitmap of user enumerated reasons to keep
> > > the interface down. See commit 829eb208e80d ("rtnetlink: add support for
> > > protodown reason") for details.
> >
> > correct. Its equivalent to errDisable found on most commercial switch OS'es.
> >
> > Can be used for any control-plane/mgmt-plane/protocol wanting to hold
> > the link down.
> >
> > Other use-cases where this can be used (as also quoted by other vendors):
> >
> > mismatch of link properties
>
> What link properties?
>
> > Link Flapping detection and disable link
> > Port Security Violation
>
> Port security as established by a .. protocol like 802.1X ?
>
> > Broadcast Storms
> > etc
>
> Why not take the entire interface down for bcast storm?
>
> > >> Not sure what "proto" in "protoup" would be.
> > > sriov/multi-host/etc ?
> >
> > agree. Would be nice to re-use protodown ndo and state/reason here
>
> You are the experts so correct me please but the point of protodown
> is that the the link is held down for general traffic but you can
> still exchange protocol messages on it. STP, VRRP, LAG, 802.1X etc.
>
> For anything that does not require special message exchange the link
> can be just brought down completely.
>
> In my head link held up is a completely different beast, the local host
> does not participate or otherwise pay attention to any communication on
> the link. It's about what other entities do with the link.
>
> But if you prefer "protoup" strongly that's fine, I guess.

As said by Ido, ndo_change_proto_down with proto_down as
on and off is sufficient for our requirement right now. We will use
ndo_change_proto_down
instead of devlink. Thanks everyone for pitching in.

Sundeep
