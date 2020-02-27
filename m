Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0A61712E7
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 09:47:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728850AbgB0IrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 03:47:13 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:32247 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728849AbgB0IrL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 03:47:11 -0500
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
IronPort-SDR: VpVMGd3VIWbOmktkboXq6rrLh/fcdo4VG4zBaaHFoUeYrsJg5fMqDoPvGTc6XS0qWq5EE4nmT0
 afkyu/ae6O2Vhi+NSh93ITpFC3+Ut6KjAArjKdMvSBFckj12C2Er2SMgVmxz/n0qDaPYjEJbfn
 xsPPnzSYQy23GLP/gsxhtEYqYy+OKis7knTltRfSEw6E9SWZt7CbNx+FI7HWA95Pm2qxgG7Lyr
 hQqOfI9FmuBgSoJem0nqtCWFegvMm8FrXjtZS0Ay4+4YrMHsH9lSNmP9PMGOPkQ9YEnt7Weaoc
 saA=
X-IronPort-AV: E=Sophos;i="5.70,491,1574146800"; 
   d="scan'208";a="3773154"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Feb 2020 01:47:10 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 27 Feb 2020 01:47:09 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Thu, 27 Feb 2020 01:47:09 -0700
Date:   Thu, 27 Feb 2020 09:47:08 +0100
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
Subject: Re: [PATCH net-next 07/10] net: mscc: ocelot: parameterize the
 vcap_is2 properties
Message-ID: <20200227084708.dyms6znxsi5lyie4@lx-anielsen.microsemi.net>
References: <20200224130831.25347-1-olteanv@gmail.com>
 <20200224130831.25347-8-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <20200224130831.25347-8-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24.02.2020 15:08, Vladimir Oltean wrote:
>EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>
>From: Vladimir Oltean <vladimir.oltean@nxp.com>
>
>Remove the definitions for the VCAP IS2 table from ocelot_ace.c, since
>it is specific to VSC7514.
>
>The VSC9959 VCAP IS2 table supports more rules (1024 instead of 64) and
>has a different width for the action (89 bits instead of 99).
>
>Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>---
> drivers/net/ethernet/mscc/ocelot_ace.c   | 108 ++++++++---------------
> drivers/net/ethernet/mscc/ocelot_board.c |  25 ++++++
> include/soc/mscc/ocelot.h                |   1 +
> include/soc/mscc/ocelot_vcap.h           |  37 ++++++--
> 4 files changed, 94 insertions(+), 77 deletions(-)
>
>diff --git a/drivers/net/ethernet/mscc/ocelot_ace.c b/drivers/net/ethernet/mscc/ocelot_ace.c
>index c838e681963f..76809ffd5d99 100644
>--- a/drivers/net/ethernet/mscc/ocelot_ace.c
>+++ b/drivers/net/ethernet/mscc/ocelot_ace.c
>@@ -11,53 +11,7 @@
> #include "ocelot_s2.h"
>
> #define OCELOT_POLICER_DISCARD 0x17f
>-
>-struct vcap_props {
>-       const char *name; /* Symbolic name */
>-       u16 tg_width; /* Type-group width (in bits) */
>-       u16 sw_count; /* Sub word count */
>-       u16 entry_count; /* Entry count */
>-       u16 entry_words; /* Number of entry words */
>-       u16 entry_width; /* Entry width (in bits) */
>-       u16 action_count; /* Action count */
>-       u16 action_words; /* Number of action words */
>-       u16 action_width; /* Action width (in bits) */
>-       u16 action_type_width; /* Action type width (in bits) */
>-       struct {
>-               u16 width; /* Action type width (in bits) */
>-               u16 count; /* Action type sub word count */
>-       } action_table[2];
>-       u16 counter_words; /* Number of counter words */
>-       u16 counter_width; /* Counter width (in bits) */
>-};
>-
> #define ENTRY_WIDTH 32
>-#define BITS_TO_32BIT(x) (1 + (((x) - 1) / ENTRY_WIDTH))
>-
>-static const struct vcap_props vcap_is2 = {
>-       .name = "IS2",
>-       .tg_width = 2,
>-       .sw_count = 4,
>-       .entry_count = VCAP_IS2_CNT,
>-       .entry_words = BITS_TO_32BIT(VCAP_IS2_ENTRY_WIDTH),
>-       .entry_width = VCAP_IS2_ENTRY_WIDTH,
>-       .action_count = (VCAP_IS2_CNT + VCAP_PORT_CNT + 2),
>-       .action_words = BITS_TO_32BIT(VCAP_IS2_ACTION_WIDTH),
>-       .action_width = (VCAP_IS2_ACTION_WIDTH),
>-       .action_type_width = 1,
>-       .action_table = {
>-               {
>-                       .width = 49,
>-                       .count = 2
>-               },
>-               {
>-                       .width = 6,
>-                       .count = 4
>-               },
>-       },
>-       .counter_words = BITS_TO_32BIT(4 * ENTRY_WIDTH),
>-       .counter_width = ENTRY_WIDTH,
>-};
>
> enum vcap_sel {
>        VCAP_SEL_ENTRY = 0x1,
>@@ -101,11 +55,13 @@ static u32 vcap_s2_read_update_ctrl(struct ocelot *oc)
>
> static void vcap_cmd(struct ocelot *oc, u16 ix, int cmd, int sel)
> {
>+       const struct vcap_props *vcap_is2 = &oc->vcap[VCAP_IS2];
>+
>        u32 value = (S2_CORE_UPDATE_CTRL_UPDATE_CMD(cmd) |
>                     S2_CORE_UPDATE_CTRL_UPDATE_ADDR(ix) |
>                     S2_CORE_UPDATE_CTRL_UPDATE_SHOT);
>
>-       if ((sel & VCAP_SEL_ENTRY) && ix >= vcap_is2.entry_count)
>+       if ((sel & VCAP_SEL_ENTRY) && ix >= vcap_is2->entry_count)
>                return;
>
>        if (!(sel & VCAP_SEL_ENTRY))
>@@ -126,14 +82,18 @@ static void vcap_cmd(struct ocelot *oc, u16 ix, int cmd, int sel)
> /* Convert from 0-based row to VCAP entry row and run command */
> static void vcap_row_cmd(struct ocelot *oc, u32 row, int cmd, int sel)
> {
>-       vcap_cmd(oc, vcap_is2.entry_count - row - 1, cmd, sel);
>+       const struct vcap_props *vcap_is2 = &oc->vcap[VCAP_IS2];
>+
>+       vcap_cmd(oc, vcap_is2->entry_count - row - 1, cmd, sel);
> }
>
> static void vcap_entry2cache(struct ocelot *oc, struct vcap_data *data)
> {
>+       const struct vcap_props *vcap_is2 = &oc->vcap[VCAP_IS2];
>+       u32 entry_words = DIV_ROUND_UP(vcap_is2->entry_width, ENTRY_WIDTH);
>        u32 i;
>
>-       for (i = 0; i < vcap_is2.entry_words; i++) {
>+       for (i = 0; i < entry_words; i++) {
>                ocelot_write_rix(oc, data->entry[i], S2_CACHE_ENTRY_DAT, i);
>                ocelot_write_rix(oc, ~data->mask[i], S2_CACHE_MASK_DAT, i);
>        }
>@@ -142,9 +102,11 @@ static void vcap_entry2cache(struct ocelot *oc, struct vcap_data *data)
>
> static void vcap_cache2entry(struct ocelot *oc, struct vcap_data *data)
> {
>+       const struct vcap_props *vcap_is2 = &oc->vcap[VCAP_IS2];
>+       u32 entry_words = DIV_ROUND_UP(vcap_is2->entry_width, ENTRY_WIDTH);
>        u32 i;
>
>-       for (i = 0; i < vcap_is2.entry_words; i++) {
>+       for (i = 0; i < entry_words; i++) {
>                data->entry[i] = ocelot_read_rix(oc, S2_CACHE_ENTRY_DAT, i);
>                // Invert mask
>                data->mask[i] = ~ocelot_read_rix(oc, S2_CACHE_MASK_DAT, i);
>@@ -154,46 +116,51 @@ static void vcap_cache2entry(struct ocelot *oc, struct vcap_data *data)
>
> static void vcap_action2cache(struct ocelot *oc, struct vcap_data *data)
> {
>+       const struct vcap_props *vcap_is2 = &oc->vcap[VCAP_IS2];
>+       u32 action_words = DIV_ROUND_UP(vcap_is2->action_width, ENTRY_WIDTH);
>        u32 i, width, mask;
>
>        /* Encode action type */
>-       width = vcap_is2.action_type_width;
>+       width = vcap_is2->action_type_width;
>        if (width) {
>                mask = GENMASK(width, 0);
>                data->action[0] = ((data->action[0] & ~mask) | data->type);
>        }
>
>-       for (i = 0; i < vcap_is2.action_words; i++)
>+       for (i = 0; i < action_words; i++)
>                ocelot_write_rix(oc, data->action[i], S2_CACHE_ACTION_DAT, i);
>
>-       for (i = 0; i < vcap_is2.counter_words; i++)
>+       for (i = 0; i < vcap_is2->counter_words; i++)
>                ocelot_write_rix(oc, data->counter[i], S2_CACHE_CNT_DAT, i);
> }
>
> static void vcap_cache2action(struct ocelot *oc, struct vcap_data *data)
> {
>+       const struct vcap_props *vcap_is2 = &oc->vcap[VCAP_IS2];
>+       u32 action_words = DIV_ROUND_UP(vcap_is2->action_width, ENTRY_WIDTH);
>        u32 i, width;
>
>-       for (i = 0; i < vcap_is2.action_words; i++)
>+       for (i = 0; i < action_words; i++)
>                data->action[i] = ocelot_read_rix(oc, S2_CACHE_ACTION_DAT, i);
>
>-       for (i = 0; i < vcap_is2.counter_words; i++)
>+       for (i = 0; i < vcap_is2->counter_words; i++)
>                data->counter[i] = ocelot_read_rix(oc, S2_CACHE_CNT_DAT, i);
>
>        /* Extract action type */
>-       width = vcap_is2.action_type_width;
>+       width = vcap_is2->action_type_width;
>        data->type = (width ? (data->action[0] & GENMASK(width, 0)) : 0);
> }
>
> /* Calculate offsets for entry */
> static void is2_data_get(struct vcap_data *data, int ix)
> {
>-       u32 i, col, offset, count, cnt, base, width = vcap_is2.tg_width;
>+       const struct vcap_props *vcap_is2 = &data->ocelot->vcap[VCAP_IS2];
>+       u32 i, col, offset, count, cnt, base, width = vcap_is2->tg_width;
>
>        count = (data->tg_sw == VCAP_TG_HALF ? 2 : 4);
>        col = (ix % 2);
>-       cnt = (vcap_is2.sw_count / count);
>-       base = (vcap_is2.sw_count - col * cnt - cnt);
>+       cnt = (vcap_is2->sw_count / count);
>+       base = (vcap_is2->sw_count - col * cnt - cnt);
>        data->tg_value = 0;
>        data->tg_mask = 0;
>        for (i = 0; i < cnt; i++) {
>@@ -204,13 +171,13 @@ static void is2_data_get(struct vcap_data *data, int ix)
>
>        /* Calculate key/action/counter offsets */
>        col = (count - col - 1);
>-       data->key_offset = (base * vcap_is2.entry_width) / vcap_is2.sw_count;
>-       data->counter_offset = (cnt * col * vcap_is2.counter_width);
>+       data->key_offset = (base * vcap_is2->entry_width) / vcap_is2->sw_count;
>+       data->counter_offset = (cnt * col * vcap_is2->counter_width);
>        i = data->type;
>-       width = vcap_is2.action_table[i].width;
>-       cnt = vcap_is2.action_table[i].count;
>+       width = vcap_is2->action_table[i].width;
>+       cnt = vcap_is2->action_table[i].count;
>        data->action_offset =
>-               (((cnt * col * width) / count) + vcap_is2.action_type_width);
>+               (((cnt * col * width) / count) + vcap_is2->action_type_width);
> }
>
> static void vcap_data_set(u32 *data, u32 offset, u32 len, u32 value)
>@@ -357,6 +324,7 @@ static void is2_action_set(struct vcap_data *data,
> static void is2_entry_set(struct ocelot *ocelot, int ix,
>                          struct ocelot_ace_rule *ace)
> {
>+       const struct vcap_props *vcap_is2 = &ocelot->vcap[VCAP_IS2];
>        u32 val, msk, type, type_mask = 0xf, i, count;
>        struct ocelot_ace_vlan *tag = &ace->vlan;
>        struct ocelot_vcap_u64 payload;
>@@ -602,7 +570,7 @@ static void is2_entry_set(struct ocelot *ocelot, int ix,
>        default:
>                type = 0;
>                type_mask = 0;
>-               count = (vcap_is2.entry_width / 2);
>+               count = vcap_is2->entry_width / 2;
>                /* Iterate over the non-common part of the key and
>                 * clear entry data
>                 */
>@@ -615,7 +583,7 @@ static void is2_entry_set(struct ocelot *ocelot, int ix,
>
>        vcap_key_set(&data, VCAP_IS2_TYPE, type, type_mask);
>        is2_action_set(&data, ace->action);
>-       vcap_data_set(data.counter, data.counter_offset, vcap_is2.counter_width,
>+       vcap_data_set(data.counter, data.counter_offset, vcap_is2->counter_width,
>                      ace->stats.pkts);
>
>        /* Write row */
>@@ -627,6 +595,7 @@ static void is2_entry_set(struct ocelot *ocelot, int ix,
> static void is2_entry_get(struct ocelot *ocelot, struct ocelot_ace_rule *rule,
>                          int ix)
> {
>+       const struct vcap_props *vcap_is2 = &ocelot->vcap[VCAP_IS2];
>        struct vcap_data data;
>        int row = (ix / 2);
>        u32 cnt;
>@@ -638,7 +607,7 @@ static void is2_entry_get(struct ocelot *ocelot, struct ocelot_ace_rule *rule,
>        data.tg_sw = VCAP_TG_HALF;
>        is2_data_get(&data, ix);
>        cnt = vcap_data_get(data.counter, data.counter_offset,
>-                           vcap_is2.counter_width);
>+                           vcap_is2->counter_width);
>
>        rule->stats.pkts = cnt;
> }
>@@ -782,6 +751,7 @@ int ocelot_ace_rule_stats_update(struct ocelot *ocelot,
>
> int ocelot_ace_init(struct ocelot *ocelot)
> {
>+       const struct vcap_props *vcap_is2 = &ocelot->vcap[VCAP_IS2];
>        struct vcap_data data;
>
>        memset(&data, 0, sizeof(data));
>@@ -789,11 +759,11 @@ int ocelot_ace_init(struct ocelot *ocelot)
>        data.ocelot = ocelot;
>
>        vcap_entry2cache(ocelot, &data);
>-       ocelot_write(ocelot, vcap_is2.entry_count, S2_CORE_MV_CFG);
>+       ocelot_write(ocelot, vcap_is2->entry_count, S2_CORE_MV_CFG);
>        vcap_cmd(ocelot, 0, VCAP_CMD_INITIALIZE, VCAP_SEL_ENTRY);
>
>        vcap_action2cache(ocelot, &data);
>-       ocelot_write(ocelot, vcap_is2.action_count, S2_CORE_MV_CFG);
>+       ocelot_write(ocelot, vcap_is2->action_count, S2_CORE_MV_CFG);
>        vcap_cmd(ocelot, 0, VCAP_CMD_INITIALIZE,
>                 VCAP_SEL_ACTION | VCAP_SEL_COUNTER);
>
>diff --git a/drivers/net/ethernet/mscc/ocelot_board.c b/drivers/net/ethernet/mscc/ocelot_board.c
>index 5e21d0cc8335..1d6d2b48a92f 100644
>--- a/drivers/net/ethernet/mscc/ocelot_board.c
>+++ b/drivers/net/ethernet/mscc/ocelot_board.c
>@@ -337,6 +337,30 @@ struct vcap_field vsc7514_vcap_is2_actions[] = {
>        [VCAP_IS2_ACT_HIT_CNT]                  = { 49, 32},
> };
>
>+static const struct vcap_props vsc7514_vcap_props[] = {
>+       [VCAP_IS2] = {
>+               .tg_width = 2,
>+               .sw_count = 4,
>+               .entry_count = 64,
>+               .entry_width = 376,
>+               .action_count = 64 + 11 + 2,
>+               .action_width = 99,
Can you please use the defines here. We will need to rename them to
avoid confusion: VCAP_IS2_CNT -> VSC7514_IS2_CNT or something like that.

>+               .action_type_width = 1,
>+               .action_table = {
>+                       [IS2_ACTION_TYPE_NORMAL] = {
>+                               .width = 49,
>+                               .count = 2
>+                       },
>+                       [IS2_ACTION_TYPE_SMAC_SIP] = {
>+                               .width = 6,
>+                               .count = 4
>+                       },
>+               },
>+               .counter_words = 4,
>+               .counter_width = 32,
>+       },
>+};
>+
> static int mscc_ocelot_probe(struct platform_device *pdev)
> {
>        struct device_node *np = pdev->dev.of_node;
>@@ -439,6 +463,7 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
>
>        ocelot->vcap_is2_keys = vsc7514_vcap_is2_keys;
>        ocelot->vcap_is2_actions = vsc7514_vcap_is2_actions;
>+       ocelot->vcap = vsc7514_vcap_props;
>
>        ocelot_init(ocelot);
>        ocelot_set_cpu_port(ocelot, ocelot->num_phys_ports,
>diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
>index 31bcbc1ab2f9..0cbd61d1c30c 100644
>--- a/include/soc/mscc/ocelot.h
>+++ b/include/soc/mscc/ocelot.h
>@@ -463,6 +463,7 @@ struct ocelot {
>
>        struct vcap_field               *vcap_is2_keys;
>        struct vcap_field               *vcap_is2_actions;
>+       const struct vcap_props         *vcap;
>
>        /* Workqueue to check statistics for overflow with its lock */
>        struct mutex                    stats_lock;
>diff --git a/include/soc/mscc/ocelot_vcap.h b/include/soc/mscc/ocelot_vcap.h
>index 0783f0ffc813..5748373ab4d3 100644
>--- a/include/soc/mscc/ocelot_vcap.h
>+++ b/include/soc/mscc/ocelot_vcap.h
>@@ -11,6 +11,30 @@
>  * =================================================================
>  */
>
>+enum {
>+       /* VCAP_IS1, */
>+       VCAP_IS2,
>+       /* VCAP_ES0, */
>+};
>+
>+struct vcap_props {
>+       u16 tg_width; /* Type-group width (in bits) */
>+       u16 sw_count; /* Sub word count */
>+       u16 entry_count; /* Entry count */
>+       u16 entry_words; /* Number of entry words */
>+       u16 entry_width; /* Entry width (in bits) */
>+       u16 action_count; /* Action count */
>+       u16 action_words; /* Number of action words */
>+       u16 action_width; /* Action width (in bits) */
>+       u16 action_type_width; /* Action type width (in bits) */
>+       struct {
>+               u16 width; /* Action type width (in bits) */
>+               u16 count; /* Action type sub word count */
>+       } action_table[2];
>+       u16 counter_words; /* Number of counter words */
>+       u16 counter_width; /* Counter width (in bits) */
>+};
>+
> /* VCAP Type-Group values */
> #define VCAP_TG_NONE 0 /* Entry is invalid */
> #define VCAP_TG_FULL 1 /* Full entry */
>@@ -22,11 +46,6 @@
>  * =================================================================
>  */
>
>-#define VCAP_IS2_CNT 64
>-#define VCAP_IS2_ENTRY_WIDTH 376
>-#define VCAP_IS2_ACTION_WIDTH 99
>-#define VCAP_PORT_CNT 11
>-
> /* IS2 half key types */
> #define IS2_TYPE_ETYPE 0
> #define IS2_TYPE_LLC 1
>@@ -42,9 +61,11 @@
> /* IS2 half key type mask for matching any IP */
> #define IS2_TYPE_MASK_IP_ANY 0xe
>
>-/* IS2 action types */
>-#define IS2_ACTION_TYPE_NORMAL 0
>-#define IS2_ACTION_TYPE_SMAC_SIP 1
>+enum {
>+       IS2_ACTION_TYPE_NORMAL,
>+       IS2_ACTION_TYPE_SMAC_SIP,
>+       IS2_ACTION_TYPE_MAX,
>+};
>
> /* IS2 MASK_MODE values */
> #define IS2_ACT_MASK_MODE_NONE 0
>--
>2.17.1
>
/Allan
