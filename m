Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E798219AEE5
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 17:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733079AbgDAPjL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 11:39:11 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:62185 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732789AbgDAPjL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 11:39:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1585755551; x=1617291551;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Eop4PknjwGrQ4k7lm+1CVE7uOGOVA8tH2UC+zw4GamU=;
  b=jiqbChkL8gjGKSbaxfzaMcekO8dXA22jEiP972p8cIsKuqI7dtWOSAN5
   GIAXABEV7ghGBVfkw3m1wlQYDVMG8yC0sGl8JW7cOBzZxurs4s6lwNbj1
   gSBbdC2VVz3DtG3+sj+R1ep223kPUvWvlC4migQCC2MCecrIoWol1ZT7Y
   NUH2KOAsB6pyAcrPDNPsdq2LsVtK8CZAk3MaLH+PTPeCmMwYCGvMgNtAK
   aKbQw8wfz4XCMjDdWWQhLvC2CMczlgk7Sc8RG0DSQxwM2PIfUC9hKzmn4
   08brdA6dryRg21cRLxHW8EMmt69O/DiclKzcbBvHbHfolWsIEucU2pIif
   w==;
IronPort-SDR: M76zDH0eyerf5chOaatwNkUhSN8SFQol0/q3Df6W6HYfx6l2wES2D1/qYEJ3OBA1juzdWUAhMC
 8SNCfNJtj4y+9ULU91xggJ4xp4Ct8fiyXNm3CM+4jKcB5c0yRK5ZrKX4S9h8aHp4Uftsk1Vvop
 5YcNVKBSpJYRASjo7Kms7wUczuHc/eF5ac2v5anCD72oDy8dkdmu8QBmclyvXikBiBXKhaPDvs
 GIEFKOabfANUuKJDqyP9baMQYvZfbVxF69F60u3Gqcf7PiGxUuAxZdisywanLH4akqiFcXyzL7
 rkw=
X-IronPort-AV: E=Sophos;i="5.72,332,1580799600"; 
   d="scan'208";a="7747253"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Apr 2020 08:39:10 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 1 Apr 2020 08:39:10 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Wed, 1 Apr 2020 08:39:15 -0700
Date:   Wed, 1 Apr 2020 17:39:09 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
CC:     <davem@davemloft.net>, <jiri@resnulli.us>, <ivecera@redhat.com>,
        <kuba@kernel.org>, <roopa@cumulusnetworks.com>,
        <olteanv@gmail.com>, <andrew@lunn.ch>,
        <UNGLinuxDriver@microchip.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bridge@lists.linux-foundation.org>
Subject: Re: [RFC net-next v4 4/9] bridge: mrp: Implement netlink interface
 to configure MRP
Message-ID: <20200401153909.ufhhvigasxhgzrq4@soft-dev3.microsemi.net>
References: <20200327092126.15407-1-horatiu.vultur@microchip.com>
 <20200327092126.15407-5-horatiu.vultur@microchip.com>
 <c64a8e3c-e86a-641d-3cdd-0cec645dd3d1@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <c64a8e3c-e86a-641d-3cdd-0cec645dd3d1@cumulusnetworks.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 03/30/2020 18:30, Nikolay Aleksandrov wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On 27/03/2020 11:21, Horatiu Vultur wrote:
> > Implement netlink interface to configure MRP. The implementation
> > will do sanity checks over the attributes and then eventually call the MRP
> > interface.
> >
> > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> > ---
> >  net/bridge/br_mrp_netlink.c | 176 ++++++++++++++++++++++++++++++++++++
> >  1 file changed, 176 insertions(+)
> >  create mode 100644 net/bridge/br_mrp_netlink.c
> >
> 
> Hi Horatiu,

Hi Nik,

Thanks for the feedback, I will update all this in the new patch series.

> 
> > diff --git a/net/bridge/br_mrp_netlink.c b/net/bridge/br_mrp_netlink.c
> > new file mode 100644
> > index 000000000000..043b7f6cddbe
> > --- /dev/null
> > +++ b/net/bridge/br_mrp_netlink.c
> > @@ -0,0 +1,176 @@
> > +// SPDX-License-Identifier: GPL-2.0-or-later
> > +
> > +#include <net/genetlink.h>
> > +
> > +#include <uapi/linux/mrp_bridge.h>
> > +#include "br_private.h"
> > +#include "br_private_mrp.h"
> > +
> > +static int br_mrp_parse_instance(struct net_bridge *br, struct nlattr *attr,
> > +                              int cmd)
> > +{
> > +     struct br_mrp_instance *instance;
> > +
> > +     if (nla_len(attr) != sizeof(*instance))
> > +             return -EINVAL;
> > +
> > +     instance = nla_data(attr);
> > +
> > +     if (cmd == RTM_SETLINK)
> > +             return br_mrp_add(br, instance);
> > +     else
> > +             return br_mrp_del(br, instance);
> > +}
> > +
> > +static int br_mrp_parse_port_state(struct net_bridge *br,
> > +                                struct net_bridge_port *p,
> > +                                struct nlattr *attr)
> > +{
> > +     enum br_mrp_port_state_type state;
> > +
> > +     if (nla_len(attr) != sizeof(u32) || !p)
> > +             return -EINVAL;
> > +
> > +     state = nla_get_u32(attr);
> > +
> > +     return br_mrp_set_port_state(p, state);
> > +}
> > +
> > +static int br_mrp_parse_port_role(struct net_bridge *br,
> > +                               struct net_bridge_port *p,
> > +                               struct nlattr *attr)
> > +{
> > +     struct br_mrp_port_role *role;
> > +
> > +     if (nla_len(attr) != sizeof(*role) || !p)
> > +             return -EINVAL;
> > +
> > +     role = nla_data(attr);
> > +
> > +     return br_mrp_set_port_role(p, role->ring_id, role->role);
> > +}
> > +
> > +static int br_mrp_parse_ring_state(struct net_bridge *br, struct nlattr *attr)
> > +{
> > +     struct br_mrp_ring_state *state;
> > +
> > +     if (nla_len(attr) != sizeof(*state))
> > +             return -EINVAL;
> > +
> > +     state = nla_data(attr);
> > +
> > +     return br_mrp_set_ring_state(br, state->ring_id, state->ring_state);
> > +}
> > +
> > +static int br_mrp_parse_ring_role(struct net_bridge *br, struct nlattr *attr)
> > +{
> > +     struct br_mrp_ring_role *role;
> > +
> > +     if (nla_len(attr) != sizeof(*role))
> > +             return -EINVAL;
> > +
> > +     role = nla_data(attr);
> > +
> > +     return br_mrp_set_ring_role(br, role->ring_id, role->ring_role);
> > +}
> > +
> > +static int br_mrp_parse_start_test(struct net_bridge *br, struct nlattr *attr)
> > +{
> > +     struct br_mrp_start_test *test;
> > +
> > +     if (nla_len(attr) != sizeof(*test))
> > +             return -EINVAL;
> > +
> > +     test = nla_data(attr);
> > +
> > +     return br_mrp_start_test(br, test->ring_id, test->interval,
> > +                              test->max_miss, test->period);
> > +}
> > +
> > +int br_mrp_parse(struct net_bridge *br, struct net_bridge_port *p,
> > +              struct nlattr *attr, int cmd)
> > +{
> > +     struct nlattr *mrp;
> > +     int rem, err;
> > +
> > +     nla_for_each_nested(mrp, attr, rem) {
> > +             err = 0;
> > +             switch (nla_type(mrp)) {
> > +             case IFLA_BRIDGE_MRP_INSTANCE:
> > +                     err = br_mrp_parse_instance(br, mrp, cmd);
> > +                     if (err)
> > +                             return err;
> > +                     break;
> > +             case IFLA_BRIDGE_MRP_PORT_STATE:
> > +                     err = br_mrp_parse_port_state(br, p, mrp);
> > +                     if (err)
> > +                             return err;
> > +                     break;
> > +             case IFLA_BRIDGE_MRP_PORT_ROLE:
> > +                     err = br_mrp_parse_port_role(br, p, mrp);
> > +                     if (err)
> > +                             return err;
> > +                     break;
> > +             case IFLA_BRIDGE_MRP_RING_STATE:
> > +                     err = br_mrp_parse_ring_state(br, mrp);
> > +                     if (err)
> > +                             return err;
> > +                     break;
> > +             case IFLA_BRIDGE_MRP_RING_ROLE:
> > +                     err = br_mrp_parse_ring_role(br, mrp);
> > +                     if (err)
> > +                             return err;
> > +                     break;
> > +             case IFLA_BRIDGE_MRP_START_TEST:
> > +                     err = br_mrp_parse_start_test(br, mrp);
> > +                     if (err)
> > +                             return err;
> > +                     break;
> > +             }
> > +     }
> > +
> > +     return 0;
> > +}
> 
> All of the above can be implemented via nla_parse_nested() with a proper policy.
> You don't have to manually check for the attribute size. Then your code follows
> the netlink normal (e.g. check the bridge netlink handling) of:
>  nla_parse_nested(tb)
>  if (tb[attr])
>     do_something_with(tb[attr])
>  ...
> 
> 
> > +
> > +void br_mrp_port_open(struct net_device *dev, u8 loc)
> > +{
> > +     struct nlattr *af, *mrp;
> > +     struct ifinfomsg *hdr;
> > +     struct nlmsghdr *nlh;
> > +     struct sk_buff *skb;
> > +     int err = -ENOBUFS;
> > +     struct net *net;
> > +
> > +     net = dev_net(dev);
> > +
> > +     skb = nlmsg_new(1024, GFP_ATOMIC);
> 
> Please add a function which calculates the size based on the attribute sizes.
> 
> > +     if (!skb)
> > +             goto errout;
> > +
> > +     nlh = nlmsg_put(skb, 0, 0, RTM_NEWLINK, sizeof(*hdr), 0);
> > +     if (!nlh)
> > +             goto errout;
> > +
> > +     hdr = nlmsg_data(nlh);
> > +     hdr->ifi_family = AF_BRIDGE;
> > +     hdr->__ifi_pad = 0;
> > +     hdr->ifi_type = dev->type;
> > +     hdr->ifi_index = dev->ifindex;
> > +     hdr->ifi_flags = dev_get_flags(dev);
> > +     hdr->ifi_change = 0;
> > +
> > +     af = nla_nest_start_noflag(skb, IFLA_AF_SPEC);
> > +     mrp = nla_nest_start_noflag(skb, IFLA_BRIDGE_MRP);
> > +
> 
> These can return an error which has to be handled.
> 
> > +     nla_put_u32(skb, IFLA_BRIDGE_MRP_RING_OPEN, loc);
> > +
> 
> Same for this.
> 
> > +     nla_nest_end(skb, mrp);
> > +     nla_nest_end(skb, af);
> > +     nlmsg_end(skb, nlh);
> > +
> > +     rtnl_notify(skb, net, 0, RTNLGRP_LINK, NULL, GFP_ATOMIC);
> > +     return;
> > +errout:
> > +     rtnl_set_sk_err(net, RTNLGRP_LINK, err);
> > +}
> > +EXPORT_SYMBOL(br_mrp_port_open);
> >
> 

-- 
/Horatiu
