Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB2B58F805
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 09:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234294AbiHKHBD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 03:01:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbiHKHBB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 03:01:01 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8FEF2E9FF
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 00:00:59 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id t5so21727789edc.11
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 00:00:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=yKDvXoGhE9VymIRDKMizOkf26gzFKmzaBxN+JMf4zI4=;
        b=AxOIZZxSoc1hopcnnY/21m/+c6rxeOHs52kXxFZyqZBceWeiFgm5M4QZkKcMc9e8D5
         46ReJ9JTXB+OOmjzum9P5eVtSB/4ua0/9uhL95ZnpB8ZqBkLuC7y1ojaKAb4G94wdHi0
         TeOHDmj2h2Z0iV9Sw2SqkZyKfnN7qdw3lOtZbKOsq5iDXDcd7QGUilkiDmA8OLpm+zm1
         m3ttiBeJnxpLccGAHKxhVD5UAK0aRt8ZvUDFXbxdZwyToEFcxOScJMBY/HE7RjX6xaQv
         hQ8I9vnb8jnpDdh8nm5LyPM6PogKmA0dVTF/oW74C0LYPjPMrNdBUOpuWckpXWRYY9LL
         yNBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=yKDvXoGhE9VymIRDKMizOkf26gzFKmzaBxN+JMf4zI4=;
        b=Pw6fIIzgyPC9hU9tmEsj7Qx7QIsqj94blOWBeABPLkrUbBtpfIxezvodTgLiTnWytK
         cAjGMWm1UZmIeBJ7TZ3NEaCuNP3K2vhKUarmWfzpCnLduZ1qFPhNR2N1u3tuPsCbd2XE
         /k7Zs4W0OHIwQg7HkyzBllhXEnGeuaIWrRKqymbt+FFiwf70zuhsM+HIIcLgRuLchQaC
         zOApigpykrMJIhIrn1kwhes6HFDZGtV3XmT3hU7qQGw/8nNPlcj+bHGKpMnuaMSWc+e0
         k1Y53VuRA6vG6V3aejId4VeL6ciapjUMm92nfWuOhGVoDRmAcGpClsWxbwsTTXPM/6la
         EUQQ==
X-Gm-Message-State: ACgBeo1fghqTyjO6enHIRAlLi/rnXweHXPEqy1NIJUaaBsPp3XYf6MGr
        FINXRMbqM8v1CAnWbHjUcOzMwUBV+bY/2CahEUwDJQ==
X-Google-Smtp-Source: AA6agR4w7AxtfaM+icnb6QzN8O86KTkJmMMhlE8wgH4bxszR76OfqhLG8jRW3DV7JdermkR/iMyEnb0pyk/hXZbrq9w=
X-Received: by 2002:a05:6402:d05:b0:425:b7ab:776e with SMTP id
 eb5-20020a0564020d0500b00425b7ab776emr30703741edb.142.1660201258017; Thu, 11
 Aug 2022 00:00:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220810164627.1.Id730b98f188a504d9835b96ddcbc83d49a70bb36@changeid>
 <CABBYNZLhhdKLqYu-5OWQcHs22aeEJw0tSjVNhgpMCj_ctH+Ldg@mail.gmail.com>
In-Reply-To: <CABBYNZLhhdKLqYu-5OWQcHs22aeEJw0tSjVNhgpMCj_ctH+Ldg@mail.gmail.com>
From:   Archie Pusaka <apusaka@google.com>
Date:   Thu, 11 Aug 2022 15:00:46 +0800
Message-ID: <CAJQfnxGOcALAOGQb57bMKfU9qe1jBKXFgnPJhHcoVtSGaVk0zQ@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: Honor name resolve evt regardless of discov state
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
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
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_FILL_THIS_FORM_SHORT,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Luiz,

On Thu, 11 Aug 2022 at 03:58, Luiz Augusto von Dentz
<luiz.dentz@gmail.com> wrote:
>
> Hi Archie,
>
> On Wed, Aug 10, 2022 at 1:47 AM Archie Pusaka <apusaka@google.com> wrote:
> >
> > From: Archie Pusaka <apusaka@chromium.org>
> >
> > Currently, we don't update the name resolving cache when receiving
> > a name resolve event if the discovery phase is not in the resolving
> > stage.
> >
> > However, if the user connect to a device while we are still resolving
> > remote name for another device, discovery will be stopped, and because
> > we are no longer in the discovery resolving phase, the corresponding
> > remote name event will be ignored, and thus the device being resolved
> > will stuck in NAME_PENDING state.
> >
> > If discovery is then restarted and then stopped, this will cause us to
> > try cancelling the name resolve of the same device again, which is
> > incorrect and might upset the controller.
>
> Please add the Fixes tag.

Unfortunately I don't know when was the issue introduced, I don't even
know whether this is a recent issue or an old one.
Looking back, this part of the code has stayed this way since 2012.
Do I still need to add the fixes tag? If so, does it have to be accurate?

>
> > Signed-off-by: Archie Pusaka <apusaka@chromium.org>
> > Reviewed-by: Ying Hsu <yinghsu@chromium.org>
> >
> > ---
> > The following steps are performed:
> >     (1) Prepare 2 classic peer devices that needs RNR. Put device A
> >         closer to DUT and device B (much) farther from DUT.
> >     (2) Remove all cache and previous connection from DUT
> >     (3) Put both peers into pairing mode, then start scanning on DUT
> >     (4) After ~8 sec, turn off peer B.
> >     *This is done so DUT can discover peer B (discovery time is 10s),
> >     but it hasn't started RNR. Peer is turned off to buy us the max
> >     time in the RNR phase (5s).
> >     (5) Immediately as device A is shown on UI, click to connect.
> >     *We thus know that the DUT is in the RNR phase and trying to
> >     resolve the name of peer B when we initiate connection to peer A.
> >     (6) Forget peer A.
> >     (7) Restart scan and stop scan.
> >     *Before the CL, stop scan is broken because we will try to cancel
> >     a nonexistent RNR
> >     (8) Restart scan again. Observe DUT can scan normally.
> >
> >
> >  net/bluetooth/hci_event.c | 17 ++++++++++-------
> >  1 file changed, 10 insertions(+), 7 deletions(-)
> >
> > diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> > index 395c6479456f..95e145e278c9 100644
> > --- a/net/bluetooth/hci_event.c
> > +++ b/net/bluetooth/hci_event.c
> > @@ -2453,6 +2453,16 @@ static void hci_check_pending_name(struct hci_dev *hdev, struct hci_conn *conn,
> >             !test_and_set_bit(HCI_CONN_MGMT_CONNECTED, &conn->flags))
> >                 mgmt_device_connected(hdev, conn, name, name_len);
> >
> > +       e = hci_inquiry_cache_lookup_resolve(hdev, bdaddr, NAME_PENDING);
> > +
> > +       if (e) {
> > +               list_del(&e->list);
> > +
> > +               e->name_state = name ? NAME_KNOWN : NAME_NOT_KNOWN;
> > +               mgmt_remote_name(hdev, bdaddr, ACL_LINK, 0x00, e->data.rssi,
> > +                                name, name_len);
> > +       }
> > +
> >         if (discov->state == DISCOVERY_STOPPED)
> >                 return;
> >
> > @@ -2462,7 +2472,6 @@ static void hci_check_pending_name(struct hci_dev *hdev, struct hci_conn *conn,
> >         if (discov->state != DISCOVERY_RESOLVING)
> >                 return;
> >
> > -       e = hci_inquiry_cache_lookup_resolve(hdev, bdaddr, NAME_PENDING);
> >         /* If the device was not found in a list of found devices names of which
> >          * are pending. there is no need to continue resolving a next name as it
> >          * will be done upon receiving another Remote Name Request Complete
> > @@ -2470,12 +2479,6 @@ static void hci_check_pending_name(struct hci_dev *hdev, struct hci_conn *conn,
> >         if (!e)
> >                 return;
> >
> > -       list_del(&e->list);
> > -
> > -       e->name_state = name ? NAME_KNOWN : NAME_NOT_KNOWN;
> > -       mgmt_remote_name(hdev, bdaddr, ACL_LINK, 0x00, e->data.rssi,
> > -                        name, name_len);
> > -
> >         if (hci_resolve_next_name(hdev))
> >                 return;
> >
> > --
> > 2.37.1.595.g718a3a8f04-goog
> >
>
>
> --
> Luiz Augusto von Dentz

Thanks,
Archie
