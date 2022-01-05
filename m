Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A576485086
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 11:00:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239147AbiAEJ75 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 04:59:57 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:15404 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239133AbiAEJ7z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 04:59:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1641376795; x=1672912795;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=R0gYk0fmYoG3XTMQFDch/j+AW6D6z74sgXAgSuH8zJ0=;
  b=UwVz45baG9V+V29rQgf/vgb2KfLz0DKqfn+FuQyDM6McC+73nzy+FI92
   4FObvlVeCb3picRempV6SNa0PRQTY2eoXBvd7yp13HREL0IkhKsmBVAIY
   +YohZAgCM8CLhx3izUIREPltfReYStowze+D9JDhqEHKqqAgJ6hNepVUA
   x+u7PKf4NGsosea5q/Dhir+ONnmc4G+lt4QRNhDuCDEOYhlNT4gA1bpyo
   zHGrmAG14NgZVoerSYfWMoOB+0rwzxkCdDvrn4gmzdqdyTm9SQGy5pQ8g
   NcM3IzUHt0fkPn0UnQfOxb4X/QA7Z9um/AwM7R3P38pkCScaO7GgIP6cH
   Q==;
IronPort-SDR: K2c3jFQjdaqD+tsdI/Zo7H/El4PmX2WlICaFHzWcgjCR+OiGXAZlMNLspD8ZJSUSgvgKW99lZX
 th/TVsviYOqfuO2ydXFqireBLcTsb1MPqXQiRa50cCiB8CHjg9PwFbHT6fbDIVPO70EiBGEnay
 YCWTbKLGcD9FYrEug3IwG2sxkS7G39kxHMFUCMAAPWcy/KJF3IIP79/P0lx3k9na4JbInOzS9f
 2W3JCV3WzfuPgIW3yByTwBmF7g7wAFMfuUU3O16IRB1D99/WNU47Pdx574/1p+mCQczSRP70Z8
 7Z3ELwLcOyZCUyXa/RqaP+Dd
X-IronPort-AV: E=Sophos;i="5.88,263,1635231600"; 
   d="scan'208";a="144400832"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Jan 2022 02:59:42 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 5 Jan 2022 02:59:37 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Wed, 5 Jan 2022 02:59:37 -0700
Date:   Wed, 5 Jan 2022 11:01:52 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next 07/15] net: dsa: remove cross-chip support for
 MRP
Message-ID: <20220105100152.cnu3zcjmqp6vizer@soft-dev3-1.localhost>
References: <20220104171413.2293847-1-vladimir.oltean@nxp.com>
 <20220104171413.2293847-8-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20220104171413.2293847-8-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 01/04/2022 19:14, Vladimir Oltean wrote:
> 
> The cross-chip notifiers for MRP are bypass operations, meaning that
> even though all switches in a tree are notified, only the switch
> specified in the info structure is targeted.
> 
> We can eliminate the unnecessary complexity by deleting the cross-chip
> notifier logic and calling the ds->ops straight from port.c.

It looks like structs dsa_notifier_mrp_info and
dsa_notifier_mrp_ring_role_info are not used anywhere anymore. So they
should also be deleted.

> 
> Cc: Horatiu Vultur <horatiu.vultur@microchip.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  net/dsa/dsa_priv.h |  4 ---
>  net/dsa/port.c     | 44 +++++++++++++++----------------
>  net/dsa/switch.c   | 64 ----------------------------------------------
>  3 files changed, 20 insertions(+), 92 deletions(-)
> 
> diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
> index b5ae21f172a8..54c23479b9ba 100644
> --- a/net/dsa/dsa_priv.h
> +++ b/net/dsa/dsa_priv.h
> @@ -40,10 +40,6 @@ enum {
>         DSA_NOTIFIER_TAG_PROTO,
>         DSA_NOTIFIER_TAG_PROTO_CONNECT,
>         DSA_NOTIFIER_TAG_PROTO_DISCONNECT,
> -       DSA_NOTIFIER_MRP_ADD,
> -       DSA_NOTIFIER_MRP_DEL,
> -       DSA_NOTIFIER_MRP_ADD_RING_ROLE,
> -       DSA_NOTIFIER_MRP_DEL_RING_ROLE,
>         DSA_NOTIFIER_TAG_8021Q_VLAN_ADD,
>         DSA_NOTIFIER_TAG_8021Q_VLAN_DEL,
>  };
> diff --git a/net/dsa/port.c b/net/dsa/port.c
> index 05677e016982..5c72f890c6a2 100644
> --- a/net/dsa/port.c
> +++ b/net/dsa/port.c
> @@ -907,49 +907,45 @@ int dsa_port_vlan_del(struct dsa_port *dp,
>  int dsa_port_mrp_add(const struct dsa_port *dp,
>                      const struct switchdev_obj_mrp *mrp)
>  {
> -       struct dsa_notifier_mrp_info info = {
> -               .sw_index = dp->ds->index,
> -               .port = dp->index,
> -               .mrp = mrp,
> -       };
> +       struct dsa_switch *ds = dp->ds;
> +
> +       if (!ds->ops->port_mrp_add)
> +               return -EOPNOTSUPP;
> 
> -       return dsa_port_notify(dp, DSA_NOTIFIER_MRP_ADD, &info);
> +       return ds->ops->port_mrp_add(ds, dp->index, mrp);
>  }
> 
>  int dsa_port_mrp_del(const struct dsa_port *dp,
>                      const struct switchdev_obj_mrp *mrp)
>  {
> -       struct dsa_notifier_mrp_info info = {
> -               .sw_index = dp->ds->index,
> -               .port = dp->index,
> -               .mrp = mrp,
> -       };
> +       struct dsa_switch *ds = dp->ds;
> +
> +       if (!ds->ops->port_mrp_del)
> +               return -EOPNOTSUPP;
> 
> -       return dsa_port_notify(dp, DSA_NOTIFIER_MRP_DEL, &info);
> +       return ds->ops->port_mrp_del(ds, dp->index, mrp);
>  }
> 
>  int dsa_port_mrp_add_ring_role(const struct dsa_port *dp,
>                                const struct switchdev_obj_ring_role_mrp *mrp)
>  {
> -       struct dsa_notifier_mrp_ring_role_info info = {
> -               .sw_index = dp->ds->index,
> -               .port = dp->index,
> -               .mrp = mrp,
> -       };
> +       struct dsa_switch *ds = dp->ds;
> +
> +       if (!ds->ops->port_mrp_add)
> +               return -EOPNOTSUPP;
> 
> -       return dsa_port_notify(dp, DSA_NOTIFIER_MRP_ADD_RING_ROLE, &info);
> +       return ds->ops->port_mrp_add_ring_role(ds, dp->index, mrp);
>  }
> 
>  int dsa_port_mrp_del_ring_role(const struct dsa_port *dp,
>                                const struct switchdev_obj_ring_role_mrp *mrp)
>  {
> -       struct dsa_notifier_mrp_ring_role_info info = {
> -               .sw_index = dp->ds->index,
> -               .port = dp->index,
> -               .mrp = mrp,
> -       };
> +       struct dsa_switch *ds = dp->ds;
> +
> +       if (!ds->ops->port_mrp_del)
> +               return -EOPNOTSUPP;
> 
> -       return dsa_port_notify(dp, DSA_NOTIFIER_MRP_DEL_RING_ROLE, &info);
> +       return ds->ops->port_mrp_del_ring_role(ds, dp->index, mrp);
>  }
> 
>  void dsa_port_set_tag_protocol(struct dsa_port *cpu_dp,
> diff --git a/net/dsa/switch.c b/net/dsa/switch.c
> index 393f2d8a860a..a164ec02b4e9 100644
> --- a/net/dsa/switch.c
> +++ b/net/dsa/switch.c
> @@ -701,58 +701,6 @@ dsa_switch_disconnect_tag_proto(struct dsa_switch *ds,
>         return 0;
>  }
> 
> -static int dsa_switch_mrp_add(struct dsa_switch *ds,
> -                             struct dsa_notifier_mrp_info *info)
> -{
> -       if (!ds->ops->port_mrp_add)
> -               return -EOPNOTSUPP;
> -
> -       if (ds->index == info->sw_index)
> -               return ds->ops->port_mrp_add(ds, info->port, info->mrp);
> -
> -       return 0;
> -}
> -
> -static int dsa_switch_mrp_del(struct dsa_switch *ds,
> -                             struct dsa_notifier_mrp_info *info)
> -{
> -       if (!ds->ops->port_mrp_del)
> -               return -EOPNOTSUPP;
> -
> -       if (ds->index == info->sw_index)
> -               return ds->ops->port_mrp_del(ds, info->port, info->mrp);
> -
> -       return 0;
> -}
> -
> -static int
> -dsa_switch_mrp_add_ring_role(struct dsa_switch *ds,
> -                            struct dsa_notifier_mrp_ring_role_info *info)
> -{
> -       if (!ds->ops->port_mrp_add)
> -               return -EOPNOTSUPP;
> -
> -       if (ds->index == info->sw_index)
> -               return ds->ops->port_mrp_add_ring_role(ds, info->port,
> -                                                      info->mrp);
> -
> -       return 0;
> -}
> -
> -static int
> -dsa_switch_mrp_del_ring_role(struct dsa_switch *ds,
> -                            struct dsa_notifier_mrp_ring_role_info *info)
> -{
> -       if (!ds->ops->port_mrp_del)
> -               return -EOPNOTSUPP;
> -
> -       if (ds->index == info->sw_index)
> -               return ds->ops->port_mrp_del_ring_role(ds, info->port,
> -                                                      info->mrp);
> -
> -       return 0;
> -}
> -
>  static int dsa_switch_event(struct notifier_block *nb,
>                             unsigned long event, void *info)
>  {
> @@ -826,18 +774,6 @@ static int dsa_switch_event(struct notifier_block *nb,
>         case DSA_NOTIFIER_TAG_PROTO_DISCONNECT:
>                 err = dsa_switch_disconnect_tag_proto(ds, info);
>                 break;
> -       case DSA_NOTIFIER_MRP_ADD:
> -               err = dsa_switch_mrp_add(ds, info);
> -               break;
> -       case DSA_NOTIFIER_MRP_DEL:
> -               err = dsa_switch_mrp_del(ds, info);
> -               break;
> -       case DSA_NOTIFIER_MRP_ADD_RING_ROLE:
> -               err = dsa_switch_mrp_add_ring_role(ds, info);
> -               break;
> -       case DSA_NOTIFIER_MRP_DEL_RING_ROLE:
> -               err = dsa_switch_mrp_del_ring_role(ds, info);
> -               break;
>         case DSA_NOTIFIER_TAG_8021Q_VLAN_ADD:
>                 err = dsa_switch_tag_8021q_vlan_add(ds, info);
>                 break;
> --
> 2.25.1
> 

-- 
/Horatiu
