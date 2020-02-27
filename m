Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E27CC1711DE
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 09:02:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728446AbgB0ICa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 03:02:30 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:26529 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726999AbgB0ICa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 03:02:30 -0500
Received-SPF: Pass (esa6.microchip.iphmx.com: domain of
  Allan.Nielsen@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="Allan.Nielsen@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa6.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa6.microchip.iphmx.com; spf=Pass smtp.mailfrom=Allan.Nielsen@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: BhUny36x9aRCK1C+z5EHiaLlSUy7NIIC9CQhoHBZhpFipIMzvHfzh7W5+r7wDyGVwsRzVyktGA
 HXqfXowoPtT61UI9Jg/Ia3QRBYOfKGyb4qAkcOuI3TradJG5a3ujAbuYbohHjR7CUNKLO2QDF4
 U6LuBApVYlr2F3EXKT21X+mEQo16JCnZ+aokvLESf14GqVf4FFXKFoGsUmxoDK6rpuFkBU2yPk
 MX4zKDqC+AZVfcOEOCrw3WsOVqMDY3lJxBuxaJ0uiY3qlXi3D5wcuaWvAiHliUO0aFKiLpsWD4
 zPw=
X-IronPort-AV: E=Sophos;i="5.70,491,1574146800"; 
   d="scan'208";a="3767426"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Feb 2020 01:02:28 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 27 Feb 2020 01:02:28 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Thu, 27 Feb 2020 01:02:40 -0700
Date:   Thu, 27 Feb 2020 09:02:27 +0100
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
Subject: Re: [PATCH net-next 01/10] net: mscc: ocelot: make ocelot_ace_rule
 support multiple ports
Message-ID: <20200227080227.c4jnvkf7mycb3nn4@lx-anielsen.microsemi.net>
References: <20200224130831.25347-1-olteanv@gmail.com>
 <20200224130831.25347-2-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <20200224130831.25347-2-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24.02.2020 15:08, Vladimir Oltean wrote:
>EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>
>From: Yangbo Lu <yangbo.lu@nxp.com>
>
>The ocelot_ace_rule is port specific now. Make it flexible to
>be able to support multiple ports too.
>
>Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
>Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>---
> drivers/net/ethernet/mscc/ocelot_ace.c    | 14 +++++++-------
> drivers/net/ethernet/mscc/ocelot_ace.h    |  4 ++--
> drivers/net/ethernet/mscc/ocelot_flower.c |  8 ++++----
> 3 files changed, 13 insertions(+), 13 deletions(-)
>
>diff --git a/drivers/net/ethernet/mscc/ocelot_ace.c b/drivers/net/ethernet/mscc/ocelot_ace.c
>index 86fc6e6b46dd..18670645d47f 100644
>--- a/drivers/net/ethernet/mscc/ocelot_ace.c
>+++ b/drivers/net/ethernet/mscc/ocelot_ace.c
>@@ -352,7 +352,7 @@ static void is2_entry_set(struct ocelot *ocelot, int ix,
>        data.type = IS2_ACTION_TYPE_NORMAL;
>
>        VCAP_KEY_ANY_SET(PAG);
>-       VCAP_KEY_SET(IGR_PORT_MASK, 0, ~BIT(ace->chip_port));
>+       VCAP_KEY_SET(IGR_PORT_MASK, 0, ~ace->ingress_port_mask);
>        VCAP_KEY_BIT_SET(FIRST, OCELOT_VCAP_BIT_1);
>        VCAP_KEY_BIT_SET(HOST_MATCH, OCELOT_VCAP_BIT_ANY);
>        VCAP_KEY_BIT_SET(L2_MC, ace->dmac_mc);
>@@ -576,7 +576,7 @@ static void is2_entry_set(struct ocelot *ocelot, int ix,
>
> static void is2_entry_get(struct ocelot_ace_rule *rule, int ix)
> {
>-       struct ocelot *op = rule->port->ocelot;
>+       struct ocelot *op = rule->ocelot;
>        struct vcap_data data;
>        int row = (ix / 2);
>        u32 cnt;
>@@ -655,11 +655,11 @@ int ocelot_ace_rule_offload_add(struct ocelot_ace_rule *rule)
>        /* Move down the rules to make place for the new rule */
>        for (i = acl_block->count - 1; i > index; i--) {
>                ace = ocelot_ace_rule_get_rule_index(acl_block, i);
>-               is2_entry_set(rule->port->ocelot, i, ace);
>+               is2_entry_set(rule->ocelot, i, ace);
>        }
>
>        /* Now insert the new rule */
>-       is2_entry_set(rule->port->ocelot, index, rule);
>+       is2_entry_set(rule->ocelot, index, rule);
>        return 0;
> }
>
>@@ -697,11 +697,11 @@ int ocelot_ace_rule_offload_del(struct ocelot_ace_rule *rule)
>        /* Move up all the blocks over the deleted rule */
>        for (i = index; i < acl_block->count; i++) {
>                ace = ocelot_ace_rule_get_rule_index(acl_block, i);
>-               is2_entry_set(rule->port->ocelot, i, ace);
>+               is2_entry_set(rule->ocelot, i, ace);
>        }
>
>        /* Now delete the last rule, because it is duplicated */
>-       is2_entry_set(rule->port->ocelot, acl_block->count, &del_ace);
>+       is2_entry_set(rule->ocelot, acl_block->count, &del_ace);
>
>        return 0;
> }
>@@ -717,7 +717,7 @@ int ocelot_ace_rule_stats_update(struct ocelot_ace_rule *rule)
>        /* After we get the result we need to clear the counters */
>        tmp = ocelot_ace_rule_get_rule_index(acl_block, index);
>        tmp->stats.pkts = 0;
>-       is2_entry_set(rule->port->ocelot, index, tmp);
>+       is2_entry_set(rule->ocelot, index, tmp);
>
>        return 0;
> }
>diff --git a/drivers/net/ethernet/mscc/ocelot_ace.h b/drivers/net/ethernet/mscc/ocelot_ace.h
>index c08e3e8482e7..2927ac83741b 100644
>--- a/drivers/net/ethernet/mscc/ocelot_ace.h
>+++ b/drivers/net/ethernet/mscc/ocelot_ace.h
>@@ -186,14 +186,14 @@ struct ocelot_ace_stats {
>
> struct ocelot_ace_rule {
>        struct list_head list;
>-       struct ocelot_port *port;
>+       struct ocelot *ocelot;
>
>        u16 prio;
>        u32 id;
>
>        enum ocelot_ace_action action;
>        struct ocelot_ace_stats stats;
>-       int chip_port;
>+       u16 ingress_port_mask;
>
>        enum ocelot_vcap_bit dmac_mc;
>        enum ocelot_vcap_bit dmac_bc;
>diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
>index 3d65b99b9734..ffd2bb50cfc3 100644
>--- a/drivers/net/ethernet/mscc/ocelot_flower.c
>+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
>@@ -177,8 +177,8 @@ struct ocelot_ace_rule *ocelot_ace_rule_create(struct flow_cls_offload *f,
>        if (!rule)
>                return NULL;
>
>-       rule->port = &block->priv->port;
>-       rule->chip_port = block->priv->chip_port;
>+       rule->ocelot = block->priv->port.ocelot;
>+       rule->ingress_port_mask = BIT(block->priv->chip_port);
>        return rule;
> }
>
>@@ -213,7 +213,7 @@ static int ocelot_flower_destroy(struct flow_cls_offload *f,
>        int ret;
>
>        rule.prio = f->common.prio;
>-       rule.port = &port_block->priv->port;
>+       rule.ocelot = port_block->priv->port.ocelot;
>        rule.id = f->cookie;
>
>        ret = ocelot_ace_rule_offload_del(&rule);
>@@ -231,7 +231,7 @@ static int ocelot_flower_stats_update(struct flow_cls_offload *f,
>        int ret;
>
>        rule.prio = f->common.prio;
>-       rule.port = &port_block->priv->port;
>+       rule.ocelot = port_block->priv->port.ocelot;
>        rule.id = f->cookie;
>        ret = ocelot_ace_rule_stats_update(&rule);
>        if (ret)
>--
>2.17.1
>

Reviewed-by: Allan W. Nielsen <allan.nielsen@microchip.com>
