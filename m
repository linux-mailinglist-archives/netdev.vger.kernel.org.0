Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 564F144DDD1
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 23:19:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233620AbhKKWWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 17:22:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233913AbhKKWWZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 17:22:25 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83FBCC061205
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 14:19:35 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id r10-20020a056830080a00b0055c8fd2cebdso10989633ots.6
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 14:19:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=accEw/Egbd2gS5q8Kbzt6W1c0cUYIIqZRnaUHnz+byg=;
        b=c3Oun6bPHKhZK/lhw7UJbZz2E2HQxe6REO+ifhldjtzuyM1XiDNthV5cbCwtf4bouA
         TBkXRfDJ0N0iqzFe4hapdrX/5yffZa9FgyhdZuiGQSQcdUwOZJF2lbO2yt2bKKq/TavR
         jHUN9wvz8JQmC3ZxGi+T2xiAMGSurLR78hAGQ1ECLHbdVmQ+oS2zmT5spRQQH3gUzzwx
         HkD8m98sDAKqS94XdN/BwSOC7NPCAAnHEkyO1EAHNNAgPjO8Mq6a6Y3tjJuWStitEj+9
         aauiEwt1jnFVO6W/rO5jxsKGRRL2CzXSCo2c4kP6uXq+MnVT+hp5rwuWD2+6Y8HQJkQM
         Oh/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=accEw/Egbd2gS5q8Kbzt6W1c0cUYIIqZRnaUHnz+byg=;
        b=pYHWLdkTdk1hkM0nk+nW8jMUUBOAfTe/gjkhBmbUCdfWLF7cnasdNc7Cjv0uI8BJPt
         A5AepJ76HzDWKNa7aTncZ4I/g9SdL61SPL4RVkgk9t34mwOrcrAflxg4Ts6TvJq21dxD
         oWR+V99wLzMKAOIStx2Jk7TlvXhIBbu3K/OIBLlgeHBPZSOEVuSmM9L/CxccNsq2rPfp
         FHk83UElHIjfbVNiODYcCW/HW1Gbd/ybfIbap2J0OzJ/gm+ftYTwTHCaO8PM8DBmOeyZ
         B+E6/+OUS1WhM8rT0+0N9sjibl0Ui9mW3aP+B+6yQB8HT8pKOHOcdLdaYDo/bPDwvBrP
         37JQ==
X-Gm-Message-State: AOAM531YyZH9U2SuaFo2ch5HsxIeYMv65wy+ASyEt9xAxbPmGFNZLMo/
        tT6h8tLTbsFtuaUiMpYYsjg=
X-Google-Smtp-Source: ABdhPJxiyhhIFrpHdZciFpvQXmGE3fA/du+WOTjQO9COBxAkbyclipekfRgK0bm9QRR1Lo8orUTS7g==
X-Received: by 2002:a9d:24c5:: with SMTP id z63mr8467867ota.321.1636669174939;
        Thu, 11 Nov 2021 14:19:34 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id r13sm758381oot.41.2021.11.11.14.19.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Nov 2021 14:19:34 -0800 (PST)
Message-ID: <b90e874b-30a7-81bb-a94f-b6cebda87e99@gmail.com>
Date:   Thu, 11 Nov 2021 15:19:33 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: [RFC PATCH net-next] rtnetlink: add RTNH_F_REJECT_MASK
Content-Language: en-US
To:     Alexander Mikhalitsyn <alexander@mihalicyn.com>,
        Roopa Prabhu <roopa@nvidia.com>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrei Vagin <avagin@gmail.com>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
References: <20211111160240.739294-1-alexander.mikhalitsyn@virtuozzo.com>
 <20211111160240.739294-2-alexander.mikhalitsyn@virtuozzo.com>
 <1f4b9028-8dec-0b14-105a-3425898798c9@gmail.com>
 <CAJqdLrqvNYm1YTA-dgGsrjsPG6efA8nsUCQLKmGXqoDM+dfpRQ@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <CAJqdLrqvNYm1YTA-dgGsrjsPG6efA8nsUCQLKmGXqoDM+dfpRQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ cc roopa]

On 11/11/21 12:23 PM, Alexander Mikhalitsyn wrote:
> On Thu, Nov 11, 2021 at 10:13 PM David Ahern <dsahern@gmail.com> wrote:
>>
>> On 11/11/21 9:02 AM, Alexander Mikhalitsyn wrote:
>>> diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
>>> index 5888492a5257..c15e591e5d25 100644
>>> --- a/include/uapi/linux/rtnetlink.h
>>> +++ b/include/uapi/linux/rtnetlink.h
>>> @@ -417,6 +417,9 @@ struct rtnexthop {
>>>  #define RTNH_COMPARE_MASK    (RTNH_F_DEAD | RTNH_F_LINKDOWN | \
>>>                                RTNH_F_OFFLOAD | RTNH_F_TRAP)
>>>
>>> +/* these flags can't be set by the userspace */
>>> +#define RTNH_F_REJECT_MASK   (RTNH_F_DEAD | RTNH_F_LINKDOWN)
>>> +
>>>  /* Macros to handle hexthops */
>>
>> Userspace can not set any of the flags in RTNH_COMPARE_MASK.
> 
> Hi David,
> 
> thanks! So, I have to prepare a patch which fixes current checks for rtnh_flags
> against RTNH_COMPARE_MASK. So, there is no need to introduce a separate
> RTNH_F_REJECT_MASK.
> Am I right?
> 

Added Roopa to double check if Cumulus relies on this for their switchd.

If that answer is no, then there is no need for a new mask.

