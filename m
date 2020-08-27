Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15E17254407
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 12:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727996AbgH0Kwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 06:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbgH0Kwh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 06:52:37 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E925C061264;
        Thu, 27 Aug 2020 03:52:36 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id w2so4506521wmi.1;
        Thu, 27 Aug 2020 03:52:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jJxwhY+IYNwIbcOdmq8CmgH52Cv6KCFPRAi1GTVPYJ0=;
        b=EJoACXXNjQYF+eDVuEMXZnXNV97rvHu/7KavVsmoO3VsG2bMpbN7F/nAXn3caOx1T/
         QoRqQNO8ipUsGQ8sf3g+UVNFXISOnXid1J2uksvD+9TjrOQgPe1AU/lrDEiNaTxBkJzY
         RoudHyWm+e2+oPQx5ftg8EYkW4sSMRLJISC/Ds7buM/8Yidaa5Yw9kg+h7jJO3YaNXrf
         Xbn23LryQx83eiooMySxY1Us3YulkXgZXq8b4RBbId9axkk9GF0lhzwax79Jr3X/1c7W
         4fPW488cQ5SAH72E9wwu0ElCW+vSnjp1CfvUuaCj2Q3DgWr0ISrv5ufh6i78keGyu0Pf
         gvmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jJxwhY+IYNwIbcOdmq8CmgH52Cv6KCFPRAi1GTVPYJ0=;
        b=SIGEjqClfzg/Xi8mF2L+ibVd1Xhf5YzH2hoiOYfc83BA/iBXYC9ltj2l1fdDawyzXr
         r/Gy6aL+Cp4TOS5ZsaKKt753mwwj0v0juoEjT+jIhSh8krsO1ng0L0Bn2yDAEXCsra3a
         nnt7B6S6ofEDKjnk+N2z2IzhU9rZCGC6eht2ZxUMaU/Pi8ci74+E27x3TOkvkpR/4sFd
         DgljXRW8Qa7MaUbeHnfFpoygjvtwxTbVuk3h9u2kfoFkugkr9rIPYalXSE5/HHr6SSXJ
         5HDm+gMqgcy7r602kNPQT18fCvh2Do+yVhUlQ0JbjZuIKJsZhQ+bH8bAhxYrFL0KPFPE
         Op2Q==
X-Gm-Message-State: AOAM5332QqikNOS/dUsAH/RbB1STiWviNHGsuwKWs4TeH8g1YDnbZAq3
        dJJNWVETyA98XPv3hgoqYrw=
X-Google-Smtp-Source: ABdhPJyAgQfoI6rWe6rWnjug5FY5+aK+GMzR9p/sCF33YdM8Uu3wFJhjvoEeu61+MmMzYN45FBMOeg==
X-Received: by 2002:a05:600c:2054:: with SMTP id p20mr10919859wmg.2.1598525553911;
        Thu, 27 Aug 2020 03:52:33 -0700 (PDT)
Received: from [10.55.3.147] ([173.38.220.45])
        by smtp.gmail.com with ESMTPSA id y26sm4309275wmj.23.2020.08.27.03.52.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Aug 2020 03:52:33 -0700 (PDT)
Subject: Re: [net-next v5 1/2] seg6: inherit DSCP of inner IPv4 packets
To:     David Ahern <dsahern@gmail.com>,
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
 <2c6bad0c-cd6f-b5d7-f921-a40db4a2e9ee@gmail.com>
From:   Ahmed Abdelsalam <ahabdels@gmail.com>
Message-ID: <2b7af321-c4bf-2c2a-183a-ccb6d1159855@gmail.com>
Date:   Thu, 27 Aug 2020 12:52:27 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <2c6bad0c-cd6f-b5d7-f921-a40db4a2e9ee@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 26/08/2020 21:41, David Ahern wrote:
> On 8/26/20 6:12 AM, Ahmed Abdelsalam wrote:
>>
>> On 26/08/2020 02:45, David Ahern wrote:
>>> On 8/25/20 5:45 PM, Ahmed Abdelsalam wrote:
>>>>
>>>> Hi David
>>>>
>>>> The seg6 encap is implemented through the seg6_lwt rather than
>>>> seg6_local_lwt.
>>>
>>> ok. I don't know the seg6 code; just taking a guess from a quick look.
>>>
>>>> We can add a flag(SEG6_IPTUNNEL_DSCP) in seg6_iptunnel.h if we do not
>>>> want to go the sysctl direction.
>>>
>>> sysctl is just a big hammer with side effects.
>>>
>>> It struck me that the DSCP propagation is very similar to the TTL
>>> propagation with MPLS which is per route entry (MPLS_IPTUNNEL_TTL and
>>> stored as ttl_propagate in mpls_iptunnel_encap). Hence the question of
>>> whether SR could make this a per route attribute. Consistency across
>>> implementations is best.
>>> SRv6 does not have an issue of having this per route.
>> Actually, as SRv6 leverage IPv6 encapsulation, I would say it should
>> consistent with ip6_tunnel not MPLS.
>>
>> In ip6_tunnel, both ttl and flowinfo (tclass and flowlabel) are provided.
>>
>> Ideally, SRv6 code should have done the same with:
>> TTL       := VLAUE | DEFAULT | inherit.
>> TCLASS    := 0x00 .. 0xFF | inherit
>> FLOWLABEL := { 0x00000 .. 0xfffff | inherit | compute.
>>
> 
> New attributes get added all the time. Why does something like this now
> work for these features:
> 
> diff --git a/include/uapi/linux/seg6_iptunnel.h
> b/include/uapi/linux/seg6_iptunnel.h
> index eb815e0d0ac3..b628333ba100 100644
> --- a/include/uapi/linux/seg6_iptunnel.h
> +++ b/include/uapi/linux/seg6_iptunnel.h
> @@ -20,6 +20,8 @@
>   enum {
>          SEG6_IPTUNNEL_UNSPEC,
>          SEG6_IPTUNNEL_SRH,
> +       SEG6_IPTUNNEL_TTL,      /* u8 */
> +       SEG6_IPTUNNEL_TCLASS,   /* u8 */
>          __SEG6_IPTUNNEL_MAX,
>   };
>   #define SEG6_IPTUNNEL_MAX (__SEG6_IPTUNNEL_MAX - 1)
> diff --git a/net/ipv6/seg6_iptunnel.c b/net/ipv6/seg6_iptunnel.c
> index 897fa59c47de..7cb512b65bc3 100644
> --- a/net/ipv6/seg6_iptunnel.c
> +++ b/net/ipv6/seg6_iptunnel.c
> @@ -46,6 +46,11 @@ static size_t seg6_lwt_headroom(struct
> seg6_iptunnel_encap *tuninfo)
> 
>   struct seg6_lwt {
>          struct dst_cache cache;
> +       u8      ttl_propagate;  /* propagate ttl from inner header */
> +       u8      default_ttl;    /* ttl value to use */
> +       u8      tclass_inherit; /* inherit tclass from inner header */
> +       u8      tclass;         /* tclass value to use */
> +
>          struct seg6_iptunnel_encap tuninfo[];
>   };
> 
> @@ -61,7 +66,10 @@ seg6_encap_lwtunnel(struct lwtunnel_state *lwt)
>   }
> 
>   static const struct nla_policy seg6_iptunnel_policy[SEG6_IPTUNNEL_MAX +
> 1] = {
> -       [SEG6_IPTUNNEL_SRH]     = { .type = NLA_BINARY },
> +       [SEG6_IPTUNNEL_UNSPEC]          = { .strict_start_type =
> SEG6_IPTUNNEL_SRH + 1 },
> +       [SEG6_IPTUNNEL_SRH]             = { .type = NLA_BINARY },
> +       [SEG6_IPTUNNEL_TTL]             = { .type = NLA_U8 },
> +       [SEG6_IPTUNNEL_TCLASS]          = { .type = NLA_U8 },
>   };
> 
>   static int nla_put_srh(struct sk_buff *skb, int attrtype,
> @@ -460,6 +468,22 @@ static int seg6_build_state(struct net *net, struct
> nlattr *nla,
> 
>          memcpy(&slwt->tuninfo, tuninfo, tuninfo_len);
> 
> +       if (tb[SEG6_IPTUNNEL_TTL]) {
> +               slwt->default_ttl = nla_get_u8(tb[SEG6_IPTUNNEL_TTL]);
> +               slwt->ttl_propagate = slwt->default_ttl ? 0 : 1;
> +       }
> +       if (tb[SEG6_IPTUNNEL_TCLASS]) {
> +               u32 tmp = nla_get_u32(tb[SEG6_IPTUNNEL_TCLASS]);
> +
> +               if (tmp == (u32)-1) {
> +                       slwt->tclass_inherit = true;
> +               } else if (tmp & <some valid range mask>) {
> +                       error
> +               } else {
> +                       slwt->tclass = ...
> +               }
> +       }
> +
>          newts->type = LWTUNNEL_ENCAP_SEG6;
>          newts->flags |= LWTUNNEL_STATE_INPUT_REDIRECT;
> 
> 
> And the use the values in slwt as needed.
> 

Thanks for the suggestions and the code example
I will write the patches and submit to net-next.

