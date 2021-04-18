Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9B73636F0
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 19:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232082AbhDRRHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 13:07:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbhDRRHw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 13:07:52 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08FBDC06174A
        for <netdev@vger.kernel.org>; Sun, 18 Apr 2021 10:07:24 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id j7so13185057pgi.3
        for <netdev@vger.kernel.org>; Sun, 18 Apr 2021 10:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mLpt/n2mgKHgqP3ltMERFMvRNGCIIR/YSbHNKDXavs4=;
        b=hV2W+Pv8QaBGJYqcl4quYBoOMEDTrx39dU/FX2ztozzkFGoBYjqmhPIRJVik6822zW
         Ke8ZReAP78sOo+jInNNRcRXQYmIra5MJEMYftmIHH5Eyp7yjNeTxzfGdjvoZkMam1c3i
         BOFmdMmmLB0exeB8uDTXeOOcvuihB4t7pxfPqd8MM7yR+dUnEYiNWVHc41miBQq19v6/
         YzkBCG8LuXMNkZ8IiXCCB6XuxL8zU5FFFPJLVmqd3fN8MzIJTBEDyM7orHUAmFBTBt9g
         oCzmxq61EQ1CeIEg2tozewCNC40Mw+r0015GqjystlBnmK2oqsYDkAzP6xpNt381hR61
         vpsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mLpt/n2mgKHgqP3ltMERFMvRNGCIIR/YSbHNKDXavs4=;
        b=Mp8lUbr9xIJUPKDB7GaxzcT/E+jhvrDCwCymb3vzktz1T4q/u3UhFr4PG2lxyfML3H
         mUw3TQpBKwhp3ojcCTYpEgD/8VIzs9Os7nsZ77sNhtxZ4VpJmaFLVArT+RmMgEYnvkzA
         VPrtE4/gncKMo6GvjmWSMQmJkHCaCozfXOMYEeRUR2ORemkZBcBgPcm3ITwEuskHcE/A
         I0eAHQr6SGALymtV/Vtuso6dho3XJNEmdn+jnYXv5qkIoktKLm3Tvi6Rsg2Akq8JqYNK
         I/d9xp5Jc37/TQoV+QkuzXnMESd1b0Xcd3kk7N+tkIK1FWSRhO/yNRblrXhI7cICW4s2
         msFQ==
X-Gm-Message-State: AOAM531zonHWnpJ+SN2DRL563oeALhwO7gFCpCDNDCJzDD25s264+QpA
        r1XNLw4wzjAMHzpMcNQxgYw=
X-Google-Smtp-Source: ABdhPJx73242sCDxZJ6J1F780aVtadl3IQ3RWJ8FCwwl2N9/lkl+KmpU/hyXyiYfb2g6riPJovKNaw==
X-Received: by 2002:a65:4082:: with SMTP id t2mr8202539pgp.396.1618765643671;
        Sun, 18 Apr 2021 10:07:23 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.45.41.12])
        by smtp.googlemail.com with ESMTPSA id i66sm9961730pfg.206.2021.04.18.10.07.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Apr 2021 10:07:23 -0700 (PDT)
Subject: Re: [PATCH net-next 2/2] selftests: fib_nexthops: Test large scale
 nexthop flushing
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
References: <20210416155535.1694714-1-idosch@idosch.org>
 <20210416155535.1694714-3-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <8352ac7a-f016-53a9-2078-10917e257544@gmail.com>
Date:   Sun, 18 Apr 2021 10:07:22 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210416155535.1694714-3-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/16/21 8:55 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Test that all the nexthops are flushed when a multi-part nexthop dump is
> required for the flushing.
> 
> Without previous patch:
> 
>  # ./fib_nexthops.sh
>  TEST: Large scale nexthop flushing                                  [FAIL]
> 
> With previous patch:
> 
>  # ./fib_nexthops.sh
>  TEST: Large scale nexthop flushing                                  [ OK ]
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> Reviewed-by: Petr Machata <petrm@nvidia.com>
> ---
>  tools/testing/selftests/net/fib_nexthops.sh | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


