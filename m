Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 151383E038B
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 16:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238178AbhHDOmk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 10:42:40 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:56510
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238037AbhHDOmj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 10:42:39 -0400
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPS id C6D703F355
        for <netdev@vger.kernel.org>; Wed,  4 Aug 2021 14:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1628088145;
        bh=3wAPLTNTz+K6PssPvD29DSKcaFgyHs1tGU9uPv0wDys=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=t5nOOzKIA2o6Rgd0nulKNvf3B/Ubf/sIK6NtMKr8ljPhuZqB+t49k/GGjp2b8kHO0
         ThBFJHcYCxvzft7lTvo07iRC3nGaiBw52igrmR92kp/uvLqyAu+vEhmpADFe9bAPRX
         GYAROzCmx/Mh+uLG9S619/N62bDDMDHa1SNx6riHwNrqnX4qNS4Y4uj54RkN+xtojT
         UZFVxVJKrIw7vxzQRgDgtl/Af6G4geRgdjB3jkCw1NanCVrFq5gSSdQ6VerMDFSjfQ
         GujC9qZa1F/0oOvp3txlMLKN9u0v0mmxokSCpBHRAzlY7kHgrQl6nWPhS1ekWHZ3hN
         Fop2jdU7Rp/pw==
Received: by mail-ed1-f71.google.com with SMTP id cm18-20020a0564020c92b02903bc7f21d540so1560010edb.13
        for <netdev@vger.kernel.org>; Wed, 04 Aug 2021 07:42:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3wAPLTNTz+K6PssPvD29DSKcaFgyHs1tGU9uPv0wDys=;
        b=Il0hA//bDLfbsn9i71UGWcjyoOTx1BZOE24WTm1jh5XFv6zNXvs8BAUgdFVcqWbwWz
         OJ9FmcOLZ1NtG7GcTytIj6euWvuK0x4lDge+mhiDEbytUdlNezvTvhPRe/XAjL3J8USn
         VuRJ7dshARk+cuwyDGD74l8/OGA7XSn6l8oO/mjxlvm8/uANUHUX0io/CMQLP1RWH3a7
         02KMwI4SFMbyRUrjNWM/zzh4h6E59ydDgxbdFlWb5QsxitLnqBKDqTxRlCLP4IjHdNHI
         RFK49NRphZX3dKHiG0/f6b7/YeKUNC8byDK5gRwg3ae+nhOOODkqJZV2Ws0eKGyNAlv2
         H+3Q==
X-Gm-Message-State: AOAM533y7yNZyQKqU1TkauDPrPHIcFZhoHS1/jdv++7lPbDcelJwWWk1
        x0reSO5B0jYc6HDImGytnZdSpuU86F6OnjCSZ5Pref4kxt+5t7aDQbHjTLcg/mK1eLUzTyoS0wN
        EWzYOSODb3jf2TbkFMdlh6XgNIv+F2Nwjmo4vZCVgMvqHRe5Irg==
X-Received: by 2002:a17:907:9d2:: with SMTP id bx18mr9112337ejc.117.1628088145474;
        Wed, 04 Aug 2021 07:42:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyOaQSvCaKPRq4H/5+YCJPxGecpIdfcA+4DRu7m7wAnxxdu88WH23lia/jjgNqV7LJNX9GlmVz4ZA/+PeiS+gI=
X-Received: by 2002:a17:907:9d2:: with SMTP id bx18mr9112321ejc.117.1628088145254;
 Wed, 04 Aug 2021 07:42:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210514071452.25220-1-kai.heng.feng@canonical.com>
 <576B26FD-81F8-4632-82F6-57C4A7C096C4@holtmann.org> <8735ryk0o7.fsf@baylibre.com>
 <CAAd53p7Zc3Zk21rwj_x1BLgf8tWRxaKBmXARkM6d7Kpkb+fDZA@mail.gmail.com>
 <87y29o58su.fsf@baylibre.com> <CAAd53p4Ss1Z-7CB4g=_xZYxo1xDz6ih6GHUuMcgncy+yNAfU4w@mail.gmail.com>
 <87a6lzx7jf.fsf@baylibre.com>
In-Reply-To: <87a6lzx7jf.fsf@baylibre.com>
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Date:   Wed, 4 Aug 2021 22:42:09 +0800
Message-ID: <CAAd53p6T_K67CPthLPObF=OWWCEChW4pMFMwuq87qWmTmzP2VA@mail.gmail.com>
Subject: Re: [PATCH v2] Bluetooth: Shutdown controller after workqueues are
 flushed or cancelled
To:     Mattijs Korpershoek <mkorpershoek@baylibre.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Fabien Parent <fparent@baylibre.com>,
        Sean Wang <sean.wang@mediatek.com>,
        "open list:BLUETOOTH SUBSYSTEM" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 3, 2021 at 4:21 PM Mattijs Korpershoek
<mkorpershoek@baylibre.com> wrote:
>
> Hi Kai-Heng,
>
> Kai-Heng Feng <kai.heng.feng@canonical.com> writes:
>
> > Hi Mattijs,
> >
> > On Fri, Jul 30, 2021 at 7:40 PM Mattijs Korpershoek
> > <mkorpershoek@baylibre.com> wrote:
> >>
> >> Hi Kai-Heng,
> >
> > [snipped]
> >
> >> Thank you for your help. Sorry I did not post the logs previously.
> >>
> >> dmesg: https://pastebin.com/tpWDNyQr
> >> ftrace on btmtksdio: https://pastebin.com/jmhvmwUw
> >
> > Seems like btmtksdio needs shudown() to be called before flush().
> > Since the order was there for a very long time, changing the calling
> > order indeed can break what driver expects.
> > Can you please test the following patch:
> > diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> > index 2560ed2f144d..a61e610a400c 100644
> > --- a/net/bluetooth/hci_core.c
> > +++ b/net/bluetooth/hci_core.c
> > @@ -1785,6 +1785,14 @@ int hci_dev_do_close(struct hci_dev *hdev)
> >         aosp_do_close(hdev);
> >         msft_do_close(hdev);
> >
> > +       if (!hci_dev_test_flag(hdev, HCI_UNREGISTER) &&
> > +           !hci_dev_test_flag(hdev, HCI_USER_CHANNEL) &&
> > +           test_bit(HCI_UP, &hdev->flags)) {
> > +               /* Execute vendor specific shutdown routine */
> > +               if (hdev->shutdown)
> > +                       hdev->shutdown(hdev);
> > +       }
> > +
> >         if (hdev->flush)
> >                 hdev->flush(hdev);
> >
> > @@ -1798,14 +1806,6 @@ int hci_dev_do_close(struct hci_dev *hdev)
> >                 clear_bit(HCI_INIT, &hdev->flags);
> >         }
> >
> > -       if (!hci_dev_test_flag(hdev, HCI_UNREGISTER) &&
> > -           !hci_dev_test_flag(hdev, HCI_USER_CHANNEL) &&
> > -           test_bit(HCI_UP, &hdev->flags)) {
> > -               /* Execute vendor specific shutdown routine */
> > -               if (hdev->shutdown)
> > -                       hdev->shutdown(hdev);
> > -       }
> > -
> >         /* flush cmd  work */
> >         flush_work(&hdev->cmd_work);
>
> Thanks for the patch and your help.
> I've tried it, but it seems that it does not improve for me.
> I'm still observing:
>
> i500-pumpkin login: root
> root@i500-pumpkin:~# hciconfig hci0 up
> Can't init device hci0: Connection timed out (110)
>
> Logs for this session:
> dmesg:   https://pastebin.com/iAFk5Tzi
> ftrace:  https://pastebin.com/kEMWSYrE

Thanks for the testing!
What about moving the shutdown() part right after hci_req_sync_lock()
so tx/rx can still work:

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 2560ed2f144d4..be3113fb7d4b0 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1727,6 +1727,14 @@ int hci_dev_do_close(struct hci_dev *hdev)
        hci_request_cancel_all(hdev);
        hci_req_sync_lock(hdev);

+       if (!hci_dev_test_flag(hdev, HCI_UNREGISTER) &&
+           !hci_dev_test_flag(hdev, HCI_USER_CHANNEL) &&
+           test_bit(HCI_UP, &hdev->flags)) {
+               /* Execute vendor specific shutdown routine */
+               if (hdev->shutdown)
+                       hdev->shutdown(hdev);
+       }
+
        if (!test_and_clear_bit(HCI_UP, &hdev->flags)) {
                cancel_delayed_work_sync(&hdev->cmd_timer);
                hci_req_sync_unlock(hdev);
@@ -1798,14 +1806,6 @@ int hci_dev_do_close(struct hci_dev *hdev)
                clear_bit(HCI_INIT, &hdev->flags);
        }

-       if (!hci_dev_test_flag(hdev, HCI_UNREGISTER) &&
-           !hci_dev_test_flag(hdev, HCI_USER_CHANNEL) &&
-           test_bit(HCI_UP, &hdev->flags)) {
-               /* Execute vendor specific shutdown routine */
-               if (hdev->shutdown)
-                       hdev->shutdown(hdev);
-       }
-
        /* flush cmd  work */
        flush_work(&hdev->cmd_work);





>
>
> >
> > Kai-Heng
> >
> >>
> >> Mattijs
> >> >
> >> > Kai-Heng
> >> >
> >> >>
> >> >> Thanks,
> >> >> Mattijs Korpershoek
> >> >>
> >> >>
> >> >> >
> >> >> > Regards
> >> >> >
> >> >> > Marcel
