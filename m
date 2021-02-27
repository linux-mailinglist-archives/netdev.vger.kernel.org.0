Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3017326DEA
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 17:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbhB0QkI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Feb 2021 11:40:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbhB0QjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Feb 2021 11:39:16 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B35ADC061756
        for <netdev@vger.kernel.org>; Sat, 27 Feb 2021 08:38:34 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id o10so8227460pgg.4
        for <netdev@vger.kernel.org>; Sat, 27 Feb 2021 08:38:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=d56DxOKz7cxr7YQl7owpG4Mf1URQ6/jCL6u5Ycy0PQc=;
        b=Byhre8PQMwPaHSEnCAXfaQk66x43lhSD27wUzIqG76M39ctYY5EVu9EdBGQok+2vLv
         KyYlroB6szAydLwfAIYBtwwq8Hidz+DyjVZGOstsz5maDpuFHggZXXEKcT3GMBetY9qg
         y0K//LHs6FHHETNVO+WTqOeNCOBxv9rweXuhRhqdI9AYHhCXr/mnff+wjFCgc4BM7Cr2
         thfHtQQVZJsYbzwZcRRdsJsbglChmFzofclxzM/2ttl+3PqaBpkUnWbEwAs8E7t3yuSZ
         1TgpRo4OuwMH4ypwKKHkYeku4GZQDjsWouE+4EZx5GaA86LbDflNqAVv5YmWpeQkQbg/
         xkiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=d56DxOKz7cxr7YQl7owpG4Mf1URQ6/jCL6u5Ycy0PQc=;
        b=kCkDzr4ZfoniOxclXIq9RA5pRakTLPuB0T4KdJr17XIRi+e2UuxSwNYQkZB9LtpVmI
         8737TiY3iMw0zzNPDGGYLtL8mIpscQGWFF9wLJJlegrAaGF7QO4tMtDruYBAjq0E45Sb
         Gc6tED0Bvi4xH+f5N+Fokr3j/g2vQqOiYtTbxLWZQYxs3C0yh85eiAoDqqgOIBdNqswX
         4rnJU3wP1D8FV3wrwDep/Sa4tRHknbCcSjFi2MURsR+kmMxo41LF+121I0/7oDElw4Sq
         2q0qDgHpdwSq/0n3W6fgvTEff6netgwghevMOjdTkvRNeYiVJeXcKGwgL7qz30SG3Qxn
         yI8w==
X-Gm-Message-State: AOAM533NBrezvUrQDBR3wfkLL8sDcVNigyErS1aKXaL4dDllPudJtm9Z
        G2HF5bow5tyVCmwCnJgBoG1pqP0+tbw=
X-Google-Smtp-Source: ABdhPJwmmtPHKhe1FXwMcbjIUtmRDuAYu9EaxlNGM2UCL0Pqku8nA00BO9ZOEQHrYz7RwdvS6g27Ig==
X-Received: by 2002:a63:724a:: with SMTP id c10mr7406079pgn.124.1614443913972;
        Sat, 27 Feb 2021 08:38:33 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a2sm12817018pfi.64.2021.02.27.08.38.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 27 Feb 2021 08:38:33 -0800 (PST)
Subject: Re: [PATCH net] net: broadcom: bcm4908_enet: enable RX after
 processing packets
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20210226132038.29849-1-zajec5@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <f85294f6-be06-5cc1-b307-f2c5d6ce7ffe@gmail.com>
Date:   Sat, 27 Feb 2021 08:38:24 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210226132038.29849-1-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/26/2021 5:20 AM, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> When receiving a lot of packets hardware may run out of free
> descriptiors and stop RX ring. Enable it every time after handling
> received packets.
> 
> Fixes: 4feffeadbcb2 ("net: broadcom: bcm4908enet: add BCM4908 controller driver")
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
