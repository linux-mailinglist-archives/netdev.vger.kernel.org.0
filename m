Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05E3144B281
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 19:11:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241925AbhKISOC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 13:14:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241893AbhKISN6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 13:13:58 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD367C061764;
        Tue,  9 Nov 2021 10:11:12 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id c4so114020pfj.2;
        Tue, 09 Nov 2021 10:11:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DjhJ6bXPCZmBBgKV1ylUUWdkZx8i5NCv/fQa//DDd+8=;
        b=CFKg7mOF/xTPaFGy3SpEDPDth6/2k7W1xswE7NpZ8JFa4MkOeZmLLUG7wyJpQWQ/nL
         3hiLb6tLPjmv7mg6obg0xEj7PHCj57KZ8J9/+i5uWJxNBgwQrDelsjAJ6YpETmBSWeDT
         tdffozi6shsWuaT9u2GpgUlMaLp8Y+hhqvO1YTavKO3IIR4IosficUUh9mxB+Y/4mg7o
         EjK4dJDRSn/Mtm4o12jZ6v0uxUv89PPw0OJB7KWIrewnItUxfTVX5kYMiZfCYlN9ZvjT
         z1qXzLLoThpBH9tuee4g0o2apwnS+PHJoAZM8wkXA2ngoeO9JEkdTlIObR/uESWWpdSs
         8Fhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DjhJ6bXPCZmBBgKV1ylUUWdkZx8i5NCv/fQa//DDd+8=;
        b=aRBUlCbvYVILu/FHCyl7y/HTpAbqBNSN1LzA3gGMTFSz4D8Jk7lxl1CvVJyL5VlynB
         YsZwSp9JuLL60AoFcEIuJfIkYHAUKaucRs1snwBqXbwdbyTxr9cyqKtqJaw2DcqDDChM
         Ff86y7liHg36nk5b1fRPJPFkWVIrfxu/mECe/77pPwieE8sF5Y9uYgm+58hKcrOE9/av
         LPoxi2o46k0yW8IZuV5jT3IwsStx6E2scc44ratZxs/r1C748h58M93lxqzfj7laxq0x
         Vmmu30idVNx5dh/nhZE5sCQFFi9MXyJCxc+BYWoT7RXKuSGOFGcILhmkwBfJhsDrzDrL
         UPWg==
X-Gm-Message-State: AOAM531enp0WK0ngswXNpaaNuYa6Jnh88dN+05i+eejsdMNcxFhHuPDu
        QEixgoBGH75CWfx/9IMRfC5KdnGS1P8=
X-Google-Smtp-Source: ABdhPJx7eFhy1N8o/K+U2OIRkhkvb/hynTqi4/KFTyEYyYygh1K2uN9cHzdjuolb4bu8F+oEAB/KVg==
X-Received: by 2002:aa7:9047:0:b0:44b:e142:8b0d with SMTP id n7-20020aa79047000000b0044be1428b0dmr9754586pfo.45.1636481471943;
        Tue, 09 Nov 2021 10:11:11 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id s21sm5199301pfk.3.2021.11.09.10.11.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Nov 2021 10:11:09 -0800 (PST)
Subject: Re: [PATCH v2 2/7] net: dsa: b53: Move struct b53_device to
 include/linux/dsa/b53.h
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     Martin Kaistra <martin.kaistra@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20211109095013.27829-1-martin.kaistra@linutronix.de>
 <20211109095013.27829-3-martin.kaistra@linutronix.de>
 <f71396fc-29a3-4022-3f7a-3a37abb9079c@gmail.com>
Message-ID: <caec2d40-6093-ff06-ab8e-379e7939a85c@gmail.com>
Date:   Tue, 9 Nov 2021 10:11:08 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <f71396fc-29a3-4022-3f7a-3a37abb9079c@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/9/21 10:05 AM, Florian Fainelli wrote:
> On 11/9/21 1:50 AM, Martin Kaistra wrote:
>> In order to access the b53 structs from net/dsa/tag_brcm.c move the
>> definitions from drivers/net/dsa/b53/b53_priv.h to the new file
>> include/linux/dsa/b53.h.
>>
>> Signed-off-by: Martin Kaistra <martin.kaistra@linutronix.de>
>> ---
>>  drivers/net/dsa/b53/b53_priv.h |  90 +----------------------------
>>  include/linux/dsa/b53.h        | 100 +++++++++++++++++++++++++++++++++
>>  2 files changed, 101 insertions(+), 89 deletions(-)
>>  create mode 100644 include/linux/dsa/b53.h
> 
> All you really access is the b53_port_hwtstamp structure within the
> tagger, so please make it the only structure exposed to net/dsa/tag_brcm.c.

You do access b53_dev in the TX part, still, I would like to find a more
elegant solution to exposing everything here, can you create a
b53_timecounter_cyc2time() function that is exported to modules but does
not require exposing the b53_device to net/dsa/tag_brcm.c?
-- 
Florian
