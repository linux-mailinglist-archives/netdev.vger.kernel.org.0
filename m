Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9D9417D29C
	for <lists+netdev@lfdr.de>; Sun,  8 Mar 2020 09:27:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726169AbgCHI1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Mar 2020 04:27:13 -0400
Received: from mail-il1-f196.google.com ([209.85.166.196]:38329 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbgCHI1N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Mar 2020 04:27:13 -0400
Received: by mail-il1-f196.google.com with SMTP id f5so5947278ilq.5;
        Sun, 08 Mar 2020 00:27:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+Zc4eg+i4Rn0BmSiaMPh/B06AVe20VTWrfl7CK2y5A8=;
        b=SpN/KlXRW5crN4+r1Wg3L5olTJbIjnHQLCcHU2IxCNFv1rWpDlcZjtVvmFBSQ5+U8c
         3ts9vikCy9bXi6vP+Bue/G3iTgX5+ftOE+BXxZ7iVxco8MPIOFifegIRUT0Ym+aFCvqj
         S7BaaFdxPtolag+rhciw4tF/mcH2VEF2EDaZVSKnNBtTJW3mIoXmqx/xP05xUEv4R7wD
         zryN5oeuf1Wkiu0BGVzNEXzncT5EqeFOZ9uxgY3OHeHSf6OFQxnzZ1ApUOoh6m7yJp6a
         NMav87SpkRCnzf/AlwqgO+S/yT7HlTBda9c8UzmwO3j0hNthtTgrbnlTs48FcgldpSYC
         PDzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+Zc4eg+i4Rn0BmSiaMPh/B06AVe20VTWrfl7CK2y5A8=;
        b=JyfIOjgcMlcJy4xkwtm3y+jX3CDPQzWFMbDC+ML8zEJQ3Zp8xegepINRSc7dTnEXjW
         fnWHWxfDwRgRy6QZNvNczNB90c1QmWHnuWKKs/gZSs7t761KT3dSfrpEAzrEvbIBYQnu
         FOlYjSM0sZLAQEU4pJWFzGR1oMc1rv3e+SuW8XPxGnN5kwsMfziMxpxMmHTJYO5jrTiW
         kbCo7snUJW7TTkYr+V3qwzkTpigOt2oQG8l3fzlxwzHcYrbMshvbu8HfsPbi4WSXzv+E
         zAeZOgj71hWXOIGVALOMa3AY/8WhZVn7S6M6gPHFQHS+rYagjN5Gg5RrcbntGwatH/t0
         +8IQ==
X-Gm-Message-State: ANhLgQ26h6aNRZOI/T1aXFt5gjpmYQ2+2u4+ZGISl2IUZigZ6GynHBHt
        HXYsR/e8S23yVdPEpytRv4/bylBCYRI5MnnCE98=
X-Google-Smtp-Source: ADFU+vt1IX4BRfB0ZrU7Xx+1rtz4c3k2dXFb/0osd5D2Rgo8GJhv7h+9LW6knuA7wkYPA189lIk4UwhQH6SMzESZ18w=
X-Received: by 2002:a05:6e02:ea8:: with SMTP id u8mr11277713ilj.0.1583656032881;
 Sun, 08 Mar 2020 00:27:12 -0800 (PST)
MIME-Version: 1.0
References: <1583589488-22450-1-git-send-email-hqjagain@gmail.com> <449B4F83-8BCD-413C-823B-C7A5554801FB@holtmann.org>
In-Reply-To: <449B4F83-8BCD-413C-823B-C7A5554801FB@holtmann.org>
From:   Qiujun Huang <hqjagain@gmail.com>
Date:   Sun, 8 Mar 2020 16:27:02 +0800
Message-ID: <CAJRQjodmk0BDa=i4JeB0MSW6NJ5tVyx5TRLReORxFbQueY4WQw@mail.gmail.com>
Subject: Re: [PATCH] bluetooth/rfcomm: fix ODEBUG bug in rfcomm_dev_ioctl
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bluez mailing list <linux-bluetooth@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 8, 2020 at 4:18 PM Marcel Holtmann <marcel@holtmann.org> wrote:
>
> Hi Qiujun,
>
> > Needn't call 'rfcomm_dlc_put' here, because 'rfcomm_dlc_exists' didn't
> > increase dlc->refcnt.
> >
> > Reported-by: syzbot+4496e82090657320efc6@syzkaller.appspotmail.com
> > Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
> > ---
> > net/bluetooth/rfcomm/tty.c | 1 -
> > 1 file changed, 1 deletion(-)
> >
> > diff --git a/net/bluetooth/rfcomm/tty.c b/net/bluetooth/rfcomm/tty.c
> > index 0c7d31c..ea2a1df0 100644
> > --- a/net/bluetooth/rfcomm/tty.c
> > +++ b/net/bluetooth/rfcomm/tty.c
> > @@ -414,7 +414,6 @@ static int __rfcomm_create_dev(struct sock *sk, void __user *arg)
> >               if (IS_ERR(dlc))
> >                       return PTR_ERR(dlc);
> >               else if (dlc) {
> > -                     rfcomm_dlc_put(dlc);
> >                       return -EBUSY;
> >               }
> >               dlc = rfcomm_dlc_alloc(GFP_KERNEL);
>
> Please see the proposed change from Hillf.
>
> It is better to not bother with the else if here since the if statement will already leave the function.

I get that. Thanks.

>
>         if (dlc)
>                 return -EBUSY;
>
> Regards
>
> Marcel
>
