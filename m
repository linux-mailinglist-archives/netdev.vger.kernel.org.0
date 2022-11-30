Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2E363E364
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 23:25:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbiK3WZb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 17:25:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiK3WZa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 17:25:30 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99FD44EC33
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 14:25:29 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id p13-20020a05600c468d00b003cf8859ed1bso108755wmo.1
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 14:25:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:subject:content-language:cc:to:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rzTletLMNp8H02Wes+2HUtaiF4IywhCDuyHbJJicyZc=;
        b=bM0u+m/GgEhVRVku4A5OgQINBLRpiwQw9hZCrIDBzwXcMKTb2E8cn0A7yVW5+GYvz8
         y3gdfUA42UcAh40si+fdBzLOzvJsFxTG5+/Og9YdC7eUV7q9hzgvjpW/nkWttipvAIwq
         5/4L+TsJSAkoeTOvR1BhE3Mi93GLPknJU0tfcm4gQlmNEbTD6Suo2pv6H4CoFrEG48co
         lB2hAWlkNy8WDFuY+7dWV/I1AduIOBwsdga5v/qASd9vKWBRsB5Ano3qaCHtpUAEidHQ
         0ts3Zk+gOgBDQHSdERpaTLMFrYbO9BP5Ejn+hAkIVNZ1fmm0sRbmNFsi+L5DolrWckpQ
         ibgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:content-language:cc:to:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=rzTletLMNp8H02Wes+2HUtaiF4IywhCDuyHbJJicyZc=;
        b=tzlsbDAnwkLxfxG2FmERgqvLiAAvWFM8cI5Z0catUTpadSu6giwr/Dk0DBpWWMDC+D
         T4bx+7h0JomhE/RhaS5xbG3YtDclgLfauR5K7JE84ac6BUNIDQ3ttc+wYjWAgXQqgZ65
         fpyhq+Y2fdntRY5UkpGzUeNNbaUVu9WAs7lBR6OXTibBQhx2wa7XTJcawF9/etbA4wSb
         LNKUY6g/5e9rmPengK0yShpSkAxlgLcdWuCufahYaMLp7ZhRi6jnl1MqVH7LGXOI2TKS
         FYKWWl/rLU3VG5ZaLr1vhtM73wRUkiBuIvGot+6FIA54YjYLzsCTMi6F8VM6NSMPqvVF
         yUVw==
X-Gm-Message-State: ANoB5pkVrnmlT69EVaVUqm0njV7tBlgNSLGunFVvcfojMkjkUhe7XjI7
        C9hGjYNwJG/V1LILr05xCj8=
X-Google-Smtp-Source: AA0mqf68W31S+wXsoQTDvGeXtuXRjOZgTXsKVlWKqBq25MMwRzydSDs14w7AFZdC4hpQTW0qCYAI2g==
X-Received: by 2002:a05:600c:5552:b0:3cf:9a16:456d with SMTP id iz18-20020a05600c555200b003cf9a16456dmr47786339wmb.100.1669847127947;
        Wed, 30 Nov 2022 14:25:27 -0800 (PST)
Received: from ?IPV6:2a01:c22:77d6:e700:1465:fbc6:a2a6:9b65? (dynamic-2a01-0c22-77d6-e700-1465-fbc6-a2a6-9b65.c22.pool.telefonica.de. [2a01:c22:77d6:e700:1465:fbc6:a2a6:9b65])
        by smtp.googlemail.com with ESMTPSA id t5-20020a5d5345000000b0022cc3e67fc5sm2659370wrv.65.2022.11.30.14.25.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Nov 2022 14:25:27 -0800 (PST)
Message-ID: <e4d1cc88-2064-caa0-c786-41f8720869a4@gmail.com>
Date:   Wed, 30 Nov 2022 23:25:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Language: en-US
Subject: [PATCH net-next 0/2] net: add and use
 netdev_sw_irq_coalesce_default_on()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are reports about r8169 not reaching full line speed on certain
systems (e.g. SBC's) with a 2.5Gbps link.
There was a time when hardware interrupt coalescing was enabled per
default, but this was changed due to ASPM-related issues on few systems.

Meanwhile we have sysfs attributes for controlling kind of
"software interrupt coalescing" on the GRO level. However most distros
and users don't know about it. So lets set a conservative default for
both involved parameters. Users can still override the defaults via
sysfs. Don't enable these settings on the fast ethernet chip versions,
they are slow enough.

Even with these conservative setting interrupt load on my 1Gbps test
system reduced significantly.

Follow Jakub's suggestion and put this functionality into net core
so that other MAC drivers can reuse it.

Heiner Kallweit (2):
  net: add netdev_sw_irq_coalesce_default_on()
  r8169: enable GRO software interrupt coalescing per default

 drivers/net/ethernet/realtek/r8169_main.c |  2 ++
 include/linux/netdevice.h                 |  1 +
 net/core/dev.c                            | 16 ++++++++++++++++
 3 files changed, 19 insertions(+)

-- 
2.38.1

