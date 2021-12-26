Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA4147F6FC
	for <lists+netdev@lfdr.de>; Sun, 26 Dec 2021 14:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233588AbhLZNdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Dec 2021 08:33:08 -0500
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:43762
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233585AbhLZNdH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Dec 2021 08:33:07 -0500
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com [209.85.167.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 747F13F1AA
        for <netdev@vger.kernel.org>; Sun, 26 Dec 2021 13:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1640525581;
        bh=5hl8fZhsVpBo1XUxuN05cyNpu1ppwDrJbSBSw880EBI=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=VOceXwIh2AJP2LaKdAmUoKTgOCRgckIx77112ASqa2uNlHLS4nfYYnRgN1bb/Yy+p
         g8umpUSMzuxzaYkJ6AlrazLtPswk0GucVvGNnpQrt6HID1IDzNoBAsIqX7Y0ZI0a5C
         HuGQn7QdlIp7tI31F+unDh7vGN+XpBAPfZIXM/hDVjPpPaOiGvKL6vJzPi/iHvP8xK
         o1vo/8qFV4GUecJswTP7+MI/hU/9Gty8j+0cUMiNyKb92SjTluM40CA1vxE0/20WWo
         8QaVLrAtMukiHfW6Skdq+bfACHQU26Y0LnqTb7C2cqKRL0WEcz6DA6Vv9P1QBuaiuW
         8JhTXZWLHxwjA==
Received: by mail-lf1-f72.google.com with SMTP id a28-20020ac2505c000000b0042524c397cfso3465132lfm.1
        for <netdev@vger.kernel.org>; Sun, 26 Dec 2021 05:33:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5hl8fZhsVpBo1XUxuN05cyNpu1ppwDrJbSBSw880EBI=;
        b=0X0xFgyYJp3qjLS31lKQ0NX0er2ZT/F6KF/DgrKpblnRM607H5CSHF8KQTvERNhwgr
         ln3HDPspvNzZMrKc5XhJZOqXrOyDlcepcYZOJe+Lo/QRMMBKUCTQgh/V2T46CYKzAwdY
         Av8n0w9rMxNYfuzSO481b+EqrrQq28h86MaHtSTZr3zqxirKoWEm/eBkgZqcuiK1FXZh
         PccQQYeuMLtwx8O6RfZVHIbr0/JjKRcPpRnrrmMES8FPm25svw88u2AbEL3t/yuVadzE
         Zeby1wfrTAvUmkaQYGcuKnjEFIUOEbJKayfMLSaSwDQGit2awfU6k3jol+wfgiB3NpGi
         uqlg==
X-Gm-Message-State: AOAM5316+xL31Q1V69ZOvCukBWS3PznjU0ia3NauhKuDjO4LmsdS+Lnv
        NCtbDzWC2USFRbEFXZRFRuTsov7aHPD7F4fTqT28+irr7hsz/fIVFzq7BtvAXx0xhgwxwClenun
        7Y2Ioi2dOeYk8Y+ybaOAecYkgDTEVi39dng==
X-Received: by 2002:a05:6512:3c93:: with SMTP id h19mr12361354lfv.350.1640525580814;
        Sun, 26 Dec 2021 05:33:00 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxaPO0IrZ0edRf135q1LSfrH5OTCn59pP04BFRwnjsK6lZ/3wxZtc7qEyXX30WwELODNuDMEw==
X-Received: by 2002:a05:6512:3c93:: with SMTP id h19mr12361347lfv.350.1640525580653;
        Sun, 26 Dec 2021 05:33:00 -0800 (PST)
Received: from [192.168.3.67] (89-77-68-124.dynamic.chello.pl. [89.77.68.124])
        by smtp.gmail.com with ESMTPSA id q5sm434393lji.57.2021.12.26.05.32.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Dec 2021 05:33:00 -0800 (PST)
Message-ID: <dc0bbdcf-fa5b-7af1-db4d-2ceb422027bf@canonical.com>
Date:   Sun, 26 Dec 2021 14:32:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v2] uapi: fix linux/nfc.h userspace compilation errors
Content-Language: en-US
To:     "Dmitry V. Levin" <ldv@altlinux.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20170220181613.GB11185@altlinux.org>
 <20211225234229.GA5025@altlinux.org>
 <3d0af5ae-0510-8610-dfc2-b8e5ff682959@canonical.com>
 <3a89b2cf-33e4-7938-08e3-348b655493d7@canonical.com>
 <20211226130126.GA13003@altlinux.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
In-Reply-To: <20211226130126.GA13003@altlinux.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/12/2021 14:01, Dmitry V. Levin wrote:
> Replace sa_family_t with __kernel_sa_family_t to fix the following
> linux/nfc.h userspace compilation errors:
> 
> /usr/include/linux/nfc.h:266:2: error: unknown type name 'sa_family_t'
>   sa_family_t sa_family;
> /usr/include/linux/nfc.h:274:2: error: unknown type name 'sa_family_t'
>   sa_family_t sa_family;
> 
> Fixes: 23b7869c0fd0 ("NFC: add the NFC socket raw protocol")
> Fixes: d646960f7986 ("NFC: Initial LLCP support")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Dmitry V. Levin <ldv@altlinux.org>
> ---
>  v2: Removed Link tag, added Fixes and Cc tags.
> 
>  include/uapi/linux/nfc.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>


Best regards,
Krzysztof
