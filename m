Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1D674461F8
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 11:10:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233028AbhKEKNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 06:13:16 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:37766
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230110AbhKEKNP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 06:13:15 -0400
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com [209.85.167.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id AE24A3F4B9
        for <netdev@vger.kernel.org>; Fri,  5 Nov 2021 10:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1636107035;
        bh=z0tsoUmWOaxgRAp937Z0S11BvmYuYC7jjzjengboIcg=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=o5Z1vjJgSACA4EGoej49Wsnt105zwONo0S4jNqAklTObPsnMYLPwG3oGVt9RJ7BnG
         F7qTQn2tIct+b+bZiIglAQVLaR912Qqlds+Vm2NN/7f6x3trZfznQr/fknLQgeQcZN
         H5Sz3/Td1/HoN1+/zzfrbpOqcDCrXuX4v1LyOWPSzQoLgKRVMFGxn1Wr8HrafvwFvT
         GYC4XLkOUM1WwPT9s54eGpEvxYRkFpQMdq7Lbwr8IBsJ7Ytv3IZxAkIuxuLagfBe38
         Dd0+8agkK4/e/s92qIcVYzbYToRAYV8KW6e/goiC4naEZEibHaaTCizdCqyFE9d+Dl
         BgPjJ8FnaxmIw==
Received: by mail-lf1-f72.google.com with SMTP id y40-20020a0565123f2800b003fded085638so3396717lfa.0
        for <netdev@vger.kernel.org>; Fri, 05 Nov 2021 03:10:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=z0tsoUmWOaxgRAp937Z0S11BvmYuYC7jjzjengboIcg=;
        b=e8FZlED7mxLi3u5wVva71aZj1xS/lalyn94q2SnEwikLbu0Mg6mksn/zEV7Zh7i0rh
         OdwmbXPJp/lEai1ftDWeq8ZLLVUy8sHMr5Dbv0jVfQXWKkZrLFOMMQ70X99yMhdbYji+
         dysiucm/Y0yRTv1Wl3ZV2y5GG954xjxEJK60Us+qWl2r12O6I9VLLX3ed3CByFtP9amv
         zi5LgxWjMI5iI/Zv6/4pkly4D65NiEVOspYmPva1Cr7hOkBtpbm0Idqhq7WO0Chvyhuy
         uf9HNu02ZA75PQAKQLVTVATibmG7yqlXiMnP1GqotHfxjW71sPm7HCKW7hZiEb6hamuD
         oZEg==
X-Gm-Message-State: AOAM530KN87p4tWgThvdci+zsPRPJLn4S4M4UW1uTicNyAChhw0lCpn0
        Qqiq6YHYHMI1T0gN+SQAKu56zIXnFhM1Rgg/yaVRg7KJvvRksPy03xdOLmcosAur0Fj1EjAnsfU
        Esb4zy5V5soem956GQveC/OyMHe+CG9FuSQ==
X-Received: by 2002:a05:6512:926:: with SMTP id f6mr52661476lft.495.1636107035186;
        Fri, 05 Nov 2021 03:10:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz8ms6IBqfGRrpRsf+ifN6GlLsj6sLALe5+yrME7rKButQoJ+/xoGsTps2A9xU47zf/OcwOvg==
X-Received: by 2002:a05:6512:926:: with SMTP id f6mr52661450lft.495.1636107034918;
        Fri, 05 Nov 2021 03:10:34 -0700 (PDT)
Received: from [192.168.3.67] (89-77-68-124.dynamic.chello.pl. [89.77.68.124])
        by smtp.gmail.com with ESMTPSA id k7sm33785lfv.214.2021.11.05.03.10.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Nov 2021 03:10:34 -0700 (PDT)
Message-ID: <45e75291-223d-829a-6772-07bde8943dcc@canonical.com>
Date:   Fri, 5 Nov 2021 11:10:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: nfc: pn533: suspected double free when pn533_fill_fragment_skbs()
 return value <= 0
Content-Language: en-US
To:     YE Chengfeng <cyeaa@connect.ust.hk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "wengjianfeng@yulong.com" <wengjianfeng@yulong.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <TYCP286MB1188FA6BE2735C22AA9C473E8A8E9@TYCP286MB1188.JPNP286.PROD.OUTLOOK.COM>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
In-Reply-To: <TYCP286MB1188FA6BE2735C22AA9C473E8A8E9@TYCP286MB1188.JPNP286.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/11/2021 10:22, YE Chengfeng wrote:
> Hi,
> 
> We notice that skb is already freed by dev_kfree_skb in pn533_fill_fragment_skbs, but follow error handler branch #line 2288 and #line 2356, skb is freed again, seems like a double free issue. Would you like to have a look at them? We will provide patch for them after confirmation.
> 
> https://github.com/torvalds/linux/blob/master/drivers/nfc/pn533/pn533.c#L2288

Hi,

Indeed it looks like double free. Please send a patch even without
confirmation - code is better than just text report.

Best regards,
Krzysztof
