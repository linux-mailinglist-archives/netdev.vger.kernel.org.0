Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A15C65715E
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 01:05:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbiL1AFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 19:05:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiL1AFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 19:05:32 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 664CF5593
        for <netdev@vger.kernel.org>; Tue, 27 Dec 2022 16:05:31 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id w37so9651530pga.5
        for <netdev@vger.kernel.org>; Tue, 27 Dec 2022 16:05:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Zn53Ilcv4VZBSICCOMbWFjUfdhSvemia78fXbmnAvfc=;
        b=We7p6Xlb17bfKm1P9wIYnwEFN8cHzjgnX6/AZKmrDRhzI9HwnozQ7K+j6W0xbIJI/b
         uoYFo0PIn9Ka2MzSYiozZLIwv0VD6R6m8IBztTIp2I5K0wVeccHWxzzVME6iWEiUUGi/
         aoSMMNdUReg1sonIIoumzlH2c900ppoyfg+vFC3y4U4xAncdgkz2nyTX4CERmVJf7g7W
         NLFNoG7LgLdViMSjJAuG4IDmyN/xAE0Y+r+SI8zheggS4U/NdwE9Fp3JmN9r73x2t8Y7
         1FtrubqvY2sjX5NGbUZw6H7XVTqXGg/Wo5HudrgKPcj49+yZhYBHeo+jw0XO1h2GPrpX
         ea2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Zn53Ilcv4VZBSICCOMbWFjUfdhSvemia78fXbmnAvfc=;
        b=fP/q8/U5NYfiZO+hUgdGTG8R8isSBCAMOSNLzJQiPueT/ggxJV1eeh83Jypzrm4JVq
         3yzOLx5I6AtuMTttXkZOuEjP+08lg9QYjYNEUCqF2a0u7D5YUFbsOnjRynbS52udN4/Y
         EezQDWsD6S5X3SvHHkP8kTG8XsUDsu6E14EVvoYJrSNTcSZjkPZUKMw9/KJTB03nBG7w
         ySaRwKh90tzVC1juYb+MqE6a0n4EuioMD7KDfjDsUuJhnjj/HSiO1B3iYyDYKlNFsGqH
         5+rXk7HNSscEmtTT2/141utd/f1604Nc6QTI0mgE0nEF6u43ykWHcrUpOdqJg1nEYgUF
         uMqw==
X-Gm-Message-State: AFqh2koeoef/HozC1B1DOZYmdUK8I/wXME7WDOzxD6ZHm+A1esMMyqSJ
        zmC6oVK0pu7yk2u5//TOhlA=
X-Google-Smtp-Source: AMrXdXs1SWMKPgjTqUwrx6G8d/6esbWjpp93Z87TTCNkJvOf6Kw/VR8nqHkbHezm5xnkvfXF5PtLXg==
X-Received: by 2002:aa7:8d09:0:b0:577:3944:aa78 with SMTP id j9-20020aa78d09000000b005773944aa78mr22000596pfe.0.1672185930825;
        Tue, 27 Dec 2022 16:05:30 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id 64-20020a620543000000b0056bd1bf4243sm9123894pff.53.2022.12.27.16.05.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Dec 2022 16:05:29 -0800 (PST)
Message-ID: <fc7603b3-1ec1-d0c6-30c7-9a9ea7fab271@gmail.com>
Date:   Tue, 27 Dec 2022 16:05:28 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 1/2] net: ethernet: broadcom: bcm63xx_enet: Drop empty
 platform remove function
Content-Language: en-US
To:     =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, kernel@pengutronix.de
References: <20221227214508.1576719-1-u.kleine-koenig@pengutronix.de>
 <20221227214508.1576719-2-u.kleine-koenig@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221227214508.1576719-2-u.kleine-koenig@pengutronix.de>
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



On 12/27/2022 1:45 PM, Uwe Kleine-König wrote:
> A remove callback just returning 0 is equivalent to no remove callback
> at all. So drop the useless function.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
