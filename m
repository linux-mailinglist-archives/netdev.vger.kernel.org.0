Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22B982664E0
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 18:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbgIKQrd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 12:47:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726493AbgIKQrT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 12:47:19 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83818C061757
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 09:47:18 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id r25so11810114ioj.0
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 09:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nhqocnUK5IBYgzD5oAcXyHByI1Iq29Lfu4Om+gaBeTk=;
        b=tfJcdKSMB0UpwpyaxMMBjNB/vK//Dfc/4NyAS+URzsMqF9WkK/gBKWkDCN9yWdYSgM
         F5f9VA4ui7pE+bEEMuphGkvVDjpbU0sZQ9nPn8vQIsnjs5mvq0gNEZ6BwIM2jwiBSiOv
         UJdbAWZmFmSJyVMRI7bpyqCaws2nkKrQjh9h3McQFqgvARAd3+oeUxz8+Z1wwAPNW9WO
         AepmVjCVklptPKARELJDJzi1cnAa/wu1Gfb7a7xK6ANMAHBdrXkbIoPKm0BOjN5Wd8eT
         4pR1kZn2bwLJijk27tsej2XxdhKCyT5ic/IMD3D5+Y5/MHlt/Y88UdnZmYXfI7QFtaky
         PoXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nhqocnUK5IBYgzD5oAcXyHByI1Iq29Lfu4Om+gaBeTk=;
        b=V8ISJB8FTwWjLUPdMlIjxGBpTcscp4hS4UKBaV2cRE/AOyWn8mVbkLes5FVHEMvJJH
         QrZfNUyRaePthaISuSkKo0+LhWwUnDKORhcmQH/+J84T0aH3JkLimvAcShCsBonC1trO
         HTgeyZ2CPN7v5ZcdIWhpIvvvnD9EyDEeejjBx+Pz0oyTEFxolWNIXqvnmtncQ92FC6LL
         qTRSUot67nCd+jlctoPEfNcVbO5+llJ6CeBsqF8sBiFwej8eXiH121UN6D0Xc40ZpMKx
         MkyjmKY/M4x5NusWEAQEBIEKxoFgLuAF7pC+bd6ikg4+YfstjVQXzqcSiYmM1pGSDMW5
         lQqA==
X-Gm-Message-State: AOAM530dgCAJiN8dgnaZAM9EPY9HpXy3ATzJgsRYC1P8IxGPv4iWlQKC
        iwKMAFfxGyKn2SB4ZWH1NUEFJW2BwzVC4Q==
X-Google-Smtp-Source: ABdhPJz+3+wBlD0xYw96gZtZ1he2RpDh3zwiLVNvd+sclkaf69P6P9psUyW+jAkWgoFZZLwJqluwEQ==
X-Received: by 2002:a05:6602:22d3:: with SMTP id e19mr2369903ioe.197.1599842835393;
        Fri, 11 Sep 2020 09:47:15 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:e8e2:f0c7:a280:c32c])
        by smtp.googlemail.com with ESMTPSA id t10sm1437589iog.49.2020.09.11.09.47.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Sep 2020 09:47:14 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 17/22] nexthop: Replay nexthops when
 registering a notifier
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        roopa@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
References: <20200908091037.2709823-1-idosch@idosch.org>
 <20200908091037.2709823-18-idosch@idosch.org>
 <8191326b-0656-e7bb-1c94-7beb9097c423@gmail.com>
 <20200911164023.GJ3160975@shredder>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <74187436-6a30-2d44-de7f-0a52268b7f11@gmail.com>
Date:   Fri, 11 Sep 2020 10:47:13 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200911164023.GJ3160975@shredder>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/11/20 10:40 AM, Ido Schimmel wrote:
>>> @@ -2116,11 +2137,40 @@ static struct notifier_block nh_netdev_notifier = {
>>>  	.notifier_call = nh_netdev_event,
>>>  };
>>>  
>>> +static int nexthops_dump(struct net *net, struct notifier_block *nb,
>>> +			 struct netlink_ext_ack *extack)
>>> +{
>>> +	struct rb_root *root = &net->nexthop.rb_root;
>>> +	struct rb_node *node;
>>> +	int err = 0;
>>> +
>>> +	for (node = rb_first(root); node; node = rb_next(node)) {
>>> +		struct nexthop *nh;
>>> +
>>> +		nh = rb_entry(node, struct nexthop, rb_node);
>>> +		err = call_nexthop_notifier(nb, net, NEXTHOP_EVENT_REPLACE, nh,
>>> +					    extack);
>>> +		if (err)
>>> +			break;
>>> +	}
>>> +
>>> +	return err;
>>> +}
>>> +
>>>  int register_nexthop_notifier(struct net *net, struct notifier_block *nb,
>>>  			      struct netlink_ext_ack *extack)
>>>  {
>>> -	return blocking_notifier_chain_register(&net->nexthop.notifier_chain,
>>> -						nb);
>>> +	int err;
>>> +
>>> +	rtnl_lock();
>>> +	err = nexthops_dump(net, nb, extack);
>>
>> can the unlock be moved here? register function below should not need it.
> 
> It can result in this unlikely race:
> 
> <t0> - rtnl_lock(); nexthops_dump(); rtnl_unlock()
> <t1> - Nexthop is added / deleted
> <t2> - blocking_notifier_chain_register()
> 

ok. Let's keep the order you have which I believe is consistent with FIB
notifiers.
