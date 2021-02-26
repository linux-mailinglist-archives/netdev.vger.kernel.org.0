Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C02A32640E
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 15:29:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbhBZO3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 09:29:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbhBZO3k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 09:29:40 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B594C061756
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 06:28:59 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id w11so8750292wrr.10
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 06:28:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=03keCITZIsf2j4gL7PRAddwSsgboZgMK2R/5ga/vhcs=;
        b=tDzmHBfCWllW6rc0Txuxej3zGzleD6tVRSOdIEKifXNC17PxNYKInb11eHhmg78fg2
         kVqQznzI8aa73YA6LITm2ynX6UKOGNPq7QdRTkoGsP4TC4oQTPjeW6m56RKWJyzu/oLn
         /RPO5lAwcjX6447eAnUzJKaAFjfa1y/Ehz8CDRFO6vamSv2AYa5RwOOprLWqWJyMbXfO
         0a0uIASWwxVDmwE3tYD0+cS7XbLKn8usK+UGMyVb689K6poJ0PTwSMVUHIpKlIMGwHfe
         pHEdOMSI8r//Dhxy1eluiyt4W8rJ8AbZo0DZTSHhtGQYTWDxv+VzqKcPNbMkAlwNAaJ3
         bdyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=03keCITZIsf2j4gL7PRAddwSsgboZgMK2R/5ga/vhcs=;
        b=toyCCKFj6nbHEMqTGvniMV46QW2SsquciqbyaRObAibzVkgX5e0u7mQ9PnpV7v7Uvp
         k5wGuLLsDPh/8jYkxoWXU76KCRU+Oq3qnnv6d+IqU0w/bberkyATAD4HaGFKovMhVQzC
         uGOlLL9/VJhzcSuCH5ZBxplOFetn3kIbP7Bzg5wZ2TOcXz+/BMRA/+3fFK2gGa1vueGs
         v4z/qvo9Ij0FGNqo2o6+XvwMX2msYPuAarw8Sj0ntmGGJYc/OOdvBstyOQcYt7Uz7QW8
         Uy+ndCz/imbCkGN82vHK+9hq7IpQodxYELHHmX2RMH0li86l+KX/RKj9o1UgcPoz5hEE
         HXJA==
X-Gm-Message-State: AOAM531MFedfJNmYfn2CGK+QSzX40efXcIoiYdXTVMSh9FJLo9RCPdpN
        tUKWYazeb+BTQ8C/qlaAvME=
X-Google-Smtp-Source: ABdhPJyNTC3Yj1EgHnvuAoS8IkDmU3Y6ydeAQGgmJVGqdCvRtfZz7kVsTp0VdVLJkyMLHIJkDbCarQ==
X-Received: by 2002:a5d:67d0:: with SMTP id n16mr3471203wrw.208.1614349738209;
        Fri, 26 Feb 2021 06:28:58 -0800 (PST)
Received: from ?IPv6:2003:ea:8f39:5b00:3483:8cf6:25ff:155b? (p200300ea8f395b0034838cf625ff155b.dip0.t-ipconnect.de. [2003:ea:8f39:5b00:3483:8cf6:25ff:155b])
        by smtp.googlemail.com with ESMTPSA id e3sm5733111wrt.12.2021.02.26.06.28.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Feb 2021 06:28:57 -0800 (PST)
To:     Andrew Lunn <andrew@lunn.ch>,
        =?UTF-8?Q?Daniel_Gonz=c3=a1lez_Cabanelas?= <dgcbueu@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
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
 <YDkCrCIwtCOmOBAX@lunn.ch>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH v2] bcm63xx_enet: fix internal phy IRQ assignment
Message-ID: <ff77ab40-57d3-72bf-8425-6f68851a01a7@gmail.com>
Date:   Fri, 26 Feb 2021 15:28:53 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <YDkCrCIwtCOmOBAX@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26.02.2021 15:16, Andrew Lunn wrote:
>>> OK, I see. Then there's no reason to complain upstream.
>>> Either use the mainline B53 DSA driver of fix interrupt mode
>>> downstream.
>>
>> I agree.
>>
>> This b53 driver has one PHY with the same BCM63XX phy_id, causing a
>> double probe. I'll send the original patch to the OpenWrt project.
> 
> Hi Daniel
> 
> There is a bit of a disconnect between OpenWRT and Mainline. They have
> a lot of fixes that don't make it upstream. So it is good to see
> somebody trying to fix mainline first, and then backport to
> OpenWRT. But please do test mainline and confirm it is actually broken
> before submitting patches.
> 
> When you do submit to OpenWRT, please make it clear this is an OpenWRT
> problem so somebody does not try to push it to mainline again....
> 
> And if you have an itch to scratch, try adding mainline support for
> this board. We can guide you.
> 
Daniel has two conflicting PHY drivers for bcm63xx, the one from mainline,
and one in the OpenWRT downstream b53 driver. Removing the mainline
PHY driver would resolve the conflict, but the OpenWRT PHY driver has
no IRQ support so Daniel would gain nothing.
I think best would be to remove the duplicated PHY driver from the
OpenWRT b53 driver. Daniel could try to remove b53_phy_driver_id3 and
re-test.

> 	Andrew
> 
Heiner
