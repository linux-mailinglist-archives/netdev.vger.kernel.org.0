Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B231448FE0E
	for <lists+netdev@lfdr.de>; Sun, 16 Jan 2022 17:58:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233928AbiAPQ6b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jan 2022 11:58:31 -0500
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:42904
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232386AbiAPQ6b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jan 2022 11:58:31 -0500
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 43EF73F175
        for <netdev@vger.kernel.org>; Sun, 16 Jan 2022 16:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1642352310;
        bh=QUxJvjdxOHxqcyIcyp2pPFZDYQTODmNTcXQxvaV9Jjs=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=ftPlrLkRhGTZgouvChla3eVFmJ2AfzuXRY7WZkWB5RlgFcmfJ8F8tyNcTCY1HzJnh
         esbBlojjMGjgUUcf67UPdwvZVDDhFu52DfgVJ0LZh42h3+fUZd6ez5HaVi6ufGWeNe
         jiVXz7CFvpnkWd9TozvJoaT+ZNpg4zeTACMQWrq5NEIAfVVZ1932X4s+2IZ+hanmdg
         Ly3F0L1YXra2v6EUQFkBeVu7eq621akH00i8jiQVIfJDTnfcxidGqJiNDFtEqvXf7l
         szrV3HmpMRqE0HvMjZCD77Hvh0HUL/F0FhIa8H8dIVb0J9EHFWuGnWmCV4DHvqjJfj
         BG4DOo3fQIDkw==
Received: by mail-ed1-f71.google.com with SMTP id x19-20020a05640226d300b003f8b80f5729so12094189edd.13
        for <netdev@vger.kernel.org>; Sun, 16 Jan 2022 08:58:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=QUxJvjdxOHxqcyIcyp2pPFZDYQTODmNTcXQxvaV9Jjs=;
        b=c0g9bzZRjiRT2QxPcmTII9yu7d88JLsY6JLw5P10PfrimsQ/R5IBjAhicNyCbKTPBy
         BhuvkzdfbBq59T298s1f5Bi7P6VkFTDz3wQTOTAgPuY9nH7Thjd/0ZfUV5Ulk26ydhWk
         8hjRjpRAfMnQ9gb7b1D3OL1LFLX64q385pC1BwVV016MeKpInA0PQFmodnr0vWfWkC5p
         uRb6r6+6Y9EXF7EYzrlU3PT3sAT1o4P/WLfxUm7Xofw4z+K1KErWQ8jZyd5TlOf8n+7J
         xNljFhfa79dRgefLyTw8ZLLFa4pfuhSATWYB1FEsPRG3De8Phn3U4b7Xd/LmkCJvJDBP
         qf7Q==
X-Gm-Message-State: AOAM530fRu5Z0cd/HOHsRBhK0jFQjOWoNhyfOZ24et/6pvZhKaEv3Uwl
        5MT4E+UU17jyaF6CEENuQlM87fDkyIqAaBM4fOnBAihkuqf3MvZG4wLh6cap25fZzJE2GbPOGf0
        cIr22hee0ZiQ14EElOI1NjWx9+xDY3tq6gw==
X-Received: by 2002:aa7:c9ca:: with SMTP id i10mr17883770edt.66.1642352309999;
        Sun, 16 Jan 2022 08:58:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx9w3mtLdhSj54CtN8jzh+J3pJj+RpZnbf53zhH8BPmWKIKMsfiJF8bekVl02LG0GPUAmtMqQ==
X-Received: by 2002:aa7:c9ca:: with SMTP id i10mr17883761edt.66.1642352309854;
        Sun, 16 Jan 2022 08:58:29 -0800 (PST)
Received: from [192.168.0.35] (xdsl-188-155-168-84.adslplus.ch. [188.155.168.84])
        by smtp.gmail.com with ESMTPSA id pk12sm382094ejb.35.2022.01.16.08.58.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Jan 2022 08:58:29 -0800 (PST)
Message-ID: <9fcef93a-7afa-06ad-66e4-2cb22c6ea0ae@canonical.com>
Date:   Sun, 16 Jan 2022 17:58:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH 0/7] nfc: llcp: fix and improvements
Content-Language: en-US
To:     David Miller <davem@davemloft.net>
Cc:     kuba@kernel.org, linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220115122650.128182-1-krzysztof.kozlowski@canonical.com>
 <20220116.123211.1251576778673440603.davem@davemloft.net>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
In-Reply-To: <20220116.123211.1251576778673440603.davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/01/2022 13:32, David Miller wrote:
> 
> Please don't mix cleanups and bug fixes.

The fix is the first patch, so it is easy to apply. Do you wish me to
resend it?


Best regards,
Krzysztof
