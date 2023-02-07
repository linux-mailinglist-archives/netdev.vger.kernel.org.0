Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE76568D446
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 11:31:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231506AbjBGKbw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 05:31:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231375AbjBGKbn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 05:31:43 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC38E38641
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 02:30:48 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id ge21-20020a17090b0e1500b002308aac5b5eso8311549pjb.4
        for <netdev@vger.kernel.org>; Tue, 07 Feb 2023 02:30:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VzHx/EVNNfxiZwjE1z86qLF1SOQQivE7PR9SXta9kr0=;
        b=ANMMbWkQyx9Gf9OpODb/BFj2fKoVDES8+fEH1icYGm+NyzdQ5RBTZ9tMgBWJ06ZlRW
         UyMY4fSGfEqM7t667xOLFodiQSdk6ydlyRyF3cWo7aRUpgWfc3UZu4JTQOn88RZLwcUd
         cigpKS8TGsG4IH5FU2HXRaQSyeDPGbcU5afr/r8y55I8KDl99RW1IH1t6TE5+XdLKn7A
         gllosdZSkmtdLIg469LVEfEkFsdbWe8o07bhSY75x5mdzdtBM0tBSZttjj+sUq7t3TPy
         3gxfZZE5gUDz8EH4hz2hIhvPiqXTohCIj+7ohzXKAHZ4EVdEQ2S95u1OnVY52zDNPkKF
         0QAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VzHx/EVNNfxiZwjE1z86qLF1SOQQivE7PR9SXta9kr0=;
        b=zpHYgKlAkwB3AdpeN9N7ea2cIXr4siPFb+chRsEQekq3Br0esIv6jBaPCNhCFCSuos
         lC21CPEYp4l6INpD0G1SBGvgMs9naxrbW/Kr8CVkxycokyW4MnKi+3hjGLf6Ry8zkWXr
         rVvOMsUdUnCcCp3Nk1IUPj7BkBZ3iV/qL5Z4RRvjtI2b8jjkXEngNdZHuBuLHT8TF2IE
         kGgEmlC2Ix7pF8Y47tt8kTYAOeW/a8jLmcDcMB0mXa8d3CRaqyQBRAoyP/c0nTW0pvx6
         rH2553TlwYYhyml+HFUzbnZ22TUqBbWoXGFWQUN4omhvKcPHRk+noRCRqQtUIS/R7gNv
         0bWQ==
X-Gm-Message-State: AO0yUKU5u21RCdKDRimq4jMtpkcSpRvpOtcsJ/+GMDFRSGBISjDjXcr+
        L6weF6P1W7bXC0JlIXKMIxLEig==
X-Google-Smtp-Source: AK7set/N60throOQx1Uwr0cfZqVgk5GxiYBwfolcBcUYkqbDeyd4MCzoL6mOC8COo51U1qfl7pu75Q==
X-Received: by 2002:a05:6a20:7f8e:b0:bb:c590:8db1 with SMTP id d14-20020a056a207f8e00b000bbc5908db1mr3028829pzj.0.1675765848286;
        Tue, 07 Feb 2023 02:30:48 -0800 (PST)
Received: from [10.200.8.117] ([139.177.225.227])
        by smtp.gmail.com with ESMTPSA id b19-20020a056a0002d300b00593c679d405sm8815602pft.78.2023.02.07.02.30.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Feb 2023 02:30:47 -0800 (PST)
Message-ID: <aeae8fb8-b052-0d4a-5d3e-8de81e1b5092@bytedance.com>
Date:   Tue, 7 Feb 2023 18:30:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH 0/3] some minor fixes of error checking about
 debugfs_rename()
Content-Language: en-US
To:     patchwork-bot+netdevbpf@kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     rafael@kernel.org, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, vireshk@kernel.org, nm@ti.com,
        sboyd@kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, netdev@vger.kernel.org
References: <20230202093256.32458-1-zhengqi.arch@bytedance.com>
 <167548141786.31101.12461204128706467220.git-patchwork-notify@kernel.org>
From:   Qi Zheng <zhengqi.arch@bytedance.com>
In-Reply-To: <167548141786.31101.12461204128706467220.git-patchwork-notify@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2023/2/4 11:30, patchwork-bot+netdevbpf@kernel.org wrote:
> Hello:
> 
> This series was applied to netdev/net.git (master)
> by Jakub Kicinski <kuba@kernel.org>:
> 
> On Thu,  2 Feb 2023 17:32:53 +0800 you wrote:
>> Since commit ff9fb72bc077 ("debugfs: return error values, not NULL") changed
>> return value of debugfs_rename() in error cases from %NULL to %ERR_PTR(-ERROR).
>> The comments and checks corresponding to debugfs_rename() should also be updated
>> and fixed.
>>
>> Qi Zheng (3):
>>    debugfs: update comment of debugfs_rename()
>>    bonding: fix error checking in bond_debug_reregister()
>>    PM/OPP: fix error checking in opp_migrate_dentry()
>>
>> [...]
> 
> Here is the summary with links:
>    - [1/3] debugfs: update comment of debugfs_rename()
>      (no matching commit)
>    - [2/3] bonding: fix error checking in bond_debug_reregister()
>      https://git.kernel.org/netdev/net/c/cbe83191d40d
>    - [3/3] PM/OPP: fix error checking in opp_migrate_dentry()
>      (no matching commit)

Hi all,

Does "no matching commit" means that these two patches have not been
applied? And I did not see them in the linux-next branch.

If so, hi Greg, Can you help to review and apply these two patches
([1/3] and [3/3])?

Thanks,
Qi

> 
> You are awesome, thank you!

-- 
Thanks,
Qi
