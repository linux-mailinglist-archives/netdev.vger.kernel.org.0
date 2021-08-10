Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71C4B3E5246
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 06:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237032AbhHJEiI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 00:38:08 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:51940
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235432AbhHJEiH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 00:38:07 -0400
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPS id BBFDB3F360
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 04:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1628570254;
        bh=8UxNrUeLSStMldoAcFeW2Lw3XcfaO3qq0rvI+4obbHY=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=txpVeGXxE2HzkqnAVq18fD6kOdKypVbQKbelYe472IO7pUNOyaSBZsBypxKOU5wK/
         nv1nBaRaFz6+r5/PBu1YHnGdYXug+SeLjjmVwQUtOsjnIDlzflycVb3CUFGo4MzK0z
         Vc00OhzSi5fVuqepwOnE155stbequDrgWwEeu3WYFQ2DuhVhSRsAOL1uatrSfU9eCE
         0zS/eMqcKYbRtPUUznhXLCrxfCYwmvDNWACXWUy2I5ZgIbR2pGoqXU5N2FO6k6QrhG
         27YqRrYr4gA4vSJGxGD+KM3bmFj10c41wHulmqcvI9sBGah2IaUdGYf4FkmWJ5ZKjL
         Dh1CCw+emxzDg==
Received: by mail-ed1-f70.google.com with SMTP id de5-20020a0564023085b02903bb92fd182eso10203964edb.8
        for <netdev@vger.kernel.org>; Mon, 09 Aug 2021 21:37:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8UxNrUeLSStMldoAcFeW2Lw3XcfaO3qq0rvI+4obbHY=;
        b=rEe7c5w3bfVN+tuaUDr4nQXFmNgkVcivIp8lFpmlKdHSi7BOic1Xqps49cpnGxFC6e
         swrhJOY2OKIjBRKu+vAvnJ9g+GKOo0RQ5SjaIW3/f5wglAeMNp9W4SDtphB/eGhw+E1H
         RblaeJAl0fB+rsig/dFBt4zfMIhq7zFFuQcfHezGhoA8/e2i8I1nYsl4uRqnPZQxh+MY
         LQn4rbNlRoOx4jx1osHi6Wn2xwDHLPgwRe3P9DIEmo283NbKYLf9rpkrRhK1Q7AmYYJ2
         ueAsNWPjENfBaKAKce0ddgYycbo3Loz8fijwSXH1r+JGo2xQbcm2hILAVvx0jkN6tfid
         M72Q==
X-Gm-Message-State: AOAM533ONKEpbRvhj6bD9Cv8GT/lHpM4cKk9lf+pm6gRsYO7FIwtpePF
        9sR4hRh9PNBcMNMf+MOh4U6er8herfrMPqpFm+bAiVPNtRtkdm2gqUCTiXvDueyAhZdaDaUw4AT
        oLaC9mbzXCipAD4xHM8OGTg07SoViQUv8toxgUUjvSBTcyN03iQ==
X-Received: by 2002:aa7:d14b:: with SMTP id r11mr2544056edo.259.1628570254394;
        Mon, 09 Aug 2021 21:37:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyXpRpqG2cNYzvU/k8PphD5FhvLU0fkLgntOuFcGb0LqjPXaDLngJqdPiYstnPz3rkAxqMs87SH/fbW9Bj+VPY=
X-Received: by 2002:aa7:d14b:: with SMTP id r11mr2544039edo.259.1628570254182;
 Mon, 09 Aug 2021 21:37:34 -0700 (PDT)
MIME-Version: 1.0
References: <20210809174358.163525-1-kai.heng.feng@canonical.com> <CAJMQK-gNk8LmguOQ+iDxGtJCwCUcM3rPQ0CJs=kRZzv81nso4g@mail.gmail.com>
In-Reply-To: <CAJMQK-gNk8LmguOQ+iDxGtJCwCUcM3rPQ0CJs=kRZzv81nso4g@mail.gmail.com>
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Date:   Tue, 10 Aug 2021 12:37:22 +0800
Message-ID: <CAAd53p712ndn=DHGNwHZQ97GkUC--XG1wjc1DqSWBm85QxkFgA@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: Move shutdown callback before flushing tx and
 rx queue
To:     Hsin-Yi Wang <hsinyi@chromium.org>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Mattijs Korpershoek <mkorpershoek@baylibre.com>,
        Guenter Roeck <linux@roeck-us.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:BLUETOOTH SUBSYSTEM" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 10, 2021 at 12:10 PM Hsin-Yi Wang <hsinyi@chromium.org> wrote:
>
> On Tue, Aug 10, 2021 at 1:44 AM Kai-Heng Feng
> <kai.heng.feng@canonical.com> wrote:
> >
> > Commit 0ea9fd001a14 ("Bluetooth: Shutdown controller after workqueues
> > are flushed or cancelled") introduced a regression that makes mtkbtsdio
> > driver stops working:
> > [   36.593956] Bluetooth: hci0: Firmware already downloaded
> > [   46.814613] Bluetooth: hci0: Execution of wmt command timed out
> > [   46.814619] Bluetooth: hci0: Failed to send wmt func ctrl (-110)
> >
> > The shutdown callback depends on the result of hdev->rx_work, so we
> > should call it before flushing rx_work:
> > -> btmtksdio_shutdown()
> >  -> mtk_hci_wmt_sync()
> >   -> __hci_cmd_send()
> >    -> wait for BTMTKSDIO_TX_WAIT_VND_EVT gets cleared
> >
> > -> btmtksdio_recv_event()
> >  -> hci_recv_frame()
> >   -> queue_work(hdev->workqueue, &hdev->rx_work)
> >    -> clears BTMTKSDIO_TX_WAIT_VND_EVT
> >
> > So move the shutdown callback before flushing TX/RX queue to resolve the
> > issue.
> >
> > Reported-and-tested-by: Mattijs Korpershoek <mkorpershoek@baylibre.com>
> > Tested-by: Hsin-Yi Wang <hsinyi@chromium.org>
>
> Hello,
>
> Sorry for confusion, but the version I tested is this one:
> https://lkml.org/lkml/2021/8/4/486 (shutdown is prior to the
> test_and_clear HCI_UP)
> I tested this version and still see the error I've seen before.

Ah, sorry for causing your trouble, I am the one who got confused :(
HCI_UP is obviously required for hci_req_sync() to work.

Let me resend one, and sorry again!

Kai-Heng

>
>
>
>
> > Cc: Guenter Roeck <linux@roeck-us.net>
> > Fixes: 0ea9fd001a14 ("Bluetooth: Shutdown controller after workqueues are flushed or cancelled")
> > Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> > ---
> >  net/bluetooth/hci_core.c | 16 ++++++++--------
> >  1 file changed, 8 insertions(+), 8 deletions(-)
> >
> > diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> > index cb2e9e513907..8da04c899197 100644
> > --- a/net/bluetooth/hci_core.c
> > +++ b/net/bluetooth/hci_core.c
> > @@ -1735,6 +1735,14 @@ int hci_dev_do_close(struct hci_dev *hdev)
> >
> >         hci_leds_update_powered(hdev, false);
> >
> > +       if (!hci_dev_test_flag(hdev, HCI_UNREGISTER) &&
> > +           !hci_dev_test_flag(hdev, HCI_USER_CHANNEL) &&
> > +           test_bit(HCI_UP, &hdev->flags)) {
> > +               /* Execute vendor specific shutdown routine */
> > +               if (hdev->shutdown)
> > +                       hdev->shutdown(hdev);
> > +       }
> > +
> >         /* Flush RX and TX works */
> >         flush_work(&hdev->tx_work);
> >         flush_work(&hdev->rx_work);
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
> >
> > --
> > 2.31.1
> >
