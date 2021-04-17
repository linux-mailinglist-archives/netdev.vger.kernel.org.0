Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCB67362C6E
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 02:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235046AbhDQAcI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 20:32:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbhDQAcH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 20:32:07 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3E1FC061574;
        Fri, 16 Apr 2021 17:31:41 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id n140so29588521oig.9;
        Fri, 16 Apr 2021 17:31:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VR3tcAp12whRBeJfwrOFnSVzrr3wsAblS3SVMAqZZtA=;
        b=h2XhWyNjac/+3AX0AhwaYIHnw7NmpR4+5Rxz9+t8TlX6al4aSfFEalHta02YSNjf5E
         UkFQL6YD7SueUO8Xy5OZIIDyaXSgT2dhZf3dlJzKWAly4CmcfSoelvKCyJW6ABs8fIO+
         1EOQjwUhgkTu93uc3CzS0PKw3yoIxcbI1ib5OrNLN8eCrQXiJaIH4dFihzl4eIQNoQfk
         PY7bD6l8cvt6M08en6t0YUpBxPHRZzNeGYVFaTgflefT0YwE8rsxqz7VDWnXtFZ/6uPn
         6gXnEOhk5ZiQjvUUGggOIGTwQHLNUbJSv2MRsa9sIWR9c8UOyxSaCoe+n9bXdOoVsZzh
         PHKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VR3tcAp12whRBeJfwrOFnSVzrr3wsAblS3SVMAqZZtA=;
        b=qKJElWt7hQVGJSD8FghieGltbr6BnMDMI1RYRrAkr/7+JA3q9XFWK18Dnyon9oHvTO
         cPeg27naonWP8ljKkSUeb+8eNPEzbhUiTrAZUNCFFkCA4NYeftrbRfaqOFt04/6+P64Z
         +tyfoB6F21FBmKVi9dQgtWkN9RFQK9MR7uX00FurhG5jHizyyKNeZelavHSPaBzUEGuE
         3tV6hjaPRkTYmGLcptUgAhr04ethE0M7QnSht2XgNDmHSyBKpA+AOG0xk/dSQbByaE2K
         TOJFVLOk8f5eVxbK/DtFYAvkJknJ/5kYIsly2Tt5XlwDQwIaU6N+LkilIH9dkmEzeSgk
         uEQQ==
X-Gm-Message-State: AOAM530psLs1Psv423BkEwPpaP94x1Lnz/6mtzsIK1SwBpjV6ScVtbYx
        qIGumQk60q4Xr7Mh4wmhfug=
X-Google-Smtp-Source: ABdhPJziqLSucJxQxgq7rZyUjNkQWZLeBiuarEiQlB6qzvMg2DNK6MnpuBP5W/KODQ0byTnBz/N3YQ==
X-Received: by 2002:aca:47ce:: with SMTP id u197mr8180544oia.81.1618619500965;
        Fri, 16 Apr 2021 17:31:40 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.45.41.12])
        by smtp.googlemail.com with ESMTPSA id l5sm1104397otr.72.2021.04.16.17.31.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Apr 2021 17:31:40 -0700 (PDT)
Subject: Re: PROBLEM: DoS Attack on Fragment Cache
To:     Keyu Man <kman001@ucr.edu>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zhiyun Qian <zhiyunq@cs.ucr.edu>
References: <02917697-4CE2-4BBE-BF47-31F58BC89025@hxcore.ol>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <52098fa9-2feb-08ae-c24f-1e696076c3b9@gmail.com>
Date:   Fri, 16 Apr 2021 17:31:38 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <02917697-4CE2-4BBE-BF47-31F58BC89025@hxcore.ol>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ cc author of 648700f76b03b7e8149d13cc2bdb3355035258a9 ]

On 4/16/21 3:58 PM, Keyu Man wrote:
> Hi,
> 
>  
> 
>     My name is Keyu Man. We are a group of researchers from University
> of California, Riverside. Zhiyun Qian is my advisor. We found the code
> in processing IPv4/IPv6 fragments will potentially lead to DoS Attacks.
> Specifically, after the latest kernel receives an IPv4 fragment, it will
> try to fit it into a queue by calling function
> 
>  
> 
>     struct inet_frag_queue *inet_frag_find(struct fqdir *fqdir, void
> *key) in net/ipv4/inet_fragment.c.
> 
>  
> 
>     However, this function will first check if the existing fragment
> memory exceeds the fqdir->high_thresh. If it exceeds, then drop the
> fragment regardless whether it belongs to a new queue or an existing queue.
> 
>     Chances are that an attacker can fill the cache with fragments that
> will never be assembled (i.e., only sends the first fragment with new
> IPIDs every time) to exceed the threshold so that all future incoming
> fragmented IPv4 traffic would be blocked and dropped. Since there is no
> GC mechanism, the victim host has to wait for 30s when the fragments are
> expired to continue receive incoming fragments normally.
> 
>     In practice, given the 4MB fragment cache, the attacker only needs
> to send 1766 fragments to exhaust the cache and DoS the victim for 30s,
> whose cost is pretty low. Besides, IPv6 would also be affected since the
> issue resides in inet part.
> 
> This issue is introduced in commit
> 648700f76b03b7e8149d13cc2bdb3355035258a9 (inet: frags: use rhashtables
> for reassembly units) which removes fqdir->low_thresh, and GC worker as
> well. We would gently request to bring GC worker back to the kernel to
> prevent the DoS attacks.
> 
> Looking forward to hear from you
> 
>  
> 
>     Thanks,
> 
> Keyu Man
> 

