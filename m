Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 734E26CB551
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 06:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232159AbjC1EHz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 00:07:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232787AbjC1EHx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 00:07:53 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93410DE
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 21:07:52 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id d17so10729863wrb.11
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 21:07:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679976471;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hSYeu2M9+8n33BFsR0hD4Zc0kLWbtkHGnKywYIFcxj0=;
        b=gv4szj55vY2B882D9QSK/BMtnFfxUe27UKvJ8aLrqfMX8H484vxq8sy3Hz8ELE6rzC
         MMb+m8V+zj9ooqThxr1lc90iegy8C6Z0Tyv1LBZq6Fw37CzlFyifvKyOlGRcV+SqNfhV
         7vn4cus1JC+3xKvFS54G6KgkpLMGWg+kluPFvy+3tUl0lsmCT+lfWRja7GGiqfBQT7IK
         BgKzA/qvjfaF1rojNgVl0ueU8NRsAprqKUcCbRXy3qMnU84gtDktDZSTAyYUPJqc/OWI
         YdcibZJFlDrJHNdfSQigQeIZTWEeR++axUd7bdnIZvRfNsN3ncAZQlncdJAzaMEMPWQy
         VTRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679976471;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hSYeu2M9+8n33BFsR0hD4Zc0kLWbtkHGnKywYIFcxj0=;
        b=2XyJjW4S+q4mX72vNIeeKvpS1OnI/PjK/KyYIE/vmSz+LZt47MLH517eUDIllOxvp0
         myMglRFoXYagdbL5NIxVYK2WSdJS1SBHgbysaHtwRJJb6m249BYRHdz0KlTWso/99Eoo
         ET1i0BuO1Zgy+wJb3rZbk3vyXz9CTLzMsIV+4BI5kIPRueO9naNj2om9kqTsP7vxXkrK
         vSS4egDsArzN8qQBoFB1swjx1mtM8mI8eiRPVY6tW619NzjuSeOCsB9L7DSe0JqCSLAE
         pDzVb5ezzAgJZAZC8LPsCwkAdZCZFPOg/iGuDt7O19WzXQuA5huVCm+tw6B0K6anYsNx
         KK7Q==
X-Gm-Message-State: AAQBX9fS25aVm7rUJdok8VAZB0SfbKVpCT1RmIEKMwrHMBAt0RgVWFQR
        zBZ/jkGAWTuQPsTKNyWP6pg=
X-Google-Smtp-Source: AKy350Yw7N8M8bkofbL4u/GOxXOsGmAPpPVfjFQp2sDqABwrzgGY7qQv9pQLaXrtKEF3KFLndMprmA==
X-Received: by 2002:a5d:4533:0:b0:2cf:ed7c:29c with SMTP id j19-20020a5d4533000000b002cfed7c029cmr11406621wra.62.1679976470979;
        Mon, 27 Mar 2023 21:07:50 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id f11-20020a5d4dcb000000b002cfe3f842c8sm26247974wru.56.2023.03.27.21.07.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Mar 2023 21:07:50 -0700 (PDT)
Subject: Re: [PATCH v5 net-next 1/4] sfc: store PTP filters in a list
To:     =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>,
        habetsm.xilinx@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com,
        netdev@vger.kernel.org, Yalin Li <yalli@redhat.com>
References: <20230327105755.13949-1-ihuguet@redhat.com>
 <20230327105755.13949-2-ihuguet@redhat.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <5ecd2625-39a7-a4d6-a7ac-5a454381f28c@gmail.com>
Date:   Tue, 28 Mar 2023 05:07:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20230327105755.13949-2-ihuguet@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/03/2023 11:57, Íñigo Huguet wrote:
> Instead of using a fixed sized array for the PTP filters, use a list.
> 
> This is not actually necessary at this point because the filters for
> multicast PTP are a fixed number, but this is a preparation for the
> following patches adding support for unicast PTP.
> 
> To avoid confusion with the new struct type efx_ptp_rxfilter, change the
> name of some local variables from rxfilter to spec, given they're of the
> type efx_filter_spec.
> 
> Reported-by: Yalin Li <yalli@redhat.com>
> Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
> ---

Reviewed-by: Edward Cree <ecree.xilinx@gmail.com>
