Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 071AE4D321E
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 16:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233994AbiCIPsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 10:48:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234000AbiCIPsH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 10:48:07 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54CE817EDA7
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 07:47:07 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id o6so3748425ljp.3
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 07:47:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=hE+S/0AbaM2pPcNCMSw4Jzqj4RQmx4E5rMxUDwkwLVU=;
        b=laFC8gg+0MeWXFJEZV67/eLluhTcckbRqcldkSukV2V4XmAwYaFkLQjBdndAn5ZP0z
         mhC5v9D7OHl09L7LsjRRnYjfzlC2uZYBm8r2wLkackJwepfp1ji5jUdBgGFB7Xl1Iiim
         vDywbsAA1eY3CPdJe4gJYtx/9yVK2rSlwXTiM2lSaT+G+jyMMS9SRdR0APkgwzhYqOgi
         CxmkzfsC9VOSf90x7xvDq6sEC0EO6XkbIcdFlQhS1VFkYH1Nip4IAGGcuai3L78Ect2V
         eAxeu2xkRnfX7sJJUwoWU+N8mtHan/aHTMlgeCvECz6/4TZUHCC+Py1EEOx+/5csKhoU
         Fidg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=hE+S/0AbaM2pPcNCMSw4Jzqj4RQmx4E5rMxUDwkwLVU=;
        b=TZztJO5gHULFZ21WzEEPTF90RL34yd5Y3oTP77yjbceJgYg7ddSWKDYmgHoToWp9RI
         S3maAaEycc/qeseOORrbtcQ2wEwp9cbzNaIFxstwuQh5xfpHTmYFZqiyylncxcdsD5Mu
         QaFpyGDgHX85CrkEBvbmVZcc/AxZyZhOlBGmcptojKN2NFDWkzOzTc7CLGyBB7YF0iR6
         OAhvMOZGQ7ysz7bqvX5qTAYf3BjMaOE4j/15z9IpjPEvOGhUMbiu9lWkhiwVfyx+K82W
         V9yvyvnEX0qkjQbmtUf9IVbJ0Egget/KF0bFfrY7JFbu2RCMfiuYBXccbmWsgiPpM/AY
         TLrg==
X-Gm-Message-State: AOAM530MKiJGbEit1JkN0EoY4OgS/rGHvGsscE0onXiQ6fl6AOJO+iqZ
        6ZD8rp+yW9PzqUXengQZWh2Mwg==
X-Google-Smtp-Source: ABdhPJyCKiyHoWMiJliNGv/4VA6yAV57wz5RNHLmQ0sm2hKI0o/my/XlW0qWYefrT775v/KuLp8rig==
X-Received: by 2002:a2e:90ca:0:b0:246:48ce:ba0e with SMTP id o10-20020a2e90ca000000b0024648ceba0emr31858ljg.401.1646840823568;
        Wed, 09 Mar 2022 07:47:03 -0800 (PST)
Received: from wkz-x280 (a124.broadband3.quicknet.se. [46.17.184.124])
        by smtp.gmail.com with ESMTPSA id u12-20020a056512128c00b00446499f855dsm455715lfs.78.2022.03.09.07.47.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 07:47:03 -0800 (PST)
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
        Cooper Lees <me@cooperlees.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH v2 net-next 06/10] net: dsa: Pass VLAN MSTI migration
 notifications to driver
In-Reply-To: <20220303222942.dkz7bfuagkv7hbpp@skbuf>
References: <20220301100321.951175-1-tobias@waldekranz.com>
 <20220301100321.951175-7-tobias@waldekranz.com>
 <20220303222942.dkz7bfuagkv7hbpp@skbuf>
Date:   Wed, 09 Mar 2022 16:47:02 +0100
Message-ID: <87pmmvm8ll.fsf@waldekranz.com>
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

On Fri, Mar 04, 2022 at 00:29, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Tue, Mar 01, 2022 at 11:03:17AM +0100, Tobias Waldekranz wrote:
>> Add the usual trampoline functionality from the generic DSA layer down
>> to the drivers for VLAN MSTI migrations.
>> 
>> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
>> ---
>>  include/net/dsa.h  |  3 +++
>>  net/dsa/dsa_priv.h |  1 +
>>  net/dsa/port.c     | 10 ++++++++++
>>  net/dsa/slave.c    |  6 ++++++
>>  4 files changed, 20 insertions(+)
>> 
>> diff --git a/include/net/dsa.h b/include/net/dsa.h
>> index cfedcfb86350..cc8acb01bd9b 100644
>> --- a/include/net/dsa.h
>> +++ b/include/net/dsa.h
>> @@ -962,6 +962,9 @@ struct dsa_switch_ops {
>>  				 struct netlink_ext_ack *extack);
>>  	int	(*port_vlan_del)(struct dsa_switch *ds, int port,
>>  				 const struct switchdev_obj_port_vlan *vlan);
>> +	int	(*vlan_msti_set)(struct dsa_switch *ds,
>> +				 const struct switchdev_attr *attr);
>
> I would rather pass the struct switchdev_vlan_attr and the orig_dev
> (bridge) as separate arguments here. Or even the struct dsa_bridge, for
> consistency to the API changes for database isolation.

Fair point. I'll change.

>> +
>>  	/*
>>  	 * Forwarding database
>>  	 */
>> diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
>> index 07c0ad52395a..87ec0697e92e 100644
>> --- a/net/dsa/dsa_priv.h
>> +++ b/net/dsa/dsa_priv.h
>> @@ -217,6 +217,7 @@ int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering,
>>  			    struct netlink_ext_ack *extack);
>>  bool dsa_port_skip_vlan_configuration(struct dsa_port *dp);
>>  int dsa_port_ageing_time(struct dsa_port *dp, clock_t ageing_clock);
>> +int dsa_port_vlan_msti(struct dsa_port *dp, const struct switchdev_attr *attr);
>>  int dsa_port_mtu_change(struct dsa_port *dp, int new_mtu,
>>  			bool targeted_match);
>>  int dsa_port_fdb_add(struct dsa_port *dp, const unsigned char *addr,
>> diff --git a/net/dsa/port.c b/net/dsa/port.c
>> index d9da425a17fb..5f45cb7d70ba 100644
>> --- a/net/dsa/port.c
>> +++ b/net/dsa/port.c
>> @@ -778,6 +778,16 @@ int dsa_port_bridge_flags(struct dsa_port *dp,
>>  	return 0;
>>  }
>>  
>> +int dsa_port_vlan_msti(struct dsa_port *dp, const struct switchdev_attr *attr)
>> +{
>> +	struct dsa_switch *ds = dp->ds;
>> +
>> +	if (!ds->ops->vlan_msti_set)
>> +		return -EOPNOTSUPP;
>> +
>> +	return ds->ops->vlan_msti_set(ds, attr);
>
> I guess this doesn't need to be a cross-chip notifier event for all
> switches, because replication to all bridge ports is handled by
> switchdev_handle_port_attr_set(). Ok. But isn't it called too many times
> per switch?

It is certainly called more times than necessary. But I'm not aware of
any way to limit it. Just as with other bridge-global settings like
ageing timeout, the bridge will just replicate the event to each port,
not knowing whether some of them belong to the same underlying ASIC or
not.

We could leverage hwdoms in the bridge to figure that out, but then:

- Drivers that do not implement forward offloading would miss out on
  this optimization. Unfortunate but not a big deal.

- Since DSA presents multi-chip trees as a single switchdev, the DSA
  layer would have to replicate the event out to each device. Doable,
  but feels like a series of its own.

>> +}
>> +
>>  int dsa_port_mtu_change(struct dsa_port *dp, int new_mtu,
>>  			bool targeted_match)
>>  {
>> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
>> index 089616206b11..c6ffcd782b5a 100644
>> --- a/net/dsa/slave.c
>> +++ b/net/dsa/slave.c
>> @@ -314,6 +314,12 @@ static int dsa_slave_port_attr_set(struct net_device *dev, const void *ctx,
>>  
>>  		ret = dsa_port_bridge_flags(dp, attr->u.brport_flags, extack);
>>  		break;
>> +	case SWITCHDEV_ATTR_ID_VLAN_MSTI:
>> +		if (!dsa_port_offloads_bridge_dev(dp, attr->orig_dev))
>> +			return -EOPNOTSUPP;
>> +
>> +		ret = dsa_port_vlan_msti(dp, attr);
>> +		break;
>>  	default:
>>  		ret = -EOPNOTSUPP;
>>  		break;
>> -- 
>> 2.25.1
>> 
