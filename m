Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56A68568BB1
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 16:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232070AbiGFOwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 10:52:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232052AbiGFOwG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 10:52:06 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B7F240A2
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 07:52:05 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id h85so14227712iof.4
        for <netdev@vger.kernel.org>; Wed, 06 Jul 2022 07:52:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=vz7bGcbu6VI9fdcubfgmH8CBRCMJeBRh3Dv5Ph65+ww=;
        b=JjJg/ZZaTBbzoILaUuoHTwfexr018N4SXOQl2kukw3Gv8hJA6WZ/a6XkyySukoaZEf
         tYc9hf7jeyxQ1kXc1YMZmAFE9vMQO0ADpCAnrU0pMwdrPwG/4Gc4AmCofF/1DwuxxI/u
         v5jDOg1BEk7o4nuFIvomhJ0m2Eo7Vk2MchAYUZztl9BcsBd49JQyRXmDyERnmsrci9Nq
         bMolesC7PqzHhoz5N/FI58DLCmgOBu8rSlSbAJhoPAZKmIVZ68IU2OVs2RQL9NONgrVU
         gdjg+zSn70rnPJB4zkDn3tHIFLc/GMdkxg/XaN/LmXxxM1+Ltu03qoeuHUEW1JFbUeug
         NJEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vz7bGcbu6VI9fdcubfgmH8CBRCMJeBRh3Dv5Ph65+ww=;
        b=t4SdCpsKggwAZrPx48PozMwwlDs92RvvmxBbf4vsueV6tP6Ceufo71+cENs9jNmqe9
         wPVicAGcpvZidSIqFZb/+rs7sntZoUpg9dsOhCrM+jkOHKajtnQdp7irbIgaiRTu200Z
         CUesnsbq8RLe7ES4O1SOL2knxQSIUtzK2xfQXh4LOldFDyN+1gwyGQGzXZvDcOmNSvdX
         LStmEhyYoDv8LJBmgVAGCDJLO+tEoZliMmY3d3tl6dHBoD59Es5nlhWNuOgYpJgZJS5U
         OnzzMmgYhaOpiwDxqLD6zmprN/uRCe+JCnwuR7QpTAt3CmkIM9C03MkMdliWKC7AD7qv
         1frQ==
X-Gm-Message-State: AJIora/V2jnpYCQLvmyvc/eoll1PgZTOU50ilyGtGrNgE31kQm6zMMO2
        EQ9eZ+HV0BJq6Sj7tyoCAAI=
X-Google-Smtp-Source: AGRyM1taTtVH1k5lkrC7lQpy29WPtqMwc4pAqWPtQ/zqP69bCnu1flBqZPmVt+9zfAh6KV9TS1bn4g==
X-Received: by 2002:a02:638b:0:b0:33f:c9f:5772 with SMTP id j133-20020a02638b000000b0033f0c9f5772mr1401262jac.104.1657119124537;
        Wed, 06 Jul 2022 07:52:04 -0700 (PDT)
Received: from ?IPV6:2601:282:800:dc80:341e:8c4d:12df:40ce? ([2601:282:800:dc80:341e:8c4d:12df:40ce])
        by smtp.googlemail.com with ESMTPSA id q19-20020a056e02097300b002dc14d4c312sm3241877ilt.53.2022.07.06.07.52.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jul 2022 07:52:04 -0700 (PDT)
Message-ID: <7b05b0f5-130d-8c4b-a954-c6dfad97a073@gmail.com>
Date:   Wed, 6 Jul 2022 08:52:02 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH iproute2-next v2] ip: Fix rx_otherhost_dropped support
Content-Language: en-US
To:     Petr Machata <petrm@nvidia.com>
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Itay Aveksis <itayav@nvidia.com>
References: <4148bef3a4e4f259aa9fa7936062a4416a035fec.1656411498.git.petrm@nvidia.com>
 <7a9cc617-c903-d9e7-9120-649a3bab86c6@gmail.com> <87sfnes96v.fsf@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <87sfnes96v.fsf@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/6/22 6:42 AM, Petr Machata wrote:
> 
> David Ahern <dsahern@gmail.com> writes:
> 
>> On 6/28/22 4:19 AM, Petr Machata wrote:
>>> The commit cited below added a new column to print_stats64(). However it
>>> then updated only one size_columns() call site, neglecting to update the
>>> remaining three. As a result, in those not-updated invocations,
>>> size_columns() now accesses a vararg argument that is not being passed,
>>> which is undefined behavior.
>>>
>>> Fixes: cebf67a35d8a ("show rx_otherehost_dropped stat in ip link show")
>>> CC: Tariq Toukan <tariqt@nvidia.com>
>>> CC: Itay Aveksis <itayav@nvidia.com>
>>> Signed-off-by: Petr Machata <petrm@nvidia.com>
>>> ---
>>>
>>> Notes:
>>>     v2:
>>>     - Adjust to changes in the "32-bit quantity" patch
>>>     - Tweak the commit message for clarity
>>>
>>>  ip/ipaddress.c | 8 +++++---
>>>  1 file changed, 5 insertions(+), 3 deletions(-)
>>>
>>
>> I merged main into next and now this one needs to be rebased.
> 
> The issue is that this depends on 329fda186156 ("ip: Fix size_columns()
> invocation that passes a 32-bit quantity"), which got to net only
> yesterday. When it's merged to next, this patch should apply cleanly.

ah, merged again and applied.
