Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 192FC1B13CE
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 20:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbgDTSBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 14:01:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725784AbgDTSBs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 14:01:48 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCE42C061A0C
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 11:01:47 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id 188so558931wmc.2
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 11:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oT92GfJOaAQKiG4CatmPFlFSWqWaY1NX8Aw0orw7olU=;
        b=SFrKDpwr6iq1OJcomvS+1UdjBeiOwjD9V/AcWRSoxvL8gEfWI/vKJCQk5Kq13/Ud8W
         x40LdW3aYhOH4IJcwtLl7/jg7DDKJHkqa/u17GxnJTy3aQ8fxQ5qBkpFMg84bhuhS3wU
         /Tk77m1gBxo1RDAs7ZV0QXpVjIC0pD5yxXlryBe3Mvnqy+deq4VIUxWSL0XUMgCZVMzU
         2GBg68iJ2wsS2kK59KavQH3Kn7peWx/XxSeQGyEW6eb2+H/JMpXnIKKFraMUUTwb9Npz
         aE37N8AGDbZMCKsBM5CHSRM/AXBfh0Re1EQ1n5pfgAatwziXEGkT9XNPFCcH6J+5bdRO
         z+Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oT92GfJOaAQKiG4CatmPFlFSWqWaY1NX8Aw0orw7olU=;
        b=t4l+HseMz+UAs2dqU8nPEv2OSw4MmS6J2xyRBKCpzjXw6A09yKgEifdv9ctKAVnNsj
         0oR8kuUNR5/1FgKcQwMTcmhTbgGN1pCEeBZ8ytLUwfx8CylwheGpb49oAYXT/eZxHAR6
         2uk3rmDru92J1JVV/OQ/80XavWpN57UnO9+OOABVWcXUGNDS1vyjwo3NsThT7iIMs23X
         +BpiuKNOm5u0yHbQBPfter1hw45r0tshm/l/LOqjCo4kN/ODWMsRUROtk31DJ3lUvDtQ
         ZMoKP303MelF2SuNacE3PXmq5wV7A5RI8fEvnFKHPHBLhiDDkSnxcaVCFFZgfZyuUWF6
         CysQ==
X-Gm-Message-State: AGi0PuZD/Lk5EGPkAOqtlANmK5+ul4Ie3DdVAbRQnYEQESX/Hp1XnZoj
        VoF5WVPkI/Ly0Mxg1p5yy6CN+Q==
X-Google-Smtp-Source: APiQypIE7TiYP5gus2N3ybfKPtgR46azvtrC+KO/PX/KcBm+CSIUyOx8dBXXkbZMwQskfttbzagnOQ==
X-Received: by 2002:a1c:964a:: with SMTP id y71mr533933wmd.89.1587405706596;
        Mon, 20 Apr 2020 11:01:46 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id l185sm179147wml.44.2020.04.20.11.01.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 11:01:45 -0700 (PDT)
Date:   Mon, 20 Apr 2020 20:01:44 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     Maor Gottlieb <maorg@mellanox.com>, davem@davemloft.net,
        jgg@mellanox.com, dledford@redhat.com, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, kuba@kernel.org,
        leonro@mellanox.com, saeedm@mellanox.com, jiri@mellanox.com,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        alexr@mellanox.com
Subject: Re: [PATCH V2 mlx5-next 01/10] net/core: Introduce
 master_xmit_slave_get
Message-ID: <20200420180144.GV6581@nanopsycho.orion>
References: <20200420075426.31462-1-maorg@mellanox.com>
 <20200420075426.31462-2-maorg@mellanox.com>
 <20200420140118.GJ6581@nanopsycho.orion>
 <a9e00f31-2f4e-1dfc-2464-d3d25376a4b8@gmail.com>
 <20200420175421.GU6581@nanopsycho.orion>
 <916ab047-3b50-7104-311a-6dcf604bcf6d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <916ab047-3b50-7104-311a-6dcf604bcf6d@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Apr 20, 2020 at 07:56:58PM CEST, dsahern@gmail.com wrote:
>On 4/20/20 11:54 AM, Jiri Pirko wrote:
>> Mon, Apr 20, 2020 at 07:29:15PM CEST, dsahern@gmail.com wrote:
>>> On 4/20/20 8:01 AM, Jiri Pirko wrote:
>>>> Mon, Apr 20, 2020 at 09:54:17AM CEST, maorg@mellanox.com wrote:
>>>>> Add new ndo to get the xmit slave of master device.
>>>>> User should release the slave when it's not longer needed.
>>>>> When slave selection method is based on hash, then the user can ask to
>>>>> get the xmit slave assume all the slaves can transmit by setting the
>>>>> LAG_FLAGS_HASH_ALL_SLAVES bit in the flags argument.
>>>>>
>>>>> Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
>>>>> ---
>>>>> include/linux/netdevice.h |  3 +++
>>>>> include/net/lag.h         | 32 ++++++++++++++++++++++++++++++++
>>>>> 2 files changed, 35 insertions(+)
>>>>>
>>>>> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
>>>>> index 130a668049ab..e8852f3ad0b6 100644
>>>>> --- a/include/linux/netdevice.h
>>>>> +++ b/include/linux/netdevice.h
>>>>> @@ -1389,6 +1389,9 @@ struct net_device_ops {
>>>>> 						 struct netlink_ext_ack *extack);
>>>>> 	int			(*ndo_del_slave)(struct net_device *dev,
>>>>> 						 struct net_device *slave_dev);
>>>>> +	struct net_device*	(*ndo_xmit_get_slave)(struct net_device *master_dev,
>>>>> +						      struct sk_buff *skb,
>>>>> +						      u16 flags);
>>>>
>>>> Please adjust the name to:
>>>> ndo_get_lag_xmit_slave
>>>
>>> I disagree. There are multiple master devices and no reason to have a
>>> LAG specific get_slave.
>> 
>> Btw, did you notice that Maor is passing "lag" named values in the flags?
>> 
>
>yes. I disagree with enum name, but having LAG in the name of a flag is
>fine. To me that is the right place for a LAG specific request of a
>generic ndo in core code.

Generic ndo with lag-specific arg? Odd. Plus, there is a small chance
this is ever going to be used for other master. And if so, could be very
easily renamed then...
