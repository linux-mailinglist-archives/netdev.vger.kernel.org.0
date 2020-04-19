Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1F121AF83D
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 09:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725987AbgDSHdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 03:33:12 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:59701 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgDSHdL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 03:33:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1587281590; x=1618817590;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=MIX8vV0I/WJoG1HzzRkaMGbk1gT8eBkAe11am86xcxY=;
  b=0KnQ8qiegHJdU/gXSW+zvlp0J0f2JTEBB3aMY7p2PCCqxbvbx1iYRtK8
   xQjxVKDpwC+c+6zBLoBwaO3EWHdlcXM82V+gZK6gjWpU0DMmlclf3ICxZ
   nMZ+ich4BbGl0R9Ajcg6OydTwe8iu4qynXrWjHt7Zaw/YFacd07SQR8DP
   1Wq+uY0+9+8X51C1Fo8XhLWrvSeT8Ives/Q1XDl4eOEw7RNFuObev7ovC
   tSq06ArRUOig9xGcXPWHxVxoEZb6Q57p9QF5mkIoWh0x8YiOfDr55YmU1
   1ZTM5uqM96E+OmBAEY9GAiKkcELtry4HD0YRtkRoDYuuQ8G+V1TjqLWYt
   A==;
IronPort-SDR: yBusc+i4PhzxCsXpz+b6xg3AjnnhzGA97GcktmJB85PUSL4aI+eZIkOJWTIN28/QkQkNcOHIhj
 L7P00ndQVT2CW8Arl8bK3kgBJ/LJvOaIcxi0Pn2XPNZfMKcSKn7ZsBd+yLs5r87nh5v4V4Vblp
 9KBlcbSj6d5F6En/sGrk7hROM6RyaQ2R8jLYYAOmVR1I+HatvgtGwH4dHTWtI3I99h6OAsZpUx
 f0Lw3p+j9Tm06BrZ0vZWG5iCuBf8TBybtVL7M4aIC6MDJ+k+ASEmAg/CERregv2AQMVnm/CIws
 qqU=
X-IronPort-AV: E=Sophos;i="5.72,402,1580799600"; 
   d="scan'208";a="73011178"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Apr 2020 00:33:10 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 19 Apr 2020 00:33:08 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Sun, 19 Apr 2020 00:32:43 -0700
Date:   Sun, 19 Apr 2020 09:33:07 +0200
From:   "Allan W. Nielsen" <allan.nielsen@microchip.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     <davem@davemloft.net>, <horatiu.vultur@microchip.com>,
        <alexandre.belloni@bootlin.com>, <antoine.tenart@bootlin.com>,
        <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <vivien.didelot@gmail.com>, <joergen.andreasen@microchip.com>,
        <claudiu.manoil@nxp.com>, <netdev@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <alexandru.marginean@nxp.com>,
        <xiaoliang.yang_1@nxp.com>, <yangbo.lu@nxp.com>, <po.liu@nxp.com>,
        <jiri@mellanox.com>, <idosch@idosch.org>, <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: mscc: ocelot: deal with problematic
 MAC_ETYPE VCAP IS2 rules
Message-ID: <20200419073307.uhm3w2jhsczpchvi@ws.localdomain>
References: <20200417190308.32598-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <20200417190308.32598-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Sorry I did not manage to provide feedback before it was merged (I will
need to consult some of my colleagues Monday before I can provide the
foll feedback).

There are many good things in this patch, but it is not only good.

The problem is that these TCAMs/VCAPs are insanely complicated and it is
really hard to make them fit nicely into the existing tc frame-work
(being hard does not mean that we should not try).

In this patch, you try to automatic figure out who the user want the
TCAM to be configured. It works for 1 use-case but it breaks others.

Before this patch you could do a:
     tc filter add dev swp0 ingress protocol ipv4 \
             flower skip_sw src_ip 10.0.0.1 action drop
     tc filter add dev swp0 ingress \
             flower skip_sw src_mac 96:18:82:00:04:01 action drop

But the second rule would not apply to the ICMP over IPv4 over Ethernet
packet, it would however apply to non-IP packets.

With this patch it not possible. Your use-case is more common, but the
other one is not unrealistic.

My concern with this, is that I do not think it is possible to automatic
detect how these TCAMs needs to be configured by only looking at the
rules installed by the user. Trying to do this automatic, also makes the
TCAM logic even harder to understand for the user.

I would prefer that we by default uses some conservative default
settings which are easy to understand, and then expose some expert
settings in the sysfs, which can be used to achieve different
behavioral.

Maybe forcing MAC_ETYPE matches is the most conservative and easiest to
understand default.

But I do seem to recall that there is a way to allow matching on both
SMAC and SIP (your original motivation). This may be a better default
(despite that it consumes more TCAM resources). I will follow up and
check if this is possible.

Vladimir (and anyone else whom interested): would you be interested in
spending some time discussion the more high-level architectures and
use-cases on how to best integrate this TCAM architecture into the Linux
kernel. Not sure on the outlook for the various conferences, but we
could arrange some online session to discuss this.

/Allan


On 17.04.2020 22:03, Vladimir Oltean wrote:
>EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>
>From: Vladimir Oltean <vladimir.oltean@nxp.com>
>
>By default, the VCAP IS2 will produce a single match for each frame, on
>the most specific classification.
>
>Example: a ping packet (ICMP over IPv4 over Ethernet) sent from an IP
>address of 10.0.0.1 and a MAC address of 96:18:82:00:04:01 will match
>this rule:
>
>tc filter add dev swp0 ingress protocol ipv4 \
>        flower skip_sw src_ip 10.0.0.1 action drop
>
>but not this one:
>
>tc filter add dev swp0 ingress \
>        flower skip_sw src_mac 96:18:82:00:04:01 action drop
>
>Currently the driver does not really warn the user in any way about
>this, and the behavior is rather strange anyway.
>
>The current patch is a workaround to force matches on MAC_ETYPE keys
>(DMAC and SMAC) for all packets irrespective of higher layer protocol.
>The setting is made at the port level.
>
>Of course this breaks all other non-src_mac and non-dst_mac matches, so
>rule exclusivity checks have been added to the driver, in order to never
>have rules of both types on any ingress port.
>
>The bits that discard higher-level protocol information are set only
>once a MAC_ETYPE rule is added to a filter block, and only for the ports
>that are bound to that filter block. Then all further non-MAC_ETYPE
>rules added to that filter block should be denied by the ports bound to
>it.
>
>Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>---
> drivers/net/ethernet/mscc/ocelot_ace.c    | 103 +++++++++++++++++++++-
> drivers/net/ethernet/mscc/ocelot_ace.h    |   5 +-
> drivers/net/ethernet/mscc/ocelot_flower.c |   2 +-
> 3 files changed, 106 insertions(+), 4 deletions(-)
>
>diff --git a/drivers/net/ethernet/mscc/ocelot_ace.c b/drivers/net/ethernet/mscc/ocelot_ace.c
>index 3bd286044480..8a2f7d13ef6d 100644
>--- a/drivers/net/ethernet/mscc/ocelot_ace.c
>+++ b/drivers/net/ethernet/mscc/ocelot_ace.c
>@@ -706,13 +706,114 @@ ocelot_ace_rule_get_rule_index(struct ocelot_acl_block *block, int index)
>        return NULL;
> }
>
>+/* If @on=false, then SNAP, ARP, IP and OAM frames will not match on keys based
>+ * on destination and source MAC addresses, but only on higher-level protocol
>+ * information. The only frame types to match on keys containing MAC addresses
>+ * in this case are non-SNAP, non-ARP, non-IP and non-OAM frames.
>+ *
>+ * If @on=true, then the above frame types (SNAP, ARP, IP and OAM) will match
>+ * on MAC_ETYPE keys such as destination and source MAC on this ingress port.
>+ * However the setting has the side effect of making these frames not matching
>+ * on any _other_ keys than MAC_ETYPE ones.
>+ */
>+static void ocelot_match_all_as_mac_etype(struct ocelot *ocelot, int port,
>+                                         bool on)
>+{
>+       u32 val = 0;
>+
>+       if (on)
>+               val = ANA_PORT_VCAP_S2_CFG_S2_SNAP_DIS(3) |
>+                     ANA_PORT_VCAP_S2_CFG_S2_ARP_DIS(3) |
>+                     ANA_PORT_VCAP_S2_CFG_S2_IP_TCPUDP_DIS(3) |
>+                     ANA_PORT_VCAP_S2_CFG_S2_IP_OTHER_DIS(3) |
>+                     ANA_PORT_VCAP_S2_CFG_S2_OAM_DIS(3);
>+
>+       ocelot_rmw_gix(ocelot, val,
>+                      ANA_PORT_VCAP_S2_CFG_S2_SNAP_DIS_M |
>+                      ANA_PORT_VCAP_S2_CFG_S2_ARP_DIS_M |
>+                      ANA_PORT_VCAP_S2_CFG_S2_IP_TCPUDP_DIS_M |
>+                      ANA_PORT_VCAP_S2_CFG_S2_IP_OTHER_DIS_M |
>+                      ANA_PORT_VCAP_S2_CFG_S2_OAM_DIS_M,
>+                      ANA_PORT_VCAP_S2_CFG, port);
>+}
>+
>+static bool ocelot_ace_is_problematic_mac_etype(struct ocelot_ace_rule *ace)
>+{
>+       if (ace->type != OCELOT_ACE_TYPE_ETYPE)
>+               return false;
>+       if (ether_addr_to_u64(ace->frame.etype.dmac.value) &
>+           ether_addr_to_u64(ace->frame.etype.dmac.mask))
>+               return true;
>+       if (ether_addr_to_u64(ace->frame.etype.smac.value) &
>+           ether_addr_to_u64(ace->frame.etype.smac.mask))
>+               return true;
>+       return false;
>+}
>+
>+static bool ocelot_ace_is_problematic_non_mac_etype(struct ocelot_ace_rule *ace)
>+{
>+       if (ace->type == OCELOT_ACE_TYPE_SNAP)
>+               return true;
>+       if (ace->type == OCELOT_ACE_TYPE_ARP)
>+               return true;
>+       if (ace->type == OCELOT_ACE_TYPE_IPV4)
>+               return true;
>+       if (ace->type == OCELOT_ACE_TYPE_IPV6)
>+               return true;
>+       return false;
>+}
>+
>+static bool ocelot_exclusive_mac_etype_ace_rules(struct ocelot *ocelot,
>+                                                struct ocelot_ace_rule *ace)
>+{
>+       struct ocelot_acl_block *block = &ocelot->acl_block;
>+       struct ocelot_ace_rule *tmp;
>+       unsigned long port;
>+       int i;
>+
>+       if (ocelot_ace_is_problematic_mac_etype(ace)) {
>+               /* Search for any non-MAC_ETYPE rules on the port */
>+               for (i = 0; i < block->count; i++) {
>+                       tmp = ocelot_ace_rule_get_rule_index(block, i);
>+                       if (tmp->ingress_port_mask & ace->ingress_port_mask &&
>+                           ocelot_ace_is_problematic_non_mac_etype(tmp))
>+                               return false;
>+               }
>+
>+               for_each_set_bit(port, &ace->ingress_port_mask,
>+                                ocelot->num_phys_ports)
>+                       ocelot_match_all_as_mac_etype(ocelot, port, true);
>+       } else if (ocelot_ace_is_problematic_non_mac_etype(ace)) {
>+               /* Search for any MAC_ETYPE rules on the port */
>+               for (i = 0; i < block->count; i++) {
>+                       tmp = ocelot_ace_rule_get_rule_index(block, i);
>+                       if (tmp->ingress_port_mask & ace->ingress_port_mask &&
>+                           ocelot_ace_is_problematic_mac_etype(tmp))
>+                               return false;
>+               }
>+
>+               for_each_set_bit(port, &ace->ingress_port_mask,
>+                                ocelot->num_phys_ports)
>+                       ocelot_match_all_as_mac_etype(ocelot, port, false);
>+       }
>+
>+       return true;
>+}
>+
> int ocelot_ace_rule_offload_add(struct ocelot *ocelot,
>-                               struct ocelot_ace_rule *rule)
>+                               struct ocelot_ace_rule *rule,
>+                               struct netlink_ext_ack *extack)
> {
>        struct ocelot_acl_block *block = &ocelot->acl_block;
>        struct ocelot_ace_rule *ace;
>        int i, index;
>
>+       if (!ocelot_exclusive_mac_etype_ace_rules(ocelot, rule)) {
>+               NL_SET_ERR_MSG_MOD(extack,
>+                                  "Cannot mix MAC_ETYPE with non-MAC_ETYPE rules");
>+               return -EBUSY;
>+       }
>+
>        /* Add rule to the linked list */
>        ocelot_ace_rule_add(ocelot, block, rule);
>
>diff --git a/drivers/net/ethernet/mscc/ocelot_ace.h b/drivers/net/ethernet/mscc/ocelot_ace.h
>index 29d22c566786..099e177f2617 100644
>--- a/drivers/net/ethernet/mscc/ocelot_ace.h
>+++ b/drivers/net/ethernet/mscc/ocelot_ace.h
>@@ -194,7 +194,7 @@ struct ocelot_ace_rule {
>
>        enum ocelot_ace_action action;
>        struct ocelot_ace_stats stats;
>-       u16 ingress_port_mask;
>+       unsigned long ingress_port_mask;
>
>        enum ocelot_vcap_bit dmac_mc;
>        enum ocelot_vcap_bit dmac_bc;
>@@ -215,7 +215,8 @@ struct ocelot_ace_rule {
> };
>
> int ocelot_ace_rule_offload_add(struct ocelot *ocelot,
>-                               struct ocelot_ace_rule *rule);
>+                               struct ocelot_ace_rule *rule,
>+                               struct netlink_ext_ack *extack);
> int ocelot_ace_rule_offload_del(struct ocelot *ocelot,
>                                struct ocelot_ace_rule *rule);
> int ocelot_ace_rule_stats_update(struct ocelot *ocelot,
>diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
>index 341923311fec..954cb67eeaa2 100644
>--- a/drivers/net/ethernet/mscc/ocelot_flower.c
>+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
>@@ -205,7 +205,7 @@ int ocelot_cls_flower_replace(struct ocelot *ocelot, int port,
>                return ret;
>        }
>
>-       return ocelot_ace_rule_offload_add(ocelot, ace);
>+       return ocelot_ace_rule_offload_add(ocelot, ace, f->common.extack);
> }
> EXPORT_SYMBOL_GPL(ocelot_cls_flower_replace);
>
>--
>2.17.1
>
/Allan
