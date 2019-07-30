Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A763F7AABB
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 16:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730804AbfG3ORv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 10:17:51 -0400
Received: from mail-vs1-f68.google.com ([209.85.217.68]:42124 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727765AbfG3ORv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 10:17:51 -0400
Received: by mail-vs1-f68.google.com with SMTP id 190so43570821vsf.9
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 07:17:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vanguardiasur-com-ar.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RK299o1I9nQNlsSGV+4buZQzWUsPGHe+LviTSNSniew=;
        b=SxaVkioTG0t2pjLf5OyxRf9JMawK69C8+zJxxRkOddWQ67OVwOAduPXdi5/peQBnKk
         lxi9e/T1J1zIv9jw/oMZp6JAuybJF9n7nnxAPDDqYruh+tZLoXZKJ/Q4A3AT5yM3UpDd
         xwPcHIMWGUZGuT5Psh9H+Jxgn1UEA1p7tgXfDI0/kw+RynaQ8a6IsxMh9b2huMgPjP3o
         mwBg41OPB8I5f2RDxKql10x6ujzkOMge/X4MS/u5FTbnMA54GyC8MC3VQhza3klGnXYI
         k019OGWuAeXXutGGH3OceFAdoSGs9lXpunq0Ya6qlRFlWPZiHKR4GNpyV6lXlQkxRe3o
         NBcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RK299o1I9nQNlsSGV+4buZQzWUsPGHe+LviTSNSniew=;
        b=dvDNdbwrdmUXL6I/j2GAHNWrs/0CEIuDLLXh0lIQM9/Xh6QpwD8KddT4PW0LfMLhsm
         mz5JHin5Uy6OXDBej0Va1KtP9qgluXgJRiVutjkMS1/kcOzpmTDGk4skOUGqu2bsvk/3
         43h20NiVqPrj2vljh0fQ21kDfY9R9PY5WjAsCkkcu++r3rlk3T1GfjkDsu7GpA3yYlpP
         4INald0OzvYpTT/iRoH9uojcckLiZ1FMBcTXI+owfmqJw8mZFznoxhJCSB/OC0t/QyBQ
         QWKJeoPibiNUOuwHhHGjdfmpHH2IHd93h5LZs/Py5Hv+c02SZ66zMCjGzMci0j7RYZLd
         CQ1A==
X-Gm-Message-State: APjAAAWgsxMcE0xH5mGnDp26/KiFqwrNbJh0/ldg9Cc+VWXFL3BBQceU
        7jMU7x5paq39fhj+9jWZkHTGnlCZy/hVHSCO2mM=
X-Google-Smtp-Source: APXvYqzOWV7w5UY6HfuniMmOZbt2GqzgJCloyN6OJVs76PDRwHfZfJxx5YKZtGvjUeFd4Nxu5FnCxu0Lhw8PkE14veU=
X-Received: by 2002:a67:e9ca:: with SMTP id q10mr41517640vso.105.1564496270292;
 Tue, 30 Jul 2019 07:17:50 -0700 (PDT)
MIME-Version: 1.0
References: <3601e3ae4357d48b3294f42781d0f19095d1b00e.1564479382.git.joabreu@synopsys.com>
In-Reply-To: <3601e3ae4357d48b3294f42781d0f19095d1b00e.1564479382.git.joabreu@synopsys.com>
From:   Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Date:   Tue, 30 Jul 2019 11:17:39 -0300
Message-ID: <CAAEAJfDU23Q2G+qXW+BubX3FM3MwSGhJ15NrmDuzoM6UFfFLmw@mail.gmail.com>
Subject: Re: [PATCH net] net: stmmac: Sync RX Buffer upon allocation
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     Networking <netdev@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jon Hunter <jonathanh@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Jul 2019 at 10:57, Jose Abreu <Jose.Abreu@synopsys.com> wrote:
>
> With recent changes that introduced support for Page Pool in stmmac, Jon
> reported that NFS boot was no longer working on an ARM64 based platform
> that had the IP behind an IOMMU.
>
> As Page Pool API does not guarantee DMA syncing because of the use of
> DMA_ATTR_SKIP_CPU_SYNC flag, we have to explicit sync the whole buffer upon
> re-allocation because we are always re-using same pages.
>
> In fact, ARM64 code invalidates the DMA area upon two situations [1]:
>         - sync_single_for_cpu(): Invalidates if direction != DMA_TO_DEVICE
>         - sync_single_for_device(): Invalidates if direction == DMA_FROM_DEVICE
>
> So, as we must invalidate both the current RX buffer and the newly allocated
> buffer we propose this fix.
>
> [1] arch/arm64/mm/cache.S
>
> Reported-by: Jon Hunter <jonathanh@nvidia.com>
> Tested-by: Jon Hunter <jonathanh@nvidia.com>
> Fixes: 2af6106ae949 ("net: stmmac: Introducing support for Page Pool")
> Signed-off-by: Jose Abreu <joabreu@synopsys.com>

Thanks a lot for the bug hunt and the fix. This fixes NFS mounting
on my RK3288 and RK3399 boards.

Tested-by: Ezequiel Garcia <ezequiel@collabora.com>
