Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3051E2A359A
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 21:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbgKBUyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 15:54:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726447AbgKBUwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 15:52:32 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C024EC0617A6
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 12:52:30 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id w65so12217310pfd.3
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 12:52:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZwEoERCM5ujoro0z9B5jHtM/h0u16bE0c9lNBDoMQGo=;
        b=FYV9DxEe3LESDsPWIJyej96C1k9vpyc48tLQPGjIJLlrjRBxO0eHHs427SSx3nfy+f
         v46hRGb771C1Zdx2FrxkxB2S6OFXoVvh8mhCwQuAEEFgH49yPzzo9stj6K4VRmPZztwt
         wPET9HNDVPgz3ZZKomMHMm8H+fvriot2qbPliZ8gJwU0zAqkaO/nHQDTfl8S1w8Sj/XC
         tlD17BoObOlJXsR8QoBNxnUfuavkuR3QvFyk5gPN3ygxOy17WZL5T20U1kGN7JQ+rc8O
         HOZ5uKwBLuBoazdomDW4NGVR4dya/tEGqtGBXZMR4/Lmy9wJkOYSlGMAJl7exlJzhATv
         sI4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZwEoERCM5ujoro0z9B5jHtM/h0u16bE0c9lNBDoMQGo=;
        b=dObd/sOKJ338UpviySAtv0EfdSmUZ+xoqCZopZpW8S4mIz5rKIcjuwz4931BBXVg94
         dkbPVC/nVCeYMXUm7IWhAwI43KGD9Uh1HgrdeW6B92kLSvQMYKBxpu0W+EAzj4U+o1Tw
         Zzk7duLYD3n0jjynaeo9m/5NEofdd/sAVtEUAPpoFSuvuU1iSMw/rOmeRhVHyeOIqR2F
         OtL3/ezHIV0glSDaBhHPvVvpvBUoVVIiZ+juUCTt5l+XFlxwXSyQhrnGJ2EFGLuLNBDa
         dCTRzwFaSt1eNqJ5xIxKTgOAGukWvZUXqrRxRZvM47WQIvRZYrBWvadTnyeeTIbKevoS
         Np4g==
X-Gm-Message-State: AOAM533SQz0jUBvj0WBtNWrk0sshIFBvpwYgFxGY8H4iXt+o2ng+y0X7
        eNBbIYB5e8qeKAgNfNRYYVo=
X-Google-Smtp-Source: ABdhPJz+La6CPkU93A459wh+FPV7MXp+3zVcSQom8RGKeBFpSb258BeEVsOxff63VZRqsGk7kOv27g==
X-Received: by 2002:a17:90b:994:: with SMTP id bl20mr38848pjb.34.1604350350327;
        Mon, 02 Nov 2020 12:52:30 -0800 (PST)
Received: from [10.230.28.234] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id jy19sm392713pjb.9.2020.11.02.12.52.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2020 12:52:29 -0800 (PST)
Subject: Re: [PATCH v3 net-next 11/12] net: dsa: tag_gswip: let DSA core deal
 with TX reallocation
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, kuba@kernel.org,
        Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>
References: <20201101191620.589272-1-vladimir.oltean@nxp.com>
 <20201101191620.589272-12-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <8fe096a9-6d30-5e54-39b5-b371ed00d1f7@gmail.com>
Date:   Mon, 2 Nov 2020 12:52:27 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201101191620.589272-12-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/1/2020 11:16 AM, Vladimir Oltean wrote:
> Now that we have a central TX reallocation procedure that accounts for
> the tagger's needed headroom in a generic way, we can remove the
> skb_cow_head call.
> 
> This one is interesting, the DSA tag is 8 bytes on RX and 4 bytes on TX.
> Because DSA is unaware of asymmetrical tag lengths, the overhead/needed
> headroom is declared as 8 bytes and therefore 4 bytes larger than it
> needs to be. If this becomes a problem, and the GSWIP driver can't be
> converted to a uniform header length, we might need to make DSA aware of
> separate RX/TX overhead values.
> 
> Cc: Hauke Mehrtens <hauke@hauke-m.de>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
