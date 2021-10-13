Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24CF942BC33
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 11:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237822AbhJMJ4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 05:56:09 -0400
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:42566
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235811AbhJMJ4J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 05:56:09 -0400
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com [209.85.167.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 6B9333FFE1
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 09:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1634118845;
        bh=hX3zbOHxrRQUNMJzkc7MRlng8m6KCtFLtMMPLm301tg=;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type;
        b=maDqAEe4aUBQMCfEeAsbekr1QbGkIw+aPwl9ZqOhFqsyZIz41/hEJmblybUloKoJ4
         +6podv8zNmBrxlc9ljVW52ygaEs9viCgE835OEybCii9As2N38g2QF8G2D/0cWaTtt
         JlWJAE818rti5O31bnZuMqgRZ0h9KMzLJz0x6eHW4484qZ71gfpQBDO5cctc+B8JhL
         Dom1P6P/RMjeDh3ZaQa8CVNcbeqJDglFXDsTLWMa9lDJItiGZB8HyHUEom6jrCr/ao
         esTeA239YpMHG8C9Aws9vFNJDKzgDTJxnijNMOPI2w43n4F6ohtoTSRTubwDbAdJOF
         VrdPmeura+QdA==
Received: by mail-lf1-f72.google.com with SMTP id x7-20020a056512130700b003fd1a7424a8so1586725lfu.5
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 02:54:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hX3zbOHxrRQUNMJzkc7MRlng8m6KCtFLtMMPLm301tg=;
        b=AxunpK6pFPiM3ylEvYMX57tV5ZBVG1rp2Ty7e8XcQbXLQMGcE4KupNN6efgbXjkUHC
         mEFYZBCN7wGQpPms6GrYfaKo45g5jrVKVyqdRoCi/4wNnEOHeuWlrFh1ZARYAPjoxQVm
         lELB/vw0FbHAJSS5D1QrCafb9k1fH/fM/+qzkyFilptoS7HmuUKM4bkjHK1kQSooaUpQ
         ezl962T8VpZ1U4qPMsy+ovjq6D6/Q6CTEtwiyW68rldxprdXp/IiQSz6ta7QswoyYHOD
         izIo+1x1S6zuCdPxBrm9w8KHe1fCNJEyAzC++l3VKNp/i4D52gCObBzsWVsmAfbcX5s6
         ZlGA==
X-Gm-Message-State: AOAM530V+0YShEcAia69yaVed+DLJTs340UxXCeZ0EOjTGaq/CopB6iI
        I/HS5yswQb94OTzeSOYyqO8ImXO3twQJ10f81GgF+trTNb7/2jEfP2VV7cZ8+QLhP0TQyu1HtKL
        t61SOxg/6M4ao1NpeUTLom1dzUQMmul3VTA==
X-Received: by 2002:a05:651c:206:: with SMTP id y6mr34042358ljn.98.1634118844900;
        Wed, 13 Oct 2021 02:54:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyW5eOV9mE/54Su1c7Va1aXOMDsQOPa4ErGTiUSRBUBTNbeo/DQJTRhuoE6PxkCiym2wULGFA==
X-Received: by 2002:a05:651c:206:: with SMTP id y6mr34042344ljn.98.1634118844755;
        Wed, 13 Oct 2021 02:54:04 -0700 (PDT)
Received: from [192.168.0.22] (89-77-68-124.dynamic.chello.pl. [89.77.68.124])
        by smtp.gmail.com with ESMTPSA id w8sm1004928lft.293.2021.10.13.02.54.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Oct 2021 02:54:04 -0700 (PDT)
Subject: Re: [PATCH net] nfc: fix error handling of nfc_proto_register()
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211013034932.2833737-1-william.xuanziyang@huawei.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <cda4c596-b04e-f6c9-5232-f37ee3d23ae5@canonical.com>
Date:   Wed, 13 Oct 2021 11:53:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211013034932.2833737-1-william.xuanziyang@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/10/2021 05:49, Ziyang Xuan wrote:
> When nfc proto id is using, nfc_proto_register() return -EBUSY error
> code, but forgot to unregister proto. Fix it by adding proto_unregister()
> in the error handling case.
> 
> Fixes: c7fe3b52c128 ("NFC: add NFC socket family")
> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
> ---
>  net/nfc/af_nfc.c | 3 +++
>  1 file changed, 3 insertions(+)
> 


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>


Best regards,
Krzysztof
