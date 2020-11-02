Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F05632A35D1
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 22:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725983AbgKBVNS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 16:13:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725841AbgKBVNR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 16:13:17 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE205C0617A6
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 13:13:17 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id i26so11855096pgl.5
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 13:13:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1FSEqXSFqbk/1d5hCO6ZNVQKcuS1H5Ajn7HwA2HcGFU=;
        b=veP3DJUcbSsWbygJ4h5TTjfXmSBQ5dM7s3C8PaWDxtAseehZMyL5S519omTBD2kVdT
         UvTvbqnlNh3cxLPNhKWVd+zvVMTv0HjILvo7zJ+lPXPmiR23iUZ4FP2ybrJUlEkukDE3
         TW9Me8vsfHxKodHNSdqpdw0bgpXMuKTCAzd9yOoI0JR3ChaN33oM0Yq13R6Fu8Ux/ra3
         jXbZBy93KA5dq+FEr03v5zqJIXJXCwF3ImmffOtRzx2hb60R2xkD+MM95smXFtMg2NV9
         q6pFn9LTjcKQiMFKuLprJ8zaehXxMa1izSrZvj3CgkvxNuQseyD/QdCQGZzhi9bpuwR0
         y1Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1FSEqXSFqbk/1d5hCO6ZNVQKcuS1H5Ajn7HwA2HcGFU=;
        b=K1nTicazWn6WtZk0xg2KQ/UDxHE3b4IZ2fr3Rxh1dxTOSB9HBI5ZYk5WJZ8jvLE5f1
         94Y8FqtwM0Duaz9QwtNIF97e8XUkb6Z1q0c9V0scnUtl2T1RA/e39PWa3c9q7xB63tOT
         19MPNm2175iSofi9YcjsMP/SyMOzgv6JSszWa1alUi6UMJFXS9WmrUHr2M2H3UGCsozN
         a/U0D1CTyfvveJaiCPNb4yDrI+UprTdNx9aZW9ugxvEDeST9IjDI10bTIbvnylNQV5Vf
         KBwJofmzr7bL0oSt11hbLEDQBplnJKGd3jBzn2SsCwU+9j9s7CPsITSGhv+39PxENMg7
         n7eA==
X-Gm-Message-State: AOAM530pyu8ZHHdRvD7PlDPZmSUrbne+8bY9q6bNc1xDI8VvU+xlDDh8
        apjkjXzA3DTiSS4VapDeW/p49lccLO4=
X-Google-Smtp-Source: ABdhPJyOp+CGXPPp89K44Gy+zUR2smeyg5aZEv9tXuja2MkL8YdRjZx65sP63469AjRCVJdO68n/XQ==
X-Received: by 2002:a65:6201:: with SMTP id d1mr337556pgv.156.1604351596987;
        Mon, 02 Nov 2020 13:13:16 -0800 (PST)
Received: from [10.230.28.234] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 10sm383866pjt.50.2020.11.02.13.13.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2020 13:13:16 -0800 (PST)
Subject: Re: [PATCH net-next 4/5] net: dsa: use net core stats64 handling
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <25c7e008-c3fb-9fcd-f518-5d36e181c0cb@gmail.com>
 <d5091440-3fe2-4d14-dfed-3d030bd09633@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <d1166c21-245b-ba3c-c560-5535877619f9@gmail.com>
Date:   Mon, 2 Nov 2020 13:13:15 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <d5091440-3fe2-4d14-dfed-3d030bd09633@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/1/2020 4:37 AM, Heiner Kallweit wrote:
> Use netdev->tstats instead of a member of dsa_slave_priv for storing
> a pointer to the per-cpu counters. This allows us to use core
> functionality for statistics handling.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
