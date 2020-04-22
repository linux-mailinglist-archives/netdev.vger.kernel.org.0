Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7A3C1B47ED
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 16:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbgDVO4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 10:56:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727069AbgDVO43 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 10:56:29 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70758C03C1A9
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 07:56:29 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id mq3so1039624pjb.1
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 07:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=cJMFTGsb3fkV1xXGdQYacTP3uNP3RmYzCrCOpiwE2HQ=;
        b=IK/YIoz3JVZFDuKm+FCe2A5AykugcXRUcdDCVptfsdlRg5FcPrls+Bb5bkkqu1Wegi
         1zPGM0LtXqpfRJVN9qAgkzAFdDZ64X6XaKJo+tftagtz8KGspkLpomnbsODEapLyF/Hd
         eHYp9n+3KyHgtKcOEIRIZ80vabIwta/DiUFofreo/IF/sSKGUCkmDXXK54D8kMVHzWAt
         TlqpPbiNT+QY+et4YOBSLmjHNL+Aq+lI1mxkHfBLoPMfPGz1kwsN981L2lVRT9m4pYTb
         wkW5kfG2SFVRa0E0S9whrUA7QgZPvs4eWrn5L06NLeLfvAf76pIW8g7lSWJdRRJe8EOL
         u/xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=cJMFTGsb3fkV1xXGdQYacTP3uNP3RmYzCrCOpiwE2HQ=;
        b=N9KZ3AhuYSwJYzK374FwKIqx5HkKWXqxXDz4XFDR9m57/7lG9i751PHTjv8zsw91pF
         K6YMCliOcN6x+0yIs7H/XLWUkCi0LpqpoKMh06sw3ycTRvyHRcOrk1rcyxcLG27ml8zR
         D7q5O83E6srhYF2dbTZ9+BWadmxyVh5oZqY/vGjZMTNDkG1834HFd8JRfOzL+7g15h7S
         JoMJ0FLJHwwdPhmXoWlYFcqu3Pv6RIWoGBBPU8sv4qvhHY3d3Q9qWD5SkOjL+lINwb2p
         eveg43njOAKj8xkB8zpK1GHTxKxIEg/i/YbA4Bqx7DhgfR9Jnk0Ky+7g1+6B0WQBeZHv
         +VeA==
X-Gm-Message-State: AGi0PuaRoyntpqrshkddUGNEkBtt4tdRZx+bH52UO5S6jZZamxpA3pdf
        LHSYhpjwlVP4UdlLVPwdQuo=
X-Google-Smtp-Source: APiQypJiOpvo2NH/QPYWYtyeK1LGPRZWLxzwU0scOR5CTzLwBu8cnJxthubGruPRs4sKc27qeEIDqQ==
X-Received: by 2002:a17:90a:30e7:: with SMTP id h94mr11385679pjb.186.1587567388892;
        Wed, 22 Apr 2020 07:56:28 -0700 (PDT)
Received: from host ([154.223.71.61])
        by smtp.gmail.com with ESMTPSA id o99sm5773699pjo.8.2020.04.22.07.56.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 22 Apr 2020 07:56:27 -0700 (PDT)
Date:   Wed, 22 Apr 2020 22:56:21 +0800
From:   Bo YU <tsu.yubo@gmail.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     matthieu.baerts@tessares.net, davem@davemloft.net, kuba@kernel.org,
        mathew.j.martineau@linux.intel.com, netdev@vger.kernel.org,
        mptcp@lists.01.org
Subject: Re: [PATCH V2 -next] mptcp/pm_netlink.c : add check for
 nla_put_in/6_addr
Message-ID: <20200422145618.b5qshinlmi26i6ko@host>
References: <20200422013433.qzlthtmx4c7mmlh3@host>
 <f82e4d00d4d4680994f0885c55831b2e9a2299c1.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
In-Reply-To: <f82e4d00d4d4680994f0885c55831b2e9a2299c1.camel@redhat.com>
User-Agent: NeoMutt/20171215
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 22, 2020 at 12:12:27PM +0200, Paolo Abeni wrote:
>On Wed, 2020-04-22 at 09:34 +0800, Bo YU wrote:
>> Normal there should be checked for nla_put_in6_addr like other
>> usage in net.
>>
>> Detected by CoverityScan, CID# 1461639
>>
>> Fixes: 01cacb00b35c("mptcp: add netlink-based PM")
>> Signed-off-by: Bo YU <tsu.yubo@gmail.com>
>> ---
>> V2: Add check for nla_put_in_addr suggested by Paolo Abeni
>
>Thank you for addressing my feedback!
>
>> ---
>>  net/mptcp/pm_netlink.c | 11 +++++++----
>>  1 file changed, 7 insertions(+), 4 deletions(-)
>>
>> diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
>> index 86d61ab34c7c..0a39f0ebad76 100644
>> --- a/net/mptcp/pm_netlink.c
>> +++ b/net/mptcp/pm_netlink.c
>> @@ -599,12 +599,15 @@ static int mptcp_nl_fill_addr(struct sk_buff *skb,
>>  	    nla_put_s32(skb, MPTCP_PM_ADDR_ATTR_IF_IDX, entry->ifindex))
>>  		goto nla_put_failure;
>>
>> -	if (addr->family == AF_INET)
>> +	if (addr->family == AF_INET &&
>>  		nla_put_in_addr(skb, MPTCP_PM_ADDR_ATTR_ADDR4,
>> -				addr->addr.s_addr);
>> +				addr->addr.s_addr))
>> +		goto nla_put_failure;
>> +
>
>I'm very sorry about the nit-picking, but the above is now a single
>statement, and indentation should be adjusted accordingly:
>'nla_put_in_addr()' should be aligned with 'addr->family'.
Ok, but i just want to make clear for that, do you mean:


	if (addr->family == AF_INET && nla_put_in_addr(skb,
			MPTCP_PM_ADDR_ATTR_ADDR4, addr->addr.s_addr))

In fact, i was upset by checkpatch about over 80 chars warning.
This is my originally version patch to fix it :(. If i was wrong
to understand your means, please  correct me. Thank you.

>
>The same applies to the chunk below.
>
>>  #if IS_ENABLED(CONFIG_MPTCP_IPV6)
>> -	else if (addr->family == AF_INET6)
>> -		nla_put_in6_addr(skb, MPTCP_PM_ADDR_ATTR_ADDR6, &addr->addr6);
>> +	else if (addr->family == AF_INET6 &&
>> +		nla_put_in6_addr(skb, MPTCP_PM_ADDR_ATTR_ADDR6, &addr->addr6))
>> +		goto nla_put_failure;
>>  #endif
>>  	nla_nest_end(skb, attr);
>>  	return 0;
>
>Otherwise LGTM, thanks!
>
>Paolo
>
