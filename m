Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 338064DC400
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 11:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232594AbiCQKde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 06:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232580AbiCQKde (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 06:33:34 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAD321B7B4
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 03:32:17 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id r23so6043965edb.0
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 03:32:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=sKo8r6HTcCUjNi/eOi2uCOAgAR1NjGdO0mNl0PJTmOo=;
        b=PFGcXE0jVVkPxP0qtBZHZLqvDuxC7OM25DdhOpAjo1yEs1eKZ8ZzJOUeOPupTAIPFJ
         ql/FdvGVCg/2RsVnal83QI/pWG7goXkWo8j7okH6Nofzm6Y77dEX1gufeaK4N7sZZmmo
         rBqHDgeBWpGCb9GH9I5YlOAHiWFkFgyFRqBC9qYOsKNh4BMyTXjShvmdxM08aL4T8IVe
         fxwovJ3/0Tnl0tiBA7Ssb3Yo0/pNTk79HtVfWg4v7psKNi62RIaQPbvodHpyXnk/tAxg
         a5J4xximP+TMiuqVaL51WbSk03utYMBxfWKfXtrbtoNy4D5XRwfnsL+IHBvHboJOonPz
         NkXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=sKo8r6HTcCUjNi/eOi2uCOAgAR1NjGdO0mNl0PJTmOo=;
        b=pV1y6w/ASZo4vDuRaUUpp25XYhl3mPCuCXU0BdyC0jlHA7Bvg0jKzOrTslPgj1YNmI
         KStASi2/lTKELQeqNNYkrz5vD0ouF6p3GkEUMzZJ0tv8hmDPvLKCcS5/Qvuh6yJhSohw
         BIUuEH7kls1f1Ggm2AWVES8lywdomJDTbRrgVkhgHOyIOLy6O0dgAmhC9xtf5RP4ijqk
         JW9vtzPnARaMZkbbRYeKBHliT8C34qnwTKmG5/pHeKHptflcz8iuU2WRjjJDBdn2OzCI
         999SGXTL4ZIjBIvVv8w4FuKOa7nAFcldmyNqrlKBmfZBXdFsuWI++qehjTSxoQ+99vFj
         KE4w==
X-Gm-Message-State: AOAM532E5sEKCYO+MQLPAVZyeYavh9NXSB2uHeiHb5tptAmvq5sSz43l
        srM07P2yqcoUNRfKMoFeESgeMg==
X-Google-Smtp-Source: ABdhPJyf61ziGji5ZFm0GxDHj6WhYi7D/YM3H8xsLbrIdTiDZXI6knLa9DwiIwbfOWOmlktCLl8HLA==
X-Received: by 2002:a05:6402:84b:b0:419:b5:70b2 with SMTP id b11-20020a056402084b00b0041900b570b2mr597553edz.162.1647513136460;
        Thu, 17 Mar 2022 03:32:16 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id l2-20020a1709060cc200b006d3d91e88c7sm2147524ejh.214.2022.03.17.03.32.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Mar 2022 03:32:16 -0700 (PDT)
Message-ID: <9386184c-5925-aca4-e9f6-42cc56077c8d@blackwall.org>
Date:   Thu, 17 Mar 2022 12:32:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 2/5] net: bridge: Implement bridge flood flag
Content-Language: en-US
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>,
        netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Joachim Wiberg <troglobit@gmail.com>
References: <20220317065031.3830481-1-mattias.forsblad@gmail.com>
 <20220317065031.3830481-3-mattias.forsblad@gmail.com>
 <f2104e0e-45f2-1fe6-5cf9-ef3fa0f1475d@blackwall.org>
In-Reply-To: <f2104e0e-45f2-1fe6-5cf9-ef3fa0f1475d@blackwall.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/03/2022 12:11, Nikolay Aleksandrov wrote:
> On 17/03/2022 08:50, Mattias Forsblad wrote:
>> This patch implements the bridge flood flags. There are three different
>> flags matching unicast, multicast and broadcast. When the corresponding
>> flag is cleared packets received on bridge ports will not be flooded
>> towards the bridge.
>> This makes is possible to only forward selected traffic between the
>> port members of the bridge.
>>
>> Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>
>> ---
>>  include/linux/if_bridge.h      |  6 +++++
>>  include/uapi/linux/if_bridge.h |  9 ++++++-
>>  net/bridge/br.c                | 45 ++++++++++++++++++++++++++++++++++
>>  net/bridge/br_device.c         |  3 +++
>>  net/bridge/br_input.c          | 23 ++++++++++++++---
>>  net/bridge/br_private.h        |  4 +++
>>  6 files changed, 85 insertions(+), 5 deletions(-)
>>
> Please always CC bridge maintainers for bridge patches.
> 
> I almost missed this one. I'll add my reply to Joachim's notes
> which are pretty spot on.
> 
>> diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
>> index 3aae023a9353..fa8e000a6fb9 100644
>> --- a/include/linux/if_bridge.h
>> +++ b/include/linux/if_bridge.h
>> @@ -157,6 +157,7 @@ static inline int br_vlan_get_info_rcu(const struct net_device *dev, u16 vid,
>>  struct net_device *br_fdb_find_port(const struct net_device *br_dev,
>>  				    const unsigned char *addr,
>>  				    __u16 vid);
>> +bool br_flood_enabled(const struct net_device *dev);
>>  void br_fdb_clear_offload(const struct net_device *dev, u16 vid);
>>  bool br_port_flag_is_set(const struct net_device *dev, unsigned long flag);
>>  u8 br_port_get_stp_state(const struct net_device *dev);
>> @@ -170,6 +171,11 @@ br_fdb_find_port(const struct net_device *br_dev,
>>  	return NULL;
>>  }
>>  
>> +static inline bool br_flood_enabled(const struct net_device *dev)
>> +{
>> +	return true;
>> +}
>> +
>>  static inline void br_fdb_clear_offload(const struct net_device *dev, u16 vid)
>>  {
>>  }
>> diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
>> index 2711c3522010..765ed70c9b28 100644
>> --- a/include/uapi/linux/if_bridge.h
>> +++ b/include/uapi/linux/if_bridge.h
>> @@ -72,6 +72,7 @@ struct __bridge_info {
>>  	__u32 tcn_timer_value;
>>  	__u32 topology_change_timer_value;
>>  	__u32 gc_timer_value;
>> +	__u8 flood;
>>  };

Replying to myself as this part was snipped from Joachim's comments.
You cannot change uapi structures.

