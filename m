Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0D5B3E9746
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 20:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbhHKSGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 14:06:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbhHKSGW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 14:06:22 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36DACC061765;
        Wed, 11 Aug 2021 11:05:58 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id t128so5892121oig.1;
        Wed, 11 Aug 2021 11:05:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HxY/WUTgeQY0+6YEwdFvZK8RANC+Nq5/hbFGvTroIBM=;
        b=p81Yc26djxFQaFJ7NCFX+EPjY/jGcWPm7G7gzBeo8h2Quj/TIkPrGw+tCco45s5uGo
         8GE7rTun/3e5fHaqqTXPhObCbK/GLHMUabdwENh1i6TMXc0SATjhRCgOpoIod4kBEyq9
         f4gPXpOGlQM/BnIDHDhWzVIWx2h9xLTcbTdIo2gK2Rt2EnNKDPExVAJx8NKLeKD9eNuP
         MLWNFOc7ODFeFkGxIsU7NcbbNXUsaDxQpKgTNMxv7+YmT8ynmhRTK3OgXlFxpscdsNrg
         nBXvFHNOPMJMceHBKUdbd8cc/HofHj7MSrlV24pSxRftwLeqapLuSbf2EmCWeJ5R0ziX
         KVZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HxY/WUTgeQY0+6YEwdFvZK8RANC+Nq5/hbFGvTroIBM=;
        b=k62esMWrrsNwySrloanYrQeIxoKR7WqSLzz/PLzuxS8InMc40wKbwLCQ3N2zVR4LGr
         YcWmBp9wMNbCgeCdVuZAz7MYlU9F9GjBUkRfGt+ZWvFS3cSYyD9MdMAVZLC47vWY92KV
         DeE/3fnvg1lrk64mHjzb0cKlFqSQ7eU4x7T8RfgRLi83KmrKEex+OxYcRtjq3PuwBUyj
         Cm9Cixel8KEzkBkvfnB2FeFblys49k9V9JgAuioNeq3vc0mGn7FdHupuC2XVhHBOXLRs
         oS8y7GoSsuOqb/xBkOMrAE1MbMuG+Z8k83b4TzzfLswgpsOF7gNQ4yyerTdguIRjbpml
         Gkiw==
X-Gm-Message-State: AOAM530kHGGrhElzloi+lyVF08ElKPId8F+7rpmdPsBSYGM6jnhcZ4VI
        RZA/9prYKawlXcUJCVjqIa0=
X-Google-Smtp-Source: ABdhPJy/5AUXtuljNkc5tzk/CAVNEAidUYBLMgUS5IwUQjZNN0/xFCqRkgygQxR5lzENJkC/vuG+tA==
X-Received: by 2002:a05:6808:905:: with SMTP id w5mr5155632oih.27.1628705157682;
        Wed, 11 Aug 2021 11:05:57 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.45])
        by smtp.googlemail.com with ESMTPSA id e10sm2790673oig.42.2021.08.11.11.05.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Aug 2021 11:05:57 -0700 (PDT)
Subject: Re: [PATCH net-next v3] ipv6: add IFLA_INET6_RA_MTU to expose mtu
 value in the RA message
From:   David Ahern <dsahern@gmail.com>
To:     Rocco Yue <rocco.yue@mediatek.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, rocco.yue@gmail.com,
        chao.song@mediatek.com, zhuoliang.zhang@mediatek.com
References: <c0a6f817-0225-c863-722c-19c798daaa4b@gmail.com>
 <20210810123327.15998-1-rocco.yue@mediatek.com>
 <25dcf6e8-cdd6-6339-f499-5c3100a7d8c4@gmail.com>
Message-ID: <4624cc10-1fc8-12cd-e9e1-9585f5b496a0@gmail.com>
Date:   Wed, 11 Aug 2021 12:05:54 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <25dcf6e8-cdd6-6339-f499-5c3100a7d8c4@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/11/21 7:56 AM, David Ahern wrote:
> On 8/10/21 6:33 AM, Rocco Yue wrote:
>> On Mon, 2021-08-09 at 16:43 -0600, David Ahern wrote:
>>> On 8/9/21 8:01 AM, Rocco Yue wrote:
>>
>>> +
>>>>  #ifdef CONFIG_SYSCTL
>>>>  
>>>>  static int addrconf_sysctl_forward(struct ctl_table *ctl, int write,
>>>> diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
>>>> index c467c6419893..a04164cbd77f 100644
>>>> --- a/net/ipv6/ndisc.c
>>>> +++ b/net/ipv6/ndisc.c
>>>> @@ -1496,6 +1496,12 @@ static void ndisc_router_discovery(struct sk_buff *skb)
>>>>  		memcpy(&n, ((u8 *)(ndopts.nd_opts_mtu+1))+2, sizeof(mtu));
>>>>  		mtu = ntohl(n);
>>>>  
>>>> +		if (in6_dev->ra_mtu != mtu) {
>>>> +			in6_dev->ra_mtu = mtu;
>>>> +			inet6_iframtu_notify(in6_dev);
>>>> +			ND_PRINTK(2, info, "update ra_mtu to %d\n", in6_dev->ra_mtu);
>>>> +		}
>>>> +
>>>>  		if (mtu < IPV6_MIN_MTU || mtu > skb->dev->mtu) {
>>>>  			ND_PRINTK(2, warn, "RA: invalid mtu: %d\n", mtu);
>>>>  		} else if (in6_dev->cnf.mtu6 != mtu) {
>>>
>>> Since this MTU is getting reported via af_info infrastructure,
>>> rtmsg_ifinfo should be sufficient.
>>>
>>> From there use 'ip monitor' to make sure you are not generating multiple
>>> notifications; you may only need this on the error path.
>>
>> Hi David,
>>
>> To avoid generating multiple notifications, I added a separate ramtu notify
>> function in this patch, and I added RTNLGRP_IPV6_IFINFO nl_mgrp to the ipmonitor.c
>> to verify this patch was as expected.
>>
>> I look at the rtmsg_ifinfo code, it should be appropriate and I will use it and
>> verify it.
>>
>> But there's one thing, I'm sorry I didn't fully understand the meaning of this
>> sentence "you may only need this on the error path". Honestly, I'm not sure what
>> the error patch refers to, do you mean "if (mtu < IPV6_MIN_MTU || mtu > skb->dev->mtu)" ?
>>
> 
> looks like nothing under:
>     if (ndopts.nd_opts_mtu && in6_dev->cnf.accept_ra_mtu) {
> 
>     }
> 
> is going to send a link notification so you can just replace
> inet6_iframtu_notify with rtmsg_ifinfo in your proposed change.
> 

Taking a deeper dive on the code, you do not need to call rtmsg_ifinfo.
Instead, the existing:

        /*
         *      Send a notify if RA changed managed/otherconf flags or
timer settings
         */
        if (send_ifinfo_notify)
                inet6_ifinfo_notify(RTM_NEWLINK, in6_dev);

is called too early. For one the RA can change the MTU and that is done
after this notify.

I think if you moved this down to the out:

out:
        /*
         *      Send a notify if RA changed managed/otherconf flags or
timer settings
         */
        if (send_ifinfo_notify)
                inet6_ifinfo_notify(RTM_NEWLINK, in6_dev);

and then set send_ifinfo_notify when the mtu is *changed* by the RA you
should be good.
