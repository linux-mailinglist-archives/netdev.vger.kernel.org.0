Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E99EC21DFEF
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 20:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726602AbgGMSja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 14:39:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbgGMSja (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 14:39:30 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17235C061755
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 11:39:30 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id k4so5867333pld.12
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 11:39:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HTARqhFeeazkcuKTZNPnFakhuBTnbvw4q48kW063gww=;
        b=TxGm9MWMyz1luyJ8FgXLeTohEWwQoeKYDjPFBZNe5lwSdcCCuDVeWI+fyuQXVFsHz+
         XXHqnt2e18yO61MdBIxFAE6RzTCgagJsonjeAXCTb+wQEgXyDM7reCJ1xwHFSiXl1ayH
         IVkzli4olIX9WFBzd3yNVpRi93RMT7VOY8FvOEMoMA3/QBnaNOWIWeGe7HrLFdVopVhg
         InSYfWU9liGeTY85HfXx+cPdh+jq+YZp4yl7mtlNGEW4+AioOmErXpZBHwZ17cdbox/m
         3FEehlRUpjdYWIHd6oiBrgDl/VEQ6yZLKS45zOAvin7Du6SgRCf8f7qpwk2ZtLwGd35U
         su4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HTARqhFeeazkcuKTZNPnFakhuBTnbvw4q48kW063gww=;
        b=UALm/lu+Evwk7k85VGQVjjaeHDII2UxUF+jDMoT3Gr4GaJpO1errQKVf57KhowyC0T
         kVNChA5LElXfsqUZRc+0MmMClzuHO8QgL7TEZZ/YKByiv4oCfLR9SpjE7A04eaj587PN
         gRJAuBkd/v1Tvt7QlxN9H57u5SZGSE8zRktaKWyIA9QAnijsAo833u7ydq33YMngS5Cc
         TOeJACY2Scb8p1IV/LEtofUIssU7zLAPvq18tU2cnHN3DVYCXD6hcdVERXTm/ZKjKF0p
         H3+BJq2ehK8XF2DVTWxicKb0nW/wkkyzJ5DF+V1r0SrPS4RI/GKg00CMBBBKNr6k6dBh
         IpPA==
X-Gm-Message-State: AOAM5313fxZcmifu+5xyX0tejAe4L6YMSa3Cm1V8H/p+Zz6x2YNMczU3
        39V2bIhe3MB3QSafOq1IHCt6Q/gu
X-Google-Smtp-Source: ABdhPJyc8N9xVSh2yT5xzjKkOQwg55ya5xWh5XaktOsdlWhzlT+2ii0kvj6/mVsn9WAldWnzNOVMjg==
X-Received: by 2002:a17:90a:2c0e:: with SMTP id m14mr764711pjd.166.1594665569358;
        Mon, 13 Jul 2020 11:39:29 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id ev14sm294542pjb.0.2020.07.13.11.39.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jul 2020 11:39:28 -0700 (PDT)
Subject: Re: [PATCH net] net: dsa: link interfaces with the DSA master to get
 rid of lockdep warnings
To:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, jiri@resnulli.us
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, xiyou.wangcong@gmail.com,
        ap420073@gmail.com
References: <20200713162443.2510682-1-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b252ce38-57c4-df81-12b5-f57404eac449@gmail.com>
Date:   Mon, 13 Jul 2020 11:39:22 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200713162443.2510682-1-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+ Jiri,

On 7/13/2020 9:24 AM, Vladimir Oltean wrote:
> Since commit 845e0ebb4408 ("net: change addr_list_lock back to static
> key"), cascaded DSA setups (DSA switch port as DSA master for another
> DSA switch port) are emitting this lockdep warning:
> 
> ============================================
> WARNING: possible recursive locking detected
> 5.8.0-rc1-00133-g923e4b5032dd-dirty #208 Not tainted
> --------------------------------------------
> dhcpcd/323 is trying to acquire lock:
> ffff000066dd4268 (&dsa_master_addr_list_lock_key/1){+...}-{2:2}, at: dev_mc_sync+0x44/0x90
> 
> but task is already holding lock:
> ffff00006608c268 (&dsa_master_addr_list_lock_key/1){+...}-{2:2}, at: dev_mc_sync+0x44/0x90
> 
> other info that might help us debug this:
>  Possible unsafe locking scenario:
> 
>        CPU0
>        ----
>   lock(&dsa_master_addr_list_lock_key/1);
>   lock(&dsa_master_addr_list_lock_key/1);
> 
>  *** DEADLOCK ***
> 
>  May be due to missing lock nesting notation
> 
> 3 locks held by dhcpcd/323:
>  #0: ffffdbd1381dda18 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock+0x24/0x30
>  #1: ffff00006614b268 (_xmit_ETHER){+...}-{2:2}, at: dev_set_rx_mode+0x28/0x48
>  #2: ffff00006608c268 (&dsa_master_addr_list_lock_key/1){+...}-{2:2}, at: dev_mc_sync+0x44/0x90
> 
> stack backtrace:
> Call trace:
>  dump_backtrace+0x0/0x1e0
>  show_stack+0x20/0x30
>  dump_stack+0xec/0x158
>  __lock_acquire+0xca0/0x2398
>  lock_acquire+0xe8/0x440
>  _raw_spin_lock_nested+0x64/0x90
>  dev_mc_sync+0x44/0x90
>  dsa_slave_set_rx_mode+0x34/0x50
>  __dev_set_rx_mode+0x60/0xa0
>  dev_mc_sync+0x84/0x90
>  dsa_slave_set_rx_mode+0x34/0x50
>  __dev_set_rx_mode+0x60/0xa0
>  dev_set_rx_mode+0x30/0x48
>  __dev_open+0x10c/0x180
>  __dev_change_flags+0x170/0x1c8
>  dev_change_flags+0x2c/0x70
>  devinet_ioctl+0x774/0x878
>  inet_ioctl+0x348/0x3b0
>  sock_do_ioctl+0x50/0x310
>  sock_ioctl+0x1f8/0x580
>  ksys_ioctl+0xb0/0xf0
>  __arm64_sys_ioctl+0x28/0x38
>  el0_svc_common.constprop.0+0x7c/0x180
>  do_el0_svc+0x2c/0x98
>  el0_sync_handler+0x9c/0x1b8
>  el0_sync+0x158/0x180
> 
> Since DSA never made use of the netdev API for describing links between
> upper devices and lower devices, the dev->lower_level value of a DSA
> switch interface would be 1, which would warn when it is a DSA master.
> 
> We can use netdev_upper_dev_link() to describe the relationship between
> a DSA slave and a DSA master. To be precise, a DSA "slave" (switch port)
> is an "upper" to a DSA "master" (host port). The relationship is "many
> uppers to one lower", like in the case of VLAN. So, for that reason, we
> use the same function as VLAN uses.
> 
> Since this warning was not there when lockdep was using dynamic keys for
> addr_list_lock, we are blaming the lockdep patch itself. The network
> stack _has_ been using static lockdep keys before, and it _is_ likely
> that stacked DSA setups have been triggering these lockdep warnings
> since forever, however I can't test very old kernels on this particular
> stacked DSA setup, to ensure I'm not in fact introducing regressions.
> 
> Fixes: 845e0ebb4408 ("net: change addr_list_lock back to static key")
> Suggested-by: Cong Wang <xiyou.wangcong@gmail.com>
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Jiri suggested not doing this a few years ago, but I do not remember the
reasons why he advised against doing it. Jiri does your objection still
stand today?

> ---
>  net/dsa/slave.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index 743caabeaaa6..a951b2a7d79a 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -1994,6 +1994,13 @@ int dsa_slave_create(struct dsa_port *port)
>  			   ret, slave_dev->name);
>  		goto out_phy;
>  	}
> +	rtnl_lock();
> +	ret = netdev_upper_dev_link(master, slave_dev, NULL);
> +	rtnl_unlock();
> +	if (ret) {
> +		unregister_netdevice(slave_dev);
> +		goto out_phy;
> +	}
>  
>  	return 0;
>  
> @@ -2013,11 +2020,13 @@ int dsa_slave_create(struct dsa_port *port)
>  
>  void dsa_slave_destroy(struct net_device *slave_dev)
>  {
> +	struct net_device *master = dsa_slave_to_master(slave_dev);
>  	struct dsa_port *dp = dsa_slave_to_port(slave_dev);
>  	struct dsa_slave_priv *p = netdev_priv(slave_dev);
>  
>  	netif_carrier_off(slave_dev);
>  	rtnl_lock();
> +	netdev_upper_dev_unlink(master, slave_dev);
>  	phylink_disconnect_phy(dp->pl);
>  	rtnl_unlock();
>  
> 

-- 
Florian
