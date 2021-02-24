Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E33B3242ED
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 18:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233871AbhBXRJf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 12:09:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233656AbhBXRJc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 12:09:32 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 799C5C061574
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 09:08:51 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id kr16so1714011pjb.2
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 09:08:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=95PYyJrl+qnHBRm6LDDmRrrYw8z5S82hbYu6fdAoYjI=;
        b=GHNMNdQ/KoMFs1yQ5K9rIsSsCaVMYkTwVGjZZGRPuYewJ9Oo2+SMIYKN/w8NkCRN9Z
         zzv1sdjqkxnxiADeQ8ak6ohgovOl4jo9KlPPSFTFOxv6r5Ornbh3kyLQW8RQoelHnsRT
         Paqm45i1iVNgZziDFK77etmh+1ghO8YBWt9SC0lztiedVUMZy+8Pv+3jVR55vw0U/4bG
         9qQCUYvODqv5ELtQveq6Ng10qbZcYSzjh7Y8s+PjeMRbSxi+IKdKUK5tT6ScZK36puI7
         NuOqQKd/Noha5x3O4L1waA/FNBHLN1FnO/MEZAkv4ajZFlVIU9LnyeYunrCYZSaryYGA
         tk6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=95PYyJrl+qnHBRm6LDDmRrrYw8z5S82hbYu6fdAoYjI=;
        b=O4V8+V9GDjtDX6PU2hVjIFHxM1N7glF6QSuxadIAvbn5XqamhdTN4ksOiVfgqwu1p2
         YToo1QGRY+h4tMhiYSmpWsUS/yLirjiNx830vuQ5py711z0g78dBP7WrVguRx9GKpA+9
         cfARQfLTECJ3cdT2iPL8fFnHpfmkR1Z7Fzd2NLqWoNA/41vsnc+bLw50F3z727ABIrBI
         paamDmfy6AbJYcR71Paq9Ph1pXVVy0erih7MhRk4ImA7stJUUCl6ig+YDrabOSVGitBc
         7aT0CFxRMu3g+XnTTbF0CkjIpbfMzvoWQPRrD3zSLbhrBsmbw3Ntpg9jIY6Wxn2sjHGT
         knag==
X-Gm-Message-State: AOAM533IK68xrtF5zFLFjkehC4//X6uOsDWzXY4zI8De1nOmedpapXXr
        6Skdr9pNEWOm+F0qjvKEbkA=
X-Google-Smtp-Source: ABdhPJzB9Fy0T3dn9wl+uZiJetKfCIlBHOrgQRBiXy6lJBM/L4C4jKdd7bQcfpyYzhzm5CCTm3AJXA==
X-Received: by 2002:a17:902:bd0a:b029:e0:612:ad38 with SMTP id p10-20020a170902bd0ab02900e00612ad38mr34413743pls.30.1614186530958;
        Wed, 24 Feb 2021 09:08:50 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w3sm3481081pjn.12.2021.02.24.09.08.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Feb 2021 09:08:50 -0800 (PST)
Subject: Re: [PATCH v3] bcm63xx_enet: fix internal phy IRQ assignment
To:     =?UTF-8?Q?Daniel_Gonz=c3=a1lez_Cabanelas?= <dgcbueu@gmail.com>,
        davem@davemloft.net
Cc:     kuba@kernel.org, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, noltari@gmail.com
References: <2190629.1yaby32tsi@tool>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <92970535-1af2-3bca-9f70-6b2d093b2ac1@gmail.com>
Date:   Wed, 24 Feb 2021 09:08:48 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <2190629.1yaby32tsi@tool>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/24/2021 8:11 AM, Daniel González Cabanelas wrote:
> The current bcm63xx_enet driver doesn't asign the internal phy IRQ. As a
> result of this it works in polling mode.
> 
> Fix it using the phy_device structure to assign the platform IRQ.
> 
> Tested under a BCM6348 board. Kernel dmesg before the patch:
>    Broadcom BCM63XX (1) bcm63xx_enet-0:01: attached PHY driver [Broadcom
>               BCM63XX (1)] (mii_bus:phy_addr=bcm63xx_enet-0:01, irq=POLL)
> 
> After the patch:
>    Broadcom BCM63XX (1) bcm63xx_enet-0:01: attached PHY driver [Broadcom
>               BCM63XX (1)] (mii_bus:phy_addr=bcm63xx_enet-0:01, irq=17)
> 
> Pluging and uplugging the ethernet cable now generates interrupts and the
> PHY goes up and down as expected.
> 
> Signed-off-by: Daniel González Cabanelas <dgcbueu@gmail.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
