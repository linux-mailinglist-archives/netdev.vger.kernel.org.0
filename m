Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8AF48C8CE
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 17:50:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355370AbiALQuE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 11:50:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355366AbiALQuD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 11:50:03 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8D71C06173F;
        Wed, 12 Jan 2022 08:50:02 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id q9-20020a7bce89000000b00349e697f2fbso3221261wmj.0;
        Wed, 12 Jan 2022 08:50:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=JJ2SF0bb6+KdUSKyCW+HpUGApp1784aHS3nTpx0Z14s=;
        b=Q7fd1OF09Sc22CHs0JbrnbaRvJ5yz4+TzaFl2g7/XsWsE5Rfw57AryfXj9utncRj0H
         Zeh4xr/iUYHZHwIcpI4mtCqRaa/Mv+t+3N92Os5p0TLiutWpqhjzrsui6vBXnJymFYfk
         0LW7fyA8y6V18tbcj2fFyQa+rGR7UfnnJifG8ZhojSuVvbHei0wG5tHGqtXnc4ArCJ63
         eKIE1d9CDnewXU3zZDaTLgCWJd+4qFEMoj82k48+KfMvidhMT2QRd23pkQRhmE9Usjil
         FRoJMCsg7q+qPcJpnQq1T5ZX2M+JuyloKzQNkkfz0oytmhwFw3RmsPQoDC4nHWbO/s+M
         Ly0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=JJ2SF0bb6+KdUSKyCW+HpUGApp1784aHS3nTpx0Z14s=;
        b=dlSd92hYDAvXSe7qwbtx75FQ6vq1Tp6mLGZ1wCDOIp96X/JYzjJ9CucU6Dd41BqRbT
         Xg4ZTu8TgEQuXw9VuYnB7Lj8fr6MamrqyId97MqhEUgVTkOrvrGUFuqhVQTpL+eDlIiP
         EOhFo/VzyHd78LYLYPc0D/pGI3aIT4PhmLoR4hksNXli3taryhx4iE6p2PI/yhvNol+R
         Juay7cR4zsF95Uw4jd3DgBAjn6f3TwMOD0+zOAWzHsQyJ0RI0aHp/BRQ8G5Gc+PVbThL
         NMhsmLtGc3RZtdT7KLDb1rMFr4L+rhKosSUFim2rfQpjjZzJKZTwP14JPIBPvUdmnHof
         QLLQ==
X-Gm-Message-State: AOAM5328jT111NFgYvDYlklDKpN1lAi8k1pBQllmzzhJ/I0EHQsonlR2
        dvgMpAbu7zEh3yT0onzSJNpCSHcTNns=
X-Google-Smtp-Source: ABdhPJyhP4HoKPWfjEBmMhMTVMUw8Jkty2ipPtiCXRG3fM2rt5+S4ZMGOxM5chziNMgvkZ6UNASTWg==
X-Received: by 2002:a1c:a9c2:: with SMTP id s185mr7378371wme.164.1642006201590;
        Wed, 12 Jan 2022 08:50:01 -0800 (PST)
Received: from [192.168.8.198] ([148.252.129.73])
        by smtp.gmail.com with ESMTPSA id f9sm359230wry.115.2022.01.12.08.50.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jan 2022 08:50:01 -0800 (PST)
Message-ID: <a6217814-3762-f99a-9ee0-a4dfbe6a876d@gmail.com>
Date:   Wed, 12 Jan 2022 16:49:12 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 09/14] ipv6: hand dst refs to cork setup
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        linux-kernel@vger.kernel.org
References: <cover.1641863490.git.asml.silence@gmail.com>
 <07031c43d3e5c005fbfc76b60a58e30c66d7c620.1641863490.git.asml.silence@gmail.com>
 <48293134f179d643e9ec7bcbd7bca895df7611ac.camel@redhat.com>
 <9e3bb558-ecb1-a6aa-35e4-a2771136b3fe@gmail.com>
 <3520c1e1609d8bef103766ad03508d0060824b98.camel@redhat.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <3520c1e1609d8bef103766ad03508d0060824b98.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/12/22 11:15, Paolo Abeni wrote:
> On Tue, 2022-01-11 at 20:39 +0000, Pavel Begunkov wrote:
>> On 1/11/22 17:11, Paolo Abeni wrote:
>>> On Tue, 2022-01-11 at 01:21 +0000, Pavel Begunkov wrote:
>>>> During cork->dst setup, ip6_make_skb() gets an additional reference to
>>>> a passed in dst. However, udpv6_sendmsg() doesn't need dst after calling
>>>> ip6_make_skb(), and so we can save two additional atomics by passing
>>>> dst references to ip6_make_skb(). udpv6_sendmsg() is the only caller, so
>>>> it's enough to make sure it doesn't use dst afterwards.
>>>
>>> What about the corked path in udp6_sendmsg()? I mean:
>>
>> It doesn't change it for callers, so the ref stays with udp6_sendmsg() when
>> corking. To compensate for ip6_setup_cork() there is an explicit dst_hold()
>> in ip6_append_data, should be fine.
> 
> Whoops, I underlooked that chunk, thanks for pointing it out!
> 
> Yes, it looks fine.

perfect, thanks


>> @@ -1784,6 +1784,7 @@ int ip6_append_data(struct sock *sk,
>>    		/*
>>    		 * setup for corking
>>    		 */
>> +		dst_hold(&rt->dst);
>>    		err = ip6_setup_cork(sk, &inet->cork, &np->cork,
>>    				     ipc6, rt);
>>
>>
>> I don't care much about corking perf, but might be better to implement
>> this "handing away" for ip6_append_data() as well to be more consistent
>> with ip6_make_skb().
> 
> I'm personally fine with the the added dst_hold() in ip6_append_data()
-- 
Pavel Begunkov
