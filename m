Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D80E3E271A
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 11:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244430AbhHFJTD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 05:19:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244300AbhHFJSA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 05:18:00 -0400
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E481AC061798;
        Fri,  6 Aug 2021 02:17:43 -0700 (PDT)
Received: by mail-oo1-xc29.google.com with SMTP id f33-20020a4a89240000b029027c19426fbeso2059827ooi.8;
        Fri, 06 Aug 2021 02:17:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vromIZfVaRTbVHccIXLwJjG5p8UCfRytvq4A7EoGIIk=;
        b=iBGtmRsGEszCCemqaXsr04N78m8Fvi8sEQ9KxI7opv/URJjnzjBmK0BNQYCjywzEar
         5hKFaBGrhjptD8nwbsog13QAYs2reI4Jsy+dI9hr+J9sBDhE9/9SGQoP3QyJO53qoHo/
         xL0x3PqceLEzqGjnH8Rl+5Cn3fV0KcuEa5F9TdwEAhVuqEZVt44m10qt0Sk6xWrwCOxG
         Hla/wtD/lieIHu8Z4ojYCEMDPFTZaZ3yy+P1K7xjjbNKIvH36ZPoLD/IiUAe7zXfw7nY
         cxGyBoCcOdHz3yhQdK+r3Ncd64HvgQoABDACA5z8lMBLHjqpHIIdn+zp5DdiGODAMRvu
         qBug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vromIZfVaRTbVHccIXLwJjG5p8UCfRytvq4A7EoGIIk=;
        b=JpKZSTP73WOWAHgMmLsKSbhbBNFU6b0OEURb9Fza1+8bDGGJEYDnRAiquazbSAhD/Q
         30QdZqqPi/39fh9Kc/nKtnQfzjHhiAmvxd/ALPcEuLxmwqux0bC2Qgba0iNG3i4Vnly8
         q4/pcBZEkTMvmPw1WxrK3EVVu/r4ufKfyW08z92cTy9IEhcTsb1+vNR0y5X1Kqer3PJw
         rSMQ/3U5P5Qt4Ppr1KC3hPRTZKY7PaB3DyKjT9VocevuSonn7J2INbx/KV7bqiR+5lWY
         7MnOQ13okUL19vnan7ltGOYPbOTubngxxpfnyzI0fw7Z1iGGLrC4Q2tMHLzCeprEdWEO
         zaaQ==
X-Gm-Message-State: AOAM533TW3ag14U7kf+kQmSs9wHoB7uuSz83Hd+dEWITi/jEOdOFnIUW
        XrbE43gPXdXrTQlzDmllbkEjRKoInPeCCdxMt5M=
X-Google-Smtp-Source: ABdhPJwsmCE7v2947ECqTMZWDTgHtortDktjonzNkV1fPsj5Zlxw4gtRiD+PYvd6bPf4Ps9ZR2O4iEAa4UH6QSzOTQk=
X-Received: by 2002:a4a:6c06:: with SMTP id q6mr6054290ooc.71.1628241462739;
 Fri, 06 Aug 2021 02:17:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210806085413.61536-1-andriy.shevchenko@linux.intel.com> <20210806085413.61536-2-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20210806085413.61536-2-andriy.shevchenko@linux.intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Fri, 6 Aug 2021 12:17:32 +0300
Message-ID: <CAHNKnsTPQp16FPuVxY+FtJVOXnSga7zt=K8bhXr2YG15M9Y0eQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] wwan: core: Unshadow error code returned by ida_alloc_range))
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 6, 2021 at 12:00 PM Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> ida_alloc_range)) may return other than -ENOMEM error code.
> Unshadow it in the wwan_create_port().
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

A small nitpick, looks like "ida_alloc_range))" in the description is
a typo and should be "ida_alloc_range()". Besides this:

Reviewed-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
