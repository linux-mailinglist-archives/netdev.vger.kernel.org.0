Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04E8C49683D
	for <lists+netdev@lfdr.de>; Sat, 22 Jan 2022 00:32:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbiAUXck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 18:32:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiAUXcj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 18:32:39 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2E8BC06173B;
        Fri, 21 Jan 2022 15:32:39 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id k31so30308685ybj.4;
        Fri, 21 Jan 2022 15:32:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Zwd3APv0ADJGys6CshiGviZTyi6AcGSoKvHQ54dgGEA=;
        b=EOa8041Fkz0j3IiE0wwKPL+IP3Wmii2yHtwUp5V1b6q6hIlFPaqqd+7yVkubi28yaW
         uAJaAW4pojC3HzwGX+0ki2Jz33O3jzlKjs7WyhED/uB73Bdy89SF/1FlwyUWr6ckex+q
         Pr1LFoeMZh2phlgSGURSargwyPivOtN6jpT2Uk5rr2+79bBuMEcA3cICf9+xeAZGl1zJ
         Nwl/Tj1CXJEQ3sEQY1Q2tE2kHUS3bbOP6BOr+ToAGQy4X52rHoBWqDeRFUTtpm0U0VHI
         DmFbFZ9NRi1f+i/ux8ENZv8KroynjmztIDbqKt30Nv/pbcOaz/Z+iOHaxuii+VXK2HrF
         GKRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Zwd3APv0ADJGys6CshiGviZTyi6AcGSoKvHQ54dgGEA=;
        b=GxznCVyW2oi5B9WEromzmk3uwQjw+Td50IRa0OCLwhjhUIk38iiSZcPBakwi48CgIk
         VVvQGx8q1R1BKYeaybgJeCqQj8wcHktJkCC0AbGEJVfN67UP1DdnmvOr5G+DERJ19lvg
         kLd3psvEMs2lGctoPyDU2Uyzk74ZXb0RnHXdRmnFdxyWXnrv+cKsGSklmvPN4/SclafR
         H8j0nUm5kL75xKrIupAMW/3oc0GHNtAyP8pf9qp5HwuG5dI8X1/qBSgF/AV74eUmAz4K
         Sr8nt5cNXBuncBXSNxUaxBlbL62Ha2CGeuPdktZkIjWO8ERVbnD993uIy7yPN7QYWLg1
         yhKg==
X-Gm-Message-State: AOAM531WKSTCXSYQUsbEdXXOf+swyTD/qsuAnC4q6Qd3B67jQGyM/I5v
        n+TDsdax0xXZOs9ewSZcv7sUIL8CHVNXe5gN7mE=
X-Google-Smtp-Source: ABdhPJzaYYbLUA+61242B7I5At2uPodx32WJVr/GOILh26xEZC1kNbyKF3Gm0gWTDBBH4lcD4lAI4x/KqqAE56HbK34=
X-Received: by 2002:a5b:14a:: with SMTP id c10mr9033025ybp.752.1642807958777;
 Fri, 21 Jan 2022 15:32:38 -0800 (PST)
MIME-Version: 1.0
References: <20220121173622.192744-1-soenke.huster@eknoes.de>
 <4f3d6dcf-c142-9a99-df97-6190c8f2abc9@eknoes.de> <CABBYNZ+VQ3Gfw0n=PavFhnnOy2=+1OAeV5UT_S25Lz_4gWzWEQ@mail.gmail.com>
 <995e58bb-6dfb-b3db-c8a5-b9e30dbb104d@eknoes.de>
In-Reply-To: <995e58bb-6dfb-b3db-c8a5-b9e30dbb104d@eknoes.de>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Fri, 21 Jan 2022 15:32:28 -0800
Message-ID: <CABBYNZJx+UzHLRA8o=z-fkiHAmBJ6-WtY35eJtD6C6N6PhLbDQ@mail.gmail.com>
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

On Fri, Jan 21, 2022 at 3:18 PM S=C3=B6nke Huster <soenke.huster@eknoes.de>=
 wrote:
>
> Hi Luiz,
>
> On 21.01.22 22:31, Luiz Augusto von Dentz wrote:
> > Hi S=C3=B6nke,
> >
> > On Fri, Jan 21, 2022 at 10:22 AM S=C3=B6nke Huster <soenke.huster@eknoe=
s.de> wrote:
> >>
> >> I just noticed that just checking for handle does not work, as obvious=
ly 0x0 could also be a handle value and therefore it can't be distinguished=
, whether it is not set yet or it is 0x0.
> >
> > Yep, we should probably check its state, check for state !=3D BT_OPEN
> > since that is what hci_conn_add initialize the state.
> >
>
> I thought there are more valid connection states for the first HCI_CONNEC=
TION_COMPLETE event, as it also occurs e.g. after an HCI_Create_Connection =
command, see Core 5.3 p.2170:
> > This event also indicates to the Host which issued the HCI_Create_Conne=
ction, HCI_Accept_-
> > Connection_Request, or HCI_Reject_Connection_Request command, and
> > then received an HCI_Command_Status event, if the issued command failed=
 or
> > was successful.
>
> For example in hci_conn.c hci_acl_create_connection (which triggers a HCI=
_Create_Connection command as far as I understand), the state of the connec=
tion is changed to BT_CONNECT or BT_CONNECT2.
> But as I am quite new in the (Linux) Bluetooth world, I might have a wron=
g understanding of that.

Yep, we would probably need a switch to capture which states are valid
and which are not or we initialize the handle with something outside
of the valid range of handles (0x0000 to 0x0EFF) so we can initialize
it to e.g. 0xffff (using something like define HCI_CONN_HANDLE_UNSET)
so we can really tell when it has been set or not.

> >> On 21.01.22 18:36, Soenke Huster wrote:
> >>> When a HCI_CONNECTION_COMPLETE event is received multiple times
> >>> for the same handle, the device is registered multiple times which le=
ads
> >>> to memory corruptions. Therefore, consequent events for a single
> >>> connection are ignored.
> >>>
> >>> The conn->state can hold different values so conn->handle is
> >>> checked to detect whether a connection is already set up.
> >>>
> >>> Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=3D215497
> >>> Signed-off-by: Soenke Huster <soenke.huster@eknoes.de>
> >>> ---
> >>> This fixes the referenced bug and several use-after-free issues I dis=
covered.
> >>> I tagged it as RFC, as I am not 100% sure if checking the existence o=
f the
> >>> handle is the correct approach, but to the best of my knowledge it mu=
st be
> >>> set for the first time in this function for valid connections of this=
 event,
> >>> therefore it should be fine.
> >>>
> >>> net/bluetooth/hci_event.c | 11 +++++++++++
> >>>  1 file changed, 11 insertions(+)
> >>>
> >>> diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> >>> index 681c623aa380..71ccb12c928d 100644
> >>> --- a/net/bluetooth/hci_event.c
> >>> +++ b/net/bluetooth/hci_event.c
> >>> @@ -3106,6 +3106,17 @@ static void hci_conn_complete_evt(struct hci_d=
ev *hdev, void *data,
> >>>               }
> >>>       }
> >>>
> >>> +     /* The HCI_Connection_Complete event is only sent once per conn=
ection.
> >>> +      * Processing it more than once per connection can corrupt kern=
el memory.
> >>> +      *
> >>> +      * As the connection handle is set here for the first time, it =
indicates
> >>> +      * whether the connection is already set up.
> >>> +      */
> >>> +     if (conn->handle) {
> >>> +             bt_dev_err(hdev, "Ignoring HCI_Connection_Complete for =
existing connection");
> >>> +             goto unlock;
> >>> +     }
> >>> +
> >>>       if (!ev->status) {
> >>>               conn->handle =3D __le16_to_cpu(ev->handle);
> >>>
> >
> >
> >
>
> Best
> S=C3=B6nke



--=20
Luiz Augusto von Dentz
