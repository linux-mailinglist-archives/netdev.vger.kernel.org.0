Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D7721B1300
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 19:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbgDTR3T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 13:29:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725774AbgDTR3T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 13:29:19 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F0C0C061A0C;
        Mon, 20 Apr 2020 10:29:19 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id j4so11487152qkc.11;
        Mon, 20 Apr 2020 10:29:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Vq8/mG/0NTMC+GWRfgwaZ9CicThHR8b18Gos20H/OCI=;
        b=JLUlTz7ucNninrUoHI9Nk1wLF7R8zDm5vtysTzcYn6WE8S8uRFmDPaCEYajcqHexpz
         KvYq+OEQ8nX7PHZFurF7zZEgvtP/hc+JHWeOrFxk+8Xec2qf0czukOlEnu8xxj65GD8L
         YwxvuJ+xLxiYRjONFox8Su/gKTLbLBZs41nib5w3A1EETBBC4O6J5OVUtuiKIIkoFTOe
         sC5fki9DZtt/AwG9yUz8k4xsJduHbJRRvjAU6hBbxzTgd34SEkUPcXVEqgQCfaVECCsl
         dGqMo88EF8QqKkA4wAf7DeFXxO48cQwKT1+EVMd8o4n4+jPORvExlmV7BdHaPWQkYUvI
         5+dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Vq8/mG/0NTMC+GWRfgwaZ9CicThHR8b18Gos20H/OCI=;
        b=jWrIpwuhSHDXtGv/HaGRMPIzwzXy03SpV8UVKDNhGyYcWjwUsAQvLbmdgbWZl9fjkP
         kQ/WS62cTSrDegmFvKWcrur+ZH+MAxXkI+OkDZGLZB2n6fWyWiyzYHr69gN02D61/Vd1
         AaS64TP+zHdye1DsTI/FEkwKhIAI8fItoHIdeFyX7vaCeg63KZNUZx59SPnliqIuaMWQ
         TNS5P0+XHJ8Zdhz7s9s4jEocdIwtkAE1gGMjUiyQ54neE8zxzPpvsDZ7Y2Uz6dcNEreG
         ZqC4RxxJ3y2JZNFxBt4w0WuRhpw1aTcELCH/eikd12PFMQiQ6nJoQ4ibBXruJPvr7BGx
         MmbQ==
X-Gm-Message-State: AGi0PuY4gPVd5naarewGrzzVgkrzL4J/9aV4CF0dFisBgBk9N/tQkMmg
        8/OOflqooAFn7Ey6vX7zctg=
X-Google-Smtp-Source: APiQypKW29NctZAiE1u2v5LWwnt3O12q0ClWkByA4TJ/nW4i6LyBcFbUM118S6HTsTnmT49/jHcjcg==
X-Received: by 2002:a37:7744:: with SMTP id s65mr16282734qkc.54.1587403758396;
        Mon, 20 Apr 2020 10:29:18 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:294e:2b15:7b00:d585? ([2601:282:803:7700:294e:2b15:7b00:d585])
        by smtp.googlemail.com with ESMTPSA id z6sm116005qke.56.2020.04.20.10.29.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Apr 2020 10:29:17 -0700 (PDT)
Subject: Re: [PATCH V2 mlx5-next 01/10] net/core: Introduce
 master_xmit_slave_get
To:     Jiri Pirko <jiri@resnulli.us>, Maor Gottlieb <maorg@mellanox.com>
Cc:     davem@davemloft.net, jgg@mellanox.com, dledford@redhat.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        kuba@kernel.org, leonro@mellanox.com, saeedm@mellanox.com,
        jiri@mellanox.com, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, alexr@mellanox.com
References: <20200420075426.31462-1-maorg@mellanox.com>
 <20200420075426.31462-2-maorg@mellanox.com>
 <20200420140118.GJ6581@nanopsycho.orion>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a9e00f31-2f4e-1dfc-2464-d3d25376a4b8@gmail.com>
Date:   Mon, 20 Apr 2020 11:29:15 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200420140118.GJ6581@nanopsycho.orion>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/20/20 8:01 AM, Jiri Pirko wrote:
> Mon, Apr 20, 2020 at 09:54:17AM CEST, maorg@mellanox.com wrote:
>> Add new ndo to get the xmit slave of master device.
>> User should release the slave when it's not longer needed.
>> When slave selection method is based on hash, then the user can ask to
>> get the xmit slave assume all the slaves can transmit by setting the
>> LAG_FLAGS_HASH_ALL_SLAVES bit in the flags argument.
>>
>> Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
>> ---
>> include/linux/netdevice.h |  3 +++
>> include/net/lag.h         | 32 ++++++++++++++++++++++++++++++++
>> 2 files changed, 35 insertions(+)
>>
>> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
>> index 130a668049ab..e8852f3ad0b6 100644
>> --- a/include/linux/netdevice.h
>> +++ b/include/linux/netdevice.h
>> @@ -1389,6 +1389,9 @@ struct net_device_ops {
>> 						 struct netlink_ext_ack *extack);
>> 	int			(*ndo_del_slave)(struct net_device *dev,
>> 						 struct net_device *slave_dev);
>> +	struct net_device*	(*ndo_xmit_get_slave)(struct net_device *master_dev,
>> +						      struct sk_buff *skb,
>> +						      u16 flags);
> 
> Please adjust the name to:
> ndo_get_lag_xmit_slave

I disagree. There are multiple master devices and no reason to have a
LAG specific get_slave.



