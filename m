Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7E463DE4D0
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 05:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233748AbhHCDvo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 23:51:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233631AbhHCDvn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 23:51:43 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15835C06175F
        for <netdev@vger.kernel.org>; Mon,  2 Aug 2021 20:51:32 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id f20-20020a9d6c140000b02904bb9756274cso7614315otq.6
        for <netdev@vger.kernel.org>; Mon, 02 Aug 2021 20:51:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yuvhDmQUgwqc91GvynWALqB4TiRVMHZlAA2MBnH6go8=;
        b=kBpIJUNxB8cVWdxYwupF6dZhZYR1rHrnunBkdQcmnpd4HfgFuroKk/3mTzsACVi0yh
         5VUE0OnlKIW91Z8Bvk6xx2QRpUavh8GXcVE8KzKKNhD38MTuAr3lDhKr5dbwQxE8Rp4e
         md5EU3SOcC4W6IeET1Prr7wkPTLDlDKhsHewraADw+zKmOn9cqKXtUeValBp5vaBSDNm
         tsp/cDDBIZvQRZPw8f9SzXzn/2K2kLGTklU7G0AQP0pfxWTRVGQYM0wsmSUVyUntelt6
         CO1gvXpECPoLA3AaIjzHilUnVY3v5bjQJQLsSSRNIBBzGEVx2m1qri5eED/O7iOwrKsP
         AbVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yuvhDmQUgwqc91GvynWALqB4TiRVMHZlAA2MBnH6go8=;
        b=dlRWNWoIxv5+3hs/J87hz7P9rPdVYjmcLOGsIqDNuyQPjLJfUoDeuJ1f6MpdEId+bd
         TJT12E6YGMUScIeuYW6K3E2K0WEMvEjpMege1GruQQAuNxaETR4hkQ8uZytGUrTmjHw0
         4Bmob/3zmUDb5+IwSRJElW5/jE4AnQLcJkjalxMWDzECv+8Wzubdq4sU2OCDKiYYiu/F
         uS38Al4laa6kL1VkEfPQEkyONL7uWbqLyQ9RN+vhV2XNJmDDF7HWJqcjiyQDaI2nqVF9
         7FuFxtrXplFgA/ZQfck4Xd6rboVsRAqRptIhi1aIXxVWxA1Ijemh4RlC2KZWl37Wlly3
         g+Tg==
X-Gm-Message-State: AOAM530XTqdtT2QbmCyzf9v/Cl0e1mrKLTCCNVLaE+L7AcPQTt7W1Fym
        FBvkivOzNTstifg4ppOksI+ESFv4Pfo=
X-Google-Smtp-Source: ABdhPJxHk5d/IT6h+jUGFvsn6U9Zf+2AAujsb/LckUr7YQ2hSOD/xJGDyae3SoilqOkivMvuCrHz7Q==
X-Received: by 2002:a05:6830:43a3:: with SMTP id s35mr13854041otv.262.1627962691458;
        Mon, 02 Aug 2021 20:51:31 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.27])
        by smtp.googlemail.com with ESMTPSA id be15sm2198434oib.18.2021.08.02.20.51.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Aug 2021 20:51:30 -0700 (PDT)
Subject: Re: [PATCH] neigh: Support filtering neighbours for L3 slave
To:     Lahav Schlesinger <lschlesinger@drivenets.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        dsahern@kernel.org
References: <20210801090105.27595-1-lschlesinger@drivenets.com>
 <351cae13-8662-2f8f-dd8b-4127ead0ca2a@gmail.com>
 <20210802082310.wszqbydeqpxcgq2p@kgollan-pc>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <6b3516da-0ba5-0bbf-8de1-e1232457a5aa@gmail.com>
Date:   Mon, 2 Aug 2021 21:51:29 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210802082310.wszqbydeqpxcgq2p@kgollan-pc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/2/21 2:23 AM, Lahav Schlesinger wrote:
> On Sun, Aug 01, 2021 at 11:50:16AM -0600, David Ahern wrote:
>> On 8/1/21 3:01 AM, Lahav Schlesinger wrote:
>>> Currently there's support for filtering neighbours for interfaces which
>>> are in a specific VRF (passing the VRF interface in 'NDA_MASTER'), but
>>> there's not support for filtering interfaces which are not in an L3
>>> domain (the "default VRF").
>>>
>>> This means userspace is unable to show/flush neighbours in the default VRF
>>> (in contrast to a "real" VRF - Using "ip neigh show vrf <vrf_dev>").
>>>
>>> Therefore for userspace to be able to do so, it must manually iterate
>>> over all the interfaces, check each one if it's in the default VRF, and
>>> if so send the matching flush/show message.
>>>
>>> This patch adds the ability to do so easily, by passing a dummy value as
>>> the 'NDA_MASTER' ('NDV_NOT_L3_SLAVE').
>>> Note that 'NDV_NOT_L3_SLAVE' is a negative number, meaning it is not a valid
>>> ifindex, so it doesn't break existing programs.
>>>
>>> I have a patch for iproute2 ready for adding this support in userspace.
>>>
>>> Signed-off-by: Lahav Schlesinger <lschlesinger@drivenets.com>
>>> Cc: David S. Miller <davem@davemloft.net>
>>> Cc: Jakub Kicinski <kuba@kernel.org>
>>> Cc: David Ahern <dsahern@kernel.org>
>>> ---
>>>  include/uapi/linux/neighbour.h | 2 ++
>>>  net/core/neighbour.c           | 3 +++
>>>  2 files changed, 5 insertions(+)
>>>
>>> diff --git a/include/uapi/linux/neighbour.h b/include/uapi/linux/neighbour.h
>>> index dc8b72201f6c..d4f4c2189c63 100644
>>> --- a/include/uapi/linux/neighbour.h
>>> +++ b/include/uapi/linux/neighbour.h
>>> @@ -196,4 +196,6 @@ enum {
>>>  };
>>>  #define NFEA_MAX (__NFEA_MAX - 1)
>>>
>>> +#define NDV_NOT_L3_SLAVE	(-10)
>>> +
>>>  #endif
>>> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
>>> index 53e85c70c6e5..b280103b6806 100644
>>> --- a/net/core/neighbour.c
>>> +++ b/net/core/neighbour.c
>>> @@ -2529,6 +2529,9 @@ static bool neigh_master_filtered(struct net_device *dev, int master_idx)
>>>  {
>>>  	struct net_device *master;
>>>
>>> +	if (master_idx == NDV_NOT_L3_SLAVE)
>>> +		return netif_is_l3_slave(dev);
>>> +
>>>  	if (!master_idx)
>>>  		return false;
>>>
>>>
>>
>> you can not special case VRFs like this, and such a feature should apply
>> to links and addresses as well.
> 
> Understandable, I'll change it.
> In this case though, how would you advice to efficiently filter
> neighbours for interfaces in the default VRF in userspace (without
> quering the master of every interface that is being dumped)?
> I reckoned that because there's support in iproute2 for filtering based
> on a specific VRF, filtering for the default VRF is a natural extension

iproute2 has support for a link database (ll_cache). You would basically
have to expand the cache to track any master device a link is associated
with and then fill the cache with a link dump first. It's expensive at
scale; the "no stats" filter helps a bit.

This is the reason for kernel side filtering on primary attributes
(coarse grain filtering at reasonable cost).

> 
>>
>> One idea is to pass "*_MASTER" as -1 (use "none" keyword for iproute2)
>> and then update kernel side to only return entries if the corresponding
>> device is not enslaved to another device. Unfortunately since I did not
>> check that _MASTER was non-zero in the current code, we can not use 0 as
>> a valid flag for "not enslaved". Be sure to document why -1 is used.
> 
> Do you mean the command will look like "ip link show master none"?
> If so, wouldn't this cause an ambiguity if an interface names "none" is present?
> 

You could always detect "none" as a valid device name and error out or
use "nomaster" as a way to say "show all devices not enslaved to a
bridge or VRF.
