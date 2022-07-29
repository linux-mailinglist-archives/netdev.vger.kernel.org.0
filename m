Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6C5585697
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 23:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239415AbiG2VlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 17:41:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239420AbiG2VlD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 17:41:03 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E24B88C141;
        Fri, 29 Jul 2022 14:41:02 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id v16-20020a17090abb9000b001f25244c65dso9565086pjr.2;
        Fri, 29 Jul 2022 14:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=HconYR7gXzKNW0NGZdccpjqA20J5UJ9Ha5U0bOT92HM=;
        b=NDbEqVS48y0vsMkOwn6kE71XtgHcoMLUoVVZbhRq21MLlA/7gB0u9ijVbJpQak0wDS
         bXip+Ge8G0+qKUbARosndDI8BCWYIPDBlSwkY9cnMeh5+chCVzCls4AgVsLTLP1stLnx
         bTj3ZVJMm5Vo8TJ+A8wahLJId0GkQ9058uKppZZXclJY0k3FWM/u0btao//xEGmYfHci
         QH9f72AQ/6Ep5NXLceEzkuyxeMLUaQuuP68li5dKsxeBGQea4eNX5Y6mX7bti+X+dg/J
         4ubgh492NuQPMz8rufzlYpBQrJ9hPKGZXzqC70YLCyrNN/AfNtiecQe16YRXrb1Sjdss
         PL3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=HconYR7gXzKNW0NGZdccpjqA20J5UJ9Ha5U0bOT92HM=;
        b=RZjdSpF4IRsaoqAGo7yiZEWwImpiAmaI3wXPYiqKhhd9vKnxIIH+SS2y2JfWw4crMe
         HV2BSUCvSo8DwvoSGUO0AQ1TfQHfyNulJPDAebKcLfGcxztk3Bx8AEObdny/nAKHRVr9
         tOI875b2aNVcG+xv2b+sfCHiz0xpoNKO4sV57CFsbohoSNsafMZCHlnLSXFjY/koJOfJ
         QO6MDtqS0M1fj01kKoPktKfEge+C8Lt/3aMEp52g9ldpACtNKlRnI91HgoB1JlDAVpK3
         dUyZ6HZOazXl7Fy8zLzV3duoGAgdI3wMS7YpjX3+6D4mm89pSbf3MewwKqfzxm53y0ND
         oMKg==
X-Gm-Message-State: ACgBeo0AQlfPurO2ZQs2+Sm/UjbcZed0L3vZ1nKa++cCBzFkCo9vTieo
        YTvh1HoVdFhgPm/gvucPj/s=
X-Google-Smtp-Source: AA6agR604y0ZWqD790Z4firwXv9nAs1LKMuQP/tLa6FHvvwHCTJucF256z13LMiN2/+VOHqG9IjpvA==
X-Received: by 2002:a17:90b:3ec4:b0:1f0:5aab:48d6 with SMTP id rm4-20020a17090b3ec400b001f05aab48d6mr6194593pjb.123.1659130862339;
        Fri, 29 Jul 2022 14:41:02 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id l2-20020a656802000000b00415e47f82e7sm2986166pgt.60.2022.07.29.14.40.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Jul 2022 14:41:01 -0700 (PDT)
Message-ID: <aef16109-9c21-67b3-3b29-8954eeb8a046@gmail.com>
Date:   Fri, 29 Jul 2022 14:40:55 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [net-next PATCH v5 11/14] net: dsa: qca8k: move port mirror
 functions to common code
Content-Language: en-US
To:     Christian Marangi <ansuelsmth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20220727113523.19742-1-ansuelsmth@gmail.com>
 <20220727113523.19742-12-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220727113523.19742-12-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/27/22 04:35, Christian Marangi wrote:
> The same port mirror functions are used by drivers based on qca8k family
> switch. Move them to common code to make them accessible also by other
> drivers.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
