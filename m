Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00D906B041D
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 11:25:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbjCHKZe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 05:25:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230417AbjCHKZ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 05:25:29 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6B72B6D1D
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 02:25:22 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id c18so9479737wmr.3
        for <netdev@vger.kernel.org>; Wed, 08 Mar 2023 02:25:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112; t=1678271121;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0nUFqTSYYlwKcBdbLdi0XKP/nnoX/eyXZwAVZjWpB0g=;
        b=CRPN3d8ln5DVdjmWn0lQzniPy06zXgepRrqUHIrYX5wgR0GvEvbYYk9M6intl6hnzy
         aH4kWmlBjTZen30H+E6POQGHJf+jDQE5XhTOelrBuCOlyYCx8ACHuG7BjfZuo1ZS9ZoP
         BfZ7EUYjhVinkftFysX1F4/nsAkldBf7OgxMtnZdTmjT/OHxL9+bJVnKmbqAquEU8fMf
         hCbSPEHfQ3dJyEMMCjrqG1Z/6LdA2cMVSdIVQgPuY5IFjpb0wqRmGg9ZcNHYP4uFahBN
         m/GYFNAsnfS1b5EHRXVkzKk6TooV7uvXqrAywoxveA9qcXCw32lYRbEsZ/1HqFFdAPiA
         UMjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678271121;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0nUFqTSYYlwKcBdbLdi0XKP/nnoX/eyXZwAVZjWpB0g=;
        b=EQNYMKC6SHvzJ+EZQZ5RTdjAzdtDoYx7/44rK/bERGwzTtDOkYMmu81YbZSU+dlyGV
         sclq3hsclO0mkfljb8cM8hrxJbleDMjtr1bocB/IXlbLoudIrXJdubD5Ijv4G1wV7PWz
         FN8bVmbaIENGZv8+pe+LCaoXsgOSWSWSHCPXf+0cL+hGaM0F+DTDmUUFYk9CFulhGbkh
         qyYNXHoSw5Hlwgc6EiiytSa5nJxr0zjNssXYixN1L4sF312qux4eDhURn5rRLWR7BUe/
         J3QaPn4zWkRyUMuOwpgVb0KuJ7THoQhTZpVnVtDH6yqoMW0Sp/UxQ4R7PGm/DSMCJ1mY
         UCYA==
X-Gm-Message-State: AO0yUKXqZtuqQeNqtDYYvDvoN/umMe2FcBPPmySRF5YKko4waWyXzTNo
        ep4wIp4Clsb6TPJEKPZ+NDDvkA==
X-Google-Smtp-Source: AK7set9rqpA5aqHE2WNGit+ggW0J7JYgHOHtg5YAEOjn6HVsVKJmpalEtASlyHUxLcyA8M8vMCpVgA==
X-Received: by 2002:a05:600c:5123:b0:3ea:ecc2:daab with SMTP id o35-20020a05600c512300b003eaecc2daabmr16862317wms.3.1678271121097;
        Wed, 08 Mar 2023 02:25:21 -0800 (PST)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id u16-20020a5d5150000000b002c559843748sm14915809wrt.10.2023.03.08.02.25.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Mar 2023 02:25:20 -0800 (PST)
Message-ID: <d730e5d1-7dfd-58d7-b443-20461fe98ff2@blackwall.org>
Date:   Wed, 8 Mar 2023 12:25:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next] neighbour: delete neigh_lookup_nodev as not used
Content-Language: en-US
To:     Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>
References: <eb5656200d7964b2d177a36b77efa3c597d6d72d.1678267343.git.leonro@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <eb5656200d7964b2d177a36b77efa3c597d6d72d.1678267343.git.leonro@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/03/2023 11:23, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> neigh_lookup_nodev isn't used in the kernel after removal
> of DECnet. So let's remove it.
> 
> Fixes: 1202cdd66531 ("Remove DECnet support from kernel")
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  include/net/neighbour.h |  2 --
>  net/core/neighbour.c    | 31 -------------------------------
>  2 files changed, 33 deletions(-)
> 

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>


