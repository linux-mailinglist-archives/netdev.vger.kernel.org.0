Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6302A3525
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 21:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725929AbgKBUeP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 15:34:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbgKBUeO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 15:34:14 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97951C0617A6
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 12:34:14 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id w65so12177876pfd.3
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 12:34:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=10vxNw+ypTeKOLmhs8IALd1Ix2ks/NpV8pLiVk58YXs=;
        b=mh0UYVw3ZtVreT+HNzl3mpJHRE8xM+LV5NtW2FSd1Qayf7o4dYzqqYUOUmfTJsBzpz
         AdaGUjgAHHVlg4CTEbrih6F2yiqGirH7KD3WCbBX3Y1YcH1/feVij/QPqgrt4kyigLS+
         efFE6Ht3tY9MNjjSiKuxT0xTZyt2N7dxcqMwwqlDidXk5a+uKaiho2A1KFDsQ02P8aLS
         f4KVh4NfDyyK1Dxc6OSuf6f+9hvTTWDYzgCutHXWGpZ23gOokqQsbVFe0s5zhGuzUfsu
         5IqJp7Mw/27z+gFYcC5sOjGUXvXoeXTaPXjtiPUmDETaGWSi0l8TbgPxX4y+KjS4m9VK
         vFBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=10vxNw+ypTeKOLmhs8IALd1Ix2ks/NpV8pLiVk58YXs=;
        b=Z8GFlEPdwYLr4k7LyNs8BMQJ1NAgLQnSE5DFh/2Hq7aqJznU626cctEShJG0e5G55I
         UKhybvi3jRrkv3cw0XAXsBMXHq9uT/v7Q7z7eOJmNn/EmVAsUINcukconNMCPLCd5NSF
         wQPZqpSi0nACYOXDtWMgNptf7V/uqTyMbXoGmDVf/JkgbxKwJEzCEuchev4zaOw3JDZQ
         rVOfAZ7I9u0gi1+Hc462HOQeVUSHTgQv/vHCeuRSaqxP64SoXHDMbiBs/499H9su7dma
         JcyeHrgySAxdxXx86H50UAiX2Tu+5Zr225nG49GIzcxchtfrTAz1rZG3TZa3up6IhRSC
         rfDA==
X-Gm-Message-State: AOAM531jHQJ0mxPF1qkfwsUh9ce2ArLK1SF7jAuYuaQW8wpvqaW/F7EV
        I48cNkwJeFLr52M+5r18ZTI=
X-Google-Smtp-Source: ABdhPJw3tIdEVG6r9/HyfKP+D4445jU+uPEgLSdy8l9viYbbOh6h47TsFAWqSbywCGYEmuNo7cPbmA==
X-Received: by 2002:a63:7f49:: with SMTP id p9mr14473706pgn.185.1604349254124;
        Mon, 02 Nov 2020 12:34:14 -0800 (PST)
Received: from [10.230.28.234] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i26sm5671305pfq.148.2020.11.02.12.34.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2020 12:34:13 -0800 (PST)
Subject: Re: [PATCH v3 net-next 09/12] net: dsa: tag_brcm: let DSA core deal
 with TX reallocation
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, kuba@kernel.org,
        Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
References: <20201101191620.589272-1-vladimir.oltean@nxp.com>
 <20201101191620.589272-10-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <10537403-67a4-c64a-705a-61bc5f55f80e@gmail.com>
Date:   Mon, 2 Nov 2020 12:34:11 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201101191620.589272-10-vladimir.oltean@nxp.com>
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
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
