Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D19DB41D090
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 02:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347066AbhI3Ab1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 20:31:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233113AbhI3Ab0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 20:31:26 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3005C06161C
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 17:29:44 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id ce20-20020a17090aff1400b0019f13f6a749so5161963pjb.4
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 17:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=qwjNHpJA6FY0nu6BFzuBNE38cf2EdeXQAYK4wdXPBJs=;
        b=f10uZRFrvZ6uVMjSpkWkpj7DBdnSuAigwsnqg1iCtHnkwpc9BGiyIPzZ32oewOYLZX
         ZcImu1VZKUV258YI0Lu6X2NpgDAS8tX5jPtT2ho1Z4xIwCNtT1mif3kjLW+z7WCIRmSA
         vzfo3jWnUgg+MCjiO51ak5xZAnGZtneLqg5FESH56+waSonQ3gfUI3duwjibht4bhbW5
         bS3926SGJ2Pn+sHmj+ML3YKh4QBoBOlz0eibb8PxzsBBBUUWHF/dbx84MC7On0khLwMX
         vdyHNiSul0pErMWp/TOO1E4j0d2APXz/hgTjsGPPLUmaMZJ9uuHfVLsCMT2jtFztKpvq
         M74g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qwjNHpJA6FY0nu6BFzuBNE38cf2EdeXQAYK4wdXPBJs=;
        b=jFbI1TvR5rqE0tdAy1d9QEGfAHNQXeCmIPuulR3eQwz7thzwBDwbmDjY0cJyFI79xf
         UUDTM5OVr9dF1qXqeCqVbCApdbeXyXGKSk6HBE2OYi/lVQ7lDwGhL/bU9jLXId81gdL6
         RSxkhFAxwLogfjXVvEGUijhbbkZb6Vu6D/O4yPeL6Vd9u+4HAeo+J2m/wxmQzJJ1gYmT
         0v9gE7PmV5n24cCC2du5uyquk4e8+9Vldzg4GzT2VZAOJRXoyLBX51jqvzHsBdsqBXw4
         YTBG9gD96xcyHWyeiU/HMyV5204JCxX+VDTwsPwGP6NCrPh69510B78N/jFcQM9NPaKi
         fAdw==
X-Gm-Message-State: AOAM532+uu/Sf5qw+Na3OHZRnwyVLWCOC2UvXsxmS4/pJ67SbiWfE953
        4o0lihoentzUqjDVJe7huytjNZCZRqQ=
X-Google-Smtp-Source: ABdhPJy5Ic/h6aPp7oK1c6vW5wgfJ/5nvt51DIUv5gqPonPPjrQeP0ZMJmI0pcTiBp46zSobzF8p8A==
X-Received: by 2002:a17:902:6e02:b0:13a:41f5:1666 with SMTP id u2-20020a1709026e0200b0013a41f51666mr2593007plk.39.1632961784104;
        Wed, 29 Sep 2021 17:29:44 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id f4sm707551pgn.93.2021.09.29.17.29.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Sep 2021 17:29:43 -0700 (PDT)
Subject: Re: 5.15-rc3+ crash in fq-codel?
To:     Ben Greear <greearb@candelatech.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>
References: <dfa032f3-18f2-22a3-80bf-f0f570892478@candelatech.com>
 <b6e8155e-7fae-16b0-59f0-2a2e6f5142de@gmail.com>
 <00e495ba-391e-6ad8-94a2-930fbc826a37@candelatech.com>
 <296232ac-e7ed-6e3c-36b9-ed430a21f632@candelatech.com>
 <7e87883e-42f5-2341-ab67-9f1614fb8b86@candelatech.com>
 <7f1d67f1-3a2c-2e74-bb86-c02a56370526@gmail.com>
 <88bc8a03-da44-fc15-f032-fe5cb592958b@candelatech.com>
 <b537053d-498d-928b-8ca0-e9daf5909128@gmail.com>
 <f3f1378d-6839-cd23-9e2c-4668947c2345@gmail.com>
 <41b4221b-be68-da96-8cbf-4297bb7ba821@gmail.com>
 <8768df9e-f1f6-db25-15d8-cabed2346f32@candelatech.com>
 <b7df0abb-8bdd-6348-a60a-75a66d6a9d91@candelatech.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <c4000c2a-8894-c3f5-9497-82bce4615be1@gmail.com>
Date:   Wed, 29 Sep 2021 17:29:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <b7df0abb-8bdd-6348-a60a-75a66d6a9d91@candelatech.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/29/21 5:04 PM, Ben Greear wrote:
> On 9/29/21 4:48 PM, Ben Greear wrote:
>> On 9/29/21 4:42 PM, Eric Dumazet wrote:
>>>
>>>
>>> On 9/29/21 4:28 PM, Eric Dumazet wrote:
>>>>
>>>
>>>>
>>>> Actually the bug seems to be in pktgen, vs NET_XMIT_CN
>>>>
>>>> You probably would hit the same issues with other qdisc also using NET_XMIT_CN
>>>>
>>>
>>> I would try the following patch :
>>>
>>> diff --git a/net/core/pktgen.c b/net/core/pktgen.c
>>> index a3d74e2704c42e3bec1aa502b911c1b952a56cf1..0a2d9534f8d08d1da5dfc68c631f3a07f95c6f77 100644
>>> --- a/net/core/pktgen.c
>>> +++ b/net/core/pktgen.c
>>> @@ -3567,6 +3567,7 @@ static void pktgen_xmit(struct pktgen_dev *pkt_dev)
>>>          case NET_XMIT_DROP:
>>>          case NET_XMIT_CN:
>>>                  /* skb has been consumed */
>>> +               pkt_dev->last_ok = 1;
>>>                  pkt_dev->errors++;
>>>                  break;
>>>          default: /* Drivers are not supposed to return other values! */
> 
> While patching my variant of pktgen, I took a look at the 'default' case.  I think
> it should probably go above NET_XMIT_DROP and fallthrough into the consumed pkt path?
> 
> Although, probably not a big deal since only bugs elsewhere would hit that path, and
> we don't really know if skb would be consumed in that case or not.
> 

This is probably dead code after commit

commit f466dba1832f05006cf6caa9be41fb98d11cb848    pktgen: ndo_start_xmit can return NET_XMIT_xxx values

So this does not really matter anymore.



