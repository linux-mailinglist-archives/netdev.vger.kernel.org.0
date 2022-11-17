Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F98D62E7F0
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 23:12:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235015AbiKQWMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 17:12:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234710AbiKQWMV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 17:12:21 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 827A26160;
        Thu, 17 Nov 2022 14:12:20 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id u2so4553118ljl.3;
        Thu, 17 Nov 2022 14:12:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nn7CD1Io5Tu7IrvKfUpPCinD6fv0Cid4YkXQszLbTa0=;
        b=HNtqT3X+fZXMPAUtvFZEGrDknoC92jrQXKMoHNuWCUfeaQPRVAULY3fZqDTqk2NIRz
         L/SXPWL82YbSC9Dv3QkLR1BNjhy1YMblLF6GP6J+oHJTGW7V3mtq2FFT4QNzl/ZSIZSV
         G0+Lgh51wunlfbEpg2VGDLZhwspxlqwGoVnXdKTgw5IYrbGdNV6FcEaWa05RB/nOEAH7
         B9Mzo6WfmX9EXTnWYO5tS+mEQDm6immwn79yM+xEJ9xSlx7YfidWD/GF5W/ldRgnzbhM
         uIUoOlOiMgePlv4p0ZXIMZcjLsApNQ6Ij5IEtMYvIfk0eYvs8FhlEdcyBMJPsNfFWRie
         kLlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Nn7CD1Io5Tu7IrvKfUpPCinD6fv0Cid4YkXQszLbTa0=;
        b=iT6C756sQD3hLtO00gIUolk9+OzDeMAO/jXXZXYqtqcPFYemT5yz5S6Uk/Yf4QY1ta
         3LMFiqS1jrYpwMAJOECcLbcK+gMzTEShboOLloI7QLgDBalAUCagvhRML4ZyKS384QUy
         YxOQahY6H/TXn5xCqbOYB79P4ru0kYtdjUt2u4Qh3S+twGmRSTm177wdBTU0hiiCFTWI
         S9108548/AxyLlbnJwTNzfMDiNCXr5IX6i79SFTSfmKlwGpjMcKPenwqxkPDg7dhTGgT
         loS23qs6c95dGuTBoP7oZky8aBOcyZL7tvfDuWe3Dd8e8jW0oRSmbMTJ74yAALXQcQpQ
         MVoA==
X-Gm-Message-State: ANoB5pkoNUWWhpsOJWod8WO7wJvuXSFyIwSxprQFKh41qcba+IEkj4cB
        H0noLB8qqcA7Neamvp13f8fVfaIuQy43RQaaKvw=
X-Google-Smtp-Source: AA0mqf6XFdGLQW/qNOnI71a815e7g8gK6kELLCP8DjyotGqp/RBDsq3X83iooriuM6qpAmr2g8HEuGZtuah2g3JBZJc=
X-Received: by 2002:a2e:a4c7:0:b0:277:81ff:b8c4 with SMTP id
 p7-20020a2ea4c7000000b0027781ffb8c4mr1578359ljm.260.1668723138518; Thu, 17
 Nov 2022 14:12:18 -0800 (PST)
MIME-Version: 1.0
References: <20221116202856.55847-1-mat.jonczyk@o2.pl> <499a1278bcf1b2028f6984d61733717a849d9787.camel@intel.com>
 <232fd0ae-0002-53cb-9400-f0347e434d42@o2.pl> <7909f86e4d13015b7f14a6f3f1f75f053d837314.camel@intel.com>
In-Reply-To: <7909f86e4d13015b7f14a6f3f1f75f053d837314.camel@intel.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Thu, 17 Nov 2022 14:12:07 -0800
Message-ID: <CABBYNZJowvWWtKs_Ok74wNxCVsrKt26pqftG5hgpknusosjbZw@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: silence a dmesg error message in hci_request.c
To:     "Gix, Brian" <brian.gix@intel.com>
Cc:     "mat.jonczyk@o2.pl" <mat.jonczyk@o2.pl>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Von Dentz, Luiz" <luiz.von.dentz@intel.com>,
        "johan.hedberg@gmail.com" <johan.hedberg@gmail.com>,
        "marcel@holtmann.org" <marcel@holtmann.org>
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

Hi,

On Thu, Nov 17, 2022 at 1:45 PM Gix, Brian <brian.gix@intel.com> wrote:
>
> Hi  Mateusz,
>
> On Thu, 2022-11-17 at 22:27 +0100, Mateusz Jo=C5=84czyk wrote:
> > W dniu 17.11.2022 o 21:34, Gix, Brian pisze:
> > > On Wed, 2022-11-16 at 21:28 +0100, Mateusz Jo=C5=84czyk wrote:
> > > > On kernel 6.1-rcX, I have been getting the following dmesg error
> > > > message
> > > > on every boot, resume from suspend and rfkill unblock of the
> > > > Bluetooth
> > > > device:
> > > >
> > > >         Bluetooth: hci0: HCI_REQ-0xfcf0
> > > >
> > > This has a patch that fixes the usage of the deprecated HCI_REQ
> > > mechanism rather than hiding the fact it is being called, as in
> > > this
> > > case.
> > >
> > > I am still waiting for someone to give me a "Tested-By:" tag to
> > > patch:
> > >
> > > [PATCH 1/1] Bluetooth: Convert MSFT filter HCI cmd to hci_sync
> > >
> > > Which will also stop the dmesg error. If you could try that patch,
> > > and
> > > resend it to the list with a Tested-By tag, it can be applied.
> >
> > Hello,
> >
> > I did not receive this patch, as I was not on the CC list; I was not
> > aware of it. I will test it shortly.

You can find the patch here:

https://patchwork.kernel.org/project/bluetooth/patch/20221102175927.401091-=
2-brian.gix@intel.com/

> >
> > Any guidelines how I should test this functionality? I have a Sony
> > Xperia 10 i4113
> > mobile phone with LineageOS 19.1 / Android 12L, which according to
> > the spec supports
> > Bluetooth 5.0. Quick Google search tells me that I should do things
> > like
> >
> >         hcitool lescan
> >
>
> Whatever you were running that produced the
>
> "Bluetooth: hci0: HCI_REQ-0xfcf0"
>
> error in the dmesg log should be sufficient to determine that the error
> log is no longer happening. The HCI call is necessary on some
> platforms, so the absense of other negative behavior should be
> sufficient to verify that the call is still being made.  The code flow
> itself has not changed, and new coding enforces the HCI command
> sequence, so that it is more deterministric than it was with
> hci_request. The hci_request mechanism was an asyncronous request.
>
> > to discover the phone, then use gatttool to list the services, etc.
> >
> > Greetings,
> >
> > Mateusz
> >
>


--=20
Luiz Augusto von Dentz
