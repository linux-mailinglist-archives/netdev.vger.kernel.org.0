Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A02125AF63B
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 22:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231156AbiIFUix (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 16:38:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231191AbiIFUiu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 16:38:50 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08D4C89914;
        Tue,  6 Sep 2022 13:38:50 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id w28so8995585qtc.7;
        Tue, 06 Sep 2022 13:38:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=h237n7/UKMUwrtK2SdW8VgK2awMEb5gtKYbegstNBYY=;
        b=C9Ss8byNwMFLSuiFD4ppV8owA9/4wkUTBP/U9WKwcHSUI4M6aleZ6JI47wDpnkXwvP
         sZOiL5B8tm854nQMBnoWx0QFNoZAC40OYRWf3oCu0hnqVdbYj86/gybzpnL3oBIPPAZh
         B53R+G9LFexSWJa8KlhN098kxoLc/uAlOUrSWZ8IgB4ORIpBlIj3V7ZDsxkySiy77FAo
         jF809Cgn/tHn57YHP3b+oVVszQzoN3sVs4fU6e/0EylbBuZTDwcFJsF0CpFHEx6YUo5m
         DCDD2ERnMUeNyjy99d2P8UijGtKO5WqpGOcppPHDPOBaSMIdO1jnJGIW2VRCtez5JZ5f
         764w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=h237n7/UKMUwrtK2SdW8VgK2awMEb5gtKYbegstNBYY=;
        b=QUrElzvllE6YXinZqG0/iSpsWNGNti57P4Z2IySnBU4mAdRBIr5d6yKRNwdonoriV2
         67V+9Q+ds4cMI5HTF2+iUvrAF69eOrD6LbRFoG0v/Ek602tL2m5rTbJ7rOpaJtvAQHI7
         dXY8SQ0iaPM5txMiLiwqD2A9RA7LoNthl1evT7EdXMOLj+cYuPnSVqtbK5N9Lo8XuTVL
         kihcHK3qRQ/+r3sviF7dWOV/HfWtm5QOSn3gcohJbDqcokL1GAUMeidBiKbjKQU0ntfx
         g1aKvsCV+tnmj55KvCq/0hvLgw2ao20CgPmn4H2u0S917egA5gw2iboBN5EeI6uEEc9V
         Pd+g==
X-Gm-Message-State: ACgBeo2jEm0MxYJqFMjmlhBu9mByaYI5AKkNsMyn9uRnXAvIVFz+NiBO
        VbrORzvGx99JX2S9GWXi0W4=
X-Google-Smtp-Source: AA6agR7jUYM/thCW3aozvylNyqUlO54iIfwG+TJITPxh00AjybJsEh/bVfCV5cWcRER/xBmwVBiXKw==
X-Received: by 2002:ac8:5907:0:b0:344:e61b:8c0e with SMTP id 7-20020ac85907000000b00344e61b8c0emr335730qty.349.1662496729120;
        Tue, 06 Sep 2022 13:38:49 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id 137-20020a37078f000000b006be68f9bdddsm11617656qkh.133.2022.09.06.13.38.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Sep 2022 13:38:46 -0700 (PDT)
Message-ID: <a475ec3e-a1ce-c81c-5d80-8254e9b62068@gmail.com>
Date:   Tue, 6 Sep 2022 13:38:42 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH v3 05/11] leds: bcm6358: Get rid of custom
 led_init_default_state_get()
Content-Language: en-US
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Gene Chen <gene_chen@richtek.com>,
        Andrew Jeffery <andrew@aj.id.au>, linux-leds@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Pavel Machek <pavel@ucw.cz>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Lee Jones <lee@kernel.org>
References: <20220906135004.14885-1-andriy.shevchenko@linux.intel.com>
 <20220906135004.14885-6-andriy.shevchenko@linux.intel.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220906135004.14885-6-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/6/2022 6:49 AM, Andy Shevchenko wrote:
> LED core provides a helper to parse default state from firmware node.
> Use it instead of custom implementation.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
