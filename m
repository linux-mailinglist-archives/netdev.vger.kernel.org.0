Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98BCB3B204A
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 20:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbhFWSaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 14:30:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhFWSa1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 14:30:27 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E90D2C061574
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 11:28:08 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id w127so4328798oig.12
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 11:28:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KHd8E9F57olmHc15RtBtHExIdOPXbNyYjatuqdwvWCE=;
        b=JG/tEjcWIyFz4dlccIaDHvZG8vyfky1Gji1Hf6fB978U2PTjAbOsbgiulwqQb5yorS
         fVElutf/56sGJLHs/W+OLgI5MB/VusA9pqpO5HCuQU7Wgx7FTvP6/RQsuFT7KH2BpUe9
         deN04PM4K6tM9xgVKf5zOBqJEwvlP+CFzRdY04Ke3Sfx5kcboqxjUWel2QL+0woqMhyF
         TumqaJlx7zt72tJ8Gfcbq+XXDanrrPG2amE3qoQO6Gce44xs0BRJ7qU46bGqwYBftZSs
         +Pex1gc8y6zyWctf6PBDXRb5oDlKDd4o0xgFjqXET789tNKB0WYa8Qp0SVMw6E35T+/a
         +uiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KHd8E9F57olmHc15RtBtHExIdOPXbNyYjatuqdwvWCE=;
        b=HPaoRRJIlm5miDdnnSsw/eS2r/+hfwmmPvLplbk6smd3hNdzz6k3j77BfbAOutoOfJ
         eodT3GzE1sv+7J9HGmR3pxabMYHXoi1TydNYsezqMQO2WkDfTBMyiZxGiCvpqc3dzWCH
         +0WMSIVw5Ceo1HUymS04aTdMbzCJCzNcaxbIF+ThvrsfZ2ZZQKThHguxGg2uRTAObwEA
         Y+jtfoAvo09a4EsD9HiAV0fvep1yIYQFCwXEKJmmwWEDO6KJF/xomsBdIirmwgb9rFPT
         Qy/+a4Q9rzT1volQcOqODuCwDwO5Wo3EO0uYl+uW+v3WCe5v4YcCtUW/8/eRqrqo3RRe
         8iEg==
X-Gm-Message-State: AOAM5320KItXgRg2Cm7fJdVCqu6wMj/MXYGpTAozO8M3L5PW2SMU7OLm
        V+8EbgPrL0FgdyZ6mZc2joZJ1i8Chlk=
X-Google-Smtp-Source: ABdhPJzAUA8fHmxZPs4N268o12Ti3wPpC52oRxnQRApZt7yJJMB9Dji4wpY4wXT3jKRaBii2DtEtNg==
X-Received: by 2002:aca:360b:: with SMTP id d11mr1119947oia.108.1624472888261;
        Wed, 23 Jun 2021 11:28:08 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.38])
        by smtp.googlemail.com with ESMTPSA id o25sm127695ood.20.2021.06.23.11.28.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 11:28:07 -0700 (PDT)
Subject: Re: [PATCH net] ip6_tunnel: fix GRE6 segmentation
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, vfedorenko@novek.ru
References: <20210622015254.1967716-1-kuba@kernel.org>
 <33902f8c-e14a-7dc6-9bde-4f8f168505b5@gmail.com>
 <20210622152451.7847bc24@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <592a8a33-dfb8-c67f-c9e6-0e1bab37b00d@gmail.com>
 <20210623091458.40fb59c6@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5011b8aa-8bbf-9172-0982-599afed69c5d@gmail.com>
Date:   Wed, 23 Jun 2021 12:28:05 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210623091458.40fb59c6@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/23/21 10:14 AM, Jakub Kicinski wrote:
> On Tue, 22 Jun 2021 21:47:45 -0600 David Ahern wrote:
>> On 6/22/21 4:24 PM, Jakub Kicinski wrote:
>>>> would be good to capture the GRE use case that found the bug and the
>>>> MPLS version as test cases under tools/testing/selftests/net. Both
>>>> should be doable using namespaces.  
>>>
>>> I believe Vadim is working on MPLS side, how does this look for GRE?
>>
>> I like the template you followed. :-)
> 
> :)
> 
>> The test case looks good to me, thanks for doing it.
> 
> Noob question, why do we need that 2 sec wait with IPv6 sometimes?
> I've seen it randomly in my local testing as well I wasn't sure if 
> it's a bug or expected.

It is to let IPv6 DAD to complete otherwise the address will not be
selected as a source address. That typically results in test failures.
There are sysctl settings that can prevent the race and hence the need
for the sleep.

> 
> I make a v6 tunnel on top of a VLAN and for 2 secs after creation 
> I get the wrong route in ip -6 r g.
> 

