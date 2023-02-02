Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4181A6875DE
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 07:30:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbjBBGah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 01:30:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbjBBGah (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 01:30:37 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF0D37B79D
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 22:30:35 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id mc11so3041918ejb.10
        for <netdev@vger.kernel.org>; Wed, 01 Feb 2023 22:30:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u7OUPmdoqA1ASCnvnJ+g3jZcLGp6QAX2wOvHgASoNp8=;
        b=SJu+4O67I8IzdqGR/k70QEVg1ppY2PLAeCKF1u1QjecAXjO6C1+Edd+7H0ftqH+m3X
         sM6BxZnsdU/wk5xMIDTGcQQdPxgs/xGJryfZLngglaLcwyMRPc80C2YtBSv8iihRy4E9
         XRqNV3s+WWzW9JmfyLwMPsrczzJV+BBfkHBD9dBHrVTIvCLzkiVUi9x3NrYYFvliQUMd
         9e+CcDY9TMjlXLqP8M4ARd3Ii0FUdCfgqCVvaNm0VENndwE1tn3CvYslJbw5Y5Hu6e5e
         m37Gh1o7iBHMKgEQhglhwv4PU8rymI8PVEQnLcJ0+R/FKiOM6NkNsxNagjq8YDoyiclW
         kZEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u7OUPmdoqA1ASCnvnJ+g3jZcLGp6QAX2wOvHgASoNp8=;
        b=KzuExXw6F0XNK0HdSYb3HgL0ODosliXWIz+uUerfzfnwqXQR5WFriGRiO35ql93/3t
         xx9VrGsbi/XVJKfO2CnJV8sSF1eUULIk6uH+tWfUyn58FNjYMQjYQUkVn7r2p+VyyWPG
         IiJD1SIOsB55WEN+mdTENdL9JnoF0Duf9n0EtfYYDFN6AaKtCQtsVNE7qjOwaj/bPDnA
         sG6N/nG5tJ6P7Wn/28B9aoIDRPO7BnASTOfuUteXGG/RGLJZrQga6oAIdpmkJgypsZxV
         0afODVCMj56GFe66jJ1fBjId0L1/tvjt068vkIN449XyiSjn41ze26elRQ79LlqNVx/E
         LYeg==
X-Gm-Message-State: AO0yUKV9VGqTbb32h7O7U8nre4hkGpAnTL4odwBu5OBzPXGiLVoLP9yw
        8BGVcoORvnotbCcjeKqG7ZQ=
X-Google-Smtp-Source: AK7set/MiWq+DtZO9IGSh7aIOfdhElWixdyc3uLY7ShbgoecBI3Youodd+N8teK+EB3axH7Pyj/isQ==
X-Received: by 2002:a17:906:6d42:b0:887:d2a6:cc54 with SMTP id a2-20020a1709066d4200b00887d2a6cc54mr4844036ejt.30.1675319434194;
        Wed, 01 Feb 2023 22:30:34 -0800 (PST)
Received: from ?IPV6:2a01:c23:c579:1b00:2187:237e:ee8:4c17? (dynamic-2a01-0c23-c579-1b00-2187-237e-0ee8-4c17.c23.pool.telefonica.de. [2a01:c23:c579:1b00:2187:237e:ee8:4c17])
        by smtp.googlemail.com with ESMTPSA id q6-20020a1709064cc600b0084d494b24dcsm11072771ejt.161.2023.02.01.22.30.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Feb 2023 22:30:33 -0800 (PST)
Message-ID: <83e1e852-303b-2460-9034-ce1f91445f47@gmail.com>
Date:   Thu, 2 Feb 2023 07:30:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, Kevin Hao <haokexin@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>,
        Chris Healy <cphealy@gmail.com>
References: <23ecd290-56fb-699a-8722-f405b723b763@gmail.com>
 <20230131215528.7a791a54@kernel.org> <Y9pfBpoZ4cezf6Bb@pek-khao-d2>
 <20230201210754.143357c5@kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net] net: phy: meson-gxl: use MMD access dummy stubs for
 GXL, internal PHY
In-Reply-To: <20230201210754.143357c5@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02.02.2023 06:07, Jakub Kicinski wrote:
> On Wed, 1 Feb 2023 20:45:58 +0800 Kevin Hao wrote:
>> The "Fixes" tag is used to specify the commit causing regression
>> instead of patch prerequisite.
> 
> Indeed, what's the tag for the commit where the problem can be first
> observed? All the way back to:
> 
> Fixes: 7334b3e47aee ("net: phy: Add Meson GXL Internal PHY driver")
> 
> ?

The issue popped up with:
d853d145ea3e ("net: phy: add an option to disable EEE advertisement")

This commit added MMD register access to the generic configuration
path in phylib.

