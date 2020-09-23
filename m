Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF68275962
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 16:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbgIWOGY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 10:06:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgIWOGX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 10:06:23 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A61F8C0613CE;
        Wed, 23 Sep 2020 07:06:23 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id g4so167331wrs.5;
        Wed, 23 Sep 2020 07:06:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TwbdsbNQ01qQwqOKbFf8TNuPGrR4dQ5NlUzkmbce0+o=;
        b=OoYYRY91DkAWgnnrlsYtddRWauvcC6OJ5YzJtW14Fojl7S4eZu1wwPYvSc1xRvOEMv
         NjV30C9vrMMoW8M8VbZL6SYmtTfdm6l8PF3MV1MPl/O5bP1cPPtTNLMzN07U4AaGgrQD
         1iQ6DgdL6L/1+296uCalBUseH+C2U6RrgSxZFNZ9m16wZ0G62sAK9zfLarzt+aPJfm9o
         6Vl5sVJOYSPYUWhIPgbLUqapDKdAiyL+8hp8lm85XhycIHqGinZ032dKeMCkKiT0EZwI
         UVKtL2IHxKhQbmx5Zw28U1jBOiJPv0NdtE1x2+1cNl972ttnYEXMS48Tg8J+P/LVblZw
         xNdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TwbdsbNQ01qQwqOKbFf8TNuPGrR4dQ5NlUzkmbce0+o=;
        b=YqoH5Go27ARbRqHwbYtxelVz0f7G1ZF5qC4ufjEoM+iWVL9yAG2AJ+Y8i2g4XbWDnP
         zqlpY4ijfLJixGNLKsMMUWB6GsYv7SF1gMm25w3m3lRuZYtdvTBS0La2s7BTk47D+BWZ
         sWbVtV0Lw1V+3YdIY+6WIiZF2HwJ4rSzT5Q69aa4NGzpGoaCmT+yM+j07es7FH2GL01U
         Dbe8Cd4tdO9Zo7mvg36qYQXxhyCiErnnAlic4EouoHNkA1XE+rg/G0ZhduVtO5menAaP
         h3am2jCk7zespTNHiVCmMwVWFvdlSuNA56yemhXKttxXhQne7B++qLa77Ir5grDSGNZH
         qICQ==
X-Gm-Message-State: AOAM533qB4CxOVBViod7lvPpsJ072BJs60UWFoJhiwir1rIfZqLFWgpD
        FcEilTEO+Hln+S3Bf0cqnXF4QY7zkxVDiiPP8Deq7MBIdw/fmw==
X-Google-Smtp-Source: ABdhPJyRnzCExgkJl9cfP16TzWgw3924AwBQWxefA0lv/y8yZPq6g1F4ltEIa2eo/BbQ02YGvNKwscalgdDEGS6Awlk=
X-Received: by 2002:adf:9b8b:: with SMTP id d11mr1131300wrc.71.1600869982290;
 Wed, 23 Sep 2020 07:06:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200923090519.361-1-himadrispandya@gmail.com>
 <20200923090519.361-4-himadrispandya@gmail.com> <1600856557.26851.6.camel@suse.com>
In-Reply-To: <1600856557.26851.6.camel@suse.com>
From:   Himadri Pandya <himadrispandya@gmail.com>
Date:   Wed, 23 Sep 2020 19:36:10 +0530
Message-ID: <CAOY-YVkHycXqem_Xr6nQLgKEunk3MNc7dBtZ=5Aym4Y06vs9xQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] net: usb: rtl8150: use usb_control_msg_recv() and usb_control_msg_send()
To:     Oliver Neukum <oneukum@suse.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        pankaj.laxminarayan.bharadiya@intel.com,
        Kees Cook <keescook@chromium.org>, yuehaibing@huawei.com,
        petkan@nucleusys.com, ogiannou@gmail.com,
        USB list <linux-usb@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 23, 2020 at 3:52 PM Oliver Neukum <oneukum@suse.com> wrote:
>
> Am Mittwoch, den 23.09.2020, 14:35 +0530 schrieb Himadri Pandya:
>
> Hi,
>
> > Many usage of usb_control_msg() do not have proper error check on return
> > value leaving scope for bugs on short reads. New usb_control_msg_recv()
> > and usb_control_msg_send() nicely wraps usb_control_msg() with proper
> > error check. Hence use the wrappers instead of calling usb_control_msg()
> > directly.
> >
> > Signed-off-by: Himadri Pandya <himadrispandya@gmail.com>
> Nacked-by: Oliver Neukum <oneukum@suse.com>
>
> > ---
> >  drivers/net/usb/rtl8150.c | 32 ++++++--------------------------
> >  1 file changed, 6 insertions(+), 26 deletions(-)
> >
> > diff --git a/drivers/net/usb/rtl8150.c b/drivers/net/usb/rtl8150.c
> > index 733f120c852b..e3002b675921 100644
> > --- a/drivers/net/usb/rtl8150.c
> > +++ b/drivers/net/usb/rtl8150.c
> > @@ -152,36 +152,16 @@ static const char driver_name [] = "rtl8150";
> >  */
> >  static int get_registers(rtl8150_t * dev, u16 indx, u16 size, void *data)
> >  {
> > -     void *buf;
> > -     int ret;
> > -
> > -     buf = kmalloc(size, GFP_NOIO);
>
> GFP_NOIO is used here for a reason. You need to use this helper
> while in contexts of error recovery and runtime PM.
>

Understood. Apologies for proposing such a stupid change.

> > -     if (!buf)
> > -             return -ENOMEM;
> > -
> > -     ret = usb_control_msg(dev->udev, usb_rcvctrlpipe(dev->udev, 0),
> > -                           RTL8150_REQ_GET_REGS, RTL8150_REQT_READ,
> > -                           indx, 0, buf, size, 500);
> > -     if (ret > 0 && ret <= size)
> > -             memcpy(data, buf, ret);
> > -     kfree(buf);
> > -     return ret;
> > +     return usb_control_msg_recv(dev->udev, 0, RTL8150_REQ_GET_REGS,
> > +                                 RTL8150_REQT_READ, indx, 0, data,
> > +                                 size, 500);
>
> This internally uses kmemdup() with GFP_KERNEL.
> You cannot make this change. The API does not support it.
> I am afraid we will have to change the API first, before more
> such changes are done.
>
> I would suggest dropping the whole series for now.

Okay. Thanks for the review.

Regards,
Himadri

>
>         Regards
>                 Oliver
>
