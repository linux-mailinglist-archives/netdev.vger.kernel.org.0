Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6B32B2175
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 18:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbgKMREy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 12:04:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726249AbgKMREw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 12:04:52 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C368C0613D1;
        Fri, 13 Nov 2020 09:04:52 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id o11so10441176ioo.11;
        Fri, 13 Nov 2020 09:04:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6wbi7jT1+rgehcP1UuwHoeywTkGOLRJKgi1Ov4FuI0k=;
        b=IhqMnDShVApR82yMRXsBaQrh6QrFRiBAN2apeBW6PgXcwHnkZihmR8sQGa9covr/Nr
         E59TSvthh1GpGZ/oFHD/qN9wH8Qp78Km2FRbPWe+tCK9iyq+tjOukMRkd06r3rbkNoLy
         UoEWaoC0UpZ1ijAuZvbKk+g87OXb4llBbA+qgAjsin4ZlGxgItwxomtStCHInkJnsfbN
         3jtYyvmKkwSu2HmWcdIOszv8CJEFqPP8u5Y8XlQJFpSGTj1+8Ha+AcHbk4vm2wmCKWcv
         ewQDI4w+/FsAoEitHwZOyVzItoyuY+Aq3fotYIYGWgsFIuD9NzUAMNA5o7jT/BRjLr+B
         qNeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6wbi7jT1+rgehcP1UuwHoeywTkGOLRJKgi1Ov4FuI0k=;
        b=luyqJLJ99QutTq0en/YqVcZosG1ccjwCaJYrEUL798HmAzdKtI3ZrvxqlVXvcsrvH2
         mMBGMn08YxUVWUjCDgEJV5Q20rAMIZ+Y/ctwKt+PSNrI+N/atlR5bR2XrFlJ+I+2Nkhn
         XzzFeOhdAKUISa/Vw8XiLJD7H12yauyx0YH5Nv6QTz9Iaqp27hOpE32wj0WEBHvGqnlA
         r0PlGy6drrMheQ8KASI3MEfm4uQK28E4o00D9lgf8eMPe4gDmhQ6W2Is2nW2jylg9iKe
         B3yGqnpG3YKlp+At0OrTwHaDAhrOkQNVKHJtxe0a6v6HxH4fd6Yl9IGuEA6hb1cmfsML
         RFvw==
X-Gm-Message-State: AOAM530h2jDAj7HhspzIEjHDE0pOCDrBOoGzSLnd4P/P1QmGuD03W6cB
        nOous6D08B6FO8qzUcyvGGs=
X-Google-Smtp-Source: ABdhPJzV74ThdYJsJHYzIbk4mn+G8wCEjCr7oYYP4/NKzPO435awEHfPDqXLvz5gZ3yhskwv41Vgpw==
X-Received: by 2002:a6b:6001:: with SMTP id r1mr551208iog.144.1605287087097;
        Fri, 13 Nov 2020 09:04:47 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:99e7:10e8:ee93:9a3d])
        by smtp.googlemail.com with ESMTPSA id c8sm4471334ioq.40.2020.11.13.09.04.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2020 09:04:46 -0800 (PST)
Subject: Re: [net-next,v2,4/5] seg6: add support for the SRv6 End.DT4 behavior
To:     Stefano Salsano <stefano.salsano@uniroma2.it>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrea Mayer <andrea.mayer@uniroma2.it>,
        "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>
References: <20201107153139.3552-1-andrea.mayer@uniroma2.it>
 <20201107153139.3552-5-andrea.mayer@uniroma2.it>
 <20201110151255.3a86afcc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201113022848.dd40aa66763316ac4f4ffd56@uniroma2.it>
 <34d9b96f-a378-4817-36e8-3d9287c5b76b@gmail.com>
 <20201113085547.68e04931@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <bd3712b6-110b-acce-3761-457a6d2b4463@uniroma2.it>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <09381c96-42a3-91cd-951b-f970cd8e52cb@gmail.com>
Date:   Fri, 13 Nov 2020 10:04:44 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.2
MIME-Version: 1.0
In-Reply-To: <bd3712b6-110b-acce-3761-457a6d2b4463@uniroma2.it>
Content-Type: text/plain; charset=iso-8859-15
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/13/20 10:02 AM, Stefano Salsano wrote:
> Il 2020-11-13 17:55, Jakub Kicinski ha scritto:
>> On Thu, 12 Nov 2020 18:49:17 -0700 David Ahern wrote:
>>> On 11/12/20 6:28 PM, Andrea Mayer wrote:
>>>> The implementation of SRv6 End.DT4 differs from the the
>>>> implementation of SRv6
>>>> End.DT6 due to the different *route input* lookup functions. For
>>>> IPv6 is it
>>>> possible to force the routing lookup specifying a routing table
>>>> through the
>>>> ip6_pol_route() function (as it is done in the
>>>> seg6_lookup_any_nexthop()).
>>>
>>> It is unfortunate that the IPv6 variant got in without the VRF piece.
>>
>> Should we make it a requirement for this series to also extend the v6
>> version to support the preferred VRF-based operation? Given VRF is
>> better and we require v4 features to be implemented for v6?
> 
> I think it is better to separate the two aspects... adding a missing
> feature in IPv4 datapath should not depend on improving the quality of
> the implementation of the IPv6 datapath :-)
> 
> I think that Andrea is willing to work on improving the IPv6
> implementation, but this should be considered after this patchset...
> 

agreed. The v6 variant has existed for a while. The v4 version is
independent.
