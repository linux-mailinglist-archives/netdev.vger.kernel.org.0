Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8AE85A0D83
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 12:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240597AbiHYKH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 06:07:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239593AbiHYKH6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 06:07:58 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D66AAB4C7
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 03:07:57 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id m10-20020a05600c3b0a00b003a603fc3f81so2247822wms.0
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 03:07:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:from:to:cc;
        bh=abf87yPX4uoBfXKmxzR9UOrUhztevRTVH+AXh3QPMTo=;
        b=HxP5YFnjiRqStfo01I4Bcm9YhsPskoKrxZXaZvHy84tOnb+r4sennav3qm6KXUlDyp
         o2qeQvhF8ITlwlMdZ+7Ib2AGmhzGKf8uPqKncKzZmZzpz5NaiGQsGNpUtlNdJPBuMCxa
         6uHKQY8q9sipTSNuq25Ql1i+X3ngF7ExJlUpQFIcOibFTTOROgnbafqeIb3QnEE73OOr
         r/GyXfRvCBvq9rL/Ho+yOcibjXeUA2gDlSCExD64mtPpVDNzzhcgNqONowlVre3nDhhd
         EoqZLE2MIGp/3kXGbeJuaoGfcWvPy/g//UCirKr3Jm4agP0IiiGQN4tR3TjxLGD6pMS4
         hcug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc;
        bh=abf87yPX4uoBfXKmxzR9UOrUhztevRTVH+AXh3QPMTo=;
        b=OP0hw6aMzbM+4oU3N1Om+S/guSwPmmlUWkBNFB646Y9VLOWkC3KUcVKy1iXSwgNC8e
         AY9YkT61Sxl6Hw27g7J62I5CufLNfhK42Gh5Htr53nLc7s7lKcYqkOiMeZBxMhZATiKt
         PDjEVQEdw8GPCTx3/Ovo/dlQNqW8t6gRaSiqbrx8QWT7guio3BNDtelH4C8+GI6HhJB1
         O1BcG2+nLnvnlCFtP3vqG3QH/yjo8TdeK6FqYC+3vV7CC6SV8946v/Eg+0ILi2XlSHGh
         OnVu22XSLqUeOP0Hat5b97vOwqZ39mJIrjqIWo1G6YWRbqjpyAWra8W9LXCXJd9ryR0S
         aoog==
X-Gm-Message-State: ACgBeo3B2DDv3EpJeT7WoUpzF94+kH6BucWJN53AJXxHO9PnzbpEk3n0
        ie/6icZRzrXieO5WFYVfaHIJfg==
X-Google-Smtp-Source: AA6agR7tQOX/sVHkQl8ew3Yrx1FbmLXIQ6zx3HGakuHnTQzaqsavgrI1sHCyXi5gFokevdP2Pic1HA==
X-Received: by 2002:a05:600c:a0a:b0:3a6:71e5:fb70 with SMTP id z10-20020a05600c0a0a00b003a671e5fb70mr1764989wmp.141.1661422075792;
        Thu, 25 Aug 2022 03:07:55 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:b41:c160:e5a8:418:4b2a:1186? ([2a01:e0a:b41:c160:e5a8:418:4b2a:1186])
        by smtp.gmail.com with ESMTPSA id m39-20020a05600c3b2700b003a604a29a34sm5692607wms.35.2022.08.25.03.07.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Aug 2022 03:07:55 -0700 (PDT)
Message-ID: <0e44ad3b-e1a0-6af4-5e8f-f808d3b28715@6wind.com>
Date:   Thu, 25 Aug 2022 12:07:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH ipsec-next 3/3] xfrm: lwtunnel: add lwtunnel support for
 xfrm interfaces in collect_md mode
Content-Language: en-US
To:     Eyal Birger <eyal.birger@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, pablo@netfilter.org,
        contact@proelbtn.com, dsahern@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, devel@linux-ipsec.org
References: <20220823154557.1400380-1-eyal.birger@gmail.com>
 <20220823154557.1400380-4-eyal.birger@gmail.com>
 <565cce1e-0890-dd35-7b26-362da2cde128@6wind.com>
 <CAHsH6Gv0AaNamsumhdqVtuTCMkJCwcAam07kZZoQ0vbuZi7tHA@mail.gmail.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
In-Reply-To: <CAHsH6Gv0AaNamsumhdqVtuTCMkJCwcAam07kZZoQ0vbuZi7tHA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Le 24/08/2022 à 20:56, Eyal Birger a écrit :
> Hi Nicolas,
> 
> On Wed, Aug 24, 2022 at 6:21 PM Nicolas Dichtel
> <nicolas.dichtel@6wind.com> wrote:
>>
>>
>> Le 23/08/2022 à 17:45, Eyal Birger a écrit :
>>> Allow specifying the xfrm interface if_id as part of a route metadata
>>> using the lwtunnel infrastructure.
>>>
>>> This allows for example using a single xfrm interface in collect_md
>>> mode as the target of multiple routes each specifying a different if_id.
>>>
>>> With the appropriate changes to iproute2, considering an xfrm device
>>> ipsec1 in collect_md mode one can for example add a route specifying
>>> an if_id like so:
>>>
>>> ip route add <SUBNET> dev ipsec1 encap xfrm if_id 1
>> It would be nice to be able to specify the link also. It may help to combine
>> this with vrf. Something like
>> ip route add <SUBNET> dev ipsec1 encap xfrm if_id 1 dev eth0
> 
> I think I understand how this would work on xmit - if you mean adding link
> to the metadata and using it to set fl.flowi_oif in xfrmi_xmit() - in which
> case the link would be used in the underlying lookup such that routes in
> a vrf could specify a device which is part of the vrf for egress.
Yes.

> 
> On RX we could assign the link in the metadata in xfrmi_rcv_cb() to the original
> skb->dev. I suspect this would be aligned with the link device, but any input
> you may have on this would be useful.
The link is not used in the rx path, only in the tx path to perform the route
lookup in the right vrf. You can assign the input iface to the link device, but
the if_id should be enough to identify the tunnel.


Thank you,
Nicolas
