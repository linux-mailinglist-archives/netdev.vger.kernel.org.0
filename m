Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8F78470060
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 12:57:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236881AbhLJMBK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 07:01:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236854AbhLJMBJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 07:01:09 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26205C061746
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 03:57:34 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id w1so28997518edc.6
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 03:57:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZKkcUBSPJzMq8SMeF9ajj9v3yK8GDhaOX6LqwtsglKU=;
        b=Ex2qNUyDM3sxiZwZKPmzPrB2Sm3dtWDQJmw6yR58bSjgfNyBhI7Rd+pGsUWuf0Rahr
         m2wzhXPJY06Wd3Q8ETtrXqw7tN9+eTmqP8U9Wd2wJTh5/7CeQnoHx1cPmYYCVc9g/LiS
         eZOOsV418ticlZjrJO+FRV5vhca6n5ULDc9lnrEcaYNzf6z/83fV+GmT4h9LMbWLpR57
         7psarxI4twRYbc4KhLccU+Qx5h36fTg9B+RTACLxTmzLfaPEIQGxu/osOz4BRrmeDY79
         wlkE5fvSOEKu2ElJ2yS/1ANWaryaM8d/WISeSqmikB0/VgPq6vM8LtbtVEn/QlhmUve0
         vJ3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZKkcUBSPJzMq8SMeF9ajj9v3yK8GDhaOX6LqwtsglKU=;
        b=KrmDniLF6yKnACHpbYaNECPUCFB4zuUmH+o7BqjX2q4PshRjZ2sq5PHWsY0rJZgt5k
         ipo/uaINqgw3S5FjVvjyF+52ompvB1hCa+QReAxafbkWhwZpO9MgnLq+zOrmHDsugg1r
         9myhZhLInaOHCtbkxgruJRXWBAMoxLkCmKT++IBp/CB2a6L4EcweXgWTDYTgyZvFK2R7
         XkHzjUpv4GgXzwdXFtf30IOcvtG/WrzDbB7wW3HE90JaR7+8uPWX0wA8wuDWoD0UcY7h
         vsaP01gZRM6L281P9GKSlKFaa51DaOhUcBsIBOhMG6TesREihpiLHfcyR9UDaf/V2ci7
         er5w==
X-Gm-Message-State: AOAM533pm7FS5uF14Fvs7S7YZz39o5aN6Y04wciR3PaKdM4y7wt630Bg
        gx1lD0xDwK1zpk+zitQjTMY=
X-Google-Smtp-Source: ABdhPJwO6i/fjvqB1W9zY9joF47Rvl/w7uIQpgr7Qla+Sz2tR3V/8eDSvdBdRLeczxzVbXqKbYDbmg==
X-Received: by 2002:a05:6402:1292:: with SMTP id w18mr37753850edv.46.1639137452517;
        Fri, 10 Dec 2021 03:57:32 -0800 (PST)
Received: from skbuf ([188.25.173.50])
        by smtp.gmail.com with ESMTPSA id h7sm1330524edb.89.2021.12.10.03.57.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 03:57:32 -0800 (PST)
Date:   Fri, 10 Dec 2021 13:57:30 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ong Boon Leong <boon.leong.ong@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        alexandre.torgue@foss.st.com,
        Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net-next 0/2] net: stmmac: add EthType Rx Frame steering
Message-ID: <20211210115730.bcdh7jvwt24u5em3@skbuf>
References: <20211209151631.138326-1-boon.leong.ong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211209151631.138326-1-boon.leong.ong@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, Jakub,

On Thu, Dec 09, 2021 at 11:16:29PM +0800, Ong Boon Leong wrote:
> Hi,
> 
> Patch 1/2: Fixes issue in tc filter delete flower for VLAN priority
>            steering. Patch has been sent to 'net' ML. Link as follow:
> 
> https://patchwork.kernel.org/project/netdevbpf/patch/20211209130335.81114-1-boon.leong.ong@intel.com/
> 
> Patch 2/2: Patch to add LLDP and IEEE1588 EtherType RX frame steering
>            in tc flower that is implemented on-top of patch 1/2.
> 
> Below are the test steps for checking out the newly added feature:-
> 
> # Setup traffic class and ingress filter
> $ IFDEVNAME=eth0
> $ tc qdisc add dev $IFDEVNAME ingress
> $ tc qdisc add dev $IFDEVNAME root mqprio num_tc 8 \
>      map 0 1 2 3 4 5 6 7 0 0 0 0 0 0 0 0 \
>      queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 hw 0
> 
> # Add two VLAN priority based RX Frame Steering
> $ tc filter add dev $IFDEVNAME parent ffff: protocol 802.1Q \
>      flower vlan_prio 1 hw_tc 1
> $ tc filter add dev $IFDEVNAME parent ffff: protocol 802.1Q \
>      flower vlan_prio 2 hw_tc 2
> 
> # For LLDP
> $ tc filter add dev $IFDEVNAME parent ffff: protocol 0x88cc \
>      flower hw_tc 5
> 
> # For PTP
> $ tc filter add dev $IFDEVNAME parent ffff: protocol 0x88f7 \
>      flower hw_tc 6
> 
> # Show the ingress tc filters
> $ tc filter show dev $IFDEVNAME ingress
> 
> filter parent ffff: protocol ptp pref 49149 flower chain 0
> filter parent ffff: protocol ptp pref 49149 flower chain 0 handle 0x1 hw_tc 6
>   eth_type 88f7
>   in_hw in_hw_count 1
> filter parent ffff: protocol LLDP pref 49150 flower chain 0
> filter parent ffff: protocol LLDP pref 49150 flower chain 0 handle 0x1 hw_tc 5
>   eth_type 88cc
>   in_hw in_hw_count 1
> filter parent ffff: protocol 802.1Q pref 49151 flower chain 0
> filter parent ffff: protocol 802.1Q pref 49151 flower chain 0 handle 0x1 hw_tc 2
>   vlan_prio 2
>   in_hw in_hw_count 1
> filter parent ffff: protocol 802.1Q pref 49152 flower chain 0
> filter parent ffff: protocol 802.1Q pref 49152 flower chain 0 handle 0x1 hw_tc 1
>   vlan_prio 1
>   in_hw in_hw_count 1
> 
> # Delete tc filters
> $ tc filter del dev $IFDEVNAME parent ffff: pref 49149
> $ tc filter del dev $IFDEVNAME parent ffff: pref 49150
> $ tc filter del dev $IFDEVNAME parent ffff: pref 49151
> $ tc filter del dev $IFDEVNAME parent ffff: pref 49152
> 
> Thanks,
> BL
> 
> Ong Boon Leong (2):
>   net: stmmac: fix tc flower deletion for VLAN priority Rx steering
>   net: stmmac: add tc flower filter for EtherType matching
> 
>  drivers/net/ethernet/stmicro/stmmac/stmmac.h  |  20 ++
>  .../net/ethernet/stmicro/stmmac/stmmac_tc.c   | 189 +++++++++++++++++-
>  2 files changed, 205 insertions(+), 4 deletions(-)
> 
> -- 
> 2.25.1
> 

Is it the canonical approach to perform flow steering via tc-flower hw_tc,
as opposed to ethtool --config-nfc? My understanding from reading the
documentation is that tc-flower hw_tc only selects the hardware traffic
class for a packet, and that this has to do with prioritization
(although the concept in itself is a bit ill-defined as far as I
understand it, how does it relate to things like offloaded skbedit priority?).
But selecting a traffic class, in itself, doesn't (directly or
necessarily) select a ring per se, as ethtool does? Just like ethtool
doesn't select packet priority, just RX queue. When the RX queue
priority is configurable (see the "snps,priority" device tree property
in stmmac_mtl_setup) and more RX queues have the same priority, I'm not
sure what hw_tc is supposed to do in terms of RX queue selection?
