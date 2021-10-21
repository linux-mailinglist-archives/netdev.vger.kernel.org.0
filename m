Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 119EA4358AB
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 04:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbhJUCfp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 22:35:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbhJUCfo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 22:35:44 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A489C06161C
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 19:33:29 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id l16-20020a9d6a90000000b0054e7ab56f27so10566836otq.12
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 19:33:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=stkmHhx1iKeWjBm6oYkdsXBtypyKpsolsaCEB2scX+A=;
        b=GuJWwgC9bgUh17oyqeDp4Nlmp2IjlERxCfYntPE3lf/Rq8+EbDpr1eFrcf5ZkLMnrw
         mfMlKKAmK1ac5VnJgIOC1f6/WEAuy9tJiUY+KdC8M386fL+GMGKXj5JT3uPzL2T3PyQq
         mmrCfcpfep7ZHzYR3TKbKooqTvN6QdkY0B7CvgIxwCB+SgGZeDNDofM9m9MBZOKlk8/N
         e3I1VA4+ORy5YJbg4WQJvR6T3AQd0ufYOfRLsR3guqd4CwyAdcTaVrrljrRa430hokLX
         gn5uBvSqh0DeXlAC8tV1+3796dQ5lba4rEKx8sYaZNn8z/C8p0/Q93OVIkV677ac/284
         kMiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=stkmHhx1iKeWjBm6oYkdsXBtypyKpsolsaCEB2scX+A=;
        b=zACOlHPnnJyw1Ca4vTipdR7rYqboHrnmXzPdiJHtQBlj7Ky7uymK0V9sCaiXzU1iTA
         CWn3N4f3mGOpO7TJSjR/M6J8iJHMnkGzXa5mMvdvfKz57RRLuhfUVzuD9wRyZzF05Lrd
         0A1d+kuS6RmQAYEEfbN5NjyoKZDqrTclp2xiR6YNCXplvhwUQZS3DL9quteeVZ2wLeym
         THh1se1xqiiSR0/RQdei0jQPX6z97Aj4eSlLT+haxGJQNSFxyiXOG2FQxnejXpMXVkzJ
         kayqlkXJ9efKNMPWAjMaT6G73JJE/POnmXFLlCFyYri1TI8fSBbl1Rv/LgOfqXY13wd9
         uVHQ==
X-Gm-Message-State: AOAM530+ZE2cWbpapbzRwX1n119vsgSxG5znB8ng/7M0Ce9LuiNUue2A
        zoGdCwUIeuRoSJIM3TZTbXk=
X-Google-Smtp-Source: ABdhPJwMuP6EV6LRWDE6MDEZYGaNkDAk7W8GO+6D6j4YcAwD+ClHI8Tf9b4aD4tPOJ02aarD9dEYrw==
X-Received: by 2002:a05:6830:30ba:: with SMTP id g26mr2397063ots.32.1634783608723;
        Wed, 20 Oct 2021 19:33:28 -0700 (PDT)
Received: from [172.16.0.2] ([8.48.134.34])
        by smtp.googlemail.com with ESMTPSA id s206sm823079oia.33.2021.10.20.19.33.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Oct 2021 19:33:28 -0700 (PDT)
Message-ID: <a33c3f84-7333-294a-9e78-580cbdac6ec1@gmail.com>
Date:   Wed, 20 Oct 2021 20:33:26 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.0
Subject: Re: [PATCH v5 0/2] Make neighbor eviction controllable by userspace
Content-Language: en-US
To:     James Prestwood <prestwoj@gmail.com>, netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Chinmay Agarwal <chinagar@codeaurora.org>,
        Yajun Deng <yajun.deng@linux.dev>,
        Tong Zhu <zhutong@amazon.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jouni Malinen <jouni@codeaurora.org>
References: <20211021003212.878786-1-prestwoj@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211021003212.878786-1-prestwoj@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/20/21 6:32 PM, James Prestwood wrote:
> v1 -> v2:
> 
>  - It was suggested by Daniel Borkmann to extend the neighbor table settings
>    rather than adding IPv4/IPv6 options for ARP/NDISC separately. I agree
>    this way is much more concise since there is now only one place where the
>    option is checked and defined.
>  - Moved documentation/code into the same patch
>  - Explained in more detail the test scenario and results
> 
> v2 -> v3:
> 
>  - Renamed 'skip_perm' to 'nocarrier'. The way this parameter is used
>    matches this naming.
>  - Changed logic to still flush if 'nocarrier' is false.
> 
> v3 -> v4:
> 
>  - Moved NDTPA_EVICT_NOCARRIER after NDTPA_PAD
> 
> v4 -> v5:
> 
>  - Went back to the original v1 patchset and changed:
>  - Used ANDCONF for IN_DEV macro
>  - Got RCU lock prior to __in_dev_get_rcu(). Do note that the logic
>    here was extended to handle if __in_dev_get_rcu() fails. If this
>    happens the existing behavior should be maintained and set the
>    carrier down. I'm unsure if get_rcu() can fail in this context
>    though. Similar logic was used for in6_dev_get.
>  - Changed ndisc_evict_nocarrier to use a u8, proper handler, and
>    set min/max values.
> 

I'll take a deep dive on the patches tomorrow.

You need to add a selftests script under tools/testing/selftests/net
that shows this behavior with the new setting set and unset. This is
easily done with veth pairs and network namespaces (one end of the veth
pair down sets the other into no-carrier). Take a look at the scripts
there - e.g., fib_nexthops.sh should provide a template for a start point.

