Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F058457158F
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 11:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232653AbiGLJTQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 05:19:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbiGLJTP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 05:19:15 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66EC3B7F6
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 02:19:14 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id h17so10333847wrx.0
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 02:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=message-id:date:mime-version:user-agent:reply-to:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=8+XB4gReHn7DevdKSeqbBVCFg5Byeo7jVOxWWzcOgAs=;
        b=EXaDJdDF6aVGowanXnkKbq+acHuY94bYkj24nOUsIeXXo8B+w7xa3ntL1xHldDlhFF
         iwY0bZcQ/7cnAj+ZfEXs9PxGpbCf6LKfdFtlEXkNzfRYtHFMca6ye8vK28p2pH5heeSs
         tq9M8AIA8vUZFedM6jjUF43MIPkAWsckYMJvzjuUx66l+p2bi93C+7Poks1LgAuZGI/j
         E8BNdxngh1YD3kzWUhtd4DReWMuO2WgcJY5jL3Eh4WwioIFO+ox0scJqS7vng32xswGE
         szV+XtQ6T0Baw4QMlxd0T7HafP/cwC/NVIXpjuForEPm4uMLPxM9A6lrLQ4iRNiozDdU
         T8zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:reply-to
         :subject:content-language:to:cc:references:from:organization
         :in-reply-to:content-transfer-encoding;
        bh=8+XB4gReHn7DevdKSeqbBVCFg5Byeo7jVOxWWzcOgAs=;
        b=waTM6QXq2IsBD7erfbDizrzCtekjMk6bAkHFydhFK0/ASC7gCaRx4LNgcg3mZq4G5R
         +/UbULMf74e0AT1YVo3Oloii6BhzLoeeqsyQCwwKwyAn40BLWU2knXZZQpREMUHnj+ZY
         njMobj/CY2heZu/05QuvdoZY6Jz6n76lGwGd5+JGYescKmwRdlvum+IOMKt9+FYOecF/
         hsgZZHn7nW98N9IMePKwrpEGmk0TlixbHM43zR+rPEW1BzgD1f5AJIkXJAgzTLaCF+VF
         ApDT0qVEvoB2rQICTV4gNinMnvedl5RA5VhQRfj5eJkmgHWHNZQcxpzhI0CxwcON7Jxe
         tVfw==
X-Gm-Message-State: AJIora+KhVE+2nWXvjXp2O35X/U62qKgQp+QAizNq5nEc7eS2YPmHQja
        R+HcUWJU4ojsPheO34pgf8L0CA==
X-Google-Smtp-Source: AGRyM1uS7wpPaR36q1vUUbpSbDrsLI5QFLGUNsyJt16AX/LeAUAemNgyVs5JZsb9XQqnPKoQElMNRg==
X-Received: by 2002:adf:ff84:0:b0:21d:6c27:8f20 with SMTP id j4-20020adfff84000000b0021d6c278f20mr21421431wrr.497.1657617552959;
        Tue, 12 Jul 2022 02:19:12 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:b41:c160:6422:a9c9:641f:c60b? ([2a01:e0a:b41:c160:6422:a9c9:641f:c60b])
        by smtp.gmail.com with ESMTPSA id i8-20020a1c3b08000000b003942a244f40sm12541077wma.25.2022.07.12.02.19.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Jul 2022 02:19:12 -0700 (PDT)
Message-ID: <4ae464c4-9ba8-6011-e904-592bd9e8484b@6wind.com>
Date:   Tue, 12 Jul 2022 11:19:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net 2/2] selftests/net: test nexthop without gw
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org
References: <20220706160526.31711-1-nicolas.dichtel@6wind.com>
 <20220706160526.31711-2-nicolas.dichtel@6wind.com>
 <9fb5e3df069db50396799a250c4db761b1505dd3.camel@redhat.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
In-Reply-To: <9fb5e3df069db50396799a250c4db761b1505dd3.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Le 12/07/2022 à 10:19, Paolo Abeni a écrit :
[snip]
>> +################################################################################
>> +# config
>> +setup()
>> +{
>> +	ip netns add h1
>> +	ip -n h1 link set lo up
>> +	ip netns add h2
>> +	ip -n h2 link set lo up
>> +	sleep 1
> 
> Why is this needed here? same question for the 'sleep 2' after the
> setup.

The 'sleep 2' after the setup was 'copy & paste'. I will remove it.

The bug was initially spotted in 'init_net' and when I first tried to reproduce
it with netns, I didn't succeed without the 'sleep 1'. I didn't analyzed more
deeply. In fact, when I replay the test now, it fails as expected.
Let's remove it also.
