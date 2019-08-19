Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34CE791B76
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 05:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbfHSD0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Aug 2019 23:26:41 -0400
Received: from mail-ua1-f67.google.com ([209.85.222.67]:34533 "EHLO
        mail-ua1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbfHSD0k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Aug 2019 23:26:40 -0400
Received: by mail-ua1-f67.google.com with SMTP id r10so155973uam.1
        for <netdev@vger.kernel.org>; Sun, 18 Aug 2019 20:26:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2dVZIdsfkzE6AbZuPYaxpGaVfhK5dGN1XGxWqMQWY5g=;
        b=heT3PUoK/y0BKoPbUHQ2gKZqKUJRu6V/ap5Ky4DJiIUq+MbwUJSJQElQWdkYS8CQL6
         48HidbKc/o0cRsjxvRicBehJUnT4GEtdijU2OZifcPkimvX+r40BM1b/SgiCYX5UomYo
         Jxqk3kZMLWt5p/QE590Cuec1wy2Wfa0+WkOBAqFdR9RhRZasmJq4cyexZMlKxmsYQm2O
         i8SIO7tKQ8rYB37CDjTkKtxB43ufgpx2Dd0yJSHRHGrjCxR7jMwQOjRQF64QmXG6OTry
         9zVN6q3Pp3JVR+xANkVhB++hZri6JsHRgGGc7NNcUzM1UK/djB01NxU4zxaORVxExRQF
         byig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2dVZIdsfkzE6AbZuPYaxpGaVfhK5dGN1XGxWqMQWY5g=;
        b=CcUb2n9SDhXvffV/EHnKWGJMiRakf3IoDCIKkuNPxXe/QPgtrgLx18/J9sXxUSe+JN
         K6baRaAVfOEjcQDvkWed8pAzrHDltrxxBLJ5s9tDce5TgOf9gvzyD0gCKLwDrbZl2tpQ
         Gj1E8RhVH8JplOrUQM/kyioVjxWRQNds1vlJVB4xg4tFANb0+PAb1II1fL8g0lKCFLUO
         BOQhMXV9iNqEMkLqiyPWtbXl/f3IATBKV9e1qgcEoQ54r6ved+rwvw0xjrK6JkYjL3HK
         o/HIWSuVMHwmDgP6om7m13UAarsuTptAjMglskCJfugvcWlhGxjBdHbFwMWnJL3ILtm+
         kT+Q==
X-Gm-Message-State: APjAAAWdR0aWihJC+WJOT+8LcEz5HyvwkWr4E0ZLMBSsK3IeNhEgsdZL
        xp/FIfbtFhvlw/ZJaVlLleuOPhqaz35p6A02bSC5yw==
X-Google-Smtp-Source: APXvYqxhyJcN1oA5l10VDuydZejyHRlhznRvcuZMYkVOMjvKlEkhs560owClx2d55emJZN7Lul0H0tYh/4EqaOEs/l8=
X-Received: by 2002:ab0:4993:: with SMTP id e19mr1856015uad.2.1566185199211;
 Sun, 18 Aug 2019 20:26:39 -0700 (PDT)
MIME-Version: 1.0
References: <CAPpJ_edibR0bxO0Pg=NAaRU8fGYheyN8NTv-gVyTDCJhE-iG5Q@mail.gmail.com>
 <20190816100903.7549-1-jian-hong@endlessm.com> <F7CD281DE3E379468C6D07993EA72F84D18932B7@RTITMBSVM04.realtek.com.tw>
In-Reply-To: <F7CD281DE3E379468C6D07993EA72F84D18932B7@RTITMBSVM04.realtek.com.tw>
From:   Jian-Hong Pan <jian-hong@endlessm.com>
Date:   Mon, 19 Aug 2019 11:26:02 +0800
Message-ID: <CAPpJ_edU68X-Ki+J61qfws+1-=zv54bcak9tzkMX=CkDS5mOMA@mail.gmail.com>
Subject: Re: [PATCH v2] rtw88: pci: Move a mass of jobs in hw IRQ to soft IRQ
To:     Tony Chuang <yhchuang@realtek.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@endlessm.com" <linux@endlessm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tony Chuang <yhchuang@realtek.com> =E6=96=BC 2019=E5=B9=B48=E6=9C=8816=E6=
=97=A5 =E9=80=B1=E4=BA=94 =E4=B8=8B=E5=8D=886:44=E5=AF=AB=E9=81=93=EF=BC=9A
>
> > From: Jian-Hong Pan
> >
> > There is a mass of jobs between spin lock and unlock in the hardware
> > IRQ which will occupy much time originally. To make system work more
> > efficiently, this patch moves the jobs to the soft IRQ (bottom half) to
> > reduce the time in hardware IRQ.
> >
> > Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
> > ---
> > v2:
> >  Change the spin_lock_irqsave/unlock_irqrestore to spin_lock/unlock in
> >  rtw_pci_interrupt_handler. Because the interrupts are already disabled
> >  in the hardware interrupt handler.
> >
> >  drivers/net/wireless/realtek/rtw88/pci.c | 33 +++++++++++++++++++-----
> >  1 file changed, 27 insertions(+), 6 deletions(-)
> >
> > diff --git a/drivers/net/wireless/realtek/rtw88/pci.c
> > b/drivers/net/wireless/realtek/rtw88/pci.c
> > index 00ef229552d5..0740140d7e46 100644
> > --- a/drivers/net/wireless/realtek/rtw88/pci.c
> > +++ b/drivers/net/wireless/realtek/rtw88/pci.c
> > @@ -866,12 +866,28 @@ static irqreturn_t rtw_pci_interrupt_handler(int =
irq,
> > void *dev)
> >  {
> >       struct rtw_dev *rtwdev =3D dev;
> >       struct rtw_pci *rtwpci =3D (struct rtw_pci *)rtwdev->priv;
> > -     u32 irq_status[4];
> >
> >       spin_lock(&rtwpci->irq_lock);
> >       if (!rtwpci->irq_enabled)
> >               goto out;
> >
> > +     /* disable RTW PCI interrupt to avoid more interrupts before the =
end of
> > +      * thread function
> > +      */
> > +     rtw_pci_disable_interrupt(rtwdev, rtwpci);
>
> So basically it's to prevent back-to-back interrupts.
>
> Nothing wrong about it, I just wondering why we don't like
> back-to-back interrupts. Does it means that those interrupts
> fired between irq_handler and threadfin would increase
> much more time to consume them.

1. It is one of the reasons.  Besides, the hardware interrupt has
higher priority than soft IRQ.  If next hardware interrupt is coming
faster then the soft IRQ (BH), the software IRQ may always become
pended.
2. Keep the data's state until the interrupt is fully dealt.
3. The process of request_threaded_irq is documented:
https://www.kernel.org/doc/htmldocs/kernel-api/API-request-threaded-irq.htm=
l

> > +out:
> > +     spin_unlock(&rtwpci->irq_lock);
> > +
> > +     return IRQ_WAKE_THREAD;
> > +}
> > +
> > +static irqreturn_t rtw_pci_interrupt_threadfn(int irq, void *dev)
> > +{
> > +     struct rtw_dev *rtwdev =3D dev;
> > +     struct rtw_pci *rtwpci =3D (struct rtw_pci *)rtwdev->priv;
> > +     unsigned long flags;
> > +     u32 irq_status[4];
> > +
> >       rtw_pci_irq_recognized(rtwdev, rtwpci, irq_status);
> >
> >       if (irq_status[0] & IMR_MGNTDOK)
> > @@ -891,8 +907,11 @@ static irqreturn_t rtw_pci_interrupt_handler(int i=
rq,
> > void *dev)
> >       if (irq_status[0] & IMR_ROK)
> >               rtw_pci_rx_isr(rtwdev, rtwpci, RTW_RX_QUEUE_MPDU);
> >
> > -out:
> > -     spin_unlock(&rtwpci->irq_lock);
> > +     /* all of the jobs for this interrupt have been done */
> > +     spin_lock_irqsave(&rtwpci->irq_lock, flags);
>
> I suggest to protect the ISRs. Because next patches will require
> to check if the TX DMA path is empty. This means I will also add
> this rtwpci->irq_lock to the TX path, and check if the skb_queue
> does not have any pending SKBs not DMAed successfully.

Ah ... Okay for the TX path

> > +     if (rtw_flag_check(rtwdev, RTW_FLAG_RUNNING))
>
> Why check the flag here? Is there any racing or something?
> Otherwise it looks to break the symmetry.

According to backtrace, I notice rtw_pci_stop will be invoked in
rtw_power_off,  rtw_core_stop which clears the running state.
rtw_core_stop is invoked by rtw_enter_ips due to IEEE80211_CONF_IDLE.
If the stop command comes between the hardware interrupt and soft IRQ
(BH) and there is no start command again, I think user wants the WiFi
stop instead of becoming start again.

Jian-Hong Pan
