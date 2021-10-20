Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0669C4345B2
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 09:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbhJTHLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 03:11:21 -0400
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:51486
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229771AbhJTHLU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 03:11:20 -0400
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com [209.85.167.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 0B56A3F4BA
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 07:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1634713746;
        bh=j8lUGUZ+hYeiPkhKZo4yfn4ldIjieSzUVsSX+lYwZ1U=;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type;
        b=u4YJa21Y6sLQTlEdIE0zBvJPWID5a5fHPiWs87EYlCFSX7SeRvB6/ZRLqpGD2TvZ3
         sB3vy8l25cgh+E3xtWuBAF3MRclWcKDu38oGE1dCcme14HtpW7CDUAx+MRbZAiCxEI
         R5266MEMwZunOgADpFjbCCHOxp1+5xXObU7e5ZCvL+9RPcW+XekEIm9EKynw+nxNR4
         l+Ck3d89z1nvXlNLcTjre7LZuClojnHZlxJwAcGmW6qMG1CpMr34k4Z9rI56zTf9lr
         X9G9SOO9VhZuHavbP2kZNC/lygf7K2wXkP9ohzjkx42eYpw6LdX6sxdoU19TpljV4r
         Evx+E93wowC7w==
Received: by mail-lf1-f69.google.com with SMTP id br42-20020a056512402a00b003fd94a74905so2732682lfb.7
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 00:09:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j8lUGUZ+hYeiPkhKZo4yfn4ldIjieSzUVsSX+lYwZ1U=;
        b=x1crjdMeeTOzJOc30ICeKwThgqbw0u6svNkKabAD39of2fHCzM+YHurr7w+oLXtue5
         uD0iiXufO/Qy5YPvrY2ByKAQ4ZADV21BsTg/kOUTEJhvOIY7GTU+War76svn09r/vIR6
         s5NM5UKlm202ICX+SpRQdqvbYjLEA7jkl5Mu0C6wYR5YmHhBJ/+fnY5NTyZk1NhQRqud
         j5Mr4OR4aDhSvV0CwjHsV2d+iS3osrK+VHBWifP0uf2Kc5yFv2KRkvQJb0J58MlU1UIa
         YyEXCiLUwfqBKx0R9rem4qghkUQy3EjS9Bv9QJUaoUx/2iULF4kchyQrbmARsn4rNWIt
         5kpw==
X-Gm-Message-State: AOAM530cGyTmTx2pOLUZtk6jWASQYEUFXsdmrw2M6JDHulfYvTmPpW+S
        U8SL1noZ8z88LmOCRAu7aKxKTe58K/sJQgnYsqCKW0BsXHCNGpW7Rlm9ZpE4jALCKrMyYDv7gqs
        hOBX5xGrFLmiX9xX9Rp1wK/EWRdeUjkAj4A==
X-Received: by 2002:ac2:5104:: with SMTP id q4mr10687835lfb.87.1634713745378;
        Wed, 20 Oct 2021 00:09:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzoK9U8fW0DOZINVCUGWpc5mOgext9O1+WMHzVOlXzhJMHA5RE05+ZNMdJlV6pk8oIf47MPEw==
X-Received: by 2002:ac2:5104:: with SMTP id q4mr10687823lfb.87.1634713745223;
        Wed, 20 Oct 2021 00:09:05 -0700 (PDT)
Received: from [192.168.3.161] (89-77-68-124.dynamic.chello.pl. [89.77.68.124])
        by smtp.gmail.com with ESMTPSA id o12sm117851lft.254.2021.10.20.00.09.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Oct 2021 00:09:04 -0700 (PDT)
Subject: Re: [PATCH] nfc: st95hf: Make spi remove() callback return zero
To:     =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>
Cc:     netdev@vger.kernel.org, kernel@pengutronix.de
References: <20211019204916.3834554-1-u.kleine-koenig@pengutronix.de>
 <da88faf5-33db-b20d-e019-7cca6779b626@canonical.com>
 <20211020070526.4xsjqdi54iayen3l@pengutronix.de>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <5eaa4875-3d7a-f1cd-578b-c1ea8db2bf19@canonical.com>
Date:   Wed, 20 Oct 2021 09:09:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211020070526.4xsjqdi54iayen3l@pengutronix.de>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/10/2021 09:05, Uwe Kleine-König wrote:
> Hello Krzysztof,
> 
> On Wed, Oct 20, 2021 at 08:55:51AM +0200, Krzysztof Kozlowski wrote:
>> On 19/10/2021 22:49, Uwe Kleine-König wrote:
>>> If something goes wrong in the remove callback, returning an error code
>>> just results in an error message. The device still disappears.
>>>
>>> So don't skip disabling the regulator in st95hf_remove() if resetting
>>> the controller via spi fails. Also don't return an error code which just
>>> results in two error messages.
>>>
>>> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
>>> ---
>>>  drivers/nfc/st95hf/core.c | 6 ++----
>>>  1 file changed, 2 insertions(+), 4 deletions(-)
>>
>> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> 
> Given you're the listed maintainer for NFC, I wonder who will take this
> patch? I expected you to take this patch and not "only" give your
> Reviewed-by tag.
> 

Yeah, it's not that obvious. Maybe I should write subsystem/maintainer
guide for NFC...

All NFC patches are taken by netdev folks (David and Jakub) via
patchwork. You did not CC them here, but you CC-ed the netdev, so let's
hope it is enough. You also skipped linux-nfc, so you might need a file:

  $ cat .get_maintainer.conf
  --s

Best regards,
Krzysztof
