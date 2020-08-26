Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE8CB25386F
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 21:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727786AbgHZTlL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 15:41:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726723AbgHZTlK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 15:41:10 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68763C061574;
        Wed, 26 Aug 2020 12:41:10 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id t13so2836231ile.9;
        Wed, 26 Aug 2020 12:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+N/+NIRAXypVf/WOhOh1869gebLdqn4kYppUBPHpbOA=;
        b=fW4Q3BBV/1kgmDW2x7cKgOQEBnAjwOc9xEEv6qh/Ibhk5QxgnJBC81ifUFAbpzPu4/
         dfr5JzCINNWslrnd2XcwcTdyja4RHzeez1Byb5FIVCEu1XYVzMD7X70cN7fWxM1iZfbL
         oYe56B7NNE6aaMHOwFq/smzSUgXWw5MJz0rIhNqNmNWClBO2VE/Zc8M4/UDyh5CJxfMF
         aL1rlWikX4W2NQN2VycOUeg1ybTCdCo4q2qrMujyYG03h1U8CarqtvjAS37SCn+ND05J
         uVfz5rhi2HtqZtedo7CbVz5Gk2nvY3K7/m0UvLI7D4iLEpmaLWQ3+6mFOt8RmLAfRaEU
         AlnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+N/+NIRAXypVf/WOhOh1869gebLdqn4kYppUBPHpbOA=;
        b=qDlLzpyiifLNXL0LBu2qiI3f+kjomUX7x+qONZMEoFIUFF8wx6PflCEGSMWvbXhpbQ
         Eeh7JJLqbz4W5Dfmjkp/NuUM8ulW6JWz2KjSdqkIPx/fKVNwT5+v7TBG6gy1mFSLhIZQ
         rL9PGgkwG/kgIwEN9bEwYZ4TVFeFy7aundAoQcEAQZd+x8kr7ke92AMs+MHaTIz1Jvzr
         sfCM3bWdRKLqDKrTWYRoaiR/HLxC0C3+osXLI21PAcwjvFsN3/AViC/i/UNUITqjU61N
         u4u0umefjqExLOsVT/JSbLIdpu/KtyfdACclRTFhW5u7tqjhzYgtl/ew8G3Ihuvwx8HI
         auGQ==
X-Gm-Message-State: AOAM5304SwgAeTuksB+jzjQGkWSHeGdkS0CdDinqHh3FVdtQn72IUgdL
        RYbeMWkqBnRVzAW+7+dCfPQ=
X-Google-Smtp-Source: ABdhPJx8Jev2jomN4ZVBesMpkBRjx/QzweWvALpiH8/lBFJiqnOw6/FpNb7olR9Z7oZI/7wzp82JlQ==
X-Received: by 2002:a92:1fd9:: with SMTP id f86mr14778849ilf.250.1598470869675;
        Wed, 26 Aug 2020 12:41:09 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:305a:ae30:42e4:e2ca])
        by smtp.googlemail.com with ESMTPSA id o2sm1938681ili.83.2020.08.26.12.41.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Aug 2020 12:41:08 -0700 (PDT)
Subject: Re: [net-next v5 1/2] seg6: inherit DSCP of inner IPv4 packets
To:     Ahmed Abdelsalam <ahabdels@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     andrea.mayer@uniroma2.it
References: <20200825160236.1123-1-ahabdels@gmail.com>
 <efaf3273-e147-c27e-d5b8-241930335b82@gmail.com>
 <75f7be67-2362-e931-6793-1ce12c69b4ea@gmail.com>
 <71351d27-0719-6ed9-f5c6-4aee20547c58@gmail.com>
 <ab0869f7-9e69-b6fd-af5c-8e3ce432452b@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <2c6bad0c-cd6f-b5d7-f921-a40db4a2e9ee@gmail.com>
Date:   Wed, 26 Aug 2020 13:41:07 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <ab0869f7-9e69-b6fd-af5c-8e3ce432452b@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/26/20 6:12 AM, Ahmed Abdelsalam wrote:
> 
> On 26/08/2020 02:45, David Ahern wrote:
>> On 8/25/20 5:45 PM, Ahmed Abdelsalam wrote:
>>>
>>> Hi David
>>>
>>> The seg6 encap is implemented through the seg6_lwt rather than
>>> seg6_local_lwt.
>>
>> ok. I don't know the seg6 code; just taking a guess from a quick look.
>>
>>> We can add a flag(SEG6_IPTUNNEL_DSCP) in seg6_iptunnel.h if we do not
>>> want to go the sysctl direction.
>>
>> sysctl is just a big hammer with side effects.
>>
>> It struck me that the DSCP propagation is very similar to the TTL
>> propagation with MPLS which is per route entry (MPLS_IPTUNNEL_TTL and
>> stored as ttl_propagate in mpls_iptunnel_encap). Hence the question of
>> whether SR could make this a per route attribute. Consistency across
>> implementations is best.
>> SRv6 does not have an issue of having this per route.
> Actually, as SRv6 leverage IPv6 encapsulation, I would say it should
> consistent with ip6_tunnel not MPLS.
> 
> In ip6_tunnel, both ttl and flowinfo (tclass and flowlabel) are provided.
> 
> Ideally, SRv6 code should have done the same with:
> TTL       := VLAUE | DEFAULT | inherit.
> TCLASS    := 0x00 .. 0xFF | inherit
> FLOWLABEL := { 0x00000 .. 0xfffff | inherit | compute.
> 

New attributes get added all the time. Why does something like this now
work for these features:

diff --git a/include/uapi/linux/seg6_iptunnel.h
b/include/uapi/linux/seg6_iptunnel.h
index eb815e0d0ac3..b628333ba100 100644
--- a/include/uapi/linux/seg6_iptunnel.h
+++ b/include/uapi/linux/seg6_iptunnel.h
@@ -20,6 +20,8 @@
 enum {
        SEG6_IPTUNNEL_UNSPEC,
        SEG6_IPTUNNEL_SRH,
+       SEG6_IPTUNNEL_TTL,      /* u8 */
+       SEG6_IPTUNNEL_TCLASS,   /* u8 */
        __SEG6_IPTUNNEL_MAX,
 };
 #define SEG6_IPTUNNEL_MAX (__SEG6_IPTUNNEL_MAX - 1)
diff --git a/net/ipv6/seg6_iptunnel.c b/net/ipv6/seg6_iptunnel.c
index 897fa59c47de..7cb512b65bc3 100644
--- a/net/ipv6/seg6_iptunnel.c
+++ b/net/ipv6/seg6_iptunnel.c
@@ -46,6 +46,11 @@ static size_t seg6_lwt_headroom(struct
seg6_iptunnel_encap *tuninfo)

 struct seg6_lwt {
        struct dst_cache cache;
+       u8      ttl_propagate;  /* propagate ttl from inner header */
+       u8      default_ttl;    /* ttl value to use */
+       u8      tclass_inherit; /* inherit tclass from inner header */
+       u8      tclass;         /* tclass value to use */
+
        struct seg6_iptunnel_encap tuninfo[];
 };

@@ -61,7 +66,10 @@ seg6_encap_lwtunnel(struct lwtunnel_state *lwt)
 }

 static const struct nla_policy seg6_iptunnel_policy[SEG6_IPTUNNEL_MAX +
1] = {
-       [SEG6_IPTUNNEL_SRH]     = { .type = NLA_BINARY },
+       [SEG6_IPTUNNEL_UNSPEC]          = { .strict_start_type =
SEG6_IPTUNNEL_SRH + 1 },
+       [SEG6_IPTUNNEL_SRH]             = { .type = NLA_BINARY },
+       [SEG6_IPTUNNEL_TTL]             = { .type = NLA_U8 },
+       [SEG6_IPTUNNEL_TCLASS]          = { .type = NLA_U8 },
 };

 static int nla_put_srh(struct sk_buff *skb, int attrtype,
@@ -460,6 +468,22 @@ static int seg6_build_state(struct net *net, struct
nlattr *nla,

        memcpy(&slwt->tuninfo, tuninfo, tuninfo_len);

+       if (tb[SEG6_IPTUNNEL_TTL]) {
+               slwt->default_ttl = nla_get_u8(tb[SEG6_IPTUNNEL_TTL]);
+               slwt->ttl_propagate = slwt->default_ttl ? 0 : 1;
+       }
+       if (tb[SEG6_IPTUNNEL_TCLASS]) {
+               u32 tmp = nla_get_u32(tb[SEG6_IPTUNNEL_TCLASS]);
+
+               if (tmp == (u32)-1) {
+                       slwt->tclass_inherit = true;
+               } else if (tmp & <some valid range mask>) {
+                       error
+               } else {
+                       slwt->tclass = ...
+               }
+       }
+
        newts->type = LWTUNNEL_ENCAP_SEG6;
        newts->flags |= LWTUNNEL_STATE_INPUT_REDIRECT;


And the use the values in slwt as needed.
