Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D18A67FE18
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 11:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232628AbjA2KMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 05:12:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231182AbjA2KMy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 05:12:54 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E0CC4C2A
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 02:12:51 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id qw12so8403767ejc.2
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 02:12:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4573WNrB5FF9KwFCy2MksCXmBgaLnWObBAuKFtrdwIo=;
        b=3Rm/xLsmR+ZsqU2licFREtxpDXVf4RkBEpthTk0ryZYfOrooi4j/eSOMdZ+sfvvr3w
         rKTacinZoadKM1PSA6WWWU9GTe+5ckkpopkFhZmwdn0o2TO6Vd+lX9xQVHzSujzCqgpZ
         vLrhwtPqhTtM0BLS2fUAHx7F88LFQr1sxZasR0qNehko8VJ/au9lg7Yke5dFdhka6RBO
         nbE2VxjuMPd7/RUU2rljrBQJ+pSfMrDuNTrMdeaJCE05/9iGQg4JxZqHS0JxQplKLr5/
         WDcT+JTvJ+JaC+ltsJsDHTNqJRDz9C3q/VD4ddkxI3G6es12RkYaG2SSzp0NIJK5xmmV
         pPYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4573WNrB5FF9KwFCy2MksCXmBgaLnWObBAuKFtrdwIo=;
        b=67IrJVtftvwPjPJIGnFxFgm7Ve+84LB6jh7Ogc95Tb9AVpjorjdzuSOfWbdPITl0Sn
         xCD3Gk0XtCMVZZx+w/A28YkGEXZKXi/aHnCLMRpsghZhRrfSfYyasFG/XEaE4BozSFrq
         rUNjS85gRZ9rvXoKZmg746X0aF4DLu/JQQ7c/KxiQn1Jbylfu/9RuPtVn9WlEmTG/3k6
         rhRFvqvK017FLEtyVV7QdFbTIpwE3VHA+IvV1WsxrgEBjwzOEDy6L3FyJ7R0WqPqYdCQ
         Z6+woqpORLHR0If9IF4FdURfhYjdR6RjaUEcnu8MhsXRrKA381yDg1JVfX8ugrgKttja
         Ry0w==
X-Gm-Message-State: AFqh2ko/Gba0KJPLzcEAOeGAmBhAzrd0S9fXptpJpKVqzLJ8yqKMIYtf
        6sPxGhXnr7n8Tq9s14TACRhu/g==
X-Google-Smtp-Source: AMrXdXs1zy4W8Ktd34w5MoSR5ueW6FCh8fcWLUMcFtP4UzBvKef+N3nTzhVSXF/Oj9jDg/w/e7e87A==
X-Received: by 2002:a17:906:8d86:b0:870:dceb:696d with SMTP id ry6-20020a1709068d8600b00870dceb696dmr53919292ejc.43.1674987169706;
        Sun, 29 Jan 2023 02:12:49 -0800 (PST)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id n21-20020a170906689500b00877961fbaffsm5271663ejr.15.2023.01.29.02.12.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Jan 2023 02:12:49 -0800 (PST)
Message-ID: <e38b1c50-2e6a-b2b4-47d0-3ebc707b56a3@blackwall.org>
Date:   Sun, 29 Jan 2023 12:12:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH net-next 16/16] selftests: forwarding: bridge_mdb_max: Add
 a new selftest
Content-Language: en-US
To:     Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>, netdev@vger.kernel.org
Cc:     bridge@lists.linux-foundation.org, Ido Schimmel <idosch@nvidia.com>
References: <cover.1674752051.git.petrm@nvidia.com>
 <b3e7988954d5db878b8e2c97638646b25ab0350c.1674752051.git.petrm@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <b3e7988954d5db878b8e2c97638646b25ab0350c.1674752051.git.petrm@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/01/2023 19:01, Petr Machata wrote:
> Add a suite covering mcast_n_groups and mcast_max_groups bridge features.
> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> ---
>  .../testing/selftests/net/forwarding/Makefile |   1 +
>  .../net/forwarding/bridge_mdb_max.sh          | 970 ++++++++++++++++++
>  2 files changed, 971 insertions(+)
>  create mode 100755 tools/testing/selftests/net/forwarding/bridge_mdb_max.sh
> 

Nice test coverage!
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>

