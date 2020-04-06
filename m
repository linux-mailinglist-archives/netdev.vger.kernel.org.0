Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC89C19F585
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 14:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbgDFMFz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 08:05:55 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36011 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727376AbgDFMFy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 08:05:54 -0400
Received: by mail-wr1-f68.google.com with SMTP id k1so7703521wrm.3
        for <netdev@vger.kernel.org>; Mon, 06 Apr 2020 05:05:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tb5p1CydIfiIsMBrYduHzIdqK2v1ANIihAYVOuK1nbw=;
        b=W0ynj96xhfEK0+hP+qB2oEoxs4235NZOWIFrntBwP6DG9BZ3bnHCbiZ1TVfdIAB6i8
         bRvhzGkQHrI3jpThoyuk9/9RE2+WosRktCLycFMfnNbtwyT/tq9UNO7lxsIDz0fj5Nv1
         XGEiab5Pexfxj4DzlxJjH5rJP6+FzbXSdhKgcByRnbHrVvmP0Tr/4OuO81FOFDYUsnul
         YwLtabKhci5WdoBLQZPX7ecaWrQb992RBj3cl0sBJ9feCL5BDCoyYNBxh5qcYrqgja9K
         ZJEFEQ4GtBaQoaFvvt7etT3QCgJXKta+8UCb9fYpng5DrwQ1VHUjcKVIkpC33a8S7xsJ
         JJ5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tb5p1CydIfiIsMBrYduHzIdqK2v1ANIihAYVOuK1nbw=;
        b=ZDq9kddwLrAJ+fxJ9ObwFt98fM428xpXm2tziuYJXcS6eiHuN+KAT2dy+vtjdxuIfn
         gxDBmIFWokwgAcnYC3EUMsJyewxB7InuZXpZvcRAvaVQuoWtTQQIIeJArvvZyOJ9YEV4
         +/jS1sZHi/iDwBhR5aKCaFakCqRN6lYsoZKGgc9irHoIULnBk8PIZ5Pew1S17XTsv2yb
         kcc55FlcA6SdkdjCDQdxIF7O/ruDpRY7WBsQ4RSaUJLDP9u94rupsC65XLxdobS3EKk4
         s07pBmZc9Ih9A9GsqPjMboABwx67f0buZCk4l+18abHo+BXk5PkB2zXc7TICIwsTnAXI
         DnlQ==
X-Gm-Message-State: AGi0PuaWLdkp0ODJiz3lHJqAJCjZhRGuA/cBJWgcsVolbx1RIAisqfjr
        /e5+UKkpnH4tN/PfXtk/JEIB74s486hRY7qyPihGGA==
X-Google-Smtp-Source: APiQypJ8tIPBI9Ffgc1wnyJM0KKNCtWzLsTPsJd5LFX7lZK6/D5JhqYvaEF8OdpLZVZ2ABNyvq7bvnwaxTpBWDR3dZ8=
X-Received: by 2002:a5d:4290:: with SMTP id k16mr23235842wrq.406.1586174751074;
 Mon, 06 Apr 2020 05:05:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200406165542.v1.1.Ibfc500cbf0bf2dc8429b17f064e960e95bb228e9@changeid>
 <9673F164-A14E-4DD6-88FB-277694C50328@holtmann.org>
In-Reply-To: <9673F164-A14E-4DD6-88FB-277694C50328@holtmann.org>
From:   Archie Pusaka <apusaka@google.com>
Date:   Mon, 6 Apr 2020 20:05:40 +0800
Message-ID: <CAJQfnxHUWCDVs5O-sJG8cqQKRrs9UvEjm3Yjv65SoyrzNNGV=Q@mail.gmail.com>
Subject: Re: [PATCH v1] Bluetooth: debugfs option to unset MITM flag
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Archie Pusaka <apusaka@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marcel,

The way I implemented it is, if HCI_ENFORCE_MITM_SMP is set (which it
is by default), then it will assume the default behavior.
However, if it is toggled to false, then it will not set the MITM flag
although the io capability supports that.

I am reluctant to use names with "no" on it, especially since it is a
boolean. But if it is OK then I shall update to HCI_FORCE_NO_MITM,
this way it will become more separable with the default behavior.

Sure, I will move that to hci_debugfs.c.

Thanks,
Archie


On Mon, 6 Apr 2020 at 19:46, Marcel Holtmann <marcel@holtmann.org> wrote:
>
> Hi Archie,
>
> > The BT qualification test SM/MAS/PKE/BV-01-C needs us to turn off
> > the MITM flag when pairing, and at the same time also set the io
> > capability to something other than no input no output.
> >
> > Currently the MITM flag is only unset when the io capability is set
> > to no input no output, therefore the test cannot be executed.
> >
> > This patch introduces a debugfs option for controlling whether MITM
> > flag should be set based on io capability.
> >
> > Signed-off-by: Archie Pusaka <apusaka@chromium.org>
> > ---
> >
> > include/net/bluetooth/hci.h |  1 +
> > net/bluetooth/smp.c         | 52 ++++++++++++++++++++++++++++++++++++-
> > 2 files changed, 52 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
> > index 79de2a659dd69..5e183487c7479 100644
> > --- a/include/net/bluetooth/hci.h
> > +++ b/include/net/bluetooth/hci.h
> > @@ -298,6 +298,7 @@ enum {
> >       HCI_FORCE_STATIC_ADDR,
> >       HCI_LL_RPA_RESOLUTION,
> >       HCI_CMD_PENDING,
> > +     HCI_ENFORCE_MITM_SMP,
>
> actually don=E2=80=99t you mean HCI_FORCE_NO_MITM? From your description,=
 you want a toggle that disables MITM no matter what.
>
> >       __HCI_NUM_FLAGS,
> > };
> > diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
> > index d0b695ee49f63..4fa8b112fb607 100644
> > --- a/net/bluetooth/smp.c
> > +++ b/net/bluetooth/smp.c
> > @@ -2396,7 +2396,8 @@ int smp_conn_security(struct hci_conn *hcon, __u8=
 sec_level)
> >       /* Require MITM if IO Capability allows or the security level
> >        * requires it.
> >        */
> > -     if (hcon->io_capability !=3D HCI_IO_NO_INPUT_OUTPUT ||
> > +     if ((hci_dev_test_flag(hcon->hdev, HCI_ENFORCE_MITM_SMP) &&
> > +          hcon->io_capability !=3D HCI_IO_NO_INPUT_OUTPUT) ||
> >           hcon->pending_sec_level > BT_SECURITY_MEDIUM)
> >               authreq |=3D SMP_AUTH_MITM;
>
>         /* New comment for this case ..
>         if (!hci_dev_test_flag(hcon->hdev, HCI_FORCE_NO_MITM)) {
>                 /* Move comment here ..
>                 if (hcon->io_capability !=3D HCI_IO_NO_INPUT_OUTPUT ||
>                     hcon->pending_sec_level > BT_SECURITY_MEDIUM)
>                         authreq |=3D SMP_AUTH_MITM;
>         }
>
> >
> > @@ -3402,6 +3403,50 @@ static const struct file_operations force_bredr_=
smp_fops =3D {
> >       .llseek         =3D default_llseek,
> > };
> >
> > +static ssize_t enforce_mitm_smp_read(struct file *file,
> > +                                  char __user *user_buf,
> > +                                  size_t count, loff_t *ppos)
> > +{
> > +     struct hci_dev *hdev =3D file->private_data;
> > +     char buf[3];
> > +
> > +     buf[0] =3D hci_dev_test_flag(hdev, HCI_ENFORCE_MITM_SMP) ? 'Y' : =
'N';
> > +     buf[1] =3D '\n';
> > +     buf[2] =3D '\0';
> > +     return simple_read_from_buffer(user_buf, count, ppos, buf, 2);
> > +}
> > +
> > +static ssize_t enforce_mitm_smp_write(struct file *file,
> > +                                   const char __user *user_buf,
> > +                                   size_t count, loff_t *ppos)
> > +{
> > +     struct hci_dev *hdev =3D file->private_data;
> > +     char buf[32];
> > +     size_t buf_size =3D min(count, (sizeof(buf) - 1));
> > +     bool enable;
> > +
> > +     if (copy_from_user(buf, user_buf, buf_size))
> > +             return -EFAULT;
> > +
> > +     buf[buf_size] =3D '\0';
> > +     if (strtobool(buf, &enable))
> > +             return -EINVAL;
> > +
> > +     if (enable =3D=3D hci_dev_test_flag(hdev, HCI_ENFORCE_MITM_SMP))
> > +             return -EALREADY;
> > +
> > +     hci_dev_change_flag(hdev, HCI_ENFORCE_MITM_SMP);
> > +
> > +     return count;
> > +}
> > +
> > +static const struct file_operations enforce_mitm_smp_fops =3D {
> > +     .open           =3D simple_open,
> > +     .read           =3D enforce_mitm_smp_read,
> > +     .write          =3D enforce_mitm_smp_write,
> > +     .llseek         =3D default_llseek,
> > +};
> > +
> > int smp_register(struct hci_dev *hdev)
> > {
> >       struct l2cap_chan *chan;
> > @@ -3426,6 +3471,11 @@ int smp_register(struct hci_dev *hdev)
> >
> >       hdev->smp_data =3D chan;
> >
> > +     /* Enforce the policy of determining MITM flag by io capabilities=
. */
> > +     hci_dev_set_flag(hdev, HCI_ENFORCE_MITM_SMP);
>
> No. Lets keep the current behavior the default.
>
> > +     debugfs_create_file("enforce_mitm_smp", 0644, hdev->debugfs, hdev=
,
> > +                         &enforce_mitm_smp_fops);
> > +
>
> And this needs to move into hci_debugfs.c.
>
> Regards
>
> Marcel
>
