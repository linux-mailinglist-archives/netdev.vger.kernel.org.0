Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC36464278F
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 12:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbiLELfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 06:35:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbiLELe7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 06:34:59 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B160F9FF7
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 03:34:58 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id ud5so27029970ejc.4
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 03:34:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ooZLq7sC1+gvKa+ByW5ocyYtYqELg6JGdZXKkHGlG10=;
        b=FOqOQwAe1U/P/Hjau8DIcy0mlJikU16lqvhT7CE6yM/4PjW75TMvkWw/M5y2EvDLNe
         hqxJZNjlaamV903SWrDyFYo1+4HatPbg1zADpCVLwft1OHWtXoIrl3URln022KwzXgIJ
         XtGvxzLoNyj8mr6hruhYTTbAtKNYPQGUxHYS7Wbdvs+VZTP4MQ3KPEMM34zByBcf7gYc
         PhcI3foWpz/B1TgA7xT/4Y7dQ365b8qSu/w9Ku6MmCSOr/gSBZJ6vY2DCtu80Oh8f7un
         taZq/9/FfsCW37s5e1lUMV0p1C0SqkB9GWnq5LL23NhcG5lXJlHZTUY16QJwK0UavAGs
         w3Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ooZLq7sC1+gvKa+ByW5ocyYtYqELg6JGdZXKkHGlG10=;
        b=dmDePamEFDCGjMwhMyDIUFhpeXm4OdtgjJ27vuj1eAhx8rUxtKWx6Xn2HXFzBYEKls
         9W07Oc/aKtwgVFZJ/OzBbEM4vHLUKEOTgU9BPAKl63Ha+cl8FZhWtmHLtdh/MEGgqO4C
         p6C3b/crxFcsQlLhautaN7NN7n/46cZqTM2O76OYWaweTJ2O7N8jGDBgMjoDXX/uiDIK
         RodP8iXf4x2lLJNE5TEFkC9wMB7362JiK9em6A+v7MexZGJYkwp+SIrODoPV+L8O27dF
         1oYyQE/Bc5E+OBzX+t/WVgtWuorEHLskY9ChRc6qvD+Hh7qZ1aHmlK7uzXJxg9UHLzrz
         AEoA==
X-Gm-Message-State: ANoB5pm9jpvIrnZoSj+doJekFgjxu82lcNXOGWGc5tWkST/igv4weV6a
        1uyr5VRxUqcvjhYKGgmYQZGh7A==
X-Google-Smtp-Source: AA0mqf7H/OELVb6xKddYiVV2gHH48L6eEOu0XpzHxFNdvKfIEgqeSU6U+XauydpxVaxz+xydnnpABA==
X-Received: by 2002:a17:906:39c8:b0:7ad:79c0:5482 with SMTP id i8-20020a17090639c800b007ad79c05482mr59470289eje.730.1670240097030;
        Mon, 05 Dec 2022 03:34:57 -0800 (PST)
Received: from [192.168.0.161] (79-100-144-200.ip.btc-net.bg. [79.100.144.200])
        by smtp.gmail.com with ESMTPSA id z3-20020a170906240300b007aef930360asm6190848eja.59.2022.12.05.03.34.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Dec 2022 03:34:56 -0800 (PST)
Message-ID: <39f8b0e3-96a3-9a36-5a99-48088b229f4e@blackwall.org>
Date:   Mon, 5 Dec 2022 13:34:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next 2/8] bridge: mcast: Remove redundant checks
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, mlxsw@nvidia.com
References: <20221205074251.4049275-1-idosch@nvidia.com>
 <20221205074251.4049275-3-idosch@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20221205074251.4049275-3-idosch@nvidia.com>
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
> These checks are now redundant as they are performed by
> br_mdb_config_init() while parsing the RTM_{NEW,DEL}MDB messages.
> 
> Remove them.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/bridge/br_mdb.c | 63 +++++++--------------------------------------
>  1 file changed, 9 insertions(+), 54 deletions(-)
> 

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>


