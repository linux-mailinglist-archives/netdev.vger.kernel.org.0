Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EBCE39E945
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 00:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231236AbhFGWG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 18:06:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230359AbhFGWGz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 18:06:55 -0400
Received: from mail-oo1-xc2b.google.com (mail-oo1-xc2b.google.com [IPv6:2607:f8b0:4864:20::c2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D2ACC061574
        for <netdev@vger.kernel.org>; Mon,  7 Jun 2021 15:04:50 -0700 (PDT)
Received: by mail-oo1-xc2b.google.com with SMTP id e27-20020a056820061bb029020da48eed5cso4505431oow.10
        for <netdev@vger.kernel.org>; Mon, 07 Jun 2021 15:04:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LmnF+OxYjVRvwbfBAo39t9Narl9JzclQfoExdA0qYwk=;
        b=pFq3CsAJB9HJSBPvT3dDmEg/quKZ/cbm0EzBFaOzvjwQvTqvhMEFihGGalBCq8n41f
         Z4Yx/5bxX6DRec7px9+qFNGtFXPW92+Z+KVaoYFm+CW3OXQhWHoRtQwNn4oXeIKrf+K+
         Frywo4xANr31FbMiYv6eKWwhqotn3y5oKV4cRZofZe/QqiCyesOJzZOOqpPpuUBtQokW
         rTNPmFKUY0VUTLtfREDIW5ZP1Em5M/5IBKK4R+T9APvWX6eOA1dRwZL2rRsCmTP92EW7
         45cKsQYhXvrbUKmwRNN5No+zIy1KDTgjPCyjyjDU4WYxbcqsul7fJpTYKo7Zt8uPXue+
         PXiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LmnF+OxYjVRvwbfBAo39t9Narl9JzclQfoExdA0qYwk=;
        b=j37Ig4LYpfEuzrZfCHhBYjdjPe9brbKKZ/hMSC4Q4MEb0QKQYtDOXxJR2EnhXvq/ge
         DAZHN7EN6RjV3OVcwKVrOXTYQIQPuI4W/pAAU8AwTWYWHcoxJc+7UHHLudHcTmxR0/Mf
         Cl7jLd48GP91Q0TZ6s5qQakxQmPONONFbmVMGOPc9PNZmxfNY8O4ykarwYEiOxufXBgH
         bZiffbQeC+YMwfztekTmHwF24Ameyn6Vf8PRLrn4r7g21Ekx06X7Pr+Pp7/L4ESEEc2m
         d5JAzKnEKG+LMplxq5XrLM/VNHyEGGX8jwpAwq9ndmAnbp5Eg+TWIm4bQGRwl1sIQ3jA
         /FOQ==
X-Gm-Message-State: AOAM531iKxXkSRaeRTa0Nh6g7e8nu3vsFni8bADSKjs/+Fp8B/fKposw
        O240zPikYxLAml12VJqOMxc=
X-Google-Smtp-Source: ABdhPJy1Ud99hPUMNdOBY16jBgrvirL/6cFu0Wv3u4A7vmL+cJEnY8L6XPNzniCXn7mswYZh5G9jNQ==
X-Received: by 2002:a4a:b60b:: with SMTP id z11mr2207897oon.57.1623103489780;
        Mon, 07 Jun 2021 15:04:49 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.22])
        by smtp.googlemail.com with ESMTPSA id m23sm2310165otk.55.2021.06.07.15.04.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Jun 2021 15:04:49 -0700 (PDT)
Subject: Re: [PATCH net] neighbour: allow NUD_NOARP entries to be forced GCed
To:     Roopa Prabhu <roopa@nvidia.com>, David Ahern <dsahern@kernel.org>,
        netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net
Cc:     Kasper Dupont <kasperd@gjkwv.06.feb.2021.kasperd.net>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
References: <20210607173530.46493-1-dsahern@kernel.org>
 <c704333a-e326-57ba-78e7-1e7111f1e79c@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <080b469b-1fb2-dcb6-1a95-7c02918e97c4@gmail.com>
Date:   Mon, 7 Jun 2021 16:04:47 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <c704333a-e326-57ba-78e7-1e7111f1e79c@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/7/21 12:53 PM, Roopa Prabhu wrote:
> 
> On 6/7/21 10:35 AM, David Ahern wrote:
>> IFF_POINTOPOINT interfaces use NUD_NOARP entries for IPv6. It's
>> possible to
>> fill up the neighbour table with enough entries that it will overflow for
>> valid connections after that.
>>
>> This behaviour is more prevalent after commit 58956317c8de ("neighbor:
>> Improve garbage collection") is applied, as it prevents removal from
>> entries that are not NUD_FAILED, unless they are more than 5s old.
>>
>> Fixes: 58956317c8de (neighbor: Improve garbage collection)
>> Reported-by: Kasper Dupont <kasperd@gjkwv.06.feb.2021.kasperd.net>
>> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
>> Signed-off-by: David Ahern <dsahern@kernel.org>
>> ---
>> rebased to net tree
> 
> 
> There are other use-cases  that use NUD_NOARP as static neighbour
> entries which should be exempt from forced gc.
> 
> for example when qualified by NTF_EXT_LEARNED for the E-VPN use-case.
> 
> The check in your patch below should exclude NTF_EXT_LEARNED entries.
> 
> 
> (unrelated to the neighbour code ,  but bridge driver also uses
> NUD_NOARP for static entries)
> 
> 

Maybe I misunderstand your comment: forced_gc does not apply to static
entries; those were moved to a separate list to avoid walking them.

