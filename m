Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 440906D0A95
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 18:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbjC3QBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 12:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbjC3QBq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 12:01:46 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D934C2681
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 09:01:44 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id fy10-20020a17090b020a00b0023b4bcf0727so20162087pjb.0
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 09:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680192104;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RhHZp5lQKp83YetxEyIvEe+2exbO5eOjzg6Gy5lgg6Q=;
        b=muCChrH52A4mjQhvcH7jwV9+4DqJxdLXIXn+wB/QfhrVr/uMUBO0obBQuysfgJa5HS
         /UkKrnl8JMB8PK4ZZz1BaktyhKbtDUU8HUCoMxM4CUyDeorCvVf6FAJREW2C2GJmE5oD
         4PV22XYi/AxlLQmgLNAyP2p98IPsDVUjj0klbrvj36aEOM1xago2EwKNwPT9xcqbO3ao
         DquvvQyq5tB7JC2kM9sl6seBtbyN26qZr1cNllfEaIqtvq+O5PHYGNKfN0rqQ9wYs860
         FXHb7ycKWoeiEaRtAq1GKmauOFEhXXdlnjYw6A+d1EIF1SibAPmIKXKx8nn9QdDLIwRO
         jiBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680192104;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RhHZp5lQKp83YetxEyIvEe+2exbO5eOjzg6Gy5lgg6Q=;
        b=3YgyBMkFiQvLnwIbaUPqOOEXklqukD1TPG8Xu0BOkjStavFOuZabgdLAbsgBKWBdWq
         wIWYLPBbaaSReodWBNFg3rytoVlsgTy1nbZAhrlctax5R8g8uruavlEWPs5uSqMaXaVf
         q638FMsAv1iv9MdN0409ai0iGgcFtiFtH/ETqnHBXtEjpDzdXQha+U0uh6mol7+3IB8j
         kzZXyXIl4hS/CEm9UnCpaeO20IjhgNPb8Pp7+NBM1PF6bIyfxTCky99eh0LRpeEwEU/s
         8bVe2VQsTP6IpYaEZYToJ2RXzgHlDrJOz2wGT7MeCBB8SX/o8ycO1B6vdQPMfzyG98hR
         gwbQ==
X-Gm-Message-State: AAQBX9ea5rlyt5+PqT1T52MUzWm2Lx0+BpBCvbf11JY95MQlhsIpUbHY
        doOmmiYv3N3T1owfwQeFjzWjAWQG3vzmww==
X-Google-Smtp-Source: AKy350Y89gNmJQ21J3wKiDhDh9NbHId6ByVbvnJ/vNKJOjnlbFn8l0YrBue4Tdgsf96SDSDGiIQqiA==
X-Received: by 2002:a17:902:e38b:b0:1a2:ca:c6cd with SMTP id g11-20020a170902e38b00b001a200cac6cdmr19066363ple.43.1680192104170;
        Thu, 30 Mar 2023 09:01:44 -0700 (PDT)
Received: from ?IPV6:2601:282:800:7ed0:9428:49f2:b7cb:5336? ([2601:282:800:7ed0:9428:49f2:b7cb:5336])
        by smtp.googlemail.com with ESMTPSA id o19-20020a02a1d3000000b003a0565a5750sm11004614jah.119.2023.03.30.09.01.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Mar 2023 09:01:43 -0700 (PDT)
Message-ID: <6b83ba3e-f60f-7711-90ea-e97a2b60e3ed@gmail.com>
Date:   Thu, 30 Mar 2023 10:01:42 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Subject: Re: [v2 PATCH iproute2-next] macvlan: Add bclim parameter
Content-Language: en-US
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     netdev@vger.kernel.org
References: <ZCJXefIhSrd7Hm2Z@gondor.apana.org.au>
 <ZCJYxDy1fgCm+cbj@gondor.apana.org.au>
 <b52bb122-b5e2-cff1-1c0a-ad8a855e278d@gmail.com>
 <ZCT87VZFkWNLujT9@gondor.apana.org.au>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <ZCT87VZFkWNLujT9@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/29/23 9:07 PM, Herbert Xu wrote:
> v2 fixes a typo on bclen/bclim and switches matches to strcmp.
> 
> ---8<---
> This patch adds support for setting the broadcast queueing threshold
> on macvlan devices.  This controls which multicast packets will be
> processed in a workqueue instead of inline.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
> 
>  include/uapi/linux/if_link.h |    1 +
>  ip/iplink_macvlan.c          |   26 ++++++++++++++++++++++++--
>  man/man8/ip-link.8.in        |   18 ++++++++++++++++++
>  3 files changed, 43 insertions(+), 2 deletions(-)
> 

applied to iproute2-next.

