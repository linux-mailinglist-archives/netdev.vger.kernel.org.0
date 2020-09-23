Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65C4427596C
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 16:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbgIWOI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 10:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbgIWOI0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 10:08:26 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E9E2C0613CE;
        Wed, 23 Sep 2020 07:08:26 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id j2so161571wrx.7;
        Wed, 23 Sep 2020 07:08:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4uOSBvkeFCtt0jtghI6Iaa1Oo8+32MdaZFs6lvK60t8=;
        b=hIsdByJzmuRZb2kuHY+GIbDpMgWlvIUBRMTXmdV1C4IB9eRgcQy/OMVs2LdsuXRALc
         OPjiJGytcYJ+AqzYQ5+tx7xtLh+HPD1VxW1yvp/tZNOtCvSnydgapNZUVaFkMSapnkUV
         dn9rUUzdxM28cMyXFHXi4gXE32x+JjKe7gj8YX07quIKnNYjNcsA1Hj71H1/YIqtk+An
         vqMD9ip4rhlImUBqeu7EzMTx6OQe7a94hq6HBB21V+1x2Kk7PgLgb+t2XF8Njo6T8Qlv
         QgC7XqKrVAt5bRwL5i4A/pXjwpHdnhvjfMKRd9HDdfGzo52JbJhYPkcUFq8/+7FfOHMB
         7HJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4uOSBvkeFCtt0jtghI6Iaa1Oo8+32MdaZFs6lvK60t8=;
        b=OXNimDKPLSN5JT13A7joN6I+TTlH7+Cggq0KGMe0t4tjaXjnNq9jLjQNm1ecqwRJcF
         OE0ElszMFiSGwLJWUAi/AyxjMXXUMj9ukuj4EXXDDzTGEqjKLkP5ugO5AAhlltwj5XkX
         DIf4NGI1QCCwb7wsrrMNM1HnRespiS63ylRAAOVCQvTae1kDubvzvBM0aqLSq2RzsoGl
         rqRGkwbnxTVGtwsZD5CdBbqfhxua0FCWd1QY5gJS1vz9t4fs1clEADazd/4ikc90MElC
         J/Az2r1kgkJyPtR9/aGauRBh8uUxvQE/cfZnLO8UXWOhONPk3+dEi+HABbQX9KMJDCXU
         ztBw==
X-Gm-Message-State: AOAM531KsiDWC6xcRThBmHyK6WaYeyWZ/rDNy62sLdOG87rWnXOA+/1o
        RZbdVBH/Y+qDXsmJdSP/sd0wPc/S4KbkcouDE68=
X-Google-Smtp-Source: ABdhPJwfifO44HBhduMMKEMbLd2291rc6s++c2z9Q98+xivVO3BJPwzCQSMyA1phXsZQ4fDrwn6LpOEPvUyk8VM1Cs4=
X-Received: by 2002:adf:9b8b:: with SMTP id d11mr1141570wrc.71.1600870104795;
 Wed, 23 Sep 2020 07:08:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200923090519.361-1-himadrispandya@gmail.com>
 <20200923090519.361-2-himadrispandya@gmail.com> <20200923102425.GC3154647@kroah.com>
In-Reply-To: <20200923102425.GC3154647@kroah.com>
From:   Himadri Pandya <himadrispandya@gmail.com>
Date:   Wed, 23 Sep 2020 19:38:13 +0530
Message-ID: <CAOY-YVk3Vio=jKndTMnn66h-dZAnFUpZU701KqvdYh51ZQFk+g@mail.gmail.com>
Subject: Re: [PATCH 1/4] net: usbnet: use usb_control_msg_recv() and usb_control_msg_send()
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Neukum <oneukum@suse.com>,
        pankaj.laxminarayan.bharadiya@intel.com,
        Kees Cook <keescook@chromium.org>, yuehaibing@huawei.com,
        petkan@nucleusys.com, ogiannou@gmail.com,
        USB list <linux-usb@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 23, 2020 at 3:54 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Wed, Sep 23, 2020 at 02:35:16PM +0530, Himadri Pandya wrote:
> > Potential incorrect use of usb_control_msg() has resulted in new wrapper
> > functions to enforce its correct usage with proper error check. Hence
> > use these new wrapper functions instead of calling usb_control_msg()
> > directly.
> >
> > Signed-off-by: Himadri Pandya <himadrispandya@gmail.com>
> > ---
> >  drivers/net/usb/usbnet.c | 46 ++++------------------------------------
> >  1 file changed, 4 insertions(+), 42 deletions(-)
> >
> > diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
> > index 2b2a841cd938..a38a85bef46a 100644
> > --- a/drivers/net/usb/usbnet.c
> > +++ b/drivers/net/usb/usbnet.c
> > @@ -1982,64 +1982,26 @@ EXPORT_SYMBOL(usbnet_link_change);
> >  static int __usbnet_read_cmd(struct usbnet *dev, u8 cmd, u8 reqtype,
> >                            u16 value, u16 index, void *data, u16 size)
> >  {
> > -     void *buf = NULL;
> > -     int err = -ENOMEM;
> > -
> >       netdev_dbg(dev->net, "usbnet_read_cmd cmd=0x%02x reqtype=%02x"
> >                  " value=0x%04x index=0x%04x size=%d\n",
> >                  cmd, reqtype, value, index, size);
> >
> > -     if (size) {
> > -             buf = kmalloc(size, GFP_KERNEL);
> > -             if (!buf)
> > -                     goto out;
> > -     }
> > -
> > -     err = usb_control_msg(dev->udev, usb_rcvctrlpipe(dev->udev, 0),
> > -                           cmd, reqtype, value, index, buf, size,
> > +     return usb_control_msg_recv(dev->udev, 0,
> > +                           cmd, reqtype, value, index, data, size,
> >                             USB_CTRL_GET_TIMEOUT);
> > -     if (err > 0 && err <= size) {
> > -        if (data)
> > -            memcpy(data, buf, err);
> > -        else
> > -            netdev_dbg(dev->net,
> > -                "Huh? Data requested but thrown away.\n");
> > -    }
> > -     kfree(buf);
> > -out:
> > -     return err;
> >  }
>
> Now there is no real need for these wrapper functions at all, except for
> the debugging which I doubt anyone needs anymore.
>
> So how about just deleting these and calling the real function instead?
>

Yes, that would be a better thing to do.

Thanks,
Himadri

> thanks,
>
> greg k-h
