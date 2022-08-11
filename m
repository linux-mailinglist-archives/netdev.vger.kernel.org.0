Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2535905C2
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 19:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236700AbiHKRWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 13:22:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236159AbiHKRWP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 13:22:15 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 999DEAE45;
        Thu, 11 Aug 2022 10:21:09 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id k26so34672484ejx.5;
        Thu, 11 Aug 2022 10:21:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=kZuTb0XGOTxegdvIxstiuNGagHtnJca7Yl4Fn6HCR2U=;
        b=SP2yV5p++9LMug3fjfrGVmsKvDQ9rh4ZPjL2VNIGKsJ2jUqgQ5DT0/GHk8W+fm4i9H
         LKtDRuC5tWIM7YEhAtMPAQsE7ItZ7+WUMJi913Y4fr45Ii7+gzOLcDEX1lRH4SldcXss
         M3qD6lb1grRoNCUQuvbd/DRosE6jCviS31yhVRhVBGP0j6yBK/5rl4Cr2TSzjOq29Frg
         uC+aTXP5zI2WUQpP7N9D+VCfovB6opEPWXw5WELmLVEMFBy83H2Bg2ZwvCJhfTCLsV1L
         wBueyUvKzX1/qrbRL22LZPS687iLH8jheOEQGSOELaSqfvvdHID9ed0YhUweIxEq++L7
         rkRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=kZuTb0XGOTxegdvIxstiuNGagHtnJca7Yl4Fn6HCR2U=;
        b=dMmmr/Xjy9k59D/BdqSoMigvGcdqlfQ68S7slxoT0ZJzb1un+baTX5IBf8oSOkBGbZ
         182GFG+tls8U1sCRoItSEzq41Esmm0H8TUmNxEkYTUOd+Nd29Vxahmz0+7NPa1hi+IKQ
         w7ae69D+nBTQRscGhvHqRFrZ1UvjK9cVWVKm52xzqy4cRrxs+qLstdpvBCZD6zKJyjpo
         VagB2ehx+qXtMRTwA+KvmMGEW0aFtI3sJdoHhaNDWu3OVd36ukEIWTdUFEy2v/FE56qH
         o9lm/PEINhB66/n+23TRUJyYwQLJUEKn3+rO7T6UORGmWRIL1yQyDG490wWpKDTreDMY
         YejQ==
X-Gm-Message-State: ACgBeo2FjgSYZqZF4iYLt45KFtUZSPuLEoJUmKHaLCIPc87CEyHd/IbD
        s0EgQ3SCtqM2AuyaMwC6AZI/4yaL1ttK0ygUim4B+bUMCQwsiQ==
X-Google-Smtp-Source: AA6agR52eKD7sHKzXtCUmoyL7gdAJGg4UEwh6k+z0wcVc/BRVJFEw3GI5tA0pxbTraxn+f68wUQdk+cGkuWT/hPug1E=
X-Received: by 2002:a17:907:a40d:b0:733:17c1:a246 with SMTP id
 sg13-20020a170907a40d00b0073317c1a246mr77077ejc.132.1660238467916; Thu, 11
 Aug 2022 10:21:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220810164627.1.Id730b98f188a504d9835b96ddcbc83d49a70bb36@changeid>
 <CABBYNZLhhdKLqYu-5OWQcHs22aeEJw0tSjVNhgpMCj_ctH+Ldg@mail.gmail.com> <CAJQfnxGOcALAOGQb57bMKfU9qe1jBKXFgnPJhHcoVtSGaVk0zQ@mail.gmail.com>
In-Reply-To: <CAJQfnxGOcALAOGQb57bMKfU9qe1jBKXFgnPJhHcoVtSGaVk0zQ@mail.gmail.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Thu, 11 Aug 2022 10:20:56 -0700
Message-ID: <CABBYNZJhGgwOSGAUWMcs_aP6uxx5XtTXp2nx_7mobS=vQKt+wQ@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: Honor name resolve evt regardless of discov state
To:     Archie Pusaka <apusaka@google.com>
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Ying Hsu <yinghsu@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_FILL_THIS_FORM_SHORT,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Archie,

On Thu, Aug 11, 2022 at 12:00 AM Archie Pusaka <apusaka@google.com> wrote:
>
> Hi Luiz,
>
> On Thu, 11 Aug 2022 at 03:58, Luiz Augusto von Dentz
> <luiz.dentz@gmail.com> wrote:
> >
> > Hi Archie,
> >
> > On Wed, Aug 10, 2022 at 1:47 AM Archie Pusaka <apusaka@google.com> wrote:
> > >
> > > From: Archie Pusaka <apusaka@chromium.org>
> > >
> > > Currently, we don't update the name resolving cache when receiving
> > > a name resolve event if the discovery phase is not in the resolving
> > > stage.
> > >
> > > However, if the user connect to a device while we are still resolving
> > > remote name for another device, discovery will be stopped, and because
> > > we are no longer in the discovery resolving phase, the corresponding
> > > remote name event will be ignored, and thus the device being resolved
> > > will stuck in NAME_PENDING state.
> > >
> > > If discovery is then restarted and then stopped, this will cause us to
> > > try cancelling the name resolve of the same device again, which is
> > > incorrect and might upset the controller.
> >
> > Please add the Fixes tag.
>
> Unfortunately I don't know when was the issue introduced, I don't even
> know whether this is a recent issue or an old one.
> Looking back, this part of the code has stayed this way since 2012.
> Do I still need to add the fixes tag? If so, does it have to be accurate?

Hmm I thought this was related to some recent changes of RNR, we will
need to trace back with git blame, note it important to have the fixes
tag so we can add this change to stable kernels and if that is really
since 2012 that have this bug it probably even more important since it
might be applied to more stable versions.

> >
> > > Signed-off-by: Archie Pusaka <apusaka@chromium.org>
> > > Reviewed-by: Ying Hsu <yinghsu@chromium.org>
> > >
> > > ---
> > > The following steps are performed:
> > >     (1) Prepare 2 classic peer devices that needs RNR. Put device A
> > >         closer to DUT and device B (much) farther from DUT.
> > >     (2) Remove all cache and previous connection from DUT
> > >     (3) Put both peers into pairing mode, then start scanning on DUT
> > >     (4) After ~8 sec, turn off peer B.
> > >     *This is done so DUT can discover peer B (discovery time is 10s),
> > >     but it hasn't started RNR. Peer is turned off to buy us the max
> > >     time in the RNR phase (5s).
> > >     (5) Immediately as device A is shown on UI, click to connect.
> > >     *We thus know that the DUT is in the RNR phase and trying to
> > >     resolve the name of peer B when we initiate connection to peer A.
> > >     (6) Forget peer A.
> > >     (7) Restart scan and stop scan.
> > >     *Before the CL, stop scan is broken because we will try to cancel
> > >     a nonexistent RNR
> > >     (8) Restart scan again. Observe DUT can scan normally.
> > >
> > >
> > >  net/bluetooth/hci_event.c | 17 ++++++++++-------
> > >  1 file changed, 10 insertions(+), 7 deletions(-)
> > >
> > > diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> > > index 395c6479456f..95e145e278c9 100644
> > > --- a/net/bluetooth/hci_event.c
> > > +++ b/net/bluetooth/hci_event.c
> > > @@ -2453,6 +2453,16 @@ static void hci_check_pending_name(struct hci_dev *hdev, struct hci_conn *conn,
> > >             !test_and_set_bit(HCI_CONN_MGMT_CONNECTED, &conn->flags))
> > >                 mgmt_device_connected(hdev, conn, name, name_len);
> > >
> > > +       e = hci_inquiry_cache_lookup_resolve(hdev, bdaddr, NAME_PENDING);
> > > +
> > > +       if (e) {
> > > +               list_del(&e->list);
> > > +
> > > +               e->name_state = name ? NAME_KNOWN : NAME_NOT_KNOWN;
> > > +               mgmt_remote_name(hdev, bdaddr, ACL_LINK, 0x00, e->data.rssi,
> > > +                                name, name_len);
> > > +       }
> > > +
> > >         if (discov->state == DISCOVERY_STOPPED)
> > >                 return;
> > >
> > > @@ -2462,7 +2472,6 @@ static void hci_check_pending_name(struct hci_dev *hdev, struct hci_conn *conn,
> > >         if (discov->state != DISCOVERY_RESOLVING)
> > >                 return;
> > >
> > > -       e = hci_inquiry_cache_lookup_resolve(hdev, bdaddr, NAME_PENDING);
> > >         /* If the device was not found in a list of found devices names of which
> > >          * are pending. there is no need to continue resolving a next name as it
> > >          * will be done upon receiving another Remote Name Request Complete
> > > @@ -2470,12 +2479,6 @@ static void hci_check_pending_name(struct hci_dev *hdev, struct hci_conn *conn,
> > >         if (!e)
> > >                 return;
> > >
> > > -       list_del(&e->list);
> > > -
> > > -       e->name_state = name ? NAME_KNOWN : NAME_NOT_KNOWN;
> > > -       mgmt_remote_name(hdev, bdaddr, ACL_LINK, 0x00, e->data.rssi,
> > > -                        name, name_len);
> > > -
> > >         if (hci_resolve_next_name(hdev))
> > >                 return;
> > >
> > > --
> > > 2.37.1.595.g718a3a8f04-goog
> > >
> >
> >
> > --
> > Luiz Augusto von Dentz
>
> Thanks,
> Archie



-- 
Luiz Augusto von Dentz
