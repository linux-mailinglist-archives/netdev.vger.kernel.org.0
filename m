Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E625214FB9
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 23:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728444AbgGEVIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 17:08:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727894AbgGEVIp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 17:08:45 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48A9AC061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 14:08:45 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id k71so12417874pje.0
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 14:08:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=55rXPoamLkZXNyv4B6Kwl3726eVDSZoRrpsHXn/iAqk=;
        b=QpvbVlmZefB16OuEXlPkaElXpU94mslnew2EoX5c5jHrkZnuMQM/peFLUuc2DImbJ0
         YBP9RRU+oZUFL5mkj4vE6pENUY3q5cdA7t/efA5RtApKVYKUJ6QULNq728qAFUze4KQ+
         rhsmlAjPXYpwun5VDu24gPG8jUkT4UNB6SVIjAyYW5/Dd5xYUBlsY5YXXqs6zxKr9VNt
         rQbNH2NnhkO+X7ih0Tqx+ab9pP6ZXnv25Xc74eVCma2/PiUp85Sz4r0lWD8PwImjeaHk
         YeZ0YpOdVXQsO4EcBenUJ2UBU2/krJ9n54PsrnEgo3ahAgXhTaYw8PjDJgrfuYaLLE25
         ENZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=55rXPoamLkZXNyv4B6Kwl3726eVDSZoRrpsHXn/iAqk=;
        b=bE8IMGGSW9aDRdEytQgIg+F0lrLs8q+R49+XPcIvtfaEXNxCLgfZgz4MSjqZcr/emj
         lt6Y6gIo3D9+70j7lDfk+M1I9bWjSuh62OIlzwHGPUrKechSS1Cixa251Eh5lXtRRMdY
         pqMN3mz9mf1y75g78xFoXHjsS66X+PVdjTNRpqGe/YH43XRhpC4WnhmaOHJKaCEJ5A0Q
         iU4cx3zanQXp+QC3rdyXlWtHFp/MEzR+PT8W+JXvlm8E1ivEn2sQQiWfVQDs+PZWkHJ8
         9zJOvoA/Tz7xng0AJbltGzViDGRNkU8CfRANRxm3GOwtWWp2Y14JpiHKV6vi3YaiF9ST
         DvLg==
X-Gm-Message-State: AOAM531qk2Ctf0WBDrZyCn1tMG9/CcaEhCOw6ncwYnoJ6q8p59stkp1E
        vJ03pXzI8csD3kbOkUesPbw=
X-Google-Smtp-Source: ABdhPJylhdtzi9RHrmMgB9ySoPkEBvgFfGQm3xC5r+qSnWV4SEgZBc0TR8uIf/YiAOZ27S7fkTg9iw==
X-Received: by 2002:a17:90a:20e9:: with SMTP id f96mr49554919pjg.13.1593983324879;
        Sun, 05 Jul 2020 14:08:44 -0700 (PDT)
Received: from ?IPv6:2001:470:67:5b9:5dec:e971:4cde:a128? ([2001:470:67:5b9:5dec:e971:4cde:a128])
        by smtp.gmail.com with ESMTPSA id s68sm17499544pjb.38.2020.07.05.14.08.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jul 2020 14:08:44 -0700 (PDT)
Subject: Re: [PATCH v3 net-next 3/6] net: dsa: felix: unconditionally
 configure MAC speed to 1000Mbps
To:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, ioana.ciornei@nxp.com,
        linux@armlinux.org.uk
References: <20200705161626.3797968-1-olteanv@gmail.com>
 <20200705161626.3797968-4-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <2d957d5d-ec71-7fa9-a49e-220dd6b8c5f2@gmail.com>
Date:   Sun, 5 Jul 2020 14:08:41 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200705161626.3797968-4-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/5/2020 9:16 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> In VSC9959, the PCS is the one who performs rate adaptation (symbol
> duplication) to the speed negotiated by the PHY. The MAC is unaware of
> that and must remain configured for gigabit. If it is configured at
> OCELOT_SPEED_10 or OCELOT_SPEED_100, it'll start transmitting PAUSE
> frames out of control and never recover, _even if_ we then reconfigure
> it at OCELOT_SPEED_1000 afterwards.
> 
> This patch fixes a bug that luckily did not have any functional impact.
> We were writing 10, 100, 1000 etc into this 2-bit field in
> DEV_CLOCK_CFG, but the hardware expects values in the range 0, 1, 2, 3.
> So all speed values were getting truncated to 0, which is
> OCELOT_SPEED_2500, and which also appears to be fine.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
