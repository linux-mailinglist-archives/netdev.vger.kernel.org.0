Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27111687803
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 09:57:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232056AbjBBI5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 03:57:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231371AbjBBI5L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 03:57:11 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A744D14EB8
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 00:57:10 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id ml19so4122280ejb.0
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 00:57:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JUUjEFx3Nk/775g2gSfW9ymadFWHIooRW2ZkQPyxtlc=;
        b=cB5KPcXPZTKe4+Ra9C+fiK1YlpRE9AKHeXyKkRJvgLS2OON6Wn7yQbf1MTUjbLI8wO
         QN4r9b7h0eCbu28FI7Tcel2LJBGKMtDMteqxGHo0aNd+hEUiaDKYptcj4ohWbDX6phom
         gtMQ/ijTcSxcHDNM7UufwBAIAjD54uS+E+AzU7zaZ9EFOcgZu2w8qavBonZ7f8HC/W+/
         2PvHReMcjio4c333/wEO8qxLbRGUP/pOX6Z6r8F9jzG6az763Wz0OG796UbxB9eifR/o
         /ICCN9tVaHy6DhMNLQcPgvJlIE7sNqZ+fErHLFZmE7BO8BTrDMeH/J48ybRUCij7rEOg
         oilg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JUUjEFx3Nk/775g2gSfW9ymadFWHIooRW2ZkQPyxtlc=;
        b=ixhK2bEHX1v241cksJvWoEAaTK9KN5kQmPm1T8mGRgtbzqWup3TaXnC8KZEZ45iMKi
         1mkyb20HrfwIBs/c6tdVe8O0Fv/mMo1vvE35Dc/9hGKBQ6rnU7DyXfHCJ3V4dvUFaNUO
         cv9SJk8LtcdLwtevJa++um1N9RR9lCaGqIMRen8ydNQbVqQ6M0E03iSerTOU4isX9CH6
         poLH3WSl34Fi5Laaei56wazwKvNjX0exwOC236si/QJEPeKF7LOSeSIEl2l8gdj1bNSR
         pDmjc05OEEi3r1Kl7iAX3ccCmWcQW6CAQwI4xD2CuNtxlkBv6WkwFFdtXlg6xTVpgRyb
         xn+g==
X-Gm-Message-State: AO0yUKWTJ7Kdiw+E+ADCElZDtBPGOmfM4cAozXAjhdQs6lf8FFmb9vYG
        k37X5IuAGX4xz40SjUFCtvJ9hQ==
X-Google-Smtp-Source: AK7set/s/XG/c0nKO/wtgmqiavTZHIqJoWacqkdckDM1rhYEzfP3xmti0IGuzQSKMcLMrGMdRMUyZQ==
X-Received: by 2002:a17:907:362:b0:883:3299:91c8 with SMTP id rs2-20020a170907036200b00883329991c8mr5316264ejb.55.1675328229149;
        Thu, 02 Feb 2023 00:57:09 -0800 (PST)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id z16-20020a170906435000b007b935641971sm11217453ejm.5.2023.02.02.00.57.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Feb 2023 00:57:08 -0800 (PST)
Message-ID: <9ed8f5c0-ef73-3e12-a822-b0153f5237bb@blackwall.org>
Date:   Thu, 2 Feb 2023 10:57:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH net-next mlxsw v2 07/16] net: bridge: Maintain number of
 MDB entries in net_bridge_mcast_port
Content-Language: en-US
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>, netdev@vger.kernel.org
Cc:     bridge@lists.linux-foundation.org, Ido Schimmel <idosch@nvidia.com>
References: <cover.1675271084.git.petrm@nvidia.com>
 <706d902460b69454ffeb57908beb8dce46e9b064.1675271084.git.petrm@nvidia.com>
 <18e82e5a-1ee9-94ee-78a7-15bc08b62978@blackwall.org>
In-Reply-To: <18e82e5a-1ee9-94ee-78a7-15bc08b62978@blackwall.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/02/2023 10:56, Nikolay Aleksandrov wrote:
> On 01/02/2023 19:28, Petr Machata wrote:
>> The MDB maintained by the bridge is limited. When the bridge is configured
>> for IGMP / MLD snooping, a buggy or malicious client can easily exhaust its
>> capacity. In SW datapath, the capacity is configurable through the
>> IFLA_BR_MCAST_HASH_MAX parameter, but ultimately is finite. Obviously a
>> similar limit exists in the HW datapath for purposes of offloading.
>>
>> In order to prevent the issue of unilateral exhaustion of MDB resources,
>> introduce two parameters in each of two contexts:
>>
>> - Per-port and per-port-VLAN number of MDB entries that the port
>>   is member in.
>>
>> - Per-port and (when BROPT_MCAST_VLAN_SNOOPING_ENABLED is enabled)
>>   per-port-VLAN maximum permitted number of MDB entries, or 0 for
>>   no limit.
>>
>> The per-port multicast context is used for tracking of MDB entries for the
>> port as a whole. This is available for all bridges.
>>
>> The per-port-VLAN multicast context is then only available on
>> VLAN-filtering bridges on VLANs that have multicast snooping on.
>>
>> With these changes in place, it will be possible to configure MDB limit for
>> bridge as a whole, or any one port as a whole, or any single port-VLAN.
>>
>> Note that unlike the global limit, exhaustion of the per-port and
>> per-port-VLAN maximums does not cause disablement of multicast snooping.
>> It is also permitted to configure the local limit larger than hash_max,
>> even though that is not useful.
>>
>> In this patch, introduce only the accounting for number of entries, and the
>> max field itself, but not the means to toggle the max. The next patch
>> introduces the netlink APIs to toggle and read the values.
>>
>> Signed-off-by: Petr Machata <petrm@nvidia.com>
>> ---
>>
>> Notes:
>>     v2:
>>     - In br_multicast_port_ngroups_inc_one(), bounce
>>       if n>=max, not if n==max
>>     - Adjust extack messages to mention ngroups, now that
>>       the bounces appear when n>=max, not n==max
>>     - In __br_multicast_enable_port_ctx(), do not reset
>>       max to 0. Also do not count number of entries by
>>       going through _inc, as that would end up incorrectly
>>       bouncing the entries.
>>
>>  net/bridge/br_multicast.c | 132 +++++++++++++++++++++++++++++++++++++-
>>  net/bridge/br_private.h   |   2 +
>>  2 files changed, 133 insertions(+), 1 deletion(-)
>>
>> diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
>> index 51b622afdb67..e7ae339a8757 100644
>> --- a/net/bridge/br_multicast.c
>> +++ b/net/bridge/br_multicast.c
>> @@ -31,6 +31,7 @@
>>  #include <net/ip6_checksum.h>
>>  #include <net/addrconf.h>
>>  #endif
>> +#include <trace/events/bridge.h>
>>  
>>  #include "br_private.h"
>>  #include "br_private_mcast_eht.h"
>> @@ -234,6 +235,29 @@ br_multicast_pg_to_port_ctx(const struct net_bridge_port_group *pg)
>>  	return pmctx;
>>  }
>>  
>> +static struct net_bridge_mcast_port *
>> +br_multicast_port_vid_to_port_ctx(struct net_bridge_port *port, u16 vid)
>> +{
>> +	struct net_bridge_mcast_port *pmctx = NULL;
>> +	struct net_bridge_vlan *vlan;
>> +
>> +	lockdep_assert_held_once(&port->br->multicast_lock);
>> +
>> +	if (!br_opt_get(port->br, BROPT_MCAST_VLAN_SNOOPING_ENABLED))
>> +		return NULL;
>> +
>> +	/* Take RCU to access the vlan. */
>> +	rcu_read_lock();
>> +
>> +	vlan = br_vlan_find(nbp_vlan_group_rcu(port), vid);
>> +	if (vlan && !br_multicast_port_ctx_vlan_disabled(&vlan->port_mcast_ctx))
>> +		pmctx = &vlan->port_mcast_ctx;
>> +
>> +	rcu_read_unlock();
>> +
>> +	return pmctx;
>> +}
>> +
>>  /* when snooping we need to check if the contexts should be used
>>   * in the following order:
>>   * - if pmctx is non-NULL (port), check if it should be used
>> @@ -668,6 +692,82 @@ void br_multicast_del_group_src(struct net_bridge_group_src *src,
>>  	__br_multicast_del_group_src(src);
>>  }
>>  
>> +static int
>> +br_multicast_port_ngroups_inc_one(struct net_bridge_mcast_port *pmctx,
>> +				  struct netlink_ext_ack *extack)
>> +{
>> +	if (pmctx->mdb_max_entries &&
>> +	    pmctx->mdb_n_entries >= pmctx->mdb_max_entries)
> 
> These should be using *_ONCE() because of the next patch.
> KCSAN might be sad otherwise. :)
> 
>> +		return -E2BIG;
>> +
>> +	pmctx->mdb_n_entries++;
> 
> WRITE_ONCE()
> 
>> +	return 0;
>> +}
>> +
>> +static void br_multicast_port_ngroups_dec_one(struct net_bridge_mcast_port *pmctx)
>> +{
>> +	WARN_ON_ONCE(pmctx->mdb_n_entries-- == 0);
> 
> READ_ONCE()

err, I meant WRITE_ONCE() of course. :)
Need to get coffee.

> 
>> +}
>> +

