Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38FB247F6AE
	for <lists+netdev@lfdr.de>; Sun, 26 Dec 2021 12:58:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233372AbhLZL6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Dec 2021 06:58:15 -0500
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:42658
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233358AbhLZL6O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Dec 2021 06:58:14 -0500
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com [209.85.208.198])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id D2B223F175
        for <netdev@vger.kernel.org>; Sun, 26 Dec 2021 11:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1640519893;
        bh=k/SriGNptKt8RyID4T8dxyDKW7Ndc6Y4GjEtV/aG7i8=;
        h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
         In-Reply-To:Content-Type;
        b=cHDikb6vh2u7lIhoagXpHGoJ/MsNoDChMlSkaavpCkT236KDtt9l67Gt/tXzWgYEr
         5mkDr5cG81XNTX1ir19peXFknTRmdPS1r2Bqedi//n56vl5QRomo8zgneCa8ztOHph
         Cm6C6iyyIHvT1x20MF7pyoGjDj2JlBNjqI6OBI3v1u4otvKjI1R64vJiF8ANrw7R3r
         Enx50gxfSjRWATPtKGbnntY7kxVgxSlsNjLiVi3Kg3LUtvEZeo6/TK6kf3Y5JMSKyC
         /e5OleiVtzbVrN+U8tLtZ5VB6iuUjpNGl5jPvnOxCGFV9DXE0asAwaI6lBQqH6/CV/
         IH5pGfxdH+akQ==
Received: by mail-lj1-f198.google.com with SMTP id r20-20020a2eb894000000b0021a4e932846so3788887ljp.6
        for <netdev@vger.kernel.org>; Sun, 26 Dec 2021 03:58:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=k/SriGNptKt8RyID4T8dxyDKW7Ndc6Y4GjEtV/aG7i8=;
        b=u1uw00mSPixwMv0hiDiaHwwl2AZ5detDUauDDssR4T4YR8fq0qhoQuaHTaiCDqg3rQ
         fh+Kd4alE5pBK6S3ISdrIKnJ+XrxGp1hm5ZGNFKOEeqPF1CYgtmUD1xUqrnJ18y412oG
         QV4QiKTTw4FdB+VTpBApEVM0E21ljCxGxOBYEoSvzEx+F2k6GqfliTnrbNyUbUQfnXvL
         htPgpablfh/r5mKts5m5URbp28bRKjPzYx5ufgprBbUiu+t8I51q/avOjZAcemre71SV
         E0JUOdia1SyY/tIVi97Qtwg3/YFgBYW6byz+/eZXmxr/OIwGe/jX8nFlQQfoYOw7ghFC
         GETg==
X-Gm-Message-State: AOAM5338yNM1BP2KwBZJ3qtehqtzEzjzcHRFTBpFwdiR7w3pJYuWWMV8
        aUdnDRbc5w5WFWoWqlWPicbnq+W1oC3XnJti329QJsLfWn/Pj5Hir6ozlfyw3q77DCejrQZIlL/
        nKTvBX+DJ1kPje+mnHiIMOTowgHiYy91qig==
X-Received: by 2002:a2e:9697:: with SMTP id q23mr10531263lji.354.1640519893035;
        Sun, 26 Dec 2021 03:58:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwymfV342G9Fd2sVTSX4algppqpLEF5/WDV+TJGBx4EKLVPN71lGZ54emmTYy2+X7S+ckGwrA==
X-Received: by 2002:a2e:9697:: with SMTP id q23mr10531248lji.354.1640519892736;
        Sun, 26 Dec 2021 03:58:12 -0800 (PST)
Received: from [192.168.3.67] (89-77-68-124.dynamic.chello.pl. [89.77.68.124])
        by smtp.gmail.com with ESMTPSA id q10sm1299558lfm.163.2021.12.26.03.58.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Dec 2021 03:58:12 -0800 (PST)
Message-ID: <3a89b2cf-33e4-7938-08e3-348b655493d7@canonical.com>
Date:   Sun, 26 Dec 2021 12:58:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH resend] uapi: fix linux/nfc.h userspace compilation errors
Content-Language: en-US
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     "Dmitry V. Levin" <ldv@altlinux.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20170220181613.GB11185@altlinux.org>
 <20211225234229.GA5025@altlinux.org>
 <3d0af5ae-0510-8610-dfc2-b8e5ff682959@canonical.com>
In-Reply-To: <3d0af5ae-0510-8610-dfc2-b8e5ff682959@canonical.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/12/2021 12:42, Krzysztof Kozlowski wrote:
> On 26/12/2021 00:42, Dmitry V. Levin wrote:
>> Replace sa_family_t with __kernel_sa_family_t to fix the following
>> linux/nfc.h userspace compilation errors:
>>
>> /usr/include/linux/nfc.h:266:2: error: unknown type name 'sa_family_t'
>>   sa_family_t sa_family;
>> /usr/include/linux/nfc.h:274:2: error: unknown type name 'sa_family_t'
>>   sa_family_t sa_family;
>>
>> Link: https://lore.kernel.org/lkml/20170220181613.GB11185@altlinux.org/
> 
> Please skip the link. There will be link added for current patch which
> leads to this discussion. There was no discussion in 2017.
> 
>> Signed-off-by: Dmitry V. Levin <ldv@altlinux.org>
>> ---
>>  The patch was submitted almost 5 years ago, and I was under impression
>>  that it was applied among others of this kind, but, apparently,
>>  it's still relevant.
>>
>>  include/uapi/linux/nfc.h | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/uapi/linux/nfc.h b/include/uapi/linux/nfc.h
>> index f6e3c8c9c744..aadad43d943a 100644
>> --- a/include/uapi/linux/nfc.h
>> +++ b/include/uapi/linux/nfc.h
>> @@ -263,7 +263,7 @@ enum nfc_sdp_attr {
>>  #define NFC_SE_ENABLED  0x1
>>  
>>  struct sockaddr_nfc {
>> -	sa_family_t sa_family;
>> +	__kernel_sa_family_t sa_family;
> 
> include/uapi/linux/nfc.h includes linux/socket.h which defines typedef:
>   __kernel_sa_family_t    sa_family_t;
> so how exactly the build is being fixed? How to reproduce it?
> 

Ok, I see the error - when user-space does not include sys/socket.h.
Makes sense, can you resend with removed Link and with:
Fixes: 23b7869c0fd0 ("NFC: add the NFC socket raw protocol")

Fixes: d646960f7986 ("NFC: Initial LLCP support")


Best regards,
Krzysztof
