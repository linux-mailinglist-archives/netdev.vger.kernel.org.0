Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E8313CD079
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 11:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235196AbhGSIi3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 04:38:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234826AbhGSIiX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 04:38:23 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82B98C061574
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 01:20:07 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id dp20so25606154ejc.7
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 02:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tIojDdwExwM2bQG0JEvEesKc8kB3tKWJV3J1f0da5ZA=;
        b=pdHzLs5JGnc0J1gic2eKxFomgPy6zqT0sZNphWWO9rk6ZQr5XoeVwd+EvAce7pSnzl
         pUIE2LXmpy2gAR6WEkKk2qmmtpaTsjwWSMhBTCVNRoud2hIVrFnHzipUadejss5eMiWv
         3mQ0B5ahMAiUUsn4MY92QQzo7jbwH2qMqx6VbDXqW4Uf6OmRns2EdMOpUfj6M3U28t2T
         FD7+wmaDWFfbgtKG64yhGyNB/0v+F46q9C1FEyXJTjt1KuHVb7GxDX3Onq1myrr17Bcc
         SS/5FzCblHim68zec4TUheUDGVsFHiV2D8bolqpNdEp3VK4laF2LZp2n11HMiqNzdYv0
         vc+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tIojDdwExwM2bQG0JEvEesKc8kB3tKWJV3J1f0da5ZA=;
        b=Hy/tycyK1v9/zN0W9ftIVAW2q8NtGjqzw0huwhoec5avctoXhECHVMrqI8k/+y/v9P
         sauXp/AV1gDWpDuJcao420olFfLdlAdaw3RW1ZRJR+j2AqU5d2rhAuQWspOhW6UHzKb1
         ShCNZJqR0XBsNfosAw0Dx3VrS57fwLpJMUn+5mw26rXsy7knijV55NA5lopazM37ymHn
         knAm6W5z4NZa8qL+Lw6HsSNDKLtmH1HRaImSx2AtYwH2p1Ng8VVAET9f0KIbQs6ub1VW
         rdJ4FeEY9mLP5TJlWvFHTAPkP7v/yEjne1635H9Gr5kz/3fqKGxAYLnq6b86XnqMYGy9
         A94w==
X-Gm-Message-State: AOAM532z31UeprxQymbXi+8VI5a7IHTuYE3CMhQllSdzG9CVKX/a9Gqe
        MZKKyuRzHnW9gVqtvmg7nxBACvDb89k=
X-Google-Smtp-Source: ABdhPJzeDbzmVBfzpLsfwhdhZmxQ7LJiAWsUEkvcmmvvUk87xLxPhaDXDuRWKgj3SQzZbgUnBoMpNg==
X-Received: by 2002:aa7:d990:: with SMTP id u16mr32760879eds.263.1626682751332;
        Mon, 19 Jul 2021 01:19:11 -0700 (PDT)
Received: from skbuf ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id m15sm7401930edp.73.2021.07.19.01.19.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 01:19:10 -0700 (PDT)
Date:   Mon, 19 Jul 2021 11:19:08 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: Re: [PATCH v4 net-next 10/15] net: bridge: switchdev object replay
 helpers for everybody
Message-ID: <20210719081908.qnxw7gjetwkubxz3@skbuf>
References: <20210718214434.3938850-1-vladimir.oltean@nxp.com>
 <20210718214434.3938850-11-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210718214434.3938850-11-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 19, 2021 at 12:44:29AM +0300, Vladimir Oltean wrote:
> Note that:
> (c) I do not expect a lot of functional change introduced for drivers in
>     this patch, because:
>     - nbp_vlan_init() is called _after_ netdev_master_upper_dev_link(),
>       so br_vlan_replay() should not do anything for the new drivers on
>       which we call it. The existing drivers where there was even a
>       slight possibility for there to exist a VLAN on a bridge port
>       before they join it are already guarded against this: mlxsw and
>       prestera deny joining LAG interfaces that are members of a bridge.
>     - br_fdb_replay() should now notify of local FDB entries, but I
>       patched all drivers except DSA to ignore these new entries in
>       commit 2c4eca3ef716 ("net: bridge: switchdev: include local flag
>       in FDB notifications"). Driver authors can lift this restriction
>       as they wish.
>     - br_mdb_replay() should now fix the issue described in commit
>       2c4eca3ef716 ("net: bridge: switchdev: include local flag in FDB
>       notifications") for all drivers, I don't see any downside.

I really meant commit 4f2673b3a2b6 ("net: bridge: add helper to replay
port and host-joined mdb entries"), sorry for the copy-pasta mistake.
