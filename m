Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AAFF5842F5
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 17:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232169AbiG1PVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 11:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232089AbiG1PVm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 11:21:42 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7AD461B0D
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 08:21:40 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id h188so2387367oia.13
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 08:21:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=dOwKKdSFx2EiPhc8ZLpGx28baQ0ZotpaAuu9KkKccqg=;
        b=Atzt0iTyCpnMpDAIeViidX/Rpgp2m7WO7vvIHhTHqFS1HOc/9gJy3A+8oCg99T+X0K
         J7adkCbPcLJc91R6NS9qGVEmY6kJ8L1Z3xEpRaYB44LUxjH/YaM7MWzQKF55udWg1v39
         7mekXZfR3LQ5+oRef8bSBpJ77w1gHT7+IbNhS2GTHGEiZJPYqi7kVUH2a83MCZxoHCgG
         uB5PDpXPUvqLZATkbBmY3Qwi/B/hsdvR0f/CRqTqLLgcqlQoMUzwRq86fkLfop1IhMrj
         i4z8GSxkho3jTX9cbHlhtMC6dAgdPg4TlurWOeXN6LY97yH2R1dcwWKbNqIy7aUrkCUl
         /vzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=dOwKKdSFx2EiPhc8ZLpGx28baQ0ZotpaAuu9KkKccqg=;
        b=mn/laS+QF+PI0+tuIKOqLpvQVwKu8AlgBc/1tYJx7CsdpaliuOmcbr/lAk6ng6wseN
         c/qi9puBszRBGY03mVLgpoDSkT4jwt0lpAxYS5mQ7IYSGrSpjRgF94pLQO6rLLT8pPLA
         SCQhAiBG/x8m7uUKTIDXIkCBznsd9M9Fm7sGodllupyNBrSNQfPJSBxNj+eP3cmd7i76
         DUjf7Il2WFf5A5XnWCsEekP5aockeQ54iIGG/HeB6nXXgRD1o35o0Heg/TUhyiY9OLFD
         Ef1ESsg0C95yAX2viTqSH+HMJoisvy0CLmEvemcdAisyBtb+YgQMksv2fvGiMcIFQa2/
         WuzQ==
X-Gm-Message-State: AJIora/U+OaGCp9epHgEcHKwApdV8EJhJ0GRnDS0Xo9x7HCayXHYuZ58
        pFKq/2E5AAzBK3MM6M+1xIk=
X-Google-Smtp-Source: AGRyM1t9SxhRxutpu+aeyysia89SWcC3XvUfVPolu/gHGkw0kqThfXj4mSfVfD5YUat5YL/Fz8bwpg==
X-Received: by 2002:a05:6808:170f:b0:33b:182:ce4f with SMTP id bc15-20020a056808170f00b0033b0182ce4fmr4303223oib.24.1659021699203;
        Thu, 28 Jul 2022 08:21:39 -0700 (PDT)
Received: from ?IPV6:2601:282:800:dc80:b47e:4ea2:2c6e:1224? ([2601:282:800:dc80:b47e:4ea2:2c6e:1224])
        by smtp.googlemail.com with ESMTPSA id w23-20020a056830061700b00616d3ec6734sm359183oti.53.2022.07.28.08.21.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jul 2022 08:21:38 -0700 (PDT)
Message-ID: <a5c5e336-78dd-22ea-4641-d4e5f91cd241@gmail.com>
Date:   Thu, 28 Jul 2022 09:21:38 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH net 1/3] netdevsim: fib: Fix reference count leak on route
 deletion failure
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, amcohen@nvidia.com
References: <20220728114535.3318119-1-idosch@nvidia.com>
 <20220728114535.3318119-2-idosch@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220728114535.3318119-2-idosch@nvidia.com>
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

On 7/28/22 5:45 AM, Ido Schimmel wrote:
> As part of FIB offload simulation, netdevsim stores IPv4 and IPv6 routes
> and holds a reference on FIB info structures that in turn hold a
> reference on the associated nexthop device(s).
> 
> In the unlikely case where we are unable to allocate memory to process a
> route deletion request, netdevsim will not release the reference from
> the associated FIB info structure, thereby preventing the associated
> nexthop device(s) from ever being removed [1].
> 
> Fix this by scheduling a work item that will flush netdevsim's FIB table
> upon route deletion failure. This will cause netdevsim to release its
> reference from all the FIB info structures in its table.
> 
> Reported by Lucas Leong of Trend Micro Zero Day Initiative.
> 
> Fixes: 0ae3eb7b4611 ("netdevsim: fib: Perform the route programming in a non-atomic context")
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> Reviewed-by: Amit Cohen <amcohen@nvidia.com>
> ---
> No "Reported-by" tag since I do not have the mail address of the
> reporter.
> ---
>  drivers/net/netdevsim/fib.c | 27 ++++++++++++++++++++++++++-
>  1 file changed, 26 insertions(+), 1 deletion(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


