Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F4792FA7CA
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 18:45:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436724AbhARRo2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 12:44:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436663AbhARRoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 12:44:05 -0500
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 120C1C061573
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 09:43:25 -0800 (PST)
Received: by mail-ot1-x32c.google.com with SMTP id x13so17038726oto.8
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 09:43:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=59eBgm74+HlMjwAP32RS7s81AbEfQ5GIcve9hr3guVw=;
        b=ciQw3Lvn+I/+fU5G7BvWx4tDhahk/8fLFUHUj/YgOyri3jGBqdyhdDKlQlOaqPgp23
         xJE8ZbdLbSJ45/4khwpjIliCMVerUpF14uhUH+w8vqXbj/SqKcC63WFp00JSj4jihqy3
         44jVck9dZofwWY6NJIDrBwNmWQPl64LAWEs9Uhuf++ZV/+3foTG0Jswk9T7xj7LPrw0+
         /w32vrc9TwUVYmmCnA2S3xSraft+qYkjt8AXHP2FGBqMACEuZdw9OFnzpxiXodVJXA/8
         W7XqXVMfQ42FA0NyCI6GhQcuIE1kgxq5Oi6MRKcHQE0TVoyvw3YijpsuXTzKVdg2lKfT
         XHsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=59eBgm74+HlMjwAP32RS7s81AbEfQ5GIcve9hr3guVw=;
        b=lA71HaDM353HKKkT3H5cbSGfoJF1E+S+9EZi6EVf0Cgg0uz+4F+lCZiViytmb1+Egx
         Q8/t8fbCP+RqgqC9RjubvPUWczH70tBHLCKlLwtZPf3b46tgS8UHXPOaDV72Z3oLPxte
         DWMmgt5FylTfBygZvqAJzh84o8rsp6oHA7mAABVjy0y8+xcp6+454Kk2cH5fT0LousoX
         p9jrSgktjSOz2C/I+2+FRtLlSRE4/Q2dX1xBUCdBB1KfoewM4p8w+i4+QyGYmNY7jseP
         Pm9Lx8urzc7sRv0tj8ZgpqUa5XSo5tAU7ltr8xfcSGGtMqE1z+nQRhUZ//YTk+QWtrWY
         lmRw==
X-Gm-Message-State: AOAM531uVljmaY6JKsCiJtNHTGfJ7CBhc7WtU7wB9HhVTgcVD9MQvNVe
        HQtEl0tDx4+GhAOQrK10v8M=
X-Google-Smtp-Source: ABdhPJwzJ+Hnrn3lKw/HBkl5f2dSbN7g4Lzzw3p9gsGAnEP3VBWNzpBq3iMNh93ZLBlhHu8fHCGmpQ==
X-Received: by 2002:a05:6830:1db7:: with SMTP id z23mr480614oti.314.1610991804448;
        Mon, 18 Jan 2021 09:43:24 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.20.123.34])
        by smtp.googlemail.com with ESMTPSA id g12sm3791898oos.8.2021.01.18.09.43.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jan 2021 09:43:24 -0800 (PST)
Subject: Re: [PATCH net-next 0/3] nexthop: More fine-grained policies for
 netlink message validation
To:     Petr Machata <petrm@nvidia.com>, netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.org>
References: <cover.1610978306.git.petrm@nvidia.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f2ba918f-6781-3740-fe49-756fe4fb40c5@gmail.com>
Date:   Mon, 18 Jan 2021 10:43:22 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <cover.1610978306.git.petrm@nvidia.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/18/21 7:05 AM, Petr Machata wrote:
> From: Petr Machata <petrm@nvidia.org>
> 
> There is currently one policy that covers all attributes for next hop
> object management. Actual validation is then done in code, which makes it
> unobvious which attributes are acceptable when, and indeed that everything
> is rejected as necessary.
> 
> In this series, split rtm_nh_policy to several policies that cover various
> aspects of the next hop object configuration, and instead of open-coding
> the validation, defer to nlmsg_parse(). This should make extending the next
> hop code simpler as well, which will be relevant in near future for
> resilient hashing implementation.
> 
> This was tested by running tools/testing/selftests/net/fib_nexthops.sh.
> Additionally iproute2 was tweaked to issue "nexthop list id" as an
> RTM_GETNEXTHOP dump request, instead of a straight get to test that
> unexpected attributes are indeed rejected.
> 
> In patch #1, convert attribute validation in nh_valid_get_del_req().
> 
> In patch #2, convert nh_valid_dump_req().
> 
> In patch #3, rtm_nh_policy is cleaned up and renamed to rtm_nh_policy_new,
> because after the above two patches, that is the only context that it is
> used in.
> 
> Petr Machata (3):
>   nexthop: Use a dedicated policy for nh_valid_get_del_req()
>   nexthop: Use a dedicated policy for nh_valid_dump_req()
>   nexthop: Specialize rtm_nh_policy
> 
>  net/ipv4/nexthop.c | 85 +++++++++++++++++-----------------------------
>  1 file changed, 32 insertions(+), 53 deletions(-)
> 

good cleanup. thanks for doing this. Did you run fib_nexthops.sh
selftests on the change? Seems right, but always good to run that script
which has functional tests about valid attribute combinations.
