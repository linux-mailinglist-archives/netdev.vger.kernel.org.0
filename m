Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAF651459ED
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 17:32:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725970AbgAVQcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 11:32:14 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:36399 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbgAVQcO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 11:32:14 -0500
Received: by mail-lj1-f196.google.com with SMTP id r19so7542577ljg.3
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 08:32:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=PV8voRyQaKVLzunXykRLPQ9F83D+RbA3gYFSv9pmXAs=;
        b=ieKGAsUH1Qx8N0SSZyT5j0U3Eh5CCd33MNXNrbarwrPwi7Q5sbcMWpX9mg573OXAfg
         vm+C1WnkiUpGsnIbRNLhcuy2We+C6UxDex0lznJSw1aNdFYI+B63NdGTnvzaPIurCXg2
         90rdONLYvhDmLw9NHpOw9Zt0QwhO8Jgv0tu3AacrUOLXnacucXAGxfU/uOzoAq0MzZu+
         KQuZJJ5cHGvNBwwPj9JsI0SRFefgtG+Oo30drIJCw2MnfC9CymN/Bbzp02S/oRb1H63C
         IauFzh8+T7NZhRWrn0pUh0QcyjLFsVYmNZUAVa8XNkODataAOpbgboOQdPNqHyMJ1XQi
         TqLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PV8voRyQaKVLzunXykRLPQ9F83D+RbA3gYFSv9pmXAs=;
        b=rzit+ZB9jgXVLFwD0RRsSH99r3gEw9+ZXJXBxugh2U2ChMm63ysKAozVQaJBbcJCfn
         DTz5nFobQji+EuIxLre3p2AsWTcnXWn4JRaNQlNpZVi2tnTWZ4rEYS+P23v1wlGeGt2E
         vLwJTIaWyVFOQLDJ7QLJJpXXUYJzqKvDla8wworzwBCjItRkX5odbEEuH+7h/x+NC3lF
         Vc7uBrmk7hmhdt6Ox9Ds4tyVd+peua/7qX9A1VDYJSeEu5gvWQ8k4Vdr5t4l5iYiKEpl
         ydPk0GnKILO6pue4nP+j+JZnvoKeND6jnAdg08UY9FmcqGE/5wS3VCCCO8fDH3C0xV2c
         W+0g==
X-Gm-Message-State: APjAAAVBuQ5V6N49SdGvpFTyIXGnKfv0g6m8zK2IcxFaQAIxO1s/JCOB
        NO3IJdtT0PganiaOWj1N+rsZgrRNvwlsmf4PJtKutQ==
X-Google-Smtp-Source: APXvYqznREp7kxVYFSgA3ER2nyvAzXRFyv8qqEMkjHz0eKkTwYx6a2A7bxOk0hN+zZMNknEaQcE6OAy1s6zyjUHghOo=
X-Received: by 2002:a2e:94c8:: with SMTP id r8mr20507532ljh.28.1579710731473;
 Wed, 22 Jan 2020 08:32:11 -0800 (PST)
MIME-Version: 1.0
References: <20200117212705.57436-1-abhishekpandit@chromium.org>
 <20200117132623.RFC.1.I797e2f4cb824299043e771f3ab9cef86ee09f4db@changeid>
 <ACAE240C-345B-43F9-B6C8-8967AF436CE9@holtmann.org> <CANFp7mVjR9X=UjPZ5puX1z87NAeOBpvvQM8ASjijKAHz2+Uq8Q@mail.gmail.com>
In-Reply-To: <CANFp7mVjR9X=UjPZ5puX1z87NAeOBpvvQM8ASjijKAHz2+Uq8Q@mail.gmail.com>
From:   Alain Michaud <alainmichaud@google.com>
Date:   Wed, 22 Jan 2020 11:32:00 -0500
Message-ID: <CALWDO_Vp7YedFsxL=Sc4wj8ibghkwmWy5+8LGgspnoH3tMuL4Q@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] Bluetooth: Add mgmt op set_wake_capable
To:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Alain Michaud <alainm@chromium.org>,
        Bluez mailing list <linux-bluetooth@vger.kernel.org>,
        chromeos-bluetooth-upstreaming@chromium.org,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 21, 2020 at 6:31 PM Abhishek Pandit-Subedi
<abhishekpandit@chromium.org> wrote:
>
> On Tue, Jan 21, 2020 at 8:35 AM Marcel Holtmann <marcel@holtmann.org> wro=
te:
> >
> > Hi Abhishek,
> >
> > > When the system is suspended, only some connected Bluetooth devices
> > > cause user input that should wake the system (mostly HID devices). Ad=
d
> > > a list to keep track of devices that can wake the system and add
> > > a management API to let userspace tell the kernel whether a device is
> > > wake capable or not.
> > >
> > > Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> > > ---
> > >
> > > include/net/bluetooth/hci_core.h |  1 +
> > > include/net/bluetooth/mgmt.h     |  7 ++++++
> > > net/bluetooth/hci_core.c         |  1 +
> > > net/bluetooth/mgmt.c             | 42 +++++++++++++++++++++++++++++++=
+
> > > 4 files changed, 51 insertions(+)
> > >
> > > diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth=
/hci_core.h
> > > index 89ecf0a80aa1..ce4bebcb0265 100644
> > > --- a/include/net/bluetooth/hci_core.h
> > > +++ b/include/net/bluetooth/hci_core.h
> > > @@ -394,6 +394,7 @@ struct hci_dev {
> > >       struct list_head        mgmt_pending;
> > >       struct list_head        blacklist;
> > >       struct list_head        whitelist;
> > > +     struct list_head        wakeable;
> > >       struct list_head        uuids;
> > >       struct list_head        link_keys;
> > >       struct list_head        long_term_keys;
> > > diff --git a/include/net/bluetooth/mgmt.h b/include/net/bluetooth/mgm=
t.h
> > > index a90666af05bd..283ba5320bdb 100644
> > > --- a/include/net/bluetooth/mgmt.h
> > > +++ b/include/net/bluetooth/mgmt.h
> > > @@ -671,6 +671,13 @@ struct mgmt_cp_set_blocked_keys {
> > > } __packed;
> > > #define MGMT_OP_SET_BLOCKED_KEYS_SIZE 2
> > >
> > > +#define MGMT_OP_SET_WAKE_CAPABLE     0x0047
> > > +#define MGMT_SET_WAKE_CAPABLE_SIZE   8
> > > +struct mgmt_cp_set_wake_capable {
> > > +     struct mgmt_addr_info addr;
> > > +     u8 wake_capable;
> > > +} __packed;
> > > +
> >
> > please also send a patch for doc/mgmt-api.txt describing these opcodes.=
 I would also like to have the discussion if it might be better to add an e=
xtra Action parameter to Add Device. We want to differentiate between allow=
 incoming connection that allows to wakeup and the one that doesn=E2=80=99t=
.
> >
> > Another option is to create an Add Extended Device command. Main reason=
 here is that I don=E2=80=99t want to end up in the situation where you hav=
e to add a device and then send another 10 commands to set its features.
>
> Sent an email for doc/mgmt-api.txt. I think adding this to "Add
> Device" would be acceptable. However, it is possible for "wake
> capable" to be modified at runtime so it might be more appropriate on
> some sort of Set Connection Parameters type command.
Agreed, a generic property mechanism seems appropriate.  However, I
would advise against overloading Add_Device as Abhishek indicated.
Wake capability (or many other types of device featuers) may only be
discovered (or enabled by a user) after the device has already been
added.

>
> >
> > > #define MGMT_EV_CMD_COMPLETE          0x0001
> > > struct mgmt_ev_cmd_complete {
> > >       __le16  opcode;
> > > diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> > > index 1ca7508b6ca7..7057b9b65173 100644
> > > --- a/net/bluetooth/hci_core.c
> > > +++ b/net/bluetooth/hci_core.c
> > > @@ -3299,6 +3299,7 @@ struct hci_dev *hci_alloc_dev(void)
> > >       INIT_LIST_HEAD(&hdev->mgmt_pending);
> > >       INIT_LIST_HEAD(&hdev->blacklist);
> > >       INIT_LIST_HEAD(&hdev->whitelist);
> > > +     INIT_LIST_HEAD(&hdev->wakeable);
> > >       INIT_LIST_HEAD(&hdev->uuids);
> > >       INIT_LIST_HEAD(&hdev->link_keys);
> > >       INIT_LIST_HEAD(&hdev->long_term_keys);
> > > diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
> > > index 0dc610faab70..95092130f16c 100644
> > > --- a/net/bluetooth/mgmt.c
> > > +++ b/net/bluetooth/mgmt.c
> > > @@ -106,7 +106,10 @@ static const u16 mgmt_commands[] =3D {
> > >       MGMT_OP_START_LIMITED_DISCOVERY,
> > >       MGMT_OP_READ_EXT_INFO,
> > >       MGMT_OP_SET_APPEARANCE,
> > > +     MGMT_OP_GET_PHY_CONFIGURATION,
> > > +     MGMT_OP_SET_PHY_CONFIGURATION,
> >
> > These are unrelated to this patch.
>
> They weren't there on tip last time I rebased. Should I create a new
> patch for this?
>
> >
> > >       MGMT_OP_SET_BLOCKED_KEYS,
> > > +     MGMT_OP_SET_WAKE_CAPABLE,
> > > };
> > >
> > > static const u16 mgmt_events[] =3D {
> > > @@ -4663,6 +4666,37 @@ static int set_fast_connectable(struct sock *s=
k, struct hci_dev *hdev,
> > >       return err;
> > > }
> > >
> > > +static int set_wake_capable(struct sock *sk, struct hci_dev *hdev, v=
oid *data,
> > > +                         u16 len)
> > > +{
> > > +     int err;
> > > +     u8 status;
> > > +     struct mgmt_cp_set_wake_capable *cp =3D data;
> > > +     u8 addr_type =3D cp->addr.type =3D=3D BDADDR_BREDR ?
> > > +                            cp->addr.type :
> > > +                            le_addr_type(cp->addr.type);
> > > +
> > > +     BT_DBG("Set wake capable %pMR (type 0x%x) =3D 0x%x\n", &cp->add=
r.bdaddr,
> > > +            addr_type, cp->wake_capable);
> > > +
> > > +     if (cp->wake_capable)
> > > +             err =3D hci_bdaddr_list_add(&hdev->wakeable, &cp->addr.=
bdaddr,
> > > +                                       addr_type);
> > > +     else
> > > +             err =3D hci_bdaddr_list_del(&hdev->wakeable, &cp->addr.=
bdaddr,
> > > +                                       addr_type);
> > > +
> > > +     if (!err || err =3D=3D -EEXIST || err =3D=3D -ENOENT)
> > > +             status =3D MGMT_STATUS_SUCCESS;
> > > +     else
> > > +             status =3D MGMT_STATUS_FAILED;
> > > +
> > > +     err =3D mgmt_cmd_complete(sk, hdev->id, MGMT_OP_SET_WAKE_CAPABL=
E, status,
> > > +                             cp, sizeof(*cp));
> > > +
> > > +     return err;
> > > +}
> > > +
> > > static void set_bredr_complete(struct hci_dev *hdev, u8 status, u16 o=
pcode)
> > > {
> > >       struct mgmt_pending_cmd *cmd;
> > > @@ -5791,6 +5825,13 @@ static int remove_device(struct sock *sk, stru=
ct hci_dev *hdev,
> > >                       err =3D hci_bdaddr_list_del(&hdev->whitelist,
> > >                                                 &cp->addr.bdaddr,
> > >                                                 cp->addr.type);
> > > +
> > > +                     /* Don't check result since it either succeeds =
or device
> > > +                      * wasn't there (not wakeable or invalid params=
 as
> > > +                      * covered by deleting from whitelist).
> > > +                      */
> > > +                     hci_bdaddr_list_del(&hdev->wakeable, &cp->addr.=
bdaddr,
> > > +                                         cp->addr.type);
> > >                       if (err) {
> > >                               err =3D mgmt_cmd_complete(sk, hdev->id,
> > >                                                       MGMT_OP_REMOVE_=
DEVICE,
> > > @@ -6990,6 +7031,7 @@ static const struct hci_mgmt_handler mgmt_handl=
ers[] =3D {
> > >       { set_phy_configuration,   MGMT_SET_PHY_CONFIGURATION_SIZE },
> > >       { set_blocked_keys,        MGMT_OP_SET_BLOCKED_KEYS_SIZE,
> > >                                               HCI_MGMT_VAR_LEN },
> > > +     { set_wake_capable,        MGMT_SET_WAKE_CAPABLE_SIZE },
> > > };
> > >
> >
> > Regards
> >
> > Marcel
> >
