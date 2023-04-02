Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBE3E6D38A1
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 16:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230488AbjDBO6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 10:58:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230462AbjDBO6F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 10:58:05 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31DD57692
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 07:58:04 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id m6-20020a05600c3b0600b003ee6e324b19so16633271wms.1
        for <netdev@vger.kernel.org>; Sun, 02 Apr 2023 07:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680447482;
        h=content-transfer-encoding:in-reply-to:subject:from:content-language
         :references:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nT6vXeP8IhxfrLCi1mP05zjfmLQkE9byHtEBHEJTF20=;
        b=qzBobAXQlh8t2P+vxdZ9iDzmdYT88tD5dLdD77VnI24FJu4JZtiZxiFsXbOd74m7bn
         XNZgxk5RsUoFszpEpfSREGhEbLhQiFV1wJGFesfYt9mU5qUoiV0wPmt1afhqI1TIhKa7
         5vA/3hMxJbDWB01luoq05maU56D8n8zGcnIGRZXipgxB/2NgqurPyKattnvYPRKTGWN1
         xAuEuLry4UYa2XHLJbCk+eGgvYzCqxiM6l5WC2ZliWlEq9u6RbUJh6MpkmnFBZyYN0Xv
         wmNP/ZAtKCwR1G3raAMgdDg8qFjvTx9uTQklkyEy58yjoSXQDavNP/sqt94GCQ0Abbwb
         pz4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680447482;
        h=content-transfer-encoding:in-reply-to:subject:from:content-language
         :references:cc:to:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nT6vXeP8IhxfrLCi1mP05zjfmLQkE9byHtEBHEJTF20=;
        b=7TZ9T72MjMycngSEeo9TKtvyEN2FTZvwDDOoWHziP1fAU7K4cdvhuimQAjZihQTpQi
         cH101B8fyAbxeP1hz/Qa4Rh6ECl6HIEtmu3l+pahT9SG99DQnh6rkDlXNvjdyx1jgRdD
         OBRHL3xsERz3q5noUanVCaebRFUWgNSXn3eLHuLsJLWLl14iK4EKgpEB/RMTUuTPWqGK
         45hBVBvvxTMoOQCj4ah0Jjxv7Mbc+zd+7mX28mR+6UEf6ccV69KlI610Q2CY5dM9k3Py
         Pe9FjmnaTHh3Qze/q1lvEyYsPruQdpYJouKAhqfLO1ArLB/I/dFubfxpgbdnv+8UMwVm
         DF0Q==
X-Gm-Message-State: AO0yUKXhUWvrtjIam+RBJWzMib/QOheTtqQ+QyyU3F3XUtGi63Okbp/i
        p/DOiU/VSMzRzMlLC/X+AR8=
X-Google-Smtp-Source: AK7set+7kZTzx/rCU1ZNd+7RvytOXOZ0G1IYl/tiZdUw2envFi4D5jvvCjg4a2q6aw4bXPdt6OtNkg==
X-Received: by 2002:a7b:c8c4:0:b0:3ed:b590:96e6 with SMTP id f4-20020a7bc8c4000000b003edb59096e6mr24417254wml.4.1680447482549;
        Sun, 02 Apr 2023 07:58:02 -0700 (PDT)
Received: from ?IPV6:2a01:c22:7b85:6800:129:5577:2076:7bf8? (dynamic-2a01-0c22-7b85-6800-0129-5577-2076-7bf8.c22.pool.telefonica.de. [2a01:c22:7b85:6800:129:5577:2076:7bf8])
        by smtp.googlemail.com with ESMTPSA id g20-20020a05600c4ed400b003ee8a1bc220sm16914284wmq.1.2023.04.02.07.58.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Apr 2023 07:58:01 -0700 (PDT)
Message-ID: <baa2f821-ddbc-3ce3-02d2-8d4d9e438fd1@gmail.com>
Date:   Sun, 2 Apr 2023 16:58:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Chris Healy <cphealy@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <17fcccf5-8d81-298e-0671-d543340da105@gmail.com>
 <ddab653a-c3f6-9b9f-2cac-ed98594849b5@gmail.com>
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next 0/7] net: phy: smsc: add support for edpd tunable
In-Reply-To: <ddab653a-c3f6-9b9f-2cac-ed98594849b5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02.04.2023 16:00, Florian Fainelli wrote:
> 
> 
> On 4/2/2023 2:43 AM, Heiner Kallweit wrote:
>> This adds support for the EDPD PHY tunable.
>> Per default EDPD is disabled in interrupt mode, the tunable can be used
>> to override this, e.g. if the link partner doesn't use EDPD.
>> The interval to check for energy can be chosen between 1000ms and
>> 2000ms. Note that this value consists of the 1000ms phylib interval
>> for state machine runs plus the time to wait for energy being detected.
> 
> AFAIR Chris Healy was trying to get something similar done, maybe you can CC him on the next version?

Actually this is based on a conversation between him and me. Chris came up
with a first version and I reworked it from scratch to meet mainline standards
and make it usable on SMSC and Amlogic PHY's.

