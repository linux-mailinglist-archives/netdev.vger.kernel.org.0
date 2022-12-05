Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B65A96427B9
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 12:43:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbiLELnA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 06:43:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231355AbiLELmR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 06:42:17 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F29411A20F
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 03:42:05 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id s5so15308084edc.12
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 03:42:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nrWL8VxV0K9t0uZy6ZzE5+V/ehvOIE3e5uGU6WmUU3g=;
        b=n/JHSIp5f7fAh4109T4B/S5kbuGEk//xfTg/w87G677OjtlH3/YKvF8TZjZSMoP9Ra
         qUQ98PTxBGTeetn12wzisQsFSgoesqRH5HORYzjd4GN+yi/VcZBsu3EGjAI3aC1nrrW9
         9mw58FvzPYZfn5/gYnda4NFrSNsSbWXzf/k3tA0iE649LOq0EXGLbRMzswfvN4eSrp7R
         3qlRany7DwBZYrwvwpCFV/O8B0FyUXJCFUE8SmAy4Fx+Nl+hTGpqFB42N18fY904YwE7
         51q9JRMNPjnI4E2GPnN83p6wc6hyEJoXNTh7a+zBzP8pGNTJDOG4P7RRjjG/b9WPyvKH
         uX9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nrWL8VxV0K9t0uZy6ZzE5+V/ehvOIE3e5uGU6WmUU3g=;
        b=vmzrUJDnpj6h6UfePNYmIN3ZSc2NU7EZ3+8LvuBLOR0E5EwrKLbc/LoesUYuY6TYWh
         Qhlhumarw9uZHqmWDpPBP3Dq10ZbEWtN60FycUF5UkjdQ+81Uf7CaRzMJy21uaTwYdWY
         agj15urUQG9GFDW4a9fdM8J/Xu/UTM0o4iaohdVOR506R+9j/8syNMUrmWXc80mbQMzT
         yD7MuRhXp+ZDvJZUsx8iiIGRVpB8EyeQeLDZ/+YqVcTL+yNVdcgBmm0zEFxQoeqEqryh
         wZHyu9QpCBWD2jI2tlDxDpHNIv4HW7adx98VTiSHOOikSnefWsKI31WjBq9eycqC/JuQ
         H67g==
X-Gm-Message-State: ANoB5pkLdVmqlX1738UJ7FbJt8uBHus0UcH80NF4jKKyoJukmXgn8KSv
        KjD8ote1GdthPmuQbXpegvLvtAxE3e0+9ofLzIc=
X-Google-Smtp-Source: AA0mqf7FqZrEI5Sxh/yhl80H3SHBzft7AK1rxYdF4kgIq83YlPSwOsF0dOgYGZV9y1mqbY2kFMaIYw==
X-Received: by 2002:a05:6402:538e:b0:468:ea55:ab40 with SMTP id ew14-20020a056402538e00b00468ea55ab40mr9512064edb.323.1670240524429;
        Mon, 05 Dec 2022 03:42:04 -0800 (PST)
Received: from [192.168.0.161] (79-100-144-200.ip.btc-net.bg. [79.100.144.200])
        by smtp.gmail.com with ESMTPSA id v5-20020aa7d805000000b0045723aa48ccsm6091801edq.93.2022.12.05.03.42.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Dec 2022 03:42:03 -0800 (PST)
Message-ID: <aa2c2350-7210-ce54-f75e-62d56be2b4d2@blackwall.org>
Date:   Mon, 5 Dec 2022 13:42:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next 6/8] bridge: mcast: Remove br_mdb_parse()
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, mlxsw@nvidia.com
References: <20221205074251.4049275-1-idosch@nvidia.com>
 <20221205074251.4049275-7-idosch@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20221205074251.4049275-7-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/12/2022 09:42, Ido Schimmel wrote:
> The parsing of the netlink messages and the validity checks are now
> performed in br_mdb_config_init() so we can remove br_mdb_parse().
> 
> This finally allows us to stop passing netlink attributes deep in the
> MDB control path and only use the MDB configuration structure.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/bridge/br_mdb.c | 93 +++------------------------------------------
>  1 file changed, 5 insertions(+), 88 deletions(-)
> 

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>


