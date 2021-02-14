Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82BE731AEAC
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 02:26:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbhBNB0d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 20:26:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbhBNB0b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 20:26:31 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BCC0C061574
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 17:25:51 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id l3so4124877oii.2
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 17:25:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HVQB2fEvqI8A7GX2c234n/H8YW9TwHUVfQZQ+ajiHgc=;
        b=t7nIKmJy4P29xI/6yyUjTm3AcAsDIGJTszC7G4k2Ry0/Lpabc6QkAGW+2PfmAc2Cgh
         JdJ37xO/ACF6MEgvWO4lzRn2LkapWsXa78+xncoWLhTsw98yoyMBH6EDg1ZEW5yyHN+G
         XswOQxz6jmtSB/ENANOHSBb/lW+5kF7nh2OxAZl/J7NkQU4bI3Cp1U4p5kRo7EUBVBhx
         t5LmgrThgusuI0q9AFo2y6kjeaxwn2V6/PO3E+2EY9XIxWiVcyuNm0aqhfJGqi8NgbmE
         1U68+IoRdL3dGZVQWjfPLzL65hrfqRfXarrgH5AUoeuhiOADIb+1OHRw//11WCAYCEqX
         Y6XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HVQB2fEvqI8A7GX2c234n/H8YW9TwHUVfQZQ+ajiHgc=;
        b=gTTZluZeu5DgtAypqTWqgxPDkHqr4lNEoEah8pD/sqc1TbIeSZDxDHJpoWt+rpcpLP
         xGJ7Iinup1tHrFjauOKXBv6efwVWnuVceemiA+Y6Lx6KSvbhV8cvp3SsrQRSHU47BN18
         lZHZSUdE9DOu6W9z3J35pcBONt56Y75BbTZoBeYVjXsmy0h71cDpqwBwEEGBgaylNR9c
         1amZG4CgO5nMgs/UXtHlObTHSDblnMPKnXQ1VxSXFHqv8Gv8gOKR5CfgBX98ZN3XtnKN
         N4VrQc2EoseSyIyrCfyQwykCKTevFcqvX7ts4uuCI737ERIlXPx3GRNhO70UM4g5XvAn
         pnXQ==
X-Gm-Message-State: AOAM532xaoMCboRI/5D60HVIehJyyY5MJ82Gp9lce5KPgVjJQyxT5XnL
        sogYWxZG+uhvNeeHYHncDpY=
X-Google-Smtp-Source: ABdhPJxyFaxzeheatXxm978uFjx50jzpzMbtNb20CrrjkhciwV5Ibzeh8YMpKYvoGpRBlDcjJlYHug==
X-Received: by 2002:aca:600a:: with SMTP id u10mr4143576oib.36.1613265951005;
        Sat, 13 Feb 2021 17:25:51 -0800 (PST)
Received: from ?IPv6:2600:1700:dfe0:49f0:e93c:cbea:e191:f62a? ([2600:1700:dfe0:49f0:e93c:cbea:e191:f62a])
        by smtp.gmail.com with ESMTPSA id x10sm2822218oic.20.2021.02.13.17.25.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Feb 2021 17:25:50 -0800 (PST)
Subject: Re: [PATCH v2 net-next 07/12] net: mscc: ocelot: use common tag
 parsing code with DSA
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        UNGLinuxDriver@microchip.com
References: <20210213223801.1334216-1-olteanv@gmail.com>
 <20210213223801.1334216-8-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <5073a654-1fb2-37f1-887c-771fa06a94e1@gmail.com>
Date:   Sat, 13 Feb 2021 17:25:47 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210213223801.1334216-8-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/13/2021 14:37, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The Injection Frame Header and Extraction Frame Header that the switch
> prepends to frames over the NPI port is also prepended to frames
> delivered over the CPU port module's queues.
> 
> Let's unify the handling of the frame headers by making the ocelot
> driver call some helpers exported by the DSA tagger. Among other things,
> this allows us to get rid of the strange cpu_to_be32 when transmitting
> the Injection Frame Header on ocelot, since the packing API uses
> network byte order natively (when "quirks" is 0).
> 
> The comments above ocelot_gen_ifh talk about setting pop_cnt to 3, and
> the cpu extraction queue mask to something, but the code doesn't do it,
> so we don't do it either.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
