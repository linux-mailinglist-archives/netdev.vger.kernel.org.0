Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE3EA2FC0A9
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 21:14:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728239AbhASUKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 15:10:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391692AbhASUJi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 15:09:38 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47246C0613D6
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 12:08:37 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id v184so878098wma.1
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 12:08:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=gUbElotSDC5VjMwIga4WOXAKVvCXV926k6hzZgmzzKo=;
        b=f8s9eiBwX0BAYgTTiS9iO+QNwEqYZwj8DStyNa1yjK4wsqYVXC3Zsj15HDc1DrObws
         o8aUi0EE1VUj9Xk055rdTv0Y9QauywK2PuRFbCbXhIbAE0q8HKTqdaaCcurbtdlv9h26
         q4VBSOuR6lRnXTU93lB/eoI3Gx9d4AfEKE4UaXkIONv3E57E6GnLvRtMRcvsHttFhw78
         uFju6QTUN43rbbW28mO9U3C6XgnUmqzmdb1LqlPeCDlw9hQCLij2S2YJZFgX4wx7nqut
         DaF1TvxlRZ/9kon465I+dAt80nqvMZtm/t/UZbRQkgaXdYCiiJgw0ftRBp9iH5fE5duY
         VoEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=gUbElotSDC5VjMwIga4WOXAKVvCXV926k6hzZgmzzKo=;
        b=g01SWDBcdmnhO7Kr9Bmgm1Mt47qE/YYYtgqg/gn1QG4UWXgYAY31FJShTNkWIQw7Zt
         wLHSA5e/PJUIQAANxfbRcQpFHflXzce43p6yjpH0DomCpCxdUQM3ZeLf7o+Z1zoRmwYX
         cx7Ba3uyOEZVgm7R/NZZERLjGuIRUaw9iD1N8Trhn4Ca1TlvH5As4hs3k2V5UnNod39W
         BIjvCi/OSlw5ptRbUPygy76+OL1ZNeemPYV3z0m3gDVm+sonJpGb1I/wa8MosCcdMkUM
         g9rNiGG1vyvM+6P+YAZRPaVcUH3lKFvNnsZPOn9hhVn8L7Iqjb+rbe9lE2umzb3Lh+mF
         fpRA==
X-Gm-Message-State: AOAM532P5ASdO6keMcxqsqIoYq7Ev2ZOfElm2R5+kY5Db8M0h6QKkFob
        KF2omzfAOc4maMun026X7rsCiq6BDodcWvknnLo+Ya20Ers=
X-Google-Smtp-Source: ABdhPJzrByNHbxqQDoB5h5ZZFMFxCtyIYWGU1zYgenco9ZaYf+wvAgUsCDWmr+8dnoCWDmWDLWUkCsPQ3dcf5zQZwqU=
X-Received: by 2002:a1c:9c01:: with SMTP id f1mr1085750wme.159.1611086916064;
 Tue, 19 Jan 2021 12:08:36 -0800 (PST)
MIME-Version: 1.0
References: <20210119193313.43791-1-ljp@linux.ibm.com> <20210119194959.a67nlfbngx4drvyz@pengutronix.de>
In-Reply-To: <20210119194959.a67nlfbngx4drvyz@pengutronix.de>
From:   Lijun Pan <lijunp213@gmail.com>
Date:   Tue, 19 Jan 2021 14:08:25 -0600
Message-ID: <CAOhMmr5pmLLCdm7Jjkkfvuyof9PZ+R4zgidEFgC_ms-r6rv4ow@mail.gmail.com>
Subject: Re: [PATCH net RFC] ibmvnic: device remove has higher precedence over reset
To:     =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Lijun Pan <ljp@linux.ibm.com>, netdev@vger.kernel.org,
        gregkh@linuxfoundation.org, julietk@linux.vnet.ibm.com,
        mpe@ellerman.id.au, paulus@samba.org, kernel@pengutronix.de,
        benh@kernel.crashing.org, drt@linux.ibm.com,
        Jakub Kicinski <kuba@kernel.org>, sukadev@linux.ibm.com,
        linuxppc-dev@lists.ozlabs.org, davem@davemloft.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 19, 2021 at 1:56 PM Uwe Kleine-K=C3=B6nig
<u.kleine-koenig@pengutronix.de> wrote:
>
> On Tue, Jan 19, 2021 at 01:33:13PM -0600, Lijun Pan wrote:
> > Returning -EBUSY in ibmvnic_remove() does not actually hold the
> > removal procedure since driver core doesn't care for the return
> > value (see __device_release_driver() in drivers/base/dd.c
> > calling dev->bus->remove()) though vio_bus_remove
> > (in arch/powerpc/platforms/pseries/vio.c) records the
> > return value and passes it on. [1]
> >
> > During the device removal precedure, we should not schedule
> > any new reset, and rely on the flush_work and flush_delayed_work
> > to complete the pending resets, and specifically we need to
> > let __ibmvnic_reset() keep running while in REMOVING state since
> > flush_work and flush_delayed_work shall call __ibmvnic_reset finally.
> >
> > [1] https://lore.kernel.org/linuxppc-dev/20210117101242.dpwayq6wdgfdzir=
l@pengutronix.de/T/#m48f5befd96bc9842ece2a3ad14f4c27747206a53
> > Reported-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>
> > Fixes: 7d7195a026ba ("ibmvnic: Do not process device remove during devi=
ce reset")
> > Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
> > ---
> >  drivers/net/ethernet/ibm/ibmvnic.c | 8 +-------
> >  1 file changed, 1 insertion(+), 7 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/=
ibm/ibmvnic.c
> > index aed985e08e8a..11f28fd03057 100644
> > --- a/drivers/net/ethernet/ibm/ibmvnic.c
> > +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> > @@ -2235,8 +2235,7 @@ static void __ibmvnic_reset(struct work_struct *w=
ork)
> >       while (rwi) {
> >               spin_lock_irqsave(&adapter->state_lock, flags);
> >
> > -             if (adapter->state =3D=3D VNIC_REMOVING ||
> > -                 adapter->state =3D=3D VNIC_REMOVED) {
> > +             if (adapter->state =3D=3D VNIC_REMOVED) {
>
> I think you need to keep the check for VNIC_REMOVING. Otherwise you
> don't prevent that a new reset being queued after ibmvnic_remove() set
> the state to VNIC_REMOVING. Am I missing something?

I leave the checking for REMOVING there in ibmvnic_reset, which is the
function to schedule/queue up the resets.
Here I delete the REMOVING in __ibmvnic_reset to let it run and finish.
Otherwise flush_work will not do anything if __ibmvnic_reset() just return
doing nothing.

I can explain it in the commit message.

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
>
> Best regards
> Uwe
>
> --
> Pengutronix e.K.                           | Uwe Kleine-K=C3=B6nig       =
     |
> Industrial Linux Solutions                 | https://www.pengutronix.de/ =
|
