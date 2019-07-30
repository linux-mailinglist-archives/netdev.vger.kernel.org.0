Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A68687AED1
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 19:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbfG3Q75 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 12:59:57 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:37137 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725929AbfG3Q75 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 12:59:57 -0400
Received: by mail-io1-f65.google.com with SMTP id q22so9971563iog.4
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 09:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=thfSVMX6+HwxM/ty44YHwCabreMvWV/+Gb4a/AYAosM=;
        b=QDZk/EFUsh6U0OHs8YqCvTgja17nbMT2Y0sFIVcZgyTwIhEIGARc0EvYjU0bNaUDDw
         DhykaLBu959pAPwvEWt43vHt5h7OAeSRBBZov+gZsctSFuksXsHKukwZRmShoDWKA+8I
         wItHBj4PVtGEm32bkk7ccUJxqF53Ib3OaAdy0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=thfSVMX6+HwxM/ty44YHwCabreMvWV/+Gb4a/AYAosM=;
        b=uHxsRVUNe2qnzNHUGS4h+8jgxmaB57yeuL+X7QnwM7GaSdkXYLHza7B9UvnnBXxmbv
         z9HP+zj1pnL69+NAz5Pp+wjy9HFTGpavy3dyBoOKBGCF6o1dxdrKdoy8FzWX9fHv9VFT
         XJI6aEvAGjPSyUkfjO112UaN5cSNgVcoLK7x293qcJK5KU95SKsWkZ62HU1uHXxG+fyN
         BIiCd4QHwGQR8gIZcD8GtYyZZwD3ZjGxYjIAj9voE5nHUkIW4mPfjE2eg2OZzx43xzd1
         a/oMkn2/rxgNUmGriIxSPJaXuneKkUgLzK6EBk//1Js7YpFPkCH6mV/GTpyeSrrUKikS
         iJow==
X-Gm-Message-State: APjAAAXDlmNkQ+lxCoijWRlFU0XylkYyNBjZ6K0rk/MQWWVbOHk8oRpt
        CNOagbpoG5onKuHgJMOZUxJTXKewo20=
X-Google-Smtp-Source: APXvYqzcQ/Vv8GumVxOn4/hFXRGtttaOsYjQsKSMXAP+tegJ2SQe1hq84T1MP4XeT/d8OXQ5/DAXgw==
X-Received: by 2002:a6b:5a17:: with SMTP id o23mr693383iob.41.1564505996477;
        Tue, 30 Jul 2019 09:59:56 -0700 (PDT)
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com. [209.85.166.53])
        by smtp.gmail.com with ESMTPSA id j5sm50574288iom.69.2019.07.30.09.59.55
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 09:59:55 -0700 (PDT)
Received: by mail-io1-f53.google.com with SMTP id f4so129789498ioh.6
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 09:59:55 -0700 (PDT)
X-Received: by 2002:a02:5b05:: with SMTP id g5mr116310299jab.114.1564505994931;
 Tue, 30 Jul 2019 09:59:54 -0700 (PDT)
MIME-Version: 1.0
References: <20190722193939.125578-1-dianders@chromium.org> <CALtMJEB871Redpzx1u6G5GVEXz-kAP=vT6Wt98=X=xm4SEMeAQ@mail.gmail.com>
In-Reply-To: <CALtMJEB871Redpzx1u6G5GVEXz-kAP=vT6Wt98=X=xm4SEMeAQ@mail.gmail.com>
From:   Doug Anderson <dianders@chromium.org>
Date:   Tue, 30 Jul 2019 09:59:42 -0700
X-Gmail-Original-Message-ID: <CAD=FV=VfabHB=ALxvAZ_grg_V6Nkv1UkhHjHjp-_Fs=Bx94WAA@mail.gmail.com>
Message-ID: <CAD=FV=VfabHB=ALxvAZ_grg_V6Nkv1UkhHjHjp-_Fs=Bx94WAA@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] mmc: core: Fix Marvell WiFi reset by adding SDIO
 API to replug card
To:     Andreas Fenkart <afenkart@gmail.com>
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        netdev <netdev@vger.kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Xinming Hu <huxinming820@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kate Stewart <kstewart@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, Jul 30, 2019 at 1:47 AM Andreas Fenkart <afenkart@gmail.com> wrote:
>
> > * Sometimes while I was testing I saw "Fail WiFi 1" indicating a
> >   transitory failure.  Usually this was an association failure, but in
> >   one case I saw the device do "Firmware wakeup failed" after I
> >   triggered the reset.  This caused the driver to trigger a re-reset
> >   of itself which eventually recovered things.  This was good because
> >   it was an actual test of the normal reset flow (not the one
> >   triggered via sysfs).
>
> This error triggers something. I remember that when I was working on
> suspend-to-ram feature, we had problems to wake up the firmware
> reliable. I found this patch in one of my old 3.13 tree
>
>     the missing bit -- ugly hack to force cmd52 before cmd53.

Thanks for the reference!  At the moment I'm not terribly worried
about this particular failure case (compared to other failure modes)
because it's rare and it self-heals.

...my best guess, though, is that the problem isn't exactly the same.
The "Firmware wakeup failed" is a pretty generic error message, kind
of like "something went wrong" and not all instances of this message
will have the same root cause.

I actually dealt with a few suspend/resume issues around mwifiex
recently though.  If you ever uprev, you might be interested in:

b82d6c1f8f82 mwifiex: Make resume actually do something useful again
on SDIO cards
83293386bc95 mmc: core: Prevent processing SDIO IRQs when the card is suspended

-Doug
