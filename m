Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25D0A500184
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 00:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235031AbiDMWFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 18:05:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233989AbiDMWFj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 18:05:39 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 030EB222B4;
        Wed, 13 Apr 2022 15:03:17 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id z16so3178973pfh.3;
        Wed, 13 Apr 2022 15:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=dGjtYEXEvkww7m0I6B/FhETocUOCMDPi+l5G5osJj1U=;
        b=G0kI8IXgqQDJlkctzDjTvJnEEXc47d7pEzg3lDgcff0PfDjwzkf7StTko4K3YvyBgq
         xHgbOcxhsCQQV5vYkq2jPJvPpYpxEeMxECtt+pdoCFbdsA0zL1uacTEdwekgJEltnctH
         MzvQBcUEYln5E8qG70s3p6yT9lcZJFzI7zDVrNw/JzRl/ljrLDijwg1tDc5muAbXm/Ut
         FsXl+q8mFzoTnARo6spGqMz3KcIRmqOveLIlQTSargRih+x6tTyWXkjK6NnC/wJM+kwt
         IG4mARNhOG/k9Q8FbrA7I8F4YmRBJfJrDryauKLgosclwmEZCGDeXDHbgXBJ/ZaUyvuC
         5rHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=dGjtYEXEvkww7m0I6B/FhETocUOCMDPi+l5G5osJj1U=;
        b=mbJcDZmUvgeIWX9AiIQEHjt0LVj5+zDIdxWUNU41qA7NZifARcG+rsLvoWxarUca2G
         N6Jx4N1BceHrFrwDnSW46UOLV/IZGYZcD7ZlKEESKPfMFoExQlLkTCrDIzMF9hgHfM3F
         2MpgKADFQO29pIEHzo6UaM6ktjWO5DNZ1XFcaRFWikQ487ZgObNcBD58jhjwa/OcKErz
         xuo9QGUMhkI39SB0tvDq+DiO+W6026rNGKQTZtYGfNzSZmhaHPErMtmqnCTXZw30S6aj
         HO9Gvc5rydn52YDE64s3pN3Og+LsXKnSBI0Q5KdY6TtFnI8/I7bmvmEWsExoOvuPtiDi
         biaA==
X-Gm-Message-State: AOAM531sedCvgDgWmG2qByf0704/V7eER3monvUtfVJmvbCJS7oxoHZo
        DQYPoxLs6KQOxax0420jwh0=
X-Google-Smtp-Source: ABdhPJwqmcS7b4vgqqMKmO5kvOHNB11CErkFD7m5F/dvNTL1GQXekl8extuLoXJIc5CI4viacjjdaQ==
X-Received: by 2002:a63:bd49:0:b0:39d:a2d3:94a2 with SMTP id d9-20020a63bd49000000b0039da2d394a2mr6977027pgp.242.1649887396477;
        Wed, 13 Apr 2022 15:03:16 -0700 (PDT)
Received: from ?IPV6:2620:15c:2c1:200:4cf8:b337:73c1:2c25? ([2620:15c:2c1:200:4cf8:b337:73c1:2c25])
        by smtp.gmail.com with ESMTPSA id y7-20020a056a00180700b00506f420e62asm75922pfa.11.2022.04.13.15.03.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Apr 2022 15:03:15 -0700 (PDT)
Message-ID: <2b935c82-ea5c-af47-4455-edf3a629e941@gmail.com>
Date:   Wed, 13 Apr 2022 15:03:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net-next v3] net/ipv6: Introduce accept_unsolicited_na
 knob to implement router-side changes for RFC9131
Content-Language: en-US
To:     David Ahern <dsahern@kernel.org>, Arun Ajith S <aajith@arista.com>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, yoshfuji@linux-ipv6.org,
        kuba@kernel.org, pabeni@redhat.com, corbet@lwn.net,
        prestwoj@gmail.com, gilligan@arista.com, noureddine@arista.com,
        gk@arista.com
References: <20220413143434.527-1-aajith@arista.com>
 <5a92f5cd-9af4-4228-dc44-b0c363f30e18@gmail.com>
 <17769a5b-9569-18ee-d1c0-c8971a42c709@kernel.org>
From:   Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <17769a5b-9569-18ee-d1c0-c8971a42c709@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/13/22 15:00, David Ahern wrote:
> On 4/13/22 3:22 PM, Eric Dumazet wrote:
>> On 4/13/22 07:34, Arun Ajith S wrote:
>>> Add a new neighbour cache entry in STALE state for routers on receiving
>>> an unsolicited (gratuitous) neighbour advertisement with
>>> target link-layer-address option specified.
>>> This is similar to the arp_accept configuration for IPv4.
>>> A new sysctl endpoint is created to turn on this behaviour:
>>> /proc/sys/net/ipv6/conf/interface/accept_unsolicited_na.
>>
>> Do we really need to expose this to /proc/sys, for every interface added
>> in the host ?
>>
>> /proc files creations/deletion cost a lot in environments
>> adding/deleting netns very often.
> agree with the general intent (along with the increasing memory costs).
> I do think this case should be done as a /proc/sys entry for consistency
> with both ARP and existing related NA settings.
>
>> I would prefer using NETLINK attributes, a single recvmsg() syscall can
>> fetch/set hundreds of them.
> What do you have in mind here? A link attribute managed through `ip link
> set`?


Yes, something like that, if this is a netdevice/link attribute.


