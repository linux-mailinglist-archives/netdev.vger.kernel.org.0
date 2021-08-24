Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 065213F628D
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 18:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231840AbhHXQRl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 12:17:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbhHXQRY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 12:17:24 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A48DAC06122E
        for <netdev@vger.kernel.org>; Tue, 24 Aug 2021 09:16:37 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id j4-20020a17090a734400b0018f6dd1ec97so2689058pjs.3
        for <netdev@vger.kernel.org>; Tue, 24 Aug 2021 09:16:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=r0YeXm7+Wc7zLt54+UT5I6D0yllGpCmGvhf4XHfXZTk=;
        b=p4bdIs3YQd4wrlNSabs5sI9wTY0UIeiE1mXZo4t3OUmGPtCGMNvlmJedpmSJEgKD33
         9qtxEY1JOf7y6KWhvpcGHCHvIClbgEtBh/6/T5bXuxvoeF7kvMmYaXdIa1iVSZYb714Y
         h7/3noqkRlA0Tez8KNFvS66wEWBYb9AlkyJ9fQseSTXwRYs4z80ip43xtavAyqt/DSA2
         q0LSuHJgMZilYkTYrc2qHSfhQ50Qk09JAXeoJSfwVUjeC4+EuhLI98IeUESjbKjQpvyU
         GoufdjRK9JpWm1HurNYZF0zdHPcUO9bUri9tF5Q/hkH8FJBSMAabV7JezGOhJ5s9gSNG
         thQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=r0YeXm7+Wc7zLt54+UT5I6D0yllGpCmGvhf4XHfXZTk=;
        b=PhadfQwcsmxNezKZkLzU1bn65JpTgX2JvlO5FejdFxMoaaEC9YB55XL4VXFRF1vDYe
         IA9MQFAThsIZIPHYravi3jOSVSvKmGuwmtjnbid2kUHo1cRbjy9vzSczJuXq2VFSmO0R
         0U9k1iSR/i3/h+kbImBut0U8pRwndFSMKc5rSotUxxr2OIWJBdy1JGKQwYzDazlZgHEZ
         IIIWVsCn8tW7zZgS95Bf3KVmdLsOW1GLAX8KF7q9CISXTiB9keZbYVAm5p0RJFyvP8go
         3AERClRH5Wj/1t7MQcqFHtcpAU1aKxETbAxz6eONGdB5UEnucYN5pTTg+yOi/IO0MO6e
         AIWA==
X-Gm-Message-State: AOAM533wfr5vJrHfxR+qLPz/byjOYBltEkQVGeHhiyiMWINCJawTvkte
        FmMZExgrOY2U1v4XQQ6dT8U=
X-Google-Smtp-Source: ABdhPJwwJ6ly83pV1eWSBY1yapFBWWQpxLr7Spll4/bIFlnJb0cKAqO8vLV9L825eq692LaKndZmZA==
X-Received: by 2002:a17:902:6b47:b0:12d:7aa6:1e45 with SMTP id g7-20020a1709026b4700b0012d7aa61e45mr33398685plt.80.1629821797239;
        Tue, 24 Aug 2021 09:16:37 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.45.42.119])
        by smtp.googlemail.com with ESMTPSA id j17sm20341508pfn.148.2021.08.24.09.16.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Aug 2021 09:16:36 -0700 (PDT)
Subject: Re: [PATCH] ip: Support filter links/neighs with no master
To:     Lahav Schlesinger <lschlesinger@drivenets.com>
Cc:     netdev@vger.kernel.org, dsahern@kernel.org
References: <20210819104522.6429-1-lschlesinger@drivenets.com>
 <8b8762b4-6675-6dbc-bfe5-ed9443c8d54f@gmail.com>
 <20210824141625.dtwnvpejidy64kye@kgollan-pc>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <11a0051c-2d14-a479-c657-d49a2fce9a9d@gmail.com>
Date:   Tue, 24 Aug 2021 09:16:35 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210824141625.dtwnvpejidy64kye@kgollan-pc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/24/21 8:16 AM, Lahav Schlesinger wrote:
>>> diff --git a/ip/ipaddress.c b/ip/ipaddress.c
>>> index 85534aaf..a5b683f5 100644
>>> --- a/ip/ipaddress.c
>>> +++ b/ip/ipaddress.c
>>> @@ -61,7 +61,7 @@ static void usage(void)
>>>               "                            [ to PREFIX ] [ FLAG-LIST ] [ label LABEL ] [up]\n"
>>>               "       ip address [ show [ dev IFNAME ] [ scope SCOPE-ID ] [ master DEVICE ]\n"
>>
>> move [ nomaster ] to here on a new line to keep the existing line
>> length, and
>>
>>>               "                         [ type TYPE ] [ to PREFIX ] [ FLAG-LIST ]\n"
>>> -             "                         [ label LABEL ] [up] [ vrf NAME ] ]\n"
>>> +             "                         [ label LABEL ] [up] [ vrf NAME ] [ nomaster ] ]\n"
>>
>> make this 'novrf' for consistency with existing syntax.
>>
>> Similarly for the other 2 commands.
> 
> I think "nomaster" is more fitting here, because this option only affects
> interfaces that have no master at all, so e.g. slaves of a bundle will
> not be returned by the "nomaster" option, even if they are in the default VRF.

I was thinking both - 'nomaster' for bridges and 'novrf' for VRFs. Just
friendlier syntax for the latter.

> 
> I'm planning next to add support for the "novrf" option which will indeed
> only affect interfaces which are in the default VRF, even if they have a
> master.

ok,

