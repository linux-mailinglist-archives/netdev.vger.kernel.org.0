Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94B8A31CEA6
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 18:08:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbhBPRH3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 12:07:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbhBPRHV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 12:07:21 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51CCAC061574
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 09:06:41 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id o7so6643857pgl.1
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 09:06:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=60TalLKB3xklb61L3CuI1LLghBzHqmjJ6+nEnXogpFQ=;
        b=i91n9GZn/NY/7613glA0lzP0LNOcK+8IbA58XpaDFmmVUewD39Kr+oI+PMV83TaRe5
         aDuOqTAXunYu9VKatAp4XIqmxu8vBIlGmP9JecZgHTom8Om3w3daC/CSUg7urtGiGfNV
         YpgyaXPe6dcX3xegVRAblBlckX0biQl9enBP8sJmKV6fMB8HL96KsH2gXuZoXBA2zhCY
         d088uOnq/ciuKiIvapNWmoKCKiZqAYkJU+z3kXDhzDi2J1Uu6/m2Itns41++Y5pXy5aQ
         UZQZwKpwq87N5g/pMJHgcGo5XJarTfmE7WkF3P6Tslm+MIhKVFp1yfxuctrCgPor/8od
         +hoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=60TalLKB3xklb61L3CuI1LLghBzHqmjJ6+nEnXogpFQ=;
        b=kGPSofjgI/FjC8zyIunL51hmay6Tiu6EpIb4juI6p2tPGpqtElQ2I5ary5CsoxoRcq
         I8+ER7m8PZn66U2JILspXHqFqJzyaJJ9qbkkwc0OI+3tjVxScEbKlYoqfs5an1oFCWDA
         e8AVQRXkDQEvWJvexyXywBvm944hnm+Olrbt7HIoe7e9qOxcd/20iJcUOdO2fPiNc22B
         geARs3o+E6GmBu928vV5eZDcmCKgJaAZqMspzB7dF7x6tFzTsS1Pbtl/7bRmCx2vdTc0
         wkp+W/59X7Ie4k2Vr0J5LDeZLnBaTT5Muulsrz8NilV0lrCKPKaVEarVDZZrTxypfP7d
         V66A==
X-Gm-Message-State: AOAM531WVtV2/SfZg3zR/HF5T/wPtPdWSf0kpXap/9Lz01g2Ud1R/z28
        airO0NCO30cS+b3ny6t/StI=
X-Google-Smtp-Source: ABdhPJykitCjjx6FsbesG/cauIJlpbtE//3b8DqJpo43pPCQ1VY+av08S/b5cbj1Dobl3pCd2eW54Q==
X-Received: by 2002:a63:c84a:: with SMTP id l10mr20198162pgi.159.1613495200868;
        Tue, 16 Feb 2021 09:06:40 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id c23sm21802111pfi.47.2021.02.16.09.06.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Feb 2021 09:06:40 -0800 (PST)
Subject: Re: [PATCH RESEND net-next 1/2] net: dsa: sja1105: fix configuration
 of source address learning
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20210216114119.2856299-1-olteanv@gmail.com>
 <20210216114119.2856299-2-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <6d992e36-7559-94b0-2a8d-f154bb3b302a@gmail.com>
Date:   Tue, 16 Feb 2021 09:06:38 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210216114119.2856299-2-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/16/2021 3:41 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Due to a mistake, the driver always sets the address learning flag to
> the previously stored value, and not to the currently configured one.
> The bug is visible only in standalone ports mode, because when the port
> is bridged, the issue is masked by .port_stp_state_set which overwrites
> the address learning state to the proper value.
> 
> Fixes: 4d9423549501 ("net: dsa: sja1105: offload bridge port flags to device")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
