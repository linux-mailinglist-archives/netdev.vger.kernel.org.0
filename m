Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 932A84FE574
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 17:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357404AbiDLP6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 11:58:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357412AbiDLP6G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 11:58:06 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 898EB26AE3
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 08:55:47 -0700 (PDT)
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 1386B3F369
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 15:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1649778945;
        bh=IdsK3rslWvEczfLRUZxAwD+uspBC4ZtTr8zubl+sf34=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=YTMmlP5ACA1TJmgjE05Uu6zUWWXQLKUVmDmi4bsWxikaVfd+tzeOg8LrgbHLcc5Oa
         /3bJ+eYhcLtFUuDOp3wmlfizwe/HsaLTSG/W7BMrvUDBXo/wEVyuNnUZ+2sWti/mOV
         sgMA7hH/yu7fYadKRbIGQr2Ukz9YmmTzfSdNnSckjnhEvHmp6VgOFwGsXy5to6CnTL
         TAJ0AsJzI6vhMr/b/b2lV+oAYgZRhKETLR+7tiVcKROLyoJepQ+OiLXoPHur7/fz1O
         mYsNjSVN2EmiD1I2vDpynk7BP7gzHNTr3/6R1WceubPdcH4DU5gCIoHo/5H5cjLZ0g
         ofx2p0puXPLrQ==
Received: by mail-pl1-f198.google.com with SMTP id s5-20020a170902b18500b00155d6fbf4d4so8069669plr.18
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 08:55:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :comments:mime-version:content-id:content-transfer-encoding:date
         :message-id;
        bh=IdsK3rslWvEczfLRUZxAwD+uspBC4ZtTr8zubl+sf34=;
        b=3NTFg9sZkbfKV2HNID8Z8JCo5E1WbVsBcF5wZKERKcRtZRe3RQCiiPHlJR5xETrEpH
         w718Bg9wpWNuQ1u6//+JAu7ZcU6x3gqDItGRPZnsSMy5CkXR9cRJQo4v0jA3JMbs4LVF
         //eu/9TO2hGjqtnav+xubzloddyYH1P2kF8C+Hd4B+HYq1NsCm+OlnwldnUZfTKCNtoT
         0gMsybfxY1w/TnHy4F8bfNbnSbNvQ4Myg36KJyYdC6DJxud7lAbAyBFMa7EHAqiFEDZf
         gYS8RoCO6XzfUxngqP3jM5zCFw1GReNsCMj11k6Y4qLyYjpotB/eGL5p7FdUIyOkhecP
         U4yA==
X-Gm-Message-State: AOAM530ThEqlYdmA2hVvB/Q7tj8tdp4NdihFlt9FTmallmsu2KlxEYGS
        MTXcKW2pegBU/ONP7Ze9FdyLigSrvCS3HnZLG3if5OL5dICn0Uo56/OVghg28JYo76pyqZDLnAP
        kX9KGi3t6G0oJZrQARTlUjh3IenGsEoA7tg==
X-Received: by 2002:a17:90a:1688:b0:1cb:9793:6824 with SMTP id o8-20020a17090a168800b001cb97936824mr5623492pja.217.1649778943342;
        Tue, 12 Apr 2022 08:55:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyNfsCzjhGn5sxnHNUIh3t8nfwKzBvVnNB/gjN9RAIU9KJpceM+AlJ9aye1WCDzDWTsUZbfIA==
X-Received: by 2002:a17:90a:1688:b0:1cb:9793:6824 with SMTP id o8-20020a17090a168800b001cb97936824mr5623460pja.217.1649778943007;
        Tue, 12 Apr 2022 08:55:43 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id c9-20020a056a00248900b005060a6be89esm631630pfv.201.2022.04.12.08.55.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Apr 2022 08:55:42 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id C5ABF6093D; Tue, 12 Apr 2022 08:55:41 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id BE88FA0B21;
        Tue, 12 Apr 2022 08:55:41 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Jonathan Toppins <jtoppins@redhat.com>
cc:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next] Bonding: add per port priority support
In-reply-to: <1d6de134-c14e-4170-d2ad-873db62d8275@redhat.com>
References: <20220412041322.2409558-1-liuhangbin@gmail.com> <1d6de134-c14e-4170-d2ad-873db62d8275@redhat.com>
Comments: In-reply-to Jonathan Toppins <jtoppins@redhat.com>
   message dated "Tue, 12 Apr 2022 10:23:27 -0400."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <20133.1649778941.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Tue, 12 Apr 2022 08:55:41 -0700
Message-ID: <20134.1649778941@famine>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jonathan Toppins <jtoppins@redhat.com> wrote:

>On 4/12/22 00:13, Hangbin Liu wrote:
>> Add per port priority support for bonding. A higher number means higher
>> priority. The primary slave still has the highest priority. This option
>> also follows the primary_reselect rules.
>> This option could only be configured via netlink.
>> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
>> ---
>>   Documentation/networking/bonding.rst |  9 +++++++++
>>   drivers/net/bonding/bond_main.c      | 27 +++++++++++++++++++++++++++
>>   drivers/net/bonding/bond_netlink.c   | 12 ++++++++++++
>>   include/net/bonding.h                |  1 +
>>   include/uapi/linux/if_link.h         |  1 +
>>   tools/include/uapi/linux/if_link.h   |  1 +
>>   6 files changed, 51 insertions(+)
>> diff --git a/Documentation/networking/bonding.rst
>> b/Documentation/networking/bonding.rst
>> index 525e6842dd33..103e292a04a1 100644
>> --- a/Documentation/networking/bonding.rst
>> +++ b/Documentation/networking/bonding.rst
>> @@ -780,6 +780,15 @@ peer_notif_delay
>>   	value is 0 which means to match the value of the link monitor
>>   	interval.
>>   +prio
>> +	Slave priority. A higher number means higher priority.
>> +	The primary slave has the highest priority. This option also
>> +	follows the primary_reselect rules.
>> +
>> +	This option could only be configured via netlink, and is only valid
>                    ^^ can
>> +	for active-backup(1), balance-tlb (5) and balance-alb (6) mode.
>> +	The default value is 0.
>> +
>>   primary
>>     	A string (eth0, eth2, etc) specifying which slave is the
>> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond=
_main.c
>> index 15eddca7b4b6..4211b79ac619 100644
>> --- a/drivers/net/bonding/bond_main.c
>> +++ b/drivers/net/bonding/bond_main.c
>> @@ -1026,12 +1026,38 @@ static void bond_do_fail_over_mac(struct bondin=
g *bond,
>>     }
>>   +/**
>> + * bond_choose_primary_or_current - select the primary or high priorit=
y slave
>> + * @bond: our bonding struct
>> + *
>> + * - Check if there is a primary link. If the primary link was set and=
 is up,
>> + *   go on and do link reselection.
>> + *
>> + * - If primary link is not set or down, find the highest priority lin=
k.
>> + *   If the highest priority link is not current slave, set it as prim=
ary
>> + *   link and do link reselection.
>> + */
>>   static struct slave *bond_choose_primary_or_current(struct bonding *b=
ond)
>>   {
>>   	struct slave *prim =3D rtnl_dereference(bond->primary_slave);
>>   	struct slave *curr =3D rtnl_dereference(bond->curr_active_slave);
>> +	struct slave *slave, *hprio =3D NULL;
>> +	struct list_head *iter;
>>     	if (!prim || prim->link !=3D BOND_LINK_UP) {
>> +		bond_for_each_slave(bond, slave, iter) {
>> +			if (slave->link =3D=3D BOND_LINK_UP) {
>> +				hprio =3D hprio ? hprio : slave;
>> +				if (slave->prio > hprio->prio)
>> +					hprio =3D slave;
>> +			}
>> +		}
>> +
>> +		if (hprio && hprio !=3D curr) {
>> +			prim =3D hprio;
>> +			goto link_reselect;
>> +		}
>> +
>>   		if (!curr || curr->link !=3D BOND_LINK_UP)
>>   			return NULL;
>>   		return curr;
>> @@ -1042,6 +1068,7 @@ static struct slave *bond_choose_primary_or_curre=
nt(struct bonding *bond)
>>   		return prim;
>>   	}
>>   +link_reselect:
>>   	if (!curr || curr->link !=3D BOND_LINK_UP)
>>   		return prim;
>>   diff --git a/drivers/net/bonding/bond_netlink.c
>> b/drivers/net/bonding/bond_netlink.c
>> index f427fa1737c7..63066559e7d6 100644
>> --- a/drivers/net/bonding/bond_netlink.c
>> +++ b/drivers/net/bonding/bond_netlink.c
>> @@ -27,6 +27,7 @@ static size_t bond_get_slave_size(const struct net_de=
vice *bond_dev,
>>   		nla_total_size(sizeof(u16)) +	/* IFLA_BOND_SLAVE_AD_AGGREGATOR_ID *=
/
>>   		nla_total_size(sizeof(u8)) +	/* IFLA_BOND_SLAVE_AD_ACTOR_OPER_PORT_=
STATE */
>>   		nla_total_size(sizeof(u16)) +	/* IFLA_BOND_SLAVE_AD_PARTNER_OPER_PO=
RT_STATE */
>> +		nla_total_size(sizeof(s32)) +	/* IFLA_BOND_SLAVE_PRIO */
>>   		0;
>>   }
>>   @@ -53,6 +54,9 @@ static int bond_fill_slave_info(struct sk_buff *skb=
,
>>   	if (nla_put_u16(skb, IFLA_BOND_SLAVE_QUEUE_ID, slave->queue_id))
>>   		goto nla_put_failure;
>>   +	if (nla_put_s32(skb, IFLA_BOND_SLAVE_PRIO, slave->prio))
>> +		goto nla_put_failure;
>> +
>>   	if (BOND_MODE(slave->bond) =3D=3D BOND_MODE_8023AD) {
>>   		const struct aggregator *agg;
>>   		const struct port *ad_port;
>> @@ -117,6 +121,7 @@ static const struct nla_policy bond_policy[IFLA_BON=
D_MAX + 1] =3D {
>>     static const struct nla_policy bond_slave_policy[IFLA_BOND_SLAVE_MA=
X
>> + 1] =3D {
>>   	[IFLA_BOND_SLAVE_QUEUE_ID]	=3D { .type =3D NLA_U16 },
>> +	[IFLA_BOND_SLAVE_PRIO]		=3D { .type =3D NLA_S32 },
>>   };
>>     static int bond_validate(struct nlattr *tb[], struct nlattr *data[]=
,
>> @@ -136,6 +141,7 @@ static int bond_slave_changelink(struct net_device =
*bond_dev,
>>   				 struct nlattr *tb[], struct nlattr *data[],
>>   				 struct netlink_ext_ack *extack)
>>   {
>> +	struct slave *slave =3D bond_slave_get_rtnl(slave_dev);
>>   	struct bonding *bond =3D netdev_priv(bond_dev);
>>   	struct bond_opt_value newval;
>>   	int err;
>> @@ -156,6 +162,12 @@ static int bond_slave_changelink(struct net_device=
 *bond_dev,
>>   			return err;
>>   	}
>>   +	/* No need to bother __bond_opt_set as we only support netlink
>> config */
>
>Not sure this comment is necessary, it doesn't add any value. Also I woul=
d
>recommend using bonding's options management, as it would allow for
>checking if the value is in a defined range. That might not be
>particularly useful in this context since it appears +/-INT_MAX is the
>range.

	Agreed, on both the comment and in regards to using the extant
bonding options management stuff.

>Also, in the Documentation it is mentioned that this parameter is only
>used in modes active-backup and balance-alb/tlb. Do we need to send an
>error message back preventing the modification of this value when not in
>these modes?

	Using the option management stuff would get this for free.

	-J

>> +	if (data[IFLA_BOND_SLAVE_PRIO]) {
>> +		slave->prio =3D nla_get_s32(data[IFLA_BOND_SLAVE_PRIO]);
>> +		bond_select_active_slave(bond);
>> +	}
>> +
>>   	return 0;
>>   }
>>   diff --git a/include/net/bonding.h b/include/net/bonding.h
>> index b14f4c0b4e9e..4ff093fb2289 100644
>> --- a/include/net/bonding.h
>> +++ b/include/net/bonding.h
>> @@ -176,6 +176,7 @@ struct slave {
>>   	u32    speed;
>>   	u16    queue_id;
>>   	u8     perm_hwaddr[MAX_ADDR_LEN];
>> +	int    prio;
>
>Do we want a struct slave_params here instead? That would allow us to
>define defaults in a central place and set them once instead of setting
>each parameter.

	Presuming that you mean creating a sub-struct here and moving
some set of members of struct slave into it, I'm not sure I see the
benefit, as it would only exist here and not really be an independent
object.  Am I misunderstanding?

	-J

>>   	struct ad_slave_info *ad_info;
>>   	struct tlb_slave_info tlb_info;
>>   #ifdef CONFIG_NET_POLL_CONTROLLER
>> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.=
h
>> index cc284c048e69..204e342b107a 100644
>> --- a/include/uapi/linux/if_link.h
>> +++ b/include/uapi/linux/if_link.h
>> @@ -956,6 +956,7 @@ enum {
>>   	IFLA_BOND_SLAVE_AD_AGGREGATOR_ID,
>>   	IFLA_BOND_SLAVE_AD_ACTOR_OPER_PORT_STATE,
>>   	IFLA_BOND_SLAVE_AD_PARTNER_OPER_PORT_STATE,
>> +	IFLA_BOND_SLAVE_PRIO,
>>   	__IFLA_BOND_SLAVE_MAX,
>>   };
>>   diff --git a/tools/include/uapi/linux/if_link.h
>> b/tools/include/uapi/linux/if_link.h
>> index e1ba2d51b717..ee5de9f3700b 100644
>> --- a/tools/include/uapi/linux/if_link.h
>> +++ b/tools/include/uapi/linux/if_link.h
>> @@ -888,6 +888,7 @@ enum {
>>   	IFLA_BOND_SLAVE_AD_AGGREGATOR_ID,
>>   	IFLA_BOND_SLAVE_AD_ACTOR_OPER_PORT_STATE,
>>   	IFLA_BOND_SLAVE_AD_PARTNER_OPER_PORT_STATE,
>> +	IFLA_BOND_SLAVE_PRIO,
>>   	__IFLA_BOND_SLAVE_MAX,
>>   };
>>   =


---
	-Jay Vosburgh, jay.vosburgh@canonical.com
