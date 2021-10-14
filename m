Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FACD42D0B3
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 04:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbhJNCyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 22:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbhJNCyG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 22:54:06 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09FE2C061570;
        Wed, 13 Oct 2021 19:52:02 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id h196so2073530iof.2;
        Wed, 13 Oct 2021 19:52:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=78v6ehYr8lkWAmAtl+EulYj9+9VVNSSph/rczTFZO4k=;
        b=Rqjvlj5lj2cg/ECXzgoojZoaDB7+XLotUnE9LIpf/a1lAX+cjfjAoFKlo2IMMeXWTK
         1YjW7fp0qxXmWj6us5i13LNJgu1tUbFE5ZI4rBQ5WF3NPOc/A+5xiBgjB/F40+mqoUW4
         wYeJBCoATKKhUkL0WnUNWsOChMBZWJGmsv7eSL7FV1W8W4fc9F6mcrSv8F5SYBnnnhXu
         kQEXu9lAwqUoYwwKUJZ81LgvnS9yjFQuCmliFPW6RiyOxNmqikPfLoZFm6kA6Xq8FMZR
         YbO8OtjHuNsFGAMrz01/Qa3d7NI4+WA/WFz/fv0DRwzCctiokL7JlBnjzap3IpwTD4Cv
         r9yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=78v6ehYr8lkWAmAtl+EulYj9+9VVNSSph/rczTFZO4k=;
        b=Ci7QNwLKtFC0Y8I6Yut1jHgETgz8l7XZfvk7JSuCW5ThD+wWd7WilgruwizquPERs3
         X8tNTJy6pdQL7c8CYhWTX9wp63C3QydeRoAdG/zZvorncLv3tS+tUzJcsPMWtnp/0ACY
         dgFLwYM9vGrnXf0+LsWDRDOXYkNnMTefmHgLs6qF55jDpNApOKxUKT/1QwsqN8KiqHzn
         f6xLU7pYg51YLNZ9SCAy6JG70Qp1vphoJ/l1rLsHtptBvwCsVsjbEw+jIylH5FDdWo9g
         XHhb2DV0yUktlrRGiC/WduzK6mlFOq8LjF80vHDAcA8Hk9JtqWUvPe3Mzhy1nqPh4wJC
         8+jQ==
X-Gm-Message-State: AOAM530Lky4yIb13Dp7qIG40kzEd4eyXCpNtMAAHSgRCc4vKlhaG8aLJ
        YhaGf/VbY8IScUTkSmZNFaKKcYuk6UT1eg==
X-Google-Smtp-Source: ABdhPJwkQ+Y3YQ+mI7AchvouppRyy4ghOkghjn7WLZWrrWkwJytTdWvalXJUASmAexvU/B6fXVNNwQ==
X-Received: by 2002:a05:6602:2b8f:: with SMTP id r15mr431475iov.93.1634179921459;
        Wed, 13 Oct 2021 19:52:01 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.40])
        by smtp.googlemail.com with ESMTPSA id b4sm630370iot.45.2021.10.13.19.52.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Oct 2021 19:52:00 -0700 (PDT)
Subject: Re: [PATCH] ipv4: only allow increasing fib_info_hash_size
To:     =?UTF-8?B?5byg5Yev?= <zhangkaiheb@126.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211012110658.10166-1-zhangkaiheb@126.com>
 <23911752-3971-0230-cfd2-f8e30e8805db@gmail.com>
 <3bd88b51.6c7.17c77339c10.Coremail.zhangkaiheb@126.com>
 <9404e2d8-0976-1726-5f08-c277cdc14945@gmail.com>
 <5219d023.14d1.17c778a9a18.Coremail.zhangkaiheb@126.com>
 <1e3f52c3.350f.17c78afcc56.Coremail.zhangkaiheb@126.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <fc1bde05-8f7b-9d1f-a55f-8c77cfd55ee3@gmail.com>
Date:   Wed, 13 Oct 2021 20:51:59 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <1e3f52c3.350f.17c78afcc56.Coremail.zhangkaiheb@126.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/13/21 2:05 AM, 张凯 wrote:
> Should we let the function still work when the below check is true, not goto failure?
> 
>        if (new_size < fib_info_hash_size)
>                goto failure;
> 
> 

no, it can not.

if (fib_info_cnt >= fib_info_hash_size) {

means the hash table is full. It is going down this path to expand. If
expansion can not happen then you can not add more entries.

This is all theory hence the request for a simpler change; in reality
there should never be so many unique fib_info entries across namespaces
to hit an overflow.
