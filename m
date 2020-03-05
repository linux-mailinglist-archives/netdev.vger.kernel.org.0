Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1B117B054
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 22:13:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbgCEVNw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 16:13:52 -0500
Received: from mail-yw1-f67.google.com ([209.85.161.67]:41057 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbgCEVNw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 16:13:52 -0500
Received: by mail-yw1-f67.google.com with SMTP id p124so136745ywc.8
        for <netdev@vger.kernel.org>; Thu, 05 Mar 2020 13:13:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eemFwt8CT75DooD0IviTTrX49R07p6fV1QPOeV6HZ5k=;
        b=V6eLsk2vsZR7vIeeY1xY1LMo7RQwrD6UDwuXihMI1JtMKm0m1nxtRBGxp7xSBQ9h8L
         RVL0r7Qes8qasL9zMcJEPK85gxcFFluelmLLv46FQIF/HQKy8H/+fuRGaDvmVoY91/a9
         AboF52fQ8Fst8AzvX3A7GrVhXTpGUSdzzUPMGIPHlXzFX+cmBhfUNHXMAMSzXNRIpOKL
         WMMJ7vWlVsLw0CqU/IgMwFkYUP4WGHLSTdgomEwIkLiSGNHeagGNc3NpHe7A2AY/BFKd
         rEPwKsOz7ioi4+Tprfl39LxwqvzXWRQk5GOLZmSyggYYCY7BaVV+EgYZrQJFb9Y5vDZS
         9YSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eemFwt8CT75DooD0IviTTrX49R07p6fV1QPOeV6HZ5k=;
        b=h43bKlNLMZzUpPpwf4qofJQ4yv03/NOjhqf/ELmW/iWAHP+/7vMpCA4asQgHn+7emp
         DPNcy2Oe2Q0WW8dLk1CkJK6uilPoojZUBkn/IYjSw4U95NwGvAK66fb+kQUYN8eMiVpD
         B3bKWu/Ug3ggD9JKlXPykzMmSOmGRqaaxQewSs6YjtPndOeUTRL6bCraSzcqVLiTWA5V
         +yeonPd0DymyF8EqktKQjagRLTAYDrpypKqddNQda5F/QCH9FRElnaMONSDdeAa5RpWf
         6urOUBVnW3WOWF/Q9RXJPlKHEKdoTh4wLQ7OwuEgaXJDagE63rTAs9ssKUKdJbsx/yl9
         WRnQ==
X-Gm-Message-State: ANhLgQ36uXguy6nmzyyDe9oLrEbfczZ/3V0N4RCoTp4xD/G6SORBqGIv
        4IylVr2K6mbA3aralvobpZqaHtHonEK6Enkhd6aIeoVE6ko=
X-Google-Smtp-Source: ADFU+vtMzhM5nZRW3UbxwwhWa+UuAaEoyo+42dT7xGwvNIzLt/ANRrYu6s7Qk3r5khq+2x3ZuqpI8eDf2hsemZDch0Y=
X-Received: by 2002:a25:3607:: with SMTP id d7mr281497yba.42.1583442830743;
 Thu, 05 Mar 2020 13:13:50 -0800 (PST)
MIME-Version: 1.0
References: <20200305193101.GA16264@incl>
In-Reply-To: <20200305193101.GA16264@incl>
From:   =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?= 
        <maheshb@google.com>
Date:   Thu, 5 Mar 2020 13:13:34 -0800
Message-ID: <CAF2d9jjnKHy1CHQG1QrbDq1=0wc4rtOLosR6nDBzggO6_rkOKQ@mail.gmail.com>
Subject: Re: [PATCH net] ipvlan: do not add hardware address of master to its
 unicast filter list
To:     Jiri Wiesner <jwiesner@suse.com>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andreas Taschner <Andreas.Taschner@suse.com>,
        Michal Kubecek <mkubecek@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 5, 2020 at 11:31 AM Jiri Wiesner <jwiesner@suse.com> wrote:
>
> There is a problem when ipvlan slaves are created on a master device that
> is a vmxnet3 device (ipvlan in VMware guests). The vmxnet3 driver does not
> support unicast address filtering. When an ipvlan device is brought up in
> ipvlan_open(), the ipvlan driver calls dev_uc_add() to add the hardware
> address of the vmxnet3 master device to the unicast address list of the
> master device, phy_dev->uc. This inevitably leads to the vmxnet3 master
> device being forced into promiscuous mode by __dev_set_rx_mode().
>
> Promiscuous mode is switched on the master despite the fact that there is
> still only one hardware address that the master device should use for
> filtering in order for the ipvlan device to be able to receive packets.
> The comment above struct net_device describes the uc_promisc member as a
> "counter, that indicates, that promiscuous mode has been enabled due to
> the need to listen to additional unicast addresses in a device that does
> not implement ndo_set_rx_mode()". Moreover, the design of ipvlan
> guarantees that only the hardware address of a master device,
> phy_dev->dev_addr, will be used to transmit and receive all packets from
> its ipvlan slaves. Thus, the unicast address list of the master device
> should not be modified by ipvlan_open() and ipvlan_stop() in order to make
> ipvlan a workable option on masters that do not support unicast address
> filtering.
>
> Fixes: 2ad7bf3638411 ("ipvlan: Initial check-in of the IPVLAN driver")
> Reported-by: Per Sundstrom <per.sundstrom@redqube.se>
> Signed-off-by: Jiri Wiesner <jwiesner@suse.com>
Acked-by: Mahesh Bandewar <maheshb@google.com>
> ---
>  drivers/net/ipvlan/ipvlan_main.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
> index a70662261a5a..f23214003d42 100644
> --- a/drivers/net/ipvlan/ipvlan_main.c
> +++ b/drivers/net/ipvlan/ipvlan_main.c
> @@ -178,7 +178,7 @@ static int ipvlan_open(struct net_device *dev)
>                 ipvlan_ht_addr_add(ipvlan, addr);
>         rcu_read_unlock();
>
> -       return dev_uc_add(phy_dev, phy_dev->dev_addr);
> +       return 0;
>  }
>
>  static int ipvlan_stop(struct net_device *dev)
> @@ -190,8 +190,6 @@ static int ipvlan_stop(struct net_device *dev)
>         dev_uc_unsync(phy_dev, dev);
>         dev_mc_unsync(phy_dev, dev);
>
> -       dev_uc_del(phy_dev, phy_dev->dev_addr);
> -
>         rcu_read_lock();
>         list_for_each_entry_rcu(addr, &ipvlan->addrs, anode)
>                 ipvlan_ht_addr_del(addr);
> --
> 2.16.4
>
