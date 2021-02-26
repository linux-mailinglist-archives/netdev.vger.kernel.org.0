Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09FD83265EC
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 17:56:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbhBZQz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 11:55:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbhBZQz6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 11:55:58 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99769C06174A
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 08:55:15 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id m6so6648654pfk.1
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 08:55:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cxv8C0tA7k3niyP7HCOXKGtFxBP6/ZQl0VS87bwwRSI=;
        b=YWOf4QRBLidTMdmg5MXd6XSbRxNUfLN2x785KmF+aX0xID4v9WmDaYn9FI7hT8fSz2
         zl0pgAZIaVS5EJBfkFUjjw1YTLjfpojkLffLmbaKmU20kSSvM0At+Pe/dVX0Nw/BMt7S
         9BUrRkEgEFumgLit8xQczJFXGmgtrti7lpthlLbIHI+JbFnFrkqqIhs+pgEBaiK4hixu
         v1CU7mGGDEKQOPehi8/bfhwdi7D60srjp3zeIqSP5sCswyRilfuq4xNLZHgGPniXj89K
         amBNmVfHfhPrdfAzLlpmKqAVE35nP/LK0C1c6CJVGBnL1cGwB0wimqAMAXKWlFDyi+wF
         OKFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cxv8C0tA7k3niyP7HCOXKGtFxBP6/ZQl0VS87bwwRSI=;
        b=Ttt39g6NDyfhqCLQ0/JI3wbdbG/6x68K1DRQw7DwpiApf7laaq4PFc1tPgiuCT3+XL
         ddbgyPcYXcMns4Bqv5ocfdAX4gz2XQvzewop57JzWgVjnhtTN4rBjQwOclhETJ2TP6DL
         VEqSEXbXfZZJOHbVoyy1cyTcApl2aPzS6SHU9+jVS7b1FX6mDGRw8gRNytEPplL6VEa+
         mKIcXdDgMQcsxMe92EwMxKj4Dw/3Sg2+kr3UKH4NKyvOyQJm2K8wLSjf1TjbGS1DubxD
         uu+uINdqw3udwZ/Hn3t6xlYFUvw1sxg/6Jz4NMrueeCx1Auy/GlaoAS0bS75NduPrxj4
         wvFQ==
X-Gm-Message-State: AOAM5314w2ynxTiTrW15E1LLGw+vWMuB3ekx5jwkKZMuk2rlhYA75qWa
        8Njn/D/oFobih7+jRajxbWU=
X-Google-Smtp-Source: ABdhPJx1pj5+QkOIBtU3FqRv8St8TOZurR7Axqxa8VjU9jXax+UNRFaLAUT8rUvYctE4Up6NBFkeQQ==
X-Received: by 2002:a63:54:: with SMTP id 81mr3749232pga.410.1614358515097;
        Fri, 26 Feb 2021 08:55:15 -0800 (PST)
Received: from [192.168.1.67] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id s196sm8278565pfc.185.2021.02.26.08.55.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Feb 2021 08:55:14 -0800 (PST)
Subject: Re: [PATCH v2] bcm63xx_enet: fix internal phy IRQ assignment
To:     =?UTF-8?Q?Daniel_Gonz=c3=a1lez_Cabanelas?= <dgcbueu@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org,
        =?UTF-8?Q?=c3=81lvaro_Fern=c3=a1ndez_Rojas?= <noltari@gmail.com>
References: <0e75a5c3-f6bd-6039-3cfd-8708da963d20@gmail.com>
 <CABwr4_s6Y8OoeGNiPK8XpnduMsv3Sv3_mx_UcoGq=9vza6L2Ew@mail.gmail.com>
 <7fc4933f-36d4-99dc-f968-9ca3b8758a9b@gmail.com>
 <CABwr4_siD8PcXnYuAoYCqQp8ioikJQiMgDW=JehX1c+0Zuc3rQ@mail.gmail.com>
 <b35ae75c-d0ce-2d29-b31a-72dc999a9bcc@gmail.com>
 <CABwr4_u5azaW8vRix-OtTUyUMRKZ3ncHwsou5MLC9w4F0WUsvg@mail.gmail.com>
 <c9e72b62-3b4e-6214-f807-b24ec506cb56@gmail.com>
 <CABwr4_vpmgxyGAGYjM_C5TvdROT+pV738YBv=KnSKEO-ibUMxQ@mail.gmail.com>
 <286fb043-b812-a5ba-c66e-eef63fe5cc98@gmail.com>
 <CABwr4_tJqFiS-XtFitXGn=bjYzdv=YwqSSUaAvh1U-iHsbTZXQ@mail.gmail.com>
 <YDkCrCIwtCOmOBAX@lunn.ch> <ff77ab40-57d3-72bf-8425-6f68851a01a7@gmail.com>
 <CABwr4_s_w-0-rNVmjoHMy-b=vWcJSzSFOyvuJfu7TziBneOHBg@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <ccf012a3-9ab7-39d9-ed2a-465fe12e2233@gmail.com>
Date:   Fri, 26 Feb 2021 08:55:06 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <CABwr4_s_w-0-rNVmjoHMy-b=vWcJSzSFOyvuJfu7TziBneOHBg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/26/2021 8:14 AM, Daniel González Cabanelas wrote:
> I could update the BCM5365 phy_id in the downstream B53 driver to fix
> it and avoid any kind of future conflicts if the driver is upstreamed.
> Accordingly to documentation the whole BCM5365 UID (not masked) is
> 0x00406370.
> PHYID HIGH[15:0] = OUI[21:6]
> PHYID LOW[15:0] = OUI[5:0] + MODEL[5:0] + REV[3:0]
> 
> Right now the used mask is 0x1ffffc00. But if I understood correctly
> it is only required to mask the last 3 bits. This would reflect in the
> B53 driver:
> ---snip---
> /* BCM5365 */
> static struct phy_driver b53_phy_driver_id3 = {
> .phy_id = 0x00406370,
> .name = "Broadcom B53 (3)",
> .phy_id_mask = 0xfffffff8,,
> ----snip---
> 
> For the tested board, BCM6348, the UID is 0x00406240 (read by the
> kernel). But in this case its driver involves more SoCs/PHYs, maybe
> with different UIDs.

Or another way to solve this entirely is to move to the upstream DSA
driver for b53 under drivers/net/dsa/b53 and register the switch as a
mdio_device instead of as a phy_device.
-- 
Florian
