Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9746417E5DB
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 18:36:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbgCIRgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 13:36:50 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:42682 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727257AbgCIRgt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 13:36:49 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us5.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 281564C005C;
        Mon,  9 Mar 2020 17:36:47 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 9 Mar 2020
 17:36:32 +0000
Subject: Re: [PATCH net-next ct-offload v2 02/13] net/sched: act_ct:
 Instantiate flow table entry actions
To:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        "David Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
References: <1583676662-15180-1-git-send-email-paulb@mellanox.com>
 <1583676662-15180-3-git-send-email-paulb@mellanox.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <5dde483c-be42-644c-30b5-add308b4f69d@solarflare.com>
Date:   Mon, 9 Mar 2020 17:36:30 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <1583676662-15180-3-git-send-email-paulb@mellanox.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25278.003
X-TM-AS-Result: No-14.701400-8.000000-10
X-TMASE-MatchedRID: ZFzIhWOuIzvmLzc6AOD8DfHkpkyUphL9B4bXdj887A8Lt1T6w2Ze0t5Q
        ZVAH5Zt2YWTnOnMH547fbYqgOvx6nZ6CKaYYGfNGR0BY8wG7yRA1TzP60UkdHQpCjqVELlwVAUq
        wO9pSIT2auV0m1Pa00e4UL2DTQdBzCQZYBny/onOHZXNSWjgdUweCHewokHM/27KSseGDg92Ind
        s1RGmDCxy68x3kzf05foaZKm4m1WlRq+qIQYdPyehsg0dmQfnGUPO4Up/w0pNGMe+tDjQ3FpGrd
        WQJt2T1WOtcAGFuzQRuL3ESIrARl1U97fGGL+q3PwKTD1v8YV5MkOX0Uoduuc9essRvi1FZ1DQW
        12L1ci4A9xn3PN8twldXfmY1NScsEs+RG1oouyUMOWxRtywg+ts4MOUU/wa2e1OjQ/WyxP7JpL/
        lo1j1HrHCuW/KSMCa/9nQZVP1z1QVlVZBrluia/KUR83BvqItoiKTb964zHVHZg0gWH5yUXd7bc
        i/LVuNp+Ew/5yfsGghbV0QbOOjh4YU3uv70YCLuoibJpHRrFngt7TT//Roak2v0JV0JaVRo8WMk
        QWv6iWhMIDkR/KfwI2j49Ftap9EOwBXM346/+yT5lm5kqPo4N3dw45mFb3g0vA6SHFyW0y2sbQo
        9yWnz0ZKy8Qhz1VF
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--14.701400-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25278.003
X-MDID: 1583775408-reE0RjNAsDP9
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/03/2020 14:10, Paul Blakey wrote:
> NF flow table API associate 5-tuple rule with an action list by calling
> the flow table type action() CB to fill the rule's actions.
>
> In action CB of act_ct, populate the ct offload entry actions with a new
> ct_metadata action. Initialize the ct_metadata with the ct mark, label and
> zone information. If ct nat was performed, then also append the relevant
> packet mangle actions (e.g. ipv4/ipv6/tcp/udp header rewrites).
>
> Drivers that offload the ft entries may match on the 5-tuple and perform
> the action list.
>
> Signed-off-by: Paul Blakey <paulb@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
> ---
> Changelog:
>    v1->v2:
>      Remove zone from metadata
>      Add add mangle helper func (removes the unneccasry () and correct the mask there)
>      Remove "abuse" of ? operator and use switch case
>      Check protocol and ports in relevant function and return err
>      On error restore action entries (on the topic, validaiting num of action isn't available)
>      Add comment expalining nat
>      Remove Inlinie from tcf_ct_flow_table_flow_action_get_next
>      Refactor tcf_ct_flow_table_add_action_nat_ipv6 with helper
>      On nats, allow both src and dst mangles
>
>  include/net/flow_offload.h            |   5 +
>  include/net/netfilter/nf_flow_table.h |  23 ++++
>  net/netfilter/nf_flow_table_offload.c |  23 ----
>  net/sched/act_ct.c                    | 208 ++++++++++++++++++++++++++++++++++
>  4 files changed, 236 insertions(+), 23 deletions(-)
>
> <snip>
> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
> index 23eba61..d57e7969 100644
> --- a/net/sched/act_ct.c
> +++ b/net/sched/act_ct.c
> @@ -55,7 +55,215 @@ struct tcf_ct_flow_table {
>  	.automatic_shrinking = true,
>  };
>  
> +static struct flow_action_entry *
> +tcf_ct_flow_table_flow_action_get_next(struct flow_action *flow_action)
> +{
> +	int i = flow_action->num_entries++;
> +
> +	return &flow_action->entries[i];
> +}
> +
> +static void tcf_ct_add_mangle_action(struct flow_action *action,
> +				     enum flow_action_mangle_base htype,
> +				     u32 offset,
> +				     u32 mask,
> +				     u32 val)
> +{
> +	struct flow_action_entry *entry;
> +
> +	entry = tcf_ct_flow_table_flow_action_get_next(action);
> +	entry->id = FLOW_ACTION_MANGLE;
> +	entry->mangle.htype = htype;
> +	entry->mangle.mask = ~mask;
> +	entry->mangle.offset = offset;
> +	entry->mangle.val = val;
> +}
> +
> +static void
> +tcf_ct_flow_table_add_action_nat_ipv4(const struct nf_conntrack_tuple *tuple,
> +				      struct nf_conntrack_tuple target,
> +				      struct flow_action *action)
> +{
> +	if (memcmp(&target.src.u3, &tuple->src.u3, sizeof(target.src.u3)))
> +		tcf_ct_add_mangle_action(action, FLOW_ACT_MANGLE_HDR_TYPE_IP4,
> +					 offsetof(struct iphdr, saddr),
> +					 0xFFFFFF,
Why is this mask only 24 bits?

> +					 be32_to_cpu(target.src.u3.ip));
> +	if (memcmp(&target.dst.u3, &tuple->dst.u3, sizeof(target.dst.u3)))
> +		tcf_ct_add_mangle_action(action, FLOW_ACT_MANGLE_HDR_TYPE_IP4,
> +					 offsetof(struct iphdr, daddr),
> +					 0xFFFFFF,
> +					 be32_to_cpu(target.dst.u3.ip));
> +}
> +
> +static void
> +tcf_ct_add_ipv6_addr_mangle_action(struct flow_action *action,
> +				   union nf_inet_addr *addr,
> +				   u32 offset)
> +{
> +	int i;
> +
> +	for (i = 0; i < sizeof(struct in6_addr) / sizeof(u32); i++)
> +		tcf_ct_add_mangle_action(action, FLOW_ACT_MANGLE_HDR_TYPE_IP6,
> +					 i * sizeof(u32) + offset,
> +					 0xFFFFFF, be32_to_cpu(addr->ip6[i]));
Again, looks like this is meant to be 0xffffffff.

> +}
> +
> +static void
> +tcf_ct_flow_table_add_action_nat_ipv6(const struct nf_conntrack_tuple *tuple,
> +				      struct nf_conntrack_tuple target,
> +				      struct flow_action *action)
> +{
> +	if (memcmp(&target.src.u3, &tuple->src.u3, sizeof(target.src.u3)))
> +		tcf_ct_add_ipv6_addr_mangle_action(action, &target.src.u3,
> +						   offsetof(struct ipv6hdr,
> +							    saddr));
> +	if (memcmp(&target.dst.u3, &tuple->dst.u3, sizeof(target.dst.u3)))
> +		tcf_ct_add_ipv6_addr_mangle_action(action, &target.dst.u3,
> +						   offsetof(struct ipv6hdr,
> +							    daddr));
> +}
> +
> +static void
> +tcf_ct_flow_table_add_action_nat_tcp(const struct nf_conntrack_tuple *tuple,
> +				     struct nf_conntrack_tuple target,
> +				     struct flow_action *action)
> +{
> +	__be16 target_src = target.src.u.tcp.port;
> +	__be16 target_dst = target.dst.u.tcp.port;
> +
> +	if (target_src != tuple->src.u.tcp.port)
> +		tcf_ct_add_mangle_action(action, FLOW_ACT_MANGLE_HDR_TYPE_TCP,
> +					 offsetof(struct tcphdr, source),
> +					 0xFFFF, htons(target_src));
htons() on a __be16 is wrong — did you run this through sparse?
(htons takes a u16 and returns a __be16: "host to network short".)
Either ntohs() or, canonically, be16_to_cpu().

> +	if (target_dst != tuple->dst.u.tcp.port)
> +		tcf_ct_add_mangle_action(action, FLOW_ACT_MANGLE_HDR_TYPE_TCP,
> +					 offsetof(struct tcphdr, dest),
> +					 0xFFFF, htons(target_dst));
> +}
> +
> +static void
> +tcf_ct_flow_table_add_action_nat_udp(const struct nf_conntrack_tuple *tuple,
> +				     struct nf_conntrack_tuple target,
> +				     struct flow_action *action)
> +{
> +	__be16 target_src = target.src.u.udp.port;
> +	__be16 target_dst = target.dst.u.udp.port;
> +
> +	if (target_src != tuple->src.u.udp.port)
> +		tcf_ct_add_mangle_action(action, FLOW_ACT_MANGLE_HDR_TYPE_TCP,
> +					 offsetof(struct udphdr, source),
> +					 0xFFFF, htons(target_src));
> +	if (target_dst != tuple->dst.u.udp.port)
> +		tcf_ct_add_mangle_action(action, FLOW_ACT_MANGLE_HDR_TYPE_TCP,
> +					 offsetof(struct udphdr, dest),
> +					 0xFFFF, htons(target_dst));
> +}
> +
> +static void tcf_ct_flow_table_add_action_meta(struct nf_conn *ct,
> +					      enum ip_conntrack_dir dir,
> +					      struct flow_action *action)
> +{
> +	struct nf_conn_labels *ct_labels;
> +	struct flow_action_entry *entry;
> +	u32 *act_ct_labels;
> +
> +	entry = tcf_ct_flow_table_flow_action_get_next(action);
> +	entry->id = FLOW_ACTION_CT_METADATA;
> +#if IS_ENABLED(CONFIG_NF_CONNTRACK_MARK)
> +	entry->ct_metadata.mark = ct->mark;
> +#endif
> +
> +	act_ct_labels = entry->ct_metadata.labels;
> +	ct_labels = nf_ct_labels_find(ct);
> +	if (ct_labels)
> +		memcpy(act_ct_labels, ct_labels->bits, NF_CT_LABELS_MAX_SIZE);
> +	else
> +		memset(act_ct_labels, 0, NF_CT_LABELS_MAX_SIZE);
> +}
> +
> +static int tcf_ct_flow_table_add_action_nat(struct net *net,
> +					    struct nf_conn *ct,
> +					    enum ip_conntrack_dir dir,
> +					    struct flow_action *action)
> +{
> +	const struct nf_conntrack_tuple *tuple = &ct->tuplehash[dir].tuple;
> +	struct nf_conntrack_tuple target;
> +
> +	nf_ct_invert_tuple(&target, &ct->tuplehash[!dir].tuple);
> +
> +	/* The following helper functions check if the inverted reverse tuple
> +	 * is different then the current dir tuple - meaning nat for ports
> +	 * and/or ip is needed, and add the relevant mangle actions.
> +	 */
Probably better to put this comment above the helpers, ratherthan the
 calls to them, so that people reading the source linearly see the comment
 before the memcmp()s.

-ed
> +
> +	switch (tuple->src.l3num) {
> +	case NFPROTO_IPV4:
> +		tcf_ct_flow_table_add_action_nat_ipv4(tuple, target,
> +						      action);
> +		break;
> +	case NFPROTO_IPV6:
> +		tcf_ct_flow_table_add_action_nat_ipv6(tuple, target,
> +						      action);
> +		break;
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +
> +	switch (nf_ct_protonum(ct)) {
> +	case IPPROTO_TCP:
> +		tcf_ct_flow_table_add_action_nat_tcp(tuple, target, action);
> +		break;
> +	case IPPROTO_UDP:
> +		tcf_ct_flow_table_add_action_nat_udp(tuple, target, action);
> +		break;
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +
> +	return 0;
> +}
> +
> +static int tcf_ct_flow_table_fill_actions(struct net *net,
> +					  const struct flow_offload *flow,
> +					  enum flow_offload_tuple_dir tdir,
> +					  struct nf_flow_rule *flow_rule)
> +{
> +	struct flow_action *action = &flow_rule->rule->action;
> +	int num_entries = action->num_entries;
> +	struct nf_conn *ct = flow->ct;
> +	enum ip_conntrack_dir dir;
> +	int i, err;
> +
> +	switch (tdir) {
> +	case FLOW_OFFLOAD_DIR_ORIGINAL:
> +		dir = IP_CT_DIR_ORIGINAL;
> +		break;
> +	case FLOW_OFFLOAD_DIR_REPLY:
> +		dir = IP_CT_DIR_REPLY;
> +		break;
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +
> +	err = tcf_ct_flow_table_add_action_nat(net, ct, dir, action);
> +	if (err)
> +		goto err_nat;
> +
> +	tcf_ct_flow_table_add_action_meta(ct, dir, action);
> +	return 0;
> +
> +err_nat:
> +	/* Clear filled actions */
> +	for (i = num_entries; i < action->num_entries; i++)
> +		memset(&action->entries[i], 0, sizeof(action->entries[i]));
> +	action->num_entries = num_entries;
> +
> +	return err;
> +}
> +
>  static struct nf_flowtable_type flowtable_ct = {
> +	.action		= tcf_ct_flow_table_fill_actions,
>  	.owner		= THIS_MODULE,
>  };
>  

