Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0743560DCE
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 01:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231980AbiF2X46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 19:56:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230262AbiF2X44 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 19:56:56 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B903F26565;
        Wed, 29 Jun 2022 16:56:53 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id f39so30800818lfv.3;
        Wed, 29 Jun 2022 16:56:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=x0FVQWiDWCNBvfhXTg+DCNRZVi9anK6oT7bb9algMk8=;
        b=itGTArdzG2JhYKye5rxha1hI25Ynn/puTWAkt3z3ro5DE5RZkl3xOawIxc0xzm9c+d
         sssj+LeHOzBWu1HMzvJrmZiVaB7voBz2FxJviomhNL5XAqxASI837+GJqHNWSQTvbX6L
         SYDrlHKLa6Lt73wCNM9jUzAfpWKIdLdVBWOpuCfkp11jYXJd+aN+ZsbpsPwCtq4cK/hX
         yYLGiLTUMPlecuN0XHxjnhFxkt9NPiSJzO7c9aT2op6207Syk9rdjBOZ5YbTFGUEVdhC
         9cuckcrbiic6VtoiLTraUVxUHkwTuulfzcD5Pdq+a2KEOxQPtBwvH7q4w/JCDxn7mHph
         +tEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=x0FVQWiDWCNBvfhXTg+DCNRZVi9anK6oT7bb9algMk8=;
        b=UExZlTCRKr4Bsq1KHJaBlsDYWbSJ2gSH/5XRT/JyCRbcZc5OkNHmTjHCUfmtes832Q
         0eeXSM//cUhcVT+0VYXAMrM/uyKyF8fPeL0oWzgqU9i0eMWk16ROTazYP8cflcW95xYs
         JXR8hzLHbViIYMy7tglB61+pWDUOoAgdD7fmDci6s9IIuhiYW+mS8ZStl7Sp7UiMZC/k
         UY+Fk0DhumxBQyhh7kc2cJIgIlFEPZfBbzB01NWMDUWkdtcaH+2C/C+xrrej9uiTg3da
         RDPVL19ek1YxCKyH2cE9GnQCzvU/gUDS428TyvKyr90QlqpeOP15m1PimfRD4d71PUpt
         iNgg==
X-Gm-Message-State: AJIora+S0tfJ9ZflQqxthgyREoAGYzbGGYmCs0IhIOxp+MCOtokHUbxA
        LvLfXQioI0XmdjbjeIhySGCr3vgyXj/8lf5H6AE=
X-Google-Smtp-Source: AGRyM1vvooqW6A5Kl3iQqazHnonHyFT5fXFOqzXTolo678LrCRruDUdP05RWlGwXtmrvredli2r/9a06oDP/M79AgWQ=
X-Received: by 2002:a05:6512:acc:b0:47f:769e:6aef with SMTP id
 n12-20020a0565120acc00b0047f769e6aefmr3565405lfu.26.1656547011805; Wed, 29
 Jun 2022 16:56:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220320183225.1.Iaf638bb9f885f5880ab1b4e7ae2f73dd53a54661@changeid>
 <CABBYNZJSu9QgO-zbBQTecbvzWNNtYrmHdSCjvEVURVKxPiojAw@mail.gmail.com>
 <CAGPPCLDu5_ES5CcsUU3qHLWHkzAV=FUU8rns8Twh6C5FVSeEUQ@mail.gmail.com>
 <CABBYNZ+jGjSHvpQg8uXyC2siCu8Zk-oqKnhiO1MG5d-3cUsyag@mail.gmail.com> <CAGPPCLBp7kOXquyJzHaYxsH8=GkJ6M6gC1twwc=2iMJvB+n=qQ@mail.gmail.com>
In-Reply-To: <CAGPPCLBp7kOXquyJzHaYxsH8=GkJ6M6gC1twwc=2iMJvB+n=qQ@mail.gmail.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Wed, 29 Jun 2022 16:56:40 -0700
Message-ID: <CABBYNZ+5yQjGEe_fMmLOYXLidkJo36i4-Vu9LjxnhBNuwwLpnQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] Bluetooth: Add support for devcoredump
To:     Manish Mandlik <mmandlik@google.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        ChromeOS Bluetooth Upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Manish,

On Thu, Jun 23, 2022 at 12:43 PM Manish Mandlik <mmandlik@google.com> wrote=
:
>
> Hi Luiz,
>
> On Tue, May 3, 2022 at 5:04 PM Luiz Augusto von Dentz <luiz.dentz@gmail.c=
om> wrote:
>>
>> Hi Manish,
>>
>> On Tue, May 3, 2022 at 4:00 PM Manish Mandlik <mmandlik@google.com> wrot=
e:
>> >
>> > Hi Luiz,
>> >
>> > On Mon, Mar 21, 2022 at 9:46 AM Luiz Augusto von Dentz <luiz.dentz@gma=
il.com> wrote:
>> >>
>> >> Hi Manish,
>> >>
>> >> On Sun, Mar 20, 2022 at 6:34 PM Manish Mandlik <mmandlik@google.com> =
wrote:
>> >> >
>> >> > From: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
>> >> >
>> >> > Add devcoredump APIs to hci core so that drivers only have to provi=
de
>> >> > the dump skbs instead of managing the synchronization and timeouts.
>> >> >
>> >> > The devcoredump APIs should be used in the following manner:
>> >> >  - hci_devcoredump_init is called to allocate the dump.
>> >> >  - hci_devcoredump_append is called to append any skbs with dump da=
ta
>> >> >    OR hci_devcoredump_append_pattern is called to insert a pattern.
>> >> >  - hci_devcoredump_complete is called when all dump packets have be=
en
>> >> >    sent OR hci_devcoredump_abort is called to indicate an error and
>> >> >    cancel an ongoing dump collection.
>> >> >
>> >> > The high level APIs just prepare some skbs with the appropriate dat=
a and
>> >> > queue it for the dump to process. Packets part of the crashdump can=
 be
>> >> > intercepted in the driver in interrupt context and forwarded direct=
ly to
>> >> > the devcoredump APIs.
>> >>
>> >> If this sort of information comes from telemetry support it can be
>> >> intercepted by other means as well e.g. btmon, in fact I think that
>> >> would have been better since we already dump the backtrace of
>> >> bluetoothd crashes into the monitor as well. Anyway the kernel
>> >> devcoredump support seems to just be dumping the data into sysfs so w=
e
>> >> could be fetching that information from there as well but I'm not
>> >> really sure what we would be gaining with that since we are just
>> >> adding yet another kernel dependency for something that userspace
>> >> could already be doing by itself.
>> >
>> > Currently every vendor has their own way of collecting firmware dumps.=
 The main intention of adding devcoredump support for bluetooth is to provi=
de a unified way to collect firmware crashdumps across all vendors/controll=
ers. This will generate a dump file in the sysfs and vendors can use it for=
 further debugging. There is no plan to include any information from these =
dumps into the btmon logs.
>> >
>> >>
>> >> > Internally, there are 5 states for the dump: idle, active, complete=
,
>> >> > abort and timeout. A devcoredump will only be in active state after=
 it
>> >> > has been initialized. Once active, it accepts data to be appended,
>> >> > patterns to be inserted (i.e. memset) and a completion event or an =
abort
>> >> > event to generate a devcoredump. The timeout is initialized at the =
same
>> >> > time the dump is initialized (defaulting to 10s) and will be cleare=
d
>> >> > either when the timeout occurs or the dump is complete or aborted.
>> >>
>> >> Is there some userspace component parsing these dumps? Or we will nee=
d
>> >> to add some support for the likes of btmon to collect the logs from
>> >> sysfs?
>> >
>> > Yes, user space component is required to parse these dumps. But these =
tools will be vendor specific and could be proprietary. However, ChromeOS w=
ould be using these dumps to identify bluetooth firmware crashes. I'll shar=
e more information on ChromeOS use case offline.
>>
>> Fair enough, but we do need some way to exercise this code by the CI,
>> so at very least we need emulator support otherwise it needs to be
>> behind an experimental UUID until proper tests are introduced.
>
> I can add emulator support. Can you please share some instructions/docume=
ntation on how to create and run emulator tests? I'll send a separate patch=
 for adding emulator support.

They are the same tests run in CI, have a look at:

https://git.kernel.org/pub/scm/bluetooth/bluez.git/tree/doc/test-runner.txt

>>
>>
>> >>
>> >>
>> >> > Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
>> >> > Signed-off-by: Manish Mandlik <mmandlik@google.com>
>> >> > Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
>> >> > ---
>> >> >
>> >> >  include/net/bluetooth/hci_core.h |  51 ++++
>> >> >  net/bluetooth/hci_core.c         | 496 +++++++++++++++++++++++++++=
++++
>> >> >  net/bluetooth/hci_sync.c         |   2 +
>> >> >  3 files changed, 549 insertions(+)
>> >> >
>> >> > diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetoo=
th/hci_core.h
>> >> > index d5377740e99c..818ba3a43e8c 100644
>> >> > --- a/include/net/bluetooth/hci_core.h
>> >> > +++ b/include/net/bluetooth/hci_core.h
>> >> > @@ -118,6 +118,43 @@ enum suspended_state {
>> >> >         BT_SUSPEND_CONFIGURE_WAKE,
>> >> >  };
>> >> >
>> >> > +#define DEVCOREDUMP_TIMEOUT    msecs_to_jiffies(100000)        /* =
100 sec */
>> >> > +
>> >> > +typedef int  (*dmp_hdr_t)(struct hci_dev *hdev, char *buf, size_t =
size);
>> >> > +typedef void (*notify_change_t)(struct hci_dev *hdev, int state);
>> >> > +
>> >> > +/* struct hci_devcoredump - Devcoredump state
>> >> > + *
>> >> > + * @supported: Indicates if FW dump collection is supported by dri=
ver
>> >> > + * @state: Current state of dump collection
>> >> > + * @alloc_size: Total size of the dump
>> >> > + * @head: Start of the dump
>> >> > + * @tail: Pointer to current end of dump
>> >> > + * @end: head + alloc_size for easy comparisons
>> >> > + *
>> >> > + * @dmp_hdr: Create a dump header to identify controller/fw/driver=
 info
>> >> > + * @notify_change: Notify driver when devcoredump state has change=
d
>> >> > + */
>> >> > +struct hci_devcoredump {
>> >> > +       bool            supported;
>> >> > +
>> >> > +       enum devcoredump_state {
>> >> > +               HCI_DEVCOREDUMP_IDLE,
>> >> > +               HCI_DEVCOREDUMP_ACTIVE,
>> >> > +               HCI_DEVCOREDUMP_DONE,
>> >> > +               HCI_DEVCOREDUMP_ABORT,
>> >> > +               HCI_DEVCOREDUMP_TIMEOUT
>> >> > +       } state;
>> >> > +
>> >> > +       u32             alloc_size;
>> >> > +       char            *head;
>> >> > +       char            *tail;
>> >> > +       char            *end;
>> >> > +
>> >> > +       dmp_hdr_t       dmp_hdr;
>> >> > +       notify_change_t notify_change;
>> >> > +};
>> >> > +
>> >> >  struct hci_conn_hash {
>> >> >         struct list_head list;
>> >> >         unsigned int     acl_num;
>> >> > @@ -568,6 +605,11 @@ struct hci_dev {
>> >> >         const char              *fw_info;
>> >> >         struct dentry           *debugfs;
>> >> >
>> >> > +       struct hci_devcoredump  dump;
>> >> > +       struct sk_buff_head     dump_q;
>> >> > +       struct work_struct      dump_rx;
>> >> > +       struct delayed_work     dump_timeout;
>> >> > +
>> >> >         struct device           dev;
>> >> >
>> >> >         struct rfkill           *rfkill;
>> >> > @@ -1308,6 +1350,15 @@ static inline void hci_set_aosp_capable(stru=
ct hci_dev *hdev)
>> >> >  #endif
>> >> >  }
>> >> >
>> >> > +int hci_devcoredump_register(struct hci_dev *hdev, dmp_hdr_t dmp_h=
dr,
>> >> > +                            notify_change_t notify_change);
>> >> > +int hci_devcoredump_init(struct hci_dev *hdev, u32 dmp_size);
>> >> > +int hci_devcoredump_append(struct hci_dev *hdev, struct sk_buff *s=
kb);
>> >> > +int hci_devcoredump_append_pattern(struct hci_dev *hdev, u8 patter=
n, u32 len);
>> >> > +int hci_devcoredump_complete(struct hci_dev *hdev);
>> >> > +int hci_devcoredump_abort(struct hci_dev *hdev);
>> >> > +void hci_devcoredump_reset(struct hci_dev *hdev);
>> >> > +
>> >> >  int hci_dev_open(__u16 dev);
>> >> >  int hci_dev_close(__u16 dev);
>> >> >  int hci_dev_do_close(struct hci_dev *hdev);
>> >> > diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
>> >> > index b4782a6c1025..76dbb6b28870 100644
>> >> > --- a/net/bluetooth/hci_core.c
>> >> > +++ b/net/bluetooth/hci_core.c
>> >> > @@ -28,6 +28,7 @@
>> >> >  #include <linux/export.h>
>> >> >  #include <linux/rfkill.h>
>> >> >  #include <linux/debugfs.h>
>> >> > +#include <linux/devcoredump.h>
>> >> >  #include <linux/crypto.h>
>> >> >  #include <linux/property.h>
>> >> >  #include <linux/suspend.h>
>> >> > @@ -2404,6 +2405,498 @@ static int hci_suspend_notifier(struct noti=
fier_block *nb, unsigned long action,
>> >> >         return NOTIFY_DONE;
>> >> >  }
>> >> >
>> >> > +enum hci_devcoredump_pkt_type {
>> >> > +       HCI_DEVCOREDUMP_PKT_INIT,
>> >> > +       HCI_DEVCOREDUMP_PKT_SKB,
>> >> > +       HCI_DEVCOREDUMP_PKT_PATTERN,
>> >> > +       HCI_DEVCOREDUMP_PKT_COMPLETE,
>> >> > +       HCI_DEVCOREDUMP_PKT_ABORT,
>> >> > +};
>>
>> I'd move the documentation of the states here, also perhaps we should
>> have the handling of devcoredump in its own file e.g. coredump.c,
>> since hci_core.c is quite big already adding things that are not part
>> of HCI/core specification makes it even bigger.
>
> Since these are just packet types, I'm keeping the documentation of the s=
tates with the state machine function hci_devcoredump_rx(). However, I have=
 moved  all hci_devcoredump code to a new file - net/bluetooth/coredump.c.
>
>>
>> >> > +struct hci_devcoredump_skb_cb {
>> >> > +       u16 pkt_type;
>> >> > +};
>> >> > +
>> >> > +struct hci_devcoredump_skb_pattern {
>> >> > +       u8 pattern;
>> >> > +       u32 len;
>> >> > +} __packed;
>> >> > +
>> >> > +#define hci_dmp_cb(skb)        ((struct hci_devcoredump_skb_cb *)(=
(skb)->cb))
>> >> > +
>> >> > +#define MAX_DEVCOREDUMP_HDR_SIZE       512     /* bytes */
>> >> > +
>> >> > +static int hci_devcoredump_update_hdr_state(char *buf, size_t size=
, int state)
>> >> > +{
>> >> > +       if (!buf)
>> >> > +               return 0;
>> >> > +
>> >> > +       return snprintf(buf, size, "Bluetooth devcoredump\nState: %=
d\n", state);
>> >> > +}
>> >> > +
>> >> > +/* Call with hci_dev_lock only. */
>> >> > +static int hci_devcoredump_update_state(struct hci_dev *hdev, int =
state)
>> >> > +{
>> >> > +       hdev->dump.state =3D state;
>> >> > +
>> >> > +       return hci_devcoredump_update_hdr_state(hdev->dump.head,
>> >> > +                                               hdev->dump.alloc_si=
ze, state);
>> >> > +}
>> >> > +
>> >> > +static int hci_devcoredump_mkheader(struct hci_dev *hdev, char *bu=
f,
>> >> > +                                   size_t buf_size)
>> >> > +{
>> >> > +       char *ptr =3D buf;
>> >> > +       size_t rem =3D buf_size;
>> >> > +       size_t read =3D 0;
>> >> > +
>> >> > +       read =3D hci_devcoredump_update_hdr_state(ptr, rem, HCI_DEV=
COREDUMP_IDLE);
>> >> > +       read +=3D 1; /* update_hdr_state adds \0 at the end upon st=
ate rewrite */
>> >> > +       rem -=3D read;
>> >> > +       ptr +=3D read;
>> >> > +
>> >> > +       if (hdev->dump.dmp_hdr) {
>> >> > +               /* dmp_hdr() should return number of bytes written =
*/
>> >> > +               read =3D hdev->dump.dmp_hdr(hdev, ptr, rem);
>> >> > +               rem -=3D read;
>> >> > +               ptr +=3D read;
>> >> > +       }
>> >> > +
>> >> > +       read =3D snprintf(ptr, rem, "--- Start dump ---\n");
>> >> > +       rem -=3D read;
>> >> > +       ptr +=3D read;
>> >> > +
>> >> > +       return buf_size - rem;
>> >> > +}
>> >> > +
>> >> > +/* Do not call with hci_dev_lock since this calls driver code. */
>> >> > +static void hci_devcoredump_notify(struct hci_dev *hdev, int state=
)
>> >> > +{
>> >> > +       if (hdev->dump.notify_change)
>> >> > +               hdev->dump.notify_change(hdev, state);
>> >> > +}
>> >> > +
>> >> > +/* Call with hci_dev_lock only. */
>> >> > +void hci_devcoredump_reset(struct hci_dev *hdev)
>> >> > +{
>> >> > +       hdev->dump.head =3D NULL;
>> >> > +       hdev->dump.tail =3D NULL;
>> >> > +       hdev->dump.alloc_size =3D 0;
>> >> > +
>> >> > +       hci_devcoredump_update_state(hdev, HCI_DEVCOREDUMP_IDLE);
>> >> > +
>> >> > +       cancel_delayed_work(&hdev->dump_timeout);
>> >> > +       skb_queue_purge(&hdev->dump_q);
>> >> > +}
>> >> > +
>> >> > +/* Call with hci_dev_lock only. */
>> >> > +static void hci_devcoredump_free(struct hci_dev *hdev)
>> >> > +{
>> >> > +       if (hdev->dump.head)
>> >> > +               vfree(hdev->dump.head);
>> >> > +
>> >> > +       hci_devcoredump_reset(hdev);
>> >> > +}
>> >> > +
>> >> > +/* Call with hci_dev_lock only. */
>> >> > +static int hci_devcoredump_alloc(struct hci_dev *hdev, u32 size)
>> >> > +{
>> >> > +       hdev->dump.head =3D vmalloc(size);
>> >> > +       if (!hdev->dump.head)
>> >> > +               return -ENOMEM;
>> >> > +
>> >> > +       hdev->dump.alloc_size =3D size;
>> >> > +       hdev->dump.tail =3D hdev->dump.head;
>> >> > +       hdev->dump.end =3D hdev->dump.head + size;
>> >> > +
>> >> > +       hci_devcoredump_update_state(hdev, HCI_DEVCOREDUMP_IDLE);
>> >> > +
>> >> > +       return 0;
>> >> > +}
>> >> > +
>> >> > +/* Call with hci_dev_lock only. */
>> >> > +static bool hci_devcoredump_copy(struct hci_dev *hdev, char *buf, =
u32 size)
>> >> > +{
>> >> > +       if (hdev->dump.tail + size > hdev->dump.end)
>> >> > +               return false;
>> >> > +
>> >> > +       memcpy(hdev->dump.tail, buf, size);
>> >> > +       hdev->dump.tail +=3D size;
>> >> > +
>> >> > +       return true;
>> >> > +}
>> >> > +
>> >> > +/* Call with hci_dev_lock only. */
>> >> > +static bool hci_devcoredump_memset(struct hci_dev *hdev, u8 patter=
n, u32 len)
>> >> > +{
>> >> > +       if (hdev->dump.tail + len > hdev->dump.end)
>> >> > +               return false;
>> >> > +
>> >> > +       memset(hdev->dump.tail, pattern, len);
>> >> > +       hdev->dump.tail +=3D len;
>> >> > +
>> >> > +       return true;
>> >> > +}
>> >> > +
>> >> > +/* Call with hci_dev_lock only. */
>> >> > +static int hci_devcoredump_prepare(struct hci_dev *hdev, u32 dump_=
size)
>> >> > +{
>> >> > +       char *dump_hdr;
>> >> > +       int dump_hdr_size;
>> >> > +       u32 size;
>> >> > +       int err =3D 0;
>> >> > +
>> >> > +       dump_hdr =3D vmalloc(MAX_DEVCOREDUMP_HDR_SIZE);
>> >> > +       if (!dump_hdr) {
>> >> > +               err =3D -ENOMEM;
>> >> > +               goto hdr_free;
>> >> > +       }
>> >> > +
>> >> > +       dump_hdr_size =3D hci_devcoredump_mkheader(hdev, dump_hdr,
>> >> > +                                                MAX_DEVCOREDUMP_HD=
R_SIZE);
>> >> > +       size =3D dump_hdr_size + dump_size;
>> >> > +
>> >> > +       if (hci_devcoredump_alloc(hdev, size)) {
>> >> > +               err =3D -ENOMEM;
>> >> > +               goto hdr_free;
>> >> > +       }
>> >> > +
>> >> > +       /* Insert the device header */
>> >> > +       if (!hci_devcoredump_copy(hdev, dump_hdr, dump_hdr_size)) {
>> >> > +               bt_dev_err(hdev, "Failed to insert header");
>> >> > +               hci_devcoredump_free(hdev);
>> >> > +
>> >> > +               err =3D -ENOMEM;
>> >> > +               goto hdr_free;
>> >> > +       }
>> >> > +
>> >> > +hdr_free:
>> >> > +       if (dump_hdr)
>> >> > +               vfree(dump_hdr);
>> >> > +
>> >> > +       return err;
>> >> > +}
>> >> > +
>> >> > +/* Bluetooth devcoredump state machine.
>> >> > + *
>> >> > + * Devcoredump states:
>> >> > + *
>> >> > + *      HCI_DEVCOREDUMP_IDLE: The default state.
>> >> > + *
>> >> > + *      HCI_DEVCOREDUMP_ACTIVE: A devcoredump will be in this stat=
e once it has
>> >> > + *              been initialized using hci_devcoredump_init(). Onc=
e active, the
>> >> > + *              driver can append data using hci_devcoredump_appen=
d() or insert
>> >> > + *              a pattern using hci_devcoredump_append_pattern().
>> >> > + *
>> >> > + *      HCI_DEVCOREDUMP_DONE: Once the dump collection is complete=
, the drive
>> >> > + *              can signal the completion using hci_devcoredump_co=
mplete(). A
>> >> > + *              devcoredump is generated indicating the completion=
 event and
>> >> > + *              then the state machine is reset to the default sta=
te.
>> >> > + *
>> >> > + *      HCI_DEVCOREDUMP_ABORT: The driver can cancel ongoing dump =
collection in
>> >> > + *              case of any error using hci_devcoredump_abort(). A=
 devcoredump
>> >> > + *              is still generated with the available data indicat=
ing the abort
>> >> > + *              event and then the state machine is reset to the d=
efault state.
>> >> > + *
>> >> > + *      HCI_DEVCOREDUMP_TIMEOUT: A timeout timer for HCI_DEVCOREDU=
MP_TIMEOUT sec
>> >> > + *              is started during devcoredump initialization. Once=
 the timeout
>> >> > + *              occurs, the driver is notified, a devcoredump is g=
enerated with
>> >> > + *              the available data indicating the timeout event an=
d then the
>> >> > + *              state machine is reset to the default state.
>> >> > + *
>> >> > + * The driver must register using hci_devcoredump_register() befor=
e using the
>> >> > + * hci devcoredump APIs.
>> >> > + */
>> >> > +static void hci_devcoredump_rx(struct work_struct *work)
>> >> > +{
>> >> > +       struct hci_dev *hdev =3D container_of(work, struct hci_dev,=
 dump_rx);
>> >> > +       struct sk_buff *skb;
>> >> > +       struct hci_devcoredump_skb_pattern *pattern;
>> >> > +       u32 dump_size;
>> >> > +       int start_state;
>> >> > +
>> >> > +#define DBG_UNEXPECTED_STATE() \
>> >> > +               bt_dev_dbg(hdev, \
>> >> > +                          "Unexpected packet (%d) for state (%d). =
", \
>> >> > +                          hci_dmp_cb(skb)->pkt_type, hdev->dump.st=
ate)
>> >> > +
>> >> > +       while ((skb =3D skb_dequeue(&hdev->dump_q))) {
>> >> > +               hci_dev_lock(hdev);
>> >> > +               start_state =3D hdev->dump.state;
>> >> > +
>> >> > +               switch (hci_dmp_cb(skb)->pkt_type) {
>> >> > +               case HCI_DEVCOREDUMP_PKT_INIT:
>> >> > +                       if (hdev->dump.state !=3D HCI_DEVCOREDUMP_I=
DLE) {
>> >> > +                               DBG_UNEXPECTED_STATE();
>> >> > +                               goto loop_continue;
>> >> > +                       }
>> >> > +
>> >> > +                       if (skb->len !=3D sizeof(dump_size)) {
>> >> > +                               bt_dev_dbg(hdev, "Invalid dump init=
 pkt");
>> >> > +                               goto loop_continue;
>> >> > +                       }
>> >> > +
>> >> > +                       dump_size =3D *((u32 *)skb->data);
>> >> > +                       if (!dump_size) {
>> >> > +                               bt_dev_err(hdev, "Zero size dump in=
it pkt");
>> >> > +                               goto loop_continue;
>> >> > +                       }
>> >> > +
>> >> > +                       if (hci_devcoredump_prepare(hdev, dump_size=
)) {
>> >> > +                               bt_dev_err(hdev, "Failed to prepare=
 for dump");
>> >> > +                               goto loop_continue;
>> >> > +                       }
>> >> > +
>> >> > +                       hci_devcoredump_update_state(hdev,
>> >> > +                                                    HCI_DEVCOREDUM=
P_ACTIVE);
>> >> > +                       queue_delayed_work(hdev->workqueue, &hdev->=
dump_timeout,
>> >> > +                                          DEVCOREDUMP_TIMEOUT);
>> >> > +                       break;
>> >> > +
>> >> > +               case HCI_DEVCOREDUMP_PKT_SKB:
>> >> > +                       if (hdev->dump.state !=3D HCI_DEVCOREDUMP_A=
CTIVE) {
>> >> > +                               DBG_UNEXPECTED_STATE();
>> >> > +                               goto loop_continue;
>> >> > +                       }
>> >> > +
>> >> > +                       if (!hci_devcoredump_copy(hdev, skb->data, =
skb->len))
>> >> > +                               bt_dev_dbg(hdev, "Failed to insert =
skb");
>> >> > +                       break;
>> >> > +
>> >> > +               case HCI_DEVCOREDUMP_PKT_PATTERN:
>> >> > +                       if (hdev->dump.state !=3D HCI_DEVCOREDUMP_A=
CTIVE) {
>> >> > +                               DBG_UNEXPECTED_STATE();
>> >> > +                               goto loop_continue;
>> >> > +                       }
>> >> > +
>> >> > +                       if (skb->len !=3D sizeof(*pattern)) {
>> >> > +                               bt_dev_dbg(hdev, "Invalid pattern s=
kb");
>> >> > +                               goto loop_continue;
>> >> > +                       }
>> >> > +
>> >> > +                       pattern =3D (void *)skb->data;
>> >> > +
>> >> > +                       if (!hci_devcoredump_memset(hdev, pattern->=
pattern,
>> >> > +                                                   pattern->len))
>> >> > +                               bt_dev_dbg(hdev, "Failed to set pat=
tern");
>> >> > +                       break;
>> >> > +
>> >> > +               case HCI_DEVCOREDUMP_PKT_COMPLETE:
>> >> > +                       if (hdev->dump.state !=3D HCI_DEVCOREDUMP_A=
CTIVE) {
>> >> > +                               DBG_UNEXPECTED_STATE();
>> >> > +                               goto loop_continue;
>> >> > +                       }
>> >> > +
>> >> > +                       hci_devcoredump_update_state(hdev,
>> >> > +                                                    HCI_DEVCOREDUM=
P_DONE);
>> >> > +                       dump_size =3D hdev->dump.tail - hdev->dump.=
head;
>> >> > +
>> >> > +                       bt_dev_info(hdev,
>> >> > +                                   "Devcoredump complete with size=
 %u "
>> >> > +                                   "(expect %u)",
>> >> > +                                   dump_size, hdev->dump.alloc_siz=
e);
>> >> > +
>> >> > +                       dev_coredumpv(&hdev->dev, hdev->dump.head, =
dump_size,
>> >> > +                                     GFP_KERNEL);
>> >> > +                       break;
>> >> > +
>> >> > +               case HCI_DEVCOREDUMP_PKT_ABORT:
>> >> > +                       if (hdev->dump.state !=3D HCI_DEVCOREDUMP_A=
CTIVE) {
>> >> > +                               DBG_UNEXPECTED_STATE();
>> >> > +                               goto loop_continue;
>> >> > +                       }
>> >> > +
>> >> > +                       hci_devcoredump_update_state(hdev,
>> >> > +                                                    HCI_DEVCOREDUM=
P_ABORT);
>> >> > +                       dump_size =3D hdev->dump.tail - hdev->dump.=
head;
>> >> > +
>> >> > +                       bt_dev_info(hdev,
>> >> > +                                   "Devcoredump aborted with size =
%u "
>> >> > +                                   "(expect %u)",
>> >> > +                                   dump_size, hdev->dump.alloc_siz=
e);
>> >> > +
>> >> > +                       /* Emit a devcoredump with the available da=
ta */
>> >> > +                       dev_coredumpv(&hdev->dev, hdev->dump.head, =
dump_size,
>> >> > +                                     GFP_KERNEL);
>> >> > +                       break;
>> >> > +
>> >> > +               default:
>> >> > +                       bt_dev_dbg(hdev,
>> >> > +                                  "Unknown packet (%d) for state (=
%d). ",
>> >> > +                                  hci_dmp_cb(skb)->pkt_type, hdev-=
>dump.state);
>> >> > +                       break;
>> >> > +               }
>> >> > +
>> >> > +loop_continue:
>> >> > +               kfree_skb(skb);
>> >> > +               hci_dev_unlock(hdev);
>> >> > +
>> >> > +               if (start_state !=3D hdev->dump.state)
>> >> > +                       hci_devcoredump_notify(hdev, hdev->dump.sta=
te);
>> >> > +
>> >> > +               hci_dev_lock(hdev);
>> >> > +               if (hdev->dump.state =3D=3D HCI_DEVCOREDUMP_DONE ||
>> >> > +                   hdev->dump.state =3D=3D HCI_DEVCOREDUMP_ABORT)
>> >> > +                       hci_devcoredump_reset(hdev);
>> >> > +               hci_dev_unlock(hdev);
>> >> > +       }
>> >> > +}
>> >> > +
>> >> > +static void hci_devcoredump_timeout(struct work_struct *work)
>> >> > +{
>> >> > +       struct hci_dev *hdev =3D container_of(work, struct hci_dev,
>> >> > +                                           dump_timeout.work);
>> >> > +       u32 dump_size;
>> >> > +
>> >> > +       hci_devcoredump_notify(hdev, HCI_DEVCOREDUMP_TIMEOUT);
>> >> > +
>> >> > +       hci_dev_lock(hdev);
>> >> > +
>> >> > +       cancel_work_sync(&hdev->dump_rx);
>> >> > +
>> >> > +       hci_devcoredump_update_state(hdev, HCI_DEVCOREDUMP_TIMEOUT)=
;
>> >> > +       dump_size =3D hdev->dump.tail - hdev->dump.head;
>> >> > +       bt_dev_info(hdev, "Devcoredump timeout with size %u (expect=
 %u)",
>> >> > +                   dump_size, hdev->dump.alloc_size);
>> >> > +
>> >> > +       /* Emit a devcoredump with the available data */
>> >> > +       dev_coredumpv(&hdev->dev, hdev->dump.head, dump_size, GFP_K=
ERNEL);
>> >> > +
>> >> > +       hci_devcoredump_reset(hdev);
>> >> > +
>> >> > +       hci_dev_unlock(hdev);
>> >> > +}
>> >> > +
>> >> > +int hci_devcoredump_register(struct hci_dev *hdev, dmp_hdr_t dmp_h=
dr,
>> >> > +                            notify_change_t notify_change)
>> >> > +{
>> >> > +       /* driver must implement dmp_hdr() function for bluetooth d=
evcoredump */
>> >> > +       if (!dmp_hdr)
>> >> > +               return -EINVAL;
>> >> > +
>> >> > +       hci_dev_lock(hdev);
>> >> > +       hdev->dump.dmp_hdr =3D dmp_hdr;
>> >> > +       hdev->dump.notify_change =3D notify_change;
>> >> > +       hdev->dump.supported =3D true;
>> >> > +       hci_dev_unlock(hdev);
>> >> > +
>> >> > +       return 0;
>> >> > +}
>> >> > +EXPORT_SYMBOL(hci_devcoredump_register);
>> >> > +
>> >> > +int hci_devcoredump_init(struct hci_dev *hdev, u32 dmp_size)
>> >> > +{
>> >> > +       struct sk_buff *skb =3D NULL;
>> >> > +
>> >> > +       if (!hdev->dump.supported)
>> >> > +               return -EOPNOTSUPP;
>> >> > +
>> >> > +       skb =3D alloc_skb(sizeof(dmp_size), GFP_ATOMIC);
>> >> > +       if (!skb) {
>> >> > +               bt_dev_err(hdev, "Failed to allocate devcoredump in=
it");
>> >> > +               return -ENOMEM;
>> >> > +       }
>> >> > +
>> >> > +       hci_dmp_cb(skb)->pkt_type =3D HCI_DEVCOREDUMP_PKT_INIT;
>> >> > +       skb_put_data(skb, &dmp_size, sizeof(dmp_size));
>> >> > +
>> >> > +       skb_queue_tail(&hdev->dump_q, skb);
>> >> > +       queue_work(hdev->workqueue, &hdev->dump_rx);
>> >> > +
>> >> > +       return 0;
>> >> > +}
>> >> > +EXPORT_SYMBOL(hci_devcoredump_init);
>> >> > +
>> >> > +int hci_devcoredump_append(struct hci_dev *hdev, struct sk_buff *s=
kb)
>> >> > +{
>> >> > +       if (!skb)
>> >> > +               return -ENOMEM;
>> >> > +
>> >> > +       if (!hdev->dump.supported) {
>> >> > +               kfree_skb(skb);
>> >> > +               return -EOPNOTSUPP;
>> >> > +       }
>> >> > +
>> >> > +       hci_dmp_cb(skb)->pkt_type =3D HCI_DEVCOREDUMP_PKT_SKB;
>> >> > +
>> >> > +       skb_queue_tail(&hdev->dump_q, skb);
>> >> > +       queue_work(hdev->workqueue, &hdev->dump_rx);
>> >> > +
>> >> > +       return 0;
>> >> > +}
>> >> > +EXPORT_SYMBOL(hci_devcoredump_append);
>> >> > +
>> >> > +int hci_devcoredump_append_pattern(struct hci_dev *hdev, u8 patter=
n, u32 len)
>> >> > +{
>> >> > +       struct hci_devcoredump_skb_pattern p;
>> >> > +       struct sk_buff *skb =3D NULL;
>> >> > +
>> >> > +       if (!hdev->dump.supported)
>> >> > +               return -EOPNOTSUPP;
>> >> > +
>> >> > +       skb =3D alloc_skb(sizeof(p), GFP_ATOMIC);
>> >> > +       if (!skb) {
>> >> > +               bt_dev_err(hdev, "Failed to allocate devcoredump pa=
ttern");
>> >> > +               return -ENOMEM;
>> >> > +       }
>> >> > +
>> >> > +       p.pattern =3D pattern;
>> >> > +       p.len =3D len;
>> >> > +
>> >> > +       hci_dmp_cb(skb)->pkt_type =3D HCI_DEVCOREDUMP_PKT_PATTERN;
>> >> > +       skb_put_data(skb, &p, sizeof(p));
>> >> > +
>> >> > +       skb_queue_tail(&hdev->dump_q, skb);
>> >> > +       queue_work(hdev->workqueue, &hdev->dump_rx);
>> >> > +
>> >> > +       return 0;
>> >> > +}
>> >> > +EXPORT_SYMBOL(hci_devcoredump_append_pattern);
>> >> > +
>> >> > +int hci_devcoredump_complete(struct hci_dev *hdev)
>> >> > +{
>> >> > +       struct sk_buff *skb =3D NULL;
>> >> > +
>> >> > +       if (!hdev->dump.supported)
>> >> > +               return -EOPNOTSUPP;
>> >> > +
>> >> > +       skb =3D alloc_skb(0, GFP_ATOMIC);
>> >> > +       if (!skb) {
>> >> > +               bt_dev_err(hdev, "Failed to allocate devcoredump co=
mplete");
>> >> > +               return -ENOMEM;
>> >> > +       }
>> >> > +
>> >> > +       hci_dmp_cb(skb)->pkt_type =3D HCI_DEVCOREDUMP_PKT_COMPLETE;
>> >> > +
>> >> > +       skb_queue_tail(&hdev->dump_q, skb);
>> >> > +       queue_work(hdev->workqueue, &hdev->dump_rx);
>> >> > +
>> >> > +       return 0;
>> >> > +}
>> >> > +EXPORT_SYMBOL(hci_devcoredump_complete);
>> >> > +
>> >> > +int hci_devcoredump_abort(struct hci_dev *hdev)
>> >> > +{
>> >> > +       struct sk_buff *skb =3D NULL;
>> >> > +
>> >> > +       if (!hdev->dump.supported)
>> >> > +               return -EOPNOTSUPP;
>> >> > +
>> >> > +       skb =3D alloc_skb(0, GFP_ATOMIC);
>> >> > +       if (!skb) {
>> >> > +               bt_dev_err(hdev, "Failed to allocate devcoredump ab=
ort");
>> >> > +               return -ENOMEM;
>> >> > +       }
>> >> > +
>> >> > +       hci_dmp_cb(skb)->pkt_type =3D HCI_DEVCOREDUMP_PKT_ABORT;
>> >> > +
>> >> > +       skb_queue_tail(&hdev->dump_q, skb);
>> >> > +       queue_work(hdev->workqueue, &hdev->dump_rx);
>> >> > +
>> >> > +       return 0;
>> >> > +}
>> >> > +EXPORT_SYMBOL(hci_devcoredump_abort);
>> >> > +
>> >> >  /* Alloc HCI device */
>> >> >  struct hci_dev *hci_alloc_dev_priv(int sizeof_priv)
>> >> >  {
>> >> > @@ -2511,14 +3004,17 @@ struct hci_dev *hci_alloc_dev_priv(int size=
of_priv)
>> >> >         INIT_WORK(&hdev->tx_work, hci_tx_work);
>> >> >         INIT_WORK(&hdev->power_on, hci_power_on);
>> >> >         INIT_WORK(&hdev->error_reset, hci_error_reset);
>> >> > +       INIT_WORK(&hdev->dump_rx, hci_devcoredump_rx);
>> >> >
>> >> >         hci_cmd_sync_init(hdev);
>> >> >
>> >> >         INIT_DELAYED_WORK(&hdev->power_off, hci_power_off);
>> >> > +       INIT_DELAYED_WORK(&hdev->dump_timeout, hci_devcoredump_time=
out);
>> >> >
>> >> >         skb_queue_head_init(&hdev->rx_q);
>> >> >         skb_queue_head_init(&hdev->cmd_q);
>> >> >         skb_queue_head_init(&hdev->raw_q);
>> >> > +       skb_queue_head_init(&hdev->dump_q);
>>
>> Perhaps it is a better idea to have this fields as part of a dedicated
>> struct for coredumps e.g. struct hci_devcoredump, also perhaps they
>> need to be conditional to CONFIG_DEV_COREDUMP otherwise it just adds
>> things like a delayed work that will never going to be used, this just
>> reinforces the need of proper CI tests so we can exercise this code
>> with the likes of the emulator.
>
> Done. I just submitted a v2 patch series with all above changes. Please t=
ake a look.
>
>>
>>
>> >> >         init_waitqueue_head(&hdev->req_wait_q);
>> >> >
>> >> > diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
>> >> > index 8f4c5698913d..ec03fa871ef0 100644
>> >> > --- a/net/bluetooth/hci_sync.c
>> >> > +++ b/net/bluetooth/hci_sync.c
>> >> > @@ -3877,6 +3877,8 @@ int hci_dev_open_sync(struct hci_dev *hdev)
>> >> >                 goto done;
>> >> >         }
>> >> >
>> >> > +       hci_devcoredump_reset(hdev);
>> >> > +
>> >> >         set_bit(HCI_RUNNING, &hdev->flags);
>> >> >         hci_sock_dev_event(hdev, HCI_DEV_OPEN);
>> >> >
>> >> > --
>> >> > 2.35.1.894.gb6a874cedc-goog
>> >> >
>> >>
>> >>
>> >> --
>> >> Luiz Augusto von Dentz
>> >
>> > Regards,
>> > Manish.
>>
>>
>>
>> --
>> Luiz Augusto von Dentz
>
> Regards,
> Manish.



--=20
Luiz Augusto von Dentz
