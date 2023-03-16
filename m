Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 646FE6BD9DA
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 21:08:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbjCPUIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 16:08:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbjCPUIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 16:08:04 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E85CA5699;
        Thu, 16 Mar 2023 13:07:48 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id a2so3022854plm.4;
        Thu, 16 Mar 2023 13:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678997268;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XgaE34WlFKyvwNRyoN2A9AopcNRZkWUVLIwBf1qOyzo=;
        b=GDMLtLDfcK1D5wlRjBW7lxMaMjp0Z6N90Yh9wSaccCGXqL4TEHCO8BxgBcs6IK39DA
         hrSn/p6csHUSsaxWy5Li6ZQndmGrfTsbeb35f8p7PmcAaF9p18cV+U6EGQBHEvJc0W1V
         bqanY/yOnubREhnm9M8HU5N42GYV3gW6vtL7rr4ihMiCR8bCAWPVvoDTxFAphE0UBR4A
         uYbsaw5xLwRFfa5FPfm0woLXgS1ts3hVd/ImnT5+qLXMm6nSGB+DpS/p86IPWpk0cAZ5
         HXzSurfOZ0UugXqlodLtMIB2yJrSz0CUOlIX+Jv/VEPw9RL/561IcfonDxSEKZbfFSWL
         X6Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678997268;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XgaE34WlFKyvwNRyoN2A9AopcNRZkWUVLIwBf1qOyzo=;
        b=uYwi0m825jqJti96i0H7pQymUENjY7FPRsZ1B16qPD4BFh4cI6PX+aT45eRTdSuRQv
         23PfiwYkHB4EdAtD9bAeexGnjU3WxKJTX/ewfmc5BWVRtC11/nnFo8YVhN/MpKfNJH/O
         X5tLJ6BOXzR+ZRDug+EDLazhg20eJBea5Y0EQPCTe53G8CUi54UD7rimJjZwwWKjAdFg
         K4bj5+NEgn6kQokeKK49Iky07++AaiPavBs/QrMKrx4wsX0iNG9L0YW9+MhcQ4xcQjut
         0VpHANT29PYhvKdtzW+ZLPOluMqqxm8EokFK5bfDc9FhYTALa1VvaTQZupj9gDhPOEso
         KkaA==
X-Gm-Message-State: AO0yUKV4SoengGlPQMnxJiHOkXbOJ71WJOXU4oq+/rayGp4aXiTkYiZ4
        29Fl80glpcI/ObB6G/aGk78=
X-Google-Smtp-Source: AK7set/EmN9A6HV7i6I2mpGfCkHSokbkfs3beFpJ6wfHptdaHxgdIWmEXl5EJHDgIQbU/3CdtChnnQ==
X-Received: by 2002:a17:90b:3c0f:b0:23c:fdb9:b528 with SMTP id pb15-20020a17090b3c0f00b0023cfdb9b528mr5159040pjb.27.1678997267926;
        Thu, 16 Mar 2023 13:07:47 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id mh10-20020a17090b4aca00b00233b1da232csm3596768pjb.41.2023.03.16.13.07.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Mar 2023 13:07:47 -0700 (PDT)
Message-ID: <69230fab-349f-0666-de67-59b11001094d@gmail.com>
Date:   Thu, 16 Mar 2023 13:07:39 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net v2 1/2] ravb: avoid PHY being resumed when interface
 is not up
Content-Language: en-US
To:     Wolfram Sang <wsa+renesas@sang-engineering.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Michal Kubiak <michal.kubiak@intel.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-kernel@vger.kernel.org
References: <20230315074115.3008-1-wsa+renesas@sang-engineering.com>
 <20230315074115.3008-2-wsa+renesas@sang-engineering.com>
 <78e0a047-ad0a-2ca6-10f7-9734a191cefd@gmail.com> <ZBN2rE8WxLoQ1DVX@shikoro>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <ZBN2rE8WxLoQ1DVX@shikoro>
Content-Type: text/plain; charset=UTF-8; format=flowed
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

On 3/16/23 13:06, Wolfram Sang wrote:
> 
>> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> Thanks!
> 
>> This is a pattern that a lot of drivers have, for better or for worse, it
>> would be neat if we couldcome up with a common helper that could work mostly
>> with OF configurations, what do you think?
> 
> I am not so experienced in this subsystem, so I only could identify 4
> drivers which need this pattern, with one not using OF. So, while I
> trust you with a helper being useful, I'd like to pass this task to
> someone more experienced here.

That seems entirely fair, I have one such platform, so may come up with 
a helper after I debug this other issue I am looking at :)
-- 
Florian

