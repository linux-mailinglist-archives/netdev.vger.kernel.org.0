Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA21C683ABE
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 00:53:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbjAaXxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 18:53:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbjAaXxK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 18:53:10 -0500
Received: from mail-oa1-x31.google.com (mail-oa1-x31.google.com [IPv6:2001:4860:4864:20::31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CC2E1815C;
        Tue, 31 Jan 2023 15:53:09 -0800 (PST)
Received: by mail-oa1-x31.google.com with SMTP id 586e51a60fabf-15085b8a2f7so21536080fac.2;
        Tue, 31 Jan 2023 15:53:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vYdEeqjNgoJHoM9SJT0m+2v5Gmt/A9maZs7Zf5eYT0U=;
        b=CXfgZBjaN8iKI3nm7eBxc2m4WpogJtbLT+AgoHycgD3olULfXSwuI5j6/GiFc+jBob
         VmUL2tKDllcVmP+K2CA7vvg2wZ8pgWhZQ9NCPjNqAmL+zoYygQdvvMS5aA+ysALBl0Ir
         2kYQpf8bLQhF8b6euAOzPPPUgbN8bjJLUJEXBW/pCQhnKgc/u6aP3zDwfIHXEo22xUoT
         bDaHWBfqKM1wwYwuE7T/aEGfOx3T8DGPefE270WKYN7FcFSwfmeNPYyFoK29oriJxSay
         USjEZphJE7VRAjnw253uW3MnklxL2NtDu5vAAfR+wI2xdfwA15SrqJsubYA5m8Y2AiCY
         yV3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vYdEeqjNgoJHoM9SJT0m+2v5Gmt/A9maZs7Zf5eYT0U=;
        b=D1l+hragq5mQqffvXdZJ3k+IyveYt1zpRvTyJpFA4z7IWUcRU2njDnfKVgPDSJd7U4
         S+d0dBuFch7Z/0bbBxG4NVwJl5Hnr1ZchMXPkEvW7PDGyywOwCaeVpwZf8q9qMvUintA
         fuSY1SgRZLkUiaEqWwt4BDPCc2sFKB5uG5pCggyGWwGSU2LPRP/01ZpJQtOEkvlDKoij
         EHaAchvL9OK6DeVKcYT8EkRGxTLjuB8g6D8E8GTDZnwufBoE479+cZePqdUw1BldbTrz
         gSvrbRZM5o599K9CNPHZMQg1voWY7YYpdZagxtBKVMOo5WiV95Tmk2NyMHqfAnI8r0eg
         lwTA==
X-Gm-Message-State: AO0yUKUzK5eJ4PxR+jgDzRvnnvjmhagRGh3gkd6KTRyAB001fnWfV4SY
        17WvkOg5w2eMbA5cNSY3yKHqVk/UCqabWi3lHfZYFJ9d/6Y=
X-Google-Smtp-Source: AK7set9X0fMapUox6SkZRqxLHjb6kHYlavJvRHqQlWZX9LMKSI82Azfoc1BVOABrvqzOsDMgTuUiphTTOOsZEQJxB5E=
X-Received: by 2002:a05:6870:3913:b0:163:4ae7:f200 with SMTP id
 b19-20020a056870391300b001634ae7f200mr2021361oap.84.1675209188690; Tue, 31
 Jan 2023 15:53:08 -0800 (PST)
MIME-Version: 1.0
References: <20230126162323.2986682-1-arnd@kernel.org>
In-Reply-To: <20230126162323.2986682-1-arnd@kernel.org>
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date:   Tue, 31 Jan 2023 15:52:55 -0800
Message-ID: <CAKdAkRQT_Jk5yBeMZqh=M1JscVLFieZTQjLGOGxy8nHh8SnD3A@mail.gmail.com>
Subject: Re: [PATCH] [v2] at86rf230: convert to gpio descriptors
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arnd,

On Thu, Jan 26, 2023 at 8:32 AM Arnd Bergmann <arnd@kernel.org> wrote:
>
>         /* Reset */
> -       if (gpio_is_valid(rstn)) {
> +       if (rstn) {
>                 udelay(1);
> -               gpio_set_value_cansleep(rstn, 0);
> +               gpiod_set_value_cansleep(rstn, 0);
>                 udelay(1);
> -               gpio_set_value_cansleep(rstn, 1);
> +               gpiod_set_value_cansleep(rstn, 1);

For gpiod conversions, if we are not willing to chase whether existing
DTSes specify polarities
properly and create workarounds in case they are wrong, we should use
gpiod_set_raw_value*()
(my preference would be to do the work and not use "raw" variants).

In this particular case, arch/arm/boot/dts/vf610-zii-dev-rev-c.dts
defines reset line as active low,
so you are leaving the device in reset state.

Please review your other conversion patches.

-- 
Dmitry
