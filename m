Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6E730B50B
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 03:07:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbhBBCGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 21:06:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbhBBCGq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 21:06:46 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CD55C061756
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 18:06:06 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id i30so18404655ota.6
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 18:06:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CwWiOZQmxYrRcvWCDy0uDjOMDsiyAmHaUDPqXTeh5C4=;
        b=GBXg8D0nysXnwUAb486Zh/3MQGq3fQylDxWEkq8tX13sRxMvgVeNbAXcDLQlKC2XAx
         PJLEFpW7lnBTArGqJ9cP5hsQvnChGvh/NiNYI+AFYPnQvhUe2TwwH500ndN9HXTmzFPq
         tvIKIcad28ERp/RkS5U1QDCE1c4FzPzf6EEtVnfQASxBk1/l57uqjvlYhYZKd1cfNlAZ
         V58FTum4I97ttqw+cWZ6iSmJDj4jZH/9UZrLBa9VDa8CkWhtj7WdmjtPM8gm6ikSxmaO
         ZkswPzl8SW0kV7AyBxAY/EN96BglmmGxSo7qb4BSbcLV3VM4vDFkiQjSgPZjgWPi5jy+
         GAPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CwWiOZQmxYrRcvWCDy0uDjOMDsiyAmHaUDPqXTeh5C4=;
        b=mAuJkfjuwSnd35trp+q/631ECqIa9v1n1M+ZJAlvWELYEjbGo4mtZE1Do9SN0ZXsJF
         RSFsk5t8zM9/bzfZwmEBR5rdLPW66Nuqd5bnJ4eCLfhc7yzxJNmtXfVD4/puj9yngpZ8
         jq9PUpJD0w+Dt22KAui5yWJoAx3NSLO38WOJqPpgYSNP1V/yqLHcdHk8f1aH2F/1gk6t
         HcE7XyECOAA12LMH4KgpOWRTJB280OENrhxBWm41kfn/ACg4StOJT6kcRKFRQW77dOtC
         3mP1QHHZdeI4tVmc6zldzFdnKGxIdEJDB6OHAb3TQzOQXMl9U0zrZKF2NAIWv7PxDFLP
         m83Q==
X-Gm-Message-State: AOAM533kICUc8Z7r2GXKIoSWOBl8y6oVxHRPHBlVYlF4k6hIUM4Y5qN+
        9h9P0BT8aHjLIaVvgw8W12A=
X-Google-Smtp-Source: ABdhPJyoMLLGNir+oYO0rzWdDTiL0jXMJQZ+BioexBTPFNEKzaocGkRCs6OaadRzCVEnDE1wrNzBiw==
X-Received: by 2002:a9d:c66:: with SMTP id 93mr13482701otr.289.1612231565718;
        Mon, 01 Feb 2021 18:06:05 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id s33sm3780232ooi.39.2021.02.01.18.06.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Feb 2021 18:06:04 -0800 (PST)
Subject: Re: [net-next v2 2/2] tcp: Add receive timestamp support for receive
 zerocopy.
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Arjun Roy <arjunroy.kdev@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, arjunroy@google.com, edumazet@google.com,
        soheil@google.com
References: <20210121004148.2340206-1-arjunroy.kdev@gmail.com>
 <20210121004148.2340206-3-arjunroy.kdev@gmail.com>
 <20210122200723.50e4afe6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <a18cbf73-1720-dec0-fbc6-2e357fee6bd8@gmail.com>
 <20210125061508.GC579511@unreal>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ad3d4a29-b6c1-c6d2-3c0f-fff212f23311@gmail.com>
Date:   Mon, 1 Feb 2021 19:06:03 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210125061508.GC579511@unreal>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/24/21 11:15 PM, Leon Romanovsky wrote:
> On Fri, Jan 22, 2021 at 10:55:45PM -0700, David Ahern wrote:
>> On 1/22/21 9:07 PM, Jakub Kicinski wrote:
>>> On Wed, 20 Jan 2021 16:41:48 -0800 Arjun Roy wrote:
>>>> diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
>>>> index 768e93bd5b51..b216270105af 100644
>>>> --- a/include/uapi/linux/tcp.h
>>>> +++ b/include/uapi/linux/tcp.h
>>>> @@ -353,5 +353,9 @@ struct tcp_zerocopy_receive {
>>>>  	__u64 copybuf_address;	/* in: copybuf address (small reads) */
>>>>  	__s32 copybuf_len; /* in/out: copybuf bytes avail/used or error */
>>>>  	__u32 flags; /* in: flags */
>>>> +	__u64 msg_control; /* ancillary data */
>>>> +	__u64 msg_controllen;
>>>> +	__u32 msg_flags;
>>>> +	/* __u32 hole;  Next we must add >1 u32 otherwise length checks fail. */
>>>
>>> Well, let's hope nobody steps on this landmine.. :)
>>>
>>
>> Past suggestions were made to use anonymous declarations - e.g., __u32
>> :32; - as a way of reserving the space for future use. That or declare
>> '__u32 resvd', check that it must be 0 and makes it available for later
>> (either directly or with a union).
> 
> This is the schema (reserved field without union) used by the RDMA UAPIs from
> the beginning (>20 years already) and it works like a charm.
> 
> Highly recommend :).
> 

agreed.

Arjun: would you mind following up with a patch to make this hole
explicit and usable for the next extension? Thanks,
