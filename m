Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9591680B4B
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 11:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236011AbjA3KuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 05:50:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235596AbjA3KuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 05:50:13 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D8042B0AA
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 02:50:11 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id q10-20020a1cf30a000000b003db0edfdb74so8375738wmq.1
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 02:50:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fRM03qwfbEeaEuYQXnBVl6nNRGYFGoNY4J9VMiyCffA=;
        b=NCwWTwRYc15Ca5bNTvrXy7xKphZYBtaX224MigV/0Qj0yXcIlLqtDbYfc9bHAGKRfL
         Esy3gVsDmAbj35cmSi2VC03rdALu4R3sG/UrduCqh56GxPAeUfg1QQo8D0CqkEtrwcug
         YS2G5mMhpnjAkVoCgNSVXugvlccbNaGwDMYj7Hrptj0u9N86k5IY9o4kG0sEmmV/lXnF
         NuC/VadCSgusEUVPhZqbxFoQlev2AE57gpKUexhtIPPSqEYXDQsySqO5s8XBA28nhaDM
         T0q5RodLbrzNLAdx4euM+hoNIicg0lqtDOMB1i2FS3jttow1RecB5293mLPccCoJKec7
         3h4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fRM03qwfbEeaEuYQXnBVl6nNRGYFGoNY4J9VMiyCffA=;
        b=04XOgjxQ+10ju0PoaHgv/y8jdOJWVprH81x4A3Hdk2npGDv/Ht7ZNYJF07op1KI9DP
         MRtsFD9jbdjgz9Z4OpB1QOJKCYksFiClT+wshLpp/Hc3j43fxdIpjkBZST/BCemaFJBL
         5Ixx3oN9FW/XhmshyciOoOuN2SjGb8QloJ/ITJKim9z1mvl525yN6G+oTv5dKhsijdBC
         UBMxdjHyUXOYaaYO4z3e/1BhSe2bJsydpR1j4Ye/Bcn1a5nClYCDPDqNO/2nd81Rf2yg
         5BSa9JpqgFZ9m1Wh/Oyo5pQUojK1lgrCohJ5Hwa5SXDbFciSaEa2wbBjqeoNEvM6XMDX
         Fr4w==
X-Gm-Message-State: AFqh2kq+yxL3xuiW5MMpIYgeQ1CThFl2WTKEu9lGcJx720+PgUXgk39h
        nOc6TPq02y8uKculhf27Jbg14w==
X-Google-Smtp-Source: AMrXdXv97F6QWaNocmG9cYDEz0vQIT2EG5H6BbtyKWcsDOmeGPxfhiD7/BDAK+gFrLM5dDzA+wv9WQ==
X-Received: by 2002:a05:600c:4fc9:b0:3d9:f769:2115 with SMTP id o9-20020a05600c4fc900b003d9f7692115mr49552912wmq.26.1675075809787;
        Mon, 30 Jan 2023 02:50:09 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id l16-20020a7bc350000000b003d9aa76dc6asm18554701wmj.0.2023.01.30.02.50.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 02:50:09 -0800 (PST)
Date:   Mon, 30 Jan 2023 11:50:08 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     patchwork-bot+netdevbpf@kernel.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, jacob.e.keller@intel.com,
        gal@nvidia.com, mailhol.vincent@wanadoo.fr
Subject: Re: [patch net-next 0/3] devlink: fix reload notifications and
 remove features
Message-ID: <Y9eg4OmDARyDHUFc@nanopsycho>
References: <20230127155042.1846608-1-jiri@resnulli.us>
 <167506861691.21040.7506893085716379938.git-patchwork-notify@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167506861691.21040.7506893085716379938.git-patchwork-notify@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Jan 30, 2023 at 09:50:16AM CET, patchwork-bot+netdevbpf@kernel.org wrote:
>Hello:
>
>This series was applied to netdev/net-next.git (master)
>by David S. Miller <davem@davemloft.net>:
>
>On Fri, 27 Jan 2023 16:50:39 +0100 you wrote:
>> From: Jiri Pirko <jiri@nvidia.com>
>> 
>> First two patches adjust notifications during devlink reload.
>> The last patch removes no longer needed devlink features.
>> 
>> Jiri Pirko (3):
>>   devlink: move devlink reload notifications back in between _down() and
>>     _up() calls
>>   devlink: send objects notifications during devlink reload
>>   devlink: remove devlink features
>> 
>> [...]
>
>Here is the summary with links:
>  - [net-next,1/3] devlink: move devlink reload notifications back in between _down() and _up() calls
>    https://git.kernel.org/netdev/net-next/c/7d7e9169a3ec
>  - [net-next,2/3] devlink: send objects notifications during devlink reload
>    https://git.kernel.org/netdev/net-next/c/a131315a47bb
>  - [net-next,3/3] devlink: remove devlink features
>    https://git.kernel.org/netdev/net-next/c/fb8421a94c56

Hi.
The merge commit text is wrong:
    Merge branch 'devlink-next'

    Jakub Kicinski says:

    ====================
    devlink: fix reload notifications and remove features

    First two patches adjust notifications during devlink reload.
    The last patch removes no longer needed devlink features.

"Jakub Kicinsky says" should be "Jiri Pirko says". I thought this is
done by a bot? Is the bot buggy?



>
>You are awesome, thank you!
>-- 
>Deet-doot-dot, I am a bot.
>https://korg.docs.kernel.org/patchwork/pwbot.html
>
>
