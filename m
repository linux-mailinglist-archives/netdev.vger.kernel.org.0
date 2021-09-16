Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75C3B40EACD
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 21:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbhIPT3W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 15:29:22 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:35466
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229455AbhIPT3U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 15:29:20 -0400
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 9652840267
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 19:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1631820478;
        bh=MMcgzru3ZwhyKOsYx2iFuNW8JodY417NqNj4jNsFMOQ=;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type;
        b=WmsgSjgvRZbCGGvLpwIqgyndnz1GO8TIzbqyguhA46DPqcSXONcGKWFEeHR8us0yl
         erGEGG1N0iPahnFMhHjqKX68P8lhXEYttk61jD60yBxtOLHIELfL9O4BCRnBBua6F1
         q/RZ5umPWYLE8Q8tsZ7nonXuoUXVi2qvoKDOdL9X2MbHnUfmy83R7srXi0m89tiCxU
         pFbxqN4pR7IJiLrVqH3SMF1fxn0FKeouaOhwLgN6UvVvs93vL6D/XMW+l1WAbhbwop
         ZDrNAbuDxucDrUvwiBjz9BL6vXQhq/5q4zmDe/YK2IlX6S40UCfUpuhYJOQdG/9AmO
         kJzGcRCSp7VPQ==
Received: by mail-wm1-f71.google.com with SMTP id q4-20020a1c4304000000b00306cd53b671so1193285wma.1
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 12:27:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MMcgzru3ZwhyKOsYx2iFuNW8JodY417NqNj4jNsFMOQ=;
        b=hnnldGJA0HgJx4qxW3J1vuBJjDbGosDORJhbaZe4BCd/9jxo0QqCOly2J3r6BCPxQL
         UgLH8YMoce06FZQrhX2GiIKuZ8XClhcavWeou6ACQS4p18A2KrKxhF9Th6ABcI/tldR6
         1MUVxqqWE8qzfV0vTj5R6Uws2lew58UUJg2ypw3Kln6vqloRZPBSvE4O+R5WIfmNoIzB
         exXRFQJ+xm0RJLMUFL8vsr+z9hVylnAu6b8Cctjsc6l0XQALFV8EitC380yTK6fYvssN
         HheLkFClHyc861HslOh3gGDMh3QtDJ0lKKIFswZvzEiPp7YaxuELF3TNBx2Dvt7ege9f
         rEQw==
X-Gm-Message-State: AOAM531PIAbIxe4SFNNPmKNVTE5K8JOAd8n3kMs11jXykAY0U7aG0c7N
        6P0I4YuuQeu3a7UIMMtL1gO6b3kwWTwKoEuXLQlWrkBPfwWO+k6dFxWEbuMsUtLpYYOkeHuBfPk
        ta9IDdxe42AElR/2ChZSOEl8N5lQXy5hjXw==
X-Received: by 2002:a1c:7f57:: with SMTP id a84mr6593057wmd.34.1631820478294;
        Thu, 16 Sep 2021 12:27:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwqn1+ESA3K0zllvSWstH2qMZ0N3R38ReyqO045tBhcLAJAO9cDYj4nPSe6W+hMxkhv/fTfPg==
X-Received: by 2002:a1c:7f57:: with SMTP id a84mr6593050wmd.34.1631820478167;
        Thu, 16 Sep 2021 12:27:58 -0700 (PDT)
Received: from [192.168.2.211] (lk.84.20.244.219.dc.cable.static.lj-kabel.net. [84.20.244.219])
        by smtp.gmail.com with ESMTPSA id k6sm7063711wmo.37.2021.09.16.12.27.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Sep 2021 12:27:57 -0700 (PDT)
Subject: Re: [PATCH] nfc: trf7970a: Make use of the helper function
 dev_err_probe()
To:     Cai Huoqing <caihuoqing@baidu.com>
Cc:     Mark Greer <mgreer@animalcreek.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210916153621.16576-1-caihuoqing@baidu.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <21782e6d-038f-9009-ed8a-d65c2cdfb761@canonical.com>
Date:   Thu, 16 Sep 2021 21:27:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210916153621.16576-1-caihuoqing@baidu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/09/2021 17:36, Cai Huoqing wrote:
> When possible use dev_err_probe help to properly deal with the
> PROBE_DEFER error, the benefit is that DEFER issue will be logged
> in the devices_deferred debugfs file.
> Using dev_err_probe() can reduce code size, and the error value
> gets printed.
> 
> Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
> ---
>  drivers/nfc/trf7970a.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 

Please don't send patches one-by-one, but group them in series.

Same response - I think the preferred approach was Rob's dev_err removal.

P.S. You need to Cc all folks and all lists. The cc-list here is too short.

Best regards,
Krzysztof
