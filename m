Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B45E1E6257
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 15:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390377AbgE1Ncw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 09:32:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390355AbgE1Ncv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 09:32:51 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0EB9C05BD1E
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 06:32:51 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id j8so29903300iog.13
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 06:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=W6Ng+4krUrmarKse2LeV5TbqCd00mWN+CVVq8JMM5SE=;
        b=NJ0ybiSwbgGo1ahGYgAEwAdeEVE39Up4uZ5A1HFgeBFSeLdYyEjBoxzLaGany3U5qV
         tjyrvq25hqP+szOxI6JhW3xweR3C+uklX69AslmSgzZCTItj/lE1GwHfTH3xcf08EAt3
         mIwE34/rwjc7maTJJIaEZzx9+zgsTJyg16wtDEVvAZDos92VaeKTKyLujiHiG6B1cOYc
         KIuFtxHGqOtrjVeCdhdPy1poHODMArChjps6RUTUQ889ANVor3RtIvsULAyoI9a8m+lM
         yGQ/vmJQnyAURdQlFeawVfHk0vmYbLrVgpgL5isYwZKpihaGQitPE1wijKFtYBpDmHAO
         jbyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=W6Ng+4krUrmarKse2LeV5TbqCd00mWN+CVVq8JMM5SE=;
        b=LUzM3zNGleFr6DaCQYDohmSnYidZn5vU/njfYQ2nI1lkdoxgwGI40zFgvWDia8PaaT
         ZK7MSBK7k8eJ214CbzPUwSwpXbHYYpC4+3WlQ/ShVfN2LxxQhMoEn9dVxpCHtS1+cGIJ
         0a4XZLDvlIYS/fGSM78Sl5IXyPx1twf16edDbUj8IWnh8zJC5K766tMyC34APptsUheb
         u0DS31pTOvsYPlGKp/AINgSHu5Bp8Wl74WBoMSaE+w03tpP5rsYN5eUEELBFNai3/ZA3
         ioEmyO1kVzBgULML+gkqKsarHKzLeNxlk3eF9S/roqqugWyecNV+b3AdU+UzSvs6wuxQ
         Zk8A==
X-Gm-Message-State: AOAM531l01J1dXFPyD8+FldSfzj5RXemt1VV9i+ADGCOXOkXG5q5hkOM
        jr8dp5Z5INIOXphQosU+Anx8YBlZYv7IIeBBqFAs2A==
X-Google-Smtp-Source: ABdhPJzo7KSXJqLmG4j0rLnWfVnluS/E9w7gshGux7pMtHXApV9skQgthF60OVdfNho6c1thzgPYEEykEs0OHoviWNw=
X-Received: by 2002:a5e:981a:: with SMTP id s26mr2322972ioj.131.1590672771135;
 Thu, 28 May 2020 06:32:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200528123459.21168-1-brgl@bgdev.pl> <20200528123459.21168-2-brgl@bgdev.pl>
 <20200528132938.GC3606@sirena.org.uk>
In-Reply-To: <20200528132938.GC3606@sirena.org.uk>
From:   Bartosz Golaszewski <brgl@bgdev.pl>
Date:   Thu, 28 May 2020 15:32:40 +0200
Message-ID: <CAMRc=MejeXv6vd5iRW_EB3XqBtdCWDcV=4BOCDDFd4D0-y9LUA@mail.gmail.com>
Subject: Re: [PATCH 1/2] regmap: provide helpers for simple bit operations
To:     Mark Brown <broonie@kernel.org>
Cc:     John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC..." 
        <linux-mediatek@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fabien Parent <fparent@baylibre.com>,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

czw., 28 maj 2020 o 15:29 Mark Brown <broonie@kernel.org> napisa=C5=82(a):
>
> On Thu, May 28, 2020 at 02:34:58PM +0200, Bartosz Golaszewski wrote:
>
> > This adds three new macros for simple bit operations: set_bits,
> > clear_bits and test_bits.
>
> Why macros and not static inlines?

The existing regmap_update_bits_*() helpers are macros too, so I tried
to stay consistent. Any reason why they are macros and not static
inlines? If there's none, then why not convert them too? Otherwise
we'd have a static inline expanding a macro which in turn is calling a
function (regmap_update_bits_base()).

Bartosz
