Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 578CB56AF9B
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 03:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237048AbiGHAf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 20:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237018AbiGHAfZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 20:35:25 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A68B4D157;
        Thu,  7 Jul 2022 17:35:23 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id bf9so10600460lfb.13;
        Thu, 07 Jul 2022 17:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+FPDA9bpaQNxNay43TNVS3DDzoTOq/wXCfl3H+fiAR4=;
        b=CoBKaqbtvrcNGCDdvhwGOug/bNENd37YzHSLmd4wFY8hVY/0ER+VTIDdpxVi1QpSO7
         9hpDfQtTiRrw8zjII7AV9rm9OE5OBqHydS+4618WY+1vBTkWr49LYgyft3j/6P89oZZ+
         kTlqqFxc+/0qFPdH2cu8SjRW5s+BAQfbLUWy3t+bJax1DtXcJ8UG2vELQnenJ9hxu48E
         5GKeFWcHpybntCvx1rVfh4f1KCICmZ25kHiz2r5+GB6yC1OlHhKO8UxKVax9bxvqNsGh
         PdKsGkAlLVMYAQmKW9ZFxqmy7H5ifnOEwZ/L0ZLSU5uiKyRSbbGtYTeKmzE8U1uRg4bo
         Nt3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+FPDA9bpaQNxNay43TNVS3DDzoTOq/wXCfl3H+fiAR4=;
        b=bCsq7U6hWO/D987sb9IBUcTurgbdW//kjOxz8g6Sf5KX1e6kuLciam2TUKAfwsNUVg
         +JiJ/maotwULmSVg2L48XbXsFM/8aX4DY2PVNWUjq+KEOkSe4RM3XL+KYn71gZTq050c
         Tki98soMioN15D+JiwgLdIMmksIfxaM6Gvbxl2T4J2ZI2lMzFijlaojPDy7mVeDqdP5L
         xQPzA8OrWjz6EOmRtgb759U/+So9kpvZYKxE+1ZSsHMKQwpOVIVLo/UdpuHd3weEFynY
         UYSSDqo2V//bkUySgX6KEqAmgj8xergMG6LVQOz74dkWOXfXbavqM35CQjHhSuvhhtuq
         nBmA==
X-Gm-Message-State: AJIora+hint+on4angZavZcihcRWXX6mhD7XSlr+/Qd45ZmUNXh4Bqbh
        QYfFuvE4B1RMi84qRtVvoCI+kPztg4ubtVdrbVPugxiX
X-Google-Smtp-Source: AGRyM1t5m32p0KnvzP/URVtSroili6PPvSNhkQV/VEmwv77Af9SVxVU9AcqksZDeEjAJ9fitRK+1gzz8NxuDolm2hyQ=
X-Received: by 2002:a05:6512:22c8:b0:488:e69b:9311 with SMTP id
 g8-20020a05651222c800b00488e69b9311mr528666lfu.564.1657240520992; Thu, 07 Jul
 2022 17:35:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220623123549.v2.1.Iaf638bb9f885f5880ab1b4e7ae2f73dd53a54661@changeid>
 <CABBYNZKMNGu1K23AoiW+1yfxpBSkFqUsJWNNMhA6+P5hqic9ew@mail.gmail.com> <CAGPPCLCq7DtKJ-mQqzZEgFrc6UOPUPDssap7bYuayr26VDdi4g@mail.gmail.com>
In-Reply-To: <CAGPPCLCq7DtKJ-mQqzZEgFrc6UOPUPDssap7bYuayr26VDdi4g@mail.gmail.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Thu, 7 Jul 2022 17:35:09 -0700
Message-ID: <CABBYNZJr3EGdLODS6oJGEoNZ10g44nFSa=gDAeGZyZHiX0=dfw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] Bluetooth: Add support for devcoredump
To:     Manish Mandlik <mmandlik@google.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        ChromeOS Bluetooth Upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
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

On Thu, Jul 7, 2022 at 3:29 PM Manish Mandlik <mmandlik@google.com> wrote:
>
> Hi Luiz,
>
>
> On Wed, Jun 29, 2022 at 5:07 PM Luiz Augusto von Dentz <luiz.dentz@gmail.=
com> wrote:
>>
>> Hi Manish,
>>
>> On Thu, Jun 23, 2022 at 12:38 PM Manish Mandlik <mmandlik@google.com> wr=
ote:
>> >
>> > From: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
>> >
>> > Add devcoredump APIs to hci core so that drivers only have to provide
>> > the dump skbs instead of managing the synchronization and timeouts.
>> >
>> > The devcoredump APIs should be used in the following manner:
>> >  - hci_devcoredump_init is called to allocate the dump.
>> >  - hci_devcoredump_append is called to append any skbs with dump data
>> >    OR hci_devcoredump_append_pattern is called to insert a pattern.
>> >  - hci_devcoredump_complete is called when all dump packets have been
>> >    sent OR hci_devcoredump_abort is called to indicate an error and
>> >    cancel an ongoing dump collection.
>> >
>> > The high level APIs just prepare some skbs with the appropriate data a=
nd
>> > queue it for the dump to process. Packets part of the crashdump can be
>> > intercepted in the driver in interrupt context and forwarded directly =
to
>> > the devcoredump APIs.
>> >
>> > Internally, there are 5 states for the dump: idle, active, complete,
>> > abort and timeout. A devcoredump will only be in active state after it
>> > has been initialized. Once active, it accepts data to be appended,
>> > patterns to be inserted (i.e. memset) and a completion event or an abo=
rt
>> > event to generate a devcoredump. The timeout is initialized at the sam=
e
>> > time the dump is initialized (defaulting to 10s) and will be cleared
>> > either when the timeout occurs or the dump is complete or aborted.
>> >
>> > Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
>> > Signed-off-by: Manish Mandlik <mmandlik@google.com>
>> > Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
>> > ---
>> >
>> > Changes in v2:
>> > - Move hci devcoredump implementation to new files
>> > - Move dump queue and dump work to hci_devcoredump struct
>> > - Add CONFIG_DEV_COREDUMP conditional compile
>>
>> Looks like you didn't add an experimental UUID for enabling it, it
>> should be per index and we mark as supported when the driver supports
>> it then userspace can mark it to be used via main.conf so we can
>> properly experiment with it before marking it as stable.
>
> We want to keep bluetooth devcoredump implementation to kernel only and n=
ot have any dependency on the userspace bluez. But I agree that we should n=
ot have it enabled by default without experimenting. So, I have added anoth=
er attribute to enable/disable hci devcoredump and the default state is set=
 to disabled. This can be enabled via bluetooth sysfs entry `enable_coredum=
p`. I have sent a v3 series with this new patch to add a sysfs entry. Pleas=
e take a look. I was anyway working on a mechanism to enable/disable devcor=
edump and I feel this could be the right way. Please let me know your thoug=
hts. Thanks!

Not sure I understand about not depending on userspace BlueZ, I mean
we might need a userspace interface to enable it or are you suggesting
to not use the MGMT interface for enabling it? If there is a is a
generic method for enabling devcoredumps then yes that is probably
preferable otherwise if is bluetooth specific that is what MGMT
interface is for.

>
>>
>> >
>> >  include/net/bluetooth/coredump.h | 109 +++++++
>> >  include/net/bluetooth/hci_core.h |   5 +
>> >  net/bluetooth/Makefile           |   2 +
>> >  net/bluetooth/coredump.c         | 504 ++++++++++++++++++++++++++++++=
+
>> >  net/bluetooth/hci_core.c         |   9 +
>> >  net/bluetooth/hci_sync.c         |   2 +
>> >  6 files changed, 631 insertions(+)
>> >  create mode 100644 include/net/bluetooth/coredump.h
>> >  create mode 100644 net/bluetooth/coredump.c
>> >
>> > diff --git a/include/net/bluetooth/coredump.h b/include/net/bluetooth/=
coredump.h
>> > new file mode 100644
>> > index 000000000000..73601c409c6e
>> > --- /dev/null
>> > +++ b/include/net/bluetooth/coredump.h
>> > @@ -0,0 +1,109 @@
>> > +// SPDX-License-Identifier: GPL-2.0-only
>> > +/*
>> > + * Copyright (C) 2022 Google Corporation
>> > + */
>> > +
>> > +#ifndef __COREDUMP_H
>> > +#define __COREDUMP_H
>> > +
>> > +#define DEVCOREDUMP_TIMEOUT    msecs_to_jiffies(10000) /* 10 sec */
>> > +
>> > +typedef int  (*dmp_hdr_t)(struct hci_dev *hdev, char *buf, size_t siz=
e);
>> > +typedef void (*notify_change_t)(struct hci_dev *hdev, int state);
>> > +
>> > +/* struct hci_devcoredump - Devcoredump state
>> > + *
>> > + * @supported: Indicates if FW dump collection is supported by driver
>> > + * @state: Current state of dump collection
>> > + * @alloc_size: Total size of the dump
>> > + * @head: Start of the dump
>> > + * @tail: Pointer to current end of dump
>> > + * @end: head + alloc_size for easy comparisons
>> > + *
>> > + * @dump_q: Dump queue for state machine to process
>> > + * @dump_rx: Devcoredump state machine work
>> > + * @dump_timeout: Devcoredump timeout work
>> > + *
>> > + * @dmp_hdr: Create a dump header to identify controller/fw/driver in=
fo
>> > + * @notify_change: Notify driver when devcoredump state has changed
>> > + */
>> > +struct hci_devcoredump {
>> > +       bool            supported;
>> > +
>> > +       enum devcoredump_state {
>> > +               HCI_DEVCOREDUMP_IDLE,
>> > +               HCI_DEVCOREDUMP_ACTIVE,
>> > +               HCI_DEVCOREDUMP_DONE,
>> > +               HCI_DEVCOREDUMP_ABORT,
>> > +               HCI_DEVCOREDUMP_TIMEOUT
>> > +       } state;
>> > +
>> > +       u32             alloc_size;
>> > +       char            *head;
>> > +       char            *tail;
>> > +       char            *end;
>> > +
>> > +       struct sk_buff_head     dump_q;
>> > +       struct work_struct      dump_rx;
>> > +       struct delayed_work     dump_timeout;
>> > +
>> > +       dmp_hdr_t       dmp_hdr;
>> > +       notify_change_t notify_change;
>> > +};
>> > +
>> > +#ifdef CONFIG_DEV_COREDUMP
>> > +
>> > +void hci_devcoredump_reset(struct hci_dev *hdev);
>> > +void hci_devcoredump_rx(struct work_struct *work);
>> > +void hci_devcoredump_timeout(struct work_struct *work);
>> > +int hci_devcoredump_register(struct hci_dev *hdev, dmp_hdr_t dmp_hdr,
>> > +                            notify_change_t notify_change);
>> > +int hci_devcoredump_init(struct hci_dev *hdev, u32 dmp_size);
>> > +int hci_devcoredump_append(struct hci_dev *hdev, struct sk_buff *skb)=
;
>> > +int hci_devcoredump_append_pattern(struct hci_dev *hdev, u8 pattern, =
u32 len);
>> > +int hci_devcoredump_complete(struct hci_dev *hdev);
>> > +int hci_devcoredump_abort(struct hci_dev *hdev);
>> > +
>> > +#else
>> > +
>> > +static inline void hci_devcoredump_reset(struct hci_dev *hdev) {}
>> > +static inline void hci_devcoredump_rx(struct work_struct *work) {}
>> > +static inline void hci_devcoredump_timeout(struct work_struct *work) =
{}
>> > +
>> > +static inline int hci_devcoredump_register(struct hci_dev *hdev,
>> > +                                          dmp_hdr_t dmp_hdr,
>> > +                                          notify_change_t notify_chan=
ge)
>> > +{
>> > +       return -EOPNOTSUPP;
>> > +}
>> > +
>> > +static inline int hci_devcoredump_init(struct hci_dev *hdev, u32 dmp_=
size)
>> > +{
>> > +       return -EOPNOTSUPP;
>> > +}
>> > +
>> > +static inline int hci_devcoredump_append(struct hci_dev *hdev,
>> > +                                        struct sk_buff *skb)
>> > +{
>> > +       return -EOPNOTSUPP;
>> > +}
>> > +
>> > +static inline int hci_devcoredump_append_pattern(struct hci_dev *hdev=
,
>> > +                                                u8 pattern, u32 len)
>> > +{
>> > +       return -EOPNOTSUPP;
>> > +}
>> > +
>> > +static inline int hci_devcoredump_complete(struct hci_dev *hdev)
>> > +{
>> > +       return -EOPNOTSUPP;
>> > +}
>> > +
>> > +static inline int hci_devcoredump_abort(struct hci_dev *hdev)
>> > +{
>> > +       return -EOPNOTSUPP;
>> > +}
>> > +
>> > +#endif /* CONFIG_DEV_COREDUMP */
>> > +
>> > +#endif /* __COREDUMP_H */
>> > diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/=
hci_core.h
>> > index 15237ee5f761..9ccc034c8fde 100644
>> > --- a/include/net/bluetooth/hci_core.h
>> > +++ b/include/net/bluetooth/hci_core.h
>> > @@ -32,6 +32,7 @@
>> >  #include <net/bluetooth/hci.h>
>> >  #include <net/bluetooth/hci_sync.h>
>> >  #include <net/bluetooth/hci_sock.h>
>> > +#include <net/bluetooth/coredump.h>
>> >
>> >  /* HCI priority */
>> >  #define HCI_PRIO_MAX   7
>> > @@ -582,6 +583,10 @@ struct hci_dev {
>> >         const char              *fw_info;
>> >         struct dentry           *debugfs;
>> >
>> > +#ifdef CONFIG_DEV_COREDUMP
>> > +       struct hci_devcoredump  dump;
>> > +#endif
>> > +
>> >         struct device           dev;
>> >
>> >         struct rfkill           *rfkill;
>> > diff --git a/net/bluetooth/Makefile b/net/bluetooth/Makefile
>> > index a52bba8500e1..4e894e452869 100644
>> > --- a/net/bluetooth/Makefile
>> > +++ b/net/bluetooth/Makefile
>> > @@ -17,6 +17,8 @@ bluetooth-y :=3D af_bluetooth.o hci_core.o hci_conn.=
o hci_event.o mgmt.o \
>> >         ecdh_helper.o hci_request.o mgmt_util.o mgmt_config.o hci_code=
c.o \
>> >         eir.o hci_sync.o
>> >
>> > +bluetooth-$(CONFIG_DEV_COREDUMP) +=3D coredump.o
>> > +
>> >  bluetooth-$(CONFIG_BT_BREDR) +=3D sco.o
>> >  bluetooth-$(CONFIG_BT_HS) +=3D a2mp.o amp.o
>> >  bluetooth-$(CONFIG_BT_LEDS) +=3D leds.o
>> > diff --git a/net/bluetooth/coredump.c b/net/bluetooth/coredump.c
>> > new file mode 100644
>> > index 000000000000..43c355cd7ad3
>> > --- /dev/null
>> > +++ b/net/bluetooth/coredump.c
>> > @@ -0,0 +1,504 @@
>> > +// SPDX-License-Identifier: GPL-2.0-only
>> > +/*
>> > + * Copyright (C) 2022 Google Corporation
>> > + */
>> > +
>> > +#include <linux/devcoredump.h>
>> > +
>> > +#include <net/bluetooth/bluetooth.h>
>> > +#include <net/bluetooth/hci_core.h>
>> > +
>> > +enum hci_devcoredump_pkt_type {
>> > +       HCI_DEVCOREDUMP_PKT_INIT,
>> > +       HCI_DEVCOREDUMP_PKT_SKB,
>> > +       HCI_DEVCOREDUMP_PKT_PATTERN,
>> > +       HCI_DEVCOREDUMP_PKT_COMPLETE,
>> > +       HCI_DEVCOREDUMP_PKT_ABORT,
>> > +};
>> > +
>> > +struct hci_devcoredump_skb_cb {
>> > +       u16 pkt_type;
>> > +};
>> > +
>> > +struct hci_devcoredump_skb_pattern {
>> > +       u8 pattern;
>> > +       u32 len;
>> > +} __packed;
>> > +
>> > +#define hci_dmp_cb(skb)        ((struct hci_devcoredump_skb_cb *)((sk=
b)->cb))
>> > +
>> > +#define MAX_DEVCOREDUMP_HDR_SIZE       512     /* bytes */
>> > +
>> > +static int hci_devcoredump_update_hdr_state(char *buf, size_t size, i=
nt state)
>> > +{
>> > +       if (!buf)
>> > +               return 0;
>> > +
>> > +       return snprintf(buf, size, "Bluetooth devcoredump\nState: %d\n=
", state);
>> > +}
>> > +
>> > +/* Call with hci_dev_lock only. */
>> > +static int hci_devcoredump_update_state(struct hci_dev *hdev, int sta=
te)
>> > +{
>> > +       hdev->dump.state =3D state;
>> > +
>> > +       return hci_devcoredump_update_hdr_state(hdev->dump.head,
>> > +                                               hdev->dump.alloc_size,=
 state);
>> > +}
>> > +
>> > +static int hci_devcoredump_mkheader(struct hci_dev *hdev, char *buf,
>> > +                                   size_t buf_size)
>> > +{
>> > +       char *ptr =3D buf;
>> > +       size_t rem =3D buf_size;
>> > +       size_t read =3D 0;
>> > +
>> > +       read =3D hci_devcoredump_update_hdr_state(ptr, rem, HCI_DEVCOR=
EDUMP_IDLE);
>> > +       read +=3D 1; /* update_hdr_state adds \0 at the end upon state=
 rewrite */
>> > +       rem -=3D read;
>> > +       ptr +=3D read;
>> > +
>> > +       if (hdev->dump.dmp_hdr) {
>> > +               /* dmp_hdr() should return number of bytes written */
>> > +               read =3D hdev->dump.dmp_hdr(hdev, ptr, rem);
>> > +               rem -=3D read;
>> > +               ptr +=3D read;
>> > +       }
>> > +
>> > +       read =3D snprintf(ptr, rem, "--- Start dump ---\n");
>> > +       rem -=3D read;
>> > +       ptr +=3D read;
>> > +
>> > +       return buf_size - rem;
>> > +}
>> > +
>> > +/* Do not call with hci_dev_lock since this calls driver code. */
>> > +static void hci_devcoredump_notify(struct hci_dev *hdev, int state)
>> > +{
>> > +       if (hdev->dump.notify_change)
>> > +               hdev->dump.notify_change(hdev, state);
>> > +}
>> > +
>> > +/* Call with hci_dev_lock only. */
>> > +void hci_devcoredump_reset(struct hci_dev *hdev)
>> > +{
>> > +       hdev->dump.head =3D NULL;
>> > +       hdev->dump.tail =3D NULL;
>> > +       hdev->dump.alloc_size =3D 0;
>> > +
>> > +       hci_devcoredump_update_state(hdev, HCI_DEVCOREDUMP_IDLE);
>> > +
>> > +       cancel_delayed_work(&hdev->dump.dump_timeout);
>> > +       skb_queue_purge(&hdev->dump.dump_q);
>> > +}
>> > +
>> > +/* Call with hci_dev_lock only. */
>> > +static void hci_devcoredump_free(struct hci_dev *hdev)
>> > +{
>> > +       if (hdev->dump.head)
>> > +               vfree(hdev->dump.head);
>> > +
>> > +       hci_devcoredump_reset(hdev);
>> > +}
>> > +
>> > +/* Call with hci_dev_lock only. */
>> > +static int hci_devcoredump_alloc(struct hci_dev *hdev, u32 size)
>> > +{
>> > +       hdev->dump.head =3D vmalloc(size);
>> > +       if (!hdev->dump.head)
>> > +               return -ENOMEM;
>> > +
>> > +       hdev->dump.alloc_size =3D size;
>> > +       hdev->dump.tail =3D hdev->dump.head;
>> > +       hdev->dump.end =3D hdev->dump.head + size;
>> > +
>> > +       hci_devcoredump_update_state(hdev, HCI_DEVCOREDUMP_IDLE);
>> > +
>> > +       return 0;
>> > +}
>> > +
>> > +/* Call with hci_dev_lock only. */
>> > +static bool hci_devcoredump_copy(struct hci_dev *hdev, char *buf, u32=
 size)
>> > +{
>> > +       if (hdev->dump.tail + size > hdev->dump.end)
>> > +               return false;
>> > +
>> > +       memcpy(hdev->dump.tail, buf, size);
>> > +       hdev->dump.tail +=3D size;
>> > +
>> > +       return true;
>> > +}
>> > +
>> > +/* Call with hci_dev_lock only. */
>> > +static bool hci_devcoredump_memset(struct hci_dev *hdev, u8 pattern, =
u32 len)
>> > +{
>> > +       if (hdev->dump.tail + len > hdev->dump.end)
>> > +               return false;
>> > +
>> > +       memset(hdev->dump.tail, pattern, len);
>> > +       hdev->dump.tail +=3D len;
>> > +
>> > +       return true;
>> > +}
>> > +
>> > +/* Call with hci_dev_lock only. */
>> > +static int hci_devcoredump_prepare(struct hci_dev *hdev, u32 dump_siz=
e)
>> > +{
>> > +       char *dump_hdr;
>> > +       int dump_hdr_size;
>> > +       u32 size;
>> > +       int err =3D 0;
>> > +
>> > +       dump_hdr =3D vmalloc(MAX_DEVCOREDUMP_HDR_SIZE);
>> > +       if (!dump_hdr) {
>> > +               err =3D -ENOMEM;
>> > +               goto hdr_free;
>> > +       }
>> > +
>> > +       dump_hdr_size =3D hci_devcoredump_mkheader(hdev, dump_hdr,
>> > +                                                MAX_DEVCOREDUMP_HDR_S=
IZE);
>> > +       size =3D dump_hdr_size + dump_size;
>> > +
>> > +       if (hci_devcoredump_alloc(hdev, size)) {
>> > +               err =3D -ENOMEM;
>> > +               goto hdr_free;
>> > +       }
>> > +
>> > +       /* Insert the device header */
>> > +       if (!hci_devcoredump_copy(hdev, dump_hdr, dump_hdr_size)) {
>> > +               bt_dev_err(hdev, "Failed to insert header");
>> > +               hci_devcoredump_free(hdev);
>> > +
>> > +               err =3D -ENOMEM;
>> > +               goto hdr_free;
>> > +       }
>> > +
>> > +hdr_free:
>> > +       if (dump_hdr)
>> > +               vfree(dump_hdr);
>> > +
>> > +       return err;
>> > +}
>> > +
>> > +/* Bluetooth devcoredump state machine.
>> > + *
>> > + * Devcoredump states:
>> > + *
>> > + *      HCI_DEVCOREDUMP_IDLE: The default state.
>> > + *
>> > + *      HCI_DEVCOREDUMP_ACTIVE: A devcoredump will be in this state o=
nce it has
>> > + *              been initialized using hci_devcoredump_init(). Once a=
ctive, the
>> > + *              driver can append data using hci_devcoredump_append()=
 or insert
>> > + *              a pattern using hci_devcoredump_append_pattern().
>> > + *
>> > + *      HCI_DEVCOREDUMP_DONE: Once the dump collection is complete, t=
he drive
>> > + *              can signal the completion using hci_devcoredump_compl=
ete(). A
>> > + *              devcoredump is generated indicating the completion ev=
ent and
>> > + *              then the state machine is reset to the default state.
>> > + *
>> > + *      HCI_DEVCOREDUMP_ABORT: The driver can cancel ongoing dump col=
lection in
>> > + *              case of any error using hci_devcoredump_abort(). A de=
vcoredump
>> > + *              is still generated with the available data indicating=
 the abort
>> > + *              event and then the state machine is reset to the defa=
ult state.
>> > + *
>> > + *      HCI_DEVCOREDUMP_TIMEOUT: A timeout timer for HCI_DEVCOREDUMP_=
TIMEOUT sec
>> > + *              is started during devcoredump initialization. Once th=
e timeout
>> > + *              occurs, the driver is notified, a devcoredump is gene=
rated with
>> > + *              the available data indicating the timeout event and t=
hen the
>> > + *              state machine is reset to the default state.
>> > + *
>> > + * The driver must register using hci_devcoredump_register() before u=
sing the
>> > + * hci devcoredump APIs.
>> > + */
>> > +void hci_devcoredump_rx(struct work_struct *work)
>> > +{
>> > +       struct hci_dev *hdev =3D container_of(work, struct hci_dev, du=
mp.dump_rx);
>> > +       struct sk_buff *skb;
>> > +       struct hci_devcoredump_skb_pattern *pattern;
>> > +       u32 dump_size;
>> > +       int start_state;
>> > +
>> > +#define DBG_UNEXPECTED_STATE() \
>> > +               bt_dev_dbg(hdev, \
>> > +                          "Unexpected packet (%d) for state (%d). ", =
\
>> > +                          hci_dmp_cb(skb)->pkt_type, hdev->dump.state=
)
>> > +
>> > +       while ((skb =3D skb_dequeue(&hdev->dump.dump_q))) {
>> > +               hci_dev_lock(hdev);
>> > +               start_state =3D hdev->dump.state;
>> > +
>> > +               switch (hci_dmp_cb(skb)->pkt_type) {
>> > +               case HCI_DEVCOREDUMP_PKT_INIT:
>> > +                       if (hdev->dump.state !=3D HCI_DEVCOREDUMP_IDLE=
) {
>> > +                               DBG_UNEXPECTED_STATE();
>> > +                               goto loop_continue;
>> > +                       }
>> > +
>> > +                       if (skb->len !=3D sizeof(dump_size)) {
>> > +                               bt_dev_dbg(hdev, "Invalid dump init pk=
t");
>> > +                               goto loop_continue;
>> > +                       }
>> > +
>> > +                       dump_size =3D *((u32 *)skb->data);
>> > +                       if (!dump_size) {
>> > +                               bt_dev_err(hdev, "Zero size dump init =
pkt");
>> > +                               goto loop_continue;
>> > +                       }
>> > +
>> > +                       if (hci_devcoredump_prepare(hdev, dump_size)) =
{
>> > +                               bt_dev_err(hdev, "Failed to prepare fo=
r dump");
>> > +                               goto loop_continue;
>> > +                       }
>> > +
>> > +                       hci_devcoredump_update_state(hdev,
>> > +                                                    HCI_DEVCOREDUMP_A=
CTIVE);
>> > +                       queue_delayed_work(hdev->workqueue,
>> > +                                          &hdev->dump.dump_timeout,
>> > +                                          DEVCOREDUMP_TIMEOUT);
>> > +                       break;
>> > +
>> > +               case HCI_DEVCOREDUMP_PKT_SKB:
>> > +                       if (hdev->dump.state !=3D HCI_DEVCOREDUMP_ACTI=
VE) {
>> > +                               DBG_UNEXPECTED_STATE();
>> > +                               goto loop_continue;
>> > +                       }
>> > +
>> > +                       if (!hci_devcoredump_copy(hdev, skb->data, skb=
->len))
>> > +                               bt_dev_dbg(hdev, "Failed to insert skb=
");
>> > +                       break;
>> > +
>> > +               case HCI_DEVCOREDUMP_PKT_PATTERN:
>> > +                       if (hdev->dump.state !=3D HCI_DEVCOREDUMP_ACTI=
VE) {
>> > +                               DBG_UNEXPECTED_STATE();
>> > +                               goto loop_continue;
>> > +                       }
>> > +
>> > +                       if (skb->len !=3D sizeof(*pattern)) {
>> > +                               bt_dev_dbg(hdev, "Invalid pattern skb"=
);
>> > +                               goto loop_continue;
>> > +                       }
>> > +
>> > +                       pattern =3D (void *)skb->data;
>> > +
>> > +                       if (!hci_devcoredump_memset(hdev, pattern->pat=
tern,
>> > +                                                   pattern->len))
>> > +                               bt_dev_dbg(hdev, "Failed to set patter=
n");
>> > +                       break;
>> > +
>> > +               case HCI_DEVCOREDUMP_PKT_COMPLETE:
>> > +                       if (hdev->dump.state !=3D HCI_DEVCOREDUMP_ACTI=
VE) {
>> > +                               DBG_UNEXPECTED_STATE();
>> > +                               goto loop_continue;
>> > +                       }
>> > +
>> > +                       hci_devcoredump_update_state(hdev,
>> > +                                                    HCI_DEVCOREDUMP_D=
ONE);
>> > +                       dump_size =3D hdev->dump.tail - hdev->dump.hea=
d;
>> > +
>> > +                       bt_dev_info(hdev,
>> > +                                   "Devcoredump complete with size %u=
 "
>> > +                                   "(expect %u)",
>> > +                                   dump_size, hdev->dump.alloc_size);
>> > +
>> > +                       dev_coredumpv(&hdev->dev, hdev->dump.head, dum=
p_size,
>> > +                                     GFP_KERNEL);
>> > +                       break;
>> > +
>> > +               case HCI_DEVCOREDUMP_PKT_ABORT:
>> > +                       if (hdev->dump.state !=3D HCI_DEVCOREDUMP_ACTI=
VE) {
>> > +                               DBG_UNEXPECTED_STATE();
>> > +                               goto loop_continue;
>> > +                       }
>> > +
>> > +                       hci_devcoredump_update_state(hdev,
>> > +                                                    HCI_DEVCOREDUMP_A=
BORT);
>> > +                       dump_size =3D hdev->dump.tail - hdev->dump.hea=
d;
>> > +
>> > +                       bt_dev_info(hdev,
>> > +                                   "Devcoredump aborted with size %u =
"
>> > +                                   "(expect %u)",
>> > +                                   dump_size, hdev->dump.alloc_size);
>> > +
>> > +                       /* Emit a devcoredump with the available data =
*/
>> > +                       dev_coredumpv(&hdev->dev, hdev->dump.head, dum=
p_size,
>> > +                                     GFP_KERNEL);
>> > +                       break;
>> > +
>> > +               default:
>> > +                       bt_dev_dbg(hdev,
>> > +                                  "Unknown packet (%d) for state (%d)=
. ",
>> > +                                  hci_dmp_cb(skb)->pkt_type, hdev->du=
mp.state);
>> > +                       break;
>> > +               }
>> > +
>> > +loop_continue:
>> > +               kfree_skb(skb);
>> > +               hci_dev_unlock(hdev);
>> > +
>> > +               if (start_state !=3D hdev->dump.state)
>> > +                       hci_devcoredump_notify(hdev, hdev->dump.state)=
;
>> > +
>> > +               hci_dev_lock(hdev);
>> > +               if (hdev->dump.state =3D=3D HCI_DEVCOREDUMP_DONE ||
>> > +                   hdev->dump.state =3D=3D HCI_DEVCOREDUMP_ABORT)
>> > +                       hci_devcoredump_reset(hdev);
>> > +               hci_dev_unlock(hdev);
>> > +       }
>> > +}
>> > +EXPORT_SYMBOL(hci_devcoredump_rx);
>> > +
>> > +void hci_devcoredump_timeout(struct work_struct *work)
>> > +{
>> > +       struct hci_dev *hdev =3D container_of(work, struct hci_dev,
>> > +                                           dump.dump_timeout.work);
>> > +       u32 dump_size;
>> > +
>> > +       hci_devcoredump_notify(hdev, HCI_DEVCOREDUMP_TIMEOUT);
>> > +
>> > +       hci_dev_lock(hdev);
>> > +
>> > +       cancel_work_sync(&hdev->dump.dump_rx);
>> > +
>> > +       hci_devcoredump_update_state(hdev, HCI_DEVCOREDUMP_TIMEOUT);
>> > +       dump_size =3D hdev->dump.tail - hdev->dump.head;
>> > +       bt_dev_info(hdev, "Devcoredump timeout with size %u (expect %u=
)",
>> > +                   dump_size, hdev->dump.alloc_size);
>> > +
>> > +       /* Emit a devcoredump with the available data */
>> > +       dev_coredumpv(&hdev->dev, hdev->dump.head, dump_size, GFP_KERN=
EL);
>> > +
>> > +       hci_devcoredump_reset(hdev);
>> > +
>> > +       hci_dev_unlock(hdev);
>> > +}
>> > +EXPORT_SYMBOL(hci_devcoredump_timeout);
>> > +
>> > +int hci_devcoredump_register(struct hci_dev *hdev, dmp_hdr_t dmp_hdr,
>> > +                            notify_change_t notify_change)
>> > +{
>> > +       /* driver must implement dmp_hdr() function for bluetooth devc=
oredump */
>> > +       if (!dmp_hdr)
>> > +               return -EINVAL;
>> > +
>> > +       hci_dev_lock(hdev);
>> > +       hdev->dump.dmp_hdr =3D dmp_hdr;
>> > +       hdev->dump.notify_change =3D notify_change;
>> > +       hdev->dump.supported =3D true;
>> > +       hci_dev_unlock(hdev);
>> > +
>> > +       return 0;
>> > +}
>> > +EXPORT_SYMBOL(hci_devcoredump_register);
>> > +
>> > +int hci_devcoredump_init(struct hci_dev *hdev, u32 dmp_size)
>> > +{
>> > +       struct sk_buff *skb =3D NULL;
>> > +
>> > +       if (!hdev->dump.supported)
>> > +               return -EOPNOTSUPP;
>> > +
>> > +       skb =3D alloc_skb(sizeof(dmp_size), GFP_ATOMIC);
>> > +       if (!skb) {
>> > +               bt_dev_err(hdev, "Failed to allocate devcoredump init"=
);
>> > +               return -ENOMEM;
>> > +       }
>> > +
>> > +       hci_dmp_cb(skb)->pkt_type =3D HCI_DEVCOREDUMP_PKT_INIT;
>> > +       skb_put_data(skb, &dmp_size, sizeof(dmp_size));
>> > +
>> > +       skb_queue_tail(&hdev->dump.dump_q, skb);
>> > +       queue_work(hdev->workqueue, &hdev->dump.dump_rx);
>> > +
>> > +       return 0;
>> > +}
>> > +EXPORT_SYMBOL(hci_devcoredump_init);
>> > +
>> > +int hci_devcoredump_append(struct hci_dev *hdev, struct sk_buff *skb)
>> > +{
>> > +       if (!skb)
>> > +               return -ENOMEM;
>> > +
>> > +       if (!hdev->dump.supported) {
>> > +               kfree_skb(skb);
>> > +               return -EOPNOTSUPP;
>> > +       }
>> > +
>> > +       hci_dmp_cb(skb)->pkt_type =3D HCI_DEVCOREDUMP_PKT_SKB;
>> > +
>> > +       skb_queue_tail(&hdev->dump.dump_q, skb);
>> > +       queue_work(hdev->workqueue, &hdev->dump.dump_rx);
>> > +
>> > +       return 0;
>> > +}
>> > +EXPORT_SYMBOL(hci_devcoredump_append);
>> > +
>> > +int hci_devcoredump_append_pattern(struct hci_dev *hdev, u8 pattern, =
u32 len)
>> > +{
>> > +       struct hci_devcoredump_skb_pattern p;
>> > +       struct sk_buff *skb =3D NULL;
>> > +
>> > +       if (!hdev->dump.supported)
>> > +               return -EOPNOTSUPP;
>> > +
>> > +       skb =3D alloc_skb(sizeof(p), GFP_ATOMIC);
>> > +       if (!skb) {
>> > +               bt_dev_err(hdev, "Failed to allocate devcoredump patte=
rn");
>> > +               return -ENOMEM;
>> > +       }
>> > +
>> > +       p.pattern =3D pattern;
>> > +       p.len =3D len;
>> > +
>> > +       hci_dmp_cb(skb)->pkt_type =3D HCI_DEVCOREDUMP_PKT_PATTERN;
>> > +       skb_put_data(skb, &p, sizeof(p));
>> > +
>> > +       skb_queue_tail(&hdev->dump.dump_q, skb);
>> > +       queue_work(hdev->workqueue, &hdev->dump.dump_rx);
>> > +
>> > +       return 0;
>> > +}
>> > +EXPORT_SYMBOL(hci_devcoredump_append_pattern);
>> > +
>> > +int hci_devcoredump_complete(struct hci_dev *hdev)
>> > +{
>> > +       struct sk_buff *skb =3D NULL;
>> > +
>> > +       if (!hdev->dump.supported)
>> > +               return -EOPNOTSUPP;
>> > +
>> > +       skb =3D alloc_skb(0, GFP_ATOMIC);
>> > +       if (!skb) {
>> > +               bt_dev_err(hdev, "Failed to allocate devcoredump compl=
ete");
>> > +               return -ENOMEM;
>> > +       }
>> > +
>> > +       hci_dmp_cb(skb)->pkt_type =3D HCI_DEVCOREDUMP_PKT_COMPLETE;
>> > +
>> > +       skb_queue_tail(&hdev->dump.dump_q, skb);
>> > +       queue_work(hdev->workqueue, &hdev->dump.dump_rx);
>> > +
>> > +       return 0;
>> > +}
>> > +EXPORT_SYMBOL(hci_devcoredump_complete);
>> > +
>> > +int hci_devcoredump_abort(struct hci_dev *hdev)
>> > +{
>> > +       struct sk_buff *skb =3D NULL;
>> > +
>> > +       if (!hdev->dump.supported)
>> > +               return -EOPNOTSUPP;
>> > +
>> > +       skb =3D alloc_skb(0, GFP_ATOMIC);
>> > +       if (!skb) {
>> > +               bt_dev_err(hdev, "Failed to allocate devcoredump abort=
");
>> > +               return -ENOMEM;
>> > +       }
>> > +
>> > +       hci_dmp_cb(skb)->pkt_type =3D HCI_DEVCOREDUMP_PKT_ABORT;
>> > +
>> > +       skb_queue_tail(&hdev->dump.dump_q, skb);
>> > +       queue_work(hdev->workqueue, &hdev->dump.dump_rx);
>> > +
>> > +       return 0;
>> > +}
>> > +EXPORT_SYMBOL(hci_devcoredump_abort);
>> > diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
>> > index 05c13f639b94..743c5bdb8daa 100644
>> > --- a/net/bluetooth/hci_core.c
>> > +++ b/net/bluetooth/hci_core.c
>> > @@ -2516,14 +2516,23 @@ struct hci_dev *hci_alloc_dev_priv(int sizeof_=
priv)
>> >         INIT_WORK(&hdev->tx_work, hci_tx_work);
>> >         INIT_WORK(&hdev->power_on, hci_power_on);
>> >         INIT_WORK(&hdev->error_reset, hci_error_reset);
>> > +#ifdef CONFIG_DEV_COREDUMP
>> > +       INIT_WORK(&hdev->dump.dump_rx, hci_devcoredump_rx);
>> > +#endif
>> >
>> >         hci_cmd_sync_init(hdev);
>> >
>> >         INIT_DELAYED_WORK(&hdev->power_off, hci_power_off);
>> > +#ifdef CONFIG_DEV_COREDUMP
>> > +       INIT_DELAYED_WORK(&hdev->dump.dump_timeout, hci_devcoredump_ti=
meout);
>> > +#endif
>> >
>> >         skb_queue_head_init(&hdev->rx_q);
>> >         skb_queue_head_init(&hdev->cmd_q);
>> >         skb_queue_head_init(&hdev->raw_q);
>> > +#ifdef CONFIG_DEV_COREDUMP
>> > +       skb_queue_head_init(&hdev->dump.dump_q);
>> > +#endif
>> >
>> >         init_waitqueue_head(&hdev->req_wait_q);
>> >
>> > diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
>> > index e5602e209b63..a3d049b55b70 100644
>> > --- a/net/bluetooth/hci_sync.c
>> > +++ b/net/bluetooth/hci_sync.c
>> > @@ -3924,6 +3924,8 @@ int hci_dev_open_sync(struct hci_dev *hdev)
>> >                 goto done;
>> >         }
>> >
>> > +       hci_devcoredump_reset(hdev);
>> > +
>> >         set_bit(HCI_RUNNING, &hdev->flags);
>> >         hci_sock_dev_event(hdev, HCI_DEV_OPEN);
>> >
>> > --
>> > 2.37.0.rc0.104.g0611611a94-goog
>> >
>>
>>
>> --
>> Luiz Augusto von Dentz
>
>
> Regards,
> Manish.



--=20
Luiz Augusto von Dentz
