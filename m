Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C3B7612A16
	for <lists+netdev@lfdr.de>; Sun, 30 Oct 2022 11:29:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbiJ3K31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Oct 2022 06:29:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiJ3K30 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Oct 2022 06:29:26 -0400
Received: from mail-ua1-x932.google.com (mail-ua1-x932.google.com [IPv6:2607:f8b0:4864:20::932])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 329CC330;
        Sun, 30 Oct 2022 03:29:25 -0700 (PDT)
Received: by mail-ua1-x932.google.com with SMTP id x20so3914381ual.6;
        Sun, 30 Oct 2022 03:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=siZbDKvkv6GDmhZBqxezDI7PD/3HH95diPO+ZsUwpjo=;
        b=WNLIgtt5mOTUiknqiJdlxmjsudTixQ6DAzH8tAAbRCcCuFlbkjimnTdUFsMvjISvYP
         Ar1+bG2UrAuFR3UCINZEhh6oD//Kn6kM4gJk46wfmVb41rPf6oxcBv3wEJ7bnGte32uQ
         1bdLhC024i/xgeByNLSr03LUw5zpNWN6hVZpSN4OKvEawTg50ft3NEKV4LhWb797cwJI
         6wJpJCGudYU/gCXs/RVsC3T/VgoPGMcINSriDGTDq1V8IAxfGkZ0XAaMCBzW41FxDe0h
         N2NENsMt4jpRnzELU1q2a7qNrc3RzPopZMXaa9JXRnmjOhwcqrmO7QKep9WkNNeTxOiK
         v9oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=siZbDKvkv6GDmhZBqxezDI7PD/3HH95diPO+ZsUwpjo=;
        b=E4GSIvIEUMFEk1hxRyzPqLLMyzj1KRpWsFnCoIhxGgDZ7PS5KQa7MDqK8/9f+YG5xF
         gYR5hs7Yfx8Kvg6oA5lypLot8Lhzty+ild/V5UDoQPADSn5zgY8uSyrZF/L6st7pdV1o
         4lU178Fxtn0iKHQ9o1GkaVy5yKXIBaOY5gAIzHLCMuY/r7jR7sUXQO/SrY88OBlMZhJf
         K9NtykBa4I1WJGrT8eNAj2mRSah3E//BTFvGVhsTGiXsTJQsyAHlBFkCZjguB3nXed0w
         0RnvbfbtJ8Xb0cabjtIiTQUfgKYVdPsRHdmXTAx3Zp/oyUwd0kgA/niTnC17l+a/WjlU
         1DAA==
X-Gm-Message-State: ACrzQf0SlaTFouo0ZwFw7FGnU69WHoR0UObvZgjC/vXmIvrA+ocCA0QB
        oHfFMxluKngNzBKALmcm1H9VbR5ctsO3g2uucF8=
X-Google-Smtp-Source: AMsMyM5hylRd0xhmbLwKG1AYBixMFt8oW4I0vGo0LFbDby5FFzTk5F1XFtHbFqXgZ3dyrFcNuwRCFB1egWwf5aCXeEc=
X-Received: by 2002:ab0:76d1:0:b0:407:702d:7b67 with SMTP id
 w17-20020ab076d1000000b00407702d7b67mr2757436uaq.6.1667125764100; Sun, 30 Oct
 2022 03:29:24 -0700 (PDT)
MIME-Version: 1.0
References: <20221029214058.25159-1-tegongkang@gmail.com> <80f39eff-d175-785c-c10f-a31a046ec132@molgen.mpg.de>
In-Reply-To: <80f39eff-d175-785c-c10f-a31a046ec132@molgen.mpg.de>
From:   Kang Minchul <tegongkang@gmail.com>
Date:   Sun, 30 Oct 2022 19:29:13 +0900
Message-ID: <CA+uqrQDukt7u8Nvbn7RK5K+Lw8PoxO769Nf9CF9UbvM2WshXTw@mail.gmail.com>
Subject: Re: [PATCH v2] Bluetooth: Use kzalloc instead of kmalloc/memset
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Am 29.10.22 um 23:40 schrieb Kang Minchul:
> > This commit replace kmalloc + memset to kzalloc
>
> replace*s*
>
> (Though starting with =E2=80=9CThis commit =E2=80=A6=E2=80=9D is redundan=
t.
>
> > for better code readability and simplicity.
> >
> > Following messages are related cocci warnings.
>
> Maybe: This addresse the cocci warning below.
>
> > WARNING: kzalloc should be used for d, instead of kmalloc/memset
> >
> > Signed-off-by: Kang Minchul <tegongkang@gmail.com>
> > ---
> > V1 -> V2: Change subject prefix
> >
> >   net/bluetooth/hci_conn.c | 6 ++----
> >   1 file changed, 2 insertions(+), 4 deletions(-)
> >
> > diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
> > index 7a59c4487050..287d313aa312 100644
> > --- a/net/bluetooth/hci_conn.c
> > +++ b/net/bluetooth/hci_conn.c
> > @@ -824,11 +824,10 @@ static int hci_le_terminate_big(struct hci_dev *h=
dev, u8 big, u8 bis)
> >
> >       bt_dev_dbg(hdev, "big 0x%2.2x bis 0x%2.2x", big, bis);
> >
> > -     d =3D kmalloc(sizeof(*d), GFP_KERNEL);
> > +     d =3D kzalloc(sizeof(*d), GFP_KERNEL);
> >       if (!d)
> >               return -ENOMEM;
> >
> > -     memset(d, 0, sizeof(*d));
> >       d->big =3D big;
> >       d->bis =3D bis;
> >
> > @@ -861,11 +860,10 @@ static int hci_le_big_terminate(struct hci_dev *h=
dev, u8 big, u16 sync_handle)
> >
> >       bt_dev_dbg(hdev, "big 0x%2.2x sync_handle 0x%4.4x", big, sync_han=
dle);
> >
> > -     d =3D kmalloc(sizeof(*d), GFP_KERNEL);
> > +     d =3D kzalloc(sizeof(*d), GFP_KERNEL);
> >       if (!d)
> >               return -ENOMEM;
> >
> > -     memset(d, 0, sizeof(*d));
> >       d->big =3D big;
> >       d->sync_handle =3D sync_handle;
>
> Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
>
>
> Kind regards,
>
> Paul

Thank you so much for your feedback!
Should I amend the previous commit message and resend PATCH v3?

regards,

Kang Minchul
