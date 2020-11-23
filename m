Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7156E2C0FEB
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 17:19:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732684AbgKWQPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 11:15:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732233AbgKWQPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 11:15:17 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E258C0613CF
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 08:15:17 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id m16so17711558edr.3
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 08:15:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Enhiw04owuKybRTvu3T2y4iI/LKd0o+TWfLamINTcDM=;
        b=Be2KKPmV9ki11PCgilquBRHVzmqwrZ5ffKi+yQ6vIWYOUpI5EWBB88eWOFe9vUE5Bw
         YveEYBDnJwoTfRcY3QtA9hl6M1YhPyKofbD8q5sLnjrfCSXgsRsKzfezomJADlGdXE4k
         nHPUM0MHwS9mW7rl0gLuWHyXnvz0drfWtuZirqZMBUJzbRdRDxUSlGX/UbtmEYPojkn6
         0JKlLhdY8t1+/OvOp+2/kZttFUuUNfnQLOL6KupxLKo+VZfkr1J8LCHW7uHmsqmQiVSf
         eYSXGdaQ7bzxpNaOjnREcC5o5O0brNe9ogh0+hrWkMrQafy2/C7AQgeGkCxRSFXY3OrX
         2ftQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Enhiw04owuKybRTvu3T2y4iI/LKd0o+TWfLamINTcDM=;
        b=d74SOeAZO2CGxta0DiWH+5ShMhmJelrMUredWKduf+bh2Qdr0g2YFlsNpskjNJiyOh
         aFHKHNhBSjV1rCRteOJhde7GERPkWoDSZ+qtAe+nIB1fCR6+8SwDuUMXAWTARCj08asL
         lmXlf9rrm4utU0e0pU7ugg7NVoHmTDjpm8P44nwlMmdOlbHh0rB7/jVs7jJUxzDPvybv
         G4ooaNREP95teS+BahkcCyfQpWc3i+879ikEdsAqNKnh7Y3JDniEBV7KGlXi7iw/Qx5y
         cNtf8yz5jVy6KWesPE1rM9asjqcuQcGEAhk7O3JW6DgtndybpXueHGEUx4UkU3dgX7G/
         puaA==
X-Gm-Message-State: AOAM530zMsvp+xbBemC9LTI5AsfApKbi1uaesHnt/R3t1pS62QphvJt1
        IMTPGrtt9zeCBVxqUPVRjt8=
X-Google-Smtp-Source: ABdhPJxTSJgWgRLIjvqPLFuuD57ZYxkB+g8HGppNaXUPIu+Oa7IJoChECf7nVo2O/+P9auyYXupf/w==
X-Received: by 2002:a50:e68a:: with SMTP id z10mr17821746edm.66.1606148116372;
        Mon, 23 Nov 2020 08:15:16 -0800 (PST)
Received: from [192.168.1.110] ([77.124.63.70])
        by smtp.gmail.com with ESMTPSA id bd21sm5281473edb.79.2020.11.23.08.15.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Nov 2020 08:15:15 -0800 (PST)
Subject: Re: [PATCH net] netdevice.h: Fix unintentional disable of ALL_FOR_ALL
 features on upper device
To:     Eric Dumazet <edumazet@google.com>,
        Tariq Toukan <tariqt@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev <netdev@vger.kernel.org>,
        Moshe Shemesh <moshe@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
References: <20201123141256.14208-1-tariqt@nvidia.com>
 <CANn89iKRVyTZg-tNQvo_Ub-RZ_A+OOQQY8Py3J9fx=NOZXF9Qw@mail.gmail.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
Message-ID: <9bf8ba40-cd40-2af6-d358-48dd98526434@gmail.com>
Date:   Mon, 23 Nov 2020 18:15:11 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <CANn89iKRVyTZg-tNQvo_Ub-RZ_A+OOQQY8Py3J9fx=NOZXF9Qw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/23/2020 4:55 PM, Eric Dumazet wrote:
> On Mon, Nov 23, 2020 at 3:13 PM Tariq Toukan <tariqt@nvidia.com> wrote:
>>
>> Calling netdev_increment_features() on upper/master device from
>> netdev_add_tso_features() implies unintentional clearance of ALL_FOR_ALL
>> features supported by all slaves.  Fix it by passing ALL_FOR_ALL in
>> addition to ALL_TSO.
>>
>> Fixes: b0ce3508b25e ("bonding: allow TSO being set on bonding master")
> 
> I think you should give more details to your bug report, because
> netdev_add_tso_features() is used from different
> places.
> 
> Thanks.
> 

Right. I'll include these in the re-spin:
Fixes: 247f6d0f8667 ("team: allow TSO being set on master")
Fixes: f902e8812ef6 ("bridge: Add ability to enable TSO")

I wonder though if netdev_increment_features() is expected to clear 
features that are not part of the mask.

Thanks.
