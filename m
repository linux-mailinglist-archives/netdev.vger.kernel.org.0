Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4979C370B98
	for <lists+netdev@lfdr.de>; Sun,  2 May 2021 15:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231793AbhEBNIE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 09:08:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230354AbhEBNIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 May 2021 09:08:04 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF5ECC06174A;
        Sun,  2 May 2021 06:07:12 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id c8-20020a9d78480000b0290289e9d1b7bcso2748915otm.4;
        Sun, 02 May 2021 06:07:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YpG7lg+nu21n5XRrxbaXsotuhAePvUqzElZtqUKhgiw=;
        b=bmbN2WPBU9p1vPcZ4O1ILP/AAUK7gWH0JywORv8t8qM59cf535+cWZv7RNExJ1Qgsf
         vzx1SIUFzzlLdfEdXIRT7a7nTWh5SkTUaV69TmhBQt1bywhas15XrejY2k/l+bTrbYCD
         Jfs4dviLzy3fgz6xSs0HnnUHJHb9lRbXWpivWlFEi1pkO6rX1j+C8VsWDZQd25o2fw8w
         1w8L/6Dek5pUx4uvXxuqyx9n2ZCNUtABy8LFSdHwV5lLmVcF8e7Z/wF5gA+vss4FjI7a
         ArHOe/ULfDhz2szuGKN4Lj4Hh//yhiYaHxIEiX2TIOBdWzs5EATVJjzyW6BSAzy117PQ
         3YFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YpG7lg+nu21n5XRrxbaXsotuhAePvUqzElZtqUKhgiw=;
        b=LWeqTThdEi/jqzBbwH2ED0sCmpO8R6wNRsfKPtYEs8sxduvzHM6uTEoLeefA5tN951
         m1wV1OMOTIbh07yYr3oOdBDNc8Zwem9/hjt1xAllvsEHKo9LrrW5KjsjQ0LeEnkp4gG6
         aN4C9CPIhNLUUN3b//PLhNUz3sdyMlZ1rVAjHEymDGnP3SnfIxglWC9Urf/flLxsR6BN
         wOgo0uIpTIUlmIkXFgOj58myHoKRqi5wqIcwUGnj4twJVbGuYftGvbed5RpQqAWJaXyv
         WygV/62uK0z5xVVx3PfFzvhyluyK8PEy77RZdHkipn+ZucVm6appf3/M/g+kCGGLTCNM
         p9Kg==
X-Gm-Message-State: AOAM530R8CkZu2bjAIRkD/tQIL1TtpNTLHfhxckdfvp9Z54OjOAZO53N
        n3UcdXTnELXdQuxqatFT5aM=
X-Google-Smtp-Source: ABdhPJy+ualI+ndYQvuW+cEy2y1/F4IIyMdFdnxVnv4WT5tg98vlwgQ5NV+CgdDIzZxapSo3T5UdgA==
X-Received: by 2002:a9d:39e3:: with SMTP id y90mr11165513otb.257.1619960832028;
        Sun, 02 May 2021 06:07:12 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.33])
        by smtp.googlemail.com with ESMTPSA id 101sm2207294oti.7.2021.05.02.06.07.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 May 2021 06:07:11 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v2] lib/fs: fix issue when
 {name,open}_to_handle_at() is not implemented
To:     Petr Vorel <petr.vorel@gmail.com>,
        Heiko Thiery <heiko.thiery@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
References: <20210430062632.21304-1-heiko.thiery@gmail.com>
 <0daa2b24-e326-05d2-c219-8a7ade7376e0@gmail.com>
 <CAEyMn7ZtziLf__KOGWJfY5OUDoaHSN8jopbKJeK9ZSD1NsZDjw@mail.gmail.com>
 <YI6LDhpn/Esl+Rf8@pevik>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <2dfe91ee-c8b4-91e7-90d9-9c6e4c808cb3@gmail.com>
Date:   Sun, 2 May 2021 07:07:09 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <YI6LDhpn/Esl+Rf8@pevik>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/2/21 5:20 AM, Petr Vorel wrote:
> 
>> What do you mean with finding the right commit? This (d5e6ee0dac64) is
>> the commit that introduced the usage of the missing functions. Or have
>> I overlooked something?

your right; d5e6ee0dac64 is the commit.

> 
> Just put into commit message before your Signed-off-by tag this:
> 
> Fixes: d5e6ee0d ("ss: introduce cgroup2 cache and helper functions")


