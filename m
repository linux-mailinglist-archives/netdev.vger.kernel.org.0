Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D60892FE853
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 12:05:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730076AbhAULEy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 06:04:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729699AbhAULAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 06:00:18 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 133D5C061757;
        Thu, 21 Jan 2021 02:59:35 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id k4so1632937ybp.6;
        Thu, 21 Jan 2021 02:59:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D4r2Cm5wi36MAtNGLmZUx5fSiHgdYZQwfc9/LYxhsaU=;
        b=qYkwSaxnNSKrsVWlgQCyKxX0qbplVfayR48rlv5/QdlKbn+gvUVdUT0QyJgBiwow6t
         S8LRk6G+1TTwxdzxQZIIVaEUcfdQljBqzI1Znm1NHe3lRkUI4RMcdtYaU+R6Cd5sGoqe
         45K6IefVFenpMV+1rMU6JT3UL6lWAnFtUgPCXZxKGCQGn5H5Rc3M6uhsFjnWfCPqSFfp
         +4M8WUF7ssR4HUIAX7o+BAOx0/ohPr75wODhO1xW2r6ZYWSj+lhTBNV2X+IdGvxBFH1y
         fK+5ZN/VvlM9QQdbVjpR/NIwY+8AMCdxIVrtg0XzZJfkND5JxGCfEx2RKKAaqwk04G6+
         2AoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D4r2Cm5wi36MAtNGLmZUx5fSiHgdYZQwfc9/LYxhsaU=;
        b=MaB2B56baYTz8AxHqMz1ZrrJ4UTjcmYQ5TvLXdwiadnDrXGbdcMg2tIYL/p1rQ6Vfk
         1X8uLH86H1QeUqUWRBuhLJSkDL2kaR2+kdy14GlHnut+6Ox8V+6cohvU/EwsCDbgmZ2i
         XEJW4El0F+BRr09QSRxyV26u1hxmqeVf5t4cMNahRiYDJkxOiH3cEfqnl0DgyijmWgOn
         L33KX+yiY3nxbeMm65cpqqFRKmWnBOzq4zjatUJKOKw5EmqLEtr0IY+Espd/Mmf/eP8d
         T0zVmKnJLMJt/WaeN0thAlH/A+3UxHsqCFOb+OXIF21fwBhSz1sReaZMpQLvcTTLR62d
         S87Q==
X-Gm-Message-State: AOAM531A5JBLMyW5jRY/HlhEmx96OYLRq3kn69BUVhvZNpE9msoSa64D
        9L0KnvnY6GNH1ASXBrBDCWFTKtZt32DqoNmrjj8=
X-Google-Smtp-Source: ABdhPJzFhppfyjoyfvL1dN7Z6XOVKf8ajHI6Pa8b5iQytTEu8cPPhacLIYMFjE9aNhGmY3WK5UkKVvt4UREhWDfRwcY=
X-Received: by 2002:a25:688c:: with SMTP id d134mr20599838ybc.477.1611226774349;
 Thu, 21 Jan 2021 02:59:34 -0800 (PST)
MIME-Version: 1.0
References: <20210121092026.3261412-1-mudongliangabcd@gmail.com> <YAlORNKQ4y7bzYeZ@kroah.com>
In-Reply-To: <YAlORNKQ4y7bzYeZ@kroah.com>
From:   =?UTF-8?B?5oWV5Yas5Lqu?= <mudongliangabcd@gmail.com>
Date:   Thu, 21 Jan 2021 18:59:08 +0800
Message-ID: <CAD-N9QXhD48-6GbpCUYuxPKEbkzGgGTaFKQ8TAaQ93WfD_sT2A@mail.gmail.com>
Subject: Re: [PATCH] rt2x00: reset reg earlier in rt2500usb_register_read
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     davem@davemloft.net, helmut.schaa@googlemail.com,
        kvalo@codeaurora.org, linux-kernel <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        sgruszka@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 21, 2021 at 5:49 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Thu, Jan 21, 2021 at 05:20:26PM +0800, Dongliang Mu wrote:
> > In the function rt2500usb_register_read(_lock), reg is uninitialized
> > in some situation. Then KMSAN reports uninit-value at its first memory
> > access. To fix this issue, add one reg initialization in the function
> > rt2500usb_register_read and rt2500usb_register_read_lock
> >
> > BUG: KMSAN: uninit-value in rt2500usb_init_eeprom rt2500usb.c:1443 [inline]
> > BUG: KMSAN: uninit-value in rt2500usb_probe_hw+0xb5e/0x22a0 rt2500usb.c:1757
> > CPU: 0 PID: 3369 Comm: kworker/0:2 Not tainted 5.3.0-rc7+ #0
> > Hardware name: Google Compute Engine
> > Workqueue: usb_hub_wq hub_event
> > Call Trace:
> >  __dump_stack lib/dump_stack.c:77 [inline]
> >  dump_stack+0x191/0x1f0 lib/dump_stack.c:113
> >  kmsan_report+0x162/0x2d0 mm/kmsan/kmsan_report.c:109
> >  __msan_warning+0x75/0xe0 mm/kmsan/kmsan_instr.c:294
> >  rt2500usb_init_eeprom wireless/ralink/rt2x00/rt2500usb.c:1443 [inline]
> >  rt2500usb_probe_hw+0xb5e/0x22a0 wireless/ralink/rt2x00/rt2500usb.c:1757
> >  rt2x00lib_probe_dev+0xba9/0x3260 wireless/ralink/rt2x00/rt2x00dev.c:1427
> >  rt2x00usb_probe+0x7ae/0xf60 wireless/ralink/rt2x00/rt2x00usb.c:842
> >  rt2500usb_probe+0x50/0x60 wireless/ralink/rt2x00/rt2500usb.c:1966
> >  ......
> >
> > Local variable description: ----reg.i.i@rt2500usb_probe_hw
> > Variable was created at:
> >  rt2500usb_register_read wireless/ralink/rt2x00/rt2500usb.c:51 [inline]
> >  rt2500usb_init_eeprom wireless/ralink/rt2x00/rt2500usb.c:1440 [inline]
> >  rt2500usb_probe_hw+0x774/0x22a0 wireless/ralink/rt2x00/rt2500usb.c:1757
> >  rt2x00lib_probe_dev+0xba9/0x3260 wireless/ralink/rt2x00/rt2x00dev.c:1427
> >
> > Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
> > ---
> >  drivers/net/wireless/ralink/rt2x00/rt2500usb.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/drivers/net/wireless/ralink/rt2x00/rt2500usb.c b/drivers/net/wireless/ralink/rt2x00/rt2500usb.c
> > index fce05fc88aaf..f6c93a25b18c 100644
> > --- a/drivers/net/wireless/ralink/rt2x00/rt2500usb.c
> > +++ b/drivers/net/wireless/ralink/rt2x00/rt2500usb.c
> > @@ -48,6 +48,7 @@ static u16 rt2500usb_register_read(struct rt2x00_dev *rt2x00dev,
> >                                  const unsigned int offset)
> >  {
> >       __le16 reg;
> > +     memset(&reg, 0, sizeof(reg));
>
> As was pointed out, just set reg = 0 on the line above please.

I've sent another patch.

BTW, I set "--subject-prefix="PATCH v2" in my git-send-mail command.
But it does not show "v2" in the subject of the new email.

>
> >       rt2x00usb_vendor_request_buff(rt2x00dev, USB_MULTI_READ,
> >                                     USB_VENDOR_REQUEST_IN, offset,
> >                                     &reg, sizeof(reg));
>
> Are you sure this is valid to call this function with a variable on the
> stack like this?  How did you test this change?

First, I did not do any changes to this call. Second, the programming
style to pass the pointer of stack variable as arguments is not really
good. Third, I check this same code file, there are many code snippets
with such programming style. :(

>
> thanks,
>
> greg k-h
