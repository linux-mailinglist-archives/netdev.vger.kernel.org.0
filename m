Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 717A63DF08E
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 16:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236677AbhHCOoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 10:44:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236565AbhHCOn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 10:43:59 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8550BC0617A0;
        Tue,  3 Aug 2021 07:43:43 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id v9-20020a9d60490000b02904f06fc590dbso1970887otj.4;
        Tue, 03 Aug 2021 07:43:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SIy7YuIpmbrBfkxoJ9arBgQ3JJKRIVRbnKJVEeiSLTg=;
        b=HkMDkb0Qsc8j0fuAnWvVLRvJ/D1Ku0uIt1iqhg2Aidi28y9kSrxtQUwVtJAs6eJDn4
         9UNvh34VTcMW0tmiQuoh49hPnto9VDwkKPSdqEpFOvOdj7OQJ9NQ5eFbd/KJGL+2svcf
         x5wMIy6txSSSxtUne/EqenlGrtCT2nEYxEXbIE/sLYakrK2SgrJxMAYMO3OGI5DujKRx
         qSpptOjPW6Gbb6tNUNoI830ySAHcrYcwimghB4e5awuockYNcR7LEYssgRxTIqXqiU09
         WO1A9YdI4VrWoaOSfyMA5d0aWbpkfgnxR5LDP0X13EufO2eTj+JFA/JOMpLATsVBNgmO
         cAoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SIy7YuIpmbrBfkxoJ9arBgQ3JJKRIVRbnKJVEeiSLTg=;
        b=Mvq7xu5iT679td225dlUuaGTUID81ECJ1YuL9BWBh1/vbh/3BAGlrsAkLXnxSmgy1H
         +vl8KFFieJYw61LgUrxJDKl66U6tLhsydXIZAqn0jfW3gCLzIAHEAYaMVCntCbS6iF4T
         zZKDJee6k+DxnvyUpiOMWDz/LZpETiy2lkI9BCSEvz3APUa3iT6MYrM9LLDoKLE8bS9/
         FyhfH6nJi+zemqf7LIHzQ8e35zR+vCkK8RBypyQc/A8JWa9K5kix8oeWCHs4G8HeqGKJ
         AbT0CyQ0+JT+hM4+3T4rA3f9273dYG+XmyyMW7ku0pdEMr7Afi+dl1UtDDsjDzMlsH3B
         MI3Q==
X-Gm-Message-State: AOAM531tPbJ4t3uSTPSi5peBscgB/q5hC8ko2eg3llfI+Ik8QFmOoggY
        0CDBZtc/3M/1V2PEwVhBmmE=
X-Google-Smtp-Source: ABdhPJzUNS0djkEDeIu3OKB5uOrKgzmLfrXqUqT4dGlDfwh0SrogVs87XMCI6aWi7oxiK2GGpKHGwg==
X-Received: by 2002:a9d:4789:: with SMTP id b9mr15514918otf.335.1628001823221;
        Tue, 03 Aug 2021 07:43:43 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.27])
        by smtp.googlemail.com with ESMTPSA id p10sm2146449oop.46.2021.08.03.07.43.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 07:43:42 -0700 (PDT)
Subject: Re: [PATCH] net: convert fib_treeref from int to refcount_t
To:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Yajun Deng <yajun.deng@linux.dev>, davem@davemloft.net,
        kuba@kernel.org, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-decnet-user@lists.sourceforge.net
References: <20210729071350.28919-1-yajun.deng@linux.dev>
 <CGME20210803110803eucas1p276a0010caad8fc21a7ea5ca5543294f8@eucas1p2.samsung.com>
 <14e0ec1c-0345-d5d4-769a-44ded33821e8@samsung.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <43af9da8-9438-20eb-567b-4538e97d0389@gmail.com>
Date:   Tue, 3 Aug 2021 08:43:41 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <14e0ec1c-0345-d5d4-769a-44ded33821e8@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/3/21 5:08 AM, Marek Szyprowski wrote:
> Hi
> 
> On 29.07.2021 09:13, Yajun Deng wrote:
>> refcount_t type should be used instead of int when fib_treeref is used as
>> a reference counter,and avoid use-after-free risks.
>>
>> Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
> 
> This patch landed in linux-next 20210802 as commit 79976892f7ea ("net: 
> convert fib_treeref from int to refcount_t"). It triggers the following 
> warning on all my test systems (ARM32bit and ARM64bit based):
> 

fixed in net-next.

