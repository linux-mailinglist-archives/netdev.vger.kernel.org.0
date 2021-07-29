Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B60A3DA239
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 13:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234231AbhG2Lfv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 07:35:51 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:37746
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231576AbhG2Lfu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 07:35:50 -0400
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPS id 200093F114
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 11:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627558546;
        bh=ecITBiExnfrz7s+2RNbpApFu8QtFtMdKsbfQbWi6TUo=;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type;
        b=jDFB8hynE9ZQwWHiGA6bOgl34CotqcdGlqgND74z+l5eKCqYmIoffXUvip3EDsdwC
         cdmTqidmf2qhbREL2UsCSjJfHjMwiZFIK2vgjoQF+sqErVC2c/c8itsiTHlC/jSUAW
         YUU8WC1fjEmUU+5TAfFTqyVdKaygGi3fnO0mtO25meIETEKrJvzlkcvcn+pF2HemVR
         BzBuK9FIe/ym0ZdstE2nN/y7PsMpCKmG8FrxSOy+v9UqhRDJZOzAvp0Te+0CPiWUl9
         RqZX1hsPO+a/lkU0CXHIxP3xYDtXpenGMIUyUNhIYhMjBx8ouF0UFjaBuXWWAJ9jkR
         wctEuFnQwqdPQ==
Received: by mail-ed1-f70.google.com with SMTP id b88-20020a509f610000b02903ab1f22e1dcso2796215edf.23
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 04:35:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ecITBiExnfrz7s+2RNbpApFu8QtFtMdKsbfQbWi6TUo=;
        b=VdnrYbm7+6CjKG5OX47MmZ8TT297JxV0ktiIVHz/sv4FIYeCPwlrLDV/bvaGjuaSnB
         eBjF8a1DKrCQoWfCAXQaWGANV4mYuviCy46WKnFByyvhJcbuE+rDXrWTEaNxT94FBTz9
         +rp4/5i32RSHxp1cTK3NIY8uX+tPFzgU9rVd8Q+jrEE+bwwb7HexWKoTrbTlAqsWRtKg
         q0a4CI/5jqxwmCGVaazCWoY1y8LamQIq7fHErQxpPAJjwf2Whap8/Xil4HKAF04DwfLg
         RuOV/FLHdLVWR+UWmv6Mv5xBtF+o6JVOCuq766/L0+sYa0BKvR8P6kWEpT2GdQF0Iyow
         F+Bg==
X-Gm-Message-State: AOAM533oyvIO9/rwO1znABOLJkMDG22mIyXuswvvht9mIH9IiQwOWmUY
        VM/MvGMMHwc9f7zDuHlZz5Q6i/gsAHK4NCWmeVoWldOJsihIinF/T/PdpoqOaJZwqBZ0NkPooXQ
        H50z8wkZFf2Iw0DF9t3So5r3SU40DKPFCsw==
X-Received: by 2002:a05:6402:124e:: with SMTP id l14mr5714534edw.356.1627558545851;
        Thu, 29 Jul 2021 04:35:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwOaujUGXPLJ56H1P6zQk70UrsB6Pwk0g/7UcJ0l0bQB/BF2GdMVdpMGIjWRvJLxo2hy2jOyQ==
X-Received: by 2002:a05:6402:124e:: with SMTP id l14mr5714522edw.356.1627558545691;
        Thu, 29 Jul 2021 04:35:45 -0700 (PDT)
Received: from [192.168.8.102] ([86.32.47.9])
        by smtp.gmail.com with ESMTPSA id u10sm868329ejf.121.2021.07.29.04.35.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jul 2021 04:35:45 -0700 (PDT)
Subject: Re: [PATCH 00/12] nfc: constify, continued (part 2)
To:     patchwork-bot+netdevbpf@kernel.org
Cc:     mgreer@animalcreek.com, bongsu.jeon@samsung.com,
        davem@davemloft.net, kuba@kernel.org, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
References: <20210729104022.47761-1-krzysztof.kozlowski@canonical.com>
 <162755820704.26856.6157999905884570707.git-patchwork-notify@kernel.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <7b0ae615-dcdc-251e-4067-959b31c28159@canonical.com>
Date:   Thu, 29 Jul 2021 13:35:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <162755820704.26856.6157999905884570707.git-patchwork-notify@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/07/2021 13:30, patchwork-bot+netdevbpf@kernel.org wrote:
> Hello:
> 
> This series was applied to netdev/net-next.git (refs/heads/master):
> 
> On Thu, 29 Jul 2021 12:40:10 +0200 you wrote:
>> Hi,
>>
>> On top of:
>> nfc: constify pointed data
>> https://lore.kernel.org/lkml/20210726145224.146006-1-krzysztof.kozlowski@canonical.com/
>>
>> Best regards,
>> Krzysztof
>>
>> [...]
> 
> Here is the summary with links:
>   - [01/12] nfc: constify passed nfc_dev
>     https://git.kernel.org/netdev/net-next/c/dd8987a394c0
>   - [02/12] nfc: mei_phy: constify buffer passed to mei_nfc_send()
>     https://git.kernel.org/netdev/net-next/c/894a6e158633
>   - [03/12] nfc: port100: constify several pointers
>     https://git.kernel.org/netdev/net-next/c/9a4af01c35a5
>   - [04/12] nfc: trf7970a: constify several pointers
>     https://git.kernel.org/netdev/net-next/c/ea050c5ee74a
>   - [05/12] nfc: virtual_ncidev: constify pointer to nfc_dev
>     https://git.kernel.org/netdev/net-next/c/83428dbbac51
>   - [06/12] nfc: nfcsim: constify drvdata (struct nfcsim)
>     https://git.kernel.org/netdev/net-next/c/582fdc98adc8
>   - [07/12] nfc: fdp: drop unneeded cast for printing firmware size in dev_dbg()
>     https://git.kernel.org/netdev/net-next/c/6c755b1d2511
>   - [08/12] nfc: fdp: use unsigned int as loop iterator
>     https://git.kernel.org/netdev/net-next/c/c3e26b6dc1b4
>   - [09/12] nfc: fdp: constify several pointers
>     https://git.kernel.org/netdev/net-next/c/3d463dd5023b
>   - [10/12] nfc: microread: constify several pointers
>     https://git.kernel.org/netdev/net-next/c/a751449f8b47
>   - [11/12] nfc: mrvl: constify several pointers
>     https://git.kernel.org/netdev/net-next/c/fe53159fe3e0

Oh, folks, too fast :)

Sorry for the mess, but the patch 11/12 has one const which is wrong
(I sent an email for it) and this should be on top of my
previous set:
https://lore.kernel.org/lkml/20210726145224.146006-1-krzysztof.kozlowski@canonical.com/
which I think you did not take in.

I am not sure if it compiles cleanly without the one above.

Best regards,
Krzysztof
