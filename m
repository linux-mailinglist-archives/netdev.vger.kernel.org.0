Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 929111EB77B
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 10:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbgFBIgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 04:36:16 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:6250 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbgFBIgQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 04:36:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1591086976; x=1622622976;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=uG+7PKwIeu87SHqQoaFEZnNX2t0lm3xjRGLPbL/M+lU=;
  b=o7Ir1fzs1c783DkHM7qWs3CZwyGkJX+BWa8MuqOjNzteLvHwJ8uYVr33
   cee4LcrIpVX4QLPpJy22xwwyZKV2MT2nEU/QnR6u7qriE8PKaEE/m0VmF
   Rp2Z5BUi8D+/TueH943oTixabxY4KZXFYyn8eYbFxS41kUg+jRkv1GnMC
   By24BtmimDjkHzM1DPqx57W/Y2H5E0UBLay3EfNLhOlX6C4iQIRYtM2h+
   y+EKOjfser3DS+u0dy0gZ4B6XxBVj1ADIvAEzo2uFSGIwtW6wEnpSqnls
   zzcX3hdOra+9d3aaD/7GAXtbZLw6qXlYDj4uFh8H4nBMuaF7B22Q69rHc
   w==;
IronPort-SDR: HT2Z27STDLnKPYPRhP0/tEg2bNOHAwXaaaXhayf5AEasLuCHpnZgjtJEsQH5WFcoPdZoQIcg2P
 CCOtr1CsFYfGOT4RlU3aDdY0RCpPjLz/vBmmKQzsq9I84+mdiqWuX3bdpsSZenbfsn3QVFuTOG
 1V9Q2JRQJc5LyNexU1cpqVG5FZwJ56tEUlpx6KJLD9BnOIpwTnm4N5PzundwzoCEG1oUWAAbjz
 IEkA0xe8/TGhCKF+AXD+F+2xn1KKyd+Hau0IutYjn3uklYldDEq0UGbYDVDFmRms5IuwRHpaAM
 H0I=
X-IronPort-AV: E=Sophos;i="5.73,463,1583218800"; 
   d="scan'208";a="77879278"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Jun 2020 01:36:16 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 2 Jun 2020 01:36:19 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Tue, 2 Jun 2020 01:36:14 -0700
Date:   Tue, 2 Jun 2020 10:36:13 +0200
From:   "Allan W. Nielsen" <allan.nielsen@microchip.com>
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
CC:     <po.liu@nxp.com>, <claudiu.manoil@nxp.com>,
        <alexandru.marginean@nxp.com>, <vladimir.oltean@nxp.com>,
        <leoyang.li@nxp.com>, <mingkai.hu@nxp.com>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>, <vivien.didelot@gmail.com>,
        <davem@davemloft.net>, <jiri@resnulli.us>, <idosch@idosch.org>,
        <kuba@kernel.org>, <vinicius.gomes@intel.com>,
        <nikolay@cumulusnetworks.com>, <roopa@cumulusnetworks.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <horatiu.vultur@microchip.com>, <alexandre.belloni@bootlin.com>,
        <joergen.andreasen@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <linux-devel@linux.nxdi.nxp.com>
Subject: Re: [PATCH v2 net-next 03/10] net: mscc: ocelot: allocated rules to
 different hardware VCAP TCAMs by chain index
Message-ID: <20200602083613.ddzjh54zxtbklytw@ws.localdomain>
References: <20200602051828.5734-1-xiaoliang.yang_1@nxp.com>
 <20200602051828.5734-4-xiaoliang.yang_1@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <20200602051828.5734-4-xiaoliang.yang_1@nxp.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Xiaoliang,

Happy to see that you are moving in the directions of multi chain - this
seems ilke a much better fit to me.


On 02.06.2020 13:18, Xiaoliang Yang wrote:
>There are three hardware TCAMs for ocelot chips: IS1, IS2 and ES0. Each
>one supports different actions. The hardware flow order is: IS1->IS2->ES0.
>
>This patch add three blocks to store rules according to chain index.
>chain 0 is offloaded to IS1, chain 1 is offloaded to IS2, and egress chain
>0 is offloaded to ES0.

Using "static" allocation to to say chain-X goes to TCAM Y, also seems
like the right approach to me. Given the capabilities of the HW, this
will most likely be the easiest scheme to implement and to explain to
the end-user.

But I think we should make some adjustments to this mapping schema.

Here are some important "things" I would like to consider when defining
this schema:

- As you explain, we have 3 TCAMs (IS1, IS2 and ES0), but we have 3
   parallel lookups in IS1 and 2 parallel lookups in IS2 - and also these
   TCAMs has a wide verity of keys.

- We can utilize these multiple parallel lookups such that it seems like
   they are done in serial (that is if they do not touch the same
   actions), but as they are done in parallel they can not influence each
   other.

- We can let IS1 influence the IS2 lookup (like the GOTO actions was
   intended to be used).

- The chip also has other QoS classification facilities which sits
   before the TCAM (take a look at 3.7.3 QoS, DP, and DSCP Classification
   in vsc7514 datasheet). It we at some point in time want to enable
   this, then I think we need to do that in the same tc-flower framework.

Here is my initial suggestion for an alternative chain-schema:

Chain 0:           The default chain - today this is in IS2. If we proceed
                    with this as is - then this will change.
Chain 1-9999:      These are offloaded by "basic" classification.
Chain 10000-19999: These are offloaded in IS1
                    Chain 10000: Lookup-0 in IS1, and here we could limit the
                                 action to do QoS related stuff (priority
                                 update)
                    Chain 11000: Lookup-1 in IS1, here we could do VLAN
                                 stuff
                    Chain 12000: Lookup-2 in IS1, here we could apply the
                                 "PAG" which is essentially a GOTO.

Chain 20000-29999: These are offloaded in IS2
                    Chain 20000-20255: Lookup-0 in IS2, where CHAIN-ID -
                                       20000 is the PAG value.
                    Chain 21000-21000: Lookup-1 in IS2.

All these chains should be optional - users should only need to
configure the chains they need. To make this work, we need to configure
both the desired actions (could be priority update) and the goto action.
Remember in HW, all packets goes through this process, while in SW they
only follow the "goto" path.

An example could be (I have not tested this yet - sorry):

tc qdisc add dev eth0 ingress

# Activate lookup 11000. We can not do any other rules in chain 0, also
# this implicitly means that we do not want any chains <11000.
tc filter add dev eth0 parent ffff: chain 0 
    action
    matchall goto 11000

tc filter add dev eth0 parent ffff: chain 11000 \
    flower src_mac 00:01:00:00:00:00/00:ff:00:00:00:00 \
    action \
    vlan modify id 1234 \
    pipe \
    goto 20001

tc filter add dev eth0 parent ffff: chain 20001 ...

Maybe it would be an idea to create some use-cases, implement them in a
test which can pass with today's SW, and then once we have a common
understanding of what we want, we can implement it?

/Allan

>Using action goto chain to express flow order as follows:
>        tc filter add dev swp0 chain 0 parent ffff: flower skip_sw \
>        action goto chain 1
>
>Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
>---
> drivers/net/ethernet/mscc/ocelot_ace.c    | 51 +++++++++++++++--------
> drivers/net/ethernet/mscc/ocelot_ace.h    |  7 ++--
> drivers/net/ethernet/mscc/ocelot_flower.c | 46 +++++++++++++++++---
> include/soc/mscc/ocelot.h                 |  2 +-
> include/soc/mscc/ocelot_vcap.h            |  4 +-
> 5 files changed, 81 insertions(+), 29 deletions(-)
>
>diff --git a/drivers/net/ethernet/mscc/ocelot_ace.c b/drivers/net/ethernet/mscc/ocelot_ace.c
>index 748c618db7d8..b76593b40097 100644
>--- a/drivers/net/ethernet/mscc/ocelot_ace.c
>+++ b/drivers/net/ethernet/mscc/ocelot_ace.c
>@@ -341,6 +341,8 @@ static void is2_action_set(struct ocelot *ocelot, struct vcap_data *data,
>                vcap_action_set(vcap, data, VCAP_IS2_ACT_CPU_QU_NUM, 0);
>                vcap_action_set(vcap, data, VCAP_IS2_ACT_CPU_COPY_ENA, 0);
>                break;
>+       default:
>+               break;
>        }
> }
>
>@@ -644,9 +646,9 @@ static void is2_entry_set(struct ocelot *ocelot, int ix,
> }
>
> static void vcap_entry_get(struct ocelot *ocelot, struct ocelot_ace_rule *rule,
>-                          int ix)
>+                          int ix, int block_id)
> {
>-       const struct vcap_props *vcap = &ocelot->vcap[VCAP_IS2];
>+       const struct vcap_props *vcap = &ocelot->vcap[block_id];
>        struct vcap_data data;
>        int row, count;
>        u32 cnt;
>@@ -663,6 +665,19 @@ static void vcap_entry_get(struct ocelot *ocelot, struct ocelot_ace_rule *rule,
>        rule->stats.pkts = cnt;
> }
>
>+static void vcap_entry_set(struct ocelot *ocelot, int ix,
>+                          struct ocelot_ace_rule *ace,
>+                          int block_id)
>+{
>+       switch (block_id) {
>+       case VCAP_IS2:
>+               is2_entry_set(ocelot, ix, ace);
>+               break;
>+       default:
>+               break;
>+       }
>+}
>+
> static void ocelot_ace_rule_add(struct ocelot *ocelot,
>                                struct ocelot_acl_block *block,
>                                struct ocelot_ace_rule *rule)
>@@ -790,7 +805,7 @@ static bool ocelot_ace_is_problematic_non_mac_etype(struct ocelot_ace_rule *ace)
> static bool ocelot_exclusive_mac_etype_ace_rules(struct ocelot *ocelot,
>                                                 struct ocelot_ace_rule *ace)
> {
>-       struct ocelot_acl_block *block = &ocelot->acl_block;
>+       struct ocelot_acl_block *block = &ocelot->acl_block[VCAP_IS2];
>        struct ocelot_ace_rule *tmp;
>        unsigned long port;
>        int i;
>@@ -824,15 +839,16 @@ static bool ocelot_exclusive_mac_etype_ace_rules(struct ocelot *ocelot,
>        return true;
> }
>
>-int ocelot_ace_rule_offload_add(struct ocelot *ocelot,
>+int ocelot_ace_rule_offload_add(struct ocelot *ocelot, int block_id,
>                                struct ocelot_ace_rule *rule,
>                                struct netlink_ext_ack *extack)
> {
>-       struct ocelot_acl_block *block = &ocelot->acl_block;
>+       struct ocelot_acl_block *block = &ocelot->acl_block[block_id];
>        struct ocelot_ace_rule *ace;
>        int i, index;
>
>-       if (!ocelot_exclusive_mac_etype_ace_rules(ocelot, rule)) {
>+       if (block_id == VCAP_IS2 &&
>+           !ocelot_exclusive_mac_etype_ace_rules(ocelot, rule)) {
>                NL_SET_ERR_MSG_MOD(extack,
>                                   "Cannot mix MAC_ETYPE with non-MAC_ETYPE rules");
>                return -EBUSY;
>@@ -847,11 +863,11 @@ int ocelot_ace_rule_offload_add(struct ocelot *ocelot,
>        /* Move down the rules to make place for the new rule */
>        for (i = block->count - 1; i > index; i--) {
>                ace = ocelot_ace_rule_get_rule_index(block, i);
>-               is2_entry_set(ocelot, i, ace);
>+               vcap_entry_set(ocelot, i, ace, block_id);
>        }
>
>        /* Now insert the new rule */
>-       is2_entry_set(ocelot, index, rule);
>+       vcap_entry_set(ocelot, index, rule, block_id);
>        return 0;
> }
>
>@@ -902,10 +918,10 @@ static void ocelot_ace_rule_del(struct ocelot *ocelot,
>        block->count--;
> }
>
>-int ocelot_ace_rule_offload_del(struct ocelot *ocelot,
>+int ocelot_ace_rule_offload_del(struct ocelot *ocelot, int block_id,
>                                struct ocelot_ace_rule *rule)
> {
>-       struct ocelot_acl_block *block = &ocelot->acl_block;
>+       struct ocelot_acl_block *block = &ocelot->acl_block[block_id];
>        struct ocelot_ace_rule del_ace;
>        struct ocelot_ace_rule *ace;
>        int i, index;
>@@ -921,29 +937,29 @@ int ocelot_ace_rule_offload_del(struct ocelot *ocelot,
>        /* Move up all the blocks over the deleted rule */
>        for (i = index; i < block->count; i++) {
>                ace = ocelot_ace_rule_get_rule_index(block, i);
>-               is2_entry_set(ocelot, i, ace);
>+               vcap_entry_set(ocelot, i, ace, block_id);
>        }
>
>        /* Now delete the last rule, because it is duplicated */
>-       is2_entry_set(ocelot, block->count, &del_ace);
>+       vcap_entry_set(ocelot, block->count, &del_ace, block_id);
>
>        return 0;
> }
>
>-int ocelot_ace_rule_stats_update(struct ocelot *ocelot,
>+int ocelot_ace_rule_stats_update(struct ocelot *ocelot, int block_id,
>                                 struct ocelot_ace_rule *rule)
> {
>-       struct ocelot_acl_block *block = &ocelot->acl_block;
>+       struct ocelot_acl_block *block = &ocelot->acl_block[block_id];
>        struct ocelot_ace_rule *tmp;
>        int index;
>
>        index = ocelot_ace_rule_get_index_id(block, rule);
>-       vcap_entry_get(ocelot, rule, index);
>+       vcap_entry_get(ocelot, rule, index, block_id);
>
>        /* After we get the result we need to clear the counters */
>        tmp = ocelot_ace_rule_get_rule_index(block, index);
>        tmp->stats.pkts = 0;
>-       is2_entry_set(ocelot, index, tmp);
>+       vcap_entry_set(ocelot, index, tmp, block_id);
>
>        return 0;
> }
>@@ -968,7 +984,7 @@ static void vcap_init(struct ocelot *ocelot, const struct vcap_props *vcap)
>
> int ocelot_ace_init(struct ocelot *ocelot)
> {
>-       struct ocelot_acl_block *block = &ocelot->acl_block;
>+       struct ocelot_acl_block *block;
>
>        vcap_init(ocelot, &ocelot->vcap[VCAP_IS2]);
>
>@@ -987,6 +1003,7 @@ int ocelot_ace_init(struct ocelot *ocelot)
>        ocelot_write_gix(ocelot, 0x3fffff, ANA_POL_CIR_STATE,
>                         OCELOT_POLICER_DISCARD);
>
>+       block = &ocelot->acl_block[VCAP_IS2];
>        block->pol_lpr = OCELOT_POLICER_DISCARD - 1;
>        INIT_LIST_HEAD(&block->rules);
>
>diff --git a/drivers/net/ethernet/mscc/ocelot_ace.h b/drivers/net/ethernet/mscc/ocelot_ace.h
>index 099e177f2617..a9fd99401a65 100644
>--- a/drivers/net/ethernet/mscc/ocelot_ace.h
>+++ b/drivers/net/ethernet/mscc/ocelot_ace.h
>@@ -175,6 +175,7 @@ struct ocelot_ace_frame_ipv6 {
> };
>
> enum ocelot_ace_action {
>+       OCELOT_ACL_ACTION_NULL,
>        OCELOT_ACL_ACTION_DROP,
>        OCELOT_ACL_ACTION_TRAP,
>        OCELOT_ACL_ACTION_POLICE,
>@@ -214,12 +215,12 @@ struct ocelot_ace_rule {
>        u32 pol_ix;
> };
>
>-int ocelot_ace_rule_offload_add(struct ocelot *ocelot,
>+int ocelot_ace_rule_offload_add(struct ocelot *ocelot, int block_id,
>                                struct ocelot_ace_rule *rule,
>                                struct netlink_ext_ack *extack);
>-int ocelot_ace_rule_offload_del(struct ocelot *ocelot,
>+int ocelot_ace_rule_offload_del(struct ocelot *ocelot, int block_id,
>                                struct ocelot_ace_rule *rule);
>-int ocelot_ace_rule_stats_update(struct ocelot *ocelot,
>+int ocelot_ace_rule_stats_update(struct ocelot *ocelot, int block_id,
>                                 struct ocelot_ace_rule *rule);
>
> int ocelot_ace_init(struct ocelot *ocelot);
>diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
>index 891925f73cbc..a1f7b6b28170 100644
>--- a/drivers/net/ethernet/mscc/ocelot_flower.c
>+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
>@@ -9,13 +9,26 @@
>
> #include "ocelot_ace.h"
>
>+static int ocelot_block_id_get(int chain, bool ingress)
>+{
>+       /* Select TCAM blocks by using chain index. Rules in chain 0 are
>+        * implemented on IS1, chain 1 are implemented on IS2, and egress
>+        * chain corresponds to ES0 block.
>+        */
>+       if (ingress)
>+               return chain ? VCAP_IS2 : VCAP_IS1;
>+       else
>+               return VCAP_ES0;
>+}
>+
> static int ocelot_flower_parse_action(struct flow_cls_offload *f,
>                                      struct ocelot_ace_rule *ace)
> {
>+       struct netlink_ext_ack *extack = f->common.extack;
>        const struct flow_action_entry *a;
>+       int i, allowed_chain = 0;
>        s64 burst;
>        u64 rate;
>-       int i;
>
>        if (!flow_offload_has_one_action(&f->rule->action))
>                return -EOPNOTSUPP;
>@@ -28,9 +41,11 @@ static int ocelot_flower_parse_action(struct flow_cls_offload *f,
>                switch (a->id) {
>                case FLOW_ACTION_DROP:
>                        ace->action = OCELOT_ACL_ACTION_DROP;
>+                       allowed_chain = 1;
>                        break;
>                case FLOW_ACTION_TRAP:
>                        ace->action = OCELOT_ACL_ACTION_TRAP;
>+                       allowed_chain = 1;
>                        break;
>                case FLOW_ACTION_POLICE:
>                        ace->action = OCELOT_ACL_ACTION_POLICE;
>@@ -38,10 +53,23 @@ static int ocelot_flower_parse_action(struct flow_cls_offload *f,
>                        ace->pol.rate = div_u64(rate, 1000) * 8;
>                        burst = rate * PSCHED_NS2TICKS(a->police.burst);
>                        ace->pol.burst = div_u64(burst, PSCHED_TICKS_PER_SEC);
>+                       allowed_chain = 1;
>+                       break;
>+               case FLOW_ACTION_GOTO:
>+                       if (a->chain_index != f->common.chain_index + 1) {
>+                               NL_SET_ERR_MSG_MOD(extack, "HW only support goto next chain\n");
>+                               return -EOPNOTSUPP;
>+                       }
>+                       ace->action = OCELOT_ACL_ACTION_NULL;
>+                       allowed_chain = f->common.chain_index;
>                        break;
>                default:
>                        return -EOPNOTSUPP;
>                }
>+               if (f->common.chain_index != allowed_chain) {
>+                       NL_SET_ERR_MSG_MOD(extack, "Action is not supported on this chain\n");
>+                       return -EOPNOTSUPP;
>+               }
>        }
>
>        return 0;
>@@ -205,7 +233,7 @@ int ocelot_cls_flower_replace(struct ocelot *ocelot, int port,
>                              struct flow_cls_offload *f, bool ingress)
> {
>        struct ocelot_ace_rule *ace;
>-       int ret;
>+       int ret, block_id;
>
>        ace = ocelot_ace_rule_create(ocelot, port, f);
>        if (!ace)
>@@ -216,8 +244,10 @@ int ocelot_cls_flower_replace(struct ocelot *ocelot, int port,
>                kfree(ace);
>                return ret;
>        }
>+       block_id = ocelot_block_id_get(f->common.chain_index, ingress);
>
>-       return ocelot_ace_rule_offload_add(ocelot, ace, f->common.extack);
>+       return ocelot_ace_rule_offload_add(ocelot, block_id, ace,
>+                                          f->common.extack);
> }
> EXPORT_SYMBOL_GPL(ocelot_cls_flower_replace);
>
>@@ -225,11 +255,13 @@ int ocelot_cls_flower_destroy(struct ocelot *ocelot, int port,
>                              struct flow_cls_offload *f, bool ingress)
> {
>        struct ocelot_ace_rule ace;
>+       int block_id;
>
>        ace.prio = f->common.prio;
>        ace.id = f->cookie;
>+       block_id = ocelot_block_id_get(f->common.chain_index, ingress);
>
>-       return ocelot_ace_rule_offload_del(ocelot, &ace);
>+       return ocelot_ace_rule_offload_del(ocelot, block_id, &ace);
> }
> EXPORT_SYMBOL_GPL(ocelot_cls_flower_destroy);
>
>@@ -237,11 +269,13 @@ int ocelot_cls_flower_stats(struct ocelot *ocelot, int port,
>                            struct flow_cls_offload *f, bool ingress)
> {
>        struct ocelot_ace_rule ace;
>-       int ret;
>+       int ret, block_id;
>
>        ace.prio = f->common.prio;
>        ace.id = f->cookie;
>-       ret = ocelot_ace_rule_stats_update(ocelot, &ace);
>+       block_id = ocelot_block_id_get(f->common.chain_index, ingress);
>+
>+       ret = ocelot_ace_rule_stats_update(ocelot, block_id, &ace);
>        if (ret)
>                return ret;
>
>diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
>index 91357b1c8f31..4b2320bdc036 100644
>--- a/include/soc/mscc/ocelot.h
>+++ b/include/soc/mscc/ocelot.h
>@@ -540,7 +540,7 @@ struct ocelot {
>
>        struct list_head                multicast;
>
>-       struct ocelot_acl_block         acl_block;
>+       struct ocelot_acl_block         acl_block[3];
>
>        const struct vcap_props         *vcap;
>
>diff --git a/include/soc/mscc/ocelot_vcap.h b/include/soc/mscc/ocelot_vcap.h
>index 26d9384b3657..495847a40490 100644
>--- a/include/soc/mscc/ocelot_vcap.h
>+++ b/include/soc/mscc/ocelot_vcap.h
>@@ -14,9 +14,9 @@
>  */
>
> enum {
>-       /* VCAP_IS1, */
>+       VCAP_IS1,
>        VCAP_IS2,
>-       /* VCAP_ES0, */
>+       VCAP_ES0,
> };
>
> struct vcap_props {
>--
>2.17.1
>
/Allan
