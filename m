Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8CBA6C883E
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 23:21:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231516AbjCXWVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 18:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbjCXWVV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 18:21:21 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37294166E7;
        Fri, 24 Mar 2023 15:21:16 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id 31so2705367qvc.1;
        Fri, 24 Mar 2023 15:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679696475;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ynyRu9MXX0o1sLS2T/gIPwPvYYermXkBvLgDj6CJ3Qw=;
        b=GEfnzWlrq2DN/opiY2cgKie6j/qUb8BIxelj1dORs8BbeGj1nEgzegugIfL3L0bMVG
         2JmiZrih1YD1F9RDA7p9/RczEedelj63DcNPTTwmsMW8OUNHwJ3wSNx1wyNFyt2GuOvj
         lcZPvrxtERniJ3Ei26fHdhR/exAi2td2nH6qgobSGNgSAxr7wxOpXf1vtzdridQ+ZYAt
         +v7RZ3cn6YxDSHyJxL5iCMGKtATMnBpDNeMbgDORBgQJxYuIsyCh8mPdPS/VJjQkMT8K
         cAR6A6khHsgyZYolbEz8UPX6wIw4oU7ZvZoy5ssaCs7+THR+U8be7WJoL9OmQjlJpzA+
         5Nqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679696475;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ynyRu9MXX0o1sLS2T/gIPwPvYYermXkBvLgDj6CJ3Qw=;
        b=rOeYvyFcrzqgkJHI66TUotWK+OxXlmeBZaHRa4KzQvE0wawPL6QScmzr8FUBlNSdMl
         fSzDk1wPk6VbfCBSHID6KBprTBRa7QfzHwb/8i43Yjz2Gsk8tO7JkL5LwEZIOI3A9iAX
         dwgffbn9vAZa+UJ9TomhumSQmfL/jwD5Hi3mwVdsZCkJOQ2kJxESLgQp06qPb8JtVaZJ
         ewMjqiDSBAQgyKFT7CsMeOZYh7SdoE2hJJvNRWInHNg3IQp7kpfv95pk0jbGnjq7PcfK
         yr0hzMsQh1w4jP+j0L+O8/eSxBsWYrDRwuY9mvIvr92UC2ChhenWPh46j/gtDsZSpWxT
         sPTQ==
X-Gm-Message-State: AAQBX9dwoYVN2Ntui4QDnj9iktPQIJnILMKMPPeTsTv0+AnbHybXxDIu
        b9CHsi07XTGQMLnSzZLz9oA=
X-Google-Smtp-Source: AKy350bEXMJVSAKXMuHeQWTYpxQ+wEiP9f1kQyIgtg7PZMati0/Mhsa0a8LLNj9agz9jmx14tKXFJQ==
X-Received: by 2002:a05:6214:406:b0:5aa:ad07:ea43 with SMTP id z6-20020a056214040600b005aaad07ea43mr7295413qvx.5.1679696475342;
        Fri, 24 Mar 2023 15:21:15 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id eh13-20020a056214186d00b005dd8b9345fasm997720qvb.146.2023.03.24.15.21.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Mar 2023 15:21:14 -0700 (PDT)
Message-ID: <4236cc30-86f6-803d-82dc-a340fbe89481@gmail.com>
Date:   Fri, 24 Mar 2023 15:21:07 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net v2 5/6] net: dsa: microchip: ksz8863_smi: fix bulk
 access
Content-Language: en-US
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, UNGLinuxDriver@microchip.com
References: <20230324080608.3428714-1-o.rempel@pengutronix.de>
 <20230324080608.3428714-6-o.rempel@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230324080608.3428714-6-o.rempel@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/24/23 01:06, Oleksij Rempel wrote:
> Current regmap bulk access is broken, resulting to wrong reads/writes
> if ksz_read64/ksz_write64 functions are used.
> Mostly this issue was visible by using ksz8_fdb_dump(), which returned
> corrupt MAC address.
> 
> The reason is that regmap was configured to have max_raw_read/write,
> even if ksz8863_mdio_read/write functions are able to handle unlimited
> read/write accesses. On ksz_read64 function we are using multiple 32bit
> accesses by incrementing each access by 1 instead of 4. Resulting buffer
> had 01234567.12345678 instead of 01234567.89abcdef.
> 
> We have multiple ways to fix it:
> - enable 4 byte alignment for 32bit accesses. Since the HW do not have
>    this requirement. It will break driver.
> - disable max_raw_* limit.
> 
> This patch is removing max_raw_* limit for regmap accesses in ksz8863_smi.
> 
> Fixes: 60a364760002 ("net: dsa: microchip: Add Microchip KSZ8863 SMI based driver support")
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

