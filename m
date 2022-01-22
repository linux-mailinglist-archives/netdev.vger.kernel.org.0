Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC4B349687E
	for <lists+netdev@lfdr.de>; Sat, 22 Jan 2022 01:07:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbiAVAHF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 19:07:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbiAVAHE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 19:07:04 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F91C06173B;
        Fri, 21 Jan 2022 16:07:04 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id 23so31995625ybf.7;
        Fri, 21 Jan 2022 16:07:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tqvQucpiteOKFF3jKzFr/dI6vHgqq1WKbdfX3lgR7Sc=;
        b=ghhwdTauQ42Av9X0kL6/nDCzJJx4n9hr4D644wQkKWgCYsdT9xzFnJxz9RoGy7zbom
         /g8cWs0hyRlKmo6VgRTzmowKuX9Rl0SRJxoYbvPyuAN36VBcQmL5AH6czvqaVWzMl/w5
         hb/wmzlI3hPRCt1xhwiaqUgOkTyJi0Ffsq4RBMY4vZUL7+mXcM2oKWM/GK6NEyVw6dL8
         ZoVRDwOEUFdsTpZW1VoXyn357cQxNdLgXm+hnFkemUKzog183ut2jVVQGYqSvTi/DOoe
         l8yKCQOpQ8YSdNhsb1La6AZ11PZFExrB7E4uOlafTcJ1ph7M2zv56g/jffid298+om81
         JRDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tqvQucpiteOKFF3jKzFr/dI6vHgqq1WKbdfX3lgR7Sc=;
        b=Jv9X3ZcGSICpKYuvjWYYMsUsRMcb4E56RKCVf9Bxb6AVHOZTFYLaosba9HVuZELBEz
         l07zebygM2L9AGuAcWm69akSz1P9GA9SzuzuQcKjLGDq2sjYGz63HiieGGvjDsaGoL4j
         uPIABaEiCraoiKw4iKBLXbHkkm2paayWIR0ix9hDf1gCADzI/fyLVUUWU9QIC5AwhsLA
         WiCtg2ETW/nce538Cm0APQGNfokysI32V3JTS9s2ZALtsSNKvgEq6dauqxnm+yRJ1Xvj
         wXdPydrx/zbb46dRME9b/0GMVqP5zofJgstZJo5hv2TqhLCPKmj4mmv+LecYOHF7o5e/
         teLQ==
X-Gm-Message-State: AOAM530xwijLFPN08chOuA1Md1Nih6oEeVfO68alzG54Nr9ZlveJeAfw
        /D62oj4lCcIJnLVUtFWX3wrpETiWNMA8DGP26Q4=
X-Google-Smtp-Source: ABdhPJx0Hf8esElMoynhKS7Jy/KJeKbM67UP0p1vuJUdopVsaWaRma/41Dn82w5Wh6lFdL8vdTZOKwkdJKvyH8llFCo=
X-Received: by 2002:a25:c41:: with SMTP id 62mr9429796ybm.284.1642810023288;
 Fri, 21 Jan 2022 16:07:03 -0800 (PST)
MIME-Version: 1.0
References: <20220121173622.192744-1-soenke.huster@eknoes.de>
 <4f3d6dcf-c142-9a99-df97-6190c8f2abc9@eknoes.de> <CABBYNZ+VQ3Gfw0n=PavFhnnOy2=+1OAeV5UT_S25Lz_4gWzWEQ@mail.gmail.com>
 <995e58bb-6dfb-b3db-c8a5-b9e30dbb104d@eknoes.de> <CABBYNZJx+UzHLRA8o=z-fkiHAmBJ6-WtY35eJtD6C6N6PhLbDQ@mail.gmail.com>
 <5d83dba0-2283-ef9d-e8f7-82e6628d4263@eknoes.de>
In-Reply-To: <5d83dba0-2283-ef9d-e8f7-82e6628d4263@eknoes.de>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Fri, 21 Jan 2022 16:06:52 -0800
Message-ID: <CABBYNZK+Auenk69sG918XruTSgGxupTFngMF-KXoHqBsgZGtFw@mail.gmail.com>
Subject: Re: [RFC PATCH] Bluetooth: hci_event: Ignore multiple conn complete events
To:     =?UTF-8?Q?S=C3=B6nke_Huster?= <soenke.huster@eknoes.de>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi S=C3=B6nke,

On Fri, Jan 21, 2022 at 3:52 PM S=C3=B6nke Huster <soenke.huster@eknoes.de>=
 wrote:
>
> Hi Luiz,
>
> On 22.01.22 00:32, Luiz Augusto von Dentz wrote:
> > Hi S=C3=B6nke,
> >
> > On Fri, Jan 21, 2022 at 3:18 PM S=C3=B6nke Huster <soenke.huster@eknoes=
.de> wrote:
> >>
> >> Hi Luiz,
> >>
> >> On 21.01.22 22:31, Luiz Augusto von Dentz wrote:
> >>> Hi S=C3=B6nke,
> >>>
> >>> On Fri, Jan 21, 2022 at 10:22 AM S=C3=B6nke Huster <soenke.huster@ekn=
oes.de> wrote:
> >>>>
> >>>> I just noticed that just checking for handle does not work, as obvio=
usly 0x0 could also be a handle value and therefore it can't be distinguish=
ed, whether it is not set yet or it is 0x0.
> >>>
> >>> Yep, we should probably check its state, check for state !=3D BT_OPEN
> >>> since that is what hci_conn_add initialize the state.
> >>>
> >>
> >> I thought there are more valid connection states for the first HCI_CON=
NECTION_COMPLETE event, as it also occurs e.g. after an HCI_Create_Connecti=
on command, see Core 5.3 p.2170:
> >>> This event also indicates to the Host which issued the HCI_Create_Con=
nection, HCI_Accept_-
> >>> Connection_Request, or HCI_Reject_Connection_Request command, and
> >>> then received an HCI_Command_Status event, if the issued command fail=
ed or
> >>> was successful.
> >>
> >> For example in hci_conn.c hci_acl_create_connection (which triggers a =
HCI_Create_Connection command as far as I understand), the state of the con=
nection is changed to BT_CONNECT or BT_CONNECT2.
> >> But as I am quite new in the (Linux) Bluetooth world, I might have a w=
rong understanding of that.
> >
> > Yep, we would probably need a switch to capture which states are valid
> > and which are not or we initialize the handle with something outside
> > of the valid range of handles (0x0000 to 0x0EFF) so we can initialize
> > it to e.g. 0xffff (using something like define HCI_CONN_HANDLE_UNSET)
> > so we can really tell when it has been set or not.
> >
>
> I think the state switch is just possible if there is no possibility
> to change a connection state back into one of the accepted states.
> Unless changing the state back into an accepted state includes a call
> to "hci_conn_del_sysfs", as the real issue when getting a duplicate
> HCI_Create_Connection event is that device_add in hci_conn_add_sysfs
> is called twice for the same connection.
>
> There might be other issues as well in processing a duplicate event,
> but as far as I can see the bugs I trigger rely on multiple calls to
> device_add which lead in the long run to multiple user-after frees
> or null-pointer derefs. I tried to write that up in the bugzilla report
> here: https://bugzilla.kernel.org/show_bug.cgi?id=3D215497
>
>
> When using something like HCI_CONN_HANDLE_UNSET, we need to make sure
> that everywhere where we receive a handle from an event and use it to
> set conn->handle, it is a valid one. Otherwise a hacked / malicious
> controller would just send multiple events for the invalid handle.

Well that is already the case for 0x0000, so one can in fact already
abuse such a thing, so yes we probably should check if the received
handle is within the valid range or not.

> What solution do you prefer? If you don't mind I'd like to try to
> create a patch.

I'd start by initializing the conn->handle to 0xffff and add checks
for it later we can add checks for received handle as well.

> >>>> On 21.01.22 18:36, Soenke Huster wrote:
> >>>>> When a HCI_CONNECTION_COMPLETE event is received multiple times
> >>>>> for the same handle, the device is registered multiple times which =
leads
> >>>>> to memory corruptions. Therefore, consequent events for a single
> >>>>> connection are ignored.
> >>>>>
> >>>>> The conn->state can hold different values so conn->handle is
> >>>>> checked to detect whether a connection is already set up.
> >>>>>
> >>>>> Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=3D215497
> >>>>> Signed-off-by: Soenke Huster <soenke.huster@eknoes.de>
> >>>>> ---
> >>>>> This fixes the referenced bug and several use-after-free issues I d=
iscovered.
> >>>>> I tagged it as RFC, as I am not 100% sure if checking the existence=
 of the
> >>>>> handle is the correct approach, but to the best of my knowledge it =
must be
> >>>>> set for the first time in this function for valid connections of th=
is event,
> >>>>> therefore it should be fine.
> >>>>>
> >>>>> net/bluetooth/hci_event.c | 11 +++++++++++
> >>>>>  1 file changed, 11 insertions(+)
> >>>>>
> >>>>> diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> >>>>> index 681c623aa380..71ccb12c928d 100644
> >>>>> --- a/net/bluetooth/hci_event.c
> >>>>> +++ b/net/bluetooth/hci_event.c
> >>>>> @@ -3106,6 +3106,17 @@ static void hci_conn_complete_evt(struct hci=
_dev *hdev, void *data,
> >>>>>               }
> >>>>>       }
> >>>>>
> >>>>> +     /* The HCI_Connection_Complete event is only sent once per co=
nnection.
> >>>>> +      * Processing it more than once per connection can corrupt ke=
rnel memory.
> >>>>> +      *
> >>>>> +      * As the connection handle is set here for the first time, i=
t indicates
> >>>>> +      * whether the connection is already set up.
> >>>>> +      */
> >>>>> +     if (conn->handle) {
> >>>>> +             bt_dev_err(hdev, "Ignoring HCI_Connection_Complete fo=
r existing connection");
> >>>>> +             goto unlock;
> >>>>> +     }
> >>>>> +
> >>>>>       if (!ev->status) {
> >>>>>               conn->handle =3D __le16_to_cpu(ev->handle);
> >>>>>
> >>>
> >>>
> >>>
> >>
> >> Best
> >> S=C3=B6nke
> >
> >
> >



--=20
Luiz Augusto von Dentz
