Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA0D46B5F3
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 09:27:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232531AbhLGIag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 03:30:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232881AbhLGIae (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 03:30:34 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D8CDC0611F7
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 00:27:04 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id i5so27833636wrb.2
        for <netdev@vger.kernel.org>; Tue, 07 Dec 2021 00:27:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s5OqC7VPBrMj01hHCHUKkNLxuzC3dQ9fWZboCbDwXMo=;
        b=dves5TmgGIraK19J2GeFK0Z2FlsRGB4FVVTPd/G5fuOVuIepvcSR9DgXSTT2MR/Ves
         TYs63ZnzUBx2g3qbEOPtKgwYYXs6iRllzVK1flS2Vg4x1MZ5FAs5v70qLpSCmK+F/o8Q
         VCkr1QrZVu17Xx48u1BwtDUuwW9VjrqQh7sWjPeTum5XqdLbEUEzuVK6sVk+DT80L7FV
         it63HTZUf+avsGNSb/zvyV5fPBchdB1PITUljpgKp0R68k1pvgn1A/2JkhBFJVrV9ZbV
         khhm1hSpNvhkKXxF2CTIxX5tsQHT4fDAr4A1m10mYTQpPgjH1rpwvf45oCivTrQ20/xT
         oADw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=s5OqC7VPBrMj01hHCHUKkNLxuzC3dQ9fWZboCbDwXMo=;
        b=fTp7jMa2TIaOFxVyfPhHViWwXughq6FMEnWKGhgeJ8Gn8PE7Jx92LbplkniY6LPWP9
         bVfAVZTLn9BdXPgEfbNwiDJ0ucM2fmmB8Fmn+n654sZkF5AvozcojuVQqEtkhvMZzrpH
         erMQ+DwQbAWQk5snjRmJoTFnsgIwn+ikwmvLJtiGL15fOSZThsRL9r/np0tXs1kThAQ1
         fFpESkKG/wT0Vz/Tr2qXEgE3+sLgOpyE2S4bhtSEQP2U5iaUpRrqZL+jXDQWqoirJWTn
         8S6xZihOWRr7B5C8xYo6vTvgUFFEicBHM/w1teXiGZW1nRglVe0+m87NEBhKnZUKC8BD
         kdrQ==
X-Gm-Message-State: AOAM531LbyMXNiwr5VrDyQoA/wF5NDIicr02TVdpdSMU4ud52jRV1Abd
        l6AoxW1q3asTHVc0pggItyJbRw==
X-Google-Smtp-Source: ABdhPJx4poMLa2e0orQ7i3gGyi2dGZ8u/bvrHBaVyRb1we187ztd2hinL+hw0Mwdfk7yimy6cT0f7g==
X-Received: by 2002:a5d:47ab:: with SMTP id 11mr50185717wrb.148.1638865623012;
        Tue, 07 Dec 2021 00:27:03 -0800 (PST)
Received: from ?IPv6:2a01:e0a:b41:c160:f40f:c5d1:958:e84f? ([2a01:e0a:b41:c160:f40f:c5d1:958:e84f])
        by smtp.gmail.com with ESMTPSA id u15sm1863363wmq.13.2021.12.07.00.27.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Dec 2021 00:27:02 -0800 (PST)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net-next v5] rtnetlink: Support fine-grained netdevice
 bulk deletion
To:     David Ahern <dsahern@gmail.com>,
        Lahav Schlesinger <lschlesinger@drivenets.com>,
        netdev@vger.kernel.org
Cc:     kuba@kernel.org, nikolay@nvidia.com
References: <20211205093658.37107-1-lschlesinger@drivenets.com>
 <84166fe9-37f1-2c99-2caf-c68dcc5a370c@6wind.com>
 <98c6884c-642b-66d3-10ad-a8f0afebf446@gmail.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <d6924ce2-29e0-5604-8c79-88209f5ae295@6wind.com>
Date:   Tue, 7 Dec 2021 09:27:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <98c6884c-642b-66d3-10ad-a8f0afebf446@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 06/12/2021 à 16:20, David Ahern a écrit :
> On 12/6/21 1:25 AM, Nicolas Dichtel wrote:
>>> @@ -3050,6 +3052,78 @@ static int rtnl_group_dellink(const struct net *net, int group)
>>>  	return 0;
>>>  }
>>>  
>>> +static int dev_ifindex_cmp(const void *a, const void *b)
>>> +{
>>> +	struct net_device * const *dev1 = a, * const *dev2 = b;
>>> +
>>> +	return (*dev1)->ifindex - (*dev2)->ifindex;
>>> +}
>>> +
>>> +static int rtnl_ifindex_dellink(struct net *net, struct nlattr *head, int len,
>>> +				struct netlink_ext_ack *extack)
>>> +{
>>> +	int i = 0, num_devices = 0, rem;
>>> +	struct net_device **dev_list;
>>> +	const struct nlattr *nla;
>>> +	LIST_HEAD(list_kill);
>>> +	int ret;
>>> +
>>> +	nla_for_each_attr(nla, head, len, rem) {
>>> +		if (nla_type(nla) == IFLA_IFINDEX)
>>> +			num_devices++;
>>> +	}
>>> +
>>> +	dev_list = kmalloc_array(num_devices, sizeof(*dev_list), GFP_KERNEL);
>>> +	if (!dev_list)
>>> +		return -ENOMEM;
>>> +
>>> +	nla_for_each_attr(nla, head, len, rem) {
>>> +		const struct rtnl_link_ops *ops;
>>> +		struct net_device *dev;
>>> +		int ifindex;
>>> +
>>> +		if (nla_type(nla) != IFLA_IFINDEX)
>>> +			continue;
>>> +
>>> +		ifindex = nla_get_s32(nla);
>>> +		ret = -ENODEV;
>>> +		dev = __dev_get_by_index(net, ifindex);
>>> +		if (!dev) {
>>> +			NL_SET_ERR_MSG_ATTR(extack, nla, "Unknown ifindex");
>> It would be nice to have the ifindex in the error message. This message does not
>> give more information than "ENODEV".
> 
> extack infra does not allow dynamic messages. It does point to the
> location of the bad index, so userspace could figure it out.
Oh yes, my bad.


Thank you,
Nicolas
