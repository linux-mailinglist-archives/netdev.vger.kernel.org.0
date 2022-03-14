Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3974D8840
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 16:37:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241330AbiCNPiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 11:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231261AbiCNPiV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 11:38:21 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8511741FAF
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 08:37:10 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id q194so13069724qke.5
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 08:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fireburn-co-uk.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0elgh052PSKRgUoeTnvN0bWDvw6A8anfaBt8OXlPQ1Y=;
        b=IyDJx9FYLxq0/OFsl6PjULq1hPM856m5NjEgas6tyzwW95iNX23GcmcSfTJao1Fs/h
         tEtyXRs5sajz8UhQzmJCrvnbMP7lrCkmfqVXyx57DLKwk4PFK0RvlBIsiR/94g0I7C5A
         YrnmAurs8ZyiwcDO763iE4Nv7FSddrIfqLH+28Ije3Ai5heLz+OwouI0bqjK4GIIGWai
         MTsTx3GdhUHVPdnjITT9f0PKJUHfKt2sEuZ5Aur/ejjH+qKT/4cd6c/WW8NOPmmTLXgw
         izFMebbzzUX0tj8pI8aAt+aXqwLiX40VKiFbdvc6SUYsmPf/GGGio/meEWEfa6Q5ya6T
         7vIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0elgh052PSKRgUoeTnvN0bWDvw6A8anfaBt8OXlPQ1Y=;
        b=TBruk7I7pATUgCMYfkg/GRhHa8o6v967y2bXSa5ObggsjZzuolKtLID0SL6KPPm34r
         K3BkA3P6vMot10IO79+McD41HPHhJgFLlaOfXN2B4D5lIj55c5DNwEM61JhAG6QVj2FV
         pNm6kV9Fk4EKoS3pt1sQx02qmNvMxou34Byc0a0TMsoVB44jEiScBoArKDp9RRQWYIlB
         s1xtGVivhsp9xDn2CBb+zqY39rPZU8CkSiPK+dgEy0uzY/EM53NxGxvBX+BtXDZ/RDrA
         X/9RZ2GjPYpVkE8LcOkWx5q32MJPSwzgl5GVAvYBue6kjnkfVMmXVGhq8J0YF46H+ZtL
         IPKQ==
X-Gm-Message-State: AOAM532HOgMtMt2K0mm4sonhLgwxQxaLTdxcg/gdJ9Ws3TkSdyjcfjQ5
        Q60d0c0bdgYcDVCRxFO0EabnvDeUgKw4yqis1B4zfERuhRDMw1PW
X-Google-Smtp-Source: ABdhPJyTloUkN91Q7ZAlujMEv/38sKubt4ooFXq30iFcN33LD+RPW78EKqagwBPZqPZIqDQ7wmDhXrXxN16GxBT1U60=
X-Received: by 2002:a05:620a:1902:b0:5f1:8f5d:b0f2 with SMTP id
 bj2-20020a05620a190200b005f18f5db0f2mr15068195qkb.60.1647272229548; Mon, 14
 Mar 2022 08:37:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220312164550.1810665-1-mike@fireburn.co.uk> <61E2F921-2006-4E9A-AAFF-47371CBC5FCD@holtmann.org>
In-Reply-To: <61E2F921-2006-4E9A-AAFF-47371CBC5FCD@holtmann.org>
From:   Mike Lothian <mike@fireburn.co.uk>
Date:   Mon, 14 Mar 2022 15:36:57 +0000
Message-ID: <CAHbf0-GWcz85r4GEzmySFJ1n4iqeDTAm5H_Njs0FEpBs1hkJHw@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: hci_event: Remove excessive bluetooth warning
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        BlueZ <linux-bluetooth@vger.kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Mar 2022 at 15:32, Marcel Holtmann <marcel@holtmann.org> wrote:
>
> Hi Mike,
>
> > Fixes: 3e54c5890c87a ("Bluetooth: hci_event: Use of a function table to=
 handle HCI events")
> > Signed-off-by: Mike Lothian <mike@fireburn.co.uk>
> > ---
> > net/bluetooth/hci_event.c | 8 --------
> > 1 file changed, 8 deletions(-)
> >
> > diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> > index fc30f4c03d29..aa57fccd2e47 100644
> > --- a/net/bluetooth/hci_event.c
> > +++ b/net/bluetooth/hci_event.c
> > @@ -6818,14 +6818,6 @@ static void hci_event_func(struct hci_dev *hdev,=
 u8 event, struct sk_buff *skb,
> >               return;
> >       }
> >
> > -     /* Just warn if the length is over max_len size it still be
> > -      * possible to partially parse the event so leave to callback to
> > -      * decide if that is acceptable.
> > -      */
> > -     if (skb->len > ev->max_len)
> > -             bt_dev_warn(hdev, "unexpected event 0x%2.2x length: %u > =
%u",
> > -                         event, skb->len, ev->max_len);
> > -
>
> which event type is this? You need to have a commit message giving detail=
s. I am also pretty sure that this is broken hardware and we can go for rat=
elimited version, but the warning is justified if the hardware is stupid. I=
f our table is wrong, we fix the table, but not just silence an unpleasant =
warning.
>
> Regards
>
> Marcel
>

Hi Marcel

I noticed it had already been fixed in "Bluetooth: hci_event: Fix
HCI_EV_VENDOR max_len"

I've replied to that patch asking if it can be added to stable, would
be nice to get this into 5.17.0 before next week

Cheers

Mike
