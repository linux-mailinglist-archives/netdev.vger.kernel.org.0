Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 396493EE71A
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 09:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234630AbhHQHYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 03:24:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234402AbhHQHYk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 03:24:40 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 724E2C0613C1
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 00:24:07 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id i10-20020a05600c354ab029025a0f317abfso1148028wmq.3
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 00:24:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=k1CgOPIa4n8DhcaJK9nsG7rytL7vIVlLDzs67n6AWoM=;
        b=ESxuGmoejql+KJqudW71YmXAVcpivN8iG3xoY7CrTrTtal9GvssW6TT4vJqxDquKPS
         ZbpXdNqcJBBLIl6MtVdwC9a/llh3K/FZKm/UPFaPXrA7YUWGKH4PKir9bAOVkidGxVXY
         KZgb5s5zpGWR+rnCKZWAixf2rB1d64//WrzKKijRZuzN0RDP9gx57b6SvEBgRT4pdvXD
         X1kSzbupbe/G5T8TEIKJRcKMjhZo3ew5OFpQzcgJ6Q3gCVZIJJfitLrSY1xRLI8EBk0q
         J2uri7ShGkd+SeV+XM/koxWEK/wKimiUptIJZ14WxLHZYijyn68CW4sxB/4vSV8jlFF4
         f/5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=k1CgOPIa4n8DhcaJK9nsG7rytL7vIVlLDzs67n6AWoM=;
        b=TL9OgVnbGHyIS6m/iWwX2GZKtOonIlpmU1e58q/hZ9rO5TCXS4HOBOKSoh3EYwoUwe
         qI2x18661eMyzhegyHA2eGK1q+8fnOPVhsikSq7Fo1FLnoIBtyIachctxvhApi4nApE7
         j2nxFmoE+HG7QEuKaMVHveDymn4p/DMmxCL1FjfOxUpRlmTWvEz4vvvQ3WUvHSJ/cTLX
         agQzD5R8m5slU8gKnNBwvUMECCuIojvUeUGzwbCNUC4ruqWw968sZNYbSyersK3+n7IX
         5kJbXAy/LWmJF86/OfeOd3eml315alAYQqS72hueNJjtUFEojgvmNCbhCLJniPjBiSjb
         SoCA==
X-Gm-Message-State: AOAM531H6E1vMJyEkcFbICyMZDxkn6upGaovwxbzGR6pcrNZi68EywyW
        tZT3J1rFuYuFOqdB+bPLbUTYrQ==
X-Google-Smtp-Source: ABdhPJw+7IS45rZ/FJaVYS7tOUDstHuyiASXa0q8qpIY9XfIiWi2zJdF0dx4HuJt2hC+0aOuKnl8SA==
X-Received: by 2002:a7b:c2f0:: with SMTP id e16mr1880371wmk.144.1629185045975;
        Tue, 17 Aug 2021 00:24:05 -0700 (PDT)
Received: from google.com ([2.31.167.59])
        by smtp.gmail.com with ESMTPSA id v1sm1282927wrt.93.2021.08.17.00.24.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 00:24:05 -0700 (PDT)
Date:   Tue, 17 Aug 2021 08:24:03 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Saravana Kannan <saravanak@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Kevin Hilman <khilman@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        linux-amlogic@lists.infradead.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [PATCH 1/2] irqchip: irq-meson-gpio: make it possible to build
 as a module
Message-ID: <YRtkE62O+4EiyzF9@google.com>
References: <87r1hwwier.wl-maz@kernel.org>
 <7h7diwgjup.fsf@baylibre.com>
 <87im0m277h.wl-maz@kernel.org>
 <CAGETcx9OukoWM_qprMse9aXdzCE=GFUgFEkfhhNjg44YYsOQLw@mail.gmail.com>
 <87sfzpwq4f.wl-maz@kernel.org>
 <CAGETcx95kHrv8wA-O+-JtfH7H9biJEGJtijuPVN0V5dUKUAB3A@mail.gmail.com>
 <CAGETcx8bpWQEnkpJ0YW9GqX8WE0ewT45zqkbWWdZ0ktJBhG4yQ@mail.gmail.com>
 <YQuZ2cKVE+3Os25Z@google.com>
 <YRpeVLf18Z+1R7WE@google.com>
 <CAGETcx-gSJD0Ra=U_55k3Anps11N_3Ev9gEQV6NaXOvqwP0J3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGETcx-gSJD0Ra=U_55k3Anps11N_3Ev9gEQV6NaXOvqwP0J3g@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Aug 2021, Saravana Kannan wrote:
> > > > I sent out the proper fix as a series:
> > > > https://lore.kernel.org/lkml/20210804214333.927985-1-saravanak@google.com/T/#t
> > > >
> > > > Marc, can you give it a shot please?
> > > >
> > > > -Saravana
> > >
> > > Superstar!  Thanks for taking the time to rectify this for all of us.
> >
> > Just to clarify:
> >
> >   Are we waiting on a subsequent patch submission at this point?
> 
> Not that I'm aware of. Andrew added a "Reviewed-by" to all 3 of my
> proper fix patches. I didn't think I needed to send any newer patches.
> Is there some reason you that I needed to?

Actually, I meant *this* patch.

But happy to have unlocked your patches also. :)

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
