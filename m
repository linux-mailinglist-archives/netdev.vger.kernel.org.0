Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C20C32FABED
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 21:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388305AbhARUmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 15:42:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437958AbhARUlc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 15:41:32 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBF6DC061574;
        Mon, 18 Jan 2021 12:40:45 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id b3so10886738pft.3;
        Mon, 18 Jan 2021 12:40:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fwAQFJhObfa7QSS1dGjWaJeUQJXlIyax8y6PCryLoDo=;
        b=dDIFYIpseNfrsYS24pxxcBcGi6L1TwyLHvLHMYU4S+zgiqz6Eh9uysly9DM3lLahZv
         7045M7DBlnNeuikx1FQHqi2u19LshX5Sr8OWOPNolKbiSDJLcAwV9ZCJLLVKPu/QWCWj
         uZH/NVYJ1ZvmmobLqUlhwJQ7O2vPeAqsy3bsRZFY/kZwfyyZ+Wb/cnq4BUVrDOeUSojM
         0Tghvh+hp4gJ85coAkIQPZvXykAiAl4KweKTXVbNrQ6WMxA+Eixu3wZ9bn2eantovfDB
         U3DcQIaFdIyNuprwQK7t/w0CyXvcY/VQgVoxMCNUZZoqmfiPVhNbAQ+t2ArAPwbeCCVk
         97iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fwAQFJhObfa7QSS1dGjWaJeUQJXlIyax8y6PCryLoDo=;
        b=giKg5oqsHJEcW9dSKahfVlSRBOq2vRfVEacpkWc/BAPIbSeXKz2978VX/VT28aC8gY
         rWZNHW+uHTjDadDC1n2gbY4ryOsPGf3enGOzIMHGmc+CtjyMBwWtdfaJ7kLX6YWdCaFa
         8bpGaylFf+lDTV76zrTOGVD7MELl4ogBpPV4C0WBzxx7bDfN0KI1jnTPmP4wULTjK6rp
         slTRe8/ln89Zltx4aKAc770BEQcUDPYy3Rv58ze7cfRz07R4oI6XZHELyPTih6shC3Wl
         vV/OWC1LeRoVOGld6NN0JtlP9kf7+Q8RXw7/kQOB2efvOI73UU3+LSEm1P3kTlAgHQ03
         V+3A==
X-Gm-Message-State: AOAM533SzpobSfYX2E1jawUEarKXZoJ+a8cafs9uRoO2+c/NhfJ+Nq8b
        879eWllXkhzMfxj+wNFsoixmu7/BNo0=
X-Google-Smtp-Source: ABdhPJxIF9/LPwWGOdqniZXsqIrWna1N97RtfipR1GbexaNJ/mcQ0cTyecRLYXyBDplYJENdkRUdmw==
X-Received: by 2002:a63:e049:: with SMTP id n9mr1312571pgj.339.1611002444900;
        Mon, 18 Jan 2021 12:40:44 -0800 (PST)
Received: from [10.230.29.29] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 3sm17476467pgk.81.2021.01.18.12.40.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jan 2021 12:40:44 -0800 (PST)
Subject: Re: [PATCH net v2 1/2] mdio-bitbang: Export mdiobb_{read,write}()
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210118150656.796584-1-geert+renesas@glider.be>
 <20210118150656.796584-2-geert+renesas@glider.be>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <1c7f5e04-d914-3b96-f412-6d355e666012@gmail.com>
Date:   Mon, 18 Jan 2021 12:40:41 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210118150656.796584-2-geert+renesas@glider.be>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/18/2021 7:06 AM, Geert Uytterhoeven wrote:
> Export mdiobb_read() and mdiobb_write(), so Ethernet controller drivers
> can call them from their MDIO read/write wrappers.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
