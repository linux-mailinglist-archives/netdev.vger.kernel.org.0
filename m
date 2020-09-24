Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7109277C86
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 01:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbgIXXyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 19:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgIXXyS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 19:54:18 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C172C0613CE
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 16:54:18 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id u24so907888pgi.1
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 16:54:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SsVXNsCqL45/rgL58aiZGnbAo9fkAnrMqE2RIgl9gQ4=;
        b=KrFYk3TkepbULmJj8ch2B3kXC4NxBfYOoPGBckAHSb6s4LimBYZ7J+cqiPM0c5/0Je
         tgyiaCxLooLP8unJNyXODgnEDvi3kX5NsexHGtW1V7Sz1W6asVN6Kn4xUFv4tCBBkKkn
         mCmQUIZfv/o7iNAIegFksjX7NapG7mZajPUgPstgKccSghJXArPc7YWwSxNa3IQHm9nU
         QQ1Y+ulrLGtNMTprxkrmvHU8orED+b/SAJCxPv926bVU88z3vG8/B98D4hSlRnNQo91N
         ho9rsKDJRII92bhbMroNdWv2VsN0fHdICY9BkA55DMcBEofKviLVxsLJFwX5xh6K27W5
         UoKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SsVXNsCqL45/rgL58aiZGnbAo9fkAnrMqE2RIgl9gQ4=;
        b=mJ+ZU7nriq1mkGbMYpNMF5/9JWXkrgdFfMFpTqHXz1TTVoQhaFcxqZ8LDtoNfKyzsd
         xUhgnM+elWw9Ct+TDOM6Ts9MfFBPgTCDpBdvbEzYA/4R9+rsne9Smor8SsBbb2PIZQWW
         ANflCYY5cwqs1M9ARZh/JG9vsTvCRyveFMTsQsU/T9G/hPthNnAS0jqUb1oBxSTD07qa
         4JXsdzSDP2K+DD4f73+Of3+0I5BmoTxWT/pH/AUFYnnvAaavMyVTAuep3UNdywGrsf3q
         4Si0PQqv8zVTiIge6eq/dpEmzacc0lTbTAXfoLtd9bSVRDrLacCsEFaSY/9h6ghe36d3
         0rIg==
X-Gm-Message-State: AOAM531ihf0bgrzhSEhEisQxn27Sl2QtkQVoNOL8sYjiKLZ5GQqHAKOO
        NFVURAJ5Tl8Atddot210kvE=
X-Google-Smtp-Source: ABdhPJwoFbgWmbbzBTPRfXWiIc+P++A3S7dlMihh1K0N0I8LuWCJIZkyHgf3Eu3kmaEtxia3+8pjrA==
X-Received: by 2002:a17:902:59d7:b029:d1:e5e7:bdf9 with SMTP id d23-20020a17090259d7b02900d1e5e7bdf9mr1596074plj.44.1600991657877;
        Thu, 24 Sep 2020 16:54:17 -0700 (PDT)
Received: from [10.230.28.160] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id c186sm406263pga.61.2020.09.24.16.54.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Sep 2020 16:54:17 -0700 (PDT)
Subject: Re: [PATCH net-next] net: vlan: Avoid using BUG() in vlan_proto_idx()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, olteanv@gmail.com, vladimir.oltean@nxp.com
References: <20200924041627.33106-1-f.fainelli@gmail.com>
 <20200924164615.619badc0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <74995756-2a48-7e63-3806-e98b624177e0@gmail.com>
Date:   Thu, 24 Sep 2020 16:54:15 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200924164615.619badc0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/24/2020 4:46 PM, Jakub Kicinski wrote:
> On Wed, 23 Sep 2020 21:16:27 -0700 Florian Fainelli wrote:
>> While we should always make sure that we specify a valid VLAN protocol
>> to vlan_proto_idx(), killing the machine when an invalid value is
>> specified is too harsh and not helpful for debugging. All callers are
>> capable of dealing with an error returned by vlan_proto_idx() so check
>> the index value and propagate it accordingly.
>>
>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> Perhaps it's heresy but I wonder if the error checking is worth it
> or we'd be better off WARNing and assuming normal Q tag.. unlikely
> someone is getting it wrong now given the BUG().

This showed up while working with Vladimir on another patch set where we 
were able to submit packets with an incorrect skb->vlan_proto submitted 
via the DSA stacking model. It should not happen, but arguably crashing 
the kernel was not helping either.

> 
>> diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
>> index d4bcfd8f95bf..6c08de1116c1 100644
>> --- a/net/8021q/vlan.c
>> +++ b/net/8021q/vlan.c
>> @@ -57,6 +57,9 @@ static int vlan_group_prealloc_vid(struct vlan_group *vg,
>>   	ASSERT_RTNL();
>>   
>>   	pidx  = vlan_proto_idx(vlan_proto);
>> +	if (pidx < 0)
>> +		return -EINVAL;
>> +
>>   	vidx  = vlan_id / VLAN_GROUP_ARRAY_PART_LEN;
>>   	array = vg->vlan_devices_arrays[pidx][vidx];
>>   	if (array != NULL)
>> diff --git a/net/8021q/vlan.h b/net/8021q/vlan.h
>> index bb7ec1a3915d..143e9c12dbd6 100644
>> --- a/net/8021q/vlan.h
>> +++ b/net/8021q/vlan.h
>> @@ -44,8 +44,8 @@ static inline unsigned int vlan_proto_idx(__be16 proto)
> 
> adjust return type

Ah yes, indeed.

> 
>>   	case htons(ETH_P_8021AD):
>>   		return VLAN_PROTO_8021AD;
>>   	default:
>> -		BUG();
>> -		return 0;
>> +		WARN(1, "invalid VLAN protocol: 0x%04x\n", htons(proto));
> 
> ntohs()

OK, there is also a variable name pdix instead of pidx, I will resend 
shortly, thanks!
-- 
Florian
