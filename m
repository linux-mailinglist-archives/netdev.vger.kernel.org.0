Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2106274759
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 19:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgIVRUD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 13:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbgIVRUD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 13:20:03 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17D51C061755;
        Tue, 22 Sep 2020 10:20:03 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id e23so16334811otk.7;
        Tue, 22 Sep 2020 10:20:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EItoq1kaiHeWVc5lky8YhdzGpyspzkaqvTZAN+0uG8s=;
        b=ek1BIZZyVl3RntwXpKxZKVRy7AjMYd2t5ZjDu0Gkr+83ZXPJiTnzcLSziQYU5YQi9M
         zz5wOAudN8qHSec8RMYhz3079Sg2fztpxsFVlYPTbpjJj4NEFIouF6csvy38nV6qdvO4
         LHFyhEB6+sDeNLM20tDikE0MdOwP+PWOSb8F52houXJNiMI3wO2FMRTniR98K97dgkZ4
         EtCLz1jHbknfXgrX6t3JeREbjP8noQCnc9wvt1K0D+0uAg6Q1ij30KxXkn+n5pJw/Wot
         Jh3lFs3CaqraBeH+JP3TFUsIDL8If4ZRXHdII6p6FMHRs1zjGRt8K18vJWC8slKoX1wA
         E1DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EItoq1kaiHeWVc5lky8YhdzGpyspzkaqvTZAN+0uG8s=;
        b=l0+h5lLkvRLkkQnFYZ/5cFi7WhDHwLkvwEFVEfINT1DSl/+zies1OznIRuV0Z3BaAm
         VMW7M1QEcE/c+uYsf4J7xr40L7fWLWvTZCF9QyOlr9Rn+l3Sr9gaJfMBR0JmQs4nVwCO
         GCnbhXSf+mCRQ9RLoN1YynMgH1+q3YEhCOyQ4eDJU3l28AQaJqoFHRBZeUvM+e9SfW2E
         /fjlgdJT2fFZQHT9FVJs8cWCK6j+H2i7jYQ5xkljd0rZqTlQoBekJDflzEhHwhBWkCDK
         6F2H/BMaQ0ow0OL5GQS0lsikYszpOZZ1rr36FOdSX3Bu0sl/MOYZUFXmrlefP7WyjPj2
         sxMQ==
X-Gm-Message-State: AOAM531IjbME+drraLp1MfJkm4ZexmoZ4pmEMl0/g0cNPoV07MNnQGYY
        FARMH/iwbZAPDa7qQcElOtrbgJJ2SAZrguiEfbk=
X-Google-Smtp-Source: ABdhPJwNcpShFc8c3V/UC1bmKbpnJq1sPySTQ40fTrCHUXJ486Nscbfvc9yXAnnr7C/wr8kImZHNzbiYtV9UD4Td08Q=
X-Received: by 2002:a9d:4695:: with SMTP id z21mr3525657ote.91.1600795202320;
 Tue, 22 Sep 2020 10:20:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200921163021.v1.1.Id3160295d33d44a59fa3f2a444d74f40d132ea5c@changeid>
 <CABBYNZJGfDoV+E-f6T=ZQ2RT0doXDdOB7tgVrt=4fpvKcpmH4w@mail.gmail.com> <CAJQfnxHcvm_-iCP-2Y6GR1vG4ZmMr==ZuMHBua8TeeiNbqAJgA@mail.gmail.com>
In-Reply-To: <CAJQfnxHcvm_-iCP-2Y6GR1vG4ZmMr==ZuMHBua8TeeiNbqAJgA@mail.gmail.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Tue, 22 Sep 2020 10:19:50 -0700
Message-ID: <CABBYNZKuXtf5Z_zHG1h2c6_0to8o2MqvmQvt-8mmX0hdb3_B9g@mail.gmail.com>
Subject: Re: [PATCH v1] Bluetooth: Enforce key size of 16 bytes on FIPS level
To:     Archie Pusaka <apusaka@google.com>
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Alain Michaud <alainm@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Archie,

On Tue, Sep 22, 2020 at 12:37 AM Archie Pusaka <apusaka@google.com> wrote:
>
> Hi Luiz,
>
> On Tue, 22 Sep 2020 at 01:13, Luiz Augusto von Dentz
> <luiz.dentz@gmail.com> wrote:
> >
> > Hi Archie,
> >
> > On Mon, Sep 21, 2020 at 1:31 AM Archie Pusaka <apusaka@google.com> wrote:
> > >
> > > From: Archie Pusaka <apusaka@chromium.org>
> > >
> > > According to the spec Ver 5.2, Vol 3, Part C, Sec 5.2.2.8:
> > > Device in security mode 4 level 4 shall enforce:
> > > 128-bit equivalent strength for link and encryption keys required
> > > using FIPS approved algorithms (E0 not allowed, SAFER+ not allowed,
> > > and P-192 not allowed; encryption key not shortened)
> > >
> > > This patch rejects connection with key size below 16 for FIPS level
> > > services.
> > >
> > > Signed-off-by: Archie Pusaka <apusaka@chromium.org>
> > > Reviewed-by: Alain Michaud <alainm@chromium.org>
> > >
> > > ---
> > >
> > >  net/bluetooth/l2cap_core.c | 7 ++++++-
> > >  1 file changed, 6 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
> > > index ade83e224567..306616ec26e6 100644
> > > --- a/net/bluetooth/l2cap_core.c
> > > +++ b/net/bluetooth/l2cap_core.c
> > > @@ -1515,8 +1515,13 @@ static bool l2cap_check_enc_key_size(struct hci_conn *hcon)
> > >          * that have no key size requirements. Ensure that the link is
> > >          * actually encrypted before enforcing a key size.
> > >          */
> > > +       int min_key_size = hcon->hdev->min_enc_key_size;
> > > +
> > > +       if (hcon->sec_level == BT_SECURITY_FIPS)
> > > +               min_key_size = 16;
> > > +
> > >         return (!test_bit(HCI_CONN_ENCRYPT, &hcon->flags) ||
> > > -               hcon->enc_key_size >= hcon->hdev->min_enc_key_size);
> > > +               hcon->enc_key_size >= min_key_size);
> >
> > While this looks fine to me, it looks like this should be placed
> > elsewhere since it takes an hci_conn and it is not L2CAP specific.
>
> From what I understood, it is permissible to use AES-CCM P-256
> encryption with key length < 16 when encrypting the link, but such a
> connection does not satisfy security level 4, and therefore must not
> be given access to level 4 services. However, I think it is
> permissible to give them access to level 3 services or below.
>
> Should I use l2cap chan->sec_level for this purpose? I'm kind of lost
> on the difference between hcon->sec_level and chan->sec_level.

The chan->sec_level is L2CAP channel required sec_level while
hcon->sec_level is the current secure level in effect, at some point I
guess we assign the hcon->sec_level with chan->sec_level but Im not
sure if that has already happened here or not.

> >
> > >  }
> > >
> > >  static void l2cap_do_start(struct l2cap_chan *chan)
> > > --
> > > 2.28.0.681.g6f77f65b4e-goog
> > >
> >
> >
> > --
> > Luiz Augusto von Dentz



-- 
Luiz Augusto von Dentz
