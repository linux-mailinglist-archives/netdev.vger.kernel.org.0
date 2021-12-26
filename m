Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89A0047F6A4
	for <lists+netdev@lfdr.de>; Sun, 26 Dec 2021 12:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233273AbhLZLmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Dec 2021 06:42:07 -0500
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:42458
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229735AbhLZLmG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Dec 2021 06:42:06 -0500
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com [209.85.208.200])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 203F83F1B2
        for <netdev@vger.kernel.org>; Sun, 26 Dec 2021 11:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1640518925;
        bh=zpufh2CvDreLRGLAtAqhzvft20fCH3VnJaLHlSd4UR0=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=gBevRhOyoU7lvGeqCaFxRqEe1yVLa8Et7Z7aGv51nc5+tHIOyIP1js5M2oqm94R+7
         X0sNzgzzilm3gA9KbpciydsvdNZMCDmagMnwSBvJkfaO2KP3JZXP5o4jUHIZ9UyMJE
         D69SyKVBlhfrSEMkXgcF7GIqTTRzzJkUX6NyP87HJ9GB6Lhdu5n/68eDNXGGvSBiIr
         uAm5B2wx4d07FE/sKHpeWppGGWzBUlGYtExjI/7zrnj7uoCSnp6PCTXBo9aPcBdza7
         nDax6l3JX6YnW0tsbZWTji7Iv/TjKy+EPonKWzJmlSy/k6SpcfIONelHoYYT1l95NF
         vZWH4MMC2o1dQ==
Received: by mail-lj1-f200.google.com with SMTP id d12-20020a05651c088c00b0022d989d91caso2826531ljq.20
        for <netdev@vger.kernel.org>; Sun, 26 Dec 2021 03:42:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=zpufh2CvDreLRGLAtAqhzvft20fCH3VnJaLHlSd4UR0=;
        b=1DezMZd5ApQngiw672xLFYSb2xI8EpDMmECHNcshxi8pG6f+Ny485TqfEI/EtsiF4d
         rvjDer3eCmQPGOrzSFK9j5ifYJjvlJtO69XOqyKm6oe1w+pKiKbralqKQAxyZ39isXSW
         sc4YJzL8kEtueLivDENmHCpz5VdxEz018o4Y39UdPKExOH9A2NAwD82Yb9a3cepd/7V+
         cE+g8rpU8jZogo7/sI7Lzg2QcNHrjyMEnP1Jd4l2umpc142VgY2xPQhXUnv+w/L3r1Js
         T5HA9634a+/X/Es3yeI7CCztFMtC6t4yraCIy8Ue8fwozIWndeF+ZCcjAZxkmPbQe2O7
         sgJQ==
X-Gm-Message-State: AOAM530GvhXx+7A9Q/zVKYOOji4ijp+CIB5AhPQKGAfRjpWFBqg+BjR2
        VoElklX3OKPBagfOW4l9HiayRUkKA2ZFRo6GbWqD3VcRU1oe+XXCSrunrnuktuOnumRtc64JQUh
        hfCJFs996UjDGOqKBvvTaItmMHUbskXy52Q==
X-Received: by 2002:ac2:5ca4:: with SMTP id e4mr12065784lfq.263.1640518924089;
        Sun, 26 Dec 2021 03:42:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwf3Z942vTSDQmm1sp07odWHNvAxPgacPmaUNEMbB5aL3o/oAnNG7bI6KMlewbiw8o7NSZOnQ==
X-Received: by 2002:ac2:5ca4:: with SMTP id e4mr12065721lfq.263.1640518922401;
        Sun, 26 Dec 2021 03:42:02 -0800 (PST)
Received: from [192.168.3.67] (89-77-68-124.dynamic.chello.pl. [89.77.68.124])
        by smtp.gmail.com with ESMTPSA id a12sm1040004ljp.59.2021.12.26.03.42.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Dec 2021 03:42:01 -0800 (PST)
Message-ID: <3d0af5ae-0510-8610-dfc2-b8e5ff682959@canonical.com>
Date:   Sun, 26 Dec 2021 12:42:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH resend] uapi: fix linux/nfc.h userspace compilation errors
Content-Language: en-US
To:     "Dmitry V. Levin" <ldv@altlinux.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20170220181613.GB11185@altlinux.org>
 <20211225234229.GA5025@altlinux.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
In-Reply-To: <20211225234229.GA5025@altlinux.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/12/2021 00:42, Dmitry V. Levin wrote:
> Replace sa_family_t with __kernel_sa_family_t to fix the following
> linux/nfc.h userspace compilation errors:
> 
> /usr/include/linux/nfc.h:266:2: error: unknown type name 'sa_family_t'
>   sa_family_t sa_family;
> /usr/include/linux/nfc.h:274:2: error: unknown type name 'sa_family_t'
>   sa_family_t sa_family;
> 
> Link: https://lore.kernel.org/lkml/20170220181613.GB11185@altlinux.org/

Please skip the link. There will be link added for current patch which
leads to this discussion. There was no discussion in 2017.

> Signed-off-by: Dmitry V. Levin <ldv@altlinux.org>
> ---
>  The patch was submitted almost 5 years ago, and I was under impression
>  that it was applied among others of this kind, but, apparently,
>  it's still relevant.
> 
>  include/uapi/linux/nfc.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/uapi/linux/nfc.h b/include/uapi/linux/nfc.h
> index f6e3c8c9c744..aadad43d943a 100644
> --- a/include/uapi/linux/nfc.h
> +++ b/include/uapi/linux/nfc.h
> @@ -263,7 +263,7 @@ enum nfc_sdp_attr {
>  #define NFC_SE_ENABLED  0x1
>  
>  struct sockaddr_nfc {
> -	sa_family_t sa_family;
> +	__kernel_sa_family_t sa_family;

include/uapi/linux/nfc.h includes linux/socket.h which defines typedef:
  __kernel_sa_family_t    sa_family_t;
so how exactly the build is being fixed? How to reproduce it?

Best regards,
Krzysztof
