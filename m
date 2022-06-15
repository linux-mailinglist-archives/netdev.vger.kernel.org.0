Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2A7B54D046
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 19:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344358AbiFORpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 13:45:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231282AbiFORpI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 13:45:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 36F6545526
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 10:45:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655315102;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MpvvfPUBPxISWwdGZSbsUr9FbWwpWlziXSeFwGXYeKY=;
        b=EBOywovVIMUP7G1Jn84pZ7OIkiRaKbUPKBkK310G2UVoBsgbKge80Nprq+cs4NGQ6SwdQq
        lYdM4xeOqtwX+vbJa111UEXk+pSHDYb48itvjjvifLaqK7xkiF4s7I9xBzOciqXDmXBt+f
        JQFq0fuAe9ciHtW3OtuJwz5lBJS8y1c=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-670-h2eBiviXM5i19zLLwOzRmA-1; Wed, 15 Jun 2022 13:45:00 -0400
X-MC-Unique: h2eBiviXM5i19zLLwOzRmA-1
Received: by mail-qt1-f199.google.com with SMTP id f20-20020a05622a1a1400b00304eb093686so9305537qtb.5
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 10:44:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=MpvvfPUBPxISWwdGZSbsUr9FbWwpWlziXSeFwGXYeKY=;
        b=wl71FJjqJ+rOCXJ2SjzwYHyo7pCyCUYpOVpYgxMJmqjNMEdWGh7tRsGGYk6rLUyfgu
         OLUTKv8L/D7K5umCqXwWoBUDrM0qa/7HFhCofHyt02uftLlt/f1YztnOZJml0w+c6xR3
         gEOf3/FSIqQa5OeCiekFW0gwwDKuZAf54RlD0wLUASXtL70xy9rVYRPj0WyEnNLCGSfY
         hA4krXCsS2w9qHRDo8ZonNowTSMw7fRFWmqxxJHHFwARl+j1L4ruig8eNMJnjbjetoxn
         F51oo+w9e0bK7y7LUAy6O1KmXBVIOay9wQXUNtXPYYy6QQ3zU6w2Knxd7o+eDB2xU61g
         X1zA==
X-Gm-Message-State: AJIora+yKuKi3ryakMvVYww37TdpM8kLERf4pBI1KOfZcsMcdqtCYIjV
        GAKxeINbDmQ17eRkLePGnEpV5BXfbK4VL2xsMfyfFD8agekVd/qwE2hNVdIZHS+dVRh+mqCdK/y
        8lRWRq2YqCjgP0ePX
X-Received: by 2002:ac8:7f46:0:b0:305:139:fcfb with SMTP id g6-20020ac87f46000000b003050139fcfbmr650576qtk.648.1655315099420;
        Wed, 15 Jun 2022 10:44:59 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1t3d5dCDIeYOYll4pdlAcgGmG2KA+FexCODk44Q/IQDvcs8HenrZtxx4kap/9iNvIslTJjDFg==
X-Received: by 2002:ac8:7f46:0:b0:305:139:fcfb with SMTP id g6-20020ac87f46000000b003050139fcfbmr650545qtk.648.1655315099081;
        Wed, 15 Jun 2022 10:44:59 -0700 (PDT)
Received: from [192.168.98.18] ([107.12.98.143])
        by smtp.gmail.com with ESMTPSA id n1-20020a05620a294100b006a6b6638a59sm12593542qkp.53.2022.06.15.10.44.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jun 2022 10:44:58 -0700 (PDT)
Message-ID: <c5d45c3f-065d-c8e7-fcc6-4cdb54bfdd70@redhat.com>
Date:   Wed, 15 Jun 2022 13:44:57 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCHv2 net-next] Bonding: add per-port priority for failover
 re-selection
Content-Language: en-US
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>
References: <20220615032934.2057120-1-liuhangbin@gmail.com>
From:   Jonathan Toppins <jtoppins@redhat.com>
In-Reply-To: <20220615032934.2057120-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/14/22 23:29, Hangbin Liu wrote:
> Add per port priority support for bonding active slave re-selection during
> failover. A higher number means higher priority in selection. The primary
> slave still has the highest priority. This option also follows the
> primary_reselect rules.
> 
> This option could only be configured via netlink.
> 
> v2: using the extant bonding options management stuff instead setting
> slave prio in bond_slave_changelink() directly.
> 
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>   Documentation/networking/bonding.rst | 11 +++++
>   drivers/net/bonding/bond_main.c      | 27 +++++++++++
>   drivers/net/bonding/bond_netlink.c   | 19 ++++++++
>   drivers/net/bonding/bond_options.c   | 67 ++++++++++++++++++++++++++++
>   include/net/bond_options.h           |  1 +
>   include/net/bonding.h                |  1 +
>   include/uapi/linux/if_link.h         |  1 +
>   tools/include/uapi/linux/if_link.h   |  1 +
>   8 files changed, 128 insertions(+)
> 
> diff --git a/Documentation/networking/bonding.rst b/Documentation/networking/bonding.rst
> index 43be3782e5df..53a18ff7cf23 100644
> --- a/Documentation/networking/bonding.rst
> +++ b/Documentation/networking/bonding.rst
> @@ -780,6 +780,17 @@ peer_notif_delay
>   	value is 0 which means to match the value of the link monitor
>   	interval.
>   
> +prio
> +	Slave priority. A higher number means higher priority.
> +	The primary slave has the highest priority. This option also
> +	follows the primary_reselect rules.
> +
> +	This option could only be configured via netlink, and is only valid
> +	for active-backup(1), balance-tlb (5) and balance-alb (6) mode.
> +	The valid value range is a signed 32 bit integer.
> +
> +	The default value is 0.

Why is this a signed 32 bit number? Why not a u8, it would seem 256 
[255,0] options is more than enough to select from. Is there a specific 
reason it needs to be an s32?

If the reason for selecting a signed value is so that the default 
priority could be in the middle of the range, why not just set the 
default to be 128, assuming u8 is wide enough?

> +
>   primary
>   
>   	A string (eth0, eth2, etc) specifying which slave is the
> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> index 3d427183ec8e..3415a0feea07 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -1026,12 +1026,38 @@ static void bond_do_fail_over_mac(struct bonding *bond,
>   
>   }
>   
> +/**
> + * bond_choose_primary_or_current - select the primary or high priority slave
> + * @bond: our bonding struct
> + *
> + * - Check if there is a primary link. If the primary link was set and is up,
> + *   go on and do link reselection.
> + *
> + * - If primary link is not set or down, find the highest priority link.
> + *   If the highest priority link is not current slave, set it as primary
> + *   link and do link reselection.
> + */
>   static struct slave *bond_choose_primary_or_current(struct bonding *bond)
>   {
>   	struct slave *prim = rtnl_dereference(bond->primary_slave);
>   	struct slave *curr = rtnl_dereference(bond->curr_active_slave);
> +	struct slave *slave, *hprio = NULL;
> +	struct list_head *iter;
>   
>   	if (!prim || prim->link != BOND_LINK_UP) {
> +		bond_for_each_slave(bond, slave, iter) {
> +			if (slave->link == BOND_LINK_UP) {
> +				hprio = hprio ?: slave;
> +				if (slave->prio > hprio->prio)
> +					hprio = slave;
> +			}
> +		}
> +
> +		if (hprio && hprio != curr) {
> +			prim = hprio;
> +			goto link_reselect;
> +		}
> +
>   		if (!curr || curr->link != BOND_LINK_UP)
>   			return NULL;
>   		return curr;
> @@ -1042,6 +1068,7 @@ static struct slave *bond_choose_primary_or_current(struct bonding *bond)
>   		return prim;
>   	}
>   
> +link_reselect:
>   	if (!curr || curr->link != BOND_LINK_UP)
>   		return prim;
>   
> diff --git a/drivers/net/bonding/bond_netlink.c b/drivers/net/bonding/bond_netlink.c
> index 5a6f44455b95..41b3244747fa 100644
> --- a/drivers/net/bonding/bond_netlink.c
> +++ b/drivers/net/bonding/bond_netlink.c
> @@ -27,6 +27,7 @@ static size_t bond_get_slave_size(const struct net_device *bond_dev,
>   		nla_total_size(sizeof(u16)) +	/* IFLA_BOND_SLAVE_AD_AGGREGATOR_ID */
>   		nla_total_size(sizeof(u8)) +	/* IFLA_BOND_SLAVE_AD_ACTOR_OPER_PORT_STATE */
>   		nla_total_size(sizeof(u16)) +	/* IFLA_BOND_SLAVE_AD_PARTNER_OPER_PORT_STATE */
> +		nla_total_size(sizeof(s32)) +	/* IFLA_BOND_SLAVE_PRIO */
>   		0;
>   }
>   
> @@ -53,6 +54,9 @@ static int bond_fill_slave_info(struct sk_buff *skb,
>   	if (nla_put_u16(skb, IFLA_BOND_SLAVE_QUEUE_ID, slave->queue_id))
>   		goto nla_put_failure;
>   
> +	if (nla_put_s32(skb, IFLA_BOND_SLAVE_PRIO, slave->prio))
> +		goto nla_put_failure;
> +
>   	if (BOND_MODE(slave->bond) == BOND_MODE_8023AD) {
>   		const struct aggregator *agg;
>   		const struct port *ad_port;
> @@ -117,6 +121,7 @@ static const struct nla_policy bond_policy[IFLA_BOND_MAX + 1] = {
>   
>   static const struct nla_policy bond_slave_policy[IFLA_BOND_SLAVE_MAX + 1] = {
>   	[IFLA_BOND_SLAVE_QUEUE_ID]	= { .type = NLA_U16 },
> +	[IFLA_BOND_SLAVE_PRIO]		= { .type = NLA_S32 },
>   };
>   
>   static int bond_validate(struct nlattr *tb[], struct nlattr *data[],
> @@ -157,6 +162,20 @@ static int bond_slave_changelink(struct net_device *bond_dev,
>   			return err;
>   	}
>   
> +	if (data[IFLA_BOND_SLAVE_PRIO]) { > +		int prio = nla_get_s32(data[IFLA_BOND_SLAVE_PRIO]);
> +		char prio_str[IFNAMSIZ + 7];
> +
> +		/* prio option setting expects slave_name:prio */
> +		snprintf(prio_str, sizeof(prio_str), "%s:%d\n",
> +			 slave_dev->name, prio);
> +
> +		bond_opt_initstr(&newval, prio_str);

It might be less code and a little cleaner to extend struct 
bond_opt_value with a slave pointer.

	struct bond_opt_value {
		char *string;
		u64 value;
		u32 flags;
		union {
			char cextra[BOND_OPT_EXTRA_MAXLEN];
			struct net_device *slave_dev;
		} extra;
	};

Then modify __bond_opt_init to set the slave pointer, basically a set of 
bond_opt_slave_init{} macros. This would remove the need to parse the 
slave interface name in the set function. Setting .flags = 
BOND_OPTFLAG_RAWVAL (already done I see) in the option definition to 
avoid bond_opt_parse() from loosing our extra information by pointing to 
a .values table entry. Now in the option specific set function we can 
just find the slave entry and set the value, no more string parsing code 
needed.

> +		err = __bond_opt_set(bond, BOND_OPT_PRIO, &newval);

I think this patch series needs to be rebased onto latest 
net-next/master as a patch series I sent added two extra parameter list 
arguments to __bond_opt_set().

   2bff369b2354 bonding: netlink error message support for options

Considering my comments above about extending bond_opt_value, I might 
look as sending a fixup patch to remove all the parameter list additions 
and hide the netlink extack pointer in bond_opt_value.

> +		if (err)
> +			return err;
> +	}
> +
>   	return 0;
>   }
>   
> diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
> index 96eef19cffc4..bac3858825b3 100644
> --- a/drivers/net/bonding/bond_options.c
> +++ b/drivers/net/bonding/bond_options.c
> @@ -40,6 +40,8 @@ static int bond_option_arp_validate_set(struct bonding *bond,
>   					const struct bond_opt_value *newval);
>   static int bond_option_arp_all_targets_set(struct bonding *bond,
>   					   const struct bond_opt_value *newval);
> +static int bond_option_prio_set(struct bonding *bond,
> +				const struct bond_opt_value *newval);
>   static int bond_option_primary_set(struct bonding *bond,
>   				   const struct bond_opt_value *newval);
>   static int bond_option_primary_reselect_set(struct bonding *bond,
> @@ -365,6 +367,16 @@ static const struct bond_option bond_opts[BOND_OPT_LAST] = {
>   		.values = bond_intmax_tbl,
>   		.set = bond_option_miimon_set
>   	},
> +	[BOND_OPT_PRIO] = {
> +		.id = BOND_OPT_PRIO,
> +		.name = "prio",
> +		.desc = "Link priority for failover re-selection",
> +		.flags = BOND_OPTFLAG_RAWVAL,
> +		.unsuppmodes = BOND_MODE_ALL_EX(BIT(BOND_MODE_ACTIVEBACKUP) |
> +						BIT(BOND_MODE_TLB) |
> +						BIT(BOND_MODE_ALB)),
> +		.set = bond_option_prio_set
> +	},
>   	[BOND_OPT_PRIMARY] = {
>   		.id = BOND_OPT_PRIMARY,
>   		.name = "primary",
> @@ -1306,6 +1318,61 @@ static int bond_option_missed_max_set(struct bonding *bond,
>   	return 0;
>   }
>   
> +static int bond_option_prio_set(struct bonding *bond,
> +				const struct bond_opt_value *newval)
> +{
> +	struct slave *slave, *update_slave;
> +	struct net_device *sdev;
> +	struct list_head *iter;
> +	char *delim;
> +	int ret = 0;
> +	int prio;

Priorities are only considered if there is no primary set, correct? 
Would you not want to issue a netdev_warn here noting the fact that this 
will be ignored if the bond device has a primary set? Much like how 
other options issue warnings, or in miimon's case turn off arp monitor, 
when other configuration influence the effectiveness of the setting?

> +
> +	/* delim will point to prio if successful */
> +	delim = strchr(newval->string, ':');
> +	if (!delim)
> +		goto err_no_cmd;
> +
> +	/* Terminate string that points to device name and bump it
> +	 * up one, so we can read the prio there.
> +	 */
> +	*delim = '\0';
> +	if (sscanf(++delim, "%d\n", &prio) != 1)
> +		goto err_no_cmd;
> +
> +	/* Valid ifname */
> +	if (!dev_valid_name(newval->string))
> +		goto err_no_cmd;
> +
> +	/* Get the pointer to that interface if it exists */
> +	sdev = __dev_get_by_name(dev_net(bond->dev), newval->string);
> +	if (!sdev)
> +		goto err_no_cmd;
> +
> +	update_slave = NULL;
> +	bond_for_each_slave(bond, slave, iter) {
> +		if (sdev == slave->dev)
> +			update_slave = slave;
> +	}
> +
> +	if (!update_slave)
> +		goto err_no_cmd;
> +
> +	/* Actually set the prio for the slave */
> +	update_slave->prio = prio;
> +
> +	/* Do reselect after prio update */
> +	bond_select_active_slave(bond);
> +
> +out:
> +	return ret;
> +
> +err_no_cmd:
> +	netdev_dbg(bond->dev, "invalid input for slave prio set\n");
> +	ret = -EPERM;
> +	goto out;
> +}
> +
>   static int bond_option_primary_set(struct bonding *bond,
>   				   const struct bond_opt_value *newval)
>   {
> diff --git a/include/net/bond_options.h b/include/net/bond_options.h
> index 1618b76f4903..569808933094 100644
> --- a/include/net/bond_options.h
> +++ b/include/net/bond_options.h
> @@ -67,6 +67,7 @@ enum {
>   	BOND_OPT_LACP_ACTIVE,
>   	BOND_OPT_MISSED_MAX,
>   	BOND_OPT_NS_TARGETS,
> +	BOND_OPT_PRIO,
>   	BOND_OPT_LAST
>   };
>   
> diff --git a/include/net/bonding.h b/include/net/bonding.h
> index cb904d356e31..6e78d657aa05 100644
> --- a/include/net/bonding.h
> +++ b/include/net/bonding.h
> @@ -178,6 +178,7 @@ struct slave {
>   	u32    speed;
>   	u16    queue_id;
>   	u8     perm_hwaddr[MAX_ADDR_LEN];
> +	int    prio;
>   	struct ad_slave_info *ad_info;
>   	struct tlb_slave_info tlb_info;
>   #ifdef CONFIG_NET_POLL_CONTROLLER
> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
> index 5f58dcfe2787..e36d9d2c65a7 100644
> --- a/include/uapi/linux/if_link.h
> +++ b/include/uapi/linux/if_link.h
> @@ -963,6 +963,7 @@ enum {
>   	IFLA_BOND_SLAVE_AD_AGGREGATOR_ID,
>   	IFLA_BOND_SLAVE_AD_ACTOR_OPER_PORT_STATE,
>   	IFLA_BOND_SLAVE_AD_PARTNER_OPER_PORT_STATE,
> +	IFLA_BOND_SLAVE_PRIO,
>   	__IFLA_BOND_SLAVE_MAX,
>   };
>   
> diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
> index b339bf2196ca..0242f31e339c 100644
> --- a/tools/include/uapi/linux/if_link.h
> +++ b/tools/include/uapi/linux/if_link.h
> @@ -890,6 +890,7 @@ enum {
>   	IFLA_BOND_SLAVE_AD_AGGREGATOR_ID,
>   	IFLA_BOND_SLAVE_AD_ACTOR_OPER_PORT_STATE,
>   	IFLA_BOND_SLAVE_AD_PARTNER_OPER_PORT_STATE,
> +	IFLA_BOND_SLAVE_PRIO,
>   	__IFLA_BOND_SLAVE_MAX,
>   };
>   

