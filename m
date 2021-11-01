Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 644B0441F8A
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 18:45:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231450AbhKARr4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 13:47:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbhKARrz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 13:47:55 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7AE1C061714
        for <netdev@vger.kernel.org>; Mon,  1 Nov 2021 10:45:21 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id j9so9683458pgh.1
        for <netdev@vger.kernel.org>; Mon, 01 Nov 2021 10:45:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=nYVN+CRA77cUNIm1PKYhr/tWkAk6TjJWDH1oqGGspMI=;
        b=SL4TdPbRObspzMQsQ3KJTvF73bZSI15SDZFa4vPcutIfgLv/erJgLn83oeqRqw6w9F
         ulnRYdtnv4oeMI71icCMXLBfc3ysnjDwHcO0FsuSO+/6j6uko1EnRtRGaF1wkxWnyS3M
         NGm1SKlm63nSGEyiWPdPC8V5zyrZLpa/XUIEwtGJ/u02tcTEnMaPwZltCcC1fhlINMci
         3rGwF961CFBJP00L9r2hN6MyQJcpOyV7F4RlvVatAoFfjXwSpWIJf9n+/UCLTrUXn5D3
         2kIgYxcMLzl0648ZJip2J1IYZDSLPL97AE6j/SB7qDHctskyZ6QdK2bNJS/dtQfW6xsX
         OSlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=nYVN+CRA77cUNIm1PKYhr/tWkAk6TjJWDH1oqGGspMI=;
        b=eEPt+QOQWUQwDxyinIRDbRyAMcdtJbd2+dnwNNXqbPJrvV2AOVOk+iCx4oOFRldVE2
         sOmtTwMxQz2/dulq6GzPW7tKCjhFiv4zoq3LRGUY1vC9z1jzWjSurXON8HFAeXckp4VQ
         H74RkwKC9f4clkXEPE67Ih1Mx88Tu5NdQwSnhOQlIXvu1akgtb+dJHcBjMKwoN4j2sho
         irISa3KnIuop0W4wsScaXsOqwJBsUdQIIIyAwIC2MCS7da3sCd4PKzrgjbiRHKKp+Ah2
         IGP35HdomLXp0UYbrgDEw3Ap6nHyGAzXOM5zGzCpDMArNCw4PMG8efqC/ypdPxSI3GXw
         XD2g==
X-Gm-Message-State: AOAM531gIJI26b8FhlkYIoR9hv2X/DP5cubxkUXVB/LUbLR9Sm8+pR4B
        I3+D7pYvEVqc+BXk0hu01FdsGUn7pk9ZTg==
X-Google-Smtp-Source: ABdhPJwwMvtEqol2AEAE40GuWuJ4BCrNZ/Kr+torH4kvK2sFSQw/WPJPYYNv6ORl2WEQHWrNVpVPeg==
X-Received: by 2002:a63:7c41:: with SMTP id l1mr22936336pgn.372.1635788721168;
        Mon, 01 Nov 2021 10:45:21 -0700 (PDT)
Received: from [192.168.254.56] ([50.45.187.22])
        by smtp.gmail.com with ESMTPSA id p9sm15801095pfn.7.2021.11.01.10.45.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 10:45:20 -0700 (PDT)
Message-ID: <674e57f3766a49909bf304abab2956a4213780cd.camel@gmail.com>
Subject: Re: [PATCH 0/3] Make neighbor eviction controllable by userspace
From:   James Prestwood <prestwoj@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, roopa@nvidia.com,
        daniel@iogearbox.net, vladimir.oltean@nxp.com, idosch@nvidia.com,
        nikolay@nvidia.com, yajun.deng@linux.dev, zhutong@amazon.com,
        johannes@sipsolutions.net, jouni@codeaurora.org
Date:   Mon, 01 Nov 2021 10:41:02 -0700
In-Reply-To: <20211101173630.300969-1-prestwoj@gmail.com>
References: <20211101173630.300969-1-prestwoj@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry about this, 'V8' never made it into the patch subject.

On Mon, 2021-11-01 at 10:36 -0700, James Prestwood wrote:
> v1 -> v2:
> 
>  - It was suggested by Daniel Borkmann to extend the neighbor table
> settings
>    rather than adding IPv4/IPv6 options for ARP/NDISC separately. I
> agree
>    this way is much more concise since there is now only one place
> where the
>    option is checked and defined.
>  - Moved documentation/code into the same patch
>  - Explained in more detail the test scenario and results
> 
> v2 -> v3:
> 
>  - Renamed 'skip_perm' to 'nocarrier'. The way this parameter is used
>    matches this naming.
>  - Changed logic to still flush if 'nocarrier' is false.
> 
> v3 -> v4:
> 
>  - Moved NDTPA_EVICT_NOCARRIER after NDTPA_PAD
> 
> v4 -> v5:
> 
>  - Went back to the original v1 patchset and changed:
>  - Used ANDCONF for IN_DEV macro
>  - Got RCU lock prior to __in_dev_get_rcu(). Do note that the logic
>    here was extended to handle if __in_dev_get_rcu() fails. If this
>    happens the existing behavior should be maintained and set the
>    carrier down. I'm unsure if get_rcu() can fail in this context
>    though. Similar logic was used for in6_dev_get.
>  - Changed ndisc_evict_nocarrier to use a u8, proper handler, and
>    set min/max values.
> 
> v5 -> v6
> 
>  - Added selftests for both sysctl options
>  - (arp) Used __in_dev_get_rtnl rather than getting the rcu lock
>  - (ndisc) Added in6_dev_put
>  - (ndisc) Check 'all' option as well as device specific
> 
> v6 -> v7
> 
>  - Corrected logic checking all and netdev option
> 
> Resend v7:
> 
>  - Fixed (hopefully) the issue with CC's only getting the cover
> letter
> 
> v7 -> v8:
> 
>  - Added selftests for 'all' options
> 
> James Prestwood (3):
>   net: arp: introduce arp_evict_nocarrier sysctl parameter
>   net: ndisc: introduce ndisc_evict_nocarrier sysctl parameter
>   selftests: net: add arp_ndisc_evict_nocarrier
> 
>  Documentation/networking/ip-sysctl.rst        |  18 ++
>  include/linux/inetdevice.h                    |   2 +
>  include/linux/ipv6.h                          |   1 +
>  include/uapi/linux/ip.h                       |   1 +
>  include/uapi/linux/ipv6.h                     |   1 +
>  include/uapi/linux/sysctl.h                   |   1 +
>  net/ipv4/arp.c                                |  11 +-
>  net/ipv4/devinet.c                            |   4 +
>  net/ipv6/addrconf.c                           |  12 +
>  net/ipv6/ndisc.c                              |  12 +-
>  .../net/arp_ndisc_evict_nocarrier.sh          | 220
> ++++++++++++++++++
>  11 files changed, 281 insertions(+), 2 deletions(-)
>  create mode 100755
> tools/testing/selftests/net/arp_ndisc_evict_nocarrier.sh
> 


