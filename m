Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 209E068F743
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 19:41:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbjBHSk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 13:40:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231377AbjBHSkg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 13:40:36 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F8F0DBCD
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 10:40:35 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id q9so13274624pgq.5
        for <netdev@vger.kernel.org>; Wed, 08 Feb 2023 10:40:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=W2AALq91N8pnKXqSYSOtessxM8hcirn3S6d4ltMah90=;
        b=qnMQvYy8HdMtbpWPp1wlGLoPK2uVQcI7DXfK9ymiWDFAYV9rwOuqYIaGe4lQ5LHO3e
         n3D24UMCv9ZSrHF51DRyse3lBKpf0xbzkBjeHORKtBLqt42ynXXWeXVQ9kDhU7f9ydNJ
         2xkgYfMvve66igLY/YNqjUrgtraRnRcOn70KE/h0RbCakD8ZlysyGazd2n1VGMuX6doz
         rAti4L26c/0sm9x57h6Q6TQLYrIKR0N+1ey9Bbx6GtmZfK6wJVr4OrXzd/niShMkIh4P
         3Iz1n02FxoNC3LsNWZNOFvtaHoX8H0FfGM3dOz8tE3wW10gt/eUr0Jwbq/KMCDQ9t1QX
         rmhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W2AALq91N8pnKXqSYSOtessxM8hcirn3S6d4ltMah90=;
        b=aVOVIFg/59TAoqSBw7i+fYOIVSAJb0ggsN0xE8ATqQHVt2ls1k07kNJ4FfQump2+mp
         tNvsu8dpfbePb/Jjdl3cEqMswBWTqoKPxM8PHHvFgkDsxhavMJvGgkV2ECeJ+Um89N6t
         8w6jrorpbVxGbT35R3hiFb6hX2dC9Oucb0txF4KALoU6m9VpnxS2A4XT3SUgvm7I897A
         xh6hcsRpFQWf3sY4/yOWu5geqhmgtM4/HXXxbXBKOF94G/76ilqYosP7YbFCc+h/i8Jt
         9j7o/73OoJPwEpbDbGYDhdJvEHXsFfSe5AZN7iwpUIQI9oZKgQZ11POm+ZgNvJ5bWfD7
         SEkw==
X-Gm-Message-State: AO0yUKU6B/LNg13COMUQIGqpGTVG7z878lZb4hJzY7hcFqtL66jWkMix
        R7x4gNTlB7yyoNijLQXJ3v/OquTuycfxVQ==
X-Google-Smtp-Source: AK7set8mmZVSqtsCXXcrlTXvoJG3AyDUPi1KvhzJG4OlXqaaRPyAvH6AzrPSDxmO5tl4LmJDCV7IoQ==
X-Received: by 2002:aa7:9e10:0:b0:5a8:49c8:8533 with SMTP id y16-20020aa79e10000000b005a849c88533mr2223338pfq.8.1675881635044;
        Wed, 08 Feb 2023 10:40:35 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id v26-20020aa7809a000000b005a8173829d5sm2313824pff.66.2023.02.08.10.40.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Feb 2023 10:40:34 -0800 (PST)
Message-ID: <03ba5b04-fcdc-8eba-5d7b-b1739965d0a8@gmail.com>
Date:   Wed, 8 Feb 2023 10:40:31 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net] net: bgmac: fix BCM5358 support by setting correct
 flags
Content-Language: en-US
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        bcm-kernel-feedback-list@broadcom.com
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Jon Mason <jdmason@kudzu.us>
References: <20230208091637.16291-1-zajec5@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230208091637.16291-1-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/8/23 01:16, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> Code blocks handling BCMA_CHIP_ID_BCM5357 and BCMA_CHIP_ID_BCM53572 were
> incorrectly unified. Chip package values are not unique and cannot be
> checked independently. They are meaningful only in a context of a given
> chip.
> 
> Packages BCM5358 and BCM47188 share the same value but then belong to
> different chips. Code unification resulted in treating BCM5358 as
> BCM47188 and broke its initialization.
> 
> Link: https://github.com/openwrt/openwrt/issues/8278
> Fixes: cb1b0f90acfe ("net: ethernet: bgmac: unify code of the same family")
> Cc: Jon Mason <jdmason@kudzu.us>
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

