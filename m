Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28D6169B04F
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 17:14:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230302AbjBQQOE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 11:14:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbjBQQOD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 11:14:03 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75D9E6D26D;
        Fri, 17 Feb 2023 08:14:02 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id bv17so1362674wrb.9;
        Fri, 17 Feb 2023 08:14:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8RQetRR+uhEzx2YjMOMemS0vyYW1DnbUII0q1wHkqQ8=;
        b=F3/ceruWtxrS16K4Dv6Aeo7+a8MCW80cjvNNyU3N38k4tMJHYX6Eb66Nucf9bQ9seW
         goaQYQRC/kjbaAiU37hGcAWItXQz0FgPBghwl+Icp+vwQG6A693YQ3a9qsURR73YrMO2
         tbE0SEzR4DIMyGaaBB0cmFpewUZxdFd5be/KaBQ9DvstX0XB0Ql5oknzMYN/2zAYrqw+
         GpUUsAGmDLHfjcP/72znDsVUTXDDImVcrysIJEnXVFghOEub7temLJ14g0bkvAGXVPXK
         W9K11uWDLVkORQlNVC5eQQHRB5x9CEXIRfQnc06E+AwbFCrX9808+aSC3ADKPiltziZ4
         8bkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8RQetRR+uhEzx2YjMOMemS0vyYW1DnbUII0q1wHkqQ8=;
        b=b2n08LyhhdaI4c4PXYd4fydpQhu+F3egRTOLJ6V20dfXDPp3Asf61QqN6IDDMitcrr
         /IqdD0ZSFReYonFIR694Fhu6AS/CqG8NBUFwVd44RPvPFoB6A09clyizvNIu0n7hwGxP
         tnIbRhCovXRslcFdQq8PtotL8RuXxoBlANwM5DvyFMbCVaVw4VNvoixbIFy9FZBju5jb
         clNVHbwMwo/CxYcfuP2xJdNXhlX9kW75cXPcL6xyi5SppI+BKQiRdN8UoefW1BuGQQ8M
         riOt/wv11F/MDtoGKrWykEdPSV3tT7bktA/WS5ierSdSej9Np00mMZ+FLKdBtd8SpeQB
         TOmg==
X-Gm-Message-State: AO0yUKXdVZHe1R7Tvs6gzyWvqv80bJYER4ThYrLZdNQrSUXqUhYHCFFT
        WcPrt0EJbHK1e0p1RpHLNxs=
X-Google-Smtp-Source: AK7set/+e43c1CRmyqJcABIcyZ9Ql6ZxTB029IByTgxHdOU1lrmValSfsUkp/XrI/wKC6ocRmjSYXw==
X-Received: by 2002:a5d:458d:0:b0:2c3:eafd:143d with SMTP id p13-20020a5d458d000000b002c3eafd143dmr9505154wrq.69.1676650440864;
        Fri, 17 Feb 2023 08:14:00 -0800 (PST)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id b16-20020adfee90000000b002c592535839sm4038665wro.17.2023.02.17.08.14.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Feb 2023 08:14:00 -0800 (PST)
Subject: Re: [PATCH] sfc: use IS_ENABLED() checks for CONFIG_SFC_SRIOV
To:     Arnd Bergmann <arnd@kernel.org>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alejandro Lucero <alejandro.lucero-palau@amd.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Jonathan Cooper <jonathan.s.cooper@amd.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Leon Romanovsky <leon@kernel.org>
References: <20230217095650.2305559-1-arnd@kernel.org>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <f38d6b22-f846-5637-d58b-2d8862bc6840@gmail.com>
Date:   Fri, 17 Feb 2023 16:13:59 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20230217095650.2305559-1-arnd@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/02/2023 09:56, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> One local variable has become unused after a recent change:
> 
> drivers/net/ethernet/sfc/ef100_nic.c: In function 'ef100_probe_netdev_pf':
> drivers/net/ethernet/sfc/ef100_nic.c:1155:21: error: unused variable 'net_dev' [-Werror=unused-variable]
>   struct net_device *net_dev = efx->net_dev;
>                      ^~~~~~~
> 
> The variable is still used in an #ifdef. Replace the #ifdef with
> an if(IS_ENABLED()) check that lets the compiler see where it is
> used, rather than adding another #ifdef.

So we've had Leon telling us[1] to use __maybe_unused, and you're
 saying to use IS_ENABLED() instead.  Which is right?
(And does it make any difference to build time?  I'm assuming the
 compiler is smart enough that this change doesn't affect text
 size...?)
-ed

[1]: https://lore.kernel.org/netdev/cac3fa89-50a3-6de0-796c-a215400f3710@intel.com/T/#md2ecc82f18c200391dc6581ff68ff08eee9a65cf
