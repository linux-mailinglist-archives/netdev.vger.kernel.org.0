Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 477D7207122
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 12:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390245AbgFXK3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 06:29:16 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:10084 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387962AbgFXK3P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 06:29:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1592994555; x=1624530555;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=yGrRZklnrruPHgecJrYbeXz0jFDG57EUhI3217bZdwA=;
  b=eB/MS0cMZP+i1dGdN6vCO5NFel8/OR2g0CefRYfG+TcppBK5PVsLDjpy
   twCiuWbIfhsZtLL5NS26rgZkJzcmod3DckdSOGkuywRlIIu9cMcBoH/k/
   Nl39SdL+0n9YYWIJYmwxxuiEoakurT3J/zb04FRIV/S33huDOC18OrOwL
   L4qHvEhCT1l1vtid9VEMciOhkqMPVG09DJbuSN0M9c8pxYL6ey7NZ/m75
   lVj3Hoth9roCNjFLw4it8O+Kh2Bpv8NHkm0VNfL5Mo4s0giP3gvYdLVFW
   GeDZS7bz7FXrIuZXT7ANYfBcGgc5kbH+30Wz7HjuXZNukcYrR8jTwtbf6
   g==;
IronPort-SDR: QF9yjQ2ujdsb0ncOlgvHmhhBMwQCkscrjqW4/bB7HhH9IWJAHZ9sLcLx8hjpz7chdqyyVce84K
 8QCpW6f1rhQe7Ua9b9rvEkJGY6OveEOaw4EK29MptqltC4LdJmkitYIGTPyufnvfdvilrkihP0
 uUe6e+dyPs2meOxXX1kpd+060HQDYagIHS/YCLJXLIecZrNIvZcyXJchFK9jiKjQ0ZbvvfiNON
 RJX38CuEmnNE9vCKJoxZZihA148rU2x9j5yhsnObODlR5DWTxz7zkumjzOXCcYqIxc+LJjcCvh
 61Q=
X-IronPort-AV: E=Sophos;i="5.75,275,1589266800"; 
   d="scan'208";a="79575176"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Jun 2020 03:29:14 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 24 Jun 2020 03:29:02 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Wed, 24 Jun 2020 03:29:01 -0700
Date:   Wed, 24 Jun 2020 12:29:09 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
CC:     <roopa@cumulusnetworks.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bridge@lists.linux-foundation.org>
Subject: Re: [PATCH net-next] bridge: mrp: Extend MRP netlink interface with
 IFLA_BRIDGE_MRP_CLEAR
Message-ID: <20200624102909.dumxk24at65yjyai@soft-dev3.localdomain>
References: <20200624080537.3154332-1-horatiu.vultur@microchip.com>
 <84c1e063-f49b-ee5a-c5ed-ab6ba5346991@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <84c1e063-f49b-ee5a-c5ed-ab6ba5346991@cumulusnetworks.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 06/24/2020 11:19, Nikolay Aleksandrov wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On 24/06/2020 11:05, Horatiu Vultur wrote:
> > In case the userspace daemon dies, then when is restarted it doesn't
> > know if there are any MRP instances in the kernel. Therefore extend the
> > netlink interface to allow the daemon to clear all MRP instances when is
> > started.
> >
> > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> > ---
> >  include/uapi/linux/if_bridge.h |  8 ++++++++
> >  net/bridge/br_mrp.c            | 15 +++++++++++++++
> >  net/bridge/br_mrp_netlink.c    | 26 ++++++++++++++++++++++++++
> >  net/bridge/br_private_mrp.h    |  1 +
> >  4 files changed, 50 insertions(+)
> >
> > diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
> > index caa6914a3e53a..2ae7d0c0d46b8 100644
> > --- a/include/uapi/linux/if_bridge.h
> > +++ b/include/uapi/linux/if_bridge.h
> > @@ -166,6 +166,7 @@ enum {
> >       IFLA_BRIDGE_MRP_RING_STATE,
> >       IFLA_BRIDGE_MRP_RING_ROLE,
> >       IFLA_BRIDGE_MRP_START_TEST,
> > +     IFLA_BRIDGE_MRP_CLEAR,
> >       __IFLA_BRIDGE_MRP_MAX,
> >  };
> >
> > @@ -228,6 +229,13 @@ enum {
> >
> >  #define IFLA_BRIDGE_MRP_START_TEST_MAX (__IFLA_BRIDGE_MRP_START_TEST_MAX - 1)
> >
> > +enum {
> > +     IFLA_BRIDGE_MRP_CLEAR_UNSPEC,
> > +     __IFLA_BRIDGE_MRP_CLEAR_MAX,
> > +};
> 
> Out of curiousity - do you plan to have any clean attributes?
> In case you don't this can simply be a flag that clears the MRP instances instead
> of a nested attribute.

Currently I don't plan to add any clean attributes. But I have used the
nested attribute just in case in the future something will be needed.

> 
> > +
> > +#define IFLA_BRIDGE_MRP_CLEAR_MAX (__IFLA_BRIDGE_MRP_CLEAR_MAX - 1)
> > +
> >  struct br_mrp_instance {
> >       __u32 ring_id;
> >       __u32 p_ifindex;
> > diff --git a/net/bridge/br_mrp.c b/net/bridge/br_mrp.c
> > index 24986ec7d38cc..02d102edaaaad 100644
> > --- a/net/bridge/br_mrp.c
> > +++ b/net/bridge/br_mrp.c
> > @@ -372,6 +372,21 @@ int br_mrp_del(struct net_bridge *br, struct br_mrp_instance *instance)
> >       return 0;
> >  }
> >
> > +/* Deletes all MRP instances on the bridge
> > + * note: called under rtnl_lock
> > + */
> > +int br_mrp_clear(struct net_bridge *br)
> > +{
> > +     struct br_mrp *mrp;
> > +
> > +     list_for_each_entry_rcu(mrp, &br->mrp_list, list,
> > +                             lockdep_rtnl_is_held()) {
> > +             br_mrp_del_impl(br, mrp);
> 
> I don't think you're in RCU-protected region here, as the lockdep above confirms, which
> means br_mrp_del_impl() can free mrp and you can access freed memory while walking the list
> (trying to access of the next element).
> 
> You should be using list_for_each_entry_safe() to delete elements while walking the list.

Good catch! I will update in the next version.
> 
> Cheers,
>  Nik
> 
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> >  /* Set port state, port state can be forwarding, blocked or disabled
> >   * note: already called with rtnl_lock
> >   */
> > diff --git a/net/bridge/br_mrp_netlink.c b/net/bridge/br_mrp_netlink.c
> > index 34b3a8776991f..5e743538464f6 100644
> > --- a/net/bridge/br_mrp_netlink.c
> > +++ b/net/bridge/br_mrp_netlink.c
> > @@ -14,6 +14,7 @@ static const struct nla_policy br_mrp_policy[IFLA_BRIDGE_MRP_MAX + 1] = {
> >       [IFLA_BRIDGE_MRP_RING_STATE]    = { .type = NLA_NESTED },
> >       [IFLA_BRIDGE_MRP_RING_ROLE]     = { .type = NLA_NESTED },
> >       [IFLA_BRIDGE_MRP_START_TEST]    = { .type = NLA_NESTED },
> > +     [IFLA_BRIDGE_MRP_CLEAR]         = { .type = NLA_NESTED },
> >  };
> >
> >  static const struct nla_policy
> > @@ -235,6 +236,25 @@ static int br_mrp_start_test_parse(struct net_bridge *br, struct nlattr *attr,
> >       return br_mrp_start_test(br, &test);
> >  }
> >
> > +static const struct nla_policy
> > +br_mrp_clear_policy[IFLA_BRIDGE_MRP_CLEAR_MAX + 1] = {
> > +     [IFLA_BRIDGE_MRP_CLEAR_UNSPEC]          = { .type = NLA_REJECT },
> > +};
> > +
> > +static int br_mrp_clear_parse(struct net_bridge *br, struct nlattr *attr,
> > +                           struct netlink_ext_ack *extack)
> > +{
> > +     struct nlattr *tb[IFLA_BRIDGE_MRP_START_TEST_MAX + 1];
> > +     int err;
> > +
> > +     err = nla_parse_nested(tb, IFLA_BRIDGE_MRP_CLEAR_MAX, attr,
> > +                            br_mrp_clear_policy, extack);
> > +     if (err)
> > +             return err;
> > +
> > +     return br_mrp_clear(br);
> > +}
> > +
> >  int br_mrp_parse(struct net_bridge *br, struct net_bridge_port *p,
> >                struct nlattr *attr, int cmd, struct netlink_ext_ack *extack)
> >  {
> > @@ -301,6 +321,12 @@ int br_mrp_parse(struct net_bridge *br, struct net_bridge_port *p,
> >                       return err;
> >       }
> >
> > +     if (tb[IFLA_BRIDGE_MRP_CLEAR]) {
> > +             err = br_mrp_clear_parse(br, tb[IFLA_BRIDGE_MRP_CLEAR], extack);
> > +             if (err)
> > +                     return err;
> > +     }
> > +
> >       return 0;
> >  }
> >
> > diff --git a/net/bridge/br_private_mrp.h b/net/bridge/br_private_mrp.h
> > index 33b255e38ffec..25c3b8596c25b 100644
> > --- a/net/bridge/br_private_mrp.h
> > +++ b/net/bridge/br_private_mrp.h
> > @@ -36,6 +36,7 @@ struct br_mrp {
> >  /* br_mrp.c */
> >  int br_mrp_add(struct net_bridge *br, struct br_mrp_instance *instance);
> >  int br_mrp_del(struct net_bridge *br, struct br_mrp_instance *instance);
> > +int br_mrp_clear(struct net_bridge *br);
> >  int br_mrp_set_port_state(struct net_bridge_port *p,
> >                         enum br_mrp_port_state_type state);
> >  int br_mrp_set_port_role(struct net_bridge_port *p,
> >
> 

-- 
/Horatiu
