Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61E644959A3
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 06:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378585AbiAUF73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 00:59:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbiAUF73 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 00:59:29 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DABF0C061574;
        Thu, 20 Jan 2022 21:59:28 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id m4so38341139edb.10;
        Thu, 20 Jan 2022 21:59:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+wQr2d5eRpHGPSk+GQ5BJP2QmCnLf6GyW5hqo/3Oh/c=;
        b=E5jHcZ9X8iERSBwBX7mycrhSqXUPDJlCqp5XQFVvE+CfkqUUfF8bN1XMeD1nWvQwiz
         TQMaZrbbDnRvk+2pbJ5N217mXiFN9VIeqyyzNHkaNyGyldjsvtqXuJMQ8zE5QXoy9WuZ
         oqm6Upasna3Z9fTWQypO70yUAqq+TNNGZQA91iPE8NkavMs94Hz10Z3OkVeu5YY2aMqb
         FLTpDuLJkmN7LMqKObsj/cRjQ9ZAHIKwI64EwNY9w5g6rDzg1/3lxxmKbqJ0pFmiN62u
         3IX5MzZBkkRnrps+P+ftqFQwhqkuN4crQaCjtH8K7VVlGN4w0hr89GY8ooB31OoHm6PJ
         +K7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+wQr2d5eRpHGPSk+GQ5BJP2QmCnLf6GyW5hqo/3Oh/c=;
        b=rPK9xct+/TpQHlW97BaaQGLhjwCjIuyOENrGzGgsT7wJMsU7dpKHfHnG5g6o/1zAVp
         MhecVngjltZakYVh6RSJ8VCvX+B4s4/jzG4jBXToGsHSTc77jgxKijlEv5wgJiaV8KZu
         LHo1fqmujjfxvdYWRig4WQLvyuwDLhnGKtNbMRiSM4H5gKmHA9/WGoQpHSOAxsWCJe5b
         +it0iKU6FW6zl4Ebbb4gFmGNY9zi8AIeS6A70Yl/vwoiPScHBG29fr6HmmEpwFG8ydUQ
         S1MoGXs7Z9UHLOl+EIM9FGyLDOs+88jFV1GIf8VbwrWXdkAgHOCR6YoEHS7aPP9XO4gl
         I7QQ==
X-Gm-Message-State: AOAM531C2GRGvFtXTjfa72AwIukZCugSWQIb2VgL2OD13LhUlnhGWLdL
        yY1NkVG0x2ryJKg+WirM/Qji1aEYX7Cu5UqUSo80N4iUWbHTsw==
X-Google-Smtp-Source: ABdhPJzxE+z+JVqF0ZR5h7iW2PVzsy0qMYo06iPY2SB3w9/6r/fQqkAF/e1Lek1C57boSMDvRAo2HILeDCPTO76XZSY=
X-Received: by 2002:a17:906:2b8a:: with SMTP id m10mr2119678ejg.479.1642744767084;
 Thu, 20 Jan 2022 21:59:27 -0800 (PST)
MIME-Version: 1.0
References: <20220120130605.55741-1-dzm91@hust.edu.cn> <b5cb1132-2f6b-e2da-78c7-1828b3617bc3@gmail.com>
 <CAD-N9QWvfoo_HtQ+KT-7JNFumQMaq8YqMkHGR2t7pDKsDW0hkQ@mail.gmail.com> <CAD-N9QUfiTNqs7uOH3C99oMNdqFXh+MKLQ94BkQou_T7-yU_mg@mail.gmail.com>
In-Reply-To: <CAD-N9QUfiTNqs7uOH3C99oMNdqFXh+MKLQ94BkQou_T7-yU_mg@mail.gmail.com>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Fri, 21 Jan 2022 13:58:58 +0800
Message-ID: <CAD-N9QUZ95zqboe=58gybue6ssSO-M-raijd3XnGXkXnp3wiqQ@mail.gmail.com>
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

On Fri, Jan 21, 2022 at 11:36 AM Dongliang Mu <mudongliangabcd@gmail.com> wrote:
>
> On Fri, Jan 21, 2022 at 8:09 AM Dongliang Mu <mudongliangabcd@gmail.com> wrote:
> >
> > On Thu, Jan 20, 2022 at 10:27 PM Pavel Skripkin <paskripkin@gmail.com> wrote:
> > >
> > > Hi Dongliang,
> > >
> > > On 1/20/22 16:05, Dongliang Mu wrote:
> > > > From: Dongliang Mu <mudongliangabcd@gmail.com>
> > > >
> > > > The error handling code of peak_usb_create_dev forgets to reset the
> > > > next_siblings of previous entry.
> > > >
> > > > Fix this by nullifying the (dev->prev_siblings)->next_siblings in the
> > > > error handling code.
> > > >
> > > > Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
> > > > ---
> > > >   drivers/net/can/usb/peak_usb/pcan_usb_core.c | 3 +++
> > > >   1 file changed, 3 insertions(+)
> > > >
> > > > diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_core.c b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
> > > > index b850ff8fe4bd..f858810221b6 100644
> > > > --- a/drivers/net/can/usb/peak_usb/pcan_usb_core.c
> > > > +++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
> > > > @@ -894,6 +894,9 @@ static int peak_usb_create_dev(const struct peak_usb_adapter *peak_usb_adapter,
> > > >               dev->adapter->dev_free(dev);
> > > >
> > > >   lbl_unregister_candev:
> > > > +     /* remove the dangling pointer in next_siblings */
> > > > +     if (dev->prev_siblings)
> > > > +             (dev->prev_siblings)->next_siblings = NULL;
> > > >       unregister_candev(netdev);
> > > >
> > > >   lbl_restore_intf_data:
> > >
> > >
> > > Is this pointer used somewhere? I see, that couple of
> > > struct peak_usb_adapter::dev_free() functions use it, but
> > > peak_usb_disconnect() sets dev->next_siblings to NULL before calling
> > > ->dev_free().
> > >
> > > Do you have a calltrace or oops log?
> >
> > Hi Pavel,
> >
> > I have no calltrace or log since this dangling pointer may not be
> > dereferenced in the following code. But I am not sure. So the commit
> > title of this patch is "remove a dangling pointer in
> > peak_usb_create_dev".
>
> BTW, as you mentioned, dev->next_siblings is used in struct
> peak_usb_adapter::dev_free() (i.e., pcan_usb_fd_free or
> pcan_usb_pro_free), how about the following path?
>
> peak_usb_probe
> -> peak_usb_create_dev (goto adap_dev_free;)
>    -> dev->adapter->dev_free()
>       -> pcan_usb_fd_free or pcan_usb_pro_free (This function uses
> next_siblings as condition elements)
>
> static void pcan_usb_fd_free(struct peak_usb_device *dev)
> {
>         /* last device: can free shared objects now */
>         if (!dev->prev_siblings && !dev->next_siblings) {
>                 struct pcan_usb_fd_device *pdev =
>                         container_of(dev, struct pcan_usb_fd_device, dev);
>
>                 /* free commands buffer */
>                 kfree(pdev->cmd_buffer_addr);
>
>                 /* free usb interface object */
>                 kfree(pdev->usb_if);
>         }
> }
>
> If next_siblings is not NULL, will it lead to the missing free of
> cmd_buffer_addr and usb_if?

The answer is No. Forget my silly thought.

>
> Please let me know if I made any mistakes.
>
> > >
> > >
> > >
> > >
> > > With regards,
> > > Pavel Skripkin
