Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6A27671515
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 08:34:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbjARHe2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 02:34:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbjARHd6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 02:33:58 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B4FA8EFEC;
        Tue, 17 Jan 2023 22:49:25 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id c10-20020a05600c0a4a00b003db0636ff84so781794wmq.0;
        Tue, 17 Jan 2023 22:49:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X3j7TK4o15smaY9j7yBCCWkNi0k481whvm/a6xLSW68=;
        b=qEgfCW2osBy04NQeCBEIzIVQ3BSrHa19rj4E/ZwZb6l+m5MuPKXkWFRMxxgTrwNlKF
         S+agjzMsDo44oOWxavGbaBVcclkBQrIsfWcGyseeMgDIYMHHVGCIN+q/Zxis9KpdXobk
         TgHGo7d39AHHzsyNFI2dBUlqXpNRiLjTw+Pb/h+aVhFo1fBW2C/kyhtQjELfcrpHqj3q
         L72Mzo6enk84zTLrMNkYFKkQq+Rgjzr2W5c0KBz4mV2akothtYIt2d/Qwof2KsxlbT4u
         F3safktAdjdtFHT5z3rGV5OrGy9N6pkvsLd8iNVfoyUL1FCe9pvor4BjK37Y5kChox1Z
         hH2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X3j7TK4o15smaY9j7yBCCWkNi0k481whvm/a6xLSW68=;
        b=E+CurFIXMWQW4uIahOhr2bTn2GKpC6gPsGL+b2em6w8Ek6E/t1POiNnf+wIZdU9j01
         9Lm24U+pIhSB9Svn2PiTwMy2C2qzHwx6WqIJlDLvgUtBlgdMQiLjPJXNj3wYHSL7eKuC
         GevzgKdeBNdyk16ecJx9AUhvtDFbvm3uKuVo6ATVhhNWT/5fKqVczswTC9gpvLT4YWK1
         vjt2umwtGzh/treXdWF8KclUMQ8m8p1CXDem/ZgQSL1q1ZZx0XeAXZ1jZ+qh+gAoImiT
         kUvrGRU+2xFgDsk1cDTsoSHmHZbIyO3mhuftoTWEH6Hm/VbkdvZm1GNxjklB0Hjk2tBU
         RYcQ==
X-Gm-Message-State: AFqh2koPaijXMnMoY38C8QaJjxSQL62d1PtEriqjIk1kHpOvYDecWFkb
        +Y9BTFHFboQsKOM5jRz7lJg=
X-Google-Smtp-Source: AMrXdXsIkAT4mygynpSuSNgl7Bn0qYNULYecV3TnXtqIIyJ/+LBrwp9/iDLLEBDAyljXZZCAC7j8Kw==
X-Received: by 2002:a05:600c:3acc:b0:3d9:efe8:a424 with SMTP id d12-20020a05600c3acc00b003d9efe8a424mr5780077wms.34.1674024563807;
        Tue, 17 Jan 2023 22:49:23 -0800 (PST)
Received: from [192.168.0.103] ([77.126.105.148])
        by smtp.gmail.com with ESMTPSA id o7-20020a5d62c7000000b002bbeda3809csm24594261wrv.11.2023.01.17.22.49.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jan 2023 22:49:23 -0800 (PST)
Message-ID: <c3fac862-2f5a-6be8-5be2-19bf5866c067@gmail.com>
Date:   Wed, 18 Jan 2023 08:49:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH] [v2] mlx5: reduce stack usage in mlx5_setup_tc
Content-Language: en-US
To:     Arnd Bergmann <arnd@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Gal Pressman <gal@nvidia.com>, Lama Kayal <lkayal@nvidia.com>,
        Moshe Tal <moshet@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
References: <20230117210324.1371169-1-arnd@kernel.org>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20230117210324.1371169-1-arnd@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 17/01/2023 23:01, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> Clang warns about excessive stack usage on 32-bit targets:
> 
> drivers/net/ethernet/mellanox/mlx5/core/en_main.c:3597:12: error: stack frame size (1184) exceeds limit (1024) in 'mlx5e_setup_tc' [-Werror,-Wframe-larger-than]
> static int mlx5e_setup_tc(struct net_device *dev, enum tc_setup_type type,
> 
> It turns out that both the mlx5e_setup_tc_mqprio_dcb() function and
> the mlx5e_safe_switch_params() function it calls have a copy of
> 'struct mlx5e_params' on the stack, and this structure is fairly
> large.
> 
> Use dynamic allocation for the inner one.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> v2: simplify the patch
> ---
>   .../net/ethernet/mellanox/mlx5/core/en_main.c   | 17 +++++++++++------
>   1 file changed, 11 insertions(+), 6 deletions(-)
> 

Thanks for your patch.
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
