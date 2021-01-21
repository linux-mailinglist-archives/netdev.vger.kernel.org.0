Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36E922FE8BC
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 12:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728657AbhAUL07 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 06:26:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726603AbhAUL0j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 06:26:39 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7F21C0613D3;
        Thu, 21 Jan 2021 03:25:58 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id y4so1717140ybn.3;
        Thu, 21 Jan 2021 03:25:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=k9t1av7olujuCjiWRao1+foelfX8Dllx4K3zuzbAp08=;
        b=taU/XiBsk52yDFqqDgjQA0bad/3BoAoLe3P8app055QZ9J2qP/yY+2mlnkTfVU3Tl8
         cqGIRyt1YNUB2iaaKijOP6S978PG7uQm1Yh/2fP0AdgDBdMpn1LMqgk0/5vvf6pCe+zp
         lqPjzFjgPfH72xqoRJAZUC1I/OUYGnL7KerFnT3avyxGGVYcmC5D55YgILJnMxaKLv6Y
         qtlLXlY1bop0hAX+le5xO8b1VoQTfd+OwpnTfb88r+dgQJK7s5xa65+oWBtVgGIo+X/i
         7ygIWTDk9GTKTzUgNdqkd5wpR/oDY2yg4pgbvvKqrHVMMxfB/Ltucgbt2nW0CJ7/I/zz
         1yDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=k9t1av7olujuCjiWRao1+foelfX8Dllx4K3zuzbAp08=;
        b=rc5TQfKi5Mz6SgrGqbdNMg0vzCOl/tURmL5pFPnpsOqbVfjfEhBhqb+WMNEB1eYMLr
         DuT3iKCQ4HJHclG7sUPp6gvePcgu5/HhqnpzxAToI/DkJ1TpIEGn07F+km5X7O4st573
         gqvptJlZwAdbWljkRzjBdVpnK72cAdxns6nqFybzoCxyLRgT11+0cWtHoHZyXiyAt3oy
         W+io2vg8KkKgdcQizt/cCTxlfAKHnSAcFx14o+rc+iMZQznrmEeRDShGpJZPgJqa0ubm
         yF5/KX4hMhflImPOToxlzFq8usx4judPhh0eOdIvZiZH+u64DmNqai0AtzDB9AvVjT+D
         PZwg==
X-Gm-Message-State: AOAM531h9C/o3orfOyBWY+ZZUw6jahjRvuh+bMj7yf7Z8Z4LU/6Cre+W
        5Uh0/PPPGtfU+CSbZ2OZLUGMH5b8bI0ZvvUKjps=
X-Google-Smtp-Source: ABdhPJyh67EExgFHy7v3gQDCtpSciDMQOcV5rIe3/RzF7i5efyrcTPlNOZ5Mb8YhiDN1XyLAnvP7KrY+FuXfZuTud18=
X-Received: by 2002:a25:538a:: with SMTP id h132mr19654496ybb.247.1611228358033;
 Thu, 21 Jan 2021 03:25:58 -0800 (PST)
MIME-Version: 1.0
References: <20210121092026.3261412-1-mudongliangabcd@gmail.com>
 <YAlORNKQ4y7bzYeZ@kroah.com> <CAD-N9QXhD48-6GbpCUYuxPKEbkzGgGTaFKQ8TAaQ93WfD_sT2A@mail.gmail.com>
 <YAljtMMV4oh5uAHC@kroah.com>
In-Reply-To: <YAljtMMV4oh5uAHC@kroah.com>
From:   =?UTF-8?B?5oWV5Yas5Lqu?= <mudongliangabcd@gmail.com>
Date:   Thu, 21 Jan 2021 19:25:31 +0800
Message-ID: <CAD-N9QWao8+VFLbE00Dmo0Kpwf2ATzaP=F=QWk=5R8Td_JWsew@mail.gmail.com>
Subject: Re: [PATCH] rt2x00: reset reg earlier in rt2500usb_register_read
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     davem@davemloft.net, helmut.schaa@googlemail.com,
        kvalo@codeaurora.org, linux-kernel <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        sgruszka@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 21, 2021 at 7:21 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Thu, Jan 21, 2021 at 06:59:08PM +0800, =E6=85=95=E5=86=AC=E4=BA=AE wro=
te:
> > > >       rt2x00usb_vendor_request_buff(rt2x00dev, USB_MULTI_READ,
> > > >                                     USB_VENDOR_REQUEST_IN, offset,
> > > >                                     &reg, sizeof(reg));
> > >
> > > Are you sure this is valid to call this function with a variable on t=
he
> > > stack like this?  How did you test this change?
> >
> > First, I did not do any changes to this call. Second, the programming
> > style to pass the pointer of stack variable as arguments is not really
> > good. Third, I check this same code file, there are many code snippets
> > with such programming style. :(
>
> I know you did not change it, what I am asking is how did you test this
> change works?  I think the kernel will warn you in huge ways that using
> this pointer on the stack is incorrect, which implies you did not test
> this change :(
>

I tested this patch only with PoC. The patched kernel version did not
crash when executing the PoC.

BTW, I did not take notice of the warning information as there are
many many warnings in building KMSAN.

> thanks,
>
> greg k-h
