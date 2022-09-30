Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E2075F1663
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 00:58:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbiI3W6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 18:58:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230291AbiI3W6o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 18:58:44 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 096BE1166F3;
        Fri, 30 Sep 2022 15:58:43 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id z4so8976168lft.2;
        Fri, 30 Sep 2022 15:58:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=FPDhyg+fqnd6KI676BphOSnDk1rwd88+iFcjWjngdEk=;
        b=T+cBzOQMyhh+6jhfOrIUDL6wQFttyucRRtPWsMeZoMN1ydBnJoRcQh5hqbY34Bx3kO
         ziDWgtrclU3pbCStFb9zWTcpSTljj9imf5FbudgxPedyaZXFruiEC3PhFm+/lcbKavhj
         7ymDdwIrmL4sUHS4tZEPi6n8EXgNGhJlwbpm444R+mEnAFBvRtkk/gJDZ7HaZFEH8uxt
         JJ7JUIQPYL/iUG4BDETwX8qjK6OiLBZTqIxd9Xl7NmpqWMhjh8SQ6BdqsI5BDVP/4dZQ
         ZAyy22UmDFBiTqk++TgKykS7xaBjuGYluQ6OOPDtUdwGl/L/YC6QdfU7tTJ8Q2r252Yh
         Svyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=FPDhyg+fqnd6KI676BphOSnDk1rwd88+iFcjWjngdEk=;
        b=48pl/mmMC7ETThEQrFFgHJdtsZvXu+YCNgH5dHh/Dh0O9dlHy05ZZ0itgOCLCg0YNl
         L9jhp0zz918G2KQ0JQO9XbVkDP+EBIC0vXcBIOd39zg7qMN5395mVhOzovRmsyBO46tU
         RdjhUWOuz2ikqlUcd3aFvibPz9bTfrbejI0dji2SDfySFlnW9FbkgEy+LRwxUXllTMi0
         GzjGB8S0ZJ7ArVkIuQWpAvodt9G/oYjTUg/kITTZHXl7DdFfPzxbx9cW5pd/ib4zOPBT
         UWlr9o1wAZ9mesyozTHBlmCzDjLLma+GcOitDEpT7rbttBmPLTQVvhreha2OUkynyk0d
         iSOA==
X-Gm-Message-State: ACrzQf3vDOcwSb5iitfv+4lH7krwCZGy1cw1p6TwqAY13JYeM1d3JX2N
        pcgi8MsIaqUi021ihU9Bovw5NL3mpiE3AFa/X3g=
X-Google-Smtp-Source: AMsMyM5qmOCwuqmr0BdDuL5pXdqM+82omWToXEFZMotMSk68eatOJ6BLSqDAbWWV4fDiFJa0edlJ+TrK463ZgHpQ2JM=
X-Received: by 2002:ac2:4c8b:0:b0:4a2:2432:93ff with SMTP id
 d11-20020ac24c8b000000b004a2243293ffmr128870lfl.26.1664578721152; Fri, 30 Sep
 2022 15:58:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220930140655.2723164-1-ajye_huang@compal.corp-partner.google.com>
 <CABBYNZJZcgQ+VsPu68-14=EQGxxZ1VpHth37uO_NnGm+SsOnbw@mail.gmail.com> <CALprXBaUMR0uxMKeJ8f8+BWHDesfB9CxDquy4Muptf4eppmQdA@mail.gmail.com>
In-Reply-To: <CALprXBaUMR0uxMKeJ8f8+BWHDesfB9CxDquy4Muptf4eppmQdA@mail.gmail.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Fri, 30 Sep 2022 15:58:29 -0700
Message-ID: <CABBYNZ+UPJz2Oh0d-o-v=hURHf2cSfCCF2epoJUHNY9f3GbQDA@mail.gmail.com>
Subject: Re: [PATCH v1] bluetooth: Fix the bluetooth icon status after running
 hciconfig hci0 up
To:     Ajye Huang <ajye_huang@compal.corp-partner.google.com>
Cc:     linux-kernel@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ajye,

On Fri, Sep 30, 2022 at 3:30 PM Ajye Huang
<ajye_huang@compal.corp-partner.google.com> wrote:
>
> On Sat, Oct 1, 2022 at 3:57 AM Luiz Augusto von Dentz
> <luiz.dentz@gmail.com> wrote:
> >
> > Hi Ajye,
> >
> > On Fri, Sep 30, 2022 at 7:07 AM Ajye Huang
> > <ajye_huang@compal.corp-partner.google.com> wrote:
> > >
> > > When "hciconfig hci0 up" command is used to bluetooth ON, but
> > > the bluetooth UI icon in settings still not be turned ON.
> > >
> > > Refer to commit 2ff13894cfb8 ("Bluetooth: Perform HCI update for power on synchronously")
> > > Add back mgmt_power_on(hdev, ret) into function hci_dev_do_open(struct hci_dev *hdev)
> > > in hci_core.c
> > >
> > > Signed-off-by: Ajye Huang <ajye_huang@compal.corp-partner.google.com>
> > > ---
> > >  net/bluetooth/hci_core.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > >
> > > diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> > > index 0540555b3704..5061845c8fc2 100644
> > > --- a/net/bluetooth/hci_core.c
> > > +++ b/net/bluetooth/hci_core.c
> > > @@ -481,6 +481,7 @@ static int hci_dev_do_open(struct hci_dev *hdev)
> > >         hci_req_sync_lock(hdev);
> > >
> > >         ret = hci_dev_open_sync(hdev);
> > > +       mgmt_power_on(hdev, ret);
> > >
> > >         hci_req_sync_unlock(hdev);
> > >         return ret;
> > > --
> > > 2.25.1
> >
> >
> > I believe the culprit is actually the following change:
> >
> > git show cf75ad8b41d2a:
> >
> > @@ -1489,8 +1488,7 @@ static int hci_dev_do_open(struct hci_dev *hdev)
> >                     !hci_dev_test_flag(hdev, HCI_USER_CHANNEL) &&
> >                     hci_dev_test_flag(hdev, HCI_MGMT) &&
> >                     hdev->dev_type == HCI_PRIMARY) {
> > -                       ret = __hci_req_hci_power_on(hdev);
> > -                       mgmt_power_on(hdev, ret);
> > +                       ret = hci_powered_update_sync(hdev);
> >
> > So we should probably restore mgmt_power_on above.
> >
> > --
> > Luiz Augusto von Dentz
>
> Hi Luiz
>
> Now, this code you mentioned in hci_dev_open_sync() was moved from
> hci_core.c to hci_sync.c
> The below modification is workable.
> Do you agree?
> If so, I will send you the v2 version. Thanks
>
> index 15c75ef4c271..76c3107c9f91 100644
> --- a/net/bluetooth/hci_sync.c
> +++ b/net/bluetooth/hci_sync.c
> @@ -4676,6 +4676,7 @@ int hci_dev_open_sync(struct hci_dev *hdev)
>                     hci_dev_test_flag(hdev, HCI_MGMT) &&
>                     hdev->dev_type == HCI_PRIMARY) {
>                         ret = hci_powered_update_sync(hdev);
> +                       mgmt_power_on(hdev, ret);
>                 }
>         } else {
>                 /* Init failed, cleanup */

Ive submitted a change like that already:

https://patchwork.kernel.org/project/bluetooth/patch/20220930201920.225767-1-luiz.dentz@gmail.com/

-- 
Luiz Augusto von Dentz
