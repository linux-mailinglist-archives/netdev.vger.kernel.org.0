Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 966C622A3D8
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 02:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733174AbgGWAsj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 20:48:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728607AbgGWAsj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 20:48:39 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E174BC0619DC
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 17:48:38 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id x69so3928607qkb.1
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 17:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Eu2/iLDXjQl3orB1eBGpy+4VFyvF7pQYeOjHN75uN5E=;
        b=JKev97ScTEF+tXvZ7j8ofoI3l51ZxfpqNdqkpKW6JbZ+msL6Veb3U3B0RARv9FydVn
         fAP7M8F71uBnY3s/ow4VtWgkMuiFcMlsSR1i+C8gZPX640M0gLwh+IB4LnL3xrwwzCgq
         otNRSgcz/0+eJP3BYobrOgXEMwV7j+ETLbOJXwfIIFsXNXuLrR2MdBGY8/KJSXYy4Fce
         sgbQjoKWT2tYA4lGSYTjPzMNPXERnGe/ic5uXroMS4tYFBHaUWV/0OR9iRwbyDcxcj7t
         /epJkjLm+m3MfQEOYtL89uOdeU9mHDTXfuOKxhLhtd8Hcmf1aSDpbAGUcfLfxFuAwOuF
         pjyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Eu2/iLDXjQl3orB1eBGpy+4VFyvF7pQYeOjHN75uN5E=;
        b=TpI5rsiT1Gl9FyGceEP7+2b798sZ4evNaUbsxL2Qe+Z9VoRRpRG/56dhOAkB93za9X
         z0Ve+7oTwIxCcLDtVJB5S3uIiIjc9KyncuCQrpKKIFB5DRH1uEqwFKBMy1afdi5KlCCv
         YyIPfNkvKtZsQCoQ2g5swvj2R2Yo4Q8/OC7WAntQgcwRQ4azVAF9IcnD/gyfcaEwfU28
         GC62POyBQi2SQNzhbE0ITu9TYKlisNPyblce6xfpwo9EpSXPuDpeXSw5ee5W8puN10zw
         2IPBiEDi4mvssfuMhEtr71VCOaVBsze3QHulT/jAsOO/ZJHgiBS0TlkeiHUH23ydtprn
         Sz7w==
X-Gm-Message-State: AOAM531ky1ITw1cr0pru9eBia1UTEw5Y/yKAqnWs2n16vdpacnOscElr
        K1GCMI4KgfFzqLWkKoi7VG4=
X-Google-Smtp-Source: ABdhPJxfc0irL4e2/LOwjcvejmhRdhKZ/HzddC7ZJK+1pQ8OdAA6Kvt9SKMKXPr46HckaVeqbFkLZg==
X-Received: by 2002:a37:aa87:: with SMTP id t129mr2818976qke.70.1595465317940;
        Wed, 22 Jul 2020 17:48:37 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:5c10:aafb:1d38:5735? ([2601:282:803:7700:5c10:aafb:1d38:5735])
        by smtp.googlemail.com with ESMTPSA id q65sm1312327qkf.50.2020.07.22.17.48.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jul 2020 17:48:37 -0700 (PDT)
Subject: Re: [RFC PATCH] Fix: ipv4/icmp: icmp error route lookup performed on
 wrong routing table
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        netdev <netdev@vger.kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
Cc:     David Ahern <dsa@cumulusnetworks.com>,
        "David S. Miller" <davem@davemloft.net>
References: <20200720221118.26148-1-mathieu.desnoyers@efficios.com>
 <1949069529.26392.1595438806291.JavaMail.zimbra@efficios.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c69f44ec-f1af-2caf-bb9f-c30cf32b9452@gmail.com>
Date:   Wed, 22 Jul 2020 18:48:35 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1949069529.26392.1595438806291.JavaMail.zimbra@efficios.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/22/20 11:26 AM, Mathieu Desnoyers wrote:
> Adding IPv4/IPv6 maintainers in CC, along with David Ahern's k.org email address.
> 
> ----- On Jul 20, 2020, at 6:11 PM, Mathieu Desnoyers mathieu.desnoyers@efficios.com wrote:
> 
>> As per RFC792, ICMP errors should be sent to the source host.
>>
>> However, in configurations with Virtual Forwarding and Routing tables,

FYI: you have it backwards; it is VRF as in Virtual Routing and
Forwarding, not VFR. The commit message should be update accordingly.

>> looking up which routing table to use is currently done by using the
>> destination net_device.
>>
>> commit 9d1a6c4ea43e ("net: icmp_route_lookup should use rt dev to
>> determine L3 domain") changes the interfaces passed to
>> l3mdev_master_ifindex() and inet_addr_type_dev_table() from skb_in->dev
>> to skb_dst(skb_in)->dev in order to fix a NULL pointer dereference. This
>> changes the interface used for routing table lookup from source to
>> destination. Therefore, if the source and destination interfaces are
>> within separate VFR, or one in the global routing table and the other in
>> a VFR, looking up the source host in the destination interface's routing
>> table is likely to fail.
>>
>> One observable effect of this issue is that traceroute does not work in
>> the following cases:
>>
>> - Route leaking between global routing table and VRF
>> - Route leaking between VRFs
>>
>> [ Note 1: I'm not entirely sure what routing table should be used when
>>  param->replyopts.opt.opt.srr is set ? Is it valid to honor Strict
>>  Source Route when sending an ICMP error ? ]
>>
>> [ Note 2: I notice that ipv6 icmp6_send() uses skb_dst(skb)->dev as
>>  argument to l3mdev_master_ifindex(). I'm not sure if it is correct ? ]
>>
>> [ This patch is only compile-tested. ]

please devise a test using namespaces which demonstrates the problem and
proves the change fixes it. The test can be added to
tools/testing/selftests/net/fcnal-test.sh, use_cases(). VRF route
leaking is only useful and relevant for the forwarding case, not locally
generated packets, so the test case should be based on forwarding
packets across VRFs.


>>
>> Fixes: 9d1a6c4ea43e ("net: icmp_route_lookup should use rt dev to determine L3
>> domain")
>> Link: https://tools.ietf.org/html/rfc792
>> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
>> Cc: David Ahern <dsa@cumulusnetworks.com>
>> Cc: David S. Miller <davem@davemloft.net>
>> Cc: netdev@vger.kernel.org
>> ---
>> net/ipv4/icmp.c | 12 ++++++++++--
>> 1 file changed, 10 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
>> index e30515f89802..3d1da70c7293 100644
>> --- a/net/ipv4/icmp.c
>> +++ b/net/ipv4/icmp.c
>> @@ -465,6 +465,7 @@ static struct rtable *icmp_route_lookup(struct net *net,
>> 					int type, int code,
>> 					struct icmp_bxm *param)
>> {
>> +	struct net_device *route_lookup_dev;
>> 	struct rtable *rt, *rt2;
>> 	struct flowi4 fl4_dec;
>> 	int err;
>> @@ -479,7 +480,14 @@ static struct rtable *icmp_route_lookup(struct net *net,
>> 	fl4->flowi4_proto = IPPROTO_ICMP;
>> 	fl4->fl4_icmp_type = type;
>> 	fl4->fl4_icmp_code = code;
>> -	fl4->flowi4_oif = l3mdev_master_ifindex(skb_dst(skb_in)->dev);
>> +	/*
>> +	 * The device used for looking up which routing table to use is
>> +	 * preferably the source whenever it is set, which should ensure
>> +	 * the icmp error can be sent to the source host, else fallback
>> +	 * on the destination device.
>> +	 */
>> +	route_lookup_dev = skb_in->dev ? skb_in->dev : skb_dst(skb_in)->dev;
>> +	fl4->flowi4_oif = l3mdev_master_ifindex(route_lookup_dev);
>>
>> 	security_skb_classify_flow(skb_in, flowi4_to_flowi(fl4));
>> 	rt = ip_route_output_key_hash(net, fl4, skb_in);
>> @@ -503,7 +511,7 @@ static struct rtable *icmp_route_lookup(struct net *net,
>> 	if (err)
>> 		goto relookup_failed;
>>
>> -	if (inet_addr_type_dev_table(net, skb_dst(skb_in)->dev,
>> +	if (inet_addr_type_dev_table(net, route_lookup_dev,
>> 				     fl4_dec.saddr) == RTN_LOCAL) {
>> 		rt2 = __ip_route_output_key(net, &fl4_dec);
>> 		if (IS_ERR(rt2))

I *think* this is ok, but a test case and running all of the IPv4
existing tests in fcnal-test.sh (-4 arg) would help.
