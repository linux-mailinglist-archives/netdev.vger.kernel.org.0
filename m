Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7969068E64D
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 03:51:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbjBHCvi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 21:51:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbjBHCvg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 21:51:36 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DECFD42DF2
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 18:51:13 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id g13so12984938ple.10
        for <netdev@vger.kernel.org>; Tue, 07 Feb 2023 18:51:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aiw2Ta+qPdaOSYiFSjZzLWkGsOWxNlcenf3Fz/uk66k=;
        b=ZsCiURAu9xsOOeq+DYgbrFnmT08fASos4hHrcniE2/gf2Mn9G3Ky25vvfkfeMjAg8b
         4fxNtLqw5OkNi41rNNLlvXtavVGmKBW1kQCuJ7NUC2rzDIhNJNifbGWj5z54Fwm4VzAd
         mwoBl9t9GhUBYpO4epXx52TJ39nLSE7ECc9F7r8CNl71Uxjhd0npFRp1ct9qb1IVCe1J
         oKwSfNkBhdvA3GNM6nHlyQUxIbrbCcpBxJQiUedc8NQmx9zS3TfjDCFW0aMU7kWUGmfP
         R5YbPOFQumIvDkndayj7/xVkahcy+4a6wyv+q3fdKa3kBxRJ8rmQujl+ux/RgaYVpPFv
         ZH/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aiw2Ta+qPdaOSYiFSjZzLWkGsOWxNlcenf3Fz/uk66k=;
        b=OkjDahcZ/D1xW8C9Uh6a0sstwGmMwpthfzxqGWe93t3XJnCLCd6oRQqpbONnMsLQn1
         EPDhhgGKKtU+wL5tZ+r0A5TdQVjVDFEBT2680bW3Gix2Nv7HJEy6q3vItoci11rFPSom
         h6wDAxLJopXdcI3wbYXFtWYP32uDAPFthiDq/bBZC8rcXN7WEhR6u4DfqtYY79LvNnWK
         P2VDKZyG7wfW1BCl7+jwiPcZ+lhKxUK0hsM5od570OGIyaS1jyjQMeVeKosshk9whIGE
         Dx9i+DYv6q2+eUcTgiRRovZi7uGI9IoFjvuvPJEF9Iw06FJHcWJ3eyT6URpmOz0Pln2R
         IbEA==
X-Gm-Message-State: AO0yUKXr/LbziH71GEjLp8600LLGhxFbE7WR491XYbbC/Z9FH3uzsMej
        8emMiWtkUmkXcA1MYvnLCvDEeQ==
X-Google-Smtp-Source: AK7set/S2Cq0ByezHnBwLK/m74mZmeQa/ljMv8LSKmVVTJ/rYIKApNbiSJjaZQoXFbrWujDFc/1y7A==
X-Received: by 2002:a17:903:32c3:b0:199:4362:93f6 with SMTP id i3-20020a17090332c300b00199436293f6mr1129768plr.4.1675824673374;
        Tue, 07 Feb 2023 18:51:13 -0800 (PST)
Received: from [10.200.9.31] ([139.177.225.226])
        by smtp.gmail.com with ESMTPSA id u14-20020a170902a60e00b001990361c134sm6099725plq.87.2023.02.07.18.51.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Feb 2023 18:51:12 -0800 (PST)
Message-ID: <2dea582a-acb1-c0f5-2e59-8d14470e380a@bytedance.com>
Date:   Wed, 8 Feb 2023 10:51:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH 0/3] some minor fixes of error checking about
 debugfs_rename()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, rafael@kernel.org,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        vireshk@kernel.org, nm@ti.com, sboyd@kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        netdev@vger.kernel.org
References: <20230202093256.32458-1-zhengqi.arch@bytedance.com>
 <167548141786.31101.12461204128706467220.git-patchwork-notify@kernel.org>
 <aeae8fb8-b052-0d4a-5d3e-8de81e1b5092@bytedance.com>
 <20230207103124.052b5ce1@kernel.org>
Content-Language: en-US
From:   Qi Zheng <zhengqi.arch@bytedance.com>
In-Reply-To: <20230207103124.052b5ce1@kernel.org>
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



On 2023/2/8 02:31, Jakub Kicinski wrote:
> On Tue, 7 Feb 2023 18:30:40 +0800 Qi Zheng wrote:
>>> Here is the summary with links:
>>>     - [1/3] debugfs: update comment of debugfs_rename()
>>>       (no matching commit)
>>>     - [2/3] bonding: fix error checking in bond_debug_reregister()
>>>       https://git.kernel.org/netdev/net/c/cbe83191d40d
>>>     - [3/3] PM/OPP: fix error checking in opp_migrate_dentry()
>>>       (no matching commit)
>>
>> Does "no matching commit" means that these two patches have not been
>> applied? And I did not see them in the linux-next branch.
> 

Hi Jakub,

> Correct, we took the networking patch to the networking tree.

Thank you very much. :)

> You'd be better off not grouping patches from different subsystems
> if there are no dependencies. Maintainers may get confused about
> who's supposed to apply them, err on the side of caution and
> not apply anything.

Got it. I will send [1/3] and [3/3] separately.

> 
>> If so, hi Greg, Can you help to review and apply these two patches
>> ([1/3] and [3/3])?
> 
> Or 3/3 should go to Viresh?.. Dunno..

Got it.

Thanks,
Qi

