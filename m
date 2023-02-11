Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA14692FB7
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 10:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbjBKJNA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Feb 2023 04:13:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbjBKJM4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Feb 2023 04:12:56 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 061E55A930
        for <netdev@vger.kernel.org>; Sat, 11 Feb 2023 01:12:55 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id n20-20020a17090aab9400b00229ca6a4636so12560434pjq.0
        for <netdev@vger.kernel.org>; Sat, 11 Feb 2023 01:12:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OoCdS2UBlXQ9GSP13nvz6NqjJ97/4rzSEuJAd9NhpE4=;
        b=1qEplTAnlipg6EdrqIrNeLHMNuXussWAZPig++YBkNAoSw8ILqUQJIdui1GKnx6jog
         YsRMktubv1RZpayKWDyVxHvH3WFaD0THcwNlN9JnFf37d4cjhgn2FaroOyAUVChcViyz
         C8gbxeqP0BYB8jRkTcH14wg+R9hf2BdziqV8OGAzftxPZPe1bLwy6uwCl4Gy7nv/jPM0
         8Oo9L6aKHiPIV76LHQiDVSTbcK4p3tbn+WpvZ76Q54zMJBRlK/lMhgJ9JzgdDT0DBXxk
         8xB/Q5NqY0eJDL1Rv/s/56HGYWGpL/LrnVzAwj7GT0OFJtUI6GeUHoTEllbqfcR/ZESq
         gKfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OoCdS2UBlXQ9GSP13nvz6NqjJ97/4rzSEuJAd9NhpE4=;
        b=U5U4TuljuQq//01G9H5XaabQ5kYRlAJj/MkmI9r3U9YOSR3AKzbqqKTaLfhn26yU1a
         zCVL39F3Fco1ehv5YS6W7g1l43aJWhbTCEBt+74J6s8xYKvkPMMd6yGsV/3ZovD+FOnb
         r+rQ2Zs7sEFKjCUaserSL679EHRl+HpY5qEvntCGmGczWArYT/q26+6HZ/yBasIt9L95
         9YIMSphy8mCzAMRRRz84BrA0lki9xjSSOlGfmbAf7aLjCG08+TUXQviIu9d7NrBZJP8s
         0bg7It0Pl8VaMfBF9vS2EY4hsATz/aa+2GZrjLL6x38Af3YqqIphOxr9klKCZcQcsO9B
         YH5Q==
X-Gm-Message-State: AO0yUKUaSFuRhJkxsXsDrEODlS36rMM4UcW+1rBa17SN/czdGlbmIt8z
        eT73ijArW7dWWKAVCa/IDQRVyA==
X-Google-Smtp-Source: AK7set8ixUwlWq4LvtWNB73ypMSQRg6Q6YCS3qwxsLIBt0wyZtL5vo9HXaqynGXJ+6JPd5bxEU8q5Q==
X-Received: by 2002:a17:90a:3f17:b0:230:dc97:9da2 with SMTP id l23-20020a17090a3f1700b00230dc979da2mr15347291pjc.1.1676106774447;
        Sat, 11 Feb 2023 01:12:54 -0800 (PST)
Received: from [10.200.9.4] ([139.177.225.240])
        by smtp.gmail.com with ESMTPSA id t7-20020a17090a2f8700b002309bbc61afsm6260623pjd.18.2023.02.11.01.12.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Feb 2023 01:12:53 -0800 (PST)
Message-ID: <88526cb7-b81d-6780-ff49-fb01d66a55ce@bytedance.com>
Date:   Sat, 11 Feb 2023 17:12:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH 0/3] some minor fixes of error checking about
 debugfs_rename()
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     patchwork-bot+netdevbpf@kernel.org, rafael@kernel.org,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        vireshk@kernel.org, nm@ti.com, sboyd@kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
References: <20230202093256.32458-1-zhengqi.arch@bytedance.com>
 <167548141786.31101.12461204128706467220.git-patchwork-notify@kernel.org>
 <aeae8fb8-b052-0d4a-5d3e-8de81e1b5092@bytedance.com>
 <20230207103124.052b5ce1@kernel.org> <Y+ONeIN0p25fwjEu@kroah.com>
 <420f2b78-2292-be4a-2e3f-cf0ed28f40d5@bytedance.com>
 <Y+dal7QKULCa+mb4@kroah.com>
From:   Qi Zheng <zhengqi.arch@bytedance.com>
In-Reply-To: <Y+dal7QKULCa+mb4@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2023/2/11 17:06, Greg Kroah-Hartman wrote:
> On Wed, Feb 08, 2023 at 08:05:44PM +0800, Qi Zheng wrote:
>>
>>
>> On 2023/2/8 19:54, Greg Kroah-Hartman wrote:
>>> On Tue, Feb 07, 2023 at 10:31:24AM -0800, Jakub Kicinski wrote:
>>>> On Tue, 7 Feb 2023 18:30:40 +0800 Qi Zheng wrote:
>>>>>> Here is the summary with links:
>>>>>>      - [1/3] debugfs: update comment of debugfs_rename()
>>>>>>        (no matching commit)
>>>>>>      - [2/3] bonding: fix error checking in bond_debug_reregister()
>>>>>>        https://git.kernel.org/netdev/net/c/cbe83191d40d
>>>>>>      - [3/3] PM/OPP: fix error checking in opp_migrate_dentry()
>>>>>>        (no matching commit)
>>>>>
>>>>> Does "no matching commit" means that these two patches have not been
>>>>> applied? And I did not see them in the linux-next branch.
>>>>
>>>> Correct, we took the networking patch to the networking tree.
>>>> You'd be better off not grouping patches from different subsystems
>>>> if there are no dependencies. Maintainers may get confused about
>>>> who's supposed to apply them, err on the side of caution and
>>>> not apply anything.
>>>>
>>>>> If so, hi Greg, Can you help to review and apply these two patches
>>>>> ([1/3] and [3/3])?
>>>
>>> If someone sends me patch 1, I can and will review it then.  Otherwise,
>>> digging it out of a random patch series is pretty impossible with my
>>> patch load, sorry.
>>
>> Hi Greg,
>>
>> Sorry about this. My bad. And I have sent the [1/3] separately, please
>> review it if you have time. :)
> 
> Ick, somehow all of these got marked as spam by my filters.  I'll look
> at them next week, sorry for the delay.
No worries. And the patch link that has been resent is
https://lore.kernel.org/lkml/20230208035634.58095-1-zhengqi.arch@bytedance.com/. 
:)

Thank you very much,
Qi

> 
> greg k-h
