Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5AD3064EE
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 21:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231756AbhA0US1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 15:18:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231264AbhA0USV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 15:18:21 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88D97C061574;
        Wed, 27 Jan 2021 12:17:41 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id z21so2349231pgj.4;
        Wed, 27 Jan 2021 12:17:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=M5prJnjp+IBjbrnVpwvStmTS1JWaLCOZpjntuh4TtrQ=;
        b=FS9e+VNRM8U8d6RzRe5VpTEqUMb0x79Qmx0A824lxZD+vcKi7fxFdvysuZaNPcuVUO
         elnCtb2NlumaCNjyMOqaeq8DV0q8i7HreBu/jOxSLl/zjErCBDUx5ytKQZO4PNK5ftSy
         eu81OcdYqIjaQTvv9VAoKWyj8OVy9rub5IhKC1JWl3J7D0p0gyEaO6sYL3x043hpoFQs
         8Fe77TXKczm9dIvsWdgDn+uIcvAMwcww6cvajSNgaeESw1bzMe1NYSoIGl1GV7/Q1/C7
         pk+JXun8ZFI7jKnM218k//NW6eEF0XzAw/qu+EU7cP6FHjJKEbjir2Vljdc4qUFdzk5W
         CfWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=M5prJnjp+IBjbrnVpwvStmTS1JWaLCOZpjntuh4TtrQ=;
        b=Wj+jS/yWq/GH/rRNNZqZeH6Fj1OgNRhMenSF+r9c/SOmwpv2754MVfPvjigi5YVYgD
         x8IefOnXVioen96tyQxISCZmloHmbQERe9oHA+NTIXhoCXtpA8nm8yZiNI0TbfPWDNpF
         EYu8+Ce1kHeEYt2/KOUyRqvr1aovvQIdga/QkIzZ5Ulrr3SNsXeTuOQkp2b8QFoaOEpO
         Bp3l04RhMaHONdM7S3r3cOYKBLwTNoqPNdQTA3Guz9rq7vlFwsKYr8LOcOwhkQbQuZ7x
         KyiCu7PmKOwBITzUAXysOqxoJ7797LoSOrwiGLvECSdZwJ2ufIL12x4+io7Y600GklT/
         qkrQ==
X-Gm-Message-State: AOAM530ca25RHtBcHkJ8khlHebnlW+imxsCBBc4fzkwXWq2DKnA/++44
        704/3bCoKJ8McLpM04PdoQ9uS70BWYY=
X-Google-Smtp-Source: ABdhPJwor/F/ypzr1Hwh0gLclmeA13uoJ9YmLIDKqzUBaDCy0RSa0PyZ1JCEHWil5uYIaKIMMTpPAg==
X-Received: by 2002:a63:da17:: with SMTP id c23mr12916767pgh.348.1611778660619;
        Wed, 27 Jan 2021 12:17:40 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 21sm3164059pfu.136.2021.01.27.12.17.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jan 2021 12:17:39 -0800 (PST)
Subject: Re: [PATCH V2 1/1] net: dsa: rtl8366rb: standardize init jam tables
To:     Lorenzo Carletti <lorenzo.carletti98@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Linus Walleij <linus.walleij@linaro.org>, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210127010632.23790-1-lorenzo.carletti98@gmail.com>
 <20210127010632.23790-2-lorenzo.carletti98@gmail.com>
 <20210127190159.s6irvdej3fs4cdai@skbuf>
 <CABRCJOQDLrms1B4TsQonDEUAyXDV22-ufq4eGYZ8wq9KgHVKkA@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <21a30b7b-56ba-29e1-de0e-4d3969360a54@gmail.com>
Date:   Wed, 27 Jan 2021 12:17:37 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <CABRCJOQDLrms1B4TsQonDEUAyXDV22-ufq4eGYZ8wq9KgHVKkA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/27/2021 12:06 PM, Lorenzo Carletti wrote:
> Many thanks for telling me that and for showing me how this works.
> I find both very useful.
> I'll be sure to follow the guidelines more carefully next time.

One of those guidelines is no top-posting and make sure you use a
plaintext format for your emails otherwise the mailing-lists may be
dropping your response (we may still get those responses because we are
copied).

Thanks!
-- 
Florian
