Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 675EF3E28C9
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 12:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245207AbhHFKjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 06:39:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245239AbhHFKjR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 06:39:17 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C449CC061798;
        Fri,  6 Aug 2021 03:39:00 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id s13so2216276oie.10;
        Fri, 06 Aug 2021 03:39:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2ir6yLMeV4DESAzPY3E3mdRxy6afP5yS47hC9DvqQSI=;
        b=Vz3Uu4W06bG5tmTR5vY5XH2wf6cTKSRdpy2vRFxAry7Id5kweTChj6c3ND3UVI8GS9
         VlRkwr60IGl3cCzDSO7nb7BRj1DHoambPq1oCEfdNVR7Kx1Z0O0F5a/qFrpqOSaTie3M
         NSeboXSAIfklLSbyp53RdvlW21bMW1mXTizjqqhFwDi+LzTGVcABY3VTnQBc3mYkuQNQ
         mUd8EBG8j9dToK42tBJA25qoDnMgfrwJCjC2Vk2rQ3MqdUryfwCmB+rKbdrOf6C9bsfv
         xC2vGGkO5CVdtEdSZi1OwNc6UbIhVJBFVgPTdRqrPaAqbhXvbNe8BxqjSGrhu6Rb6n68
         JS1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2ir6yLMeV4DESAzPY3E3mdRxy6afP5yS47hC9DvqQSI=;
        b=KtYcPGevje4IQ6f5g1DPBZkVNPXOZCWjNYJbIjwmfOT0pLBB4mi8e7z7PyqJdcvB+r
         vHQjrf8FwncIb0oIIBCrpnUVWLOL0/NKHSH0SrvEJmUssxH0n9cBxtRnlAiDzmJRyJDo
         1ElttR3nEnID79FjU182SXbN8JT/wn1ByeP4Fi7IydxPLbziEd9OEbOHGOhYQfGKkhhq
         gbdh63ZoLIFqyuGOrBNVtSHl5RIIdM1v8EDaa+I7lyMxNsTMqfzsL8ORIG+4iBeNAXlI
         LCIXVsow7uQW4go0dX/JcyaOamb7syqBEqTV7eCPRb+xs0yhToBBkw3kKiQyP/mdkFfk
         78CA==
X-Gm-Message-State: AOAM533nDUjmjRR24p/ARqmvk2btXkeTdmjECMFYOhiugjAHW/GQ3c4I
        kh3DOOY4v6DgCqCxNfgRcIT17uj585IWHnTZfU55TWnP
X-Google-Smtp-Source: ABdhPJxu03ZChp9YO7FrEqNokK/BTwGoh/imeOCY1vfLOz+CfntN+3WCL1KmcikKjJ+qwNH8/X+33DNbk6QMYQWTfss=
X-Received: by 2002:aca:eb0f:: with SMTP id j15mr4933802oih.63.1628246340243;
 Fri, 06 Aug 2021 03:39:00 -0700 (PDT)
MIME-Version: 1.0
References: <1628246109-27425-1-git-send-email-loic.poulain@linaro.org>
In-Reply-To: <1628246109-27425-1-git-send-email-loic.poulain@linaro.org>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Fri, 6 Aug 2021 13:38:49 +0300
Message-ID: <CAHNKnsQCNfLhxm8FxAb8EPKuK+6YFPVx55_SvJMTcg12MjUnJw@mail.gmail.com>
Subject: Re: [PATCH net-next] net: wwan: mhi_wwan_ctrl: Fix possible deadlock
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 6, 2021 at 1:24 PM Loic Poulain <loic.poulain@linaro.org> wrote:
> Lockdep detected possible interrupt unsafe locking scenario:
>
>         CPU0                    CPU1
>         ----                    ----
>    lock(&mhiwwan->rx_lock);
>                                local_irq_disable();
>                                lock(&mhi_cntrl->pm_lock);
>                                lock(&mhiwwan->rx_lock);
>    <Interrupt>
>      lock(&mhi_cntrl->pm_lock);
>
>   *** DEADLOCK ***
>
> To prevent this we need to disable the soft-interrupts when taking
> the rx_lock.
>
> Cc: stable@vger.kernel.org
> Fixes: fa588eba632d ("net: Add Qcom WWAN control driver")
> Reported-by: Thomas Perrot <thomas.perrot@bootlin.com>
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>

Reviewed-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
