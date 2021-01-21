Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B63352FF510
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 20:49:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727449AbhAUTsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 14:48:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726094AbhAUSro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 13:47:44 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4D27C0613D6
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 10:46:35 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id 6so2772705wri.3
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 10:46:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=eLTRmgCPr+HYEN4cQ2gWxgBb6XXHtvoKZev3zSDlplo=;
        b=NaLSF6mnOsSALBNUwoEWqpOszUcKRSjhhfwqZ0GLuhUE3tE+owsFUGFQDGiVNk85FB
         cfWX+W2cwseXNzPuKQGS1lyUQ2SNqWjuFQO1G+mV8S0FdyxEpel7XZC7RJ1fwAX4vzO9
         YERQAINr3dSMYhdy7FatFADHHERaJVLMfydBTNp4ozPSKriY6ABhroeFhyoczJ0ke98b
         M0uLbIB8Wr39FDdgqvBixY+JkFYsqzzNxAmIAWs3d8k/6hX7ex+esQCzY6b77uUD75Db
         Koio5k8vQXUnGf8rafgxU3is0H9j5bK3+21cu/gGh7RfAqDk6yHhX40fkSAswC2aYanD
         cVRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=eLTRmgCPr+HYEN4cQ2gWxgBb6XXHtvoKZev3zSDlplo=;
        b=gZ62U+1dK6U1fvaQpVB7Ek9Bg+nlYjzmf+x2W1qSf1SGzlyHkU8DXHW/bKbOF2k7ht
         VxdYgYXxCGY2XSFB/F0S5PKxfo0bVxN1nAYnFGrOKGENpJOcdTHWcPJpqby+BYiJBWhi
         O8YGuLbZa4BWyvQh5zHC2xvUitf2p5+fm2oeViaLM3HsYAZk+wa1aQYoyfzz9XCq416Z
         KXh06pIgX1KoQWetrd6iP/ZSUakAIcPyqwgJJ2wqX6QdpUq9kdpfnUK3TNReHBFb58Fr
         bFLtiju8hwAiX+dtK7Kh6hCayxfvMjAThKEqjfO4Eiui3dOwZxT1QbnNiF72iFgZe/kd
         fh5A==
X-Gm-Message-State: AOAM530LSzugZUbyBHG8XK/eFPxEmI8Lh6S10gWOQEVxDRtnVaZyctI9
        ENNJZELPUg81xszGL+Yb7IiEDNaxfQ1eQO+6xsU=
X-Google-Smtp-Source: ABdhPJxFJI5jBFOrwJgGW7fDzLgZnW9nyzCxEwUsPE+DW1/63MX/JCCf8P+lfc0O2FAiheO9+xeTNBBy8Ziy0Mn0Wy0=
X-Received: by 2002:a5d:4ecb:: with SMTP id s11mr857330wrv.334.1611254794427;
 Thu, 21 Jan 2021 10:46:34 -0800 (PST)
MIME-Version: 1.0
References: <20210121062005.53271-1-ljp@linux.ibm.com> <c34816a13d857b7f5d1a25991b58ec63@imap.linux.ibm.com>
In-Reply-To: <c34816a13d857b7f5d1a25991b58ec63@imap.linux.ibm.com>
From:   Lijun Pan <lijunp213@gmail.com>
Date:   Thu, 21 Jan 2021 12:46:23 -0600
Message-ID: <CAOhMmr6LdZQpE7Ah1XVn0ApOO8Ch1XfAuoo1tPNgT0rG0zrc=A@mail.gmail.com>
Subject: Re: [PATCH net] ibmvnic: device remove has higher precedence over reset
To:     Dany Madden <drt@linux.ibm.com>
Cc:     Lijun Pan <ljp@linux.ibm.com>, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, sukadev@linux.ibm.com,
        mpe@ellerman.id.au, julietk@linux.vnet.ibm.com,
        benh@kernel.crashing.org, paulus@samba.org, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>, gregkh@linuxfoundation.org,
        kernel@pengutronix.de,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 21, 2021 at 12:42 PM Dany Madden <drt@linux.ibm.com> wrote:
>
> On 2021-01-20 22:20, Lijun Pan wrote:
> > Returning -EBUSY in ibmvnic_remove() does not actually hold the
> > removal procedure since driver core doesn't care for the return
> > value (see __device_release_driver() in drivers/base/dd.c
> > calling dev->bus->remove()) though vio_bus_remove
> > (in arch/powerpc/platforms/pseries/vio.c) records the
> > return value and passes it on. [1]
> >
> > During the device removal precedure, we should not schedule
> > any new reset (ibmvnic_reset check for REMOVING and exit),
> > and should rely on the flush_work and flush_delayed_work
> > to complete the pending resets, specifically we need to
> > let __ibmvnic_reset() keep running while in REMOVING state since
> > flush_work and flush_delayed_work shall call __ibmvnic_reset finally.
> > So we skip the checking for REMOVING in __ibmvnic_reset.
> >
> > [1]
> > https://lore.kernel.org/linuxppc-dev/20210117101242.dpwayq6wdgfdzirl@pe=
ngutronix.de/T/#m48f5befd96bc9842ece2a3ad14f4c27747206a53
> > Reported-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>
> > Fixes: 7d7195a026ba ("ibmvnic: Do not process device remove during
> > device reset")
> > Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
> > ---
> > v1 versus RFC:
> >   1/ articulate why remove the REMOVING checking in __ibmvnic_reset
> >   and why keep the current checking for REMOVING in ibmvnic_reset.
> >   2/ The locking issue mentioned by Uwe are being addressed separately
> >      by       https://lists.openwall.net/netdev/2021/01/08/89
> >   3/ This patch does not have merge conflict with 2/
> >
> >  drivers/net/ethernet/ibm/ibmvnic.c | 8 +-------
> >  1 file changed, 1 insertion(+), 7 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/ibm/ibmvnic.c
> > b/drivers/net/ethernet/ibm/ibmvnic.c
> > index aed985e08e8a..11f28fd03057 100644
> > --- a/drivers/net/ethernet/ibm/ibmvnic.c
> > +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> > @@ -2235,8 +2235,7 @@ static void __ibmvnic_reset(struct work_struct
> > *work)
> >       while (rwi) {
> >               spin_lock_irqsave(&adapter->state_lock, flags);
> >
> > -             if (adapter->state =3D=3D VNIC_REMOVING ||
> > -                 adapter->state =3D=3D VNIC_REMOVED) {
> > +             if (adapter->state =3D=3D VNIC_REMOVED) {
>
> If we do get here, we would crash because ibmvnic_remove() happened. It
> frees the adapter struct already.

Not exactly. viodev is gone; netdev is done; ibmvnic_adapter is still there=
.

Lijun
>
> >                       spin_unlock_irqrestore(&adapter->state_lock, flag=
s);
> >                       kfree(rwi);
> >                       rc =3D EBUSY;
> > @@ -5372,11 +5371,6 @@ static int ibmvnic_remove(struct vio_dev *dev)
> >       unsigned long flags;
> >
> >       spin_lock_irqsave(&adapter->state_lock, flags);
> > -     if (test_bit(0, &adapter->resetting)) {
> > -             spin_unlock_irqrestore(&adapter->state_lock, flags);
> > -             return -EBUSY;
> > -     }
> > -
> >       adapter->state =3D VNIC_REMOVING;
> >       spin_unlock_irqrestore(&adapter->state_lock, flags);
