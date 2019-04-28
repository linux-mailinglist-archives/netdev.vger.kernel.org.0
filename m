Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8184BD9E9
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 01:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbfD1XL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Apr 2019 19:11:29 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:46778 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbfD1XL3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Apr 2019 19:11:29 -0400
Received: by mail-pl1-f196.google.com with SMTP id o7so4164193pll.13
        for <netdev@vger.kernel.org>; Sun, 28 Apr 2019 16:11:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=i68kP35mQ2ktsZl9Xjdd+WM1pXfQesqaWFe80pvByMM=;
        b=RvL0X4OWCnnxqLOVSM1vHOZ3yMNyo+xOzv793MEa7iiXewpKsiELfGohgQDt3Xb54g
         1Es0PSKU2jhqvs+rEgtLBm0f3yep5f7rV0mxWjOvCUuA2yO+7Whz5b9F/WDBUqXVztXS
         HBdSgStM9yofpewfk/1q+UOjNg7DDyy+6SiVY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=i68kP35mQ2ktsZl9Xjdd+WM1pXfQesqaWFe80pvByMM=;
        b=QMSlyvvPrOz80NOb9iEB49AVOnCyEqAhZ4Vl10dbhyAF7rNm8yoyWNdVKLtzxdpP3V
         emsFRCJ1qXc9U5LCZTLv/6f5L4sLGIUc7HQwuHgbByPsk54VrtoZzlhjUyO/u1g5MlB2
         0RYvAJyqWFMqE6FCquCHdGg9AJVD6Ggy7Vj8Nb65lsOg5RufJWlG4pZiAx3aoxBolvyv
         JJd1paJxFgL8mptki3P9a9yQsE7zjNPv5LZftSpS1DJBB0u1665anc7rD/1kSUUGWnd9
         q8WtVAFlOzk4ME/Ztyd9JNRz2ZXMXn2kPf1c5UCPMXjUTzz+UGYnXMXdY9QHVEEVAMBv
         IKLg==
X-Gm-Message-State: APjAAAUx5BWP+oraVEwIgfFJ+KRy4hfISg71/LJbIMNXIsgBLFyZI/JB
        VYFO4mLOODKzV3H1mKPeIQ6HAA==
X-Google-Smtp-Source: APXvYqx/FlxUuEgl6uTfgSMNBSre7o2nIFnl97M0Je1kuRNCdwGN5MXsKPSHu6x+rE19qRvvoyqfWQ==
X-Received: by 2002:a17:902:a503:: with SMTP id s3mr54304977plq.16.1556493088801;
        Sun, 28 Apr 2019 16:11:28 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:9941:e792:9d93:10f8? ([2601:282:800:fd80:9941:e792:9d93:10f8])
        by smtp.googlemail.com with ESMTPSA id s19sm39715526pfe.74.2019.04.28.16.11.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 28 Apr 2019 16:11:27 -0700 (PDT)
Subject: Re: [PATCH v2 0/5] strict netlink validation
To:     Johannes Berg <johannes@sipsolutions.net>, netdev@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>
References: <20190426120731.9241-1-johannes@sipsolutions.net>
 <e4645a8a-d48d-2e30-a7fd-17f2ffa0157b@cumulusnetworks.com>
 <fbf176535c0553666aa7a7106452eb53734de790.camel@sipsolutions.net>
From:   David Ahern <dsa@cumulusnetworks.com>
Message-ID: <f1bd62ff-1013-d6ab-adfa-8af442ede5d5@cumulusnetworks.com>
Date:   Sun, 28 Apr 2019 17:11:26 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <fbf176535c0553666aa7a7106452eb53734de790.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/28/19 1:32 PM, Johannes Berg wrote:
> On Fri, 2019-04-26 at 20:28 -0600, David Ahern wrote:
>>
>> I agree with this set and will help moving forward. As I recall it
>> requires follow up patches for each policy to set strict_start_type
>> opting in to the strict checking. With that in place new userspace on
>> old kernels will get a failure trying to configure a feature the old
>> kernel does not recognize.
> 
> Actually, that part you had already handled with nla_parse_strict() (now
> nla_parse_strict_deprecated()) - and I'm not sure we can make this even
> stricter because existing code might be setting future attributes
> already, expecting them to be ignored. This is already fishy of
> applications to expect though, but I'm not sure we really can change
> that? I don't think I'm actually changing something here, but I'm
> certainly open to suggestions - after all, when we actually do get
> around to adding that future attribute it almost certainly will have a
> different type than a (buggy) application would be using now.
> 
> However, what I did already do is that adding strict_start_type to
> policies means that all future attributes added to those policies will
> be handled in a strict fashion, i.e. if you add strict_start_type and
> then add a new u32 attribute >= strict_start_type, that new u32
> attribute will not be permitted to have a size other than 4 octets.
> 

For routes, an unknown attribute should cause the NEW/DEL command to
fail. There is a rare exception - something like RTA_PROTOCOL which is
just a passthrough, but in general the attribute is an important
modifier for the route.

With this change:

diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index b298255f6fdb..7325c0265c5b 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -645,6 +645,7 @@ int ip_rt_ioctl(struct net *net, unsigned int cmd,
struct rtentry *rt)
 }

 const struct nla_policy rtm_ipv4_policy[RTA_MAX + 1] = {
+       [RTA_UNSPEC]            = { .strict_start_type = RTA_DPORT + 1 },
        [RTA_DST]               = { .type = NLA_U32 },
        [RTA_SRC]               = { .type = NLA_U32 },
        [RTA_IIF]               = { .type = NLA_U32 },
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index b18e85cd7587..0760224927d2 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -4211,6 +4211,7 @@ void rt6_mtu_change(struct net_device *dev,
unsigned int mtu)
 }

 static const struct nla_policy rtm_ipv6_policy[RTA_MAX+1] = {
+       [RTA_UNSPEC]            = { .strict_start_type = RTA_DPORT + 1 },
        [RTA_GATEWAY]           = { .len = sizeof(struct in6_addr) },
        [RTA_PREFSRC]           = { .len = sizeof(struct in6_addr) },
        [RTA_OIF]               = { .type = NLA_U32 },

I do get that behavior - a new command using a new attribute fails on an
older kernel.

And yes, exact length checking works though with extack we do not need
to spam dmesg:

[  475.175153] netlink: 'ip': attribute type 30 has an invalid length.
