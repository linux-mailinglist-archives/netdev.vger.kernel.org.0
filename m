Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C66D41B13AE
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 19:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbgDTR5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 13:57:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726013AbgDTR5B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 13:57:01 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 544F8C061A0C;
        Mon, 20 Apr 2020 10:57:01 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id z90so9262479qtd.10;
        Mon, 20 Apr 2020 10:57:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZctBoDBTZhAhO9oRTy/FmpWm5c45TT9cEcntnaMTs7I=;
        b=LGRgrM9tGwPGizuJyfOQHo/h9alMC6W60dSUaMnQUbwzV0fa4MxtfVBbDd1UOnDc+m
         TzHJJ2BWcLjxAuNayaO07QwhxoG3vyWikfWVTFFdUzMTjIVeTOFt2vDSeciFXWY7aV7Y
         TkYx3im1FxsfG0SQ0FzwFjE2lozkzPZTctEuEnRIdI7L/ZTiGRKsspEbHA6Lg5XGSiAb
         ZwPX9ZbYd4rh8wnV8uDOOeDZRx9ZcqkOn1vCt18FN/lm//J1YODvj05nK/0TdahL4uzn
         wUCYye4VclfN+BurB0LoWMQ4H0vw+3nGBXcrr+qKUFbJOOyOUtuDmTo8VTlwpIOvXiXX
         llVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZctBoDBTZhAhO9oRTy/FmpWm5c45TT9cEcntnaMTs7I=;
        b=F6EHMgQHU31H8zGg6+FVwwWxyjejB6QQ/o07RSQzPejsH6jv7Q71up+FFYuVdM2xHy
         nyZBwpEinsSq8mMRRjZJJquST9NRvZlOGNS/IsqO7awUuPlYoDK4tLO9oaFGqpn0rR4u
         UWijRoJGH6y1xjzYk6Pv7l2KvZF/TMIKHvqVEwz5zuTnuP3fEYQgMHOarqg2wkO05abT
         mjdp1q69FUcq5i4X5aB8Pk0CLC8m7oymJdFQ2GXajkAkt0NhJX9OyYJPJcC2Z/WsP2DT
         503dwF/X9LPTUELUfn/OUJsWl6g+oqeBJ7V7Tyfg6aEH8zD1O0mibKL1nA1bJt050IJ/
         GQqQ==
X-Gm-Message-State: AGi0PuZdMC7nDWSJCTtGE3Whirhtan+tDC/2jmIrLH76MId9LXvmJKG0
        MFtpPHbFQNLlVZkEg4mXrbY=
X-Google-Smtp-Source: APiQypIkxwHyLo4sdNTtiSd6huKb/L1u3Ir+0ebeIcuOKOjlVyGE9Uxzu8brDji6p3lubyNb4ViLKw==
X-Received: by 2002:ac8:32cd:: with SMTP id a13mr17735379qtb.360.1587405420605;
        Mon, 20 Apr 2020 10:57:00 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:b4ef:508c:423e:3e6a? ([2601:282:803:7700:b4ef:508c:423e:3e6a])
        by smtp.googlemail.com with ESMTPSA id u17sm179974qka.0.2020.04.20.10.56.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Apr 2020 10:57:00 -0700 (PDT)
Subject: Re: [PATCH V2 mlx5-next 01/10] net/core: Introduce
 master_xmit_slave_get
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Maor Gottlieb <maorg@mellanox.com>, davem@davemloft.net,
        jgg@mellanox.com, dledford@redhat.com, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, kuba@kernel.org,
        leonro@mellanox.com, saeedm@mellanox.com, jiri@mellanox.com,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        alexr@mellanox.com
References: <20200420075426.31462-1-maorg@mellanox.com>
 <20200420075426.31462-2-maorg@mellanox.com>
 <20200420140118.GJ6581@nanopsycho.orion>
 <a9e00f31-2f4e-1dfc-2464-d3d25376a4b8@gmail.com>
 <20200420175421.GU6581@nanopsycho.orion>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <916ab047-3b50-7104-311a-6dcf604bcf6d@gmail.com>
Date:   Mon, 20 Apr 2020 11:56:58 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200420175421.GU6581@nanopsycho.orion>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/20/20 11:54 AM, Jiri Pirko wrote:
> Mon, Apr 20, 2020 at 07:29:15PM CEST, dsahern@gmail.com wrote:
>> On 4/20/20 8:01 AM, Jiri Pirko wrote:
>>> Mon, Apr 20, 2020 at 09:54:17AM CEST, maorg@mellanox.com wrote:
>>>> Add new ndo to get the xmit slave of master device.
>>>> User should release the slave when it's not longer needed.
>>>> When slave selection method is based on hash, then the user can ask to
>>>> get the xmit slave assume all the slaves can transmit by setting the
>>>> LAG_FLAGS_HASH_ALL_SLAVES bit in the flags argument.
>>>>
>>>> Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
>>>> ---
>>>> include/linux/netdevice.h |  3 +++
>>>> include/net/lag.h         | 32 ++++++++++++++++++++++++++++++++
>>>> 2 files changed, 35 insertions(+)
>>>>
>>>> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
>>>> index 130a668049ab..e8852f3ad0b6 100644
>>>> --- a/include/linux/netdevice.h
>>>> +++ b/include/linux/netdevice.h
>>>> @@ -1389,6 +1389,9 @@ struct net_device_ops {
>>>> 						 struct netlink_ext_ack *extack);
>>>> 	int			(*ndo_del_slave)(struct net_device *dev,
>>>> 						 struct net_device *slave_dev);
>>>> +	struct net_device*	(*ndo_xmit_get_slave)(struct net_device *master_dev,
>>>> +						      struct sk_buff *skb,
>>>> +						      u16 flags);
>>>
>>> Please adjust the name to:
>>> ndo_get_lag_xmit_slave
>>
>> I disagree. There are multiple master devices and no reason to have a
>> LAG specific get_slave.
> 
> Btw, did you notice that Maor is passing "lag" named values in the flags?
> 

yes. I disagree with enum name, but having LAG in the name of a flag is
fine. To me that is the right place for a LAG specific request of a
generic ndo in core code.
