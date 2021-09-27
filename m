Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5780F41A04C
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 22:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236477AbhI0Un1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 16:43:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236390AbhI0Un0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 16:43:26 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D318C061740
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 13:41:48 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id l16-20020a9d6a90000000b0053b71f7dc83so26135367otq.7
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 13:41:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pUZgLCnNelRAaV+g7H8XGqFTT9YZLErJSXLJYla4RJo=;
        b=dCoaJUF0HSoSC1tmNX6q8Fh6kJv7c6jk49XmhH2vq1ANKmz6EeVyVtD2Pcxxxh8aXz
         /W0bzAWmoH3iHlFtKt4RHhcy9v4nMv6BEyBk34D8UUa8oCh+yyJJBwKYrK5zxFL+VJ5W
         mmk25gMJbff0s4JgjQlL73M1frtzFLhhSSeKsoMfON0N7To1FwqmZevw+vpH964FuN5+
         VDs07R1JX2daPpe7GTVjL3t8b85VIkNR+VDjVjC7aEfatwsh4ieB21gaSPHVc9FrfLe4
         JK9GpMcv5K/VRzrKmX8WZg1LZAmnWcollVG6hxmBajWBFIxazJts7JTsm6AsqVhgOO/o
         pUCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pUZgLCnNelRAaV+g7H8XGqFTT9YZLErJSXLJYla4RJo=;
        b=kqIjZW0Nepw0Gc6gfinWVAgZtcpvoML60lZ5XUDpaOw0MbMFa0pE6cuIjxXmKyDX9E
         LwWiJ25bpl+CJ8eyy9A+gKg7M4pz8CblHhzzfL/BF3a0NUU1WBnv4s20t3KaFWzHD1kU
         Su1j7ztFExK4/VF5xdkd3zzvJFyy9sOEjlkRmcqrQpaPNdJwJg9wB+Sj+tNb6uEeSUPM
         3/4nMpUC3J6i42OFrZZ8ps+SWNGA2/z4+XQiPNfD3GppXUm2e69xyQ8rO9B0heyLKQrL
         iRuSk6kjsFq68DZ2o2FA2mFZwD8PisQsosH4UFV6F99fTABoi9YxndTtEBphL9w5zqiR
         Vljg==
X-Gm-Message-State: AOAM530aqXruMGRGcj36qXKDWAlABchRHf732q6+oKEbS6QzQDsdMOOw
        I3CfFM3GdNzUoSBP1gMeuKRsaA==
X-Google-Smtp-Source: ABdhPJydeIzDJHtHzGeBz5+87mWnwkDNbaEe+ql2n9gGjNC+NklvZH2OYxM0vWlXO7E/L2MFCogIbA==
X-Received: by 2002:a9d:6a0f:: with SMTP id g15mr1832465otn.126.1632775307597;
        Mon, 27 Sep 2021 13:41:47 -0700 (PDT)
Received: from ripper (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id a8sm4414108oos.46.2021.09.27.13.41.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 13:41:47 -0700 (PDT)
Date:   Mon, 27 Sep 2021 13:42:22 -0700
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Rob Clark <robdclark@gmail.com>,
        Sean Paul <sean@poorly.run>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Alex Elder <elder@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Andy Gross <agross@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        freedreno <freedreno@lists.freedesktop.org>,
        "open list:IOMMU DRIVERS" <iommu@lists.linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, ath10k@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-sunxi@lists.linux.dev
Subject: Re: [PATCH] [RFC] qcom_scm: hide Kconfig symbol
Message-ID: <YVIsrgKiOG/gFVdT@ripper>
References: <20210927152412.2900928-1-arnd@kernel.org>
 <YVIg9CxJGaJr1vpp@ripper>
 <CAK8P3a1fEuFsQVY9b1oGdTOHzr8pu9wvrSBCMn2iOvgWqtHNnA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a1fEuFsQVY9b1oGdTOHzr8pu9wvrSBCMn2iOvgWqtHNnA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon 27 Sep 13:15 PDT 2021, Arnd Bergmann wrote:

> On Mon, Sep 27, 2021 at 9:52 PM Bjorn Andersson
> <bjorn.andersson@linaro.org> wrote:
> > On Mon 27 Sep 08:22 PDT 2021, Arnd Bergmann wrote:
> > > From: Arnd Bergmann <arnd@arndb.de>
> > >
> > >  - To avoid a circular dependency chain involving RESET_CONTROLLER
> > >    and PINCTRL_SUNXI, change the 'depends on RESET_CONTROLLER' in
> > >    the latter one to 'select'.
> >
> > Can you please help me understand why this is part of the same patch?
> 
> This can be done as a preparatory patch if we decide to do it this way,
> for the review it seemed better to spell out that this is required.
> 
> I still hope that we can avoid adding another 'select RESET_CONTROLLER'
> if someone can figure out what to do instead.
> 

Okay, thanks.

> The problem here is that QCOM_SCM selects RESET_CONTROLLER,
> and turning that into 'depends on' would in turn mean that any driver that
> wants to select QCOM_SCM would have to have the same RESET_CONTROLLER
> dependency.
> 

Right, and that will just be another thing we'll get wrong across the
tree.

> An easier option might be to find a way to build QCOM_SCM without
> RESET_CONTROLLER for compile testing purposes. I don't know
> what would break from that.
> 

Afaict the reset API is properly stubbed and RESET_CONTROLLER is a bool,
so I think we can simply drop the "select" and the kernel will still
compile fine in all combinations.

When it comes to runtime, we currently select RESET_CONTROLLER from the
Qualcomm common clocks. If that is dropped (why would it...) it seems
possible to build a custom kernel for msm8916 that we can boot and miss
the stubbed out "mss restart" reset line from the SCM.


So, let's just drop the select RESET_CONTROLLER from SCM for now.

Regards,
Bjorn
