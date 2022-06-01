Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D50D1539B69
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 04:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349235AbiFACr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 22:47:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348381AbiFACrZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 22:47:25 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F6641F623;
        Tue, 31 May 2022 19:47:23 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id n8so510352plh.1;
        Tue, 31 May 2022 19:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=oQFM+rCuk95LMnjjZ4Ns18+BJzWLRDuKapwPxrHg13w=;
        b=NTo1+/bYpmehPMzgIL3+9DSkID+G6EFLDGoNstoFRqOJD5M8u4R7UvoyHt9PLkGtFT
         jZgAMnQlkl3gOd0d3YzkdVFTWUI4knohfGkA2dQdZjXOiQCJzt8I+U9JMXqSR4/LUtpX
         2j13RNpjUPvfVbH/yjdzMeib0+IE0enzqLyGRHgFM2Z5ArP9rEHkjghq65Z829jJDymt
         euNusrE+75qWl4xs1eULrf/JOxFvnXxwv6L3G6BFfklihMb9K341/2lfg33PFVDyIKJ+
         BmoIUiOX7RMz7ptiujCi2KXsD8QAP4pxTY/E3RRX4aWq0AtAGAfqIpWtrrKzVCixCjr/
         e00w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=oQFM+rCuk95LMnjjZ4Ns18+BJzWLRDuKapwPxrHg13w=;
        b=jZw/hDH3OIYl/BuJwtunL+OyvjpA4Byoc/QLq7HoW1tmPn9kjMtu0SD+FFU8QZEBIw
         5X94j+GaiwhQqeVl0h7a7NL/yitiefcGOA7FsLeH42/O+58PH+LEwfsU8ZzEPt3SIs5F
         cPeisV8F6L40Ag5ZD5i6yr6cUUt+evTeciSX+0Oq3xsrg+q2i2n78BSp6ylknqrTUsg0
         3STeHI9h+EQBt3ZkbDWXcskOSxsg4x9K0NW+vO3z/RcvCyGvWBGo5SlXmMJNOMwBhOV9
         QHIeMPhnc1hKZmlNg+raSyF1bDODxFfIzhfvXGSqeCJiE00RTPlp2QU5zpjpxtqU1Sug
         hWdA==
X-Gm-Message-State: AOAM532EHFot0G+d6tBe5s9KPGpYAlnKrJ32L/iZdiR7fiZ3L6NvZbXW
        EDc3VSZF2ftgoE3R6xCvzhK/oVF5QS4Uhw==
X-Google-Smtp-Source: ABdhPJy9jPEPzt+koescX8R9C1IhQZeP2eNX2AeLwbTTYek4Mbfukpu1gjjosD0TNYuerhY+z2+7Qg==
X-Received: by 2002:a17:902:cecd:b0:163:29e3:b1d1 with SMTP id d13-20020a170902cecd00b0016329e3b1d1mr36119846plg.129.1654051643003;
        Tue, 31 May 2022 19:47:23 -0700 (PDT)
Received: from [192.168.50.247] ([103.84.139.165])
        by smtp.gmail.com with ESMTPSA id 129-20020a621787000000b005180c127200sm164940pfx.24.2022.05.31.19.47.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 May 2022 19:47:22 -0700 (PDT)
Message-ID: <c6a3f922-0a57-5e48-c4e6-abca62f85f49@gmail.com>
Date:   Wed, 1 Jun 2022 10:47:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH] xfrm: xfrm_input: fix a possible memory leak in
 xfrm_input()
Content-Language: en-US
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220530102046.41249-1-hbh25y@gmail.com>
 <20220530103734.GD2517843@gauss3.secunet.de>
 <17ce0028-cbf2-20cd-c9ae-16b37ed61924@gmail.com>
 <20220531113530.GL2517843@gauss3.secunet.de>
From:   Hangyu Hua <hbh25y@gmail.com>
In-Reply-To: <20220531113530.GL2517843@gauss3.secunet.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/5/31 19:35, Steffen Klassert wrote:
> On Tue, May 31, 2022 at 10:12:05AM +0800, Hangyu Hua wrote:
>> On 2022/5/30 18:37, Steffen Klassert wrote:
>>> On Mon, May 30, 2022 at 06:20:46PM +0800, Hangyu Hua wrote:
>>>> xfrm_input needs to handle skb internally. But skb is not freed When
>>>> xo->flags & XFRM_GRO == 0 and decaps == 0.
>>>>
>>>> Fixes: 7785bba299a8 ("esp: Add a software GRO codepath")
>>>> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
>>>> ---
>>>>    net/xfrm/xfrm_input.c | 2 +-
>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
>>>> index 144238a50f3d..6f9576352f30 100644
>>>> --- a/net/xfrm/xfrm_input.c
>>>> +++ b/net/xfrm/xfrm_input.c
>>>> @@ -742,7 +742,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
>>>>    			gro_cells_receive(&gro_cells, skb);
>>>>    			return err;
>>>>    		}
>>>> -
>>>> +		kfree_skb(skb);
>>>>    		return err;
>>>>    	}
>>>
>>> Did you test this? The function behind the 'afinfo->the transport_finish()'
>>> pointer handles this skb and frees it in that case.
>>
>> int xfrm4_transport_finish(struct sk_buff *skb, int async)
>> {
>> 	struct xfrm_offload *xo = xfrm_offload(skb);
>> 	struct iphdr *iph = ip_hdr(skb);
>>
>> 	iph->protocol = XFRM_MODE_SKB_CB(skb)->protocol;
>>
>> #ifndef CONFIG_NETFILTER
>> 	if (!async)
>> 		return -iph->protocol;		<--- [1]
>> #endif
>> ...
>> 	NF_HOOK(NFPROTO_IPV4, NF_INET_PRE_ROUTING,
>> 		dev_net(skb->dev), NULL, skb, skb->dev, NULL,
>> 		xfrm4_rcv_encap_finish);	<--- [2]
>> 	return 0;
>> }
>>
>> int xfrm6_transport_finish(struct sk_buff *skb, int async)
>> {
>> 	struct xfrm_offload *xo = xfrm_offload(skb);
>> 	int nhlen = skb->data - skb_network_header(skb);
>>
>> 	skb_network_header(skb)[IP6CB(skb)->nhoff] =
>> 		XFRM_MODE_SKB_CB(skb)->protocol;
>>
>> #ifndef CONFIG_NETFILTER
>> 	if (!async)
>> 		return 1;			<--- [3]
>> #endif
>> ...
>> 	NF_HOOK(NFPROTO_IPV6, NF_INET_PRE_ROUTING,
>> 		dev_net(skb->dev), NULL, skb, skb->dev, NULL,
>> 		xfrm6_transport_finish2);
>> 	return 0;				<--- [4]
>> }
>>
>> If transport_finish() return in [1] or [3], there will be a memory leak.
> 
> No, even in that case there is no memleak. Look for instance at the
> IPv4 case, we return -iph->protocol here.
> Then look at ip_protocol_deliver_rcu(). If the ipprot->handler (xfrm)
> returns a negative value, this is interpreted as the protocol number
> and the packet is resubmitted to the next protocol handler.
> 
> Please test your patches before you submit them in the future.
Thanks for your explanation. I will be more careful in the future.
