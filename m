Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 946391711FD
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 09:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728532AbgB0IKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 03:10:00 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:57069 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728441AbgB0IKA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 03:10:00 -0500
Received-SPF: Pass (esa2.microchip.iphmx.com: domain of
  Allan.Nielsen@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa2.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="Allan.Nielsen@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa2.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa2.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa2.microchip.iphmx.com; spf=Pass smtp.mailfrom=Allan.Nielsen@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: AGGEUQER8H9Vvku6YF0Lzdcqd7Gi1HQ5xTocnRcGuvCXJghvpGDr9p1Z7ZZZKUyloqbRNKpOXH
 pALARDYJIJZgpQZaz2yW5iTIBeNFnWtqVVNbgOJdosxtszS6l6SgsJHqn4ti2HbQ3QGuetW2VD
 pUBMAGjbU6OKGvb9DkwarXIM2DGOzD4MHx+b6NNcFwGJ+/D0b2ILcY2+QbtZZEv5HA2oKmvUpp
 slyYYnvGDLcNGhseHzrlZgkc0+JcgUlCjmoechmlSwGmsSDjb/Y0psLUHCgyiznJqer8if1JlH
 JVo=
X-IronPort-AV: E=Sophos;i="5.70,491,1574146800"; 
   d="scan'208";a="67212924"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Feb 2020 01:09:58 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 27 Feb 2020 01:09:57 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Thu, 27 Feb 2020 01:09:57 -0700
Date:   Thu, 27 Feb 2020 09:09:57 +0100
From:   "Allan W. Nielsen" <allan.nielsen@microchip.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     <davem@davemloft.net>, <horatiu.vultur@microchip.com>,
        <alexandre.belloni@bootlin.com>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>, <vivien.didelot@gmail.com>,
        <joergen.andreasen@microchip.com>, <claudiu.manoil@nxp.com>,
        <netdev@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <alexandru.marginean@nxp.com>, <xiaoliang.yang_1@nxp.com>,
        <yangbo.lu@nxp.com>, <po.liu@nxp.com>, <jiri@mellanox.com>,
        <idosch@idosch.org>, <kuba@kernel.org>
Subject: Re: [PATCH net-next 03/10] net: mscc: ocelot: replace "rule" and
 "ocelot_rule" variable names with "ace"
Message-ID: <20200227080957.aiec5zpj2xxhirue@lx-anielsen.microsemi.net>
References: <20200224130831.25347-1-olteanv@gmail.com>
 <20200224130831.25347-4-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <20200224130831.25347-4-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24.02.2020 15:08, Vladimir Oltean wrote:
>EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>
>From: Vladimir Oltean <vladimir.oltean@nxp.com>
>
>The "ocelot_rule" variable name is both annoyingly long trying to
>distinguish itself from struct flow_rule *rule =
>flow_cls_offload_flow_rule(f), as well as actually different from the
>"ace" variable name which is used all over the place in ocelot_ace.c and
>is referring to the same structure.
>
>And the "rule" variable name is, confusingly, different from f->rule,
>but sometimes one has to look up to the beginning of the function to get
>an understanding of what structure type is actually being handled.
>
>So let's use the "ace" name wherever possible ("Access Control Entry").
>
>Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>---
> drivers/net/ethernet/mscc/ocelot_flower.c | 102 +++++++++++-----------
> 1 file changed, 51 insertions(+), 51 deletions(-)
>
>diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
>index b9673df6dbc5..698e9fee6b1a 100644
>--- a/drivers/net/ethernet/mscc/ocelot_flower.c
>+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
>@@ -9,7 +9,7 @@
> #include "ocelot_ace.h"
>
> static int ocelot_flower_parse_action(struct flow_cls_offload *f,
>-                                     struct ocelot_ace_rule *rule)
>+                                     struct ocelot_ace_rule *ace)
> {
>        const struct flow_action_entry *a;
>        int i;
>@@ -20,10 +20,10 @@ static int ocelot_flower_parse_action(struct flow_cls_offload *f,
>        flow_action_for_each(i, a, &f->rule->action) {
>                switch (a->id) {
>                case FLOW_ACTION_DROP:
>-                       rule->action = OCELOT_ACL_ACTION_DROP;
>+                       ace->action = OCELOT_ACL_ACTION_DROP;
>                        break;
>                case FLOW_ACTION_TRAP:
>-                       rule->action = OCELOT_ACL_ACTION_TRAP;
>+                       ace->action = OCELOT_ACL_ACTION_TRAP;
>                        break;
>                default:
>                        return -EOPNOTSUPP;
>@@ -34,7 +34,7 @@ static int ocelot_flower_parse_action(struct flow_cls_offload *f,
> }
>
> static int ocelot_flower_parse(struct flow_cls_offload *f,
>-                              struct ocelot_ace_rule *ocelot_rule)
>+                              struct ocelot_ace_rule *ace)
> {
>        struct flow_rule *rule = flow_cls_offload_flow_rule(f);
>        struct flow_dissector *dissector = rule->match.dissector;
>@@ -79,14 +79,14 @@ static int ocelot_flower_parse(struct flow_cls_offload *f,
>                        return -EOPNOTSUPP;
>
>                flow_rule_match_eth_addrs(rule, &match);
>-               ocelot_rule->type = OCELOT_ACE_TYPE_ETYPE;
>-               ether_addr_copy(ocelot_rule->frame.etype.dmac.value,
>+               ace->type = OCELOT_ACE_TYPE_ETYPE;
>+               ether_addr_copy(ace->frame.etype.dmac.value,
>                                match.key->dst);
>-               ether_addr_copy(ocelot_rule->frame.etype.smac.value,
>+               ether_addr_copy(ace->frame.etype.smac.value,
>                                match.key->src);
>-               ether_addr_copy(ocelot_rule->frame.etype.dmac.mask,
>+               ether_addr_copy(ace->frame.etype.dmac.mask,
>                                match.mask->dst);
>-               ether_addr_copy(ocelot_rule->frame.etype.smac.mask,
>+               ether_addr_copy(ace->frame.etype.smac.mask,
>                                match.mask->src);
>                goto finished_key_parsing;
>        }
>@@ -96,17 +96,17 @@ static int ocelot_flower_parse(struct flow_cls_offload *f,
>
>                flow_rule_match_basic(rule, &match);
>                if (ntohs(match.key->n_proto) == ETH_P_IP) {
>-                       ocelot_rule->type = OCELOT_ACE_TYPE_IPV4;
>-                       ocelot_rule->frame.ipv4.proto.value[0] =
>+                       ace->type = OCELOT_ACE_TYPE_IPV4;
>+                       ace->frame.ipv4.proto.value[0] =
>                                match.key->ip_proto;
>-                       ocelot_rule->frame.ipv4.proto.mask[0] =
>+                       ace->frame.ipv4.proto.mask[0] =
>                                match.mask->ip_proto;
>                }
>                if (ntohs(match.key->n_proto) == ETH_P_IPV6) {
>-                       ocelot_rule->type = OCELOT_ACE_TYPE_IPV6;
>-                       ocelot_rule->frame.ipv6.proto.value[0] =
>+                       ace->type = OCELOT_ACE_TYPE_IPV6;
>+                       ace->frame.ipv6.proto.value[0] =
>                                match.key->ip_proto;
>-                       ocelot_rule->frame.ipv6.proto.mask[0] =
>+                       ace->frame.ipv6.proto.mask[0] =
>                                match.mask->ip_proto;
>                }
>        }
>@@ -117,16 +117,16 @@ static int ocelot_flower_parse(struct flow_cls_offload *f,
>                u8 *tmp;
>
>                flow_rule_match_ipv4_addrs(rule, &match);
>-               tmp = &ocelot_rule->frame.ipv4.sip.value.addr[0];
>+               tmp = &ace->frame.ipv4.sip.value.addr[0];
>                memcpy(tmp, &match.key->src, 4);
>
>-               tmp = &ocelot_rule->frame.ipv4.sip.mask.addr[0];
>+               tmp = &ace->frame.ipv4.sip.mask.addr[0];
>                memcpy(tmp, &match.mask->src, 4);
>
>-               tmp = &ocelot_rule->frame.ipv4.dip.value.addr[0];
>+               tmp = &ace->frame.ipv4.dip.value.addr[0];
>                memcpy(tmp, &match.key->dst, 4);
>
>-               tmp = &ocelot_rule->frame.ipv4.dip.mask.addr[0];
>+               tmp = &ace->frame.ipv4.dip.mask.addr[0];
>                memcpy(tmp, &match.mask->dst, 4);
>        }
>
>@@ -139,60 +139,60 @@ static int ocelot_flower_parse(struct flow_cls_offload *f,
>                struct flow_match_ports match;
>
>                flow_rule_match_ports(rule, &match);
>-               ocelot_rule->frame.ipv4.sport.value = ntohs(match.key->src);
>-               ocelot_rule->frame.ipv4.sport.mask = ntohs(match.mask->src);
>-               ocelot_rule->frame.ipv4.dport.value = ntohs(match.key->dst);
>-               ocelot_rule->frame.ipv4.dport.mask = ntohs(match.mask->dst);
>+               ace->frame.ipv4.sport.value = ntohs(match.key->src);
>+               ace->frame.ipv4.sport.mask = ntohs(match.mask->src);
>+               ace->frame.ipv4.dport.value = ntohs(match.key->dst);
>+               ace->frame.ipv4.dport.mask = ntohs(match.mask->dst);
>        }
>
>        if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_VLAN)) {
>                struct flow_match_vlan match;
>
>                flow_rule_match_vlan(rule, &match);
>-               ocelot_rule->type = OCELOT_ACE_TYPE_ANY;
>-               ocelot_rule->vlan.vid.value = match.key->vlan_id;
>-               ocelot_rule->vlan.vid.mask = match.mask->vlan_id;
>-               ocelot_rule->vlan.pcp.value[0] = match.key->vlan_priority;
>-               ocelot_rule->vlan.pcp.mask[0] = match.mask->vlan_priority;
>+               ace->type = OCELOT_ACE_TYPE_ANY;
>+               ace->vlan.vid.value = match.key->vlan_id;
>+               ace->vlan.vid.mask = match.mask->vlan_id;
>+               ace->vlan.pcp.value[0] = match.key->vlan_priority;
>+               ace->vlan.pcp.mask[0] = match.mask->vlan_priority;
>        }
>
> finished_key_parsing:
>-       ocelot_rule->prio = f->common.prio;
>-       ocelot_rule->id = f->cookie;
>-       return ocelot_flower_parse_action(f, ocelot_rule);
>+       ace->prio = f->common.prio;
>+       ace->id = f->cookie;
>+       return ocelot_flower_parse_action(f, ace);
> }
>
> static
> struct ocelot_ace_rule *ocelot_ace_rule_create(struct ocelot *ocelot, int port,
>                                               struct flow_cls_offload *f)
> {
>-       struct ocelot_ace_rule *rule;
>+       struct ocelot_ace_rule *ace;
>
>-       rule = kzalloc(sizeof(*rule), GFP_KERNEL);
>-       if (!rule)
>+       ace = kzalloc(sizeof(*ace), GFP_KERNEL);
>+       if (!ace)
>                return NULL;
>
>-       rule->ingress_port_mask = BIT(port);
>-       return rule;
>+       ace->ingress_port_mask = BIT(port);
>+       return ace;
> }
>
> int ocelot_cls_flower_replace(struct ocelot *ocelot, int port,
>                              struct flow_cls_offload *f, bool ingress)
> {
>-       struct ocelot_ace_rule *rule;
>+       struct ocelot_ace_rule *ace;
>        int ret;
>
>-       rule = ocelot_ace_rule_create(ocelot, port, f);
>-       if (!rule)
>+       ace = ocelot_ace_rule_create(ocelot, port, f);
>+       if (!ace)
>                return -ENOMEM;
>
>-       ret = ocelot_flower_parse(f, rule);
>+       ret = ocelot_flower_parse(f, ace);
>        if (ret) {
>-               kfree(rule);
>+               kfree(ace);
>                return ret;
>        }
>
>-       ret = ocelot_ace_rule_offload_add(ocelot, rule);
>+       ret = ocelot_ace_rule_offload_add(ocelot, ace);
>        if (ret)
>                return ret;
>
>@@ -203,13 +203,13 @@ EXPORT_SYMBOL_GPL(ocelot_cls_flower_replace);
> int ocelot_cls_flower_destroy(struct ocelot *ocelot, int port,
>                              struct flow_cls_offload *f, bool ingress)
> {
>-       struct ocelot_ace_rule rule;
>+       struct ocelot_ace_rule ace;
>        int ret;
>
>-       rule.prio = f->common.prio;
>-       rule.id = f->cookie;
>+       ace.prio = f->common.prio;
>+       ace.id = f->cookie;
>
>-       ret = ocelot_ace_rule_offload_del(ocelot, &rule);
>+       ret = ocelot_ace_rule_offload_del(ocelot, &ace);
>        if (ret)
>                return ret;
>
>@@ -220,16 +220,16 @@ EXPORT_SYMBOL_GPL(ocelot_cls_flower_destroy);
> int ocelot_cls_flower_stats(struct ocelot *ocelot, int port,
>                            struct flow_cls_offload *f, bool ingress)
> {
>-       struct ocelot_ace_rule rule;
>+       struct ocelot_ace_rule ace;
>        int ret;
>
>-       rule.prio = f->common.prio;
>-       rule.id = f->cookie;
>-       ret = ocelot_ace_rule_stats_update(ocelot, &rule);
>+       ace.prio = f->common.prio;
>+       ace.id = f->cookie;
>+       ret = ocelot_ace_rule_stats_update(ocelot, &ace);
>        if (ret)
>                return ret;
>
>-       flow_stats_update(&f->stats, 0x0, rule.stats.pkts, 0x0);
>+       flow_stats_update(&f->stats, 0x0, ace.stats.pkts, 0x0);
>        return 0;
> }
> EXPORT_SYMBOL_GPL(ocelot_cls_flower_stats);
>--
>2.17.1
>

Reviewed-by: Allan W. Nielsen <allan.nielsen@microchip.com>

