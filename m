Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B83252CECC
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 10:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235702AbiESI6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 04:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230234AbiESI6s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 04:58:48 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E166A2057
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 01:58:47 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id bu29so8013295lfb.0
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 01:58:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=r1Wb7PaA4953uHIZsNFP9FIdN+kpe9dYq/ERCMXbxdw=;
        b=so0qRwy3SJ/vzyWAM2e9B6qti1Qdo3hQoIHhp5uVHC1Dx4YajvB7Liu9/B9p6ByU2K
         79s+t+ALqD3S2d29C7smaHUUKpYgT3knOxUlhHbwSVi/sB+4+p0p6CAgP+9TKd/M6FKo
         UcPJFkWFzQTFKiVWVc6Bu5l5QS8WA26cn04Y4oV3Rj+NcwPBuWeBK65vMCZ2Li+x/4Z/
         6RpIA/1l2DveUysr6NwZ+JMk9dKn3/XK2iUNm9yNVX/raz+yMRQFXF7+AqPasv76aNdT
         I4KF9zrv0ephx3oc50Nkzvx4vetb3MitQd6JY398hmT70681SE5q1tmFZKCT4F2FMXaG
         Ijbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=r1Wb7PaA4953uHIZsNFP9FIdN+kpe9dYq/ERCMXbxdw=;
        b=nWXiYWHX8ERduYVsa8+DqfCm1gNE4wul+FmSk89aQgZeV5arVfeXyD4/qroWGc8/0S
         LkaQpN3rgbkDOnTNfZ/YuvBgTRwmK2Eck4osPj5pTYLqho/xF/8rGpmVllvQYmSrGIi4
         gZDTW/coSRAjvSghhDoe7d5eo8bBQMevT0SCet/Xf0IOxUI9FnASf0mQDH2cn7zWr8t8
         HWtwF11aAKgvCkJQbtdnsBDJG0ongzTfima82NZ7gXq0fbAPsU2P8V/EODtAnZt47Npq
         xX35lLe5Y7N5P480UsZY+ARcZ/IQ3A4/rcs3qEqS0rU0pm2Bo0fKilh+irkGOiJaUNBk
         8ZsQ==
X-Gm-Message-State: AOAM532PX5xlGY9knHh4dGqL22iYBbPc0CUGi7AyNL33RY8zYX2YB/kD
        xeXV7mmLbqu7uF+6edW3Xc91eZ9NZRnwGRn0
X-Google-Smtp-Source: ABdhPJzM6Pe/gzEFe9YuKQN3PWZjIjxHS9s+k6JOENos+GlquY90h48vr7LikcF9bLZIeEcnnT/l1Q==
X-Received: by 2002:a05:6512:b11:b0:474:2b91:99c4 with SMTP id w17-20020a0565120b1100b004742b9199c4mr2560165lfu.347.1652950725730;
        Thu, 19 May 2022 01:58:45 -0700 (PDT)
Received: from [192.168.0.17] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id m12-20020ac2424c000000b00473c87152bcsm214181lfl.127.2022.05.19.01.58.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 May 2022 01:58:45 -0700 (PDT)
Message-ID: <00252573-b6ac-4172-eb54-ce20d49a033b@linaro.org>
Date:   Thu, 19 May 2022 10:58:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH net v3] NFC: hci: fix sleep in atomic context bugs in
 nfc_hci_hcp_message_tx
Content-Language: en-US
To:     Duoming Zhou <duoming@zju.edu.cn>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, gregkh@linuxfoundation.org,
        alexander.deucher@amd.com, broonie@kernel.org,
        linux-kernel@vger.kernel.org, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com
References: <20220518115733.62111-1-duoming@zju.edu.cn>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220518115733.62111-1-duoming@zju.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/05/2022 13:57, Duoming Zhou wrote:
> There are sleep in atomic context bugs when the request to secure
> element of st21nfca is timeout. The root cause is that kzalloc and
> alloc_skb with GFP_KERNEL parameter and mutex_lock are called in
> st21nfca_se_wt_timeout which is a timer handler. The call tree shows
> the execution paths that could lead to bugs:
> 
>    (Interrupt context)
> st21nfca_se_wt_timeout
>   nfc_hci_send_event
>     nfc_hci_hcp_message_tx
>       kzalloc(..., GFP_KERNEL) //may sleep
>       alloc_skb(..., GFP_KERNEL) //may sleep
>       mutex_lock() //may sleep
> 
> This patch moves the operations that may sleep into a work item.
> The work item will run in another kernel thread which is in
> process context to execute the bottom half of the interrupt.
> So it could prevent atomic context from sleeping.
> 
> Fixes: 2130fb97fecf ("NFC: st21nfca: Adding support for secure element")
> Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>


Best regards,
Krzysztof
