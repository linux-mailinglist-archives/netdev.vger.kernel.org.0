Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF3D45DC4A
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 15:26:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349318AbhKYO3U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 09:29:20 -0500
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:49080
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347025AbhKYO1T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 09:27:19 -0500
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com [209.85.208.199])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id F18CE4001F
        for <netdev@vger.kernel.org>; Thu, 25 Nov 2021 14:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1637850246;
        bh=jJ1CvK9RCVKJj05miAYFdX0zpNfhh9+b9Y39+PdS9oM=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=tMITbB44IRcXHPvZyBGFW1Z3nCYrF5yDQjgbu6FjhAB1Lh9uhRWnBFJtgBsQFn6jV
         og/4F9LBpaierL+9p/tHjj5xT3dQ/gDBD9PPtxDiNBvF3itgpMye9Ci/qzkrHla7mF
         mfIrIwvZ2ko6QWlnQM4eFX2M2FSMuCDhMYwCTwFZ1lSDcaPLMMcLMKw9rV3Uwz0xm2
         fveECohU/tWcAiobWX3/lFV2Z+3CAyzcNcmEODjeOdyMHKV1c6uol0upp/CrAK19+e
         0uE5QmN3AafFrYL8N4SNrWmfb8st72YBb65r2fRzZaTEkYU+FsmHutxncf2BjQzcox
         DpedyxpJKSpbg==
Received: by mail-lj1-f199.google.com with SMTP id t25-20020a2e8e79000000b0021b5c659213so1889844ljk.10
        for <netdev@vger.kernel.org>; Thu, 25 Nov 2021 06:24:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=jJ1CvK9RCVKJj05miAYFdX0zpNfhh9+b9Y39+PdS9oM=;
        b=V5yQi74qQOE4E20lGUGIQxY+p99NLfwU71yZG9Fxri1fPx5h91vmG5zrl58L5iLCc4
         MSPIdopRLyMW1MzPdUqsfQSPh15/pMQHsH7bVjz3zf2d1J/LNwA+stpTduwSKFUVlmwW
         ochTmrejfq7/lC1WCxvj5+xGiScS3MOs8TR6gAE2Q52pfzOIR22n/fNvxOP5x41OR2zD
         qCouAmrac3ph7q1+4NlACZ1Pd4J3gKQM81JjnIXd19g1OmJTTSGeRBn/cB65JgUiKZPg
         4B1sQWj/cPtE77Xyrla/nhp8DZWFSrJznhFgKZ65WavuZhcD/cmbygsoAgDOwV8F6yHO
         E2Jw==
X-Gm-Message-State: AOAM532TLo2WPMXFdbUoryK4oL1u6MBbspsT0c/trfYITSrgqzvsrg7L
        8JBCcRyIVJJlKL7bICswlos5T79W21aKe1iuoLc5/sO1t0jWmygMQB4c7CUgtus6519KDtcvRGK
        h9qTOCiclx9TtK8YRNiP9FMO6mPkJp95iaw==
X-Received: by 2002:a05:6512:a84:: with SMTP id m4mr24021456lfu.284.1637850246397;
        Thu, 25 Nov 2021 06:24:06 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxZt9BGxb3SteRzbKydg11/7MAVLZ8xf/xO5RgFnE/o2qUWQ3QTFDY/nRqr2DLousCbioJWXA==
X-Received: by 2002:a05:6512:a84:: with SMTP id m4mr24021422lfu.284.1637850246164;
        Thu, 25 Nov 2021 06:24:06 -0800 (PST)
Received: from [192.168.3.67] (89-77-68-124.dynamic.chello.pl. [89.77.68.124])
        by smtp.gmail.com with ESMTPSA id s15sm272325lfp.252.2021.11.25.06.24.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Nov 2021 06:24:05 -0800 (PST)
Message-ID: <872e6a95-721d-2c33-77c4-764a0b859f43@canonical.com>
Date:   Thu, 25 Nov 2021 15:24:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH] nfc: virtual_ncidev: change default device permissions
Content-Language: en-US
To:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bongsu.jeon@samsung.com
References: <20211125141457.716921-1-cascardo@canonical.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
In-Reply-To: <20211125141457.716921-1-cascardo@canonical.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/11/2021 15:14, Thadeu Lima de Souza Cascardo wrote:
> Device permissions is S_IALLUGO, with many unnecessary bits. Remove them
> and also remove read and write permissions from group and others.
> 
> Before the change:
> crwsrwsrwt    1 0        0          10, 125 Nov 25 13:59 /dev/virtual_nci
> 
> After the change:
> crw-------    1 0        0          10, 125 Nov 25 14:05 /dev/virtual_nci
> 
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> ---
>  drivers/nfc/virtual_ncidev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>


Best regards,
Krzysztof
