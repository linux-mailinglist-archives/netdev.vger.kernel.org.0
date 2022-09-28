Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09BA45EE435
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 20:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234050AbiI1ST2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 14:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234306AbiI1STC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 14:19:02 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E94A109774
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 11:18:04 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id c11so21008952wrp.11
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 11:18:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:references:cc:to:subject:from:from:to:cc
         :subject:date;
        bh=WvZfjT+KGPncwoli27cObekkWViFSqFqrZCljMfZ7nY=;
        b=MVhhcYCeUIa7oHQ5EzsGc+3ojbNkjckmyam6dhq4YQMf9Qyrkw0a8Nc9O5OI2e9e3a
         HGJWp6AvlDLeVDauVt8ATm96yu7Tho3TKzEDGTO3hWzPoG49fP+ynQPvMQJFH2VGKAVM
         9du5rssjtXeS4XKbP+tI3M22mpTykojQYP3cLZJhbx5P1ZKdRDrWNpGiPvNHhRQuJ+IC
         iP+RCC3i/JAYxhpHdMy/uZEWv67DP+bdrEAUbpGB3aVIBCdyqc1+YJn5TMj8hegRCj4A
         qt7TOT6iGb0tkSIy332w42nYnelVWiedNq5ysbtM41wSphWJ62irF1MmpKM1CYNt7Qf4
         BdHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:references:cc:to:subject:from
         :x-gm-message-state:from:to:cc:subject:date;
        bh=WvZfjT+KGPncwoli27cObekkWViFSqFqrZCljMfZ7nY=;
        b=k9np+U2xCr+sso8bjbkthkXYYrn59B3tX3Du4eMvv0yXNGJO+qIseOCowTe/F+gD/6
         SMiIyi8PBe5hPWTlJ8IsR1DgIeoD7gaDbXFoxmI7RibpFLjSxzCu1WUgx/J1cO8C0s9q
         bSsDC8wO+8jGgIse++ucFlFz4TDTjhX2+vM26YrMsd1HngUJkLZ617MBQQIZr5PxhzqD
         +h8u5A2i0WIXBAmM/31qh4u6+9S5w7PgfxSmDX0qwcB9tHGCBbAZk2ABFUFC/kc9h7Z3
         46eFxzoWVhv8aBLlgnxssZt0yQ1eyU1eDk683FMhQF+Yo3DSCwz7C5I92FvmqWjsrb4B
         d5fg==
X-Gm-Message-State: ACrzQf1ACnjo63g+C9+nFGjkx8vqF8Xxu2Dy4cEEdhWH3UfI3KFMUVle
        7DeX33kh2alXk8AyBfVXSLg=
X-Google-Smtp-Source: AMsMyM6BPYGALQmpGouck54b+aVE3hF/QzEQvl81QJCTKV8EUkzbgPortzGbPQQzIHaAvGrkmGhNow==
X-Received: by 2002:adf:eb84:0:b0:22a:917e:1c20 with SMTP id t4-20020adfeb84000000b0022a917e1c20mr21449509wrn.223.1664389082511;
        Wed, 28 Sep 2022 11:18:02 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id e9-20020adfe389000000b00228daaa84aesm4693343wrm.25.2022.09.28.11.18.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Sep 2022 11:18:01 -0700 (PDT)
From:   Edward Cree <ecree.xilinx@gmail.com>
Subject: Re: [PATCH v2 net-next 3/6] sfc: optional logging of TC offload
 errors
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-net-drivers@amd.com,
        davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        habetsm.xilinx@gmail.com
References: <cover.1664218348.git.ecree.xilinx@gmail.com>
 <a1ff1d57bcd5a8229dd5f2147b09c4b2b896ecc9.1664218348.git.ecree.xilinx@gmail.com>
 <20220928104426.1edd2fa2@kernel.org>
Message-ID: <b4359f7e-2625-1662-0a78-9dd65bfc8078@gmail.com>
Date:   Wed, 28 Sep 2022 19:17:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220928104426.1edd2fa2@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/09/2022 18:44, Jakub Kicinski wrote:
> On Mon, 26 Sep 2022 19:57:33 +0100 ecree@xilinx.com wrote:
>> TC offload support will involve complex limitations on what matches and
>>  actions a rule can do, in some cases potentially depending on rules
>>  already offloaded.  So add an ethtool private flag "log-tc-errors" which
>>  controls reporting the reasons for un-offloadable TC rules at NETIF_INFO.
> 
> Because extack does not work somehow?

Last I checked, flow rules coming from an indirect binding to a tunnel
 netdev did not report the hw driver's extack (or even rc) back to the
 user.
Also, extack can only contain fixed strings (netlink.h: "/* Currently
 string formatting is not supported (due to the lack of an output
 buffer.) */") which was a real problem for us.

> Somehow you limitations are harder to debug that everyone else's so you
> need a private flag? :/

It's not about debugging the driver, it's about communicating the
 limitations to the end user.  Having TC rules mysteriously fail to be
 offloaded with no indication of why is not a great UX :(
I couldn't see a way to handle this without vendor-specific ugliness,
 but if you have a proposal I don't mind putting in some work to
 implement it.

-ed
