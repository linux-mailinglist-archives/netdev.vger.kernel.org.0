Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DAA5483982
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 01:44:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231467AbiADAor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 19:44:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiADAor (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 19:44:47 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2228DC061761
        for <netdev@vger.kernel.org>; Mon,  3 Jan 2022 16:44:47 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id z9-20020a17090a7b8900b001b13558eadaso39117923pjc.4
        for <netdev@vger.kernel.org>; Mon, 03 Jan 2022 16:44:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IgljEHbZCetta8CT31CEBSYSqzETaugD3UFSCq2QH7o=;
        b=UJEsL8bQw5v4c9MVoCsd1ApwL+rR84R5w+7vKF5f79iIl2qVwXjVJZdvZ02hm0sZii
         xSKmpyEc9UkrmomymHO+omzmlyljPsfZqbhTxUSuY+MsPLzMH3sEyXKMgoxcD8nC1tyk
         SyalraYi3eaKpHVpCeq1HWiDEop1/PafWWB/6Ee3W6MTEjsEj2ORP8i/S7zWgJ2L2z4b
         cbVa5NvTMWeGt6FhTobr5/xIxOgLDj+OFjgyVs9bfS90CszgWjZC+zwPpf8M5jpRHe/2
         JU7e/tiZm5Y1dJQYbppwOL5zgQBWL8QymFsWU/OEJbC39wAinEQ6m+FCSgnX1BANx2rk
         yjIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IgljEHbZCetta8CT31CEBSYSqzETaugD3UFSCq2QH7o=;
        b=hhzF6cSGXshY3AKIiY0Cx9PiH/njWSJiZAF47s2L/ubhlmM2ceQA3Yn/YQnbIkH/0p
         il5vfITWPb4F8s/mr07n0kOsxDv8vaCjmpc7QSIeYybocUT0JkIIincJi2f3P2OBJWs2
         r20uN7UlbgMi/nBIcSB5uZGgRPzSvV6sifr+DbXM0+j7EyftvA3VG6kfIyzcQ1O2hKrt
         kdKHH88W6JE/6sN/NuIdKDrIq6e+/4ZXZVm64GtwBCR1gFgO3VgOxEfVegwvyDQnaGBF
         KDXL22tJ79xV5d0LjvTjk7o84E2ztu6iVpTtCkG81+YAoXlVJyKeUo1Rb23mvgEp/BUg
         ktbw==
X-Gm-Message-State: AOAM532oNrK2Gq8PwKAPAm4eqp15k0oK+O1gOncZHMzan9DH9w4Pt1wS
        M82U683GtXBBS7XXEHZHJnVZvg==
X-Google-Smtp-Source: ABdhPJw/WbkX4DbW3YH3VcxMfHIQB2WPSJKGhF1WW5Aip2cCF1ti7+VV15g7jP9TO1KAZFC0bNa1Cw==
X-Received: by 2002:a17:90b:3ec4:: with SMTP id rm4mr55434086pjb.104.1641257086504;
        Mon, 03 Jan 2022 16:44:46 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id oa2sm41467687pjb.51.2022.01.03.16.44.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 16:44:46 -0800 (PST)
Date:   Mon, 3 Jan 2022 16:44:43 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Ivan Babrou <ivan@cloudflare.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@cloudflare.com,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net] tcp: note that tcp_rmem[1] has a limited range
Message-ID: <20220103164443.53b7b8d5@hermes.local>
In-Reply-To: <20220104003722.73982-1-ivan@cloudflare.com>
References: <20220104003722.73982-1-ivan@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  3 Jan 2022 16:37:22 -0800
Ivan Babrou <ivan@cloudflare.com> wrote:

> The value of rcv_ssthresh is limited to tcp_rwin, which is limited
> to 64k at the handshake time, since window scaling is not allowed there.
> 
> Let's add a note to the docs that increasing tcp_rmem[1] does not have
> any effect on raising the initial value of rcv_ssthresh past 64k.
> 
> Link: https://lkml.org/lkml/2021/12/22/652
> Signed-off-by: Ivan Babrou <ivan@cloudflare.com>
> ---
>  Documentation/networking/ip-sysctl.rst | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
> index 2572eecc3e86..16528bc92e65 100644
> --- a/Documentation/networking/ip-sysctl.rst
> +++ b/Documentation/networking/ip-sysctl.rst
> @@ -683,7 +683,8 @@ tcp_rmem - vector of 3 INTEGERs: min, default, max
>  	default: initial size of receive buffer used by TCP sockets.
>  	This value overrides net.core.rmem_default used by other protocols.
>  	Default: 131072 bytes.
> -	This value results in initial window of 65535.
> +	This value results in initial window of 65535. Increasing this value
> +	won't raise the initial advertised window above 65535.
>  
>  	max: maximal size of receive buffer allowed for automatically
>  	selected receiver buffers for TCP socket. This value does not override

Why not add error check or warning in write to sysctl?
