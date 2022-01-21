Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95B3B495890
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 04:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233372AbiAUDhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 22:37:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233319AbiAUDhU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 22:37:20 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F761C061574;
        Thu, 20 Jan 2022 19:37:20 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id m4so37224331edb.10;
        Thu, 20 Jan 2022 19:37:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BHIQ0MW6h8rjtE5Oq3hSn4Eblt6AqDGPbgHQG8CkaDA=;
        b=iB9tW1I440c8OG4kQaKQuf2iWv4Fj9BrT7H+enBXSn6kKaGKkutwCx5LWUTp8ynPNC
         rTUfhvY9Kf4uh5TKXfzb4+YkZP5/PN0CtLnLRhT2PXY+A5cpkxA7z55Eu2bxEIrjPIPM
         UFLMBrsvRRy98ZcIuKAAVNk2qC59FtOAH6KW1EvOvTC2QsF2GPtLEasZ+741JJOX8/na
         h/a/e0SKBovLrEMtPcWSU6nfxkOyKPO0U1AWYqmhNr03oiSmuD9m/24KF389O6m9Hmdt
         erjUeRZKmTmsCwU1w6dKNWyVnHZHxZIZw4yvKy76IAqC1BzMi60X1sVqtg1ydMF8/udh
         Ay8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BHIQ0MW6h8rjtE5Oq3hSn4Eblt6AqDGPbgHQG8CkaDA=;
        b=3xmfoiskcTtqZHPZKy6GNybqlKeKNrWV3l6M239Px70CQFK7dsbWZUmzyN9Cr4R23Y
         Tw3rwRW6y3iwGSb5qq/kZK9jJtTcYqyuPzfiaNjlaThsVcxFzGQpv/lIoqztDqOkvgPI
         NgIu6hky5jhsv76mKUHvW+NJRnPuwpa/UN47W0HM3bKTnSpoCT3PArOKO2UNazoa9h9h
         cv8WXXNttHS0Q2ShvB6oRVCvhhfzdDj7vWMpoSQMw77EWOoVjnTwuSTNi+pQV9aqU+2x
         WvlviT9mqDb9jBsbGykCC51IJ0m3pMpy421afoGiDXTukfL4Zf60Ud0dD+rLmheivGhn
         4+9w==
X-Gm-Message-State: AOAM533hB3U1hmN2vSikOdWIVsHpOQhMhHXoBdzVY21dbxHgMsdk62hK
        X/wHNm5HkXIZVnlZsvIpVXyqmvHnShynBG2qcWc=
X-Google-Smtp-Source: ABdhPJxE6kdVV19XTr81YBYieso0BRxSR2fu3rz/08k9+FJ+iiOMrC54l9/BhOYu6V04Zy90eN2pDvY8YHpIn9gBahc=
X-Received: by 2002:a17:906:2f08:: with SMTP id v8mr1706188eji.708.1642736238541;
 Thu, 20 Jan 2022 19:37:18 -0800 (PST)
MIME-Version: 1.0
References: <20220120130605.55741-1-dzm91@hust.edu.cn> <b5cb1132-2f6b-e2da-78c7-1828b3617bc3@gmail.com>
 <CAD-N9QWvfoo_HtQ+KT-7JNFumQMaq8YqMkHGR2t7pDKsDW0hkQ@mail.gmail.com>
In-Reply-To: <CAD-N9QWvfoo_HtQ+KT-7JNFumQMaq8YqMkHGR2t7pDKsDW0hkQ@mail.gmail.com>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Fri, 21 Jan 2022 11:36:52 +0800
Message-ID: <CAD-N9QUfiTNqs7uOH3C99oMNdqFXh+MKLQ94BkQou_T7-yU_mg@mail.gmail.com>
Subject: Re: [PATCH] drivers: net: remove a dangling pointer in peak_usb_create_dev
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     Dongliang Mu <dzm91@hust.edu.cn>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        =?UTF-8?Q?Stefan_M=C3=A4tje?= <stefan.maetje@esd.eu>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 21, 2022 at 8:09 AM Dongliang Mu <mudongliangabcd@gmail.com> wrote:
>
> On Thu, Jan 20, 2022 at 10:27 PM Pavel Skripkin <paskripkin@gmail.com> wrote:
> >
> > Hi Dongliang,
> >
> > On 1/20/22 16:05, Dongliang Mu wrote:
> > > From: Dongliang Mu <mudongliangabcd@gmail.com>
> > >
> > > The error handling code of peak_usb_create_dev forgets to reset the
> > > next_siblings of previous entry.
> > >
> > > Fix this by nullifying the (dev->prev_siblings)->next_siblings in the
> > > error handling code.
> > >
> > > Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
> > > ---
> > >   drivers/net/can/usb/peak_usb/pcan_usb_core.c | 3 +++
> > >   1 file changed, 3 insertions(+)
> > >
> > > diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_core.c b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
> > > index b850ff8fe4bd..f858810221b6 100644
> > > --- a/drivers/net/can/usb/peak_usb/pcan_usb_core.c
> > > +++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
> > > @@ -894,6 +894,9 @@ static int peak_usb_create_dev(const struct peak_usb_adapter *peak_usb_adapter,
> > >               dev->adapter->dev_free(dev);
> > >
> > >   lbl_unregister_candev:
> > > +     /* remove the dangling pointer in next_siblings */
> > > +     if (dev->prev_siblings)
> > > +             (dev->prev_siblings)->next_siblings = NULL;
> > >       unregister_candev(netdev);
> > >
> > >   lbl_restore_intf_data:
> >
> >
> > Is this pointer used somewhere? I see, that couple of
> > struct peak_usb_adapter::dev_free() functions use it, but
> > peak_usb_disconnect() sets dev->next_siblings to NULL before calling
> > ->dev_free().
> >
> > Do you have a calltrace or oops log?
>
> Hi Pavel,
>
> I have no calltrace or log since this dangling pointer may not be
> dereferenced in the following code. But I am not sure. So the commit
> title of this patch is "remove a dangling pointer in
> peak_usb_create_dev".

BTW, as you mentioned, dev->next_siblings is used in struct
peak_usb_adapter::dev_free() (i.e., pcan_usb_fd_free or
pcan_usb_pro_free), how about the following path?

peak_usb_probe
-> peak_usb_create_dev (goto adap_dev_free;)
   -> dev->adapter->dev_free()
      -> pcan_usb_fd_free or pcan_usb_pro_free (This function uses
next_siblings as condition elements)

static void pcan_usb_fd_free(struct peak_usb_device *dev)
{
        /* last device: can free shared objects now */
        if (!dev->prev_siblings && !dev->next_siblings) {
                struct pcan_usb_fd_device *pdev =
                        container_of(dev, struct pcan_usb_fd_device, dev);

                /* free commands buffer */
                kfree(pdev->cmd_buffer_addr);

                /* free usb interface object */
                kfree(pdev->usb_if);
        }
}

If next_siblings is not NULL, will it lead to the missing free of
cmd_buffer_addr and usb_if?

Please let me know if I made any mistakes.

> >
> >
> >
> >
> > With regards,
> > Pavel Skripkin
