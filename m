Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB70242A94A
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 18:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbhJLQXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 12:23:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbhJLQXD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 12:23:03 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F7E4C061570;
        Tue, 12 Oct 2021 09:21:02 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id q5so6287822pgr.7;
        Tue, 12 Oct 2021 09:21:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WRpNhhyEsxgaLh0fASnMBFLgkAmcTdvzguyPmm9OqDg=;
        b=J4fCsNtX/1quYVdelF9KtRDOwx4zHYwydpj6KRsSlsnyiaZG8tsOl1X1LtT8D6/0OZ
         gxW4S8RMyklVO4bWkNs957om/J2OKNoo5RKwkMTyZnG+VEWf+nswmvE2ljEFbyrZmRzS
         fjlLg4xk33CrJpn7XuO0UJUE+7wYJIxCnlAXKaEUMxKYFhY4Eoflgq62PUNWRz0tX6bk
         7lKP9TFvXKnbUH3+8LEKAqaTlaYfO0QHyqQeY95Klapw8q46xBY7/ufa1/5iTifCFu2u
         gjyKB4DUwHBJI2YBmnc9IWmJUmwQ8L6Nf+VLUpkoRdQGGxgVnVFEaNJZNU0VD3sRw7Nd
         +bTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WRpNhhyEsxgaLh0fASnMBFLgkAmcTdvzguyPmm9OqDg=;
        b=lrSDr72J0quA2Yc/EdlrXt8BEQBMLsguFNogWKUQVaO5GL14CgWGkpJKFYb4jkTrGj
         fzUdBa9xvGaR3UwNDx55yB4gqi8MJ9aINESxEQfCk6MR0AOe0vzQySLVwSGLLm/GJWfW
         0isxLKXU577zKUil7CUDth6kbDBVrLztugmziCcnPMS/vfHo3ekN/O69FTQG2Cc8cReL
         evTd6rVzoBXydjzqnXcy/gfnPbJ/aBgX6mvWi8hMlczI93qHwN4z6MCbcRnIDPzemx/T
         VgZHi3300dMcPtPzYHJbZdAy8WEB1pFyvnd/X2g+2EK5/sWBc9NmrqsDVh+cyQbA1cRS
         Ruww==
X-Gm-Message-State: AOAM530MAgUbFSha+zcaXMTK9v5t16Ky59333Z2IqLvjlYyYMz0YVQAB
        r2vdxnYpZksCWZSFXnIEwlDPBkCQvME=
X-Google-Smtp-Source: ABdhPJzjsBxV0HMf9sO5GxvecztNyE/Mg0A0nJl/rgl8ucsz0exAbcSiMzkDYU0eMQ5wGFbNz7kc0A==
X-Received: by 2002:a63:fe03:: with SMTP id p3mr23688929pgh.289.1634055661129;
        Tue, 12 Oct 2021 09:21:01 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id mp16sm3419234pjb.1.2021.10.12.09.20.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Oct 2021 09:20:59 -0700 (PDT)
Subject: Re: [PATCH net] net: dsa: fix spurious error message when unoffloaded
 port leaves bridge
To:     =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alvin@pqrs.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211012112730.3429157-1-alvin@pqrs.dk>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <1cb43a3f-4351-9d2b-58fd-5c62733dc339@gmail.com>
Date:   Tue, 12 Oct 2021 09:20:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211012112730.3429157-1-alvin@pqrs.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/12/21 4:27 AM, Alvin Šipraga wrote:
> From: Alvin Šipraga <alsi@bang-olufsen.dk>
> 
> Flip the sign of a return value check, thereby suppressing the following
> spurious error:
> 
>   port 2 failed to notify DSA_NOTIFIER_BRIDGE_LEAVE: -EOPNOTSUPP
> 
> ... which is emitted when removing an unoffloaded DSA switch port from a
> bridge.
> 
> Fixes: d371b7c92d19 ("net: dsa: Unset vlan_filtering when ports leave the bridge")
> Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
