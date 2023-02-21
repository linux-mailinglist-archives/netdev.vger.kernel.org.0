Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 955AF69DCFC
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 10:36:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233517AbjBUJgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 04:36:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233470AbjBUJgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 04:36:19 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFDB12331E
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 01:36:16 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id l1so3399736wry.10
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 01:36:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dds5HiLKMBVe7Ep5tNtGYU3whd8yBZ5RH5cDpMj6vqs=;
        b=if8SlNFD/EtZVus+PYpb75pwAl+81P2PeROVsbm5/bMhYeJyFAe71cvyUBY3wwjD0z
         ZIlQohT+/tmAQ7NB3T398+HijW6oXlUf47OG+vi2ThDqKws7hJXK76iaIKU81GsdaVWN
         plrr+eN+SYdAxJJSMn77HzS0kJW8KkBReGDTifeQCgcGzjw8W9Cp9P0JusG+yLNreZaL
         ThXtsaBsAbO6SLJUUNH2uTQBteQJWEC4jhFUPh3YkNxmXpWh1lHNJ2OIut1qvV+vUU3h
         JEVypwbZP2qJsNoRZ24SzayInpZcJjFsrmpNB+Kk9rai6XhrMehx5yKV3EU8eORS8NQr
         nBgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dds5HiLKMBVe7Ep5tNtGYU3whd8yBZ5RH5cDpMj6vqs=;
        b=EfNRxdEPIygXwOMyLlWMXfaQAzg6CnCn6dhbeLBXeFunQjGmNHZ4hPH4p/sE7Grc/+
         HK7n3g4GGTCSxl9lTrCta6RK31opDKRc2SvIx1wxNWMWrrKnwxWqiYA7EeOgbngI/nFK
         NHi/DigY5FNeA2CjiTdUQ0kdndR+iGO3xRParKBnYqBN7bbMn58Z/Fgz8lcIlSxdzw8S
         +WQ1bKPIXmVjisPuYeGbct6yekV64JKDrMzM5ZzgrJLW0Fi2pqBQhToS4OVdh3w532gL
         aT+C5Z/8d/wYry+T4Hu+rA8H+b9ZyOjDBlMQ4fLSnTKmosM9o+9DNj43KjxcsgeQSPAV
         U1JA==
X-Gm-Message-State: AO0yUKVKzr5SeHYmLEZfzNistMTIMoqFauy7+/O4gN0IO9acsuDEGQoi
        1+ioj9Dzhy7TlxaAByyI2Ums2MVjG/Kon7wY
X-Google-Smtp-Source: AK7set8FMlbb/yCgkkkUYSUjJZwT7S9glGIqee3xZCvrRQtKK1wFa3JVtTD45HbO0AvFxpwV3hvmTQ==
X-Received: by 2002:adf:f203:0:b0:2c5:57d5:ef6e with SMTP id p3-20020adff203000000b002c557d5ef6emr5296175wro.46.1676972175309;
        Tue, 21 Feb 2023 01:36:15 -0800 (PST)
Received: from ?IPV6:2a02:578:8593:1200:375a:6534:5196:866e? ([2a02:578:8593:1200:375a:6534:5196:866e])
        by smtp.gmail.com with ESMTPSA id z12-20020a5d440c000000b002c707785da4sm17215wrq.107.2023.02.21.01.36.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Feb 2023 01:36:15 -0800 (PST)
Message-ID: <8b635689-8436-e53e-09e0-770a9b79b8ea@tessares.net>
Date:   Tue, 21 Feb 2023 10:36:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [ANNOUNCE] iproute2 6.2 release
Content-Language: en-GB
To:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
References: <20230220105811.674bd304@hermes.local>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
In-Reply-To: <20230220105811.674bd304@hermes.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stephen,

On 20/02/2023 19:58, Stephen Hemminger wrote:
> This is the release of iproute2 corresponding to the 6.2 kernel.
> Like the kernel, not a sexy release just a regular pedestrian update.
> Moof the changes are in the devlink command.

Thank you for this new release and for maintaining this project!

> Download:
>     https://www.kernel.org/pub/linux/utils/net/iproute2/iproute2-6.2.tar.gz

It looks like the file name is wrong, ".0" is missing:


https://www.kernel.org/pub/linux/utils/net/iproute2/iproute2-6.2.0.tar.gz

Also, do you mind pushing a new (git) tag for this v6.2.0 version
please? I don't see it there:

      https://git.kernel.org/pub/scm/network/iproute2/iproute2.git

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
