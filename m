Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 950A73DB026
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 02:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235343AbhG3ALB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 20:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235124AbhG3ALA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 20:11:00 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07E3DC061765;
        Thu, 29 Jul 2021 17:10:56 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id mz5-20020a17090b3785b0290176ecf64922so18177589pjb.3;
        Thu, 29 Jul 2021 17:10:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KvNrFVgss6eSO6kUoQ3VU0X35CeoRY7KVDc86f4fQm4=;
        b=kOZQR14Uy3g//5gbl3xlpGsDHTkZtnRt2eygeLvJGcHjKB5XzT7Ldokpq0NHg1qAFQ
         xrUuJh8cOjV96IFiAb3OEqVzDWXY9A9Iz4H+WomwEZv8pWvjbfnAGH/WBA0megaHfwAb
         FrZmi2FAWLjncp47tvP1GZz6eGYY3U0P/lCKl8QgOFdgFjhPely2k0UWryrc85QzoocQ
         nxpsUlu9rex7WQydEd8E2OP286Wjz5qgZt5sbHFjX6+q3MgLSpSZBwlrr445ZibTmdHB
         qMvuvtM3WGGw1NEYtucOdcPeFgMgOFEVG362GtLpgC47HKmy1NEok10Kr4JNtYkChDnx
         FZaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KvNrFVgss6eSO6kUoQ3VU0X35CeoRY7KVDc86f4fQm4=;
        b=kNjqOfQn9RyZNWaeWDtzz2ncEeCOKi0Wb2wusHK0StHso0yGJmW9HItrvHwbf7vDcn
         9QK2fTjYTA6lN5ABXonMWmusvnDoPpFgaCoF2NkRsRLQSg17AMFvlQgGNFkeVOc5JRZm
         caYoTQjhWyj4foz452/QKUP6rZFvyczJCy4BHXhmBUawfYfkFuK5AA+byVLYDaON/UOF
         l+SCS4O1dgEFZ4/W9zh6RJQPKkzxT1jFTPa+lOixr0+LzMZrzpviTidzxcoKKh3PdusY
         0jM4uFUlmH5wDVdusDUoYO87lqTuIdNLXOuTm0WvwAsdQfWshVr9a6+P43ZRTEIn3LV9
         z3Aw==
X-Gm-Message-State: AOAM532hpkQyqiD1AcmGkZ/d/zQ09jZtPHPWwwpD5mQr8mXv6qkfSP+K
        bAxBVoG16n2oiUSB27LTD74urXV/wSU=
X-Google-Smtp-Source: ABdhPJwE/niSh5UdF+w0QQdfBSjFatj+JALFmIVOdTcLe3nO62DxPf2VNDgpH154QI9H1E+xrQvSqA==
X-Received: by 2002:a65:42c3:: with SMTP id l3mr698563pgp.377.1627603855087;
        Thu, 29 Jul 2021 17:10:55 -0700 (PDT)
Received: from [10.67.49.140] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id f15sm5154339pgv.92.2021.07.29.17.10.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jul 2021 17:10:54 -0700 (PDT)
Subject: Re: [RFC-PATCH] net: stmmac: Add KR port support.
To:     Daniel Walker <danielwa@cisco.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Balamurugan Selvarajan <balamsel@cisco.com>,
        xe-linux-external@cisco.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20210729234443.1713722-1-danielwa@cisco.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <81fca68f-e0c4-ce02-6b2b-e5c22a0c3152@gmail.com>
Date:   Thu, 29 Jul 2021 17:10:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210729234443.1713722-1-danielwa@cisco.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/29/21 4:44 PM, Daniel Walker wrote:
> From: Balamurugan Selvarajan <balamsel@cisco.com>
> 
> For KR port the mii interface is a chip-to-chip
> interface without a mechanical connector. So PHY
> inits are not applicable. In this case MAC is
> configured to operate at forced speed(1000Mbps)
> and full duplex. Modified driver to accommodate
> PHY and NON-PHY mode.
> 
> Cc: xe-linux-external@cisco.com
> Signed-off-by: Balamurugan Selvarajan <balamsel@cisco.com>
> Signed-off-by: Daniel Walker <danielwa@cisco.com>

You are not adding KR support per-se, you are just hacking the driver so
it is happy with an unspecified phy_interface_t value and assuming
1000Mbits/sec, this is not going to work.

Just add KR/backplane properly or use a fixed-link property hardcoded
for 1000Mbits/sec and be done with it with no hacking, which would be
just way better than what is proposed here.
-- 
Florian
