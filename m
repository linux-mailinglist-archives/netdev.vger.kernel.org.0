Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B49248C1F4
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 11:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349646AbiALKHh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 05:07:37 -0500
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:58796
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1352291AbiALKHg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 05:07:36 -0500
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 604AF3F198
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 10:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1641982055;
        bh=KdlgmtxP+gkPgxGJtnhitWm+fuJDdU9aOghdG1MKfgY=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=T2ZlTOMQeLBbpqEvIsAS0hxdOdh9CPb1vb3qegnehsyJbJ9eCcC8xi+/WMuSdSGOX
         x7sUAJRTwJLFhb8bI5mZgKtpgU9qUBTyI2gQtH/cBHDa9qBNRCjlYO+xEhG1RXQUHT
         S2CWyAp3dvHsyjYD+46VK9qqSLfS3DNiQBvGcH6WiELl+l1kf8IIP7lYuupM+W9Fh/
         IBVWHv76cSDJI7bBDrYruprNn43I97VkRzbT+QhLkxRDIeccabWaq3C9VS108xCM86
         JnjXnEJE5wZJH/F8WNWyMs3+yde+joJkpDeg0XlV93pJQIS3UQmvGIcQfQABJ9fW+D
         Er+erExbCTgiQ==
Received: by mail-ed1-f72.google.com with SMTP id q15-20020a056402518f00b003f87abf9c37so1803620edd.15
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 02:07:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=KdlgmtxP+gkPgxGJtnhitWm+fuJDdU9aOghdG1MKfgY=;
        b=2NoV1OtWYlB8+bCpVwbXYb55TZ635egfi5OMU3ulutkpxghnXUZChtwEvBMl7U07P+
         PQm+ViHBXv1RXClKvuRVOPRxq1BKPO5dfLYRkw1y+umMAxXRb5lFEw67uGm38iexUXTP
         5TGMp3rJg2MfcVQ2oIVsvra1UiWl8gJdTvpJfIHFw5QJLeXXi6QQ3+U0kY1BwG4ihpy1
         OGHW7NKv70xklFzMz+smz2m4QRpaKYk9hrcJS1/QIPsEMig731lS+eCfa9z55Q4ySd7V
         WTc2DRneZRyb3ntiyngiqjDKl0gK7mzV5PZcQbbSF/WoRBGiLASWUAnroGs61WOrH+zd
         8PNg==
X-Gm-Message-State: AOAM530J0+ipf3tAd2n7p0JwKdEB+uDfWHNdWK6vtpJ+3bsVI21s8XsD
        6pDXUPaqyG7wDQsk8Qf1OC24SktKUPybq6ADYyDbivJMXkcqRqFzm+gZogdy5IRA+756ETMvJbh
        fOWyVrzrduJUu5TUIwPnZWozNptU8lQcBoQ==
X-Received: by 2002:a17:907:7da5:: with SMTP id oz37mr7398773ejc.586.1641982055125;
        Wed, 12 Jan 2022 02:07:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzdUaXBJsgnJXOpWStI3VRIBs4g9c6w5851GHMpkrWcLcfgjGOZHWdQmw3wExTZW8Thm6aQ+w==
X-Received: by 2002:a17:907:7da5:: with SMTP id oz37mr7398766ejc.586.1641982054933;
        Wed, 12 Jan 2022 02:07:34 -0800 (PST)
Received: from [192.168.0.29] (xdsl-188-155-168-84.adslplus.ch. [188.155.168.84])
        by smtp.gmail.com with ESMTPSA id go35sm4302409ejc.191.2022.01.12.02.07.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jan 2022 02:07:34 -0800 (PST)
Message-ID: <b47eba60-9d02-2901-2759-b2230087193c@canonical.com>
Date:   Wed, 12 Jan 2022 11:07:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v3] nfc: st21nfca: Fix potential buffer overflows in
 EVT_TRANSACTION
Content-Language: en-US
To:     Jordy Zomer <jordy@pwning.systems>
Cc:     kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20211117171706.2731410-1-jordy@pwning.systems>
 <20220111164451.3232987-1-jordy@pwning.systems>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
In-Reply-To: <20220111164451.3232987-1-jordy@pwning.systems>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/01/2022 17:44, Jordy Zomer wrote:
> It appears that there are some buffer overflows in EVT_TRANSACTION.
> This happens because the length parameters that are passed to memcpy
> come directly from skb->data and are not guarded in any way.
> 
> Signed-off-by: Jordy Zomer <jordy@pwning.systems>
> ---
>  drivers/nfc/st21nfca/se.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 


Looks ok.

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>


Best regards,
Krzysztof
