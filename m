Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AABF43F38E
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 01:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231569AbhJ1Xo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 19:44:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231629AbhJ1XoT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 19:44:19 -0400
Received: from mail-vk1-xa2d.google.com (mail-vk1-xa2d.google.com [IPv6:2607:f8b0:4864:20::a2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D19C061570;
        Thu, 28 Oct 2021 16:41:52 -0700 (PDT)
Received: by mail-vk1-xa2d.google.com with SMTP id b125so2980249vkb.9;
        Thu, 28 Oct 2021 16:41:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=lHyIAqdhwSRafGdxmTq1LL8yu8Med/Bc9fE/yN2WEi4=;
        b=Ggf+i3OlLdWhwUQ1OL8tTTT8mKTvXNPZ//Glu/oWJCTqD4Tt/b7sCnOq9X3ykS0B2j
         WWxqsrmyeV5TCeRiptd86ef5l8qL2a5MT1eWEjtl8J1NLsjxxPvI8rrEhTisJuqD2X00
         O56B/A68n4AIbtLQmZ/go+Oeh7WB4ss4G1RiLF2nQKgeLEfPxQPGzD3nk9p62fehdEJh
         wQYlZr8/L2yDFUTXLy2P8GpONcGWBmITCFpTVSqq9cYiRNAG98ZOVZqxvwdUZ4I5XArF
         0s2d55g3r0GpRLptpJjB269QTajCiseI7JuS4AOMy7oQCeC1v2Ejsfzpos39Jf1CKaqg
         js4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=lHyIAqdhwSRafGdxmTq1LL8yu8Med/Bc9fE/yN2WEi4=;
        b=v4sry6i6tphUlkrK5JBAwQztEtQtE9JGD/fRWOyjzISn3eOghzGbVY2835tA31nsm5
         rfonC258tcOWOr7tl35CG84INoykkKTwOfqMnEDdqvBAx/utiuXa5eUrD3JCzlhxjE09
         4Ba7P94+AajRG0yNTNE8J3I+UBr2yFB/1S6a0sW3VKWKUrT8QzPnyV+Pv5CNdFDck7kU
         xOWq+14fZpee5mDQfAUaZborOm+tTCqvkygLofr4hL+84QlBAb9NcLEnek6RNp5vin2H
         uPhSh/kw8uzISjqu88JL7eqRgWPgJCjpEiDsSV3GeKlxHqBYFbOjvHBlhEMS2UkOjv89
         yM8w==
X-Gm-Message-State: AOAM530kGx/U3I1/Ry3vzqQOGnXfYerN3IGmidEKFBofZ26P20xrwetb
        /e32XghdCYE0fvu4q/MdasQEuVj4MTlKjvPdkXU=
X-Google-Smtp-Source: ABdhPJwd5nR+eLG3z4UrUafUaQEotjFyukNPQ7xa6fn4xisWertrQ6OgjI9OqRCzKroXUmm/JxyH/FKZaCqvalZBeds=
X-Received: by 2002:ac5:c935:: with SMTP id u21mr8318716vkl.4.1635464511148;
 Thu, 28 Oct 2021 16:41:51 -0700 (PDT)
MIME-Version: 1.0
References: <20211028191805.1.I35b7f3a496f834de6b43a32f94b6160cb1467c94@changeid>
 <180B4F43-B60A-4326-A463-327645BA8F1B@holtmann.org>
In-Reply-To: <180B4F43-B60A-4326-A463-327645BA8F1B@holtmann.org>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Thu, 28 Oct 2021 16:41:40 -0700
Message-ID: <CABBYNZKpcXGD6=RrVRGiAtHM+cfKEOL=-_tER1ow_VPrm6fFhQ@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: Limit duration of Remote Name Resolve
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Archie Pusaka <apusaka@google.com>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marcel,

On Thu, Oct 28, 2021 at 6:30 AM Marcel Holtmann <marcel@holtmann.org> wrote=
:
>
> Hi Archie,
>
> > When doing remote name request, we cannot scan. In the normal case it's
> > OK since we can expect it to finish within a short amount of time.
> > However, there is a possibility to scan lots of devices that
> > (1) requires Remote Name Resolve
> > (2) is unresponsive to Remote Name Resolve
> > When this happens, we are stuck to do Remote Name Resolve until all is
> > done before continue scanning.
> >
> > This patch adds a time limit to stop us spending too long on remote
> > name request. The limit is increased for every iteration where we fail
> > to complete the RNR in order to eventually solve all names.
> >
> > Signed-off-by: Archie Pusaka <apusaka@chromium.org>
> > Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
> >
> > ---
> > Hi maintainers, we found one instance where a test device spends ~90
> > seconds to do Remote Name Resolving, hence this patch.
> > I think it's better if we reset the time limit to the default value
> > at some point, but I don't have a good proposal where to do that, so
> > in the end I didn't.
>
> do you have a btmon trace for this as well?
>
> The HCI Remote Name Request is essentially a paging procedure and then a =
few LMP messages. It is fundamentally a connection request inside BR/EDR an=
d if you have a remote device that has page scan disabled, but inquiry scan=
 enabled, then you get into this funky situation. Sadly, the BR/EDR parts d=
on=E2=80=99t give you any hint on this weird combination. You can't configu=
re BlueZ that way since it is really stupid setup and I remember that GAP d=
oesn=E2=80=99t have this case either, but it can happen. So we might want t=
o check if that is what happens. And of course it needs to be a Bluetooth 2=
.0 device or a device that doesn=E2=80=99t support Secure Simple Pairing. T=
here is a chance of really bad radio interference, but that is then just ba=
d luck and is only going to happen every once in a blue moon.

I wonder what does the remote sets as Page_Scan_Repetition_Mode in the
Inquiry Result, it seems quite weird that the specs allows such stage
but it doesn't have a value to represent in the inquiry result, anyway
I guess changing that now wouldn't really make any different given
such device is probably never gonna update.

> That said, you should receive a Page Timeout in the Remote Name Request C=
omplete event for what you describe. Or you just use HCI Remote Name Reques=
t Cancel to abort the paging. If I remember correctly then the setting for =
Page Timeout is also applied to Remote Name resolving procedure. So we coul=
d tweak that value. Actually once we get the =E2=80=9Csync=E2=80=9D work me=
rged, we could configure different Page Timeout for connection requests and=
 name resolving if that would help. Not sure if this is worth it, since we =
could as simple just cancel the request.

If I recall this correctly we used to have something like that back in
the days the daemon had control over the discovery, the logic was that
each round of discovery including the name resolving had a fixed time
e.g. 10 sec, so if not all device found had their name resolved we
would stop and proceed to the next round that way we avoid this
problem of devices not resolving and nothing being discovered either.
Luckily today there might not be many devices around without EIR
including their names but still I think it would be better to limit
the amount time we spend resolving names, also it looks like it sets
NAME_NOT_KNOWN when RNR fails and it never proceeds to request the
name again so I wonder why would it be waiting ~90 seconds, we don't
seem to change the page timeout so it should be using the default
which is 5.12s so I think there is something else at play.

Or perhaps it is finally time to drop legacy name resolution? At this
point they should be very rare and those keeping some ancient device
around will just have to deal with the address directly so we can get
rid of paging devices while discovery which is quite a big burden I'd
say.

>
> > include/net/bluetooth/hci_core.h |  5 +++++
> > net/bluetooth/hci_event.c        | 12 ++++++++++++
> > 2 files changed, 17 insertions(+)
> >
> > diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/h=
ci_core.h
> > index dd8840e70e25..df9ffedf1d29 100644
> > --- a/include/net/bluetooth/hci_core.h
> > +++ b/include/net/bluetooth/hci_core.h
> > @@ -87,6 +87,8 @@ struct discovery_state {
> >       u8                      (*uuids)[16];
> >       unsigned long           scan_start;
> >       unsigned long           scan_duration;
> > +     unsigned long           name_resolve_timeout;
> > +     unsigned long           name_resolve_duration;
> > };
> >
> > #define SUSPEND_NOTIFIER_TIMEOUT      msecs_to_jiffies(2000) /* 2 secon=
ds */
> > @@ -805,6 +807,8 @@ static inline void sco_recv_scodata(struct hci_conn=
 *hcon, struct sk_buff *skb)
> > #define INQUIRY_CACHE_AGE_MAX   (HZ*30)   /* 30 seconds */
> > #define INQUIRY_ENTRY_AGE_MAX   (HZ*60)   /* 60 seconds */
> >
> > +#define NAME_RESOLVE_INIT_DURATION   5120    /* msec */
> > +
> > static inline void discovery_init(struct hci_dev *hdev)
> > {
> >       hdev->discovery.state =3D DISCOVERY_STOPPED;
> > @@ -813,6 +817,7 @@ static inline void discovery_init(struct hci_dev *h=
dev)
> >       INIT_LIST_HEAD(&hdev->discovery.resolve);
> >       hdev->discovery.report_invalid_rssi =3D true;
> >       hdev->discovery.rssi =3D HCI_RSSI_INVALID;
> > +     hdev->discovery.name_resolve_duration =3D NAME_RESOLVE_INIT_DURAT=
ION;
> > }
> >
> > static inline void hci_discovery_filter_clear(struct hci_dev *hdev)
> > diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> > index 3cba2bbefcd6..104a1308f454 100644
> > --- a/net/bluetooth/hci_event.c
> > +++ b/net/bluetooth/hci_event.c
> > @@ -2086,6 +2086,15 @@ static bool hci_resolve_next_name(struct hci_dev=
 *hdev)
> >       if (list_empty(&discov->resolve))
> >               return false;
> >
> > +     /* We should stop if we already spent too much time resolving nam=
es.
> > +      * However, double the name resolve duration for the next iterati=
ons.
> > +      */
> > +     if (time_after(jiffies, discov->name_resolve_timeout)) {
> > +             bt_dev_dbg(hdev, "Name resolve takes too long, stopping."=
);
> > +             discov->name_resolve_duration *=3D 2;
> > +             return false;
> > +     }
> > +
> >       e =3D hci_inquiry_cache_lookup_resolve(hdev, BDADDR_ANY, NAME_NEE=
DED);
> >       if (!e)
> >               return false;
> > @@ -2634,6 +2643,9 @@ static void hci_inquiry_complete_evt(struct hci_d=
ev *hdev, struct sk_buff *skb)
> >       if (e && hci_resolve_name(hdev, e) =3D=3D 0) {
> >               e->name_state =3D NAME_PENDING;
> >               hci_discovery_set_state(hdev, DISCOVERY_RESOLVING);
> > +
> > +             discov->name_resolve_timeout =3D jiffies +
> > +                             msecs_to_jiffies(discov->name_resolve_dur=
ation);
>
> So if this is really caused by a device with page scan disabled and inqui=
ry scan enabled, then this fix is just a paper over hole approach. If you h=
ave more devices requiring name resolving, you end up penalizing them and m=
ake the discovery procedure worse up to the extend that no names are resolv=
ed. So I wouldn=E2=80=99t be in favor of this.
>
> What LE scan window/interval is actually working against what configured =
BR/EDR page timeout here? The discovery procedure is something that a user =
triggers so we always had that one take higher priority since the user is e=
xpecting results. This means any tweaking needs to be considered carefully =
since it is an immediate user impact if the name is missing.
>
> Is this a LE background scan you are worried about or an LE active scan t=
hat runs in parallel during discovery?
>
> Regards
>
> Marcel
>


--=20
Luiz Augusto von Dentz
