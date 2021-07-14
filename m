Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D71F3C9400
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 00:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236253AbhGNWua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 18:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230507AbhGNWu3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 18:50:29 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 551A9C06175F;
        Wed, 14 Jul 2021 15:47:36 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id w14so5342694edc.8;
        Wed, 14 Jul 2021 15:47:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uob5Zh3jNRgLuAYF2DKZCcuatsHYABlaKh+1oYXiYkI=;
        b=rAkmZn6YBFlnXA01SUW2mp+V1H+5gpr51nSikR8quwD18KOKcSi0+P4MqsuCbneaKG
         8cgTLJo+5JBKf0B4+AKf21D7YZd0UIbn8s/7k6Irkw7X7nd2QHYsYhQBqc+kmo8NZZqp
         TacrBUck4BpSvy8dp9tiqq+94KFsP+OeWyatUBfpl4ZEjfeOcxn2Qht92IO+NKepNTv+
         F7w914SmZgPO87iq0sj4Kvkp4jHujCP1k9txotaLizvqefKTf4cEF5fMB1M2PMPzREY0
         rLwhXsTXBGjz3paSS/BiLJ3oGqkb70eWuRNBVmmgqnCanlfwHajIzcpOX9fn36dn18CG
         tcRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uob5Zh3jNRgLuAYF2DKZCcuatsHYABlaKh+1oYXiYkI=;
        b=TnalzniiTlOcJznul5ao9pbKaxq/3Bx2GouW8wvTYuDbBsq7tXCIqVwk29OTpAn2Mc
         g6p+WwGeNGZE68Xkxa230CQQy54JiMNLrv1BKPRYYijRa/WdAQXlBn3WD/thtqBd+vXl
         NrA9BIf4emmfd2uK0HcL4S+YYssNVAHazQV5P6/t9jmizHueF0v/cDgnPzCplkkD/Vva
         ce2ZD6H8EmGS/VfhSyITZg0ED9aFFb6QKYrgxzEpg66onQ7NoLoj6zxcqeSwBKVZXLY0
         Vi5u3vqQzSYnu539bGAIVQNpuAvmZJNMNcYcputkQx+im89K0Wy6YkXtR+1vDtyEcUk1
         WJNg==
X-Gm-Message-State: AOAM532fqLj//a6x/1+9XdIY6X1nbOO87NGRPm3I00iKZqPwSbFPlXLF
        b7I07MQlNBcSTkkeV6R/yAfcIQ0zngnlaBtF2/w=
X-Google-Smtp-Source: ABdhPJy+l2f+5bel/MMnQUAKGmO48ypfU23MAAwxj349SBMRbCGQ6VIuf/sQFdE0/Vr3bjGhzGXotIwlHGZEmUknuVs=
X-Received: by 2002:a50:9554:: with SMTP id v20mr881082eda.179.1626302854946;
 Wed, 14 Jul 2021 15:47:34 -0700 (PDT)
MIME-Version: 1.0
References: <CAFBinCDMPPJ7qW7xTkep1Trg+zP0B9Jxei6sgjqmF4NDA1JAhQ@mail.gmail.com>
 <3c61fae611294e5098e6e0044a7a4199@realtek.com>
In-Reply-To: <3c61fae611294e5098e6e0044a7a4199@realtek.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Thu, 15 Jul 2021 00:47:23 +0200
Message-ID: <CAFBinCA4mDrBCjcNazW_mUW9NkC9sq-AULFJEh7z3Aj5oCyrxQ@mail.gmail.com>
Subject: Re: rtw88: rtw_{read,write}_rf locking questions
To:     Pkshih <pkshih@realtek.com>
Cc:     Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Ping-Ke,

On Wed, Jul 14, 2021 at 3:48 AM Pkshih <pkshih@realtek.com> wrote:
>
>
> > -----Original Message-----
> > From: Martin Blumenstingl [mailto:martin.blumenstingl@googlemail.com]
> > Sent: Wednesday, July 14, 2021 12:51 AM
> > To: Yan-Hsuan Chuang; Pkshih; Tzu-En Huang
> > Cc: linux-wireless@vger.kernel.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Neo Jou;
> > Jernej Skrabec
> > Subject: rtw88: rtw_{read,write}_rf locking questions
> >
> > Hello rtw88 maintainers and contributors,
> >
> > there is an ongoing effort where Jernej and I are working on adding
> > SDIO support to the rtw88 driver.
> > The hardware we use at the moment is RTL8822BS and RTL8822CS.
> > Work-in-progress code can be found in Jernej's repo (note: this may be
> > rebased): [0]
>
> Thanks for your nice work!
A quick update: we got scanning and authentication to work.

> > We are at a point where we can communicate with the SDIO card and
> > successfully upload the firmware to it.
> > Right now I have two questions about the locking in
> > rtw_{read,write}_rf from hci.h:
> > 1) A spinlock is used to protect RF register access. This is
> > problematic for SDIO, more information below. Would you accept a patch
> > to convert this into a mutex? I don't have any rtw88 PCIe card for
> > testing any regressions there myself.
>
> I think it's okay.
Great, thanks for confirming this!
I'll send a series of patches with locking preparations (patches which
add SDIO support will come later as we're still trying to narrow down
a few issues).

> > 2) I would like to understand why the RF register access needs to be
> > protected by a lock. From what I can tell RF register access doesn't
> > seem to be used from IRQ handlers.
>
> The use of lock isn't because we want to access the RF register in IRQ
> handlers. The reasons are
> 1. The ieee80211 iterative vif function we use is atomic type, so we can't
>    use mutex.
>    Do you change the type of iterative function?
yes, that is part of the "locking preparation" patches I mentioned above

> 2. RF register access isn't an atomic. If more than one threads access the
>    register at the same time, the value will be wrong.
Understood, thanks for pointing this out.


Best regards,
Martin
