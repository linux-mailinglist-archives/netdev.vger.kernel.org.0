Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 963B54381D6
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 06:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbhJWEOu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Oct 2021 00:14:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbhJWEOt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Oct 2021 00:14:49 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5086C061764
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 21:12:30 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id 34-20020a9d0325000000b00552cae0decbso6891817otv.0
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 21:12:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=KF1AjtAuFnSfMipUUG1fjrzTEEizuCd4zAbA4JHPIXk=;
        b=Jl0wurm+yum/esNm44hM9Bt9F0ono/UNccrNfb7CdlRci3LcAYCxpIVsGDdDRPrxtv
         cgMqi/Pc/SJ/h79CrKK1Eki+ZnwP6qZ9N/cEFIkFmVcjyXrZHqPTGLnTW/YpcKlH8Y+k
         QKIU7kiP+dOfZxr3ecuxWROkzsNNvGb94z1x+YmNbwPtBNNnUzQhumco8v8gbzyCYPcZ
         9jdTzyKHUAO70/QdU8q3wIE/SHBL4XfRnesLHYwh1sYJmDJ13Bf89BeM9pS90gxQZjIL
         KzGn5d6bQfeBrZvTtWpJ4IT7oxJshDH0KSKYfjqGMx9+JxDpPgK555/WqxR4a4GwC3+N
         wrUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=KF1AjtAuFnSfMipUUG1fjrzTEEizuCd4zAbA4JHPIXk=;
        b=eQ4vd39XNQSOldA8/N0QOWzUjO/TqP3OHUjMDqiUdUjuPWTtzcoXPXear+1xUsUz/I
         prqfxtHepFK+IPFBymHtdvS8V/2oZYr2zirTPXQ1FhWhgJ/v6L9ghI8n6s0JVKgkI/4K
         POwj30kpWI3Bim++Dj6Hr9giYfxmCXLT+GCQU2NqdNUlSL6NJd9uDHDaMNrtVUK0kqTA
         yVNoJ1gLZGQoP1DkDLPrh1GMemfWE6t4F6GbEj8drePt4ADpiMgF15pXlFQNrB/DHAOi
         W4RYoUX7A8CAzwR/IWIM75UlIGsyUTjpfy4dlybvJt5T/6qomg02bSATnzkBCpS3+RWr
         MQrA==
X-Gm-Message-State: AOAM532X/9gIV4qIv7nP91LQKhqzoej4XH4m82vP+Qy3EqjWEOPWslJV
        JJiLKO518gDogAijQbaeNEMVGiz3KdA=
X-Google-Smtp-Source: ABdhPJxQGO9YGX3YUQGy3jq34KAvIBS6KyvCLxpwcsNIu8jyJ1AzhqRX+thlUtA6vSJqdD4o/n5mcA==
X-Received: by 2002:a9d:871:: with SMTP id 104mr3024726oty.132.1634962350100;
        Fri, 22 Oct 2021 21:12:30 -0700 (PDT)
Received: from [172.16.0.2] ([8.48.134.35])
        by smtp.googlemail.com with ESMTPSA id v7sm1859843oor.29.2021.10.22.21.12.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Oct 2021 21:12:29 -0700 (PDT)
Message-ID: <2dbdc851-25e1-6b15-722d-548a95e57d32@gmail.com>
Date:   Fri, 22 Oct 2021 22:12:27 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.0
Subject: Re: [PATCH v7 0/3] Make neighbor eviction controllable by userspace
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
        Yajun Deng <yajun.deng@linux.dev>,
        Tong Zhu <zhutong@amazon.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jouni Malinen <jouni@codeaurora.org>
References: <20211022210818.1088742-1-prestwoj@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211022210818.1088742-1-prestwoj@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/22/21 3:08 PM, James Prestwood wrote:
> v6 -> v7
> 
>  - Corrected logic checking all and netdev option
> 
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: Roopa Prabhu <roopa@nvidia.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Vladimir Oltean <vladimir.oltean@nxp.com>
> Cc: Ido Schimmel <idosch@nvidia.com>
> Cc: Nikolay Aleksandrov <nikolay@nvidia.com>
> Cc: Yajun Deng <yajun.deng@linux.dev>
> Cc: Tong Zhu <zhutong@amazon.com>
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Cc: Jouni Malinen <jouni@codeaurora.org>
> 

seems like v7 did not make it the list.

Also, the way you send this set only this cover letter makes it to me
personally; the rest are only sent to the netdev mailing list.
