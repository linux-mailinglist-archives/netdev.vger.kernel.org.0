Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64DC26E2F6A
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 09:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbjDOHOv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 03:14:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjDOHOu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 03:14:50 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 167875243
        for <netdev@vger.kernel.org>; Sat, 15 Apr 2023 00:14:49 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id dm2so51252681ejc.8
        for <netdev@vger.kernel.org>; Sat, 15 Apr 2023 00:14:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681542887; x=1684134887;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w9cZtGC1yq/nHraNnywecoByV+5AViL7L5hGZARRzpE=;
        b=r8mCPDbIuOKV5WpUQAL/c0r1jGxVeuY1B6lI6fzIPCOWLoKDXRaCa8MR9SuKj0qdw0
         5VrQbXF7chLzuL2HTdQjTIavxYr0Cf85s9kBmWH5PD6fcQ0PHWD7sXfhEN7T9C4SdZ36
         hxve/Z5mCHkE0XBijusdQDIPitiztOgWJ0kOzXIdemKAnA+cW+Y6hdk7edgudkuAhMZ+
         gZnHG5xWi3PgvIFdgxOTBBi+2BzTtu0CUFuTAyUiSic0DJHF6Lt/HFAvaREYjBPyTk/n
         PGJ79OVUy+3wFs9YFCUOoNkHCzQaPMd+1ZrnvrZaajH27MLoJ6gCCeG6Yo30f+/qaMjH
         cKoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681542887; x=1684134887;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w9cZtGC1yq/nHraNnywecoByV+5AViL7L5hGZARRzpE=;
        b=AvoiBzLGfpXXz16UTvbXu0mnCtwjCTI7G1JvvxsISZOnEW7+Q5fN8Z2/fK9P8F9OkE
         Ycu5hkEYvV8JU6BdrdfVlPmbChaQkqA0IYBxe6v+gli8Zu3gq2DjByT4hG7GIiDiQsMm
         ZZIKdzRLRflFjQnaDx7DA45pxYSMlG7LngeQ6eJQ65LcwqrA3Kp0S4gBXv9wWMvXaJww
         2w5Z8QHul02y0k5FPpPOKiSjGMnxOGzVJE7e8GdnUt8bVToKBC+Eu9EQrnzBQ+66EvwI
         TlOccGJY62tXpDgBWfGTYFGQtJd9vRd6MPLKgizV5lmXoSL6NBFULRX8yCFx0oj5wy9o
         IVYg==
X-Gm-Message-State: AAQBX9fFq/+XnviEWtEtlhLbM1wOHD1I6dQRJSV91YCmfQ3htUC8uCjf
        mfu9hS4JYDPWDcmMLN5YgW0=
X-Google-Smtp-Source: AKy350aTaXx4CLmvbq35iS9dLx6l8ZHzb7S6+VuhZw33msOcmd6wlA7YMNbIRKittXXWrmOIqiSgrA==
X-Received: by 2002:a17:906:f47:b0:94e:fb4f:2fb8 with SMTP id h7-20020a1709060f4700b0094efb4f2fb8mr1901887ejj.39.1681542887301;
        Sat, 15 Apr 2023 00:14:47 -0700 (PDT)
Received: from ?IPV6:2a01:c22:76c9:5300:c449:604e:39a7:3bce? (dynamic-2a01-0c22-76c9-5300-c449-604e-39a7-3bce.c22.pool.telefonica.de. [2a01:c22:76c9:5300:c449:604e:39a7:3bce])
        by smtp.googlemail.com with ESMTPSA id bs12-20020a170906d1cc00b009351546fb54sm3367604ejb.28.2023.04.15.00.14.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Apr 2023 00:14:46 -0700 (PDT)
Message-ID: <1b342bde-99fe-be30-0dca-dfa3c1924494@gmail.com>
Date:   Sat, 15 Apr 2023 09:14:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <32e7eaf4-7e1c-04ce-eee5-a190349b31f9@gmail.com>
 <ad9be871-92a6-6c72-7485-ebb424f2381d@gmail.com>
 <20230414185329.6e8ada34@kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next 2/3] r8169: use new macro
 netif_subqueue_maybe_stop in rtl8169_start_xmit
In-Reply-To: <20230414185329.6e8ada34@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15.04.2023 03:53, Jakub Kicinski wrote:
> On Thu, 13 Apr 2023 21:15:37 +0200 Heiner Kallweit wrote:
>> +	stop_queue = netif_subqueue_maybe_stop(dev, 0, rtl_tx_slots_avail(tp),
>> +					       R8169_TX_STOP_THRS,
>> +					       R8169_TX_START_THRS);
>> +	if (door_bell || stop_queue < 0)
> 
> Macro returns 0 if it did the action. So I'd have expected <= or !
> Maybe better to invert the return value at the call site..
> 
I didn't encounter a problem in my tests, but you're right, this should
be changed. Currently we ring the door bell if the queue was stopped or
re-started. Should be sufficient to do it if queue is stopped.

> 	stopped = !netif_subqueue_maybe_stop(...
> 	if (door_bell || stopped)
> 		..

