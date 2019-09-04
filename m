Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14630A921E
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387843AbfIDS6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 14:58:42 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:32885 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387787AbfIDS6m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 14:58:42 -0400
Received: by mail-pf1-f193.google.com with SMTP id q10so8770502pfl.0
        for <netdev@vger.kernel.org>; Wed, 04 Sep 2019 11:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DHI4vXRePEAWMNkI9NCrzqFuBWvTwJ/KW5ZAkRrLcog=;
        b=f3Q9pxh++B5jy0lf3xpNTByhuGIcauOmTraxgmLfWDDPHU0q1HjC2yfdu/5SQedRiB
         XafUDup/Vy/wjkLGiEMekQzNFp2R8JXe3Ucy6G9Wr1bWPsRSqaxZnZ/a5A9hZOPCYX25
         9+XfqYB/XSexVauwdueTrggifbKxOsFXywiyFKHe4zI5wavINrtfMPf6l32iZiWphA/B
         qQ21RQpq7IfBYDKUff8zrlp/+GuA1yZiJhJEscnsLgBQIr8bY5vup7iDR2MNolwIKah4
         koafFuRGMTDvf2ujYxvQFwZEdHXg4uiRN1ApEIVVcC9iUG+7+86m+P0v1LHw8ey0pWQ2
         oy4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DHI4vXRePEAWMNkI9NCrzqFuBWvTwJ/KW5ZAkRrLcog=;
        b=tbFoXpbBUET90YUVYn6C1oRQL+yhqIunTrKR2D8sgS1atOjedX2L7cyPKtlu26KRQ9
         hpKEECFaiYdaKJ1SdBzkr6tZ4/Ky9m5Mf7D5Bz5eJ1B9OIodmpQnQZGFENKEazIF2tfX
         boKvzBkrmDsO4zeAS6BYet4sWo6urKOhQC7psgaNhsUtA0nMw0MkI0xhe4ilYPveoivI
         zQCa7YGBp1U82PIQxxg9gn1bPUCcSNuq4y1gwhWAN5BgyQHNghto3K1emVgtFztrMZLz
         jidzipnx4VVJ7NRTbItQjjcJvZhBDtbaVpfhA2CSslPd19LLlzbIFMecs7bAD/zPXts4
         vfMQ==
X-Gm-Message-State: APjAAAWHbw8j8oF9lhI+HTXBBpXrlzFt1QYRnexZLAudO06JFR3SYNBc
        NUMcoYP087+IZsu5YQoEsFC3IQ==
X-Google-Smtp-Source: APXvYqwQiWc9tFbCPqod9TYK1PeqtsN8Fexdd50WqmwyJlsLHLrI6rW5cqnJ12MppTD/5YdPAgB/ag==
X-Received: by 2002:a62:7911:: with SMTP id u17mr32844735pfc.162.1567623521382;
        Wed, 04 Sep 2019 11:58:41 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id u17sm12108486pfm.153.2019.09.04.11.58.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2019 11:58:41 -0700 (PDT)
Date:   Wed, 4 Sep 2019 11:58:39 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, jiri@resnulli.us,
        sd@queasysnail.net, roopa@cumulusnetworks.com, saeedm@mellanox.com,
        manishc@marvell.com, rahulv@marvell.com, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, sashal@kernel.org,
        hare@suse.de, varun@chelsio.com, ubraun@linux.ibm.com,
        kgraul@linux.ibm.com
Subject: Re: [PATCH net 00/11] net: fix nested device bugs
Message-ID: <20190904115839.64c27609@hermes.lan>
In-Reply-To: <20190904183828.14260-1-ap420073@gmail.com>
References: <20190904183828.14260-1-ap420073@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  5 Sep 2019 03:38:28 +0900
Taehee Yoo <ap420073@gmail.com> wrote:

> This patchset fixes several bugs that are related to nesting
> device infrastructure.
> Current nesting infrastructure code doesn't limit the depth level of
> devices. nested devices could be handled recursively. at that moment,
> it needs huge memory and stack overflow could occur.
> Below devices type have same bug.
> VLAN, BONDING, TEAM, MACSEC, MACVLAN and VXLAN.
> 
> Test commands:
>     ip link add dummy0 type dummy
>     ip link add vlan1 link dummy0 type vlan id 1
> 
>     for i in {2..100}
>     do
> 	    let A=$i-1
> 	    ip link add name vlan$i link vlan$A type vlan id $i
>     done
>     ip link del dummy0
> 
> 1st patch actually fixes the root cause.
> It adds new common variables {upper/lower}_level that represent
> depth level. upper_level variable is depth of upper devices.
> lower_level variable is depth of lower devices.
> 
>       [U][L]       [U][L]
> vlan1  1  5  vlan4  1  4
> vlan2  2  4  vlan5  2  3
> vlan3  3  3    |
>   |            |
>   +------------+
>   |
> vlan6  4  2
> dummy0 5  1
> 
> After this patch, the nesting infrastructure code uses this variable to
> check the depth level.
> 
> 2, 4, 5, 6, 7 patches fix lockdep related problem.
> Before this patch, devices use static lockdep map.
> So, if devices that are same type is nested, lockdep will warn about
> recursive situation.
> These patches make these devices use dynamic lockdep key instead of
> static lock or subclass.
> 
> 3rd patch splits IFF_BONDING flag into IFF_BONDING and IFF_BONDING_SLAVE.
> Before this patch, there is only IFF_BONDING flags, which means
> a bonding master or a bonding slave device.
> But this single flag could be problem when bonding devices are set to
> nested.
> 
> 8th patch fixes a refcnt leak in the macsec module.
> 
> 9th patch adds ignore flag to an adjacent structure.
> In order to exchange an adjacent node safely, ignore flag is needed.
> 
> 10th patch makes vxlan add an adjacent link to limit depth level.
> 
> 11th patch removes unnecessary variables and callback.
> 
> Taehee Yoo (11):
>   net: core: limit nested device depth
>   vlan: use dynamic lockdep key instead of subclass
>   bonding: split IFF_BONDING into IFF_BONDING and IFF_BONDING_SLAVE
>   bonding: use dynamic lockdep key instead of subclass
>   team: use dynamic lockdep key instead of static key
>   macsec: use dynamic lockdep key instead of subclass
>   macvlan: use dynamic lockdep key instead of subclass
>   macsec: fix refcnt leak in module exit routine
>   net: core: add ignore flag to netdev_adjacent structure
>   vxlan: add adjacent link to limit depth level
>   net: remove unnecessary variables and callback
> 
>  drivers/net/bonding/bond_alb.c                |   2 +-
>  drivers/net/bonding/bond_main.c               |  87 ++++--
>  .../net/ethernet/mellanox/mlx5/core/en_tc.c   |   2 +-
>  .../ethernet/qlogic/netxen/netxen_nic_main.c  |   2 +-
>  drivers/net/hyperv/netvsc_drv.c               |   3 +-
>  drivers/net/macsec.c                          |  50 ++--
>  drivers/net/macvlan.c                         |  36 ++-
>  drivers/net/team/team.c                       |  61 ++++-
>  drivers/net/vxlan.c                           |  71 ++++-
>  drivers/scsi/fcoe/fcoe.c                      |   2 +-
>  drivers/target/iscsi/cxgbit/cxgbit_cm.c       |   2 +-
>  include/linux/if_macvlan.h                    |   3 +-
>  include/linux/if_team.h                       |   5 +
>  include/linux/if_vlan.h                       |  13 +-
>  include/linux/netdevice.h                     |  29 +-
>  include/net/bonding.h                         |   4 +-
>  include/net/vxlan.h                           |   1 +
>  net/8021q/vlan.c                              |   1 -
>  net/8021q/vlan_dev.c                          |  32 +--
>  net/core/dev.c                                | 252 ++++++++++++++++--
>  net/core/dev_addr_lists.c                     |  12 +-
>  net/smc/smc_core.c                            |   2 +-
>  net/smc/smc_pnet.c                            |   2 +-
>  23 files changed, 519 insertions(+), 155 deletions(-)
> 

The network receive path already avoids excessive stack
depth. Maybe the real problem is in the lockdep code.
