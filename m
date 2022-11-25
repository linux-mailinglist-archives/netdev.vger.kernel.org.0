Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC8136382E4
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 04:53:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbiKYDxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 22:53:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiKYDxD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 22:53:03 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEAD92649C;
        Thu, 24 Nov 2022 19:53:02 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id k5so2669718pjo.5;
        Thu, 24 Nov 2022 19:53:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FnlmNyQzk9MfR9lWgUpnq90vysCJsC3WalO4HSAXleM=;
        b=PBzZtvYp6fpf1e9LRotvK9p5aMHF+3kIrQv8vKMz+Bwdyvm7eOwcplPYqERqNWj3W8
         pq3hrvGAFzF5EsgUqwGjIEWBn+ecq1tnv42MJ+iR8Ci4v8Qfe9PWc8OcvL62+1w3gNcT
         AxS7FPWM4qvFSXSfyG3Bx5hQ4bTi1pwPO/sZ1ldmhKyBfNMLDYGss20TdVa6cX0+ijm1
         3MJ7HLKTRTPXFBPYQHDx8/3FEt3MS/Hff7G37KFYqFYpEWq2zmMZsf3kSb0Cl61mcmIc
         3H9j3uUjM1qRr9/6l4/0v1XvzqCAR1Q/Zim0WOrDyh63UIYl6XnSRIkbdvM1pc2HoTby
         ignw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FnlmNyQzk9MfR9lWgUpnq90vysCJsC3WalO4HSAXleM=;
        b=d9JVqqeE10cU5G77bougA711FKklIV83IDf28Wmxroo/yFJgzzYCH8jWPPUaumieOV
         fslAEou4UcRL1vbcx6Eor4M4QKRPJAXMA3UhQbgu9q5hPP6+SOQ85QHbYmdgfCEIGzIB
         /TD5MJ9s/JJc38ht7CFATqbuki8yHWM17KODdFOF1sdvOAAM+SfsL9n1x0aSW4CHPFwC
         gaZoS8HL6ELCHeuHQ5QJblj4MkN+pOBjtCNKzWOVmSFMvS+WfkOc1nuTSRkvfQN3nojg
         Gw4e5HsyR/uLvsSUt5QbbCCydSQOR9f5cCBWI754l6MFhIdFUPQGe7V0wpJodzvYyICy
         XWTQ==
X-Gm-Message-State: ANoB5pm4atl48HFsX0Be7cdn/s8Q63ZctiGq0rg9pbhJowuKgHmIYY1x
        ABzXNts7MCss49WUWFuhL7E=
X-Google-Smtp-Source: AA0mqf6/l3elvhemFsSxaWsFo42/+sUNA12CqR32uYhC8otcVLe/SNcx75MBLVPdZuFN2Rp9l5dk2g==
X-Received: by 2002:a17:90a:d3ce:b0:218:7a66:64b9 with SMTP id d14-20020a17090ad3ce00b002187a6664b9mr35924059pjw.85.1669348382330;
        Thu, 24 Nov 2022 19:53:02 -0800 (PST)
Received: from ?IPV6:2600:8801:1c8b:7b00:adfe:487d:e345:f456? ([2600:8801:1c8b:7b00:adfe:487d:e345:f456])
        by smtp.googlemail.com with ESMTPSA id k1-20020a170902c40100b00186c54188b4sm2125968plk.240.2022.11.24.19.53.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Nov 2022 19:53:01 -0800 (PST)
Message-ID: <2a367ac4-ba67-0d48-39e1-19ae5402f75d@gmail.com>
Date:   Thu, 24 Nov 2022 19:52:59 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH net] ipv4: Fix route deletion when nexthop info is not
 specified
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, razor@blackwall.org, jonas.gorski@gmail.com,
        mlxsw@nvidia.com, stable@vger.kernel.org
References: <20221124210932.2470010-1-idosch@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20221124210932.2470010-1-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/24/22 2:09 PM, Ido Schimmel wrote:
> When the kernel receives a route deletion request from user space it
> tries to delete a route that matches the route attributes specified in
> the request.
> 
> If only prefix information is specified in the request, the kernel
> should delete the first matching FIB alias regardless of its associated
> FIB info. However, an error is currently returned when the FIB info is
> backed by a nexthop object:
> 
>  # ip nexthop add id 1 via 192.0.2.2 dev dummy10
>  # ip route add 198.51.100.0/24 nhid 1
>  # ip route del 198.51.100.0/24
>  RTNETLINK answers: No such process
> 
> Fix by matching on such a FIB info when legacy nexthop attributes are
> not specified in the request. An earlier check already covers the case
> where a nexthop ID is specified in the request.
> 
> Add tests that cover these flows. Before the fix:
> 
>  # ./fib_nexthops.sh -t ipv4_fcnal
>  ...
>  TEST: Delete route when not specifying nexthop attributes           [FAIL]
> 
>  Tests passed:  11
>  Tests failed:   1
> 
> After the fix:
> 
>  # ./fib_nexthops.sh -t ipv4_fcnal
>  ...
>  TEST: Delete route when not specifying nexthop attributes           [ OK ]
> 
>  Tests passed:  12
>  Tests failed:   0
> 
> No regressions in other tests:
> 
>  # ./fib_nexthops.sh
>  ...
>  Tests passed: 228
>  Tests failed:   0
> 
>  # ./fib_tests.sh
>  ...
>  Tests passed: 186
>  Tests failed:   0
> 
> Cc: stable@vger.kernel.org
> Reported-by: Jonas Gorski <jonas.gorski@gmail.com>
> Tested-by: Jonas Gorski <jonas.gorski@gmail.com>
> Fixes: 493ced1ac47c ("ipv4: Allow routes to use nexthop objects")
> Fixes: 6bf92d70e690 ("net: ipv4: fix route with nexthop object delete warning")
> Fixes: 61b91eb33a69 ("ipv4: Handle attempt to delete multipath route when fib_info contains an nh reference")
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/ipv4/fib_semantics.c                    |  8 +++++---
>  tools/testing/selftests/net/fib_nexthops.sh | 11 +++++++++++
>  2 files changed, 16 insertions(+), 3 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


