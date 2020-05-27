Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF7191E3CE6
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 10:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728991AbgE0I7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 04:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728152AbgE0I7g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 04:59:36 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E9FAC061A0F
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 01:59:36 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id u188so2258618wmu.1
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 01:59:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=UwvjkXdAbuqdE30EG/tiGfIvykyMS9KeHRmKFocaVMI=;
        b=ZJVQOOA2P9tsgr7D3iwKD5zK5rHdkLb3PkYeojOu8WKqIrvN9X+zDcIN4OSkaFrdSw
         VVDOs6D/xs3UoKzEx8mg4+cNblRdq+jSuEKKhSd27gpOO1UNMZD4HP3NZ1Ks7PcVJSef
         NS39FlCwA78DuAjJjq3xW1Ox+VSP5lgi4bn6A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UwvjkXdAbuqdE30EG/tiGfIvykyMS9KeHRmKFocaVMI=;
        b=tBD6UfaLZfmGImbD9aZWp057XnHB5SI7gYHDeDymnwODbZAOItYnmRBbyZANj27uFm
         ELGsfCNomXnXFlWHFkzCyOVBUlttDCaJe2ioa4mFuhVqB/wkb2x8BxPAgabQHo53U7g+
         VgU1vzkePEGRh62ELp3OG64uVZ616ZW+O/zPV/esYd0AjRKc4bB/SG/L61Yomu78yEQ3
         ZUOBqKHRjLRA7REVN4bSvixvhq9KElaDBe9oKICP6dh0D1jBCESDkjKzfZQ5t6g3yHmT
         lkgT4nkPD6AuvwHXYCku7CGZLu+mC8bSvQwrCC/jS9J4I/p/7cvRm6RAkCfEnxjzXLwt
         a+kQ==
X-Gm-Message-State: AOAM530ex/M1GYpZeT+kC4p3tCaN4IXzVl7BZI0afwLyzmBO0NuqgWjV
        ABZWDjlKVZOCEdllepJ4ihYDG9h8jlwjog==
X-Google-Smtp-Source: ABdhPJxjnkF/VEqL+SQzNs6F7FzDuQ+GB/ykfneErdtfh55n13HShlAu9eLz43dMJwRn4CJY8mzzZw==
X-Received: by 2002:a1c:9a47:: with SMTP id c68mr3169160wme.19.1590569974901;
        Wed, 27 May 2020 01:59:34 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id e29sm2318810wra.7.2020.05.27.01.59.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2020 01:59:33 -0700 (PDT)
Subject: Re: [PATCH net-next] bridge: mrp: Rework the MRP netlink interface
To:     Horatiu Vultur <horatiu.vultur@microchip.com>, davem@davemloft.net,
        kuba@kernel.org, roopa@cumulusnetworks.com, mkubecek@suse.cz,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org
References: <20200526142249.386410-1-horatiu.vultur@microchip.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <29e8111a-8151-4395-8743-2c8455290601@cumulusnetworks.com>
Date:   Wed, 27 May 2020 11:59:32 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200526142249.386410-1-horatiu.vultur@microchip.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/05/2020 17:22, Horatiu Vultur wrote:
> This patch rework the MRP netlink interface. Before, each attribute
> represented a binary structure which made it hard to be extended.
> Therefore update the MRP netlink interface such that each existing
> attribute to be a nested attribute which contains the fields of the
> binary structures.
> In this way the MRP netlink interface can be extended without breaking
> the backwards compatibility. It is also using strict checking for
> attributes under the MRP top attribute.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  include/uapi/linux/if_bridge.h |  64 ++++++++-
>  net/bridge/br_mrp.c            |   8 +-
>  net/bridge/br_mrp_netlink.c    | 248 ++++++++++++++++++++++++++++-----
>  net/bridge/br_private_mrp.h    |   2 +-
>  4 files changed, 272 insertions(+), 50 deletions(-)
> 

Hi Horatiu,
I think the functions below should be static. Also you could do better with the error
reporting. It seems extack is passed down, so you could return something meaningful for
each missing value.

net/bridge/br_mrp_netlink.c:27:5: warning: no previous prototype for ‘br_mrp_instance_parse’ [-Wmissing-prototypes]
   27 | int br_mrp_instance_parse(struct net_bridge *br, struct nlattr *attr,
      |     ^~~~~~~~~~~~~~~~~~~~~
net/bridge/br_mrp_netlink.c:64:5: warning: no previous prototype for ‘br_mrp_port_state_parse’ [-Wmissing-prototypes]
   64 | int br_mrp_port_state_parse(struct net_bridge_port *p, struct nlattr *attr,
      |     ^~~~~~~~~~~~~~~~~~~~~~~
net/bridge/br_mrp_netlink.c:90:5: warning: no previous prototype for ‘br_mrp_port_role_parse’ [-Wmissing-prototypes]
   90 | int br_mrp_port_role_parse(struct net_bridge_port *p, struct nlattr *attr,
      |     ^~~~~~~~~~~~~~~~~~~~~~
net/bridge/br_mrp_netlink.c:117:5: warning: no previous prototype for ‘br_mrp_ring_state_parse’ [-Wmissing-prototypes]
  117 | int br_mrp_ring_state_parse(struct net_bridge *br, struct nlattr *attr,
      |     ^~~~~~~~~~~~~~~~~~~~~~~
net/bridge/br_mrp_netlink.c:148:5: warning: no previous prototype for ‘br_mrp_ring_role_parse’ [-Wmissing-prototypes]
  148 | int br_mrp_ring_role_parse(struct net_bridge *br, struct nlattr *attr,
      |     ^~~~~~~~~~~~~~~~~~~~~~
net/bridge/br_mrp_netlink.c:181:5: warning: no previous prototype for ‘br_mrp_start_test_parse’ [-Wmissing-prototypes]
  181 | int br_mrp_start_test_parse(struct net_bridge *br, struct nlattr *attr,
      |     ^~~~~~~~~~~~~~~~~~~~~~~


Cheers,
 Nik

> diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
> index bd8c95488f161..5a43eb86c93bf 100644
> --- a/include/uapi/linux/if_bridge.h
> +++ b/include/uapi/linux/if_bridge.h
> @@ -169,17 +169,69 @@ enum {
>  	__IFLA_BRIDGE_MRP_MAX,
>  };
>  
> +#define IFLA_BRIDGE_MRP_MAX (__IFLA_BRIDGE_MRP_MAX - 1)
> +
> +enum {
> +	IFLA_BRIDGE_MRP_INSTANCE_UNSPEC,
> +	IFLA_BRIDGE_MRP_INSTANCE_RING_ID,
> +	IFLA_BRIDGE_MRP_INSTANCE_P_IFINDEX,
> +	IFLA_BRIDGE_MRP_INSTANCE_S_IFINDEX,
> +	__IFLA_BRIDGE_MRP_INSTANCE_MAX,
> +};
> +
> +#define IFLA_BRIDGE_MRP_INSTANCE_MAX (__IFLA_BRIDGE_MRP_INSTANCE_MAX - 1)
> +
> +enum {
> +	IFLA_BRIDGE_MRP_PORT_STATE_UNSPEC,
> +	IFLA_BRIDGE_MRP_PORT_STATE_STATE,
> +	__IFLA_BRIDGE_MRP_PORT_STATE_MAX,
> +};
> +
> +#define IFLA_BRIDGE_MRP_PORT_STATE_MAX (__IFLA_BRIDGE_MRP_PORT_STATE_MAX - 1)
> +
> +enum {
> +	IFLA_BRIDGE_MRP_PORT_ROLE_UNSPEC,
> +	IFLA_BRIDGE_MRP_PORT_ROLE_ROLE,
> +	__IFLA_BRIDGE_MRP_PORT_ROLE_MAX,
> +};
> +
> +#define IFLA_BRIDGE_MRP_PORT_ROLE_MAX (__IFLA_BRIDGE_MRP_PORT_ROLE_MAX - 1)
> +
> +enum {
> +	IFLA_BRIDGE_MRP_RING_STATE_UNSPEC,
> +	IFLA_BRIDGE_MRP_RING_STATE_RING_ID,
> +	IFLA_BRIDGE_MRP_RING_STATE_STATE,
> +	__IFLA_BRIDGE_MRP_RING_STATE_MAX,
> +};
> +
> +#define IFLA_BRIDGE_MRP_RING_STATE_MAX (__IFLA_BRIDGE_MRP_RING_STATE_MAX - 1)
> +
> +enum {
> +	IFLA_BRIDGE_MRP_RING_ROLE_UNSPEC,
> +	IFLA_BRIDGE_MRP_RING_ROLE_RING_ID,
> +	IFLA_BRIDGE_MRP_RING_ROLE_ROLE,
> +	__IFLA_BRIDGE_MRP_RING_ROLE_MAX,
> +};
> +
> +#define IFLA_BRIDGE_MRP_RING_ROLE_MAX (__IFLA_BRIDGE_MRP_RING_ROLE_MAX - 1)
> +
> +enum {
> +	IFLA_BRIDGE_MRP_START_TEST_UNSPEC,
> +	IFLA_BRIDGE_MRP_START_TEST_RING_ID,
> +	IFLA_BRIDGE_MRP_START_TEST_INTERVAL,
> +	IFLA_BRIDGE_MRP_START_TEST_MAX_MISS,
> +	IFLA_BRIDGE_MRP_START_TEST_PERIOD,
> +	__IFLA_BRIDGE_MRP_START_TEST_MAX,
> +};
> +
> +#define IFLA_BRIDGE_MRP_START_TEST_MAX (__IFLA_BRIDGE_MRP_START_TEST_MAX - 1)
> +
>  struct br_mrp_instance {
>  	__u32 ring_id;
>  	__u32 p_ifindex;
>  	__u32 s_ifindex;
>  };
>  
> -struct br_mrp_port_role {
> -	__u32 ring_id;
> -	__u32 role;
> -};
> -
>  struct br_mrp_ring_state {
>  	__u32 ring_id;
>  	__u32 ring_state;
> @@ -197,8 +249,6 @@ struct br_mrp_start_test {
>  	__u32 period;
>  };
>  
> -#define IFLA_BRIDGE_MRP_MAX (__IFLA_BRIDGE_MRP_MAX - 1)
> -
>  struct bridge_stp_xstats {
>  	__u64 transition_blk;
>  	__u64 transition_fwd;
> diff --git a/net/bridge/br_mrp.c b/net/bridge/br_mrp.c
> index 528d767eb026f..8ea59504ef47a 100644
> --- a/net/bridge/br_mrp.c
> +++ b/net/bridge/br_mrp.c
> @@ -376,24 +376,24 @@ int br_mrp_set_port_state(struct net_bridge_port *p,
>   * note: already called with rtnl_lock
>   */
>  int br_mrp_set_port_role(struct net_bridge_port *p,
> -			 struct br_mrp_port_role *role)
> +			 enum br_mrp_port_role_type role)
>  {
>  	struct br_mrp *mrp;
>  
>  	if (!p || !(p->flags & BR_MRP_AWARE))
>  		return -EINVAL;
>  
> -	mrp = br_mrp_find_id(p->br, role->ring_id);
> +	mrp = br_mrp_find_port(p->br, p);
>  
>  	if (!mrp)
>  		return -EINVAL;
>  
> -	if (role->role == BR_MRP_PORT_ROLE_PRIMARY)
> +	if (role == BR_MRP_PORT_ROLE_PRIMARY)
>  		rcu_assign_pointer(mrp->p_port, p);
>  	else
>  		rcu_assign_pointer(mrp->s_port, p);
>  
> -	br_mrp_port_switchdev_set_role(p, role->role);
> +	br_mrp_port_switchdev_set_role(p, role);
>  
>  	return 0;
>  }
> diff --git a/net/bridge/br_mrp_netlink.c b/net/bridge/br_mrp_netlink.c
> index 4a08a99519b04..cfad5d1cff050 100644
> --- a/net/bridge/br_mrp_netlink.c
> +++ b/net/bridge/br_mrp_netlink.c
> @@ -8,19 +8,204 @@
>  
>  static const struct nla_policy br_mrp_policy[IFLA_BRIDGE_MRP_MAX + 1] = {
>  	[IFLA_BRIDGE_MRP_UNSPEC]	= { .type = NLA_REJECT },
> -	[IFLA_BRIDGE_MRP_INSTANCE]	= { .type = NLA_EXACT_LEN,
> -				    .len = sizeof(struct br_mrp_instance)},
> -	[IFLA_BRIDGE_MRP_PORT_STATE]	= { .type = NLA_U32 },
> -	[IFLA_BRIDGE_MRP_PORT_ROLE]	= { .type = NLA_EXACT_LEN,
> -				    .len = sizeof(struct br_mrp_port_role)},
> -	[IFLA_BRIDGE_MRP_RING_STATE]	= { .type = NLA_EXACT_LEN,
> -				    .len = sizeof(struct br_mrp_ring_state)},
> -	[IFLA_BRIDGE_MRP_RING_ROLE]	= { .type = NLA_EXACT_LEN,
> -				    .len = sizeof(struct br_mrp_ring_role)},
> -	[IFLA_BRIDGE_MRP_START_TEST]	= { .type = NLA_EXACT_LEN,
> -				    .len = sizeof(struct br_mrp_start_test)},
> +	[IFLA_BRIDGE_MRP_INSTANCE]	= { .type = NLA_NESTED },
> +	[IFLA_BRIDGE_MRP_PORT_STATE]	= { .type = NLA_NESTED },
> +	[IFLA_BRIDGE_MRP_PORT_ROLE]	= { .type = NLA_NESTED },
> +	[IFLA_BRIDGE_MRP_RING_STATE]	= { .type = NLA_NESTED },
> +	[IFLA_BRIDGE_MRP_RING_ROLE]	= { .type = NLA_NESTED },
> +	[IFLA_BRIDGE_MRP_START_TEST]	= { .type = NLA_NESTED },
>  };
>  
> +static const struct nla_policy
> +br_mrp_instance_policy[IFLA_BRIDGE_MRP_INSTANCE_MAX + 1] = {
> +	[IFLA_BRIDGE_MRP_INSTANCE_UNSPEC]	= { .type = NLA_REJECT },
> +	[IFLA_BRIDGE_MRP_INSTANCE_RING_ID]	= { .type = NLA_U32 },
> +	[IFLA_BRIDGE_MRP_INSTANCE_P_IFINDEX]	= { .type = NLA_U32 },
> +	[IFLA_BRIDGE_MRP_INSTANCE_S_IFINDEX]	= { .type = NLA_U32 },
> +};
> +
> +int br_mrp_instance_parse(struct net_bridge *br, struct nlattr *attr,
> +			  int cmd, struct netlink_ext_ack *extack)
> +{
> +	struct nlattr *tb[IFLA_BRIDGE_MRP_INSTANCE_MAX + 1];
> +	struct br_mrp_instance inst;
> +	int err;
> +
> +	err = nla_parse_nested(tb, IFLA_BRIDGE_MRP_INSTANCE_MAX, attr,
> +			       br_mrp_instance_policy, extack);
> +	if (err)
> +		return err;
> +
> +	if (!tb[IFLA_BRIDGE_MRP_INSTANCE_RING_ID] ||
> +	    !tb[IFLA_BRIDGE_MRP_INSTANCE_P_IFINDEX] ||
> +	    !tb[IFLA_BRIDGE_MRP_INSTANCE_S_IFINDEX])
> +		return -EINVAL;
> +
> +	memset(&inst, 0, sizeof(inst));
> +
> +	inst.ring_id = nla_get_u32(tb[IFLA_BRIDGE_MRP_INSTANCE_RING_ID]);
> +	inst.p_ifindex = nla_get_u32(tb[IFLA_BRIDGE_MRP_INSTANCE_P_IFINDEX]);
> +	inst.s_ifindex = nla_get_u32(tb[IFLA_BRIDGE_MRP_INSTANCE_S_IFINDEX]);
> +
> +	if (cmd == RTM_SETLINK)
> +		return br_mrp_add(br, &inst);
> +	else
> +		return br_mrp_del(br, &inst);
> +
> +	return 0;
> +}
> +
> +static const struct nla_policy
> +br_mrp_port_state_policy[IFLA_BRIDGE_MRP_PORT_STATE_MAX + 1] = {
> +	[IFLA_BRIDGE_MRP_PORT_STATE_UNSPEC]	= { .type = NLA_REJECT },
> +	[IFLA_BRIDGE_MRP_PORT_STATE_STATE]	= { .type = NLA_U32 },
> +};
> +
> +int br_mrp_port_state_parse(struct net_bridge_port *p, struct nlattr *attr,
> +			    struct netlink_ext_ack *extack)
> +{
> +	struct nlattr *tb[IFLA_BRIDGE_MRP_PORT_STATE_MAX + 1];
> +	enum br_mrp_port_state_type state;
> +	int err;
> +
> +	err = nla_parse_nested(tb, IFLA_BRIDGE_MRP_PORT_STATE_MAX, attr,
> +			       br_mrp_port_state_policy, extack);
> +	if (err)
> +		return err;
> +
> +	if (!tb[IFLA_BRIDGE_MRP_PORT_STATE_STATE])
> +		return -EINVAL;
> +
> +	state = nla_get_u32(tb[IFLA_BRIDGE_MRP_PORT_STATE_STATE]);
> +
> +	return br_mrp_set_port_state(p, state);
> +}
> +
> +static const struct nla_policy
> +br_mrp_port_role_policy[IFLA_BRIDGE_MRP_PORT_ROLE_MAX + 1] = {
> +	[IFLA_BRIDGE_MRP_PORT_ROLE_UNSPEC]	= { .type = NLA_REJECT },
> +	[IFLA_BRIDGE_MRP_PORT_ROLE_ROLE]	= { .type = NLA_U32 },
> +};
> +
> +int br_mrp_port_role_parse(struct net_bridge_port *p, struct nlattr *attr,
> +			   struct netlink_ext_ack *extack)
> +{
> +	struct nlattr *tb[IFLA_BRIDGE_MRP_PORT_ROLE_MAX + 1];
> +	enum br_mrp_port_role_type role;
> +	int err;
> +
> +	err = nla_parse_nested(tb, IFLA_BRIDGE_MRP_PORT_ROLE_MAX, attr,
> +			       br_mrp_port_role_policy, extack);
> +	if (err)
> +		return err;
> +
> +	if (!tb[IFLA_BRIDGE_MRP_PORT_ROLE_ROLE])
> +		return -EINVAL;
> +
> +	role = nla_get_u32(tb[IFLA_BRIDGE_MRP_PORT_ROLE_ROLE]);
> +
> +	return br_mrp_set_port_role(p, role);
> +}
> +
> +static const struct nla_policy
> +br_mrp_ring_state_policy[IFLA_BRIDGE_MRP_RING_STATE_MAX + 1] = {
> +	[IFLA_BRIDGE_MRP_RING_STATE_UNSPEC]	= { .type = NLA_REJECT },
> +	[IFLA_BRIDGE_MRP_RING_STATE_RING_ID]	= { .type = NLA_U32 },
> +	[IFLA_BRIDGE_MRP_RING_STATE_STATE]	= { .type = NLA_U32 },
> +};
> +
> +int br_mrp_ring_state_parse(struct net_bridge *br, struct nlattr *attr,
> +			    struct netlink_ext_ack *extack)
> +{
> +	struct nlattr *tb[IFLA_BRIDGE_MRP_RING_STATE_MAX + 1];
> +	struct br_mrp_ring_state state;
> +	int err;
> +
> +	err = nla_parse_nested(tb, IFLA_BRIDGE_MRP_RING_STATE_MAX, attr,
> +			       br_mrp_ring_state_policy, extack);
> +	if (err)
> +		return err;
> +
> +	if (!tb[IFLA_BRIDGE_MRP_RING_STATE_RING_ID] ||
> +	    !tb[IFLA_BRIDGE_MRP_RING_STATE_STATE])
> +		return -EINVAL;
> +
> +	memset(&state, 0x0, sizeof(state));
> +
> +	state.ring_id = nla_get_u32(tb[IFLA_BRIDGE_MRP_RING_STATE_RING_ID]);
> +	state.ring_state = nla_get_u32(tb[IFLA_BRIDGE_MRP_RING_STATE_STATE]);
> +
> +	return br_mrp_set_ring_state(br, &state);
> +}
> +
> +static const struct nla_policy
> +br_mrp_ring_role_policy[IFLA_BRIDGE_MRP_RING_ROLE_MAX + 1] = {
> +	[IFLA_BRIDGE_MRP_RING_ROLE_UNSPEC]	= { .type = NLA_REJECT },
> +	[IFLA_BRIDGE_MRP_RING_ROLE_RING_ID]	= { .type = NLA_U32 },
> +	[IFLA_BRIDGE_MRP_RING_ROLE_ROLE]	= { .type = NLA_U32 },
> +};
> +
> +int br_mrp_ring_role_parse(struct net_bridge *br, struct nlattr *attr,
> +			   struct netlink_ext_ack *extack)
> +{
> +	struct nlattr *tb[IFLA_BRIDGE_MRP_RING_ROLE_MAX + 1];
> +	struct br_mrp_ring_role role;
> +	int err;
> +
> +	err = nla_parse_nested(tb, IFLA_BRIDGE_MRP_RING_ROLE_MAX, attr,
> +			       br_mrp_ring_role_policy, extack);
> +	if (err)
> +		return err;
> +
> +	if (!tb[IFLA_BRIDGE_MRP_RING_ROLE_RING_ID] ||
> +	    !tb[IFLA_BRIDGE_MRP_RING_ROLE_ROLE])
> +		return -EINVAL;
> +
> +	memset(&role, 0x0, sizeof(role));
> +
> +	role.ring_id = nla_get_u32(tb[IFLA_BRIDGE_MRP_RING_ROLE_RING_ID]);
> +	role.ring_role = nla_get_u32(tb[IFLA_BRIDGE_MRP_RING_ROLE_ROLE]);
> +
> +	return br_mrp_set_ring_role(br, &role);
> +}
> +
> +static const struct nla_policy
> +br_mrp_start_test_policy[IFLA_BRIDGE_MRP_START_TEST_MAX + 1] = {
> +	[IFLA_BRIDGE_MRP_START_TEST_UNSPEC]	= { .type = NLA_REJECT },
> +	[IFLA_BRIDGE_MRP_START_TEST_RING_ID]	= { .type = NLA_U32 },
> +	[IFLA_BRIDGE_MRP_START_TEST_INTERVAL]	= { .type = NLA_U32 },
> +	[IFLA_BRIDGE_MRP_START_TEST_MAX_MISS]	= { .type = NLA_U32 },
> +	[IFLA_BRIDGE_MRP_START_TEST_PERIOD]	= { .type = NLA_U32 },
> +};
> +
> +int br_mrp_start_test_parse(struct net_bridge *br, struct nlattr *attr,
> +			    struct netlink_ext_ack *extack)
> +{
> +	struct nlattr *tb[IFLA_BRIDGE_MRP_START_TEST_MAX + 1];
> +	struct br_mrp_start_test test;
> +	int err;
> +
> +	err = nla_parse_nested(tb, IFLA_BRIDGE_MRP_START_TEST_MAX, attr,
> +			       br_mrp_start_test_policy, extack);
> +	if (err)
> +		return err;
> +
> +	if (!tb[IFLA_BRIDGE_MRP_START_TEST_RING_ID] ||
> +	    !tb[IFLA_BRIDGE_MRP_START_TEST_INTERVAL] ||
> +	    !tb[IFLA_BRIDGE_MRP_START_TEST_MAX_MISS] ||
> +	    !tb[IFLA_BRIDGE_MRP_START_TEST_PERIOD])
> +		return -EINVAL;
> +
> +	memset(&test, 0x0, sizeof(test));
> +
> +	test.ring_id = nla_get_u32(tb[IFLA_BRIDGE_MRP_START_TEST_RING_ID]);
> +	test.interval = nla_get_u32(tb[IFLA_BRIDGE_MRP_START_TEST_INTERVAL]);
> +	test.max_miss = nla_get_u32(tb[IFLA_BRIDGE_MRP_START_TEST_MAX_MISS]);
> +	test.period = nla_get_u32(tb[IFLA_BRIDGE_MRP_START_TEST_PERIOD]);
> +
> +	return br_mrp_start_test(br, &test);
> +}
> +
>  int br_mrp_parse(struct net_bridge *br, struct net_bridge_port *p,
>  		 struct nlattr *attr, int cmd, struct netlink_ext_ack *extack)
>  {
> @@ -44,58 +229,45 @@ int br_mrp_parse(struct net_bridge *br, struct net_bridge_port *p,
>  		return err;
>  
>  	if (tb[IFLA_BRIDGE_MRP_INSTANCE]) {
> -		struct br_mrp_instance *instance =
> -			nla_data(tb[IFLA_BRIDGE_MRP_INSTANCE]);
> -
> -		if (cmd == RTM_SETLINK)
> -			err = br_mrp_add(br, instance);
> -		else
> -			err = br_mrp_del(br, instance);
> +		err = br_mrp_instance_parse(br, tb[IFLA_BRIDGE_MRP_INSTANCE],
> +					    cmd, extack);
>  		if (err)
>  			return err;
>  	}
>  
>  	if (tb[IFLA_BRIDGE_MRP_PORT_STATE]) {
> -		enum br_mrp_port_state_type state =
> -			nla_get_u32(tb[IFLA_BRIDGE_MRP_PORT_STATE]);
> -
> -		err = br_mrp_set_port_state(p, state);
> +		err = br_mrp_port_state_parse(p, tb[IFLA_BRIDGE_MRP_PORT_STATE],
> +					      extack);
>  		if (err)
>  			return err;
>  	}
>  
>  	if (tb[IFLA_BRIDGE_MRP_PORT_ROLE]) {
> -		struct br_mrp_port_role *role =
> -			nla_data(tb[IFLA_BRIDGE_MRP_PORT_ROLE]);
> -
> -		err = br_mrp_set_port_role(p, role);
> +		err = br_mrp_port_role_parse(p, tb[IFLA_BRIDGE_MRP_PORT_ROLE],
> +					     extack);
>  		if (err)
>  			return err;
>  	}
>  
>  	if (tb[IFLA_BRIDGE_MRP_RING_STATE]) {
> -		struct br_mrp_ring_state *state =
> -			nla_data(tb[IFLA_BRIDGE_MRP_RING_STATE]);
> -
> -		err = br_mrp_set_ring_state(br, state);
> +		err = br_mrp_ring_state_parse(br,
> +					      tb[IFLA_BRIDGE_MRP_RING_STATE],
> +					      extack);
>  		if (err)
>  			return err;
>  	}
>  
>  	if (tb[IFLA_BRIDGE_MRP_RING_ROLE]) {
> -		struct br_mrp_ring_role *role =
> -			nla_data(tb[IFLA_BRIDGE_MRP_RING_ROLE]);
> -
> -		err = br_mrp_set_ring_role(br, role);
> +		err = br_mrp_ring_role_parse(br, tb[IFLA_BRIDGE_MRP_RING_ROLE],
> +					     extack);
>  		if (err)
>  			return err;
>  	}
>  
>  	if (tb[IFLA_BRIDGE_MRP_START_TEST]) {
> -		struct br_mrp_start_test *test =
> -			nla_data(tb[IFLA_BRIDGE_MRP_START_TEST]);
> -
> -		err = br_mrp_start_test(br, test);
> +		err = br_mrp_start_test_parse(br,
> +					      tb[IFLA_BRIDGE_MRP_START_TEST],
> +					      extack);
>  		if (err)
>  			return err;
>  	}
> diff --git a/net/bridge/br_private_mrp.h b/net/bridge/br_private_mrp.h
> index 2921a4b59f8e7..a0f53cc3ab85c 100644
> --- a/net/bridge/br_private_mrp.h
> +++ b/net/bridge/br_private_mrp.h
> @@ -37,7 +37,7 @@ int br_mrp_del(struct net_bridge *br, struct br_mrp_instance *instance);
>  int br_mrp_set_port_state(struct net_bridge_port *p,
>  			  enum br_mrp_port_state_type state);
>  int br_mrp_set_port_role(struct net_bridge_port *p,
> -			 struct br_mrp_port_role *role);
> +			 enum br_mrp_port_role_type role);
>  int br_mrp_set_ring_state(struct net_bridge *br,
>  			  struct br_mrp_ring_state *state);
>  int br_mrp_set_ring_role(struct net_bridge *br, struct br_mrp_ring_role *role);
> 

