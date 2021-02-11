Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87EC331880E
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 11:24:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbhBKKY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 05:24:29 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:10430 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230138AbhBKKVy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 05:21:54 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B602505140000>; Thu, 11 Feb 2021 02:21:08 -0800
Received: from [10.26.49.8] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 11 Feb
 2021 10:21:05 +0000
Subject: Re: phy_attach_direct()'s use of device_bind_driver()
To:     Andrew Lunn <andrew@lunn.ch>,
        Saravana Kannan <saravanak@google.com>
CC:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Thierry Reding" <treding@nvidia.com>
References: <CAGETcx9YpCUMmHjyydMtOJP9SKBbVsHNB-9SspD9u=txJ12Gug@mail.gmail.com>
 <YCRkidArVGlesPfy@lunn.ch>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <5176f496-facb-d7b0-9f4e-a9e4b8974178@nvidia.com>
Date:   Thu, 11 Feb 2021 10:21:03 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YCRkidArVGlesPfy@lunn.ch>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613038868; bh=SljrkEVHDmi6xA8MKmgtTpSTzDd2Vz3b1ust/JTNqig=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=MMLGArFdzoF7FHQjCanG/GBKSJ8WlQ7YLkM32dEFhchpZoW9/o101ST5rm75hv+L9
         kpnX0wl0z1rcR24xBTLWbP1IPfRFZ3NPSn5uWW3SU4q6T8stbnSXoSFS3U7sBKkgwp
         3XER6VJFs/QntXgvrayXvvhvWfjnxMObN3mzLj6Z973RkR2QfFkBdAGmDRtYLYZqRy
         43zKexpg8HdHEz7aqtaltdd8KVmkg/1yPetg/56/sRGDSVKe3UnlagVLVYRfBAY0gs
         d2hVqjzoP/Cj7H2soWLdM3Gk3Wd1XocsYQd/llYk+hn8d6Igk5NkU4tXV9QHsqDI9i
         8Q8OxTYNZ+giw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/02/2021 22:56, Andrew Lunn wrote:
> On Wed, Feb 10, 2021 at 02:13:48PM -0800, Saravana Kannan wrote:
>> Hi,
>>
>> This email was triggered by this other email[1].
> 
> And it appears the Tegra194 Jetson Xavier uses the Marvell 88E1512
> PHY. So ensure the Marvell driver is available, and it should get
> probed in the usual way, the fallback driver will not be needed.


Yes that is correct. Enabling the Marvell PHY does fix this indeed and
so I can enable that as part of our testsuite. We were seeing the same
warning on Tegra186 Jetson TX2 and enabling the BRCM PHY resolves that
as well. I will ensure that these are enabled going forward.

Cheers
Jon

-- 
nvpublic
