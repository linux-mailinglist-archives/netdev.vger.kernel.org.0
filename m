Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 617C14639B2
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 16:17:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242721AbhK3PUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 10:20:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243732AbhK3PSh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 10:18:37 -0500
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77C95C061746
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 07:12:59 -0800 (PST)
Received: by mail-oi1-x22b.google.com with SMTP id be32so41791090oib.11
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 07:12:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=fvwH6HXb4w+MOiRTRayftBMLVaod8W2ARqIBT7t0v9U=;
        b=XLPw6aBCsi/fatEfxgYbnzYsC+mzTD2hUA7Gy+QaM1YJvANbEe08xkyvLl4U4JLR0N
         urnpSurKHBGbYDTHpBPu940BJdqvhmClFJFvfEy7uGldGqt8dQ0k96nfGCv4v2kbs2QQ
         UXDoOtJHPIbAT7Ck/ogr0U2jU9/agOt40B43PsRqJhWh+CfUAku+znCchlkXVfyWVbEE
         CsU5ypABSE+r73f2bGJ+Sjg4ME/N/dPapxVLkH3Ze32/xUDdggHs+Pc/1SPDF+pMujIA
         oXInCnwITgCyiklWGntjF3lvo6GF7kJ0ELbiuZunKZ3zzSX4O1gTkrywDqkttWuhR+rB
         AqgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fvwH6HXb4w+MOiRTRayftBMLVaod8W2ARqIBT7t0v9U=;
        b=I0G5Mp0tltMPVmCq2B44+7Mwpee3KWA0gHAbX8HDXzGIwyiQL/0hKhqogp4I7EtGIZ
         M4/FDnl4rOqY23F9inmDhqBVLCDlUcPGI5Lt8nWanDA0yOCdgu8rlFwTfwd3nevsUM1Q
         3SEULYljMrwbBIgg68xhkWM7yHunLdDtJZpInTt1xNGOGqCEEggTqw4TVboT1mSKcIkf
         CK0Vh56lvRQp2MZOECFcvf4/YE9VH3zgb/ebq9+t/Zwm/c5seourUWi4L/p7F9VxjN1Y
         H8X3uh6LzbDTDTEGcHzXwXbrsctIoXZ0ZCORbdl56IqA/YWK9nsCmB5bqhnurr//S35r
         +kvw==
X-Gm-Message-State: AOAM5318SGi65YrcLQbrPbJkSCsJlxqZB2pW4cQSltH/CrxJ9CHSAQ4w
        MMG8Eb4/vAK983eJykKaz54=
X-Google-Smtp-Source: ABdhPJz84NVwFTBKbq6wgGaujduXIntv70QTTmhjuemXBPjlxgD/Y7E7X1CsA9KkmNc4UCgrRhybtg==
X-Received: by 2002:aca:1a04:: with SMTP id a4mr4544883oia.153.1638285178808;
        Tue, 30 Nov 2021 07:12:58 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id u28sm3228997oth.52.2021.11.30.07.12.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Nov 2021 07:12:58 -0800 (PST)
Message-ID: <a0b5d939-d4a5-42e9-ff23-635744636802@gmail.com>
Date:   Tue, 30 Nov 2021 08:12:56 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.1
Subject: Re: [PATCH net-next] rtnetlink: add RTNH_REJECT_MASK
Content-Language: en-US
To:     Ido Schimmel <idosch@idosch.org>,
        Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>,
        roopa@nvidia.com
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrei Vagin <avagin@gmail.com>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        Alexander Mikhalitsyn <alexander@mihalicyn.com>
References: <20211111160240.739294-1-alexander.mikhalitsyn@virtuozzo.com>
 <20211126134311.920808-1-alexander.mikhalitsyn@virtuozzo.com>
 <20211126134311.920808-2-alexander.mikhalitsyn@virtuozzo.com>
 <YaOLt2M1hBnoVFKd@shredder> <e3d13710-2780-5dff-3cbf-fa0fd7cb5d32@gmail.com>
 <YaXZ3WdgwdeocakQ@shredder>
 <20211130113517.35324af97e168a9b0676b751@virtuozzo.com>
 <YaXuwEg/hdkwNYEN@shredder>
 <20211130125352.4bbcc68c01fe763c1f43bfdc@virtuozzo.com>
 <YaX8wa5R/r5sbca5@shredder>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <YaX8wa5R/r5sbca5@shredder>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/30/21 3:28 AM, Ido Schimmel wrote:
>> diff --git a/ip/iproute.c b/ip/iproute.c
>> index 1447a5f78f49..0e6dad2b67e5 100644
>> --- a/ip/iproute.c
>> +++ b/ip/iproute.c
>> @@ -1632,6 +1632,8 @@ static int save_route(struct nlmsghdr *n, void *arg)
>>         if (!filter_nlmsg(n, tb, host_len))
>>                 return 0;
>>  
>> +       r->rtm_flags &= RTNH_F_ONLINK;
>> +
>>         ret = write(STDOUT_FILENO, n, n->nlmsg_len);
>>         if ((ret > 0) && (ret != n->nlmsg_len)) {
>>                 fprintf(stderr, "Short write while saving nlmsg\n");
>>
>> to filter out all flags *except* RTNH_F_ONLINK.
> 
> Yes
> 
>>
>> But what about discussion from
>> https://lore.kernel.org/netdev/ff405eae-21d9-35f4-1397-b6f9a29a57ff@nvidia.com/
>>
>> As far as I understand Roopa, we have to save at least RTNH_F_OFFLOAD flag too,
>> for instance, if user uses Cumulus and want to dump/restore routes.
>>
>> I'm sorry if I misunderstood something.
> 
> Roopa, do you see a problem with the above patch?
> 

The offload flag can be set from userspace but seems to me that should
only be done by the process that talks to hardware. Using iproute2 to
dump routes and then restore them should not set that flag.
