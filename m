Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6DA489356
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 09:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240708AbiAJIaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 03:30:03 -0500
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:48792
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240822AbiAJI2u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 03:28:50 -0500
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id B32053F1A2
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 08:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1641803318;
        bh=KSGYgxbJHtzmF1VVpegyRa64dLhxDiMx11JnqwEBzqQ=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=D+48NLkUTk/Zik539i6ZCdG6/twYX0WWOYJCIYYi5sRGY+nAfWvHxqN+Luxc2C+9d
         BMq2p5dFFS/xS0ZC4NJxQESZIzVN9EFtcnbZR3Q62sp7YyoWgBsZpqvKJOJITN0CjN
         fKdQcqdqD2H/ghnE26x+LMgG9CSSiZDqx9Iyl5wg2aSF/efbiGzFsLpulmDmxRvw4D
         xvLoT5lknyI3sUi5Ev9tcgi1oRDKxVFa5+9/ad9kvn8hPn70WcvdIts+W0h5ts+1XJ
         +uv9O0f/qL0biTMp/I/VStwJtGkTfep6BUwHeznkM+BrylF5VxM8qG30eyZ3JN6ALx
         ffC+ofbZ+BvIg==
Received: by mail-ed1-f72.google.com with SMTP id y18-20020a056402271200b003fa16a5debcso9482733edd.14
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 00:28:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=KSGYgxbJHtzmF1VVpegyRa64dLhxDiMx11JnqwEBzqQ=;
        b=D/JtCM/GWd0/rywsIHohF/iOV32MLbBKyXZnXcNtjoLNKPPYfp7E70FNMm73REpmKT
         EnjHFPYwlNy+rG5aFWY12UAFrPbLtzvnLPM4WGFNYXNhWEhCL8b9JCcU10Zvv4s5Wd+X
         YdcbcxYek+vu/zJ70jHLiCOV9VqeZl9SDJBuySyfoYuc7QHqCQYOB2gmNws0k0h6nFMy
         xmQ9boXl6BNehsCSSLUvwECc2qg/jd8Rhs3m/TAFlddxXQW7dh+IwFkD3hWyN1C8Sj/m
         KHg6l0no93PJm39+qV8otOaSipbF1KOYC/c/5MIVTf9gRN8Kq8lOG+nIp/Aq3xVLAY3D
         ScbA==
X-Gm-Message-State: AOAM531lA4Ba0C2hH4ZcPDrPwlCBlJ3ae0pzd0ILgTAAO5IKNgrI4+nq
        94kTJqbQZU1bKIAiXz3ZMcUFtxp68nNr+e1g8yJNr0gO1lccDbxIQFRTq7LcB6Uen6x0XmyQbsc
        UF2WWY1lBm/3o+++KM0RgC7ngMqKBfaYcGg==
X-Received: by 2002:a17:906:4e84:: with SMTP id v4mr15335915eju.285.1641803318498;
        Mon, 10 Jan 2022 00:28:38 -0800 (PST)
X-Google-Smtp-Source: ABdhPJweIKj/IIvkfFyENUkaRCL3MEVzaMQZPMIjQjMvG12GhlNEHGgCw4u64A90ZXuQJlPEXjQPNA==
X-Received: by 2002:a17:906:4e84:: with SMTP id v4mr15335906eju.285.1641803318366;
        Mon, 10 Jan 2022 00:28:38 -0800 (PST)
Received: from [192.168.1.126] (xdsl-188-155-168-84.adslplus.ch. [188.155.168.84])
        by smtp.gmail.com with ESMTPSA id c19sm3193637ede.62.2022.01.10.00.28.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Jan 2022 00:28:38 -0800 (PST)
Message-ID: <8b5cfdc8-e714-422f-6e3f-2e8daeeed81e@canonical.com>
Date:   Mon, 10 Jan 2022 09:28:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH] nfc: pn544: make array rset_cmd static const
Content-Language: en-US
To:     Colin Ian King <colin.i.king@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220109202418.50641-1-colin.i.king@gmail.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
In-Reply-To: <20220109202418.50641-1-colin.i.king@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/01/2022 21:24, Colin Ian King wrote:
> Don't populate the read-only array rset_cmd on the stack but
> instead it static const. Also makes the object code a little smaller.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>  drivers/nfc/pn544/i2c.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>


Best regards,
Krzysztof
