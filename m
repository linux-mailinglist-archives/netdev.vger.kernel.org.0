Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8F203F9B73
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 17:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233912AbhH0PKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 11:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233779AbhH0PKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 11:10:30 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C4DAC061757
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 08:09:41 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id s11so6178658pgr.11
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 08:09:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Ef4lJCrue7prPzzws1dA4pW3iYR9I3bSYGXyuAMO3/M=;
        b=LBGkR3pz73E0tMscG0RziPLvawPGGBpHNKPeYGCpzEaE8TApXE4DjVx2CqrVJBp2Q8
         pNLIwJKUzefsGnXuCO13y4RR8Y8zCuNOfP9eDKWwg2AsZjbF0f1KY9PJt/3qKKOVlQH7
         4ejn5j08+zxyjIo/uWDoak6OCGRVmXBR26pBP+qJz/ua/b/sc1ekt2BCr584+eoPE4Su
         KjAlxGx7BXwwdD54Tt8r8VHzNm1ADcqXszS5rmxdscNtINjB6bUBm+Gn0BzvvR7n8RE3
         Mywtvt9lRrTIyfWrZ/OnmKNtwogjFlomHlOzG3F8yg4VA1K2tEZvY8RUAOMYmi57iO+R
         rDGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ef4lJCrue7prPzzws1dA4pW3iYR9I3bSYGXyuAMO3/M=;
        b=LHUn4ztoYg1i52rT5IWooAZtN62B21NsuZHZ7bP8U26ic3/JBspk06bJCdrr1Tn0ox
         qn0uoF7ovh7iXdg9GqPuGO07ChFvu+ekuE919I5P1o76YNnWilqi1JGWs6zcr0WCEVUG
         u2DrGDsZDySdKQUYEVtjw4H43nnKWZkqEfZ1OcRK6v/fV8z2jegqL6CnmXUcMMUfSWbP
         TYAViSIuzgcwBCmAYMj+DsitN8X9y5OLlGd2fpkMV3vwJN3Fx6A8xfZxuZadWEWVwWje
         e7mCp1HQpsCDpXbI3FHZH8ioKMAvZCXVZdsDJChaIBAPgGGMmWpd1gbscPw93p7PhIjM
         Ew3g==
X-Gm-Message-State: AOAM532ftQGH040Y+aFxH2gULJDpA7EjQKDF4TORRudTO/b6fYq0LQBL
        oZ0lw1nHHJFOzgx3WTZ2dwY=
X-Google-Smtp-Source: ABdhPJzuWw6QD9k9BUaf9g2918hM5bPhoVlK+IJ3moNdU0CI5Sw+Ef77yn/p4W639dyNK0PX38tqeg==
X-Received: by 2002:a63:d106:: with SMTP id k6mr8262511pgg.234.1630076980663;
        Fri, 27 Aug 2021 08:09:40 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id t42sm6406216pfg.30.2021.08.27.08.09.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Aug 2021 08:09:40 -0700 (PDT)
Subject: Re: Question about inet_rtm_getroute_build_skb()
To:     David Ahern <dsahern@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Networking <netdev@vger.kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>
References: <4a0ef868-f4ea-3ec1-52b9-4d987362be20@gmail.com>
 <d02bd384-526f-7b87-4c73-137f26cf8519@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <7bdb1675-7520-8d97-4386-20e2235368df@gmail.com>
Date:   Fri, 27 Aug 2021 08:09:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <d02bd384-526f-7b87-4c73-137f26cf8519@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/26/21 9:37 PM, David Ahern wrote:
> On 8/26/21 6:16 PM, Eric Dumazet wrote:
>> Hi Roopa
>>
>> I noticed inet_rtm_getroute_build_skb() has this endian issue 
>> when building an UDP header.
>>
>> Would the following fix break user space ?
> 
> I do not see how. As I recall this is only for going through
> ip_route_input_rcu and ip_route_output_key_hash_rcu and a call to
> fib4_rules_early_flow_dissect.
> 

Ah, nice !

Could we add a test for this feature ?
I could not really figure out reading the commit changelog how this stuff was used.
