Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 987EC63CB15
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 23:33:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235867AbiK2WdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 17:33:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235589AbiK2WdN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 17:33:13 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 252A32CDDC
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 14:33:13 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id bj12so37169046ejb.13
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 14:33:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=l5qA3qKZdKHiw5/o182jJcQJWLvxKSz08LW+4woYnrk=;
        b=lqu0glwqyZlvFMaKyTg9gOzC3iwa0CGXtTFNGHDUYF913b79OmARxNdB5gO+ODdV+I
         D7KULC1tY4RjHxV5Xnh+PLI95sQaoS3Fz0hngrncbOQwVjKAxHJ+adfukbfsgl1oXi87
         gG5JtuP0brHGZBzJ9z37BJfq+649L1bOqmhtaaaSRM0t3NQMBaloSbGa6KcWPLiHwKO9
         IDgDWy6K2rRMnbHXmfPbCYAtGd/bD2ubo3WtuVd6h8ExXLGErKVP3SPwIjDh62d6gXlH
         nR60YzW26nVOMxdQr4vXuz3zWC7kRyg7A9eQ/5REEfh8U39qtjO0VB0APr5TfiVb79Me
         ZTvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l5qA3qKZdKHiw5/o182jJcQJWLvxKSz08LW+4woYnrk=;
        b=t5zrGmIAJFrklP5OjIu7vAlyfkg6ycminq1rhDBePT4LKG7HDrSjacqmCTCp+qUVgC
         SK4gxKYhFDPADhorAz++kfO6kFyVV6dcRJHd8HO6SDs/xTNfON/RJ84J5bKxrD+PsOg8
         D4HeU+hlhQ7CHRTibkOFJNK81/FPr5Qh4e9yb3ELvrJZNAyHBTD2UKuRNX8o6N7BVunV
         nhVIPX5Vvyoreo2G21rji9mt8R6bNJrXYEMTQtG0Jvy0xXdXNjIimUBi2xlrkIaXpb08
         gotafYQI7AaOG7cnTXYgGO1hKNJDyna4bAKcknWn3nbI5ChYfsGXRKA1B8TZO0d1LQ6N
         cbcQ==
X-Gm-Message-State: ANoB5pnGjymUODcb1ejeK+Q1pqyH9Z4dRG6nV9MjX5raflAmV04Q/KBE
        jJuBZ/pj4cr/yv01vNYpbx8=
X-Google-Smtp-Source: AA0mqf4VvS3QsdW202P/rBfaosH5rgMQcLZtrsNY/H0BYa1FSDuxiuf1YEtvAgepGOJEOeQMroPckA==
X-Received: by 2002:a17:907:9842:b0:7b9:9492:b3f4 with SMTP id jj2-20020a170907984200b007b99492b3f4mr28540814ejc.688.1669761191533;
        Tue, 29 Nov 2022 14:33:11 -0800 (PST)
Received: from ?IPV6:2a01:c22:6ef3:1400:6d2d:6394:6df6:11fc? (dynamic-2a01-0c22-6ef3-1400-6d2d-6394-6df6-11fc.c22.pool.telefonica.de. [2a01:c22:6ef3:1400:6d2d:6394:6df6:11fc])
        by smtp.googlemail.com with ESMTPSA id qq18-20020a17090720d200b0073ae9ba9ba8sm6577811ejb.3.2022.11.29.14.33.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Nov 2022 14:33:11 -0800 (PST)
Message-ID: <17e16424-a46c-f39b-2368-bc0c13e3cb6e@gmail.com>
Date:   Tue, 29 Nov 2022 23:33:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH, net-next] r8169: use tp_to_dev instead of open code
Content-Language: en-US
To:     Juhee Kang <claudiajkang@gmail.com>, nic_swsd@realtek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
References: <20221129161244.5356-1-claudiajkang@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <20221129161244.5356-1-claudiajkang@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29.11.2022 17:12, Juhee Kang wrote:
> The open code is defined as a helper function(tp_to_dev) on r8169_main.c,
> which the open code is &tp->pci_dev->dev. The helper function was added
> in commit 1e1205b7d3e9 ("r8169: add helper tp_to_dev"). And then later,
> commit f1e911d5d0df ("r8169: add basic phylib support") added
> r8169_phylink_handler function but it didn't use the helper function.
> Thus, tp_to_dev() replaces the open code. This patch doesn't change logic.
> 
> Signed-off-by: Juhee Kang <claudiajkang@gmail.com>

Doesn't hurt and helper is used more than once in this function.

Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>

