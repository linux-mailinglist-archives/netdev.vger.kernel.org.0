Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72A9F3648C7
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 19:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234056AbhDSRKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 13:10:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbhDSRKq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 13:10:46 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67BCAC06174A
        for <netdev@vger.kernel.org>; Mon, 19 Apr 2021 10:10:15 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id i16-20020a9d68d00000b0290286edfdfe9eso22637787oto.3
        for <netdev@vger.kernel.org>; Mon, 19 Apr 2021 10:10:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JYbKOjVmnGQwiR58f9HBa+wgBOgZUKb/HL9ulNIoXC8=;
        b=kfy73cPtB8olgltRl9FBw5XOKz+IWebuATGGeZiDCeWvr/mWC+wJsa7L0MPpODhJP/
         uAz7ehfgDg0PvjfZ0fUGzjajReCKdfjGOckc7Fa/mXIf5o43V8Y1wW/VFWC42I9PWL+W
         gE1l8cTGknHYUzp7G2YdRtFeUL4cuRIBGtXPXA52Zsbc9HFtMYC4MyNsWRSor9gumqnC
         A+n9ZNeEOT661FWppYAHXVrte4M58eHt6OxFDeDBK43hZidz6H4o2OWc1r3UvwN0Kq4U
         7jn952ggBbwcUUN8KduwonBC3peA6dQSdyKbcwoGTQYt6G/nYCURlaAOIvombG/Tplmz
         lJ3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JYbKOjVmnGQwiR58f9HBa+wgBOgZUKb/HL9ulNIoXC8=;
        b=UF6LFM7kHDmBpJMCBmWbXy0GEfE+owuDTS9LpTIVW0vfkczvLRJwtbSaUeycz5YorL
         CXSzeyYmwUeIgFM44otq/wyL+Wt1eoluZMcdNj6xSWm3AgirRQYuBaP1Lr5jj8oBXeD2
         2FeldBl3vyXS/2BdAP1A3lcSYi5P8cCDwh+JTDlrLw+lwTtiy+GEdIal/y9RjBjl6PQc
         9zL2+2qKbi5aqNIZCDAyPOKcGXkzTe4hHa+TVgRKiVGDh3f63nvBCI7mNEoauzkXEfK4
         QxZ5OuyLoeyUFhOjtCFZ16Tfg0N9aA9tk+2i6bAeExZKyR98kKbPKATzODhQ69E8Ucs8
         QInw==
X-Gm-Message-State: AOAM533S2JNrh/xv0Zp++mSohogeWXTpCSj5bpbNKpWcH0GgFpYzv6ss
        LMhCbrIGG6XUKHhSPkdNAjc=
X-Google-Smtp-Source: ABdhPJwpEIQ9/6HFMN19suioJPMlFQdvQHlnYNzbRZV6bHe06AEOxgrjCzudn2l/gL3L9zogjIEuWQ==
X-Received: by 2002:a9d:7606:: with SMTP id k6mr15235598otl.223.1618852214703;
        Mon, 19 Apr 2021 10:10:14 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.45.42.15])
        by smtp.googlemail.com with ESMTPSA id x20sm3269652oiv.35.2021.04.19.10.10.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Apr 2021 10:10:14 -0700 (PDT)
Subject: Re: [PATCH 2/2] neighbour: allow NUD_NOARP entries to be forced GCed
To:     Kasper Dupont <kasperd@gczfm.28.feb.2009.kasperd.net>,
        netdev@vger.kernel.org
Cc:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org,
        Kasper Dupont <kasperd@gjkwv.06.feb.2021.kasperd.net>
References: <20210317185320.1561608-1-cascardo@canonical.com>
 <20210317185320.1561608-2-cascardo@canonical.com>
 <20210419164429.GA2295190@sniper.kasperd.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0b502406-1a86-faec-ff46-c530145b90cf@gmail.com>
Date:   Mon, 19 Apr 2021 10:10:12 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210419164429.GA2295190@sniper.kasperd.net>
Content-Type: text/plain; charset=UTF-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/19/21 9:44 AM, Kasper Dupont wrote:
> On 17/03/21 15.53, Thadeu Lima de Souza Cascardo wrote:
>> IFF_POINTOPOINT interfaces use NUD_NOARP entries for IPv6. It's possible to
>> fill up the neighbour table with enough entries that it will overflow for
>> valid connections after that.
>>
>> This behaviour is more prevalent after commit 58956317c8de ("neighbor:
>> Improve garbage collection") is applied, as it prevents removal from
>> entries that are not NUD_FAILED, unless they are more than 5s old.
>>
>> Fixes: 58956317c8de (neighbor: Improve garbage collection)
>> Reported-by: Kasper Dupont <kasperd@gjkwv.06.feb.2021.kasperd.net>
>> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
>> ---
>>  net/core/neighbour.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
>> index bbc89c7ffdfd..be5ca411b149 100644
>> --- a/net/core/neighbour.c
>> +++ b/net/core/neighbour.c
>> @@ -256,6 +256,7 @@ static int neigh_forced_gc(struct neigh_table *tbl)
>>  
>>  		write_lock(&n->lock);
>>  		if ((n->nud_state == NUD_FAILED) ||
>> +		    (n->nud_state == NUD_NOARP) ||
>>  		    (tbl->is_multicast &&
>>  		     tbl->is_multicast(n->primary_key)) ||
>>  		    time_after(tref, n->updated))
>> -- 
>> 2.27.0
>>
> 
> Is there any update regarding this change?
> 
> I noticed this regression when it was used in a DoS attack on one of
> my servers which I had upgraded from Ubuntu 18.04 to 20.04.
> 
> I have verified that Ubuntu 18.04 is not subject to this attack and
> Ubuntu 20.04 is vulnerable. I have also verified that the one-line
> change which Cascardo has provided fixes the vulnerability on Ubuntu
> 20.04.
> 

your testing included both patches or just this one?


