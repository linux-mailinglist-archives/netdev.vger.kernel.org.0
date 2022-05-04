Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51D52519787
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 08:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344918AbiEDGq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 02:46:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344614AbiEDGq4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 02:46:56 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78EC71A81E
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 23:43:21 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id dk23so1023886ejb.8
        for <netdev@vger.kernel.org>; Tue, 03 May 2022 23:43:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=vmfGvdzEe7Sq3XbMqL7KmA39B54APPzcmwPdJivs+Iw=;
        b=yUHggd5XkRGX7BVJ4f5wXLAMvX9qY4kDBGmX5mQ+cfxmRE/aFUntAgddgmt0hj+6ZY
         aDH/UyHEGP4FFDNJ4HjId6UVjym7p8vIejq+c28syw0lcSafOBNduiTzH3cAcn9OXCpY
         tDJpHzCtfMXinvogMOhlwsjAKW+o5l5tmv4g6GAoPKZt6ee7vJ+wRK+INu7gUjIsPXy4
         sgXx28LeVmUJS22bHNbAdA/WmtCn55/uro8ypXAJu5n8Gc9MvsNT5XlYunSnrZF4m3dD
         uW4QdavtPhGGLgwT/G98i+aZsGo2Edv+CRx9E6YzbGuywWlxUxCkHZffHMH+OTm8s/Fu
         TuCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vmfGvdzEe7Sq3XbMqL7KmA39B54APPzcmwPdJivs+Iw=;
        b=nO6LkA3D3EcWcvg4Uad2jkg8ojLlDbXqbga+tWeXM67JJfgUd57CUouI0TVp1xUgRh
         72WWcziBAocXlLqhTkNXZlDuuPrO/LvipTRHF+35dB6+exvNjdCVpDdYoETAgZNOx1J9
         EkRg4BwphKjw8I8ueTLGEsbrQFu7SI0TFh0MWy3SpYU0KgWwhs6sBoiun/ttmprnRyP4
         fO31/cQldzyxTw2vUUoU9nrYiU6bGVr4MlmCuZQCh85Jhd/Imp0sG1VFdNqMR6tkIGhx
         GSYiAf9lyU440HeIN2YFnXhxPzKGuL38ibU/G2EW4ACDWwxcd3P5kOzvSsN8M0lQooiF
         J3ow==
X-Gm-Message-State: AOAM533T3JPeST6libaKeZGvojTcZdY68IzYZWMOd/yCsIcv3vzFxuWy
        Mvk2AYetKHg5TMBRCC9c9h/K2g==
X-Google-Smtp-Source: ABdhPJxRFMk5S9I6bl1IFF4cZ1hDJJ33NG9TVpbihrfMxZsC0Wy/1hStbekFcMTYa86v+ErMcU4qMA==
X-Received: by 2002:a17:906:dc8b:b0:6ef:86e8:777 with SMTP id cs11-20020a170906dc8b00b006ef86e80777mr19342462ejc.326.1651646600068;
        Tue, 03 May 2022 23:43:20 -0700 (PDT)
Received: from [192.168.0.208] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id hw7-20020a170907a0c700b006f3ef214e16sm5385364ejc.124.2022.05.03.23.43.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 May 2022 23:43:19 -0700 (PDT)
Message-ID: <5eebd441-ded0-3668-f592-05bdeef920b1@linaro.org>
Date:   Wed, 4 May 2022 08:43:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net] NFC: netlink: fix sleep in atomic bug when firmware
 download timeout
Content-Language: en-US
To:     Duoming Zhou <duoming@zju.edu.cn>, linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
References: <20220504055847.38026-1-duoming@zju.edu.cn>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220504055847.38026-1-duoming@zju.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/05/2022 07:58, Duoming Zhou wrote:
> There are sleep in atomic bug that could cause kernel panic during
> firmware download process. The root cause is that nlmsg_new with
> GFP_KERNEL parameter is called in fw_dnld_timeout which is a timer
> handler. The call trace is shown below:
> 
> BUG: sleeping function called from invalid context at include/linux/sched/mm.h:265
> Call Trace:
> kmem_cache_alloc_node
> __alloc_skb
> nfc_genl_fw_download_done
> call_timer_fn
> __run_timers.part.0
> run_timer_softirq
> __do_softirq
> ...
> 
> The nlmsg_new with GFP_KERNEL parameter may sleep during memory
> allocation process, and the timer handler is run as the result of
> a "software interrupt" that should not call any other function
> that could sleep.
> 
> This patch changes allocation mode of netlink message from GFP_KERNEL
> to GFP_ATOMIC in order to prevent sleep in atomic bug. The GFP_ATOMIC
> flag makes memory allocation operation could be used in atomic context.
> 
> Fixes: 9674da8759df ("NFC: Add firmware upload netlink command")
> Fixes: 9ea7187c53f6 ("NFC: netlink: Rename CMD_FW_UPLOAD to CMD_FW_DOWNLOAD")
> Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>


Best regards,
Krzysztof
