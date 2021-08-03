Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 102E23DF087
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 16:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236234AbhHCOmp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 10:42:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234360AbhHCOmm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 10:42:42 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFE70C061757
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 07:42:29 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id 61-20020a9d0d430000b02903eabfc221a9so20938263oti.0
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 07:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1TOH9OabPyDjMVUYMh7NWdlerRxMzBrAXmG+PviR58k=;
        b=dWQJ2bcu5qyIrrAzUkvMOIz0i6xDjkbI+Lr77kRePqNe5fy/a7ki+WEcT+NNrCEkC2
         nJBFcoA0190+WJZWRuGvetvMol/bjr+7Eri09l4l5vThNVapVc29KzG7sNR3WU/s3UMe
         qCMa351mavhTIgX2JaZkgKwieTfIamQ8xAUc3uW4N1DpkXt9/ywK+++eFJMSVZqzxCE6
         HqZnsB+OQc0AhtMYnTlovrC7dXmhJ9yIoPZQ68suMHdePm1RpQB8eihgIRkApY3UlmHB
         RBBnKALIEvRQ/ON8cimLfRzdkLSJ89mfgiyaD6ZH5vKHIiLGwotQNS4OGjTX/pOblPS5
         N3Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1TOH9OabPyDjMVUYMh7NWdlerRxMzBrAXmG+PviR58k=;
        b=mv7HCChlKt3w9xhP9QT5lYExgQ9W5vkFI1LDY6uQOqNmrkHf0CKGn0Q+oGpv0YGh8j
         gJf+2FXl5H+6ooJXHBrG8DQHYl3E+Oegag5OFW4Kc/ZPfbWqoWWdf4PWhPovr0Sspnmf
         mqbmfdjnW0N7nYDorEyDXYPGA+sgTHzrjX+G1ZgWGRHNEtcud45DnjyYRuijOjWKn0nM
         kp1pPCGuhlPRrZf3dm0GIzaLSFiO22Y0CFaYQFup4c/1/E1fPGxUOmqos+kqE59uaoP1
         efNc/GMS0uhixqb7dIy+FSUHquo0wIkuWKQUFcM6prpAxm2lkqY7cCpi8eGovycElJwk
         i9aA==
X-Gm-Message-State: AOAM531EOF1ltOIicCMSco+WwcOyykZU8M2gjMS7LqWsOXK5lqK//Wwz
        eAZIcOhUi+DwV7rKmiAgYO8=
X-Google-Smtp-Source: ABdhPJzIl1Cfn4AgHJY8fwcKD6ilL7XTI7hG2o32gCkvOhlCNYdNNalotRYmJC7ZRjffkVq/fnFJtw==
X-Received: by 2002:a05:6830:1c1:: with SMTP id r1mr15162583ota.22.1628001749355;
        Tue, 03 Aug 2021 07:42:29 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.27])
        by smtp.googlemail.com with ESMTPSA id a193sm2327090oob.45.2021.08.03.07.42.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 07:42:29 -0700 (PDT)
Subject: Re: [PATCH] neigh: Support filtering neighbours for L3 slave
To:     Lahav Schlesinger <lschlesinger@drivenets.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        dsahern@kernel.org
References: <20210801090105.27595-1-lschlesinger@drivenets.com>
 <351cae13-8662-2f8f-dd8b-4127ead0ca2a@gmail.com>
 <20210802082310.wszqbydeqpxcgq2p@kgollan-pc>
 <6b3516da-0ba5-0bbf-8de1-e1232457a5aa@gmail.com>
 <20210803064730.pmkm7xesffzjscze@kgollan-pc>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <e71a91c7-2b56-01e0-f4e3-2f45ce985add@gmail.com>
Date:   Tue, 3 Aug 2021 08:42:27 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210803064730.pmkm7xesffzjscze@kgollan-pc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/3/21 12:47 AM, Lahav Schlesinger wrote:
>>>> you can not special case VRFs like this, and such a feature should apply
>>>> to links and addresses as well.
>>>
>>> Understandable, I'll change it.
>>> In this case though, how would you advice to efficiently filter
>>> neighbours for interfaces in the default VRF in userspace (without
>>> quering the master of every interface that is being dumped)?
>>> I reckoned that because there's support in iproute2 for filtering based
>>> on a specific VRF, filtering for the default VRF is a natural extension
>>
>> iproute2 has support for a link database (ll_cache). You would basically
>> have to expand the cache to track any master device a link is associated
>> with and then fill the cache with a link dump first. It's expensive at
>> scale; the "no stats" filter helps a bit.
>>
>> This is the reason for kernel side filtering on primary attributes
>> (coarse grain filtering at reasonable cost).
>>
> 
> Nice, didn't know about the ll_cache.
> Does filtering based on being in the default VRF is something you think
> can be merged into iproute2 (say with "novrf" keyword, following the "nomaster"
> convention below - e.g. "ip link show novrf")?
> If so I'll add it as a patch to iproute2.

yes. There is also an outstanding request to show the vrf of neighbor
entries (e.g., add a new column at the end with vrf) when doing a full dump.


