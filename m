Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A74F35200F
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 21:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234978AbhDATnY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 15:43:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233786AbhDATnU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 15:43:20 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F4108C0613E6
        for <netdev@vger.kernel.org>; Thu,  1 Apr 2021 12:43:19 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id w203-20020a1c49d40000b029010c706d0642so4369757wma.0
        for <netdev@vger.kernel.org>; Thu, 01 Apr 2021 12:43:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=8INU5BNyim3VtEL7ZCvgzJyLwztFUnxENE22Fc2bY8w=;
        b=ASjhk4jRbpGF4ln1gCaybXqOUkD4QK6I3mHDv00N7iCeeh0xcy02AERL+F2MOex3pD
         HdlL47xSEwTFj95vHNtqyz3AISiaU1n+jCI972/6940Zh574Bree5AyMVkdwRWUKysWB
         rthRMmBvL2vhsZuAx/1P7kEy+RdbUQbzqSSXJn1i2sniVZTaI6B3DTVpSML/T4MBR2DW
         hIoFEMTQ9Loahx/hU7IH/5EN1I3UKlcS/0UN4V3Rn+TWyhROo21ZtInKWKTbOGYAC6D8
         zDgAJDMNElhXVC6NORHl4zbxkZmHh3iTfRbx0p0iDkxlnLfxrKF3St5GIae7zlZAmm7f
         +xnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8INU5BNyim3VtEL7ZCvgzJyLwztFUnxENE22Fc2bY8w=;
        b=l9U9KNVn6tgFhQS2bvrbrp/IVkKDYXnd8fYc1KwsedTuHs5fbO5WCW+TLArqFS4ld9
         Lb5qm8fuNiP575MaZt1UdIhPW05DbiWUoJ8A1GvzxGo3eKRkiTUzFeY9N5/UOauwxCvj
         lRrJIo3X/5WFJU98A8fXEioxYylcXylpW/Q2bXh8ylvdd7P6BhSxV0TywY9x9fbWJBC4
         cF6iS/gnYqMruht5k69JXMYG5f0uph+Eaa8zWhAGPim6FE5pRUa8bpdMblz6PO6mqqV5
         di1cR0e9auHAVfDYbuks73MR2H48tKdog5m6uLvg9diNCSTRGzG/ObQrMY9v9zG6BaFv
         Didw==
X-Gm-Message-State: AOAM533gVJ72t80QMzXdZGp+ewYu5MYItuklobxh+KuQEZiRFBcmLKsa
        QKU1jlp1HfCjgUnBCf1ubURQU/uUTkw=
X-Google-Smtp-Source: ABdhPJyH2paMrP6u3Ap7oh0ldydpCGKk8RH7tq3RQQY5Bu28qLko438m5iVsk2Mh4V3acbbvskE5og==
X-Received: by 2002:a1c:9d0e:: with SMTP id g14mr9609223wme.30.1617306198558;
        Thu, 01 Apr 2021 12:43:18 -0700 (PDT)
Received: from [192.168.1.101] ([37.173.153.187])
        by smtp.gmail.com with ESMTPSA id y205sm12320446wmc.18.2021.04.01.12.43.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Apr 2021 12:43:17 -0700 (PDT)
Subject: Re: Fw: [Bug 212515] New: DoS Attack on Fragment Cache
To:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
References: <20210401110834.3ca4676b@hermes.local>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <e052b7a8-97bd-59ae-63c1-d94eceb5c868@gmail.com>
Date:   Thu, 1 Apr 2021 21:43:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210401110834.3ca4676b@hermes.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/1/21 8:08 PM, Stephen Hemminger wrote:
> Initial discussion is that this bug is not easily addressable.
> Any fragmentation handler is subject to getting poisoned.
> 
> Begin forwarded message:
> 
> Date: Wed, 31 Mar 2021 22:39:12 +0000
> From: bugzilla-daemon@bugzilla.kernel.org
> To: stephen@networkplumber.org
> Subject: [Bug 212515] New: DoS Attack on Fragment Cache
> 
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=212515
> 
>             Bug ID: 212515
>            Summary: DoS Attack on Fragment Cache
>            Product: Networking
>            Version: 2.5
>     Kernel Version: 5.12.0-rc5
>           Hardware: All
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: IPV4
>           Assignee: stephen@networkplumber.org
>           Reporter: kman001@ucr.edu
>         Regression: No
> 
> Hi,
> 
>     After the kernel receives an IPv4 fragment, it will try to fit it into a
> queue by calling function 
> 
>     struct inet_frag_queue *inet_frag_find(struct fqdir *fqdir, void *key) 
>     in
>     net/ipv4/inet_fragment.c. 
> 
>     However, this function will first check if the existing fragment memory
> exceeds the fqdir->high_thresh. If it exceeds, then drop the fragment
> regradless it belongs to a new queue or an existing queue. 
>     Chances are that an attacker can fill the cache with fragments that will
> never be assembled (i.e., only sends the first fragment with new IPIDs every
> time) to exceed the threshold so that all future incoming fragmented IPv4
> traffic would be blocked and dropped. Since there is GC machanism, the victim
> host has to wait for 30s when the fragments are expired to continue receive
> incoming fragments normally.
>     In pratice, given the 4MB fragment cache, the attacker only needs to send
> 1766 fragments to exhaust the cache and DoS the victim for 30s, whose cost is
> pretty low. Besides, IPv6 would also be affected since the issue resides in
> inet part.
>     This issue is introduced in commit 
> 648700f76b03b7e8149d13cc2bdb3355035258a9 (inet: frags: use rhashtables for
> reassembly units) which removes fqdir->low_thresh, which is used by GC worker.
> I would recommand to bring GC worker back to prevent the DoS attacks. 
> 
>     Thanks,
> Keyu Man
> 



Honestly I do not think we can fix anything.

IP defrag units can easily be flooded by attackers,
no strategy can guarantee that non malicious traffic can make it.

Whole point of 648700f76b03b was to allow admins to increase
storage for frags, increasing chances for frags to be reassembled.

Just say no to frags in general.
