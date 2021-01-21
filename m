Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 099392FDF72
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 03:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392622AbhAUCWR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 21:22:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733095AbhAUCLx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 21:11:53 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79871C061786
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 18:11:02 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id y8so382076plp.8
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 18:11:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=INH8/vJ3OhcB2RSNxgXWAuwm27PSWD9on0zC780IiRo=;
        b=HeTFy0bc4PAyXe4ExE8KfDA2/YVFi0+vdIifI5cvWiz3ffsor+2Jdj9YGKc5FYH3ob
         NSGg5/kxkKYjSEPxdnRaG5FDlOwIOy8R4jcLdc9/k2rGcDrnILCf/9SgR4hCPml4HoKr
         0Ydx1U6VMUk72jjVJCRRrpu/hgFP2RLJwyTcST3KdgEKfm/q65cwNy++9Km3IsAtnGdL
         rCSDznOIiCNu1GbHmQ/msDqYDGDGCqi732n9B+pcgMlpmwSbjm/9tUfU2/Cdbcn481cX
         4zy1l74TbJIqyn4TRqgi1304lSjilqmLOJUC1x0Dv2vib7ddku4dXAPYTBvK9I65Xqzx
         Wlqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=INH8/vJ3OhcB2RSNxgXWAuwm27PSWD9on0zC780IiRo=;
        b=S5Rfx33+rWZoIjlbL57mmdoaDNi4UMCFAJqFuIRxOQuW3UFFh80pGTD3cYUXfshe8+
         txICyKTDDp5RIYRNlr+JjQRgCusgUP+ZlyhSE4hXxQs2Qmz+y7tnwXf9+LZHDNUq/fI4
         kEAVORH2CXObtnpMPNLm8ipBP5JPnWl5r6R43CFF8stjcAZSO6gI6/eYzLtcOz0c27BP
         sLNeJJ4OgOoLKKIjGqrKgyW4t6lZqNicEa2wqOVuW6rNdpLoCR/csSAI37jk2YFoWQng
         VJYGG3WkgHLFC3KMGitFIAzehkPuZg3Y43t5f4KGJrLy+7NOSfCUMs0at7drL3G21XSZ
         1j2A==
X-Gm-Message-State: AOAM5331OiwC478lg+Vn1A0pVLblPvF0Lh/j/QS8UZ0Vnh66jG9+1ORo
        glkoNw78rf5ZX0oheLge0dw=
X-Google-Smtp-Source: ABdhPJwaFXWvAgTeV35HJ2us9kkPxt28Q5mLSVpHUdMQcGvTtKDXSqA374bQuEK+hGrQN8+zZudsRg==
X-Received: by 2002:a17:90a:528b:: with SMTP id w11mr8804993pjh.73.1611195061968;
        Wed, 20 Jan 2021 18:11:01 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h11sm3453485pjg.46.2021.01.20.18.11.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Jan 2021 18:11:01 -0800 (PST)
Subject: Re: [PATCH net-next V2] net: dsa: microchip: Adjust reset release
 timing to match reference reset circuit
To:     Marek Vasut <marex@denx.de>, Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Paul Barker <pbarker@konsulko.com>
References: <20210120030502.617185-1-marex@denx.de>
 <20210120173127.58445e6c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <9dd12956-4ddc-b641-185e-a36c7d4d81a9@denx.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <cdc34d4b-b384-2f2c-0b8d-070d54edf3c9@gmail.com>
Date:   Wed, 20 Jan 2021 18:10:59 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <9dd12956-4ddc-b641-185e-a36c7d4d81a9@denx.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/20/2021 5:51 PM, Marek Vasut wrote:
> On 1/21/21 2:31 AM, Jakub Kicinski wrote:
>> On Wed, 20 Jan 2021 04:05:02 +0100 Marek Vasut wrote:
>>> KSZ8794CNX datasheet section 8.0 RESET CIRCUIT describes recommended
>>> circuit for interfacing with CPU/FPGA reset consisting of 10k pullup
>>> resistor and 10uF capacitor to ground. This circuit takes ~100 ms to
>>> rise enough to release the reset.
>>>
>>> For maximum supply voltage VDDIO=3.3V VIH=2.0V R=10kR C=10uF that is
>>>                      VDDIO - VIH
>>>    t = R * C * -ln( ------------- ) = 10000*0.00001*-(-0.93)=0.093 s
>>>                         VDDIO
>>> so we need ~95 ms for the reset to really de-assert, and then the
>>> original 100us for the switch itself to come out of reset. Simply
>>> msleep() for 100 ms which fits the constraint with a bit of extra
>>> space.
>>>
>>> Fixes: 5b797980908a ("net: dsa: microchip: Implement recommended
>>> reset timing")
>>> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
>>> Signed-off-by: Marek Vasut <marex@denx.de>
>>
>> I'm slightly confused whether this is just future proofing or you
>> actually have a board where this matters. The tree is tagged as
>> net-next but there is a Fixes tag which normally indicates net+stable.
> 
> I have a board where I trigger this problem, that's how I found it. It
> should be passed to stable too. So the correct tree / tag is "net" ?

If this is a bug fix for a commit that is not only in 'net-next', then
yes, targeting 'net' is more appropriate:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/networking/netdev-FAQ.rst#n28
-- 
Florian
