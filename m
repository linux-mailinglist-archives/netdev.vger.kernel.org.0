Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7F7666B2CA
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 18:09:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbjAORJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 12:09:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230501AbjAORJb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 12:09:31 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B725EC6F
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 09:09:29 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id bk16so25408357wrb.11
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 09:09:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w4GbAtoP62CKRZQ5YvzhQGV21nLCzrKZf6UMHAQ7R6c=;
        b=Qs0TzHwISeaa+WuDsKBjv50JXQ0sW2dd7xFzal9LKEP2JauK10Flyvnok32oDzL7eE
         EMAOjheyxs3J1B4yjrWrIjpNnyU9LE23jrKirfgpc5YP4Shs4ziYRL+gKFckJ+Tc+HtE
         x/Xz3d68nEBza5/h6JcxIBhaEVfVKqIodGC5OLY+Y9U7Zu+jkJX5T31RQtdxXnfGHjbZ
         ksS9jbmSSP1G9EKDLvJ3p0CxFgvST/a/ALE7YV1c2YZP0ftSI2EccL77Y6l3H019nJ//
         HKsseal/G97fdOhlV3BegoyW0KK7qjGjmD3262SmDtXKL5UYndU9nhR1bZn18CYrJEEo
         w2Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w4GbAtoP62CKRZQ5YvzhQGV21nLCzrKZf6UMHAQ7R6c=;
        b=mJDOyE9BL9guyia5Ajd+0WtO9cB2BHWPreE5JmxD/oGN6TOeTrN24ym8GikY90El+h
         wWwLfBxl/lzeuplfq3YAnN81WSEp7Rz1IjibmX8uPt2WEhJ9TFtjSqMQQYKos1rHeqqs
         kCUuI3VdKZ4AApgTcJbA5iUPX5+llUhhyx1ja/j9fI62ZANiZlIKwLeKr0cxk2MarGvr
         c3Z7r1Ulu//LKWMlEJyz8AMSxAxW8LTbl0DJGraygg9ejt/JQ2SK4pt7UoqpE6hMNhjn
         XWeyTFl+9Pkq0MUjrz8BTa6RksVXf/0wNkuESfWH5bzCdcgqByir3u5K4q4klWXVQrqO
         bzHA==
X-Gm-Message-State: AFqh2ko7LW3wJ9NyROces8udrEwzxDiC6iMJlmONhyDUsP/50DAJj9lh
        QPtK6RU831pfI9P9npnYe4E=
X-Google-Smtp-Source: AMrXdXs7vx3SPHsW1PelQFTJn9+Sy2O6IpmYQHTlnDdC0LBH10nr5JVcbl4fGABESGPY8w+pE3omkw==
X-Received: by 2002:a05:6000:1e08:b0:2bb:6c04:4598 with SMTP id bj8-20020a0560001e0800b002bb6c044598mr23683323wrb.67.1673802568012;
        Sun, 15 Jan 2023 09:09:28 -0800 (PST)
Received: from ?IPV6:2a01:c22:6e61:8c00:154f:326e:8d45:8ce7? (dynamic-2a01-0c22-6e61-8c00-154f-326e-8d45-8ce7.c22.pool.telefonica.de. [2a01:c22:6e61:8c00:154f:326e:8d45:8ce7])
        by smtp.googlemail.com with ESMTPSA id b16-20020adff910000000b002bdf8dd6a8bsm2172869wrr.80.2023.01.15.09.09.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Jan 2023 09:09:27 -0800 (PST)
Message-ID: <03ea260e-f03c-d9d7-6f5f-ff72836f5739@gmail.com>
Date:   Sun, 15 Jan 2023 18:09:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>
References: <d75ef7df-a645-7fdd-491a-f89f70dbea01@gmail.com>
 <Y8Qwk5H8Yd7qiN0j@lunn.ch>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next] net: phy: meson-gxl: support more G12A-internal
 PHY versions
In-Reply-To: <Y8Qwk5H8Yd7qiN0j@lunn.ch>
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

On 15.01.2023 17:57, Andrew Lunn wrote:
> On Sun, Jan 15, 2023 at 04:19:37PM +0100, Heiner Kallweit wrote:
>> On my SC2-based system the genphy driver was used because the PHY
>> identifies as 0x01803300. It works normal with the meson g12a
>> driver after this change.
>> Switch to PHY_ID_MATCH_MODEL to cover the different sub-versions.
> 
> Hi Heiner
> 
> Are there any datasheets for these devices? Anything which documents
> the lower nibble really is a revision?
> 
> I'm just trying to avoid future problems where we find it is actually
> a different PHY, needs its own MATCH_EXACT entry, and then we find we
> break devices using 0x01803302 which we had no idea exists, but got
> covered by this change.
> 
The SC2 platform inherited a lot from G12A, therefore it's plausible
that it's the same PHY. Also the vendor driver for SC2 gives a hint
as it has the following compatible for the PHY:

compatible = "ethernet-phy-id0180.3301", "ethernet-phy-ieee802.3-c22";

But you're right, I can't say for sure as I don't have the datasheets.

> 	Andrew

Heiner
