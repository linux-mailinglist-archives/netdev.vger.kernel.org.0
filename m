Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC3C27AA8F
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 11:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbgI1JUI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 05:20:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbgI1JUC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 05:20:02 -0400
Received: from mail-vk1-xa36.google.com (mail-vk1-xa36.google.com [IPv6:2607:f8b0:4864:20::a36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87520C0613D0
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 02:20:02 -0700 (PDT)
Received: by mail-vk1-xa36.google.com with SMTP id e5so1400527vkm.2
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 02:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QQu91B+AW3IRpHZjKS2p4lMu3W034IPbEyQrKhHugtA=;
        b=h0nsKxQ1792AaIhUo13P82vgGVMXclf9CkIZ3KapAzb2X/3tNBKYsSGecwrBlaGlfj
         Tfj/C9Zv83pHcreLOpATprEGXKgXE7GflMxTk85DdzpRec/t1LnE+wiAfP6b5BIHasHY
         Ignqf7gF7vwjnL8HCCY3lSkGXTjCE+cuCHlYoEe1V1ud1mcWehNemRROw+dC/JdC1/0c
         0PedcFoH2tLhd3HHLNfHHJrCV/CVoz/bfJ60yVp2iKXm17ESSv95/LpX2Y/Dg/8GDOjv
         2ofiMkyoa80M4iYbgDGr8oelbtFwixNkB383I0V8notORYCLMV89a0h5ooLViuYHEZeT
         ZUiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QQu91B+AW3IRpHZjKS2p4lMu3W034IPbEyQrKhHugtA=;
        b=oTLNU/vrfD/aSPWkZrHM4zcXMepNvQmCv3cVNwSmudP0Zxw53D0zDLyE02lzOiNO0Z
         YjKFhqdJc/8JclRySov1jnMFO/NwUce3kfuMMBwbqjgnujSzqD0n3qlyXPtS8S4ctoZv
         JokKga0odyHWUclSGirU0DRqocy4kllIfToiGpY5F1Gmw2+m9A4s6UsGUO+EkAq57kbG
         XJ7mb6phEE4Q7z2A2xlbswRPg0r4MYLnlfqCgnZHdbI+f1vEuAUsl3fHWPWl8pE0kaOX
         4fDkfXjGLUFChhObyd26tFJx5oL2DLHgYmOipcyPKO8T/R7UJHjY3+XChKY5rZU1v7nh
         z5Lw==
X-Gm-Message-State: AOAM530MIGeqeLZrLOu4dGgBhPzONXviFov4AtsrV0aoIRXiHS5Ha1MT
        1AJVeivQeMFFdk5wRKGdFZE/sTivQtMe7RVpnfrq2w==
X-Google-Smtp-Source: ABdhPJyIPAnJj5fPmVsL4k9MF4OtxiE77/7ix/Qafm1hzLnqts1eYR1koTMhcOn/iv3ljy6H8r2txH0J3D7/fATe+GY=
X-Received: by 2002:ac5:c748:: with SMTP id b8mr4530997vkn.6.1601284801206;
 Mon, 28 Sep 2020 02:20:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200927194846.045411263@linutronix.de> <20200927194922.245750969@linutronix.de>
 <a345ad51-4db7-5e4f-3ff9-f1673c12da99@broadcom.com>
In-Reply-To: <a345ad51-4db7-5e4f-3ff9-f1673c12da99@broadcom.com>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Mon, 28 Sep 2020 11:19:25 +0200
Message-ID: <CAPDyKFrC2j5S7NrtTRCBga=rttKBp-OZnsEnAEgnXj8zj11p0w@mail.gmail.com>
Subject: Re: [patch 24/35] net: brcmfmac: Replace in_interrupt()
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        Paul McKenney <paulmck@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        netdev <netdev@vger.kernel.org>,
        Christian Benvenuti <benve@cisco.com>,
        Govindarajulu Varadarajan <_govind@gmx.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Linux Documentation <linux-doc@vger.kernel.org>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        Vishal Kulkarni <vishal@chelsio.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        intel-wired-lan@lists.osuosl.org,
        Shannon Nelson <snelson@pensando.io>,
        Pensando Drivers <drivers@pensando.io>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        Edward Cree <ecree@solarflare.com>,
        Martin Habets <mhabets@solarflare.com>,
        Jon Mason <jdmason@kudzu.us>, Daniel Drake <dsd@gentoo.org>,
        Ulrich Kunitz <kune@deine-taler.de>,
        Linux USB List <linux-usb@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Jouni Malinen <j@w1.fi>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        libertas-dev@lists.infradead.org,
        Pascal Terjan <pterjan@google.com>,
        Ping-Ke Shih <pkshih@realtek.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Sep 2020 at 09:35, Arend Van Spriel
<arend.vanspriel@broadcom.com> wrote:
>
> + Uffe
>
> On 9/27/2020 9:49 PM, Thomas Gleixner wrote:
> > @@ -85,7 +85,7 @@ static void brcmf_sdiod_ib_irqhandler(st
> >
> >       brcmf_dbg(INTR, "IB intr triggered\n");
> >
> > -     brcmf_sdio_isr(sdiodev->bus);
> > +     brcmf_sdio_isr(sdiodev->bus, false);
> >   }
>
> Hi Uffe,
>
> I assume the above code is okay, but want to confirm. Is the SDIO
> interrupt guaranteed to be on a worker thread?

Correct.

As a matter of fact, the sdio irqs can be delivered through a couple
of different paths. The legacy (scheduled for removal), is from a
dedicated kthread. The more "modern" way is either from the context of
a threaded IRQ handler or via a workqueue.

However, there are also so-called out of band SDIO irqs, typically
routed via a separate GPIO line. This isn't managed by the MMC/SDIO
subsystem, but the SDIO functional driver itself.

Kind regards
Uffe
