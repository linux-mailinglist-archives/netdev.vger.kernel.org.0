Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 185FC1EBBA8
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 14:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728140AbgFBM1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 08:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728087AbgFBM1N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 08:27:13 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 682CDC08C5C0
        for <netdev@vger.kernel.org>; Tue,  2 Jun 2020 05:27:12 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id n23so1587884ljh.7
        for <netdev@vger.kernel.org>; Tue, 02 Jun 2020 05:27:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SzkhBbLbmHxP92irZBt7jTabNaEj2bzN89Fv4cbtbow=;
        b=RlVJzfDPTeQf0cs8V529R1SL0IM9WLu1oq53oOBFnQc8CK7laDj1EXvNHcyNU7V3zL
         +hXDt9b/b0xTrPHdqxXc5mLcM7EJ5dVO2I6Ug3oXT2mUdocCSC7VVaPksud5NiZ/Ilau
         NcI7/WOUlhrUOn8q+a1lZth0gnGnO6+uO9LCCqPMKUVPhG1j0feT4IjzQFd61Mz7JMqd
         nF71TdjlYJsmbzlQ4edArYM9MhueZrxOvwjZSJixgZAfpUBPhI8cbipg3duiOWySK80w
         FkASaPRR625pL/WUC6R1Kj6Aos86ohAjKZvRtqfOwppDQLRNljFWYBEx0ESYjA4CC/44
         Tuog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SzkhBbLbmHxP92irZBt7jTabNaEj2bzN89Fv4cbtbow=;
        b=SlWNy6uMKEbw4UNpWwW9+yhvyFzLBFHt7L7LGEjZg3l1SHUZcVwnMWywdxWb0B+VVB
         9u2mOR+Pb2jBh29FGHgQd2Cjr7kHEDj23h/XJ9fJMCRaoWStvdjUHg7MD71inmejDrx0
         JHa/9BVn4aPkDekiQfGLSS9yxHAp+znRtgKfqkXU09k3dsGDGYyVnByH5+CXg/Hc+fdN
         lGcY5rtKyNAZ/+N65XN9qi6XmSj5/lKK2RbHNUNRRL/nSA/m9njFQFKhwoTJB+yDLF5R
         dR9hvAxmw5w2sS56dF46mJXw/wpK4zKcN8615ypz3ai2HDhk1U5zfztq8gYAoWuLwq1A
         ftYQ==
X-Gm-Message-State: AOAM532eWYkEuGVu1TbEx01Y1JQYEIUp30u5jxITl17zF2967FSiYAqj
        rVNuh30RyHNgCFfZe8a09/0oJAVqd6JxhEuQl6D/CA==
X-Google-Smtp-Source: ABdhPJz5gVZkHpLqefodvt73dt1ctZHG9Ln62jnSZBf/xAjF6zl95qgtHq8WB33aWNsSv7HXwC+Z52otFsPcw/1BNnw=
X-Received: by 2002:a2e:9ad6:: with SMTP id p22mr7949105ljj.3.1591100830499;
 Tue, 02 Jun 2020 05:27:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200601184223.1.I281c81384150e8fefbebf32fa79cb091d0311208@changeid>
 <CANFp7mXDvdicvyEpU-oDu4fBj92nQ7SENVdd_rG9TFQkqDevZg@mail.gmail.com>
In-Reply-To: <CANFp7mXDvdicvyEpU-oDu4fBj92nQ7SENVdd_rG9TFQkqDevZg@mail.gmail.com>
From:   Alain Michaud <alainmichaud@google.com>
Date:   Tue, 2 Jun 2020 08:26:59 -0400
Message-ID: <CALWDO_VetmqNFf1TT0zk2ijURy004hsipGwgtX6arS-TKqFbpw@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: Check scan state before disabling during suspend
To:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Cc:     Manish Mandlik <mmandlik@google.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Bluez mailing list <linux-bluetooth@vger.kernel.org>,
        ChromeOS Bluetooth Upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 1, 2020 at 9:49 PM Abhishek Pandit-Subedi
<abhishekpandit@chromium.org> wrote:
>
> Hey linux-bluetooth,
>
> We found this bug when reverting some Chromium maintained patches in
> our repository that was conditionally dropping LE scan enable commands
> if it wasn't toggling between true/false. On some Intel controllers,
> disabling LE scan when it's already disabled resulted in a "Command
> Disallowed" and this was causing suspend to fail.
>
> On Mon, Jun 1, 2020 at 6:43 PM Manish Mandlik <mmandlik@google.com> wrote:
> >
> > Check current scan state by checking HCI_LE_SCAN flag and send scan
> > disable command only if scan is already enabled.
> >
> > Signed-off-by: Manish Mandlik <mmandlik@google.com>
> > ---
> >
> >  net/bluetooth/hci_request.c | 10 ++++++----
> >  1 file changed, 6 insertions(+), 4 deletions(-)
> >
> > diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
> > index 1fc55685da62d..1acf5b8e0910c 100644
> > --- a/net/bluetooth/hci_request.c
> > +++ b/net/bluetooth/hci_request.c
> > @@ -998,8 +998,9 @@ static void hci_req_set_event_filter(struct hci_request *req)
> >
> >  static void hci_req_config_le_suspend_scan(struct hci_request *req)
> >  {
> > -       /* Can't change params without disabling first */
> > -       hci_req_add_le_scan_disable(req);
> > +       /* Before changing params disable scan if enabled */
> > +       if (hci_dev_test_flag(req->hdev, HCI_LE_SCAN))
> > +               hci_req_add_le_scan_disable(req);
> >
> >         /* Configure params and enable scanning */
> >         hci_req_add_le_passive_scan(req);
> > @@ -1065,8 +1066,9 @@ void hci_req_prepare_suspend(struct hci_dev *hdev, enum suspended_state next)
> >                 page_scan = SCAN_DISABLED;
> >                 hci_req_add(&req, HCI_OP_WRITE_SCAN_ENABLE, 1, &page_scan);
> >
> > -               /* Disable LE passive scan */
> > -               hci_req_add_le_scan_disable(&req);
> > +               /* Disable LE passive scan if enabled */
> > +               if (hci_dev_test_flag(hdev, HCI_LE_SCAN))
> > +                       hci_req_add_le_scan_disable(&req);
> >
> >                 /* Mark task needing completion */
> >                 set_bit(SUSPEND_SCAN_DISABLE, hdev->suspend_tasks);
> > --
> > 2.27.0.rc2.251.g90737beb825-goog
> >
>
> Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Reviewed-by: Alain Michaud <alainm@chromium.org>
>
> --
> You received this message because you are subscribed to the Google Groups "ChromeOS Bluetooth Upstreaming" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to chromeos-bluetooth-upstreaming+unsubscribe@chromium.org.
> To post to this group, send email to chromeos-bluetooth-upstreaming@chromium.org.
> To view this discussion on the web visit https://groups.google.com/a/chromium.org/d/msgid/chromeos-bluetooth-upstreaming/CANFp7mXDvdicvyEpU-oDu4fBj92nQ7SENVdd_rG9TFQkqDevZg%40mail.gmail.com.
