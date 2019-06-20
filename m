Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E43C4DA17
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 21:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726215AbfFTTVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 15:21:42 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:47015 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725993AbfFTTVm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 15:21:42 -0400
Received: by mail-io1-f65.google.com with SMTP id i10so30975iol.13
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 12:21:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=doFuf7onE1P54BGFmBlaNCzAkdABdToSNU8H2ymfIME=;
        b=t/RdPzPxE0SpgvbaNjXgy0VZK1rQ+PWhWxbUmIPAGja28KeFynLi6n2K5G3KPrDa2V
         jHyeD0OB0SkvJqUpktAFTFugVKbntsLJhmFu4tAFy0Wl2WeG8nc1czYCPcsQzzR79HVe
         jzOSUOjLua8Cg5KPRwM48Uj1EdqCxErKa8DFnu9SsDsTwQbUToK2I2voVM9ukybWkJEX
         714KuuFx8dxQSebkUxeYFPmUVZgDZxJnR7EdNAlqJ4RzHOdCo5Cl3xkpy2nIlo9xTif5
         yRNonUZTqZtxoZSGAHJ5wUVQYmlwpOP1zCQYNnVysoR8g0bUbr8PP+gq+Sk7gTkOGOsv
         yOMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=doFuf7onE1P54BGFmBlaNCzAkdABdToSNU8H2ymfIME=;
        b=kz6Sxv9JS5W9PYqWn33hy4O5P3mLTUJaAxqCTXt5rpbCuAQewk+Tql/yOuqwlVgrxI
         GfkirCNWlHHIaCmEyj1FEaaMxwB8xOdc/rsjAMHVcIZFbV27Ab9aHS60xz7Dq99+z3xf
         kJatB+AzQ1yXqrN5REmQCCWZvK7GxhHABebjB5kC1CSls8NhQ/a+MGTXW7O2oCe/CkRC
         iHsyjqvwOIu5O7KkxW+U8+PeQJYfUzvBwVv5Zh0eCmqupcRc/s2W/lQju/gVx/t65O+g
         yp/W0ggn1GrVcUbB1HW8BZqxJGBSzwelgLEl5HA2r4X0VuJaIBK2ZsIDPTBUsJ/IIwYc
         kiXQ==
X-Gm-Message-State: APjAAAVKq1Mdr9+MO/LIH+Cv2Zieu6NpnhVDJ2m7kqHM53LK5fXDkI1T
        zTlleMQMASNc6HHDcaUyl9FJrftU
X-Google-Smtp-Source: APXvYqxjqG9S7F6lq6QgqUsiBScYRYtWzWlNm6jV78BPKxnkHQYAdld6B1029CiTcqsVXMFZ3wSc8Q==
X-Received: by 2002:a02:c7c9:: with SMTP id s9mr102709884jao.82.1561058500498;
        Thu, 20 Jun 2019 12:21:40 -0700 (PDT)
Received: from ?IPv6:2601:284:8200:5cfb:9c46:f142:c937:3c50? ([2601:284:8200:5cfb:9c46:f142:c937:3c50])
        by smtp.googlemail.com with ESMTPSA id p63sm972900iof.45.2019.06.20.12.21.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 12:21:39 -0700 (PDT)
Subject: Re: [PATCH net-next v6 04/11] ipv4: Dump route exceptions if
 requested
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     David Miller <davem@davemloft.net>, Jianlin Shi <jishi@redhat.com>,
        Wei Wang <weiwan@google.com>, Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        netdev@vger.kernel.org
References: <cover.1560987611.git.sbrivio@redhat.com>
 <b5aacd9a3a3f4b256dfd091cdd8771d0f6a1aea2.1560987611.git.sbrivio@redhat.com>
 <777387d8-fa15-388e-875a-02aa5df977dd@gmail.com>
 <20190620210113.6aa2c022@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <8bbfc49b-79a1-6a0a-bf7b-9e4ee723ee1b@gmail.com>
Date:   Thu, 20 Jun 2019 13:21:35 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190620210113.6aa2c022@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/20/19 1:01 PM, Stefano Brivio wrote:
>>> diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
>>> index 94e5d83db4db..03f51e5192e5 100644
>>> --- a/net/ipv4/fib_trie.c
>>> +++ b/net/ipv4/fib_trie.c
>>> @@ -2078,28 +2078,51 @@ void fib_free_table(struct fib_table *tb)
>>>  	call_rcu(&tb->rcu, __trie_free_rcu);
>>>  }
>>>  
>>> +static int fib_dump_fnhe_from_leaf(struct fib_alias *fa, struct sk_buff *skb,
>>> +				   struct netlink_callback *cb,
>>> +				   int *fa_index, int fa_start)
>>> +{
>>> +	struct fib_info *fi = fa->fa_info;
>>> +	int nhsel;
>>> +
>>> +	if (!fi || fi->fib_flags & RTNH_F_DEAD)
>>> +		return 0;
>>> +
>>> +	for (nhsel = 0; nhsel < fib_info_num_path(fi); nhsel++) {
>>> +		int err;
>>> +
>>> +		err = fnhe_dump_buckets(fa, nhsel, skb, cb, fa_index, fa_start);
>>> +		if (err)
>>> +			return err;
>>> +	}
>>> +
>>> +	return 0;
>>> +}  
>>
>> fib_info would be the better argument to pass in to the fnhe dump, and
> 
> ...we need to pass the table ID to rt_fill_info(). Sure, I can pass
> that explicitly, but doing so kind of tells me I'm not passing the
> right argument, with sufficient information. What do you think?

I think that is preferable to passing fib_alias.

> 
>> I think the loop over where the bucket is should be in route.c as well.
>> So how about fib_info_dump_fnhe() as the helper exposed from route.c,
>> and it does the loop over nexthops and calls fnhe_dump_buckets.
> 
> Yes, I could do that conveniently if I'm passing a fib_info there. I'm
> stlll undecided if it's worth it, I guess I don't really have a
> preference.
> 
>> As for the loop, you could fill an skb without finishing a bucket inside
>> of a nexthop so you need top track which nexthop is current as well.
> 
> I think this is not a problem, and also checked that selftests trigger
> this. Buckets are transparent to the counter for partial dumps (s_fa),
> they are just an arbitrary grouping from that perspective, just like
> items on the chain for the same bucket.
> 
> Take this example, s_i values in [], s_fa values in ():
> 
>   node (fa) #1 [1]
>     nexthop #1
>     bucket #1 -> #0 in chain (1)
>     bucket #2 -> #0 in chain (2) -> #1 in chain (3) -> #2 in chain (4)
>     bucket #3 -> #0 in chain (5) -> #1 in chain (6)
> 
>     nexthop #2
>     bucket #1 -> #0 in chain (7) -> #1 in chain (8)
>     bucket #2 -> #0 in chain (9)
>   --
>   node (fa) #2 [2]
>     nexthop #1
>     bucket #1 -> #0 in chain (1) -> #1 in chain (2)
>     bucket #2 -> #0 in chain (3)
> 
> 
> If I stop at (3), (4), (7) for "node #1", or at (2) for "node #2", it
> doesn't really matter, because nexthops and buckets are always
> traversed in the same way (walking flattens all that).
> 
> For IPv4, I could even drop the in-tree/in-node distinction (s_i/s_fa).
> But accounting becomes terribly inconvenient though, and it would be
> inconsistent with what I needed to do for IPv6 (skip/skip_in_node): we
> have 'sernum' there, which is used to mark what node we need to restart
> from in case of changes. Within a node, however, I can't make any
> assumptions like that, so if the fib6 tree changes, I'll restart from
> the beginning of the node (see discussion with Martin on v1).
> 
> My idea would be to keep it like it is at the moment, and later make it
> as "accurate" as it is on IPv6, introducing something like 'sernum'. If
> we start with this, it will be more convenient to do that later.
> 

ok, if you have it covered. can you add that description above to the
commit message. Be good to capture how it is covered.

