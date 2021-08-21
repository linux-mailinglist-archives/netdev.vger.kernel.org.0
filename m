Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EFA33F37B3
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 02:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240642AbhHUAW5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 20:22:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237700AbhHUAW4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 20:22:56 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7453C061575
        for <netdev@vger.kernel.org>; Fri, 20 Aug 2021 17:22:17 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id gr13so23403427ejb.6
        for <netdev@vger.kernel.org>; Fri, 20 Aug 2021 17:22:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YAwt/5leZYbtMKTft3op5FVjvzIy22S+SPOXQpZ7thE=;
        b=NS4RQIIJchpv+cnqa/Xmnq0t/UJj73uV1XClrHNvwiLTiWnoj6zADUczt/5CA618zg
         iMbq8NCPw3LqpelLsbXhOxp7M6P9H7wKLgRmM2vH04jHxkAPWYtXHCRBVFy7YttrY/u5
         Wp5BJjHhvKQaeFqYITQUuZHZWsLI4UhdxqT3VH86vnTzGz1lrt8co0EnC9WC46IoV0P9
         7s8oZf3Ef4Rp6R4G6KJLTZNtjaxfB/6zZlopquW/oB+qa69sKVfx6aAC6oH1YRlQI7Gl
         BDYbG0GKov0W2Wrb/R03wIf1soeWVBfwPMuqeZDYpJekpNxAPHIohyp7irVrQNNWc8Vy
         9xPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YAwt/5leZYbtMKTft3op5FVjvzIy22S+SPOXQpZ7thE=;
        b=FNm9tTNylru97bBRD/mkd/Tx/JdMrK0wDObyKRwMzI1z/knBfbhsa7bJitUkP3FLty
         NQ695e4DFE2oyJdi6sEy8ZpunJCcy0X6IDk0Z0icOs0r5W81OJ0bd+hQr88Q3vrZHWjd
         4nZl5dDw2tVerhOTbwVZFOQGZXa5xICBBnr3s6GFYjWwykjgvxc93cxQFfoXSvX6vWMn
         Ycv2vZY8bgEJcf/HelWPkIr2HSeaA7/cWZY2ln83qfAEypQGXv7LV8mhxdvcKKC/YgoT
         dPkH96VXWibzA5wmwLe+nD7zLxeSgReUcSzCWJQunLIdAJVlk/N9IQ85AL26/rqsGriQ
         osgA==
X-Gm-Message-State: AOAM5338kr0hohGx+CDYeB0ENpeFL1uYbYnWkk7evA0WeW+hdtS6lLhX
        AKuK320luWAT4k/XSDgN3Ts=
X-Google-Smtp-Source: ABdhPJzX2de4dtyJGYulm9ew63z23lUV99edTljCQ2JEFzVgbfvsRVEU5z6FBU/Sq4dRtIw9Um0gew==
X-Received: by 2002:a17:906:2414:: with SMTP id z20mr23597785eja.363.1629505336370;
        Fri, 20 Aug 2021 17:22:16 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id p5sm3487763ejl.73.2021.08.20.17.22.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Aug 2021 17:22:15 -0700 (PDT)
Date:   Sat, 21 Aug 2021 03:22:12 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     Ido Schimmel <idosch@idosch.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        UNGLinuxDriver@microchip.com,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: [PATCH v2 net-next 0/5] Make SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE
 blocking
Message-ID: <20210821002212.ebi7cdugxdk5os7m@skbuf>
References: <20210819160723.2186424-1-vladimir.oltean@nxp.com>
 <YR9y2nwQWtGTumIS@shredder>
 <20210820093723.qdvnvdqjda3m52v6@skbuf>
 <YR/TrkbhhN7QpRcQ@shredder>
 <20210820170639.rvzlh4b6agvrkv2w@skbuf>
 <65f3529f-06a3-b782-7436-83e167753609@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65f3529f-06a3-b782-7436-83e167753609@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 21, 2021 at 02:36:26AM +0300, Nikolay Aleksandrov wrote:
> Hi,
> I don't like the double-queuing for each fdb for everyone either, it's forcing them
> to rework it asap due to inefficiency even though that shouldn't be necessary.

Let's be honest, with the vast majority of drivers having absurdities such as the
"if (!fdb_info->added_by_user || fdb_info->is_local) => nothing to do here, bye"
check placed _inside_ the actual work item (and therefore scheduling for nothing
for entries dynamically learned by the bridge), it's hard to believe that driver
authors cared too much about inefficiency when mindlessly copy-pasting that snippet
from mlxsw

[ which for the record does call mlxsw_sp_span_respin for dynamically learned FDB
  entries, so that driver doesn't schedule for nothing like the rest - although
  maybe even mlxsw could call mlxsw_sp_port_dev_lower_find_rcu instead of
  mlxsw_sp_port_dev_lower_find, and could save a queue_work for FDB entries on
  foreign && non-VXLAN ports. Who knows?! ]

Now I get to care for them.

But I can see how a partial conversion could leave things in an even more absurd position.
I don't want to contribute to the absurdity.

> In the
> long run I hope everyone would migrate to such scheme, but perhaps we can do it gradually.
> For most drivers this is introducing more work (as in processing) rather than helping
> them right now, give them the option to convert to it on their own accord or bite
> the bullet and convert everyone so the change won't affect them, it holds rtnl, it is blocking
> I don't see why not convert everyone to just execute their otherwise queued work.
> I'm sure driver maintainers would appreciate such help and would test and review it. You're
> halfway there already..

Agree, this needs more work. Thanks for looking.
