Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2C53FBEB1
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 00:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238773AbhH3WHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 18:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbhH3WHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 18:07:37 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F2D2C061575
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 15:06:43 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id s12so28518871ljg.0
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 15:06:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dXduIRNiTa2jS4PuT2wIRdmeCNVm0z61dlNZlyEKXDQ=;
        b=Ydr8dJGdVDjhZMKazbAFuk+i8mfr+gBIderp1JYgPoSc1BUnQ6UxchuPb/ikaPu7Xe
         +enVXbIt+rKqgDQERgHCMGOLAwqRnav/+OUMH8mg/9hPZ0yoHobWln4jkSpQzvZfsyYL
         xLxmT3bAvUjDxS3+RrftmbOfmtxvKMWjDMzwVj6y5wwq5nhRoM39sik+80UV4Y34eQnJ
         Z4UOhdgqXB91rbIQv/v8iu00aWaQBF0yCoQbnMxqiN4Y8XWGxVWCcaElXDVdQYHoKHaL
         6vP8tZZxUuQuE3Kz7hrr/zTu9QNz3xInsYQCrymFS5zyoRKY/sapuaeCq/hdS5Piki8S
         cTbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dXduIRNiTa2jS4PuT2wIRdmeCNVm0z61dlNZlyEKXDQ=;
        b=W0gOeDkDpMQY4oomQS7cr08GCFuBZuYTJ93qOv618BSfOdIvWjVAXIBcR08lpWPKz1
         e+n6zlnbh7DaWuCVb9f+0SobcfzZnUUwSDi5qgy4vnOsM1QThA5yf7zCkyZ2EKLwAUVD
         gV0ixS8lAmR7ND57yR/r7fe5NZKFoKhJqhHRaJGsDF6jE5AQkm5SXMlBS1t5s52Wsux9
         iifHS+tggwMZUWTQMRvuTikN9ll7NoQ2Hx6TXFA5s1zYYya1Z5Vrg7W7xg9Ee4AaQrZs
         /uYb56dx6QAvsAUExmnVlq+rEL/DnIfT6+zchEMLyNjIufviZjuxwwu/g0uj/z7Q5qP1
         2TMw==
X-Gm-Message-State: AOAM5322b0UA4r5PaiokySnCqJKTgnRkr5P11esmfph28gQFOlRdc2Y7
        dloaMBoI+smc75Qy8SB3vzdNAri0tKP8LlBUfz6/Ag==
X-Google-Smtp-Source: ABdhPJx0CSXGW0ITJy0zYkz1ofnA9sOOotQ5+B3rBMfJbmNZJG0pkLy6MA7Qo/RDEnPtLv2VNJFz0LFzvO9IVCmQUrg=
X-Received: by 2002:a2e:54f:: with SMTP id 76mr22552514ljf.326.1630361201601;
 Mon, 30 Aug 2021 15:06:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210829002601.282521-1-linus.walleij@linaro.org>
 <20210830081254.osqvwld7w7jk7jap@skbuf> <CACRpkdZE7i1h1vPTJz+QwkDdBiVg1tF+uxhaOATZGZctkWy+Ag@mail.gmail.com>
 <20210830220155.5nbtm6khoivend6f@skbuf>
In-Reply-To: <20210830220155.5nbtm6khoivend6f@skbuf>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 31 Aug 2021 00:06:30 +0200
Message-ID: <CACRpkdZQbLEh6B-2e-oHJ8OXXDPeY5m3Lxuk52t_Z8k41yhEKw@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] net: dsa: rtl8366rb: support bridge offloading
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Mauri Sandberg <sandberg@mailfence.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 31, 2021 at 12:01 AM Vladimir Oltean <olteanv@gmail.com> wrote:
> On Mon, Aug 30, 2021 at 11:22:11PM +0200, Linus Walleij wrote:
> > On Mon, Aug 30, 2021 at 10:12 AM Vladimir Oltean <olteanv@gmail.com> wrote:
> >
> > > > +/* Port isolation registers */
> > > > +#define RTL8366RB_PORT_ISO_BASE              0x0F08
> > > > +#define RTL8366RB_PORT_ISO(pnum)     (RTL8366RB_PORT_ISO_BASE + (pnum))
> > > > +#define RTL8366RB_PORT_ISO_EN                BIT(0)
> > > > +#define RTL8366RB_PORT_ISO_PORTS_MASK        GENMASK(7, 1)
> > >
> > > If RTL8366RB_NUM_PORTS is 6, then why is RTL8366RB_PORT_ISO_PORTS_MASK a
> > > 7-bit field?
> >
> > It's a 6 bit field actually from bit 1 to bit 7 just shifted up one
> > bit because bit 0 is "enable".
>
> Understood the part about bit 0 being "ENABLE".
> But from bit 1 to bit 7, I count 7 bits set....

Oh yeah.... something is wrong with my arithmetics.

Bit 0: enable
Bit 1: port 0
Bit 2: port 1
Bit 3: port 2
Bit 4: port 3
Bit 5: port 4
Bit 6: port 5 - CPU

I'll fix with the rest of the comments for v3.

Yours,
Linus Walleij
