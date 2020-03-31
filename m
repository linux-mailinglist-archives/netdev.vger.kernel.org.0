Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 765411988CB
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 02:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729461AbgCaAUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 20:20:15 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:36363 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729426AbgCaAUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 20:20:15 -0400
Received: by mail-lj1-f194.google.com with SMTP id g12so20161848ljj.3
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 17:20:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Qyh+UeCPmhMBCyUF2QXnjk8VqGEW1MhdZgPUG0OE7gw=;
        b=eSNxTfyDBYGuTi0YNjfIUweBBS1g9tp0MiAkpk1mqED16vI4qUZWQyn6YpJcWjZ+26
         +agqK7HQ7QmsyGZpxAjwWEeXdtmDplcKNXsyvCrM7O+lqArTeNao0jgbwxDNoEUGhIDx
         yxfVNd0lcHpHWntvGCJQABHgQrxb9bhHVNguA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Qyh+UeCPmhMBCyUF2QXnjk8VqGEW1MhdZgPUG0OE7gw=;
        b=C0djedgQM3eOh4Y49WUm1mTVx06/YJwxuIWHOADNOagqTj2PRB64I7nnlSeMKB/eLf
         ShChqI6bLmNOwWFxdx0H6NVMfsvptwlOZu5eN25SK16majgNYnMFhn9p84aP0xCovBfS
         mg2j7V1nEd5YT4aJ/moWzAGe0VTwMkUvSCAcgtlfwkB03gfjUXDVWA7l2K9JQc4nFWXa
         t1RG7XMxgUZuRequjdagDGpJ5xXrsqqf3BeYkhd1fykS1UEvStYS0G4ZLdd3iaSoR2rg
         ysHUTsoRcl8/Yydpo8hfmmaI+soewIXLZd3MqxMSy/zxXs3fLoLTjk5jOReYPqVdhUTO
         Hy6Q==
X-Gm-Message-State: AGi0PubGeD+xo7dIix7Npf36WajdQL/S3JKqssTUwJ1F7s13DvYSMHPa
        wHS/XkiNT2ge6WVwHkkVmj9RSNYI+M5A6V+QNab5RQ==
X-Google-Smtp-Source: APiQypK4gOoqqK7y4W+mJ/bW1PuBMKZYcDDB3CNoTGHP2amOhim1rA/h77eiHUfm7iQ6C8Wriyc6Dt0ha77JL5YD6Hw=
X-Received: by 2002:a05:651c:84:: with SMTP id 4mr8304565ljq.126.1585614010817;
 Mon, 30 Mar 2020 17:20:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200328074632.21907-1-mcchou@chromium.org> <20200328004507.v4.2.Ic59b637deef8e646f6599a80c9a2aa554f919e55@changeid>
 <1FA9284F-C8DD-40A3-81A7-65AC6DE1E3C5@holtmann.org>
In-Reply-To: <1FA9284F-C8DD-40A3-81A7-65AC6DE1E3C5@holtmann.org>
From:   Miao-chen Chou <mcchou@chromium.org>
Date:   Mon, 30 Mar 2020 17:19:59 -0700
Message-ID: <CABmPvSF2SMWUs_62jeAse3DbgRgQBiOinKZQuPN7k+MKYL6eDw@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] Bluetooth: btusb: Read the supported features of
 Microsoft vendor extension
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Bluetooth Kernel Mailing List <linux-bluetooth@vger.kernel.org>,
        Alain Michaud <alainm@chromium.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marcel,

On Mon, Mar 30, 2020 at 3:08 PM Marcel Holtmann <marcel@holtmann.org> wrote=
:
>
> Hi Miao-chen,
>
> > This defines opcode and packet structures of Microsoft vendor extension=
.
> > For now, we add only the HCI_VS_MSFT_Read_Supported_Features command. S=
ee
> > https://docs.microsoft.com/en-us/windows-hardware/drivers/bluetooth/
> > microsoft-defined-bluetooth-hci-commands-and-events#microsoft-defined-
> > bluetooth-hci-events for more details.
> > Upon initialization of a hci_dev, we issue a
> > HCI_VS_MSFT_Read_Supported_Features command to read the supported featu=
res
> > of Microsoft vendor extension if the opcode of Microsoft vendor extensi=
on
> > is valid. See https://docs.microsoft.com/en-us/windows-hardware/drivers=
/
> > bluetooth/microsoft-defined-bluetooth-hci-commands-and-events#
> > hci_vs_msft_read_supported_features for more details.
> > This was verified on a device with Intel ThunderPeak BT controller wher=
e
> > the Microsoft vendor extension features are 0x000000000000003f.
> >
> > Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
> >
> > Signed-off-by: Miao-chen Chou <mcchou@chromium.org>
> > ---
> >
> > Changes in v4:
> > - Move MSFT's do_open() and do_close() from net/bluetooth/hci_core.c to
> > net/bluetooth/msft.c.
> > - Other than msft opcode, define struct msft_data to host the rest of
> > information of Microsoft extension and leave a void* pointing to a
> > msft_data in struct hci_dev.
> >
> > Changes in v3:
> > - Introduce msft_vnd_ext_do_open() and msft_vnd_ext_do_close().
> >
> > Changes in v2:
> > - Issue a HCI_VS_MSFT_Read_Supported_Features command with
> > __hci_cmd_sync() instead of constructing a request.
> >
> > include/net/bluetooth/hci_core.h |   1 +
> > net/bluetooth/hci_core.c         |   5 ++
> > net/bluetooth/hci_event.c        |   5 ++
> > net/bluetooth/msft.c             | 126 +++++++++++++++++++++++++++++++
> > net/bluetooth/msft.h             |  10 +++
> > 5 files changed, 147 insertions(+)
> >
> > diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/h=
ci_core.h
> > index 239cae2d9998..59ddcd3a52cc 100644
> > --- a/include/net/bluetooth/hci_core.h
> > +++ b/include/net/bluetooth/hci_core.h
> > @@ -486,6 +486,7 @@ struct hci_dev {
> >
> > #if IS_ENABLED(CONFIG_BT_MSFTEXT)
> >       __u16                   msft_opcode;
> > +     void                    *msft_data;
> > #endif
> >
> >       int (*open)(struct hci_dev *hdev);
> > diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> > index dbd2ad3a26ed..c38707de767a 100644
> > --- a/net/bluetooth/hci_core.c
> > +++ b/net/bluetooth/hci_core.c
> > @@ -44,6 +44,7 @@
> > #include "hci_debugfs.h"
> > #include "smp.h"
> > #include "leds.h"
> > +#include "msft.h"
> >
> > static void hci_rx_work(struct work_struct *work);
> > static void hci_cmd_work(struct work_struct *work);
> > @@ -1563,6 +1564,8 @@ static int hci_dev_do_open(struct hci_dev *hdev)
> >           hci_dev_test_flag(hdev, HCI_VENDOR_DIAG) && hdev->set_diag)
> >               ret =3D hdev->set_diag(hdev, true);
> >
> > +     msft_do_open(hdev);
> > +
> >       clear_bit(HCI_INIT, &hdev->flags);
> >
> >       if (!ret) {
> > @@ -1758,6 +1761,8 @@ int hci_dev_do_close(struct hci_dev *hdev)
> >
> >       hci_sock_dev_event(hdev, HCI_DEV_DOWN);
> >
> > +     msft_do_close(hdev);
> > +
> >       if (hdev->flush)
> >               hdev->flush(hdev);
> >
> > diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> > index 20408d386268..42b5871151a6 100644
> > --- a/net/bluetooth/hci_event.c
> > +++ b/net/bluetooth/hci_event.c
> > @@ -35,6 +35,7 @@
> > #include "a2mp.h"
> > #include "amp.h"
> > #include "smp.h"
> > +#include "msft.h"
> >
> > #define ZERO_KEY "\x00\x00\x00\x00\x00\x00\x00\x00" \
> >                "\x00\x00\x00\x00\x00\x00\x00\x00"
> > @@ -6144,6 +6145,10 @@ void hci_event_packet(struct hci_dev *hdev, stru=
ct sk_buff *skb)
> >               hci_num_comp_blocks_evt(hdev, skb);
> >               break;
> >
> > +     case HCI_EV_VENDOR:
> > +             msft_vendor_evt(hdev, skb);
> > +             break;
> > +
> >       default:
> >               BT_DBG("%s event 0x%2.2x", hdev->name, event);
> >               break;
> > diff --git a/net/bluetooth/msft.c b/net/bluetooth/msft.c
> > index 7609932c48ca..f76e4c79556e 100644
> > --- a/net/bluetooth/msft.c
> > +++ b/net/bluetooth/msft.c
> > @@ -6,6 +6,24 @@
> >
> > #include "msft.h"
> >
> > +#define MSFT_OP_READ_SUPPORTED_FEATURES              0x00
> > +struct msft_cp_read_supported_features {
> > +     __u8   sub_opcode;
> > +} __packed;
> > +struct msft_rp_read_supported_features {
> > +     __u8   status;
> > +     __u8   sub_opcode;
> > +     __le64 features;
> > +     __u8   evt_prefix_len;
> > +     __u8   evt_prefix[0];
> > +} __packed;
> > +
> > +struct msft_data {
> > +     __u64 features;
> > +     __u8  evt_prefix_len;
> > +     __u8  *evt_prefix;
> > +};
> > +
> > void msft_set_opcode(struct hci_dev *hdev, __u16 opcode)
> > {
> >       hdev->msft_opcode =3D opcode;
> > @@ -14,3 +32,111 @@ void msft_set_opcode(struct hci_dev *hdev, __u16 op=
code)
> >                   hdev->msft_opcode);
> > }
> > EXPORT_SYMBOL(msft_set_opcode);
> > +
> > +static struct msft_data *read_supported_features(struct hci_dev *hdev)
> > +{
> > +     struct msft_data *msft;
>
> I used a second parameter, but yes, my initial code was totally flawed wi=
th the msft_data access.
Ack.
>
> > +     struct msft_cp_read_supported_features cp;
> > +     struct msft_rp_read_supported_features *rp;
> > +     struct sk_buff *skb;
> > +
> > +     cp.sub_opcode =3D MSFT_OP_READ_SUPPORTED_FEATURES;
> > +
> > +     skb =3D __hci_cmd_sync(hdev, hdev->msft_opcode, sizeof(cp), &cp,
> > +                          HCI_CMD_TIMEOUT);
> > +     if (IS_ERR(skb)) {
> > +             bt_dev_err(hdev, "Failed to read MSFT supported features =
(%ld)",
> > +                        PTR_ERR(skb));
> > +             return NULL;
> > +     }
> > +
> > +     if (skb->len < sizeof(*rp)) {
> > +             bt_dev_err(hdev, "MSFT supported features length mismatch=
");
> > +             goto failed;
> > +     }
> > +
> > +     rp =3D (struct msft_rp_read_supported_features *)skb->data;
> > +
> > +     if (rp->sub_opcode !=3D MSFT_OP_READ_SUPPORTED_FEATURES)
> > +             goto failed;
> > +
> > +     msft =3D kzalloc(sizeof(*msft), GFP_KERNEL);
> > +     if (!msft)
> > +             goto failed;
> > +
> > +     if (rp->evt_prefix_len > 0) {
> > +             msft->evt_prefix =3D kmemdup(rp->evt_prefix, rp->evt_pref=
ix_len,
> > +                                        GFP_KERNEL);
> > +             if (!msft->evt_prefix)
> > +                     goto failed;
> > +     }
> > +
> > +     msft->evt_prefix_len =3D rp->evt_prefix_len;
> > +     msft->features =3D __le64_to_cpu(rp->features);
> > +     kfree_skb(skb);
> > +
> > +     bt_dev_info(hdev, "MSFT supported features %llx", msft->features)=
;
> > +     return msft;
> > +
> > +failed:
> > +     kfree_skb(skb);
> > +     return NULL;
> > +}
> > +
> > +void msft_do_open(struct hci_dev *hdev)
> > +{
> > +     if (hdev->msft_opcode =3D=3D HCI_OP_NOP)
> > +             return;
> > +
> > +     bt_dev_dbg(hdev, "Initialize MSFT extension");
> > +     hdev->msft_data =3D read_supported_features(hdev);
> > +}
> > +
> > +void msft_do_close(struct hci_dev *hdev)
> > +{
> > +     struct msft_data *msft =3D hdev->msft_data;
> > +
> > +     if (!msft)
> > +             return;
> > +
> > +     bt_dev_dbg(hdev, "Cleanup of MSFT extension");
> > +
> > +     hdev->msft_data =3D NULL;
> > +
> > +     kfree(msft->evt_prefix);
> > +     kfree(msft);
> > +}
> > +
> > +int msft_vendor_evt(struct hci_dev *hdev, struct sk_buff *skb)
> > +{
>
> So this was on purpose void. There is no point in returning any feedback =
from this function. It either handles the event or it doesn=E2=80=99t. The =
caller function doesn=E2=80=99t care.
I was thinking that if there are two extensions, the vendor events
should be processed either msft or the other function. Therefore,
should we use the return value to determine whether to hand skb to the
other function?
>
> > +     struct msft_data *msft =3D hdev->msft_data;
> > +     u8 event;
> > +
> > +     if (!msft)
> > +             return -ENOSYS;
> > +
> > +     /* When the extension has defined an event prefix, check that it
> > +      * matches, and otherwise just return.
> > +      */
> > +     if (msft->evt_prefix_len > 0) {
> > +             if (skb->len < msft->evt_prefix_len)
> > +                     return -ENOSYS;
> > +
> > +             if (memcmp(skb->data, msft->evt_prefix, msft->evt_prefix_=
len))
> > +                     return -ENOSYS;
> > +
> > +             skb_pull(skb, msft->evt_prefix_len);
> > +     }
> > +
> > +     /* Every event starts at least with an event code and the rest of
> > +      * the data is variable and depends on the event code. Returns tr=
ue
> > +      */
> > +     if (skb->len < 1)
> > +             return -EBADMSG;
> > +
> > +     event =3D *skb->data;
> > +     skb_pull(skb, 1);
> > +
> > +     bt_dev_dbg(hdev, "MSFT vendor event %u", event);
> > +     return 0;
> > +}
> > diff --git a/net/bluetooth/msft.h b/net/bluetooth/msft.h
> > index 7218ea759dde..6a7d0ac6c66c 100644
> > --- a/net/bluetooth/msft.h
> > +++ b/net/bluetooth/msft.h
> > @@ -4,15 +4,25 @@
> > #ifndef __MSFT_H
> > #define __MSFT_H
> >
> > +#include <linux/errno.h>
> > #include <net/bluetooth/hci_core.h>
> >
> > #if IS_ENABLED(CONFIG_BT_MSFTEXT)
> >
> > void msft_set_opcode(struct hci_dev *hdev, __u16 opcode);
> > +void msft_do_open(struct hci_dev *hdev);
> > +void msft_do_close(struct hci_dev *hdev);
> > +int msft_vendor_evt(struct hci_dev *hdev, struct sk_buff *skb);
> >
> > #else
> >
> > static inline void msft_set_opcode(struct hci_dev *hdev, __u16 opcode) =
{}
> > +static inline void msft_do_open(struct hci_dev *hdev) {}
> > +static inline void msft_do_close(struct hci_dev *hdev) {}
> > +static inline int msft_vendor_evt(struct hci_dev *hdev, struct sk_buff=
 *skb)
> > +{
> > +     return -ENOSYS;
> > +}
> >
> > #endif
Thanks,
Miao
