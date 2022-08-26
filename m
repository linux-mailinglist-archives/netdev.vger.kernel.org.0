Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B13BA5A21F2
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 09:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245425AbiHZHbn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 03:31:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245427AbiHZHbY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 03:31:24 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24CE6D3997
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 00:31:03 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id ay39-20020a05600c1e2700b003a5503a80cfso353636wmb.2
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 00:31:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smile-fr.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=F1Ny7ZbIRlSuTEBgZvBnaqzuujGo21v2ioov9i9Cx6I=;
        b=brs2EIx6hdFVtG1sz247ozzbfyoRvVHbL51n1vwN9tR2Q8P8xnwHFnXTfX8uyFp78v
         9snQmCdQfn+QcJhHLKci8jUwfLBAa21khppz2Vc7BvbHSNjsi6dRdcvZ803muPVQIT4z
         Jyci78ZmLOyi5bBOpgpqH3UPQOewMv3hfoIDlsMTbATiBJcurIyL1j9GMdvznKMh06LA
         6XhCo4gcT9OUs4OdoolWmcD27dhAnczWRuqbfK6cQh0ZQKIMXvWs7mkuFWiT7BkPQOX1
         2ADZ/FBi0hT3FXA+NFX3fsdmOAvCObBIPWPkMDlK//43ACmhuOO0yWuUylysX7xivptr
         Xbag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=F1Ny7ZbIRlSuTEBgZvBnaqzuujGo21v2ioov9i9Cx6I=;
        b=sQNa9Nis3dRYJHLZ5GVi2E8aZGptMNrAtdNGry8JMmw8gCZsBdH4/W5+7DKBzOkSDr
         p+Cos3zCbSQEwUDY2CIRJE8ZEDBgg1K+Z3DIViWrX6/YPNWRg0Phr1IAnvb3gZ/a8TAF
         JLBb74SJ2QsVIPXBdOV8Z6xr8XkuijlNlM3YLMQWZ2XjVDvC8E72DhgGsbVhWW6/WgVv
         /iL0xHey+QE7c4K1HQO2xbQ+gPLIbvQFnyXlHpx9KxRBLK5IPGFvSOZFoe/NcT0OUHCN
         EPHGrsjeA9SFxesSaNS69i5xgvBtpTMou3WHHxK/fQ0zQKVt3ws3m9Sb2at6EFxuU9Yo
         C9cQ==
X-Gm-Message-State: ACgBeo3djoYVFJF9iJypOxyJ2XsAmk4eEIMl9JqWUgEynR+d4x0WSfMn
        Wcz1AJFTt47KP92MfRFvSt2TEg==
X-Google-Smtp-Source: AA6agR59Y12aOTJqZ17S8g11wFtSPixzlZq2f7zgpA3vxYsJBgnGeHEVJ/FEfElXrc99NHSg3WPQjA==
X-Received: by 2002:a7b:ce89:0:b0:3a5:cefe:80f6 with SMTP id q9-20020a7bce89000000b003a5cefe80f6mr10908190wmj.113.1661499061815;
        Fri, 26 Aug 2022 00:31:01 -0700 (PDT)
Received: from ?IPV6:2a01:cb05:8f8a:1800:1c97:b8d1:b477:d53f? (2a01cb058f8a18001c97b8d1b477d53f.ipv6.abo.wanadoo.fr. [2a01:cb05:8f8a:1800:1c97:b8d1:b477:d53f])
        by smtp.gmail.com with ESMTPSA id m28-20020a05600c3b1c00b003a5ea1cc63csm7917752wms.39.2022.08.26.00.31.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Aug 2022 00:31:01 -0700 (PDT)
Message-ID: <7e5ac683-130e-2a00-79c5-b5ec906d41d1@smile.fr>
Date:   Fri, 26 Aug 2022 09:31:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 1/2] net: dsa: microchip: add KSZ9896 switch support
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, arun.ramadoss@microchip.com,
        Romain Naour <romain.naour@skf.com>
References: <20220825213943.2342050-1-romain.naour@smile.fr>
 <Ywfx5ZpqQ3b1GMBn@lunn.ch>
From:   Romain Naour <romain.naour@smile.fr>
In-Reply-To: <Ywfx5ZpqQ3b1GMBn@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Le 26/08/2022 à 00:04, Andrew Lunn a écrit :
> On Thu, Aug 25, 2022 at 11:39:42PM +0200, Romain Naour wrote:
>> From: Romain Naour <romain.naour@skf.com>
>>
>> Add support for the KSZ9896 6-port Gigabit Ethernet Switch to the
>> ksz9477 driver.
>>
>> Although the KSZ9896 is already listed in the device tree binding
>> documentation since a1c0ed24fe9b (dt-bindings: net: dsa: document
>> additional Microchip KSZ9477 family switches) the chip id
>> (0x00989600) is not recognized by ksz_switch_detect() and rejected
>> by the driver.
>>
>> The KSZ9896 is similar to KSZ9897 but has only one configurable
>> MII/RMII/RGMII/GMII cpu port.
>>
>> Signed-off-by: Romain Naour <romain.naour@skf.com>
>> Signed-off-by: Romain Naour <romain.naour@smile.fr>
> 
> Two signed-off-by from the same person is unusual :-)

Indeed, but my customer (skf) asked me to use the skf.com address for the patch
but I use my smile.fr (my employer) git/email setup for mailing list.

> 
>> ---
>> It seems that the KSZ9896 support has been sent to the kernel netdev
>> mailing list a while ago but got lost after initial review:
>> https://www.spinics.net/lists/netdev/msg554771.html
> 
> I'm not sure saying it got lost is true. It looks more like the issues
> pointed out were never addressed.

It seems the initial KSZ9896 support was in the same patch with other changes
that were addressed later by followup patches.

> 
>> The initial testing with the ksz9896 was done on a 5.10 kernel
>> but due to recent changes in dsa microchip driver it was required
>> to rework this initial version for 6.0-rc2 kernel.
> 
> This looks sufficiently different that i don't think we need
> Tristram's Signed-off-by as well.
> 
> I don't know these chips well enough to do a detailed review.

Thanks for your feedback!

Best regards,
Romain


> 
>   Andrew

