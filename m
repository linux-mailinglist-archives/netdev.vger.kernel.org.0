Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FFF319E167
	for <lists+netdev@lfdr.de>; Sat,  4 Apr 2020 01:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728776AbgDCXTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 19:19:05 -0400
Received: from mail-il1-f195.google.com ([209.85.166.195]:36974 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727958AbgDCXTF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 19:19:05 -0400
Received: by mail-il1-f195.google.com with SMTP id a6so9090915ilr.4;
        Fri, 03 Apr 2020 16:19:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=dPU5rDbRXNZR3mGxrVtgTT7qKCNIJzL3wX4Y2kmnrAI=;
        b=PnH4HwG48u1Ut+Ivho3hvvqb5bhaAn4hSi8EHYGucTzs1wkC3b4hv1g19ShqB9AOhX
         URcN/2rsL80NiwAX3sTZFmaeuvHiVq+d5ouj5aV6lBlZ7SuAG4GGoaKg6dp4hL1tqiQr
         VdyMqjf0lOFut5bLlrm/v8h3QdrXjW/N9csK77csL48LcAj6JKr/GptmX9+9rgj7FQ3T
         Mw58AU2tiMh7G56Pq7HU4egpWgB4YyFIcZNoBEClZfga29RMkKiCNOdajMHsheKPfEZ5
         9t5bvKmj/oq9x3AwpXm5ysdVgBEUwxYsgg6fZ9xrf9S06kevIdf2Mv1KO5kfaByVFZI4
         fNhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dPU5rDbRXNZR3mGxrVtgTT7qKCNIJzL3wX4Y2kmnrAI=;
        b=FbooZicPc+RoVA6ckCkh1Bhjj7q9HSPrdDoa92x2idgKAei4tBOFMCBBFU1w47OZMR
         4rTaQwV2+7typtiVkeC5X2+1k50lwF8Fe5JccR1+7HLe6GYF2FzgJvng3ZBCo3tNmBI5
         5KfXyzaE/T1445YAPpSwr6hK9cOxsnxzEWaz+xtA5/uwnh2nZ4pe8qJj4np5aylN5HUi
         5xwewXn3F+82tLfERvpraQIu8MJ5YbUdsIO4LglNE+oCDMMjS+cMTAQ6Jw94Db05k4LJ
         F39ZXeVzAhxJ0n7QfTUS8alVZG3lVwwm61n88To8+BbGAZArikOt8qnbtRgl50Ckb9b7
         4y2A==
X-Gm-Message-State: AGi0PuZMWLmtbV0CYzFnUpSlMIv+cqCvvviS5SbE7CePpyZZVuPfumMN
        WHJZXLlJLTVOo/osAFRibMx/AJptwQo8gmkN1y0=
X-Google-Smtp-Source: APiQypJH2cfMpfCnPZK+pA8s6rPIi/FSJMp/KP8TFfCWVsLY5vUTwL1Z/RTjJEpywJNpHvOm4Rhvp5j8LzkY7e9bcu0=
X-Received: by 2002:a92:cf52:: with SMTP id c18mr10652807ilr.246.1585955944184;
 Fri, 03 Apr 2020 16:19:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200323194507.90944-1-abhishekpandit@chromium.org>
 <20200323124503.v3.1.I17e2220fd0c0822c76a15ef89b882fb4cfe3fe89@changeid>
 <7FD50BDC-A4B5-4ED9-8DAB-887039735800@holtmann.org> <CANFp7mX=LvTzttCHcb14TRF8YukQt_WdMpYzJP5LP_ZXwzQTsQ@mail.gmail.com>
In-Reply-To: <CANFp7mX=LvTzttCHcb14TRF8YukQt_WdMpYzJP5LP_ZXwzQTsQ@mail.gmail.com>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Fri, 3 Apr 2020 16:18:53 -0700
Message-ID: <CAA93jw5aSU6H=9yvtfXTDg1V_MXi42KNJ0imTiwFx6dLjBtBtg@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] Bluetooth: Prioritize SCO traffic
To:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Bluetooth Kernel Mailing List 
        <linux-bluetooth@vger.kernel.org>,
        ChromeOS Bluetooth Upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 3, 2020 at 11:11 AM Abhishek Pandit-Subedi
<abhishekpandit@chromium.org> wrote:
>
> Hi Marcel,
>
> Thanks for merging.
>
> I agree that the distinction between SCO/eSCO and ACL/LE is a bit
> concerning for scheduling. I will make some time to revisit this as
> part of Audio improvements we are making.

A) I know nothing of bluetooth.
B) I am unfond of strict priority queues, as they can cause
starvation. My immediate instinct is to reach for a drr++ derived
solution
to give fairness to all flows, and a bit of priority to the ones that
matter most.


>
> Thanks
> Abhishek
>
> Abhishek
>
> On Thu, Apr 2, 2020 at 11:56 PM Marcel Holtmann <marcel@holtmann.org> wro=
te:
> >
> > Hi Abhishek,
> >
> > > When scheduling TX packets, send all SCO/eSCO packets first, check fo=
r
> > > pending SCO/eSCO packets after every ACL/LE packet and send them if a=
ny
> > > are pending.  This is done to make sure that we can meet SCO deadline=
s
> > > on slow interfaces like UART.
> > >
> > > If we were to queue up multiple ACL packets without checking for a SC=
O
> > > packet, we might miss the SCO timing. For example:
> > >
> > > The time it takes to send a maximum size ACL packet (1024 bytes):
> > > t =3D 10/8 * 1024 bytes * 8 bits/byte * 1 packet / baudrate
> > >        where 10/8 is uart overhead due to start/stop bits per byte
> > >
> > > Replace t =3D 3.75ms (SCO deadline), which gives us a baudrate of 273=
0666.
> > >
> > > At a baudrate of 3000000, if we didn't check for SCO packets within 1=
024
> > > bytes, we would miss the 3.75ms timing window.
> > >
> > > Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> > > ---
> > >
> > > Changes in v3:
> > > * Removed hci_sched_sync
> > >
> > > Changes in v2:
> > > * Refactor to check for SCO/eSCO after each ACL/LE packet sent
> > > * Enabled SCO priority all the time and removed the sched_limit varia=
ble
> > >
> > > net/bluetooth/hci_core.c | 106 +++++++++++++++++++++-----------------=
-
> > > 1 file changed, 57 insertions(+), 49 deletions(-)
> >
> > patch has been applied to bluetooth-next tree.
> >
> > However I have been a bit reluctant to apply this right away. I think w=
hen this code was originally written, we only had ACL and SCO packets. The =
world was pretty simple. And right now we also only have two packets types =
(ignoring ISO packets for now), but we added LE and eSCO as separate schedu=
ling and thus =E2=80=9Cfake=E2=80=9D packet types.
> >
> > I have the feeling that this serialized packet processing will get us i=
nto trouble since we prioritize BR/EDR packets over LE packets and SCO over=
 eSCO. I think we should have looked at all packets based on SO_PRIORITY an=
d with ISO packets we have to most likely re-design this. Anyway, just some=
thing to think about.
> >
> > Regards
> >
> > Marcel
> >



--=20
Make Music, Not War

Dave T=C3=A4ht
CTO, TekLibre, LLC
http://www.teklibre.com
Tel: 1-831-435-0729
