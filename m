Return-Path: <netdev+bounces-2907-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 186B17047D4
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 10:31:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 17D401C20DE2
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 08:30:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4657EA95C;
	Tue, 16 May 2023 08:30:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC352098E
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 08:30:58 +0000 (UTC)
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1B441BFD
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 01:30:56 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id 4fb4d7f45d1cf-50b37f3e664so24247183a12.1
        for <netdev@vger.kernel.org>; Tue, 16 May 2023 01:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20221208.gappssmtp.com; s=20221208; t=1684225855; x=1686817855;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=M34/aMKN7ljoeujRQEvpnGsETt4x3AV3rvDr+t0qo4I=;
        b=mIHFwFj4/b/BrjiM1IfcwgiHg2Z25LopZs63qB+UIFWa1KKJvsXiITrff343N6CSOk
         T4DXsjUXNmlWSk07koYZJbuqxQDRRWeYeTTlN+8T3F4lkIwddDNQBI+9gbT/QV8SzONo
         QeYwAHE76QLQevJaR0UsAxCZ6kbtoyIPROFGT+bphLahpBfs0LZrPIYE4BxvjDB2bVNW
         lJJOKhNoVxxcEpOwfWqQvzBDCAPQGuCcVIePNflw9bUYSiimpnRER3doCWo6l4K0R5TE
         95Imleo5fUwejVkWafhskPgwwZIPQMP/lx2Jv/2m3jI6KjBW9Fy/0qtLC7LGzaCAiFR4
         f0Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684225855; x=1686817855;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M34/aMKN7ljoeujRQEvpnGsETt4x3AV3rvDr+t0qo4I=;
        b=UCaVNSeBecmqe+AG1gEBShVWY8KqMB3eE3HXGzIxird6SMsEO+PHQv7GoW3Vs4v3XF
         dwdFqJcgCFTLoKsVtmiptOjhfd+9k+vGXfH5s5TMfe8JUhVH6jnbSEHdBAlZB7f+ZbYJ
         xMbjYVeEaJhJzn/BsROr6PtoPhhbvn0szHUEXWo+KYnMzqK8IRJMXjZ+2ZoJrlU2yKQa
         1D76AA9Q7qgOXAnHGFlJefuB9sz50SWoLcdE+hjiHCZVQJjjWTv1YHnmMOeFynzVXI1Q
         uRLggujrtbZExYeJjAenfwah/KnHNRm55nFYDx9MsmoZe3tERH7fo0hiTlkNAklsr3sF
         OSdw==
X-Gm-Message-State: AC+VfDziHxPwsGGRh051aGNoSzPYGRHilmeZrRZ1rIPtUQFp2Pg/cJli
	uLeu4IcGaUo+4wrv+gARBCAg5Q==
X-Google-Smtp-Source: ACHHUZ7iU4fIk9gvLuIZGyu/Ww4Eq91ifhd18J31LOAEojj0tM05/0+W1TCrkhqlZO7NzvJFV32aHg==
X-Received: by 2002:a17:906:db08:b0:94f:1c90:cb70 with SMTP id xj8-20020a170906db0800b0094f1c90cb70mr33953282ejb.66.1684225855192;
        Tue, 16 May 2023 01:30:55 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id l9-20020a170906078900b0094ed0370f8fsm10748836ejc.147.2023.05.16.01.30.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 May 2023 01:30:54 -0700 (PDT)
Message-ID: <c4602c0f-76b1-c9a4-f7f1-1f5a02a56564@blackwall.org>
Date: Tue, 16 May 2023 11:30:53 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 1/2] bridge: Add a limit on FDB entries
Content-Language: en-US
To: Johannes Nixdorf <jnixdorf-oss@avm.de>
Cc: netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Roopa Prabhu <roopa@nvidia.com>
References: <20230515085046.4457-1-jnixdorf-oss@avm.de>
 <e8d98be6-d540-59c6-79eb-353715625ea5@blackwall.org>
 <ZGM64ODoVwK8J4u2@u-jnixdorf.ads.avm.de>
From: Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <ZGM64ODoVwK8J4u2@u-jnixdorf.ads.avm.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 16/05/2023 11:12, Johannes Nixdorf wrote:
[snip]
>>>  		return -EMSGSIZE;
>>>  
>>>  #ifdef CONFIG_BRIDGE_VLAN_FILTERING
>>> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
>>> index 2119729ded2b..64fb359c6e3e 100644
>>> --- a/net/bridge/br_private.h
>>> +++ b/net/bridge/br_private.h
>>> @@ -494,6 +494,8 @@ struct net_bridge {
>>>  #endif
>>>  
>>>  	struct rhashtable		fdb_hash_tbl;
>>> +	u32				fdb_n_entries;
>>> +	u32				fdb_max_entries;
>>
>> These are not critical, so I'd use 4 byte holes in net_bridge and pack it better
>> instead of making it larger.
> 
> For a v2 I now moved it into (conditional) holes now in front of
> CONFIG_BRIDGE_VLAN_FILTERING (only a hole if it is enabled) and
> CONFIG_SWITCHDEV (only a hole if it is disabled). I could not find any
> other holes, but please tell me if you had any others in mind.
> 

Just please don't add them in the first 64 bytes (first cache line) as we use that
in the hot path and keep it for variables used there. I'd say use any of the other
4 byte holes and just add both, so another 4 byte hole would be left after the second one.

>>>  	struct list_head		port_list;
>>>  #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
>>>  	union {
>>
> 
> Thanks for your detailed feedback.


