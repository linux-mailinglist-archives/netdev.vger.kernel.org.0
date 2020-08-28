Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD46225592A
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 13:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729204AbgH1LHq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 07:07:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729177AbgH1LGr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 07:06:47 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D030C061264;
        Fri, 28 Aug 2020 04:06:36 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id k20so516260wmi.5;
        Fri, 28 Aug 2020 04:06:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bzCkNueS5Za9fJgI1E1trgmJ9rPWtcxrqIv2kBAEIIA=;
        b=nqNXrGMQwoqzpRB0gErrvZ6yYPDlhcf0cEjJP4PIpxwB3TJzLQD9R6QDUdKahtv6/G
         ZG5GzNPiR3HzMBsN7cl7yvedrbGYXei4jvXKk0FC+HLsZk4t3B8ErGvWAi6d0A1Hz3kD
         cqzdi1s+VA8IcfGwk04GBOtpvpWF3RhR4DZWmDeft7V1jvKr3zwKGJdg/60VgxmAE6T5
         /r/dLa1uLko+S0/vjA52DFxzWzL1etpUz08eF86r1EkTpCn33uxnV9yZ3UEHiMonJsZ2
         nVKQawEmps+uIMH/wWb+Bl17iC79KiLZDSXwusWhNGVKTqelTrDd0SzrUeaKdQ5YGE8P
         4fZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bzCkNueS5Za9fJgI1E1trgmJ9rPWtcxrqIv2kBAEIIA=;
        b=Q9pcU0L4hpNSEdkVAg80LQpQ8rN0rvtec/Geb7QOS1wbJrpxiDJsaOIPQ5zAdfYjtA
         nNDO9lR3siWOOSCQ36BjhR2hs31HB4PcvY1CPMD38tMbK4DnlUa2qJAv8QOOLQtUSE7a
         wLIa04zOdlTUL6AILSUIVUVw6xTjMEmgMi6Gch6syGVDK8w6bxjgUht6K0pWUiL/Y/w9
         ucre9CAlOJU09TXA+d3fu/mmDtRJgyfmzO9bQVFEtHj0egcGAvzQmr8clf/6xCk3LZQW
         2KTq834GrQjubi6+GiVL3JETr5IBE3sHZZ8E9bKdfV8wZrz9HPC0ImTjGc2q9EkoVd8I
         oYHA==
X-Gm-Message-State: AOAM5323VWmKtPx9jqWd/4NJiGg28l0RQmShZt5SU29nRDlgfh5rMOJV
        MEHbCEFzNz6w5AjlRvSwfnBCaPxAHUwsqwuiyi58a0DA+cs=
X-Google-Smtp-Source: ABdhPJwEGhSTxPCFU8vPrE3opqM8wcD1YF7m5PGxddaCKQmaFW5dJBzjJv1a3VJ25037p9UaUp0nkEGDo0oVxkrByx4=
X-Received: by 2002:a7b:c923:: with SMTP id h3mr1025587wml.29.1598612795186;
 Fri, 28 Aug 2020 04:06:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200827065355.15177-1-himadrispandya@gmail.com> <5dd266df-33cf-f351-7253-33a7f589cd56@gmail.com>
In-Reply-To: <5dd266df-33cf-f351-7253-33a7f589cd56@gmail.com>
From:   Himadri Pandya <himadrispandya@gmail.com>
Date:   Fri, 28 Aug 2020 16:36:22 +0530
Message-ID: <CAOY-YV=Ad6E2nbJ-m9SHW4zuet9VeDMLw9M-VtTebp0Far-8SA@mail.gmail.com>
Subject: Re: [PATCH] net: usb: Fix uninit-was-stored issue in asix_read_phy_addr()
To:     Sergei Shtylyov <sergei.shtylyov@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 27, 2020 at 1:28 PM Sergei Shtylyov
<sergei.shtylyov@gmail.com> wrote:
>
> Hello!
>
> On 27.08.2020 9:53, Himadri Pandya wrote:
>
> > The buffer size is 2 Bytes and we expect to receive the same amount of
> > data. But sometimes we receive less data and run into uninit-was-stored
> > issue upon read. Hence modify the error check on the return value to match
> > with the buffer size as a prevention.
> >
> > Reported-and-tested by: syzbot+a7e220df5a81d1ab400e@syzkaller.appspotmail.com
> > Signed-off-by: Himadri Pandya <himadrispandya@gmail.com>
> > ---
> >   drivers/net/usb/asix_common.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/usb/asix_common.c b/drivers/net/usb/asix_common.c
> > index e39f41efda3e..7bc6e8f856fe 100644
> > --- a/drivers/net/usb/asix_common.c
> > +++ b/drivers/net/usb/asix_common.c
> > @@ -296,7 +296,7 @@ int asix_read_phy_addr(struct usbnet *dev, int internal)
> >
> >       netdev_dbg(dev->net, "asix_get_phy_addr()\n");
> >
> > -     if (ret < 0) {
> > +     if (ret < 2) {
> >               netdev_err(dev->net, "Error reading PHYID register: %02x\n", ret);
>
>     Hm... printing possibly negative values as hex?
>

Yeah. That's odd! Fixing it.

Thanks,
Himadri

> [...]
>
> MBR, Sergei
