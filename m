Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A911557EEE5
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 12:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237287AbiGWKyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jul 2022 06:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230399AbiGWKyQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jul 2022 06:54:16 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCB5D11441;
        Sat, 23 Jul 2022 03:54:14 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id n7so5293533ioo.7;
        Sat, 23 Jul 2022 03:54:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YL9wCFcJM1S8aQnJbcoxTMo6SNRCJK/vq4C87hsQwpU=;
        b=icTe+7uDRr7EXvhDnSXmpnK61DUvZdhBUV1EG52pxLeRH5b4Fp++sDQy0J4X6UI8Eh
         uGZ7po3LSPCe4MqV6mvQgXp1tKpRTebwdxMFJqJnbVMiOOXYa56IKetWOYEVjupA+mbG
         twO9t0rDvPLv/LnZwpC1PRjDAm98sUoNPLu5bilwe8uwhUF/REZaKCxGvUR+DG4GwupY
         96lp4Ne9iS5xiYgOuBNA8rdG3KGBiukHG3Dv1+RXor7fuWoy4onvrQzoGHG68D12evdN
         qopZqWfKVBQL30UA+lFKUymH1m/li+cOtP1l6Nh3OB+i2U+cnnDaysukc+2hdfwqKlvW
         HKMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YL9wCFcJM1S8aQnJbcoxTMo6SNRCJK/vq4C87hsQwpU=;
        b=fet/zYR/MdL65rLypuuwdS1sVnKizFS5itMVT6eLBp3mJD2ioFOkRfXJuKSSZizSrS
         N1918QxgOWSsRXE/Y2J077OsTQ8OHi82NuW8PxJmyKbMXH25xmB+QSBCZml41tEkFpWL
         meQ4MoAO2p02fVLqVw83TgewTIQdxGajPG5HSJ6t4ID1P6cNXZA/8nEtXczDe//OXOeQ
         qWlV3lWXfbe9rRq6gM/W1Sc+bNyRJV47d6uvIRAvNs4HDYfMrAOpn36hQJxSlDsjxtLJ
         CfQulUJoOilyChWeguQ5i63jQ4Y24qv/L/LNrK9KBDlTbSxml2gDqJCHIPMWP/wbrAOc
         0Jkw==
X-Gm-Message-State: AJIora/tK2fYHnenzpMrE5fhRXgPxpm95H2HTranHVHZB7MwFuhESIMy
        5aVGUDfcWpTqdm4z20vsofcC+NHORPIDQfj0reE=
X-Google-Smtp-Source: AGRyM1szkUECVWGAESedupd4SaLkQ477HkV5GtL8kMwaKob8JG7T9RM44BdYJtK/AyD8uGaMcylKdTpDzbiO3Mi3N/w=
X-Received: by 2002:a05:6638:1602:b0:341:3e1f:d862 with SMTP id
 x2-20020a056638160200b003413e1fd862mr1696518jas.24.1658573654111; Sat, 23 Jul
 2022 03:54:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220717133759.8479-1-khalid.masum.92@gmail.com>
 <3ea0ea90-48bf-ce19-e014-9443d732e831@gmail.com> <CAABMjtHiet1_SRvLBhoNxeEh865rwtZCkb510JmFPkHFMd5chQ@mail.gmail.com>
 <CABBYNZJVv=pJv60P6fYZh65JU+BV5agGfXEh4VenxELEXqtDsA@mail.gmail.com>
In-Reply-To: <CABBYNZJVv=pJv60P6fYZh65JU+BV5agGfXEh4VenxELEXqtDsA@mail.gmail.com>
From:   Khalid Masum <khalid.masum.92@gmail.com>
Date:   Sat, 23 Jul 2022 16:54:03 +0600
Message-ID: <CAABMjtEDHLRGVHrjPaCyuTX0SBODVcS+U+G+xS+YQH=23zk=hg@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: hci_core: Use ERR_PTR instead of NULL
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     Pavel Skripkin <paskripkin@gmail.com>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 5:04 AM Luiz Augusto von Dentz
<luiz.dentz@gmail.com> wrote:
>
> Hi Khalid,
>
> On Sun, Jul 17, 2022 at 11:34 AM Khalid Masum <khalid.masum.92@gmail.com> wrote:
> >
> > On Sun, Jul 17, 2022 at 10:17 PM Pavel Skripkin <paskripkin@gmail.com> wrote:
> > >
> > > Hi Khalid,
> > >
> > > Khalid Masum <khalid.masum.92@gmail.com> says:
> > > > Failure of kzalloc to allocate memory is not reported. Return Error
> > > > pointer to ENOMEM if memory allocation fails. This will increase
> > > > readability and will make the function easier to use in future.
> > > >
> > > > Signed-off-by: Khalid Masum <khalid.masum.92@gmail.com>
> > > > ---
> > >
> > > [snip]
> > >
> > > > index a0f99baafd35..ea50767e02bf 100644
> > > > --- a/net/bluetooth/hci_core.c
> > > > +++ b/net/bluetooth/hci_core.c
> > > > @@ -2419,7 +2419,7 @@ struct hci_dev *hci_alloc_dev_priv(int sizeof_priv)
> > > >
> > > >       hdev = kzalloc(alloc_size, GFP_KERNEL);
> > > >       if (!hdev)
> > > > -             return NULL;
> > > > +             return ERR_PTR(-ENOMEM);
> > > >
> > >
> > > This will break all callers of hci_alloc_dev(). All callers expect NULL
> > > in case of an error, so you will leave them with wrong pointer.
> >
> > You are right. All callers of hci_alloc_dev() need to be able to handle
> > the error pointer. I shall send a V2 with all the callers of hci_alloc_dev
> > handling the ERR_PTR.
> >
> > > Also, allocation functionS return an error only in case of ENOMEM, so
> > > initial code is fine, IMO
> > >
>
> If there just a single error like ENOMEM then Id say this is fine,
> just as it is fine for kzalloc.
>
> > I think it makes the memory allocation error handling look to be a bit
> > different from what we usually do while allocating memory which is,
> > returning an error or an error pointer. Here we are returning a NULL
> > without any context, making it a bit unreadable. So I think returning
> > an error pointer is better. If I am not mistaken, this also complies with
> > the return convention:
> > https://www.kernel.org/doc/htmldocs/kernel-hacking/convention-returns.html
>
> Not sure if that would apply to code that is basically a wrapper of kzalloc.

I got you.
> > > Thanks,
> > > --Pavel Skripkin
> >
> >
> > Thanks,
> >   -- Khalid Masum
>
>
>
> --
> Luiz Augusto von Dentz

Thanks,
  -- Khalid Masum
