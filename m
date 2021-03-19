Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ACCC3428AE
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 23:26:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbhCSWZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 18:25:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230476AbhCSWZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 18:25:35 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC035C061760;
        Fri, 19 Mar 2021 15:25:35 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id i3so6373118oik.7;
        Fri, 19 Mar 2021 15:25:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LgipKyceb0j7HbNt9olK50Ew2nFId355eSf3DWbsDmQ=;
        b=E6/aX0SLolulg/q7LAu0QP1FMSFpvbaBMRIf9T6qOFCEjH+UH9fnjyxj+R9H4ehxd7
         fnGauzMNsDJ/02/zhevr1MYpgEI733eE6mLgZtqY2Ql/DbPadCcIF0j07YdmeV3P/rZV
         zTTO4G3AOdSIoXKUfRtV/HElHpo+zojTxAm/xLPctwjTSxqvRJxcjdXwaI38Areqw/cu
         wm7kTumtERUY6SDOZ0w4EjpxTeSMvxz3soDokNKGAqyv5GW9zGSgktKklujvR2qVtoh3
         EQR8c5lfU0zVnomy6KrhKUjthIDdi7FE5Y3bNivXflPAWQVT46zouimmBkTbRYsNtwzG
         Iusg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LgipKyceb0j7HbNt9olK50Ew2nFId355eSf3DWbsDmQ=;
        b=h+fUHBk3oMlvFgD6+kDI8CmsrotS99Cgl1v16yOmGwm7KypDLxkL8htrqnwehO4Vxz
         dZ3LPJQOeABJrIitoSfIcVeTGI5S2IE3CjIgPRBfyZsrpJqWJE/WaXIflGd1W4ZBkTLE
         YcIjIdbKlSzX2hA2l0V+C9QQmGtQCekmJLibopsxikDmO3zNnZEahv+BXtEei+3Tg45O
         fq9pfBmF/e8XXaUp51LEMTuR5IF81xEhjOeKAKIUsN103PUBRc0gjvBA9EkEpy1FgSW4
         aO+Gvu+29MqlRgQ+ni3Ki5sdbkXY41cHaxTmzK8eTadeTlSlspbOdJJ/BiXIGY8RplLu
         mt4w==
X-Gm-Message-State: AOAM531OL65xf1385QTnB0AVLYRMN9PkAuCCQQ/S1F+RR2VlI2lJPpZL
        EG/8VPex/fzabN3S98sAB3JlbNeInGOuLEWzbs8=
X-Google-Smtp-Source: ABdhPJx0vrAXgauF/H5vmgAfB1ALItNG5X+bPhGv5vZ7jCmD3Gv2pIN4yWiGQReurrOVrA8yNX8JUV3Y+jlC0y53t48=
X-Received: by 2002:aca:a9d8:: with SMTP id s207mr2570191oie.18.1616192735280;
 Fri, 19 Mar 2021 15:25:35 -0700 (PDT)
MIME-Version: 1.0
References: <87tupl30kl.fsf@igel.home> <04a7e801-9a55-c926-34ad-3a7665077a4e@microchip.com>
 <87o8fhoieu.fsf@igel.home> <CALecT5gY1GK774TXyM+zA3J9Q8O90UKMs3bvRk13yg9_+cFO3Q@mail.gmail.com>
 <87h7l77cgn.fsf@igel.home>
In-Reply-To: <87h7l77cgn.fsf@igel.home>
From:   Yixun Lan <yixun.lan@gmail.com>
Date:   Sat, 20 Mar 2021 06:25:24 +0800
Message-ID: <CALecT5jFGr+QtEWgD3M5JCH0d7O6N7PokaNbQaisyxgEU6fx=Q@mail.gmail.com>
Subject: Re: macb broken on HiFive Unleashed
To:     Andreas Schwab <schwab@linux-m68k.org>
Cc:     Claudiu.Beznea@microchip.com,
        linux-riscv <linux-riscv@lists.infradead.org>,
        ckeepax@opensource.cirrus.com, andrew@lunn.ch, w@1wt.eu,
        Nicolas.Ferre@microchip.com, Daniel Palmer <daniel@0x0f.com>,
        alexandre.belloni@bootlin.com, pthombar@cadence.com,
        netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

HI Andreas, Zong:

On Fri, Mar 19, 2021 at 4:51 PM Andreas Schwab <schwab@linux-m68k.org> wrot=
e:
>
> On M=C3=A4r 19 2021, Yixun Lan wrote:
>
> > what's the exact root cause? and any solution?
>
> Try reverting the five commits starting with
> 732374a0b440d9a79c8412f318a25cd37ba6f4e2.
>
I confirm reverting those five patches make the ethernet work again
tested with kernel version 5.11.7

Yixun Lan
