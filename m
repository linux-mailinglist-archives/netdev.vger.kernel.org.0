Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD1A3386F9E
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 03:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346138AbhERBvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 21:51:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346136AbhERBvl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 21:51:41 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F80FC061573
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 18:50:24 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id w127so4479698oig.12
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 18:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3K79L3234K19/ZjKESb7wj9w9x47uj6HZH+jT3eEf8s=;
        b=TZBrgm4oc/oi2nBgs8IPTyO9IPlpSzEQixgJZf2oiOOGxYbq171msf73awq09B2sKa
         d+DRYMJzTYs4V9Fzizh2pOXaGKluJy+iegikjJzA9GJ+JymbIsAbV8o1IT3Ut8+/jJSQ
         nMMdyCToxdKb2MReuP/mdaEbXIdDMASL7UVkIVQZrGk3C/xzCtDl6cINWHq8hhycB+G/
         hKgt5SHWRKM/MN3y9l7mW+Zxr39e7uWGOHxrOKo5l2YZ9wx4FDLtfGPyoykv9eH5onH8
         ub0fX7FaeYXzhmyNaXenz8c6wVCHnW3AVK0asLZqVNJzV20vPh0SzjJKfyci7SxI8z+3
         GI1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3K79L3234K19/ZjKESb7wj9w9x47uj6HZH+jT3eEf8s=;
        b=TV9QGYKsZZ/DsW9IMz+70nIlPPvT/iWFr7hsCDk1vrJPA2QwFfSnI0hDAExJbyHNgo
         wzZKBf9lWZJJhQ0zJ65CUk8pR9xKzV5v7pzOIAxtUU/7svz7OsOMN+00B5MXvbusUhmC
         tTD+1wToP/8PSK9L4lh6IsheS4kPcTwQURq7xbiFoUMKBkQ6bCDQlgknTk577qxhuWxj
         OSHwpWo4ULPRjSd9uMY69m3fO0xk4bi7JG10+dC25K1Btbdv4HBGp6D1ZycFglVNWcvg
         AZbsNhnjz8NQEy8dFp1nddhd9ne4cWXDjK4/L3jAWqhai14jTQZGq0tPcbpm7w8D7hkm
         3e5Q==
X-Gm-Message-State: AOAM530dYTdvzMj3H4MhinpYauWlsHXpIsBJzGy1tewsAqLNZQHwVaMz
        i64kMw024YBu/7yjttW854U=
X-Google-Smtp-Source: ABdhPJx6WAboDbep6+WBCaPbiVDtSKQpB0vn4wbV+eY1Pc4wyeBOJgnbDzuPkaAAPmfD5unMe2hBGQ==
X-Received: by 2002:a05:6808:249:: with SMTP id m9mr2040755oie.120.1621302623658;
        Mon, 17 May 2021 18:50:23 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.22])
        by smtp.googlemail.com with ESMTPSA id x24sm3513283otq.34.2021.05.17.18.50.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 May 2021 18:50:23 -0700 (PDT)
Subject: Re: [PATCH net-next 10/10] selftests: forwarding: Add test for custom
 multipath hash with IPv6 GRE
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        roopa@nvidia.com, nikolay@nvidia.com, ssuryaextr@gmail.com,
        mlxsw@nvidia.com
References: <20210517181526.193786-1-idosch@nvidia.com>
 <20210517181526.193786-11-idosch@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0ba95b3f-6a54-ced7-f454-bcef18896373@gmail.com>
Date:   Mon, 17 May 2021 19:50:21 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210517181526.193786-11-idosch@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/17/21 12:15 PM, Ido Schimmel wrote:
> Test that when the hash policy is set to custom, traffic is distributed
> only according to the inner fields set in the fib_multipath_hash_fields
> sysctl.
> 
> Each time set a different field and make sure traffic is only
> distributed when the field is changed in the packet stream.
> 
> The test only verifies the behavior of IPv4/IPv6 overlays on top of an
> IPv6 underlay network. The previous patch verified the same with an IPv4
> underlay network.
> 

...

> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  .../ip6gre_custom_multipath_hash.sh           | 458 ++++++++++++++++++
>  1 file changed, 458 insertions(+)
>  create mode 100755 tools/testing/selftests/net/forwarding/ip6gre_custom_multipath_hash.sh
> 

Acked-by: David Ahern <dsahern@kernel.org>


