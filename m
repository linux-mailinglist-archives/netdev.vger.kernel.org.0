Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 244ED2608EE
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 05:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728355AbgIHDNE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 23:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbgIHDNE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 23:13:04 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13E3EC061573
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 20:13:04 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id 7so9029662pgm.11
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 20:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PB6idRaGPReU7lsob7+rFIS9hmfGZeNh4OuuQ2aQGz4=;
        b=fGedc11TP9er2wa8ZhGBqaUDT23wZCmIsyXRl8gST/3NUy+UW8Psf2PTxM4v7Eu1/g
         0CE7gzo3GP0D5DVKjyVvV+t6/5TU3yFcIAu99o5RV+8TMXAOygINFUXb8+xT2QuOw/lI
         T/cT6MSiVIq+Z85526T9RVCnUnHD8v3X4Y2Nbnwv2t4NWcvJY1RLNVqHYe+B3CA67o9V
         /pnYiOvEZ7AOCVdmFzYYHhiRGyaq5Q1THT8XZPt6SPcw5p6Vkm+poXUBE/37ydmk4v+Q
         ZNX/fLBd+RnEnNyl+1ULK42IkmA52o1sL+xxNYm+z8qz4Ba91lSISbLmwIyjLjri96M5
         kylw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PB6idRaGPReU7lsob7+rFIS9hmfGZeNh4OuuQ2aQGz4=;
        b=FBkOx7yO1zet4WnVSvr8Xpi6qfTEsnzhX0aTAYMFI1WQEwcvAl8iZUiFqUMDayf1JF
         icDt1uyrnxxTq/gYFwynXHV3Wn2HQNtLq4kXNorXWIe+ejJzmicJk67icuaitqqxTSRp
         Rc4ZfesKs3wt/1EGxIqIJ/A4kMVtae9VEzKOOTBoATLCHhZMLId4TyPAhUSdp5W4q8uq
         g3qSHvPAax2tBsFpW9VZrEvVgjv43+IjnwJAHcZ8vuGf4CzPIiNeZwd9VQ+oRytofkQg
         ri8Q0NdMob4odj2OtALMtn5nIVmIHeHynNPe62QRz+vO5U/730UTvisolcHCmcycSE78
         dr9Q==
X-Gm-Message-State: AOAM532BusyWWrRLaWMqhuDK25w6OzoJDF8DauBxjc0vs+naCrLY+o9O
        bXm0ub7yBvy9a8i5E4IGpfkLK5Ivr1c=
X-Google-Smtp-Source: ABdhPJyk+WEKKKw4PdUng3cHanvsySzhz9RkpwVo8R25XOp/NyS2QNWTpkpj69E+aTeZpVLsNcOSjA==
X-Received: by 2002:a17:902:8b88:: with SMTP id ay8mr22282301plb.17.1599534782268;
        Mon, 07 Sep 2020 20:13:02 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id k4sm17702378pfp.189.2020.09.07.20.13.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Sep 2020 20:13:01 -0700 (PDT)
Subject: Re: [PATCH v2 net] net: dsa: link interfaces with the DSA master to
 get rid of lockdep warnings
To:     Vladimir Oltean <olteanv@gmail.com>, kuba@kernel.org
Cc:     vivien.didelot@gmail.com, andrew@lunn.ch, xiyou.wangcong@gmail.com,
        ap420073@gmail.com, netdev@vger.kernel.org
References: <20200907234842.1684223-1-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <ebfe43c6-a576-ba33-11e0-a2d143b56de3@gmail.com>
Date:   Mon, 7 Sep 2020 20:13:00 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <20200907234842.1684223-1-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/7/2020 4:48 PM, Vladimir Oltean wrote:
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
>   Possible unsafe locking scenario:
> 
>         CPU0
>         ----
>    lock(&dsa_master_addr_list_lock_key/1);
>    lock(&dsa_master_addr_list_lock_key/1);
> 
>   *** DEADLOCK ***
> 
>   May be due to missing lock nesting notation
> 
> 3 locks held by dhcpcd/323:
>   #0: ffffdbd1381dda18 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock+0x24/0x30
>   #1: ffff00006614b268 (_xmit_ETHER){+...}-{2:2}, at: dev_set_rx_mode+0x28/0x48
>   #2: ffff00006608c268 (&dsa_master_addr_list_lock_key/1){+...}-{2:2}, at: dev_mc_sync+0x44/0x90
> 
> stack backtrace:
> Call trace:
>   dump_backtrace+0x0/0x1e0
>   show_stack+0x20/0x30
>   dump_stack+0xec/0x158
>   __lock_acquire+0xca0/0x2398
>   lock_acquire+0xe8/0x440
>   _raw_spin_lock_nested+0x64/0x90
>   dev_mc_sync+0x44/0x90
>   dsa_slave_set_rx_mode+0x34/0x50
>   __dev_set_rx_mode+0x60/0xa0
>   dev_mc_sync+0x84/0x90
>   dsa_slave_set_rx_mode+0x34/0x50
>   __dev_set_rx_mode+0x60/0xa0
>   dev_set_rx_mode+0x30/0x48
>   __dev_open+0x10c/0x180
>   __dev_change_flags+0x170/0x1c8
>   dev_change_flags+0x2c/0x70
>   devinet_ioctl+0x774/0x878
>   inet_ioctl+0x348/0x3b0
>   sock_do_ioctl+0x50/0x310
>   sock_ioctl+0x1f8/0x580
>   ksys_ioctl+0xb0/0xf0
>   __arm64_sys_ioctl+0x28/0x38
>   el0_svc_common.constprop.0+0x7c/0x180
>   do_el0_svc+0x2c/0x98
>   el0_sync_handler+0x9c/0x1b8
>   el0_sync+0x158/0x180
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
> There might be a chance that somebody will try to take hold of this
> interface and use it immediately after register_netdev() and before
> netdev_upper_dev_link(). To avoid that, we do the registration and
> linkage while holding the RTNL, and we use the RTNL-locked cousin of
> register_netdev(), which is register_netdevice().
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

I was worried for a second that dsa_slave_notify(slave_dev, 
DSA_PORT_UNREGISTER) would no longer work after your changes, but we are 
only providing references to both slave_dev and master and this actually 
makes the unregister symmetrical with the register whereby the slave_dev 
reference is not in a registered state for both events.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
