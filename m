Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED1692B1AB8
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 13:05:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbgKMMEy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 07:04:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726536AbgKMLfx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 06:35:53 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9811BC0617A6;
        Fri, 13 Nov 2020 03:34:21 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id 33so9415345wrl.7;
        Fri, 13 Nov 2020 03:34:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GMSoaYGH0pA9Jq20ijPobnsXJLhxhfT0yN3dukQKp6A=;
        b=LQlxVlKrvCkLWpBdDs/58N3IpmTopAyTws9kNHZKVjci2aBi1KeRGvBuLX3Spgfi5e
         zpsWdcAR5ty1QGG1399GotlpH1BqS5IYBsNKJDMIjqQQXunfMczgQrn1490UCWHS6P4d
         3OwmNxDiFuwYS8ZGX/dAzL/8PBFBlsS1pGuHYAbKe0jDT8JvUG2RmWO2ShVciJ/YK/ql
         ANmrM28vnx9onF4QRkv0o6w6p2+JYDrxbAYPfFE5B+X6ddFHhbkdMUiVKcZ4po1o8Td2
         W3oocH6cjfpeFTp63SmGwJuwj6OHv7l+Rh9OSMNDqwkjTEOq1sgE8ugKM0f4F6lKBAFF
         Xm+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GMSoaYGH0pA9Jq20ijPobnsXJLhxhfT0yN3dukQKp6A=;
        b=NXL/d17CWz4UNPlCI0yqbGkA0xLhecFmQE+HEwQerFpKk1cqcL6jYRhz3BOXnT+p06
         ZxG6Dz9wT2/Gw0wedGlJL2VegjWC9tLl2kc6fz0PmTSf+i7GOr6PhPDCff3Ejrv6BmxX
         ZESc7W7KQjbUc9Hv+/bLJ/hnwf0Hjt79vYNJ2lpyE3NN8c9Z5ReuuhmLBPXmUUyhEQqN
         r9rqJKGYmdUATOGMRmNP+wIjhnemQu8wb0z2QuNiZLnULTSH8exlvhZGl6+7C6y7NkhW
         Up3WHUUt8bZ8AWzsFKLdXAsv7yZQh+wGy1mr5UGm/eX/0t6Xb6fYpgOJplr9oZY5lfRi
         7GtQ==
X-Gm-Message-State: AOAM530Fe/gtf9NO4trdsOyXg9Kj8o3RE0rZtMyElKUGe7SGSxiRznZ6
        uKxPb0SxaXobvcjWGmIxvDU=
X-Google-Smtp-Source: ABdhPJyzAQ2D5zO01xFQdEApfeD/HaEk9Rw5kL9gKvfUGhUiYT0F9Hi4TU3agolrFc6X50eVsg9zgg==
X-Received: by 2002:adf:cf0b:: with SMTP id o11mr2844517wrj.162.1605267260409;
        Fri, 13 Nov 2020 03:34:20 -0800 (PST)
Received: from [192.168.8.114] ([37.167.2.65])
        by smtp.gmail.com with ESMTPSA id g23sm9865657wmh.21.2020.11.13.03.34.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2020 03:34:19 -0800 (PST)
Subject: Re: csum_partial() on different archs (selftest/bpf)
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Cc:     Tom Herbert <tom@herbertland.com>,
        Anders Roxell <anders.roxell@gmail.com>,
        linux-riscv <linux-riscv@lists.infradead.org>
References: <CAJ+HfNiQbOcqCLxFUP2FMm5QrLXUUaj852Fxe3hn_2JNiucn6g@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <e23c63dd-5f90-c273-615f-d5d67991529c@gmail.com>
Date:   Fri, 13 Nov 2020 12:34:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <CAJ+HfNiQbOcqCLxFUP2FMm5QrLXUUaj852Fxe3hn_2JNiucn6g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/13/20 11:36 AM, Björn Töpel wrote:
> I was running the selftest/bpf on riscv, and had a closer look at one
> of the failing cases:
> 
>   #14/p valid read map access into a read-only array 2 FAIL retval
> 65507 != -29 (run 1/1)
> 
> The test does a csum_partial() call via a BPF helper. riscv uses the
> generic implementation. arm64 uses the generic csum_partial() and fail
> in the same way [1]. arm (32-bit) has a arch specfic implementation,
> and fail in another way (FAIL retval 131042 != -29) [2].
> 
> I mimicked the test case in a userland program, comparing the generic
> csum_partial() to the x86 implementation [3], and the generic and x86
> implementation does yield a different result.
> 
> x86     :    -29 : 0xffffffe3
> generic :  65507 : 0x0000ffe3
> arm     : 131042 : 0x0001ffe2
> 
> Who is correct? :-) It would be nice to get rid of this failed case...
> 

There are all the same value :), they all fold to u16  0xFFE3

Maybe the test needs a fix, there is a missing folding.

> 
> Thanks,
> Björn
> 
> 
> [1] https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20201112/testrun/3430401/suite/kselftest/test/bpf.test_verifier/log
> [2] https://qa-reports.linaro.org/lkft/linux-mainline-master/build/v5.10-rc3-207-g585e5b17b92d/testrun/3432361/suite/kselftest/test/bpf.test_verifier/log
> [3] https://gist.github.com/bjoto/dc22d593aa3ac63c2c90632de5ed82e0
> 
