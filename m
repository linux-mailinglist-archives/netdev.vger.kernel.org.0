Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9375C42A94F
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 18:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbhJLQYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 12:24:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbhJLQYF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 12:24:05 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5733AC061570;
        Tue, 12 Oct 2021 09:22:03 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id pi19-20020a17090b1e5300b0019fdd3557d3so2982352pjb.5;
        Tue, 12 Oct 2021 09:22:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nBqP/3VFWK5V8AqM1vfVZzousXyortN4fifQYKnnMDA=;
        b=UYCetDqhHLSBzCA6V+m8cqyubgu7mfb113Jf09rnGQBJzSgTYWGq4PSbzmswVbKFGN
         Km0lOse9R8Tz2r7BjsXggKgKEbGvRIfS4VsAnM6irYU4sA2uhti/AzgGl+z7vDwkHfGD
         JjuWSauQ/l+KPSmbtPDnkWWKbgoc6x+jtDkeoJPVENtudbZMf94eW0upo50/3vrVguJj
         fxqCE1O0WV3wziyMGtFetUdDfi6PG3PDAAmCm/RLPKquv4Or8lESLXR/MnsZGxNaQ+XN
         /ZmyaRRxLH2hUFZje+LIJazy5CUsKg1EuLfnGWf0Kef/KJ0C7BjpBTknE1r0bVHNm5Vk
         MC1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nBqP/3VFWK5V8AqM1vfVZzousXyortN4fifQYKnnMDA=;
        b=dBn7RYDsW2EtS/rLgF+KKHBzHYVlS8jsPDIzpNzfLeMe5wHcyBDwKEA4sVcGTZfV8y
         fw3ui7e20Ri9DBfPz7A6XPmua2KXf2tcdo+ORoI3ciy6FiF4txEkv9ArqWoDihGh586S
         kRcjLosuNf1YbFUwanJ0+ABAb/hhqcJLzEEjWeagkYko8AaSTtmpZQOYMFr9jYKFC143
         Gzl+E3dsl2RCSwp81r2vBpNpWbM9wZdOPEucMr5HrwdkDK1AOPF7/qzvC4M3B8OFrMLS
         6sJTMRKC9pev+K/H+euqY3HiNPTbX/DcbFtodjesM+J6MAj1BmAxApA7ne7Nz337+N+l
         7/ag==
X-Gm-Message-State: AOAM532sCv0U5lCI+ttizgN83Y3ieV08Nv0DHa0JxTWaCsAUPa/ordzQ
        rDv/Satd7Ok3h3WQfz9mj3ZR0Id74jA=
X-Google-Smtp-Source: ABdhPJxMXia2hjPpnBc6gQ1sljG69Jm/gUhJbLmxEMhdgjpdPKHmUwy6MDn55mTcWlnq1KRw+zHv0Q==
X-Received: by 2002:a17:90a:de16:: with SMTP id m22mr7110361pjv.38.1634055722789;
        Tue, 12 Oct 2021 09:22:02 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id z23sm11799962pgv.45.2021.10.12.09.21.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Oct 2021 09:22:02 -0700 (PDT)
Subject: Re: [PATCH] net: korina: select CRC32
To:     Vegard Nossum <vegard.nossum@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
References: <20211012152509.21771-1-vegard.nossum@oracle.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <c4157f54-8ba8-cf3a-f278-ba1a3096dcd3@gmail.com>
Date:   Tue, 12 Oct 2021 09:21:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211012152509.21771-1-vegard.nossum@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/12/21 8:25 AM, Vegard Nossum wrote:
> Fix the following build/link error by adding a dependency on the CRC32
> routines:
> 
>   ld: drivers/net/ethernet/korina.o: in function `korina_multicast_list':
>   korina.c:(.text+0x1af): undefined reference to `crc32_le'
> 
> Fixes: ef11291bcd5f9 ("Add support the Korina (IDT RC32434) Ethernet MAC")
> Cc: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>

Acked-by: Florian fainelli <f.fainelli@gmail.com>
-- 
Florian
