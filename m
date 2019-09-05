Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78B20A9DFB
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 11:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733135AbfIEJPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 05:15:34 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:34423 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733117AbfIEJPe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 05:15:34 -0400
Received: by mail-lf1-f68.google.com with SMTP id z21so1393099lfe.1
        for <netdev@vger.kernel.org>; Thu, 05 Sep 2019 02:15:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6RhT2fschxvKgzkuhqEg8nei7rdGrareCHjbhY82xgk=;
        b=XuQ+R/kQSyDwibv4qSE6h/ECsUqvGrM4Sgy5rYIJOHqqd8luI99aXTEjh2a3xZwP5Q
         1yDyFIWJMaBRpsExCG+yrOzmpKsYwCS2L8RYkebI2WhYMC0IOz3TrZ2azreaUFVxuICA
         bOqRm3E+VLIus4OM/2duyrj7xS8Nvkq30f7y8cJGXTLVtSU0ZY60dP51S0V2TXbNZQSh
         W1Y2fJ6YlP2NnkU5oxoMlQELkKOGBoy+8eFx/swC3HbKnUVNufEsTtxfEOwzSjGYvNzF
         FIXg6Jfr+jP+Xd0TIoq8EbMpbzd+RRW2MPjfilvE+eRglXHk9IAKnbid7IpMM2I/z8kv
         cl4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6RhT2fschxvKgzkuhqEg8nei7rdGrareCHjbhY82xgk=;
        b=rMyGsaSao1FD6zNa8J1HxoRTNKoTXgJdoo3OwRXzbZwTVy7/nzA1Vj/2NK1Rptq+3P
         OUYhBoj495vlwvo/aRVxP84nDwca/+HC0lR2ZYXgZ7va1x47eiUoB2Bh0aWXQ0qj449/
         Cbi2nOfw2w/QUgLiYFgNgd5HyN6KyhCxq5cA1GS0brFgsAHn9H5TjFPsKKa3XqeBC/jC
         RsmH0zyxUs1OzGX4tY4oOSVn0qF9Jg1nnajP9KP9jlkaBs52a9pQxD3eI82ZBzXmZVED
         UDUw39uwnCz6oHfsEwkzu0NlxaPTptzFks6G2pX1k+SyHUd7puUgwtJCBW1NTfIC9bSK
         RY0w==
X-Gm-Message-State: APjAAAVZo8p2r9/Ee+I/mCR0ynn8AFt74OM2Ji6fu+5Pdp61K56Y/IX+
        VI/Ew5mMOWHhQ7mIunfsJIKk0y0pVJMiSwDm0b0=
X-Google-Smtp-Source: APXvYqxGd1EfGzbeQCZ/gdbKCCU3897SFhXIyVERvHouGw+tbtn5dE3qkkRc8p6NbKurS0MaUNJ2/KypV+S1BL8oB7M=
X-Received: by 2002:a19:2207:: with SMTP id i7mr1613319lfi.185.1567674931423;
 Thu, 05 Sep 2019 02:15:31 -0700 (PDT)
MIME-Version: 1.0
References: <20190904183828.14260-1-ap420073@gmail.com> <20190904115839.64c27609@hermes.lan>
In-Reply-To: <20190904115839.64c27609@hermes.lan>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Thu, 5 Sep 2019 18:15:19 +0900
Message-ID: <CAMArcTUkb1uxo4iCof769j70BkLWzXf6_yWt9t+mV5vo-Eha9A@mail.gmail.com>
Subject: Re: [PATCH net 00/11] net: fix nested device bugs
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, j.vosburgh@gmail.com,
        vfalico@gmail.com, Andy Gospodarek <andy@greyhouse.net>,
        =?UTF-8?B?SmnFmcOtIFDDrXJrbw==?= <jiri@resnulli.us>,
        sd@queasysnail.net, Roopa Prabhu <roopa@cumulusnetworks.com>,
        saeedm@mellanox.com, manishc@marvell.com, rahulv@marvell.com,
        kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        sashal@kernel.org, hare@suse.de, varun@chelsio.com,
        ubraun@linux.ibm.com, kgraul@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 Sep 2019 at 03:58, Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Thu,  5 Sep 2019 03:38:28 +0900
> Taehee Yoo <ap420073@gmail.com> wrote:
>
> > This patchset fixes several bugs that are related to nesting
> > device infrastructure.
> > Current nesting infrastructure code doesn't limit the depth level of
> > devices. nested devices could be handled recursively. at that moment,
> > it needs huge memory and stack overflow could occur.
> > Below devices type have same bug.
> > VLAN, BONDING, TEAM, MACSEC, MACVLAN and VXLAN.
> >
> > Test commands:
> >     ip link add dummy0 type dummy
> >     ip link add vlan1 link dummy0 type vlan id 1
> >
> >     for i in {2..100}
> >     do
> >           let A=$i-1
> >           ip link add name vlan$i link vlan$A type vlan id $i
> >     done
> >     ip link del dummy0
> >
> > 1st patch actually fixes the root cause.
> > It adds new common variables {upper/lower}_level that represent
> > depth level. upper_level variable is depth of upper devices.
> > lower_level variable is depth of lower devices.
> >
> >       [U][L]       [U][L]
> > vlan1  1  5  vlan4  1  4
> > vlan2  2  4  vlan5  2  3
> > vlan3  3  3    |
> >   |            |
> >   +------------+
> >   |
> > vlan6  4  2
> > dummy0 5  1
> >
> > After this patch, the nesting infrastructure code uses this variable to
> > check the depth level.
> >
> > 2, 4, 5, 6, 7 patches fix lockdep related problem.
> > Before this patch, devices use static lockdep map.
> > So, if devices that are same type is nested, lockdep will warn about
> > recursive situation.
> > These patches make these devices use dynamic lockdep key instead of
> > static lock or subclass.
> >
> > 3rd patch splits IFF_BONDING flag into IFF_BONDING and IFF_BONDING_SLAVE.
> > Before this patch, there is only IFF_BONDING flags, which means
> > a bonding master or a bonding slave device.
> > But this single flag could be problem when bonding devices are set to
> > nested.
> >
> > 8th patch fixes a refcnt leak in the macsec module.
> >
> > 9th patch adds ignore flag to an adjacent structure.
> > In order to exchange an adjacent node safely, ignore flag is needed.
> >
> > 10th patch makes vxlan add an adjacent link to limit depth level.
> >
> > 11th patch removes unnecessary variables and callback.
> >
> > Taehee Yoo (11):
> >   net: core: limit nested device depth
> >   vlan: use dynamic lockdep key instead of subclass
> >   bonding: split IFF_BONDING into IFF_BONDING and IFF_BONDING_SLAVE
> >   bonding: use dynamic lockdep key instead of subclass
> >   team: use dynamic lockdep key instead of static key
> >   macsec: use dynamic lockdep key instead of subclass
> >   macvlan: use dynamic lockdep key instead of subclass
> >   macsec: fix refcnt leak in module exit routine
> >   net: core: add ignore flag to netdev_adjacent structure
> >   vxlan: add adjacent link to limit depth level
> >   net: remove unnecessary variables and callback
> >
> >  drivers/net/bonding/bond_alb.c                |   2 +-
> >  drivers/net/bonding/bond_main.c               |  87 ++++--
> >  .../net/ethernet/mellanox/mlx5/core/en_tc.c   |   2 +-
> >  .../ethernet/qlogic/netxen/netxen_nic_main.c  |   2 +-
> >  drivers/net/hyperv/netvsc_drv.c               |   3 +-
> >  drivers/net/macsec.c                          |  50 ++--
> >  drivers/net/macvlan.c                         |  36 ++-
> >  drivers/net/team/team.c                       |  61 ++++-
> >  drivers/net/vxlan.c                           |  71 ++++-
> >  drivers/scsi/fcoe/fcoe.c                      |   2 +-
> >  drivers/target/iscsi/cxgbit/cxgbit_cm.c       |   2 +-
> >  include/linux/if_macvlan.h                    |   3 +-
> >  include/linux/if_team.h                       |   5 +
> >  include/linux/if_vlan.h                       |  13 +-
> >  include/linux/netdevice.h                     |  29 +-
> >  include/net/bonding.h                         |   4 +-
> >  include/net/vxlan.h                           |   1 +
> >  net/8021q/vlan.c                              |   1 -
> >  net/8021q/vlan_dev.c                          |  32 +--
> >  net/core/dev.c                                | 252 ++++++++++++++++--
> >  net/core/dev_addr_lists.c                     |  12 +-
> >  net/smc/smc_core.c                            |   2 +-
> >  net/smc/smc_pnet.c                            |   2 +-
> >  23 files changed, 519 insertions(+), 155 deletions(-)
> >
>

Hi Stephen,
Thank you so much for the review!

> The network receive path already avoids excessive stack
> depth. Maybe the real problem is in the lockdep code.

Sorry, I don't understand the point that you mentioned.
I appreciate if you tell me more in details about your review.
