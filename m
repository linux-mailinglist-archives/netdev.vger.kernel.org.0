Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35F783E2DD1
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 17:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232286AbhHFPga (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 11:36:30 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:50874
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232103AbhHFPg3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 11:36:29 -0400
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPS id 9E2753F34D
        for <netdev@vger.kernel.org>; Fri,  6 Aug 2021 15:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1628264172;
        bh=nn6L3pGPAVUAOexXMQWFiqKMMywY28ef7UC0JW8Ecg0=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=WmvDKVWor8VkbzreY0Ni/fYR8IV/8T3D77mb5VcXdxId8k4Z8ofYQzpJhl0+BFlyz
         9RDw0LeysFrb33x2mNU5cR/1wh7hIjAHjWymIE3PUswEDj5ddKcpvm7n6TVxdr/rHN
         U8T0N8ejw4HkpjxK4jXU0BJV0Jk5tY0ODSEyW8GMstckcLViqwojNT96MtGKdhpxiS
         XvUD7so3iqMp7oe6aHpQuNYdOlwr5KzrXEeTDMRKv0dagi7P1U52o9MZ+xmgCdZJzl
         u821woPThz5Wws3o3uiIwPSdZUtFtvnjrB7kofPSl2bnFnv9F8mYAywdMBiXuoLAD2
         ADcFO5ppzEg5Q==
Received: by mail-ed1-f70.google.com with SMTP id d6-20020a50f6860000b02903bc068b7717so5128917edn.11
        for <netdev@vger.kernel.org>; Fri, 06 Aug 2021 08:36:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nn6L3pGPAVUAOexXMQWFiqKMMywY28ef7UC0JW8Ecg0=;
        b=fUOYopJ5hJ/K0cyCJ0fw7WKBRK2IaO9jAZCOgbycXRg0vuaXShGJafhZFYl+b+lDQF
         SsOAYxPDaocLXmSRvUN0Kgw+jK31rJN495VxhihTUFlVRYKujTBf+56DACnEcNjWnXqu
         rOsD6g+cOQH3DI0h+UT5lvKmf+EYlqPS5uRLRstuO+szJu8+MbjTCi69Av/M//EowgVa
         1vwW1IIp2YIUgjRpUxOujyMBaI/vMcGhZfMOT7JJ8kTaiyyLNZ/M9/0eceIUe706xY1b
         em8ZarJc+p+p5RGpuQvhyiJ3jquSO4bOUvvFu7uIyA3d4WTUg0gYBcXFduvc6N0lKFQL
         X1UA==
X-Gm-Message-State: AOAM532np6BeLxWRUCrXX+VoOZOIZLT1wcaO4G9J47Ryx8HTj5CtwtTw
        DDOrl86UX1oEgLGrUq3WMQAToDoyPHXrFHwGGNfIH0hPPjSK9kCcz2WAL+DpoyaQ9+absqtiJpq
        iu6hzrzEDpVqMGY+R38kxLQpiYX2Gt8/jcuCNVihSrC10iw1GBA==
X-Received: by 2002:a17:906:79a:: with SMTP id l26mr10772915ejc.192.1628264172328;
        Fri, 06 Aug 2021 08:36:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwJqPGLR0PlJMC/OXDefak0pjjk5EqClsHvqh8s6/EmtI7kAm/K+l+Zroo4+IF9Cf6F8ZPDPs2bZKtQYy+55U0=
X-Received: by 2002:a17:906:79a:: with SMTP id l26mr10772892ejc.192.1628264172061;
 Fri, 06 Aug 2021 08:36:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210514071452.25220-1-kai.heng.feng@canonical.com>
 <576B26FD-81F8-4632-82F6-57C4A7C096C4@holtmann.org> <8735ryk0o7.fsf@baylibre.com>
 <CAAd53p7Zc3Zk21rwj_x1BLgf8tWRxaKBmXARkM6d7Kpkb+fDZA@mail.gmail.com>
 <87y29o58su.fsf@baylibre.com> <CAAd53p4Ss1Z-7CB4g=_xZYxo1xDz6ih6GHUuMcgncy+yNAfU4w@mail.gmail.com>
 <87a6lzx7jf.fsf@baylibre.com> <CAAd53p6T_K67CPthLPObF=OWWCEChW4pMFMwuq87qWmTmzP2VA@mail.gmail.com>
 <87bl6cnzy2.fsf@baylibre.com> <CAAd53p5TVJk3G4cArS_UO7cgUpJLONNGVHnpezXy0XTYoXd_uw@mail.gmail.com>
 <87tuk3j6rh.fsf@baylibre.com>
In-Reply-To: <87tuk3j6rh.fsf@baylibre.com>
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Date:   Fri, 6 Aug 2021 23:36:00 +0800
Message-ID: <CAAd53p7BU2=GwmyLUECKZfGhD830UQUk12mxU2y9HsXv=F_AfA@mail.gmail.com>
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

Hi Mattijs,

On Fri, Aug 6, 2021 at 4:51 PM Mattijs Korpershoek
<mkorpershoek@baylibre.com> wrote:
>
> Hi Kai-Heng,
>
> Kai-Heng Feng <kai.heng.feng@canonical.com> writes:
>
> > Hi Mattijs,
> >
> > On Thu, Aug 5, 2021 at 2:55 PM Mattijs Korpershoek
> > <mkorpershoek@baylibre.com> wrote:
> >>
> >> Hi Kai-Heng,
> >>
> >> Thanks for your patch,
> >>
> >> Kai-Heng Feng <kai.heng.feng@canonical.com> writes:
> >>
> >
> > [snipped]
> >
> >> I confirm this diff works for me:
> >>
> >> root@i500-pumpkin:~# hciconfig hci0 up
> >> root@i500-pumpkin:~# hciconfig hci0 down
> >> root@i500-pumpkin:~# hciconfig hci0 up
> >> root@i500-pumpkin:~# hciconfig hci0
> >> hci0:   Type: Primary  Bus: SDIO
> >>         BD Address: 00:0C:E7:55:FF:12  ACL MTU: 1021:8  SCO MTU: 244:4
> >>         UP RUNNING
> >>         RX bytes:11268 acl:0 sco:0 events:829 errors:0
> >>         TX bytes:182569 acl:0 sco:0 commands:829 errors:0
> >>
> >> root@i500-pumpkin:~# hcitool scan
> >> Scanning ...
> >>         <redacted>       Pixel 3 XL
> >>
> >> Tested-by: Mattijs Korpershoek <mkorpershoek@baylibre.com>
> >
> > I found that btmtksdio_flush() only cancels the work instead of doing
> > flush_work(). That probably explains why putting ->shutdown right
> > before ->flush doesn't work.
> > So can you please test the following again:
> > diff --git a/drivers/bluetooth/btmtksdio.c b/drivers/bluetooth/btmtksdio.c
> > index 9872ef18f9fea..b33c05ad2150b 100644
> > --- a/drivers/bluetooth/btmtksdio.c
> > +++ b/drivers/bluetooth/btmtksdio.c
> > @@ -649,9 +649,9 @@ static int btmtksdio_flush(struct hci_dev *hdev)
> >  {
> >         struct btmtksdio_dev *bdev = hci_get_drvdata(hdev);
> >
> > -       skb_queue_purge(&bdev->txq);
> > +       flush_work(&bdev->tx_work);
> >
> > -       cancel_work_sync(&bdev->tx_work);
> > +       skb_queue_purge(&bdev->txq);
> >
> >         return 0;
> >  }
> > diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> > index 2560ed2f144d4..a61e610a400cb 100644
> >
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
> I've tried this but I have the same (broken) symptoms as before.
>
> Here are some logs of v3:
> dmesg: https://pastebin.com/1x4UHkzy
> ftrace: https://pastebin.com/Lm1d6AWy

Thanks for your testing. I think I finally got it:
btmtksdio_shutdown()
-> mtk_hci_wmt_sync()
 -> __hci_cmd_send()
  then waiting for BTMTKSDIO_TX_WAIT_VND_EVT, which is cleared in
btmtksdio_recv_event():
btmtksdio_recv_event()
-> hci_recv_frame()
 -> queue_work(hdev->workqueue, &hdev->rx_work);

That means it has to be done before the following drain_workqueue() call.
Can you please see if moving the ->shutdown() part right before
drain_workqueue() can fix the issue?

Kai-Heng

>
> Mattijs
>
> >
> > Kai-Heng
