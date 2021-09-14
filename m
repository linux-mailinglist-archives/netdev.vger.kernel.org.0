Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8C940AF6D
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 15:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233550AbhINNn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 09:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233597AbhINNmr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 09:42:47 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF76FC0613E1;
        Tue, 14 Sep 2021 06:40:06 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id v123so12229121pfb.11;
        Tue, 14 Sep 2021 06:40:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n1xHERTWrj7D1DTPEGJj3xVwOdFR4NfsEg1IOHAruuw=;
        b=N4HjvaGMKIHbXihQJY26tsfN0SewA/NZla4RAEMjOxtJnPQfLV4agqUhzeTnjj86Mt
         LP0m9lTl6Gc6Dye+LCwhyvl/J0g772XxXhLEL/qoIq7xOen0Ca6jYCS8eZ2/qpZq0CpS
         iO0vzwUwO6nDVOLORCamflLOU2mxqFvkBzACzG8ZqC8Bld+xFWgUSd0csXsxALqCZhCm
         HPkXkL2TX1Gco+oKpFU9M6+4J58W844WQdDbfFQm7AV71OwP54oZplG9BA6hERNK2z6I
         D6pebIdKVNWIMDx5h12PyCUXPFJzFt0WMgD+1+QclBKkdJL568CtTfs8ic03gNLoycKT
         9AiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n1xHERTWrj7D1DTPEGJj3xVwOdFR4NfsEg1IOHAruuw=;
        b=DpCsJJLQd+AnV6U/cIdiXgGoezyFmChokJuuFxhcqdQj2+51D7BzbKvoCEhZkosU4l
         FDsqruvis7USQThaWwPbA2752uxZXcVay37sXDaaAYkXvUsDAyuDr6uG+rbtcHuVY21Y
         DMsHsEhVZC54tumdyubjWozXgtt2WdXoUJg2ERfV3kz5gP51j95p9YrvoI2SZmwMhfZ0
         RrYyYJVLKvvqW6YZLeMYYvcHocYPuMoVrIw3cywMUJVnxTF/P9ZgXmXvZc2faKASMvkV
         Pc+ayWRQI0QX0njYew1WdpfqaQcGc49834Rh2l+vVtoQd9uL4LJQylLse7wjmoRd73Jd
         SO6A==
X-Gm-Message-State: AOAM533ILMVNZPUCh3E61E8UQbslRwtI3zCchWlA11WhlwXn3xrb3YHe
        WvJ8Bgf/eIjJBvTN81d2Rwg5IZ9WmCDN3ZckjJA=
X-Google-Smtp-Source: ABdhPJyx6W1PZKwym79XKRlu1WIoa0lt5UEVm+XWEe1zmmFeUxgWA/N1FXcqIdWfUY+sZHxx2c6EUP6FZ4I55/6Q7mA=
X-Received: by 2002:a62:770d:0:b0:43d:aff0:dbec with SMTP id
 s13-20020a62770d000000b0043daff0dbecmr4853543pfc.79.1631626806301; Tue, 14
 Sep 2021 06:40:06 -0700 (PDT)
MIME-Version: 1.0
References: <CAGjnhw920kNaJ9Vkg54WR8vh2TaomuTtA3WwR3eieD4v6iEJDw@mail.gmail.com>
 <2ada6f05-fc3a-a301-a008-594f7665a514@wolfvision.net>
In-Reply-To: <2ada6f05-fc3a-a301-a008-594f7665a514@wolfvision.net>
From:   =?UTF-8?Q?Sebastian_D=C3=B6ring?= 
        <moralapostel+linuxkernel@gmail.com>
Date:   Tue, 14 Sep 2021 15:39:39 +0200
Message-ID: <CADkZQakh49i-M_1NgsENkqBnacVo6J3Rj8D2NFijvyBts9Pneg@mail.gmail.com>
Subject: Re: [PATCH] net: stmmac: dwmac-rk: fix unbalanced pm_runtime_enable warnings
To:     Michael Riesch <michael.riesch@wolfvision.net>
Cc:     Ivan Babrou <ivan@ivan.computer>, sashal@kernel.org,
        alexandre.torgue@foss.st.com, davem@davemloft.net,
        joabreu@synopsys.com, kuba@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        peppe.cavallaro@st.com, wens@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael,

I guess looking for a better or more ideal solution sounds good, but
sorry if this is impertinent, as it's coming from a mostly uninvolved
3rd party: This is affects a kernel that is labeled as "stable". It
seems extremely unacceptable to break ethernet support for boards like
the rockpro64, which are used largely in a headless fashion, when the
offending commit has already been identified.

I don't expect a stable kernel release to completely break my hardware
and then see people not immediately applying a workaround patch. It
seems strange. I'm not fond of having to fix things through serial
console and hunting through mailing lists to figure out what's going
on. I'd only expect this for -rc kernels.

Just my two cents.

Best regards,
Sebastian

Am Di., 14. Sept. 2021 um 12:09 Uhr schrieb Michael Riesch
<michael.riesch@wolfvision.net>:
>
> Hello Ivan,
>
> On 9/14/21 3:10 AM, Ivan Babrou wrote:
> > Is it possible to revert the patch from the 5.14 and 5.15 as well?
> > I've tried upgrading my rockpro64 board from 5.13 to 5.15-rc1 and
> > ended up bisecting the issue to this commit like the others. It would
> > be nice to spare others from this exercise.
>
> For what it is worth we believe that there is a different issue with the
> dwmac-rk driver that was obscured by calling pm_runtime_get_sync()
> early. Investigation in progress -- I hope that we can achieve a proper
> solution before we have to revert the revert.
>
> Best regards,
> Michael
