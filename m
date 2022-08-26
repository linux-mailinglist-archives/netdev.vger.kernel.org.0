Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30CF45A2624
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 12:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344030AbiHZKvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 06:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344033AbiHZKu6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 06:50:58 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6335C3F336
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 03:50:48 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id t5so1594411edc.11
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 03:50:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=BVMt85H4uwkZXKo3Dy3Nzz0cObJCNXfSwD3HhcULZDk=;
        b=HBeGZodvgGlI5lYH5sDojs/WqkFFqn/7FT3Wx4EsXREBFcujnLk54eX97bWM657re1
         2INAVAFLFnhL0EfWXJzwTyd62zgasI9d9MHjNVA6p44O03YHYBCAnBgYpAHjFStopDmU
         gVDBo6Btf0KFzdz+Qj/LhFCrBJo3uEZ5CCBsORr8ZHdtwN9sC99x2fBq13Urp/KanczM
         2wPg2erpRQjhyinJ1cyP5MI+H0h4VCNKvNwpLko/uPojIUcCmxK+W3gOogu2t219dBs5
         U0WmQCaTdrbWiOfznS6ZHqhNW/8kbx2QUWl7NX/rmvTQ8aJZauVjrOMfD3R13wjOQ/EA
         gRJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=BVMt85H4uwkZXKo3Dy3Nzz0cObJCNXfSwD3HhcULZDk=;
        b=fIvLacMKkFeF5Q/te01TmQSj/75bYYVQCrSkazQQ0RMEZgQLpNS9yll3q2TzY5G+Cn
         UaXULVTIuxohYSvfsxIaC60hDvcKJiHHj36jtEDSlgeta7d8uockzn+de2ZadXqCEveh
         uEDyFbzh+fVdGTTQ+0tpJO2ZFBY8mAA7nPSiX+G+CG+dcDMuSqz3G4PKDwIrGTogVnKj
         CIuii8Dy/mGkBCrrhQ7pZznlcQKTmjJ+Wdtt8IHE4IlHIAIgTcrgUZvVuxRmqD2VNkgR
         dRrMxUNWgmTNA7PNjROwHPvqMydwBA92Y5Tz//pHq2mODCK6eBBl2dtqH7MtOjfBumG/
         0a2A==
X-Gm-Message-State: ACgBeo2wSCDj0SC0BhZeCutQfx4Mtgqwrr2SjGNcZ70sSAUvjnYbVaaN
        TrV7E7ZE3ksaa9OhFyeXf5AbiA==
X-Google-Smtp-Source: AA6agR64G4YKQjkfGqYsfzvNPSh9aQzsAN+cbkqO3vYIB/76HzJ1I2YCou3VLlLCDafBJHbWIQQzwA==
X-Received: by 2002:a05:6402:1041:b0:446:b290:ea94 with SMTP id e1-20020a056402104100b00446b290ea94mr6250852edu.389.1661511047489;
        Fri, 26 Aug 2022 03:50:47 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id ky11-20020a170907778b00b0072abb95eaa4sm725190ejc.215.2022.08.26.03.50.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Aug 2022 03:50:47 -0700 (PDT)
Message-ID: <11448e15-f882-5494-65d4-1d4a06ab4438@blackwall.org>
Date:   Fri, 26 Aug 2022 13:50:45 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH ipsec-next,v3 3/3] xfrm: lwtunnel: add lwtunnel support
 for xfrm interfaces in collect_md mode
Content-Language: en-US
To:     Eyal Birger <eyal.birger@gmail.com>, nicolas.dichtel@6wind.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, dsahern@kernel.org,
        contact@proelbtn.com, pablo@netfilter.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20220825154630.2174742-1-eyal.birger@gmail.com>
 <20220825154630.2174742-4-eyal.birger@gmail.com>
 <d2836dfb-6666-52cc-0d9c-17cb1542893c@6wind.com>
 <CAHsH6Gt3kU6tLVpSiq4jk7QQnVDzQin8qQyv_occKhL2RM8edA@mail.gmail.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <CAHsH6Gt3kU6tLVpSiq4jk7QQnVDzQin8qQyv_occKhL2RM8edA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/08/2022 13:18, Eyal Birger wrote:
> On Fri, Aug 26, 2022 at 11:05 AM Nicolas Dichtel
> <nicolas.dichtel@6wind.com> wrote:
>>
>>
>> Le 25/08/2022 à 17:46, Eyal Birger a écrit :
>>> Allow specifying the xfrm interface if_id and link as part of a route
>>> metadata using the lwtunnel infrastructure.
>>>
>>> This allows for example using a single xfrm interface in collect_md
>>> mode as the target of multiple routes each specifying a different if_id.
>>>
>>> With the appropriate changes to iproute2, considering an xfrm device
>>> ipsec1 in collect_md mode one can for example add a route specifying
>>> an if_id like so:
>>>
>>> ip route add <SUBNET> dev ipsec1 encap xfrm if_id 1
>>>
>>> In which case traffic routed to the device via this route would use
>>> if_id in the xfrm interface policy lookup.
>>>
>>> Or in the context of vrf, one can also specify the "link" property:
>>>
>>> ip route add <SUBNET> dev ipsec1 encap xfrm if_id 1 link_dev eth15
>>>
>>> Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
>>>
>>> ----
>>>
>>> v3: netlink improvements as suggested by Nikolay Aleksandrov and
>>>     Nicolas Dichtel
>>>
>>> v2:
>>>   - move lwt_xfrm_info() helper to dst_metadata.h
>>>   - add "link" property as suggested by Nicolas Dichtel
>>> ---
>>>  include/net/dst_metadata.h    | 11 +++++
>>>  include/uapi/linux/lwtunnel.h | 10 +++++
>>>  net/core/lwtunnel.c           |  1 +
>>>  net/xfrm/xfrm_interface.c     | 85 +++++++++++++++++++++++++++++++++++
>>>  4 files changed, 107 insertions(+)
>>>
>>> diff --git a/include/net/dst_metadata.h b/include/net/dst_metadata.h
>>> index e4b059908cc7..57f75960fa28 100644
>>> --- a/include/net/dst_metadata.h
>>> +++ b/include/net/dst_metadata.h
>>> @@ -60,13 +60,24 @@ skb_tunnel_info(const struct sk_buff *skb)
>>>       return NULL;
>>>  }
>>>
>>> +static inline struct xfrm_md_info *lwt_xfrm_info(struct lwtunnel_state *lwt)
>>> +{
>>> +     return (struct xfrm_md_info *)lwt->data;
>>> +}
>>> +
>>>  static inline struct xfrm_md_info *skb_xfrm_md_info(const struct sk_buff *skb)
>>>  {
>>>       struct metadata_dst *md_dst = skb_metadata_dst(skb);
>>> +     struct dst_entry *dst;
>>>
>>>       if (md_dst && md_dst->type == METADATA_XFRM)
>>>               return &md_dst->u.xfrm_info;
>>>
>>> +     dst = skb_dst(skb);
>>> +     if (dst && dst->lwtstate &&
>>> +         dst->lwtstate->type == LWTUNNEL_ENCAP_XFRM)
>>> +             return lwt_xfrm_info(dst->lwtstate);
>>> +
>>>       return NULL;
>>>  }
>>>
>>> diff --git a/include/uapi/linux/lwtunnel.h b/include/uapi/linux/lwtunnel.h
>>> index 2e206919125c..229655ef792f 100644
>>> --- a/include/uapi/linux/lwtunnel.h
>>> +++ b/include/uapi/linux/lwtunnel.h
>>> @@ -15,6 +15,7 @@ enum lwtunnel_encap_types {
>>>       LWTUNNEL_ENCAP_SEG6_LOCAL,
>>>       LWTUNNEL_ENCAP_RPL,
>>>       LWTUNNEL_ENCAP_IOAM6,
>>> +     LWTUNNEL_ENCAP_XFRM,
>>>       __LWTUNNEL_ENCAP_MAX,
>>>  };
>>>
>>> @@ -111,4 +112,13 @@ enum {
>>>
>>>  #define LWT_BPF_MAX_HEADROOM 256
>>>
>>> +enum {
>>> +     LWT_XFRM_UNSPEC,
>>> +     LWT_XFRM_IF_ID,
>>> +     LWT_XFRM_LINK,
>>> +     __LWT_XFRM_MAX,
>>> +};
>>> +
>>> +#define LWT_XFRM_MAX (__LWT_XFRM_MAX - 1)
>>> +
>>>  #endif /* _UAPI_LWTUNNEL_H_ */
>>> diff --git a/net/core/lwtunnel.c b/net/core/lwtunnel.c
>>> index 9ccd64e8a666..6fac2f0ef074 100644
>>> --- a/net/core/lwtunnel.c
>>> +++ b/net/core/lwtunnel.c
>>> @@ -50,6 +50,7 @@ static const char *lwtunnel_encap_str(enum lwtunnel_encap_types encap_type)
>>>               return "IOAM6";
>>>       case LWTUNNEL_ENCAP_IP6:
>>>       case LWTUNNEL_ENCAP_IP:
>>> +     case LWTUNNEL_ENCAP_XFRM:
>>>       case LWTUNNEL_ENCAP_NONE:
>>>       case __LWTUNNEL_ENCAP_MAX:
>>>               /* should not have got here */
>>> diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
>>> index e9a355047468..495dee8b0764 100644
>>> --- a/net/xfrm/xfrm_interface.c
>>> +++ b/net/xfrm/xfrm_interface.c
>>> @@ -60,6 +60,88 @@ struct xfrmi_net {
>>>       struct xfrm_if __rcu *collect_md_xfrmi;
>>>  };
>>>
>>> +static const struct nla_policy xfrm_lwt_policy[LWT_XFRM_MAX + 1] = {
>>> +     [LWT_XFRM_IF_ID]        = NLA_POLICY_MIN(NLA_U32, 1),
>>> +     [LWT_XFRM_LINK]         = NLA_POLICY_MIN(NLA_S32, 1),
>> IMHO, it would be better to keep consistency with IFLA_XFRM_LINK.
>>
>> $ git grep _LINK.*NLA_U32 net/ drivers/net/
>> drivers/net/gtp.c:      [GTPA_LINK]             = { .type = NLA_U32, },
>> drivers/net/vxlan/vxlan_core.c: [IFLA_VXLAN_LINK]       = { .type = NLA_U32 },
>> ...
>> net/core/rtnetlink.c:   [IFLA_LINK]             = { .type = NLA_U32 },
>> ...
>> net/ipv4/ip_gre.c:      [IFLA_GRE_LINK]         = { .type = NLA_U32 },
>> net/ipv4/ip_vti.c:      [IFLA_VTI_LINK]         = { .type = NLA_U32 },
>> net/ipv4/ipip.c:        [IFLA_IPTUN_LINK]               = { .type = NLA_U32 },
>> net/ipv6/ip6_gre.c:     [IFLA_GRE_LINK]        = { .type = NLA_U32 },
>> net/ipv6/ip6_tunnel.c:  [IFLA_IPTUN_LINK]               = { .type = NLA_U32 },
>> net/ipv6/ip6_vti.c:     [IFLA_VTI_LINK]         = { .type = NLA_U32 },
>> net/ipv6/sit.c: [IFLA_IPTUN_LINK]               = { .type = NLA_U32 },
>> net/sched/cls_u32.c:    [TCA_U32_LINK]          = { .type = NLA_U32 },
>> ...
>> net/xfrm/xfrm_interface.c:      [IFLA_XFRM_LINK]        = { .type = NLA_U32 },
>> $ git grep _LINK.*NLA_S32 net/ drivers/net/
>> net/core/rtnetlink.c:   [IFLA_LINK_NETNSID]     = { .type = NLA_S32 },
>> $
>>
>> They all are U32. Adding one S32 would just add confusion.
> 
> Thanks for this input!
> 
> Indeed going over the other references it seems ifindex is treated as U32
> when interfacing with userspace almost everywhere including netlink and
> bpf. In the IOCTL interface it seems to be implemented as int, but at
> least on my Ubuntu machine the manpage for e.g. if_nametoindex() describes
> it as returning unsigned int.
> 
> Therefore I intend to resubmit this as U32.
> 
> Thanks,
> Eyal.

Ack, good point, note that ifindex is not always a u32 and ifindex itself is usually a
signed integer field in structs (e.g. net_device), as well as flowic_oif (flowi_oif). :) 
rtnetlink.c:	[IFLA_NEW_IFINDEX]	= NLA_POLICY_MIN(NLA_S32, 1),
rtnetlink.c:	[NDA_IFINDEX]	= NLA_POLICY_MIN(NLA_S32, 1),

Just using the old U32 code and making link a u32 should be ok.

Cheers,
 Nik



