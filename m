Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75E303F081F
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 17:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239509AbhHRPhS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 11:37:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230360AbhHRPhR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 11:37:17 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F6D6C061764
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 08:36:43 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id m7-20020a9d4c87000000b0051875f56b95so4562289otf.6
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 08:36:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8TZ2Y+oul8QDiWx6f62RJoAlsez4j19O3ah7Fntx3ww=;
        b=Cs8jOky5gXX8HsUXsrXnla3CNBqvPbFz8HJreXhD1mVQ7gUvXWx1aRv88KJ9bqM4V5
         XwmRH/bVGn8Uisp6dR13BVf6jxrc4zdVKye3CrsOmWMT/60wMuaOxRhJVa5CYfb/GfPF
         yAp0fguMSk04B/vFKUQroa4LoFCK2TuIhTM8DROjH2K4nuYeP54wLoxNSKSYfQ9sD3bl
         ErdjXW9zKt7Fm1IR1szPjq0KWflbijpzK+3hjDBA7ik4jgA2hYvkKco/q9IHXb5r1YWo
         rSC/1axwc9aFTnAz5wbJvAJogc1DHIJh9yGYQRgoPnRtVsrey91bdFb8inxqpKGb2geI
         PU4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8TZ2Y+oul8QDiWx6f62RJoAlsez4j19O3ah7Fntx3ww=;
        b=EVlGOz/160vxYUDq8w1DrW+XqeeBMJtECigaeyN551I1SE0nrx0P9zbeg+TGdrKEKr
         al0mo2+etbvtk+CUVpSUXeKUU7L8EIiKgtzmvq0BWJU95vC/tqVoY0gvKMv8k5DCRzdP
         hSMBV53LGMy+8F7kr39W23T/IReGbSC+fQtq7zRGB0n+MQ6waJFXphBv2tKNvGxFx6oT
         OU66gwNYDcI8lYHoZaAqTz5JQINYHdNi9FI4nk2mTJ2QtCznPXKNpe+xZv4otxCxnHum
         Fqf4ZEsUGGalqytemYruuRUZlbyKj/VGNXGqQdDWUUDADyQQn/YQBJ+62eb+LLh+8iSB
         lruw==
X-Gm-Message-State: AOAM533Nm8EMV1qIYYwCwB0nPIfNroQdAw+filxSIydm7II2TvbqgLtf
        2fBFS+HT1QymXmAEW6WOv0XUPBvA20I=
X-Google-Smtp-Source: ABdhPJyAFvTKMPAsKBC0jPWYttEXc98vfqjuvjgDNMR0Nv8jQe3Ln9ECSkpprG9GQpj232XeI0pXpw==
X-Received: by 2002:aca:aad7:: with SMTP id t206mr7328156oie.12.1629301002148;
        Wed, 18 Aug 2021 08:36:42 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.45])
        by smtp.googlemail.com with ESMTPSA id f5sm81940oij.6.2021.08.18.08.36.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Aug 2021 08:36:41 -0700 (PDT)
Subject: Re: [PATCH] selftests: vrf: Add test for SNAT over VRF
To:     Lahav Schlesinger <lschlesinger@drivenets.com>,
        netdev@vger.kernel.org
Cc:     dsahern@kernel.org, kuba@kernel.org, shuah@kernel.org
References: <20210818085212.2810249-1-lschlesinger@drivenets.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <2c551684-f3b2-0ec5-4fec-46aabaff1bf7@gmail.com>
Date:   Wed, 18 Aug 2021 09:36:40 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210818085212.2810249-1-lschlesinger@drivenets.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/18/21 2:52 AM, Lahav Schlesinger wrote:
> Commit 09e856d54bda ("vrf: Reset skb conntrack connection on VRF rcv")
> fixes the "reverse-DNAT" of an SNAT-ed packet over a VRF.
> 
> This patch adds a test for this scenario.
> 
> Signed-off-by: Lahav Schlesinger <lschlesinger@drivenets.com>
> ---
>  tools/testing/selftests/net/fcnal-test.sh | 28 +++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
> 

Thanks for the follow up!

