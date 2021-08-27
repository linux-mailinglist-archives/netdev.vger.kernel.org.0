Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6360D3F9CB8
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 18:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbhH0QrA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 12:47:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbhH0QrA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 12:47:00 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 283E2C061757
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 09:46:11 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id mw10-20020a17090b4d0a00b0017b59213831so9306151pjb.0
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 09:46:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=8nyUWAY8h2lt3quRbyMoSQT9EQw5lQjRhXZv9fOjBSQ=;
        b=uerK6a/kU+rw0q/JgXgoTco9vvVhEmo/nyVTIyeyQpmmEy5TPSMkbjBm5skspP7pVP
         +17jpbE+MYc6TYZtudu0NqxelIv7Fvv5qTlowN1l7IQx/d3ghOTpsrE8cDfc1HCCLdGv
         ZtrNKA/2iS7q+9lwsFBK7Iw/S9B5t8yB6Qwsib3UEHjlB8nDrt7VO9n4MDqaSZWU1AMq
         VvbfWP6uFUNuT+4YlN2w8Ogcfe7oQpANTKIzWP4JKFE+PIBJILbAnoGqcY2HdPhxvJL9
         KLxlIPKsd36QXcUOChGTSrgdmHDi0oF2/aER45hHOq0WRcBb0wux0xgLgtaoebE45Var
         nf3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8nyUWAY8h2lt3quRbyMoSQT9EQw5lQjRhXZv9fOjBSQ=;
        b=dsFx2APlN8cDL8svMKa2iJ1Uxc0yrrqFBMR5ttuPqUn2dOaWufXfwWFUobr/K8UEz1
         PQS0VXCIbDFqXvXHAtMiz+9gUH1m2TTDzEwA0eoJ8UMGKdMuGjM3m7WxAqPBfv1MNPa9
         K9MALW4yyMAYs20PAYLTJikBLkHSphKp+vMMqQvkt4edPbWV6JUcal/7d0JlWOKlJCY6
         96A5fyjglxsjv7a1xCEsitP6Cn7PaoZl/sm4ThQ/6XqgDnRrFX2iwVCOD5WqjLy8cbep
         ZDR5ofmU7jty7E+ABarpnwO65beRINhH3Px0giDcBxCQAtiJ679bZOWwPi5b7JW7TRk/
         QHnA==
X-Gm-Message-State: AOAM531EyRnRZFV9hat7LirwpjL/T9tBH6ir3XX5hwvlk7tL+y1afpYb
        pi0bULp0L74p4Pjow7rvw/c=
X-Google-Smtp-Source: ABdhPJy/6BWYycBukvfahVhEHDVYkKBTTQspvapbqSgAI65o/dge9+ExeCIG5lVaCfbbs65GrhFRiQ==
X-Received: by 2002:a17:90a:8005:: with SMTP id b5mr24260893pjn.190.1630082770713;
        Fri, 27 Aug 2021 09:46:10 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([72.164.175.30])
        by smtp.googlemail.com with ESMTPSA id t12sm8078108pgo.56.2021.08.27.09.46.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Aug 2021 09:46:10 -0700 (PDT)
Subject: Re: Question about inet_rtm_getroute_build_skb()
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Networking <netdev@vger.kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>
References: <4a0ef868-f4ea-3ec1-52b9-4d987362be20@gmail.com>
 <d02bd384-526f-7b87-4c73-137f26cf8519@gmail.com>
 <7bdb1675-7520-8d97-4386-20e2235368df@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c9655e53-b605-6ebb-53ce-8adbc6ffbec3@gmail.com>
Date:   Fri, 27 Aug 2021 09:46:08 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <7bdb1675-7520-8d97-4386-20e2235368df@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/27/21 8:09 AM, Eric Dumazet wrote:
> 
> 
> On 8/26/21 9:37 PM, David Ahern wrote:
>> On 8/26/21 6:16 PM, Eric Dumazet wrote:
>>> Hi Roopa
>>>
>>> I noticed inet_rtm_getroute_build_skb() has this endian issue 
>>> when building an UDP header.
>>>
>>> Would the following fix break user space ?
>>
>> I do not see how. As I recall this is only for going through
>> ip_route_input_rcu and ip_route_output_key_hash_rcu and a call to
>> fib4_rules_early_flow_dissect.
>>
> 
> Ah, nice !
> 
> Could we add a test for this feature ?
> I could not really figure out reading the commit changelog how this stuff was used.
> 

tools/testing/selftests/net/fib_rule_tests.sh

I do not see the udp variant, so yes, those should be added.
