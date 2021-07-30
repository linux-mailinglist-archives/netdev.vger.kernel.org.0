Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A6E63DB9D5
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 15:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239032AbhG3N42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 09:56:28 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:57082
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238971AbhG3N41 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 09:56:27 -0400
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPS id 402B73F112
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 13:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627653381;
        bh=lARzsFFKndNN9dr3t+/u0cyc0ObFsz25/ZNbpOuqiCk=;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type;
        b=BFTuQGJz0deDosa4zG7ihL4XwFHAEo7iw3+9Y1z7AU9cuHLVN7OwcYuYFaSwnhnjy
         pr6nxKoZZYaoX58Gg53F27T2TgvErEwMvX03H2alzwanQsJilwidKdBGFyNu1S5wRe
         VJTsnyudwiCb4fkF3PKBIAQvVDr+WBntSFJ/zfENgmuOPVaduZHY9Psu1o9lt9XQPK
         Kdoxi98OQCdh/OuKVLEjfKhNowlIRYErjU92SSZbZImDONUDwPR3VkQit0fqjQbu+f
         8FETe3/7RMh9vQ8o984oSnC3/yFgOPory8IFHadx4UdNc6kzN1naruLWIpTlyWQnMb
         09+PJsVZb7UZg==
Received: by mail-ed1-f71.google.com with SMTP id p2-20020a50c9420000b02903a12bbba1ebso4630270edh.6
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 06:56:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lARzsFFKndNN9dr3t+/u0cyc0ObFsz25/ZNbpOuqiCk=;
        b=sWHFaVfnFiRZi+dj+wZyTkfPZXATcDUVLkbWrspQbNvGq0se8aiRtNQXKC6Q627H1d
         jaxrdfdWBFHIXDhcfCw42GvKZ1HiI6wtJfYSee7669TV1u66pK2AcgDfdks0xRB4vtgm
         EkvA6HSI87FLgxKDeoEVxdpFdDXkvOUPzkOgngP04NX9hQHQ6muQHOPNd2N//Pl4rMr1
         45tqauwpWe6BR7dLIbrhJjWq7FtILKOQmJTA9OtX++LveSKqOmbnlEN/3GI0qVNItUvx
         2sD4gg4ae8YRf7xnfDaxzHJGEoJHFI/X2M+xrrcDfOgEfxvOoCrzHfM3pOHTliPKGJBV
         NEWw==
X-Gm-Message-State: AOAM531tXiTQAoecvMBTfYe/ElhEi1SurM3bKDK3x3lkTE2yEBQiN1BQ
        RagEHgA3+VWMaioMsGNmvgCy5qdFc0WW2RkS9awqxdnifbOS9pntZqsxewRvxrqkIdFWcwap+bu
        smWT+197/VaD1+HSD7yh76GCekGQg/oFQpA==
X-Received: by 2002:a05:6402:51c7:: with SMTP id r7mr3249734edd.150.1627653380984;
        Fri, 30 Jul 2021 06:56:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwVO/TZcid1GbI+VKszynUFz37DfSLb78lTq4sraurPgpb2E6eKicuL9nwvbLgEGd+vhDfkZg==
X-Received: by 2002:a05:6402:51c7:: with SMTP id r7mr3249721edd.150.1627653380787;
        Fri, 30 Jul 2021 06:56:20 -0700 (PDT)
Received: from [192.168.8.102] ([86.32.47.9])
        by smtp.gmail.com with ESMTPSA id m26sm730890edf.4.2021.07.30.06.56.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Jul 2021 06:56:20 -0700 (PDT)
Subject: Re: [PATCH v2 7/8] nfc: hci: pass callback data param as pointer in
 nci_request()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210730065625.34010-1-krzysztof.kozlowski@canonical.com>
 <20210730065625.34010-8-krzysztof.kozlowski@canonical.com>
 <20210730064922.078bd222@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <53f89bae-fcb5-8e7c-0b03-effa156584fe@canonical.com>
Date:   Fri, 30 Jul 2021 15:56:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210730064922.078bd222@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/07/2021 15:49, Jakub Kicinski wrote:
> On Fri, 30 Jul 2021 08:56:24 +0200 Krzysztof Kozlowski wrote:
>> The nci_request() receives a callback function and unsigned long data
>> argument "opt" which is passed to the callback.  Almost all of the
>> nci_request() callers pass pointer to a stack variable as data argument.
>> Only few pass scalar value (e.g. u8).
>>
>> All such callbacks do not modify passed data argument and in previous
>> commit they were made as const.  However passing pointers via unsigned
>> long removes the const annotation.  The callback could simply cast
>> unsigned long to a pointer to writeable memory.
>>
>> Use "const void *" as type of this "opt" argument to solve this and
>> prevent modifying the pointed contents.  This is also consistent with
>> generic pattern of passing data arguments - via "void *".  In few places
>> passing scalar values, use casts via "unsigned long" to suppress any
>> warnings.
>>
>> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> 
> This generates a bunch of warnings:
> 
> net/nfc/nci/core.c:381:51: warning: Using plain integer as NULL pointer
> net/nfc/nci/core.c:388:50: warning: Using plain integer as NULL pointer
> net/nfc/nci/core.c:494:57: warning: Using plain integer as NULL pointer
> net/nfc/nci/core.c:520:65: warning: Using plain integer as NULL pointer
> net/nfc/nci/core.c:570:44: warning: Using plain integer as NULL pointer
> net/nfc/nci/core.c:815:34: warning: Using plain integer as NULL pointer
> net/nfc/nci/core.c:856:50: warning: Using plain integer as NULL pointer

Indeed. Not that code before was better - the logic was exactly the
same. I might think more how to avoid these and maybe pass pointer to
stack value (like in other cases).

The 7/8 and 8/8 could be skipped in such case.

> 
> BTW applying this set will resolve the warnings introduced by applying
> "part 2" out of order, right? No further action needed?

Yes, it will resolve all warnings. No further action needed, at least I
am not aware of any new issues.

Best regards,
Krzysztof
