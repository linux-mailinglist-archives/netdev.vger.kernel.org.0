Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0048827599D
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 16:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbgIWOOO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 10:14:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgIWOON (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 10:14:13 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B38BC0613CE;
        Wed, 23 Sep 2020 07:14:13 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id y15so234934wmi.0;
        Wed, 23 Sep 2020 07:14:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OwjrYT2cgYiXPXM5damUhK95qHZgYya6zZ6mXD0zFBE=;
        b=obHtpepxuTTVBXFISitT+Nk85ES0huZDcdAzFAhmfmHMPjV4m156WAwF0U69K9wIGy
         z7hfLvHdGReIh3bXPoJr2bWj2gowLyCvtCzn6jtQRFn2DzWLG3lF1uj1QupWHiy3N0ho
         bxTXmzFhulvDsG2A3P20KAJxWDZpWxq/Xc4OkWsmJZVzVfNkgQ8rCP4OG41c+4pS058T
         e1LIcYESpjcGsgW2MUCfgnisE2uidlu2+vJJeefwdJaUC3Zqo73pkITqT6ddgZXyhC20
         OlfOzf7EGcycT2aX9p2h7hd6ENemBVb798fmdWFcsaqSxCDhUj4BtdY+13p4PGQVt1+9
         DSgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OwjrYT2cgYiXPXM5damUhK95qHZgYya6zZ6mXD0zFBE=;
        b=fbxqP2Z8MLK1LtqwBHwnqU0GGPWWX888WjKa6lmgAnYEzKpx4lGMPdK59nCQGOxLgg
         Vjb3oE6mO7cLDEA6iV/Ba6QWbrTPNxibgASfkFPkCUvxjeSjRK6I6yCtuVY4dx5LYXEZ
         1n3gDMwMehDNDZpEmNfdLSIXowmKh2sNlx9fNGrPu4LDxl7zOK7JGDsaEsfosD/CvTU5
         RusJLpLtJ+nkIrwm76AGG2h9yX5wpmSKVu5AaGMJY9ozoVipWSpyOAn7v1QegFsQwY5v
         2khOS/u//S2exArbC0U7EP2lyT5hAH+RJBxMpBGeePTz0dn3xRtehEy+Ka5c5ud7+sLm
         lPLA==
X-Gm-Message-State: AOAM532Pvn7nChBNkya78dS0RfrnqBNwLIMAEViERXGO7VlCRwRLefmI
        lJPefH0xaOO4rEk1QoHAYTmKEQz09hmSUpjHMmI=
X-Google-Smtp-Source: ABdhPJwdy6UD/UzHfr2IcuCNMK2z1a9fd/uvMgG9JscXgN32cCh6DM8001ZMYmM7ElTCq0gduZVIX3YihxNI3VPmGts=
X-Received: by 2002:a1c:6341:: with SMTP id x62mr6771683wmb.70.1600870452134;
 Wed, 23 Sep 2020 07:14:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200923090519.361-1-himadrispandya@gmail.com>
 <20200923090519.361-5-himadrispandya@gmail.com> <20200923102256.GA3154647@kroah.com>
In-Reply-To: <20200923102256.GA3154647@kroah.com>
From:   Himadri Pandya <himadrispandya@gmail.com>
Date:   Wed, 23 Sep 2020 19:44:00 +0530
Message-ID: <CAOY-YVnFtDMkRVVg4TZ-3rRxciRYwEQCf-ctbm9=KbF4=1FqMA@mail.gmail.com>
Subject: Re: [PATCH 4/4] net: rndis_host: use usb_control_msg_recv() and usb_control_msg_send()
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

On Wed, Sep 23, 2020 at 3:52 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Wed, Sep 23, 2020 at 02:35:19PM +0530, Himadri Pandya wrote:
> > The new usb_control_msg_recv() and usb_control_msg_send() nicely wraps
> > usb_control_msg() with proper error check. Hence use the wrappers
> > instead of calling usb_control_msg() directly.
> >
> > Signed-off-by: Himadri Pandya <himadrispandya@gmail.com>
> > ---
> >  drivers/net/usb/rndis_host.c | 44 ++++++++++++++----------------------
> >  1 file changed, 17 insertions(+), 27 deletions(-)
> >
> > diff --git a/drivers/net/usb/rndis_host.c b/drivers/net/usb/rndis_host.c
> > index 6fa7a009a24a..30fc4a7183d3 100644
> > --- a/drivers/net/usb/rndis_host.c
> > +++ b/drivers/net/usb/rndis_host.c
> > @@ -113,14 +113,13 @@ int rndis_command(struct usbnet *dev, struct rndis_msg_hdr *buf, int buflen)
> >               buf->request_id = (__force __le32) xid;
> >       }
> >       master_ifnum = info->control->cur_altsetting->desc.bInterfaceNumber;
> > -     retval = usb_control_msg(dev->udev,
> > -             usb_sndctrlpipe(dev->udev, 0),
> > -             USB_CDC_SEND_ENCAPSULATED_COMMAND,
> > -             USB_TYPE_CLASS | USB_RECIP_INTERFACE,
> > -             0, master_ifnum,
> > -             buf, le32_to_cpu(buf->msg_len),
> > -             RNDIS_CONTROL_TIMEOUT_MS);
> > -     if (unlikely(retval < 0 || xid == 0))
> > +     retval = usb_control_msg_send(dev->udev, 0,
> > +                                   USB_CDC_SEND_ENCAPSULATED_COMMAND,
> > +                                   USB_TYPE_CLASS | USB_RECIP_INTERFACE,
> > +                                   0, master_ifnum, buf,
> > +                                   le32_to_cpu(buf->msg_len),
> > +                                   RNDIS_CONTROL_TIMEOUT_MS);
> > +     if (unlikely(xid == 0))
> >               return retval;
> >
> >       /* Some devices don't respond on the control channel until
> > @@ -139,14 +138,11 @@ int rndis_command(struct usbnet *dev, struct rndis_msg_hdr *buf, int buflen)
> >       /* Poll the control channel; the request probably completed immediately */
> >       rsp = le32_to_cpu(buf->msg_type) | RNDIS_MSG_COMPLETION;
> >       for (count = 0; count < 10; count++) {
> > -             memset(buf, 0, CONTROL_BUFFER_SIZE);
> > -             retval = usb_control_msg(dev->udev,
> > -                     usb_rcvctrlpipe(dev->udev, 0),
> > -                     USB_CDC_GET_ENCAPSULATED_RESPONSE,
> > -                     USB_DIR_IN | USB_TYPE_CLASS | USB_RECIP_INTERFACE,
> > -                     0, master_ifnum,
> > -                     buf, buflen,
> > -                     RNDIS_CONTROL_TIMEOUT_MS);
> > +             retval = usb_control_msg_recv(dev->udev, 0,
> > +                                           USB_CDC_GET_ENCAPSULATED_RESPONSE,
> > +                                           USB_DIR_IN | USB_TYPE_CLASS | USB_RECIP_INTERFACE,
> > +                                           0, master_ifnum, buf, buflen,
> > +                                           RNDIS_CONTROL_TIMEOUT_MS);
> >               if (likely(retval >= 8)) {
>
> retval here is never going to be positive, right?  So I don't think this
> patch is correct :(
>

Yes :(.

> >                       msg_type = le32_to_cpu(buf->msg_type);
> >                       msg_len = le32_to_cpu(buf->msg_len);
> > @@ -178,17 +174,11 @@ int rndis_command(struct usbnet *dev, struct rndis_msg_hdr *buf, int buflen)
> >                               msg->msg_type = cpu_to_le32(RNDIS_MSG_KEEPALIVE_C);
> >                               msg->msg_len = cpu_to_le32(sizeof *msg);
> >                               msg->status = cpu_to_le32(RNDIS_STATUS_SUCCESS);
> > -                             retval = usb_control_msg(dev->udev,
> > -                                     usb_sndctrlpipe(dev->udev, 0),
> > -                                     USB_CDC_SEND_ENCAPSULATED_COMMAND,
> > -                                     USB_TYPE_CLASS | USB_RECIP_INTERFACE,
> > -                                     0, master_ifnum,
> > -                                     msg, sizeof *msg,
> > -                                     RNDIS_CONTROL_TIMEOUT_MS);
> > -                             if (unlikely(retval < 0))
> > -                                     dev_dbg(&info->control->dev,
> > -                                             "rndis keepalive err %d\n",
> > -                                             retval);
> > +                             retval = usb_control_msg_send(dev->udev, 0,
> > +                                                           USB_CDC_SEND_ENCAPSULATED_COMMAND,
> > +                                                           USB_TYPE_CLASS | USB_RECIP_INTERFACE,
> > +                                                           0, master_ifnum, msg, sizeof(*msg),
> > +                                                           RNDIS_CONTROL_TIMEOUT_MS);
>
> You lost the error message that the previous call had if something went
> wrong.  Don't know if it's really needed, but there's no reason to
> remove it here.
>

The wrapper returns the error so thought that might work instead. But
yes, the old msg is better.

Anyways, this series is dropped :).

Thanks for the review,
Himadri

> thanks,
>
> greg k-h
