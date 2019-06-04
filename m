Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18040350C5
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 22:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbfFDURb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 16:17:31 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41666 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbfFDURb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 16:17:31 -0400
Received: by mail-pf1-f193.google.com with SMTP id q17so13361605pfq.8
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 13:17:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BBTP4mbA1qxBFzXiHdooyCFJBHJAfO3uJV870x/x2P4=;
        b=Ah/iLRMdxnnR6LtQl4K4bGYj/uprOAR1qNyfE6mYpjr9hxNU/8K8uxXbWd5OE7UF5B
         b8uT6eF/ZSs5TcFjpU8tWr9TxutoYjuTkLkkhpZ5CrP+wk3nMLcLEoI+RXOHd1+N29J8
         iaH+evImntWEpbtTEEvo5uoMxf4SYTGGxF2KBt8I3MeK4XAQyHZXfFE6hKDSzq8Lu31L
         0tnInezRM1judOtukIvnJvgz2sO/FBYHYpS8xZs0fhmHdfPiB34pzHXOjhgmto9EgkvG
         eMZpGzAjHey5cRhcuZ81MsfoZffDpQe+7R6Yrjn2YqaO9miA3KvpEeVy286F94QmUf4e
         Twkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BBTP4mbA1qxBFzXiHdooyCFJBHJAfO3uJV870x/x2P4=;
        b=e1bZ/eqWQuy2WIfNNrcZdTvHN6nB1hm833njazQjt/gKsYNqsQOYAbmA+Xku2HCnX2
         DITqx++CA51Ii5AQ8PYxwGtu0g2S9qVZCAMlR17jl4+ntKrj3ed9366Nyfe95D/KHZkE
         YJx2uHoFspH4pGPT5dmtza/uSAq2o3plFrlVQqoy2lcE0S03sIeN+F0+lz4OBFftzDpu
         NvCu4Pigr4Ia7s2rxoxmaFtbiVGN9NvE7gMlkwvcJhlfrK2kxZ7SBHrOqBg5002z+GAF
         q+EN2dJwAw9shUw4tlcWE0glaL9ZS8NFvwFVmvwVGAnQWfGQF44LiZ5FKPKpaja7SprA
         zgxA==
X-Gm-Message-State: APjAAAVrOBuEa+sJY6qu1WFnAp2ytEb5Hjr2wE02VWS4NZXiRVHwjfg0
        /vpGCE/6dlOeQQDUsdksjkI=
X-Google-Smtp-Source: APXvYqyP41kzVSwV+bVIWQuvcnjXNRCR9rW2dm8bZu7Vj1lYNxkVniF14oOGs/W0+5ogcFyNdRrbRw==
X-Received: by 2002:a63:1d02:: with SMTP id d2mr516797pgd.26.1559679450941;
        Tue, 04 Jun 2019 13:17:30 -0700 (PDT)
Received: from [172.27.227.186] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id p20sm30051354pgk.7.2019.06.04.13.17.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 13:17:30 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 4/7] ipv6: Plumb support for nexthop object in
 a fib6_info
To:     Martin Lau <kafai@fb.com>
Cc:     Wei Wang <weiwan@google.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>
References: <20190603040817.4825-1-dsahern@kernel.org>
 <20190603040817.4825-5-dsahern@kernel.org>
 <CAEA6p_AgK08iXuSBbMDqzatGaJj_UFbNWiBV-dQp2r-Y71iesw@mail.gmail.com>
 <dec5c727-4002-913f-a858-362e0d926b8d@gmail.com>
 <CAEA6p_Aa2eV+jH=H9iOqepbrBLBUvAg2-_oD96wA0My6FMG_PQ@mail.gmail.com>
 <5263d3ae-1865-d935-cb03-f6dfd4604d15@gmail.com>
 <CAEA6p_CixzdRNUa46YZusFg-37MFAVqQ8D09rxVU5Nja6gO1SA@mail.gmail.com>
 <4cdcdf65-4d34-603e-cb21-d649b399d760@gmail.com>
 <20190604005840.tiful44xo34lpf6d@kafai-mbp.dhcp.thefacebook.com>
 <453565b0-d08a-be96-3cd7-5608d4c21541@gmail.com>
 <20190604052929.4mlxa5sswm46mwrq@kafai-mbp.dhcp.thefacebook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c7fb6999-16a2-001d-8e9a-ac44ed9e9fa2@gmail.com>
Date:   Tue, 4 Jun 2019 14:17:28 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190604052929.4mlxa5sswm46mwrq@kafai-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/3/19 11:29 PM, Martin Lau wrote:
> On Mon, Jun 03, 2019 at 07:36:06PM -0600, David Ahern wrote:
>> On 6/3/19 6:58 PM, Martin Lau wrote:
>>> I have concern on calling ip6_create_rt_rcu() in general which seems
>>> to trace back to this commit
>>> dec9b0e295f6 ("net/ipv6: Add rt6_info create function for ip6_pol_route_lookup")
>>>
>>> This rt is not tracked in pcpu_rt, rt6_uncached_list or exception bucket.
>>> In particular, how to react to NETDEV_UNREGISTER/DOWN like
>>> the rt6_uncached_list_flush_dev() does and calls dev_put()?
>>>
>>> The existing callers seem to do dst_release() immediately without
>>> caching it, but still concerning.
>>
>> those are the callers that don't care about the dst_entry, but are
>> forced to deal with it. Removing the tie between fib lookups an
>> dst_entry is again the right solution.
> Great to know that there will be a solution.  It would be great
> if there is patch (or repo) to show how that may look like on
> those rt6_lookup() callers.

Not 'will be', 'there is' a solution now. Someone just needs to do the
conversions and devise the tests for the impacted users.
