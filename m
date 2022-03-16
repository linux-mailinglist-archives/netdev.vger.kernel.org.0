Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C54554DAD4A
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 10:15:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354814AbiCPJQh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 05:16:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354802AbiCPJQg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 05:16:36 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6DDD5DE73
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 02:15:21 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id c15so2219079ljr.9
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 02:15:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=Y0ggJ9V38cE1b6AbUVeGyXnI9Fgl1hR/3Vx8sEEmZeo=;
        b=kCnKg4MIsOoya9TXhoPOk1grh79P74LsBE9ARzsWX9dqD6Xc4MwHcG/q+gXUdM5q8c
         lu4ocMfkObZK/AaB08efYQuvWYSm4f1Hpe+y+HI15FrLQV6qRBuK3daxp6giD9z74GQz
         fTm7w3TV+MehDK8HZwZziLrrgkqPd0Tic8iC+9cAy9It5hvPlIdY28Zu8UUvETekYoEu
         6Q8fbtrAwGWTMpV+MHDSUPHzPeM3rR1lNhG8qnn1toEzvxO8w+rb0PiKbYxlA8AB6ZxZ
         pBK3+4rthtEjx2XQmQnCFY1F4HAVLMjADxKIa2p1TLoqdBtqpUUMoqJ9BGonXYaw/Pmq
         BIiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Y0ggJ9V38cE1b6AbUVeGyXnI9Fgl1hR/3Vx8sEEmZeo=;
        b=MYoCUpJmskeshPuHfxXgOghdY4b67uYzGkJgJSib6XGrSIM8EFBsaWjmVZ/40iHZo2
         Nu1IsSHV0FK+sldatOqJZghceQLo9lxjyf4uLn102cMHZPHMWsgjUWBiu1RNCOs115Tw
         Ntz4vKqXJe0BdHH6vzqSjn5azNv1E5H2DyVO2J7jmQ+gbrk9flbOEhbrfkBvzWo23Dux
         olvtkGyzIikdoY8Vtb5j4b0b5js13QS7pLVGVEmIJGxOV10R2eMIrtZgbE4/gr3FcwvG
         uOXsJUXKTk2zaZpdkI78ij5ep0IhA+M4nnL66a9tYfWGrFuj6fnTvrG/kf0U6sTd+X9R
         5KOA==
X-Gm-Message-State: AOAM530FGGirT0dWFffEPVunkW0AJ3EC/NbFNamM9ZduIdQ077bQa1a1
        pOzpGM8NN5nGXtzXHRMGVsPArQ==
X-Google-Smtp-Source: ABdhPJw/j+Y/gmbpqw53HNbc2McDPUaBydnhTgSl5g+M78LmqUd3Ub4GwLiNCc7rZkHT+IFp2mnEvQ==
X-Received: by 2002:a2e:aa10:0:b0:248:33d:3569 with SMTP id bf16-20020a2eaa10000000b00248033d3569mr19694635ljb.107.1647422119907;
        Wed, 16 Mar 2022 02:15:19 -0700 (PDT)
Received: from wkz-x280 (a124.broadband3.quicknet.se. [46.17.184.124])
        by smtp.gmail.com with ESMTPSA id j15-20020a196e0f000000b0044827945789sm128014lfc.155.2022.03.16.02.15.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 02:15:19 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Russell King <linux@armlinux.org.uk>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        Cooper Lees <me@cooperlees.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: Re: [PATCH v4 net-next 10/15] net: dsa: Validate hardware support
 for MST
In-Reply-To: <20220315171108.ameddbqv2sehq3pp@skbuf>
References: <20220315002543.190587-1-tobias@waldekranz.com>
 <20220315002543.190587-11-tobias@waldekranz.com>
 <20220315171108.ameddbqv2sehq3pp@skbuf>
Date:   Wed, 16 Mar 2022 10:15:18 +0100
Message-ID: <8735jil0m1.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 15, 2022 at 19:11, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Tue, Mar 15, 2022 at 01:25:38AM +0100, Tobias Waldekranz wrote:
>> When joining a bridge where MST is enabled, we validate that the
>> proper offloading support is in place, otherwise we fallback to
>> software bridging.
>> 
>> When then mode is changed on a bridge in which we are members, we
>> refuse the change if offloading is not supported.
>> 
>> At the moment we only check for configurable learning, but this will
>> be further restricted as we support more MST related switchdev events.
>> 
>> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
>> ---
>>  net/dsa/dsa_priv.h |  2 ++
>>  net/dsa/port.c     | 22 ++++++++++++++++++++++
>>  net/dsa/slave.c    |  6 ++++++
>>  3 files changed, 30 insertions(+)
>> 
>> diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
>> index f20bdd8ea0a8..2aba420696ef 100644
>> --- a/net/dsa/dsa_priv.h
>> +++ b/net/dsa/dsa_priv.h
>> @@ -234,6 +234,8 @@ int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering,
>>  			    struct netlink_ext_ack *extack);
>>  bool dsa_port_skip_vlan_configuration(struct dsa_port *dp);
>>  int dsa_port_ageing_time(struct dsa_port *dp, clock_t ageing_clock);
>> +int dsa_port_mst_enable(struct dsa_port *dp, bool on,
>> +			struct netlink_ext_ack *extack);
>>  int dsa_port_mtu_change(struct dsa_port *dp, int new_mtu,
>>  			bool targeted_match);
>>  int dsa_port_fdb_add(struct dsa_port *dp, const unsigned char *addr,
>> diff --git a/net/dsa/port.c b/net/dsa/port.c
>> index 58291df14cdb..02214033cec0 100644
>> --- a/net/dsa/port.c
>> +++ b/net/dsa/port.c
>> @@ -321,6 +321,11 @@ static void dsa_port_bridge_destroy(struct dsa_port *dp,
>>  	kfree(bridge);
>>  }
>>  
>> +static bool dsa_port_supports_mst(struct dsa_port *dp)
>> +{
>> +	return dsa_port_can_configure_learning(dp);
>> +}
>> +
>>  int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
>>  			 struct netlink_ext_ack *extack)
>>  {
>> @@ -334,6 +339,9 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
>>  	struct net_device *brport_dev;
>>  	int err;
>>  
>> +	if (br_mst_enabled(br) && !dsa_port_supports_mst(dp))
>> +		return -EOPNOTSUPP;
>> +
>>  	/* Here the interface is already bridged. Reflect the current
>>  	 * configuration so that drivers can program their chips accordingly.
>>  	 */
>> @@ -735,6 +743,20 @@ int dsa_port_ageing_time(struct dsa_port *dp, clock_t ageing_clock)
>>  	return 0;
>>  }
>>  
>> +int dsa_port_mst_enable(struct dsa_port *dp, bool on,
>> +			struct netlink_ext_ack *extack)
>> +{
>> +	if (!on)
>> +		return 0;
>> +
>> +	if (!dsa_port_supports_mst(dp)) {
>> +		NL_SET_ERR_MSG_MOD(extack, "Hardware does not support MST");
>> +		return -EINVAL;
>> +	}
>> +
>> +	return 0;
>> +}
>
> Experimenting a bit... maybe this looks tidier? We make the "if" condition
> have the same basic structure as the previous "if (br_mst_enabled(br) &&
> !dsa_port_supports_mst(dp))", albeit transformed using De Morgan's rules.
>
> {
> 	if (!on || dsa_port_supports_mst(dp))
> 		return 0;
>
> 	NL_SET_ERR_MSG_MOD(extack, "Hardware does not support MST");
> 	return -EINVAL;
> }

I initially had it like this. It looks tidier, yes - but to me the
intent is less obvious when reading it. How about:

{
	if (on && !dsa_port_supports_mst(dp)) {
		NL_SET_ERR_MSG_MOD(extack, "Hardware does not support MST");
		return -EINVAL;
	}

	return 0;
}

>> +
>>  int dsa_port_pre_bridge_flags(const struct dsa_port *dp,
>>  			      struct switchdev_brport_flags flags,
>>  			      struct netlink_ext_ack *extack)
>> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
>> index 647adee97f7f..879d18cc99cb 100644
>> --- a/net/dsa/slave.c
>> +++ b/net/dsa/slave.c
>> @@ -463,6 +463,12 @@ static int dsa_slave_port_attr_set(struct net_device *dev, const void *ctx,
>>  
>>  		ret = dsa_port_ageing_time(dp, attr->u.ageing_time);
>>  		break;
>> +	case SWITCHDEV_ATTR_ID_BRIDGE_MST:
>> +		if (!dsa_port_offloads_bridge_dev(dp, attr->orig_dev))
>> +			return -EOPNOTSUPP;
>> +
>> +		ret = dsa_port_mst_enable(dp, attr->u.mst, extack);
>> +		break;
>>  	case SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS:
>>  		if (!dsa_port_offloads_bridge_port(dp, attr->orig_dev))
>>  			return -EOPNOTSUPP;
>> -- 
>> 2.25.1
>> 
