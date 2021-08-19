Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6772B3F239C
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 01:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236978AbhHSXTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 19:19:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236976AbhHSXTb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 19:19:31 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0276EC061575
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 16:18:54 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id gt38so16088197ejc.13
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 16:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=S61LkYUw4d1geWpp+QDlaq0lSQGpd4QPKugypwHhKEI=;
        b=YmzmU6+tpIgVmuKjZ3zNiEdbnhL+GWM+1X0hUeWwkub3WerKBUXvhHItWKQ2Rbj5Tj
         wtve9OVYKRD/A9Dd7JpoSpTkvQrtFZfjdLANN4kuZ3pChi3XoTmKsDwzIbDHyt9PDjyq
         Zq8lygK/T/tZ6/J+i4cOI8knWCnFIgX0yfAGkDg9cDcECVLbz5RGMFN9hNIljcC9Yc5O
         Q3WWxbdWCaB/k+zcts3OojfsesgLTC0hWMMa76dN/QdCY5oEtPQ8+UEHqMHiT91kfYpN
         UtQAi6tX99nwXa0jDCPGsO/u059cuQD8lOCEjblQjUHHdmcL4gpcvd4jNQneXP5MnN+y
         IOfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=S61LkYUw4d1geWpp+QDlaq0lSQGpd4QPKugypwHhKEI=;
        b=bjBy275fjeCMfetCSsiRMd/dYPpVUYxLKqEP/ZWlP5+K1iRtgWuM1Bs69oPgiyOBQp
         zJU7ks2Kq12gkx5cpLZrIcLU0foREZs+cVKoK+iF6+Xd6vB3ZsGSQM/dvJAqtdSR92xp
         GowODREP+QlfzEYKE/Vh8g0p3lIl9k6hyy9PgwMkMl6+5OP5vM5IjbHAkzsAw9SKU+QC
         6m5yxN/ajzAe7qv7+64c/FVMP/x7hirjl0qDRFN971WLw10BsBrRXaGYicjJ8YbU8FU/
         Rbp55XhRIQYYB2pzaB9nYk5Ikt/+msk9LEFSEb+CQ6N1OW7ctj+Unx7lBQKofXx/blI3
         +pKg==
X-Gm-Message-State: AOAM533LO+9Jz+wVDYAqngsV9IceHNDQ0FcX3C3zJvIcqmxHH7R9zvpQ
        ZbDfiREDgc1PEo6EIFG5lNc=
X-Google-Smtp-Source: ABdhPJzic9kX5vVIl2CsrIf91yCgBx+jCqTRKuOCUuWdo+8GZiR3uj3KIiNSKO+rUw/DK4lbMNoiqw==
X-Received: by 2002:a17:907:9152:: with SMTP id l18mr18124196ejs.190.1629415132528;
        Thu, 19 Aug 2021 16:18:52 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id s10sm1915920ejc.39.2021.08.19.16.18.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 16:18:52 -0700 (PDT)
Date:   Fri, 20 Aug 2021 02:18:49 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
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
        Jianbo Liu <jianbol@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: [PATCH v2 net-next 1/5] net: switchdev: move
 SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE to the blocking notifier chain
Message-ID: <20210819231849.us3hxtszkwbo2nik@skbuf>
References: <20210819160723.2186424-1-vladimir.oltean@nxp.com>
 <20210819160723.2186424-2-vladimir.oltean@nxp.com>
 <ygnh5yw1pah6.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ygnh5yw1pah6.fsf@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vlad,

On Thu, Aug 19, 2021 at 09:15:17PM +0300, Vlad Buslov wrote:
> On Thu 19 Aug 2021 at 19:07, Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
> > index 0c38c2e319be..ea7c3f07f6fe 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
> > @@ -276,6 +276,55 @@ mlx5_esw_bridge_port_obj_attr_set(struct net_device *dev,
> >  	return err;
> >  }
> >
> > +static struct mlx5_bridge_switchdev_fdb_work *
> > +mlx5_esw_bridge_init_switchdev_fdb_work(struct net_device *dev, bool add,
> > +					struct switchdev_notifier_fdb_info *fdb_info,
> > +					struct mlx5_esw_bridge_offloads *br_offloads);
> > +
> > +static int
> > +mlx5_esw_bridge_fdb_event(struct net_device *dev, unsigned long event,
> > +			  struct switchdev_notifier_info *info,
> > +			  struct mlx5_esw_bridge_offloads *br_offloads)
> > +{
> > +	struct switchdev_notifier_fdb_info *fdb_info;
> > +	struct mlx5_bridge_switchdev_fdb_work *work;
> > +	struct mlx5_eswitch *esw = br_offloads->esw;
> > +	u16 vport_num, esw_owner_vhca_id;
> > +	struct net_device *upper, *rep;
> > +
> > +	upper = netdev_master_upper_dev_get_rcu(dev);
> > +	if (!upper)
> > +		return 0;
> > +	if (!netif_is_bridge_master(upper))
> > +		return 0;
> > +
> > +	rep = mlx5_esw_bridge_rep_vport_num_vhca_id_get(dev, esw,
> > +							&vport_num,
> > +							&esw_owner_vhca_id);
> > +	if (!rep)
> > +		return 0;
> > +
> > +	/* only handle the event on peers */
> > +	if (mlx5_esw_bridge_is_local(dev, rep, esw))
> > +		return 0;
>
> This check is only needed for SWITCHDEV_FDB_DEL_TO_BRIDGE case. Here it
> breaks the offload.

Very good point, thanks for looking. I copied the entire atomic notifier
handler and deleted the code which wasn't needed, but I actually took a
break while converting mlx5, and so I forgot to delete this part when I
came back.

> > +
> > +	fdb_info = container_of(info, struct switchdev_notifier_fdb_info, info);
> > +
> > +	work = mlx5_esw_bridge_init_switchdev_fdb_work(dev,
> > +						       event == SWITCHDEV_FDB_ADD_TO_DEVICE,
> > +						       fdb_info,
>
> Here FDB info can already be deallocated[1] since this is now executing
> asynchronously and races with fdb_rcu_free() that is scheduled to be
> called after rcu grace period by fdb_delete().

I am incredibly lucky that you caught this, apparently I needed to add
an msleep(1000) to see it as well.

It is not the struct switchdev_notifier_fdb_info *fdb_info that gets
freed under RCU. It is fdb_info->addr (the MAC address), since
switchdev_deferred_enqueue only performs a shallow copy. I will address
that in v3.

> > @@ -415,9 +470,7 @@ static int mlx5_esw_bridge_switchdev_event(struct notifier_block *nb,
> >  		/* only handle the event on peers */
> >  		if (mlx5_esw_bridge_is_local(dev, rep, esw))
> >  			break;
>
> I really like the idea of completely remove the driver wq from FDB
> handling code, but I'm not yet too familiar with bridge internals to
> easily determine whether same approach can be applied to
> SWITCHDEV_FDB_{ADD|DEL}_TO_BRIDGE event after this series is accepted.
> It seems that all current users already generate these events from
> blocking context, so would it be a trivial change for me to do in your
> opinion? That would allow me to get rid of mlx5_esw_bridge_offloads->wq
> in our driver.

If all callers really are in blocking context (and they do appear to be)
you can even forgo the switchdev_deferred_enqueue that switchdev_fdb_add_to_device
does, and just call_switchdev_blocking_notifiers() directly. Then you
move the bridge handler from br_switchdev_event() to br_switchdev_blocking_event().
It should be even simpler than this conversion.
