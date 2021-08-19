Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6AD73F131A
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 08:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbhHSGJA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 02:09:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbhHSGI5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 02:08:57 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C03D5C061756;
        Wed, 18 Aug 2021 23:08:21 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id f5so7123773wrm.13;
        Wed, 18 Aug 2021 23:08:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ld5tr++fLXKmqW5dNJQnNT90Jc4o9lum57+BvwZR4Ag=;
        b=j9R85SHuFn/5xPt0/yzoTUjoW2EKjmYwyqhHIcmuH41YNhS7uLDjJjBxh2nvZcybUg
         4ThNFqKYd7y16lYFdqlGGjoRDWsdBM6RNnP1IYlFlYjwWrOXYPObZiDOBcwjRo57ajpl
         PyLLL21ySV3fRxyqGnL6rLznLxRijO5jqDKxlIAZO4Gr3Bpuq8MEkLyeffVka3I4oZb6
         3p+pAmvdliSZt4zG9rVFft3pFnHjECI3q/40IBZ01cVwejZwht6lDNdTIorsD3pkDiBc
         JYLEVOaVH4e1M1B4udZxp+ESIG9PvS5oawfVcGa/0bw5mmNpML7138HLSxxpA2unusEb
         GiAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ld5tr++fLXKmqW5dNJQnNT90Jc4o9lum57+BvwZR4Ag=;
        b=Iys03hEEptPt8pxb3OkLb8ZBaec7KHpRIuN3NwaT7JwGGjC1C/Xct9wMAPWawpL1op
         ysOsYzm4KSdJ7Hdis925r5jnEiPlUMwFfB+ko9Tk185X9jvHzcpcc/G6Z4jBrNXZ0UX/
         F8b7ILNkRsOG5DyQBJ51ZZsrZQ7ahpftuFyt8cYVjvfOWQco7jkF4GQMoxUiKWziyO+w
         07koOOjCknSKRzpDDTV1JlY6RKCEWAtdhTwiFm7KkrEk9zpPDLjQ+HB+ex6gWjlGKHa1
         rnIZg/pUxC8lYl1Q8tnyFM7tjn0p5gJZB2vMJkB4giY+x6vZAbF5El2AKm6FwghIzOt4
         2HOw==
X-Gm-Message-State: AOAM531WcLW6dxxbIIPXkKsBA6R1uK4UWGK91wd16sXqVyo7HaoaYMAk
        ob1sekwUyYztSZ1Fp3OGivCWtKkopfrWyA==
X-Google-Smtp-Source: ABdhPJzXAt1+lkVfv3LRAZgLBgCOGiS0Aq4hbOvNt97GmwRkaEIzGKuzY54QMi85skmQB39FIBvKxg==
X-Received: by 2002:adf:e3c7:: with SMTP id k7mr1522719wrm.327.1629353300137;
        Wed, 18 Aug 2021 23:08:20 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f08:4500:9978:7b72:32e9:8917? (p200300ea8f08450099787b7232e98917.dip0.t-ipconnect.de. [2003:ea:8f08:4500:9978:7b72:32e9:8917])
        by smtp.googlemail.com with ESMTPSA id l9sm1813731wrt.95.2021.08.18.23.08.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Aug 2021 23:08:19 -0700 (PDT)
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>, nic_swsd@realtek.com,
        bhelgaas@google.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210819054542.608745-1-kai.heng.feng@canonical.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next v3 0/3] r8169: Implement dynamic ASPM mechanism
 for recent 1.0/2.5Gbps Realtek NICs
Message-ID: <b14bc147-d39c-6f55-cc0e-7b2de92d23b1@gmail.com>
Date:   Thu, 19 Aug 2021 08:08:10 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210819054542.608745-1-kai.heng.feng@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19.08.2021 07:45, Kai-Heng Feng wrote:
> The latest Realtek vendor driver and its Windows driver implements a
> feature called "dynamic ASPM" which can improve performance on it's
> ethernet NICs.
> 
This statement would need a proof. Which performance improvement
did you measure? And why should performance improve?
On mainline ASPM is disabled, therefore I don't think we can see
a performance improvement. More the opposite in the scenario
I described: If traffic starts and there's a congestion in the chip,
then it may take a second until ASPM gets disabled. This may hit
performance.

> Heiner Kallweit pointed out the potential root cause can be that the
> buffer is to small for its ASPM exit latency.
> 
> So bring the dynamic ASPM to r8169 so we can have both nice performance
> and powersaving at the same time.
> 
> v2:
> https://lore.kernel.org/netdev/20210812155341.817031-1-kai.heng.feng@canonical.com/
> 
> v1:
> https://lore.kernel.org/netdev/20210803152823.515849-1-kai.heng.feng@canonical.com/
> 
> Kai-Heng Feng (3):
>   r8169: Implement dynamic ASPM mechanism
>   PCI/ASPM: Introduce a new helper to report ASPM support status
>   r8169: Enable ASPM for selected NICs
> 
>  drivers/net/ethernet/realtek/r8169_main.c | 69 ++++++++++++++++++++---
>  drivers/pci/pcie/aspm.c                   | 11 ++++
>  include/linux/pci.h                       |  2 +
>  3 files changed, 74 insertions(+), 8 deletions(-)
> 
This series is meant for your downstream kernel only, and posted here to
get feedback. Therefore it should be annotated as RFC, not that it gets
applied accidentally.
