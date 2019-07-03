Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7C905DF21
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 09:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbfGCHwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 03:52:04 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:38697 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727004AbfGCHwE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 03:52:04 -0400
Received: by mail-qt1-f193.google.com with SMTP id n11so1509007qtl.5
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 00:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s66oi9wv6cr45MUFeBju9R+3UH6mihLo8M4hLx+/17M=;
        b=pR5t05rilFoCaOx3zBKPC98Xo4/ZC1B9TAeCbhpbZYHsx1U3U2GalsHUlxmIMIZEL/
         DHFkn/yhanZJFTIte9mbS/vDmP0XMlWHfBrbHFsG3jW7Km4xS+thcjafTze+p9c5Bf6F
         64FRIPKiDWpLFpkwj8BBn+sh0D/GVGG9usWdlsoc1vQcdgH+ZZDVtPHhR2tfHirtvUIh
         Tfi5AAyO1bWkn4HHltKYlYfasuBZmW0LpIOGKq5+hhiSpsNY24dmJek3YLW38tcZHgNG
         /rgSWB/FJkC/FoMSDoaBG2elIDhqlNFMA+B4vc+WJkzaVgXKSdmW3IX/9JGsJsXW2z/2
         wHnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s66oi9wv6cr45MUFeBju9R+3UH6mihLo8M4hLx+/17M=;
        b=Bhr/cF0y7xlEIcK5F9cicqi+uuKQiyME6uCLN15/DIsfdgMphTCw5i49qGMimALRs9
         YNsDvuwq99/GuinsGMBwM9FyySyOibebRFUHjG8hGkxcAATyOisfkvXUjm3E2jflT2Ed
         XWtce8B4RE/EwR/uTmm/W9AccLT1NM4B7N4cItW3JIidCvFtzOJAo6/EMQCRt7xGAbGd
         MkIE3TFrjrqorN+2l1gWTWw5iWdIc0R9PN7tthapU+65QotcGjs5B1arZc7rQuEvZRHw
         UApMoDaGLJl0fufNg526eVhDzBuWSvoZm8zl137X9EBKIXHKE1sFvuaGB5UWNkcJ4EQS
         NKrg==
X-Gm-Message-State: APjAAAUft/u6VaoV76d+GZIH8H0R+W54ljpVbTS9riAZsyqPi96sBQbi
        y5Q0k5DL+I1QIebcW//ccKX7yTsk9tXQnBJLYtJtUw==
X-Google-Smtp-Source: APXvYqxpw7FOK6ud0IGvGgjeMvhuEOXhvcYmJ2duTPIwVgNO62XPlIw8S2PbP/1uPZsNpYg9hdzKHVlV0GGGyjTfoDk=
X-Received: by 2002:aed:21f0:: with SMTP id m45mr29178397qtc.391.1562140323204;
 Wed, 03 Jul 2019 00:52:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190627095247.8792-1-chiu@endlessm.com> <CAD8Lp44R0a1=fVi=fGv69w1ppdcaFV01opkdkhaX-eJ=K=tYeA@mail.gmail.com>
 <CAB4CAwcVoWffpK8xR_UbXaGyHh8ZrrX_9vvzjAkWGKXQotpmYA@mail.gmail.com>
In-Reply-To: <CAB4CAwcVoWffpK8xR_UbXaGyHh8ZrrX_9vvzjAkWGKXQotpmYA@mail.gmail.com>
From:   Daniel Drake <drake@endlessm.com>
Date:   Wed, 3 Jul 2019 15:51:52 +0800
Message-ID: <CAD8Lp44fjuJ-hf=8Spb9n8gkv-sS0f2O3Xv+E6=MmC_ugKnW-g@mail.gmail.com>
Subject: Re: [PATCH] rtl8xxxu: Fix wifi low signal strength issue of RTL8723BU
To:     Chris Chiu <chiu@endlessm.com>
Cc:     Jes Sorensen <jes.sorensen@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        David Miller <davem@davemloft.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Upstreaming Team <linux@endlessm.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 2, 2019 at 4:01 PM Chris Chiu <chiu@endlessm.com> wrote:
> When the vendor driver invokes rtw_btcoex_HAL_Initialize, which will then
> call halbtc8723b1ant_SetAntPath to configure the registers in this patch.
> From the code, the registers will have different register settings per the
> antenna position and the phase. If the driver is in the InitHwConfig phase,
> the register value is identical to what rtl8xxxu driver does in enable_rf().
> However, the vendor driver will do halbtc8723b1ant_PsTdma() twice by
> halbtc8723b1ant_ActionWifiNotConnected() with the type argument 8 for
> PTA control about 200ms after InitHwConfig. The _ActionWifiNotConnected
> is invoked by the BTCOEXIST. I keep seeing the halbtc8723b1ant_PsTdma
> with type 8 been called every 2 seconds.

I see. So this is a measured step towards consistency with the vendor
driver. Maybe you can mention these details in the commit message.

> Yes, it ends up with 0x0c not matter what antenna position type is. Unless
> it's configured wifi only.

Also worth mentioning in the commit message then, that the 0xc
ACT_CONTROL value is effectively what the working vendor driver uses.

> > > -        * 0x280, 0x00, 0x200, 0x80 - not clear
> > > +        * Different settings per different antenna position.
> > > +        * Antenna switch to BT: 0x280, 0x00 (inverse)
> > > +        * Antenna switch to WiFi: 0x0, 0x280 (inverse)
> > > +        * Antenna controlled by PTA: 0x200, 0x80 (inverse)
> > >          */
> > > -       rtl8xxxu_write32(priv, REG_S0S1_PATH_SWITCH, 0x00);
> > > +       rtl8xxxu_write32(priv, REG_S0S1_PATH_SWITCH, 0x80);
> >
> > I don't quite follow the comment here. Why are there 2 values listed
> > for each possibility, what do you mean by inverse? You say the
> > register settings were incorrect, but the previous value was 0x00
> > which you now document as "antenna switch to wifi" which sounds like
> > it was already correct?
> >
> > Which value does the vendor driver use?
> >
> The first column means the value for normal antenna installation, wifi
> on the main port. The second column is the value for inverse antenna
> installation. So if I want to manually switch the antenna for BT use,
> and the antenna installation is inverse, I need to set to 0x280. So 0x80
> means I want to switch to PTA and the antenna installation in inverse.

Still not quite clear what you mean by "inverse" here, but maybe I
just don't know anything about antennas. Is it that an antenna
connector has two pins and this one swaps the meaning of each pin?

Does the new value of 0x80 reflect what the vendor driver does in practice?

Thanks
Daniel
