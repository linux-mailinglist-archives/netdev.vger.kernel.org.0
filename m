Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA391277432
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 16:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728273AbgIXOl4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 10:41:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728217AbgIXOl4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 10:41:56 -0400
Received: from mail-oo1-xc35.google.com (mail-oo1-xc35.google.com [IPv6:2607:f8b0:4864:20::c35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B4ECC0613CE
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 07:41:56 -0700 (PDT)
Received: by mail-oo1-xc35.google.com with SMTP id r10so845827oor.5
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 07:41:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Zk1+q+hZj4nhxSPQHL+w1fjhMNXwWhW4NNOjLHy/5l0=;
        b=PMVgNPzUwcqPHzbbBcKi87pdFHUn/Qj2j3pBInA96oAWVRiSSsCrMK21rakzh7ICHR
         aU4J79z4NIOlaVrMRVgY7koSBUxSGs7+MImX9E32Rm8OTuV0J7EoPb6bFptq4XWjn3Dm
         bHD3AGcRLidAcrImgWJztDSIh/8qVAmY3GCxnm5Uux9Z92SoV87DVMssimRSTJzVyqLo
         oNiNks30T/mDMsRnvFuuxm5FpjPVmIBlFovYN1+W2rToO3Q1an3AGi+bVAMg/TGuvh5Z
         CpUQj/47vovbB3ur07iBwzvBRMhn78FQLqXoPdTawEWABd/7XgPuLN0DFZQw2k+uvLAA
         pGUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Zk1+q+hZj4nhxSPQHL+w1fjhMNXwWhW4NNOjLHy/5l0=;
        b=uFJ5bjgUD5B06GKYoa7MQZiNhucz7q0IGuyxQEiTIj67O90GSD2o/ZWLVKbKy1jQCQ
         is9wz0tZNnDh/VzkMyEYaBkd34TMMsk4EYywoJlCziR++qJdWnVgsoT7q03UB6nDEVX3
         KvQ2xTREOECsmAQ1pRev5yzB2iczQ9dqbnhXhzbIi53DzLQScd6G/IeGGXtGYBSjFkO4
         HNsaJQ3MzNWxtYTl3UUkCUhSQPu+rYa5ou4s7VQ+ByhhlG2SO8X/QZUttinFHZdm7CIe
         cMzFhgU29VQydlVlco8Guo583ZVMjKVnppW9bYrQuf58mI0MTCb4uqhRGZbNyLIra8rq
         ZUeA==
X-Gm-Message-State: AOAM530k/P83tTMRtgPdBncmCjFjbVStagj0EDUW5SE9lupwh65gIZ9q
        Yb7qzQzmQf6qjNXQY/sNW/NLpg/cHYjvKw==
X-Google-Smtp-Source: ABdhPJxSfThbUHx388AgSIFkjPULfdqBbYnJDceTD5rDrUyN294qJFYUIBXrfu2Tkpwtks6L2Lyjtg==
X-Received: by 2002:a4a:bd90:: with SMTP id k16mr3679948oop.16.1600958515568;
        Thu, 24 Sep 2020 07:41:55 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:5df2:2ea:febc:9ae2])
        by smtp.googlemail.com with ESMTPSA id 187sm676898oie.42.2020.09.24.07.41.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Sep 2020 07:41:54 -0700 (PDT)
Subject: Re: ip rule iif oif and vrf
To:     Stephen Suryaputra <ssuryaextr@gmail.com>
Cc:     netdev@vger.kernel.org
References: <20200922131122.GB1601@ICIPI.localdomain>
 <2bea9311-e6b6-91ea-574a-4aa7838d53ea@gmail.com>
 <20200923235002.GA25818@ICIPI.localdomain>
 <ccba2d59-58ad-40ca-0a09-b55c90e9145e@gmail.com>
 <20200924134845.GA3688@ICIPI.localdomain>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <97ce9942-2115-ed3a-75ea-8b58aa799ceb@gmail.com>
Date:   Thu, 24 Sep 2020 08:41:54 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200924134845.GA3688@ICIPI.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/24/20 7:48 AM, Stephen Suryaputra wrote:
> On Wed, Sep 23, 2020 at 07:47:16PM -0600, David Ahern wrote:
>> If I remove the fib rules and add VRF route leaking from core to tenant
>> it works. Why is that not an option? Overlapping tenant addresses?
> 
> Exactly.
> 
>> One thought to get around it is adding support for a new FIB rule type
>> -- say l3mdev_port. That rule can look at the real ingress device which
>> is saved in the skb->cb as IPCB(skb)->iif.
> 
> OK. Just to ensure that the existing ip rule behavior isn't considered a
> bug.
> 
> We have multiple options on the table right now. One that can be done
> without writing any code is to use an nft prerouting rule to mark
> the packet with iif equals the tunnel and use ip rule fwmark to lookup
> the right table.
> 
> ip netns exec r0 nft add table ip c2t
> ip netns exec r0 nft add chain ip c2t prerouting '{ type filter hook prerouting priority 0; policy accept; }'
> ip netns exec r0 nft rule ip c2t prerouting iif gre01 mark set 101 counter
> ip netns exec r0 ip rule add fwmark 101 table 10 pref 999
> 
> ip netns exec r1 nft add table ip c2t
> ip netns exec r1 nft add chain ip c2t prerouting '{ type filter hook prerouting priority 0; policy accept; }'
> ip netns exec r1 nft rule ip c2t prerouting iif gre10 mark set 101 counter
> ip netns exec r1 ip rule add fwmark 101 table 10 pref 999
> 
> But this doesn't seem to work on my Ubuntu VM with the namespaces
> script, i.e. pinging from h0 to h1. The packet doesn't egress r1_v11. It
> does work on our target, based on 4.14 kernel.

add debugs to net/core/fib_rules.c, fib_rule_match() to see if
flowi_mark is getting set properly. There could easily be places that
are missed. Or if it works on one setup, but not another compare sysctl
settings for net.core and net.ipv4

> 
> We also notice though in on the target platform that the ip rule fwmark
> doesn't seem to change the skb->dev to the vrf of the lookup table.

not following that statement. fwmark should be marking the skb, not
changing the skb->dev.

> E.g., ping from 10.0.0.1 to 11.0.0.1. With net.ipv4.fwmark_reflect set,
> the reply is generated but the originating ping application doesn't get
> the packet.  I suspect it is caused by the socket is bound to the tenant
> vrf. I haven't been able to repro this because of the problem with the
> nft approach above.
> 
> Thanks,
> Stephen.
> 

