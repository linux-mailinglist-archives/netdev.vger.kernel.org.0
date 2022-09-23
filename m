Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79E6D5E82B4
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 21:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbiIWTv6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 15:51:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiIWTv4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 15:51:56 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 845EB126B7C;
        Fri, 23 Sep 2022 12:51:54 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id c7so1153346ljm.12;
        Fri, 23 Sep 2022 12:51:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=V6PIb8TuckQBOINndrObJ+IRltbdEYcbntvFOaV8hGM=;
        b=VzpEUAW5Y1Beuf7MXYjkJGuVAWNncxaZSoh0GK+TmQ620fxTGUO677i6dHDbVVtb0S
         pXNUOlRGP1n/Bq3OCfQdStQe0gZukrl+eRY+wqCg3mC8peqpp+3NUSgxevKostoN07Re
         hRfXr2sAjB9ob7bQf8a5llu96D1G1A30TEsHWr1kU7qyOoRIRiiSogxBUq24m/F5dDtS
         puo604eL+ZP2FHdg+ThGRwNmjv9oDuTxOalEjRYOufphGA7iQya2lwdkuQVjc4siifBQ
         NeKhCu9hNvEPPT40P50f0Vyu7G8634uKjAakt6usETFUUy8/3gWSVwbXf65CixQmPc0N
         LLag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=V6PIb8TuckQBOINndrObJ+IRltbdEYcbntvFOaV8hGM=;
        b=TLqSUlJr8x9N/SXHNzLJkgwKKeA0ij5xIcvFUHukOOEsQmMtMN3Qc2YlmwG6YmDes9
         sJtZAmFEB9EubQvrMP1Wrg+W3KRaBSYulHM+n+4C+XH4xgouGVa1QEBuiZ8PRXXK139Z
         ZbQSvnFpv0x03pUXZ0D866huuLOfmuMPDS7GRWTbDrpNJTegqROjHWkbV2zvomp6Tksw
         0GxzXdNEucufvG1d3pW3PyrvayGB76JEKwv6urh9vprM3qDGS8BBSaucYdTtO/hgTLhN
         NRS1uBeQUHKL0FkfQW+hWeIemT7usABIbeuR5rVb24D44zj9UPGxUVMExnonI/fo9/BR
         Mr1A==
X-Gm-Message-State: ACrzQf1tpUobvBEd2uhueJMuM6eY4HdObzUu3OS/rWVO25B0QFA2WGrB
        y4e3PMNpnqA2855TiNcjdoauN6xOocghoRLPEHc=
X-Google-Smtp-Source: AMsMyM6/3gwbkfEHG2+nrBBWTB//ZwHnGwqE1hRBtko1P+rFzNTaUjZZ/ZbhFO/IZo82uRznWoO57bM89zZEW3I10qk=
X-Received: by 2002:a2e:a884:0:b0:25d:d8a2:d18c with SMTP id
 m4-20020a2ea884000000b0025dd8a2d18cmr3242365ljq.305.1663962712675; Fri, 23
 Sep 2022 12:51:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220922221037.v6.1.I44a65858f594107d3688087dfbdf669fac450b52@changeid>
In-Reply-To: <20220922221037.v6.1.I44a65858f594107d3688087dfbdf669fac450b52@changeid>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Fri, 23 Sep 2022 12:51:40 -0700
Message-ID: <CABBYNZ+qg-_CTxnDAFZQGwMNTZRunP=joVDx2WuK0a4PWNU56A@mail.gmail.com>
Subject: Re: [PATCH v6 1/3] Bluetooth: Add support for hci devcoredump
To:     Manish Mandlik <mmandlik@google.com>
Cc:     marcel@holtmann.org, chromeos-bluetooth-upstreaming@chromium.org,
        linux-bluetooth@vger.kernel.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Manish,

On Thu, Sep 22, 2022 at 10:12 PM Manish Mandlik <mmandlik@google.com> wrote:
>
> From: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
>
> Add devcoredump APIs to hci core so that drivers only have to provide
> the dump skbs instead of managing the synchronization and timeouts.
>
> The devcoredump APIs should be used in the following manner:
>  - hci_devcoredump_init is called to allocate the dump.
>  - hci_devcoredump_append is called to append any skbs with dump data
>    OR hci_devcoredump_append_pattern is called to insert a pattern.
>  - hci_devcoredump_complete is called when all dump packets have been
>    sent OR hci_devcoredump_abort is called to indicate an error and
>    cancel an ongoing dump collection.
>
> The high level APIs just prepare some skbs with the appropriate data and
> queue it for the dump to process. Packets part of the crashdump can be
> intercepted in the driver in interrupt context and forwarded directly to
> the devcoredump APIs.
>
> Internally, there are 5 states for the dump: idle, active, complete,
> abort and timeout. A devcoredump will only be in active state after it
> has been initialized. Once active, it accepts data to be appended,
> patterns to be inserted (i.e. memset) and a completion event or an abort
> event to generate a devcoredump. The timeout is initialized at the same
> time the dump is initialized (defaulting to 10s) and will be cleared
> either when the timeout occurs or the dump is complete or aborted.
>
> Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> Signed-off-by: Manish Mandlik <mmandlik@google.com>
> Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> ---
>
> Changes in v6:
> - Remove #ifdef from .c and move to function in .h as per suggestion
> - Remove coredump_enabled from hci_devcoredump struct since the sysfs
>   flag related change has been abandoned

Well if we can't disable it we need to at least have proper coverage
on CI to have some confidence it won't break anything, that means we
need to introduce support for coredump into the emulator (vhci) much
like we did with suspend/resume so we can exercise this code in the CI
environment.

It should be very straight forward if you follow what we have done for
suspend/resume:

https://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git/tree/drivers/bluetooth/hci_vhci.c#n108

So we can add an entry to debugfs e.g. force_devcoredump and then add
support for setting it:

https://git.kernel.org/pub/scm/bluetooth/bluez.git/tree/emulator/vhci.c#n215

Then we can add some tests to the likes of mgmt-tester to exercise the
whole thing.

> Changes in v5:
> - (no changes in v5)
>
> Changes in v4:
> - Add .enabled() and .coredump() to hci_devcoredump struct
>
> Changes in v3:
> - Add attribute to enable/disable and set default state to disabled
>
> Changes in v2:
> - Move hci devcoredump implementation to new files
> - Move dump queue and dump work to hci_devcoredump struct
> - Add CONFIG_DEV_COREDUMP conditional compile
>
>  include/net/bluetooth/coredump.h | 114 +++++++
>  include/net/bluetooth/hci_core.h |  14 +
>  net/bluetooth/Makefile           |   2 +
>  net/bluetooth/coredump.c         | 515 +++++++++++++++++++++++++++++++
>  net/bluetooth/hci_core.c         |   2 +
>  net/bluetooth/hci_sync.c         |   2 +
>  6 files changed, 649 insertions(+)
>  create mode 100644 include/net/bluetooth/coredump.h
>  create mode 100644 net/bluetooth/coredump.c
>
> diff --git a/include/net/bluetooth/coredump.h b/include/net/bluetooth/coredump.h
> new file mode 100644
> index 000000000000..5da253527cfe
> --- /dev/null
> +++ b/include/net/bluetooth/coredump.h
> @@ -0,0 +1,114 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright (C) 2022 Google Corporation
> + */
> +
> +#ifndef __COREDUMP_H
> +#define __COREDUMP_H
> +
> +#define DEVCOREDUMP_TIMEOUT    msecs_to_jiffies(10000) /* 10 sec */
> +
> +typedef void (*coredump_t)(struct hci_dev *hdev);
> +typedef int  (*dmp_hdr_t)(struct hci_dev *hdev, char *buf, size_t size);
> +typedef void (*notify_change_t)(struct hci_dev *hdev, int state);
> +
> +/* struct hci_devcoredump - Devcoredump state
> + *
> + * @supported: Indicates if FW dump collection is supported by driver
> + * @state: Current state of dump collection
> + * @alloc_size: Total size of the dump
> + * @head: Start of the dump
> + * @tail: Pointer to current end of dump
> + * @end: head + alloc_size for easy comparisons
> + *
> + * @dump_q: Dump queue for state machine to process
> + * @dump_rx: Devcoredump state machine work
> + * @dump_timeout: Devcoredump timeout work
> + *
> + * @coredump: Called from the driver's .coredump() function.
> + * @dmp_hdr: Create a dump header to identify controller/fw/driver info
> + * @notify_change: Notify driver when devcoredump state has changed
> + */
> +struct hci_devcoredump {
> +       bool            supported;
> +
> +       enum devcoredump_state {
> +               HCI_DEVCOREDUMP_IDLE,
> +               HCI_DEVCOREDUMP_ACTIVE,
> +               HCI_DEVCOREDUMP_DONE,
> +               HCI_DEVCOREDUMP_ABORT,
> +               HCI_DEVCOREDUMP_TIMEOUT
> +       } state;
> +
> +       size_t          alloc_size;
> +       char            *head;
> +       char            *tail;
> +       char            *end;

I wonder why you can't use the skb to figure out the pointer above?

> +
> +       struct sk_buff_head     dump_q;
> +       struct work_struct      dump_rx;
> +       struct delayed_work     dump_timeout;
> +
> +       coredump_t              coredump;
> +       dmp_hdr_t               dmp_hdr;
> +       notify_change_t         notify_change;
> +};
> +
> +#ifdef CONFIG_DEV_COREDUMP
> +
> +void hci_devcoredump_reset(struct hci_dev *hdev);
> +void hci_devcoredump_rx(struct work_struct *work);
> +void hci_devcoredump_timeout(struct work_struct *work);
> +
> +int hci_devcoredump_register(struct hci_dev *hdev, coredump_t coredump,
> +                            dmp_hdr_t dmp_hdr, notify_change_t notify_change);
> +int hci_devcoredump_init(struct hci_dev *hdev, u32 dmp_size);
> +int hci_devcoredump_append(struct hci_dev *hdev, struct sk_buff *skb);
> +int hci_devcoredump_append_pattern(struct hci_dev *hdev, u8 pattern, u32 len);
> +int hci_devcoredump_complete(struct hci_dev *hdev);
> +int hci_devcoredump_abort(struct hci_dev *hdev);
> +
> +#else
> +
> +static inline void hci_devcoredump_reset(struct hci_dev *hdev) {}
> +static inline void hci_devcoredump_rx(struct work_struct *work) {}
> +static inline void hci_devcoredump_timeout(struct work_struct *work) {}
> +
> +static inline int hci_devcoredump_register(struct hci_dev *hdev,
> +                                          coredump_t coredump,
> +                                          dmp_hdr_t dmp_hdr,
> +                                          notify_change_t notify_change)
> +{
> +       return -EOPNOTSUPP;
> +}
> +
> +static inline int hci_devcoredump_init(struct hci_dev *hdev, u32 dmp_size)
> +{
> +       return -EOPNOTSUPP;
> +}
> +
> +static inline int hci_devcoredump_append(struct hci_dev *hdev,
> +                                        struct sk_buff *skb)
> +{
> +       return -EOPNOTSUPP;
> +}
> +
> +static inline int hci_devcoredump_append_pattern(struct hci_dev *hdev,
> +                                                u8 pattern, u32 len)
> +{
> +       return -EOPNOTSUPP;
> +}
> +
> +static inline int hci_devcoredump_complete(struct hci_dev *hdev)
> +{
> +       return -EOPNOTSUPP;
> +}
> +
> +static inline int hci_devcoredump_abort(struct hci_dev *hdev)
> +{
> +       return -EOPNOTSUPP;
> +}
> +
> +#endif /* CONFIG_DEV_COREDUMP */
> +
> +#endif /* __COREDUMP_H */
> diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
> index c54bc71254af..07f7813dee9d 100644
> --- a/include/net/bluetooth/hci_core.h
> +++ b/include/net/bluetooth/hci_core.h
> @@ -32,6 +32,7 @@
>  #include <net/bluetooth/hci.h>
>  #include <net/bluetooth/hci_sync.h>
>  #include <net/bluetooth/hci_sock.h>
> +#include <net/bluetooth/coredump.h>
>
>  /* HCI priority */
>  #define HCI_PRIO_MAX   7
> @@ -590,6 +591,10 @@ struct hci_dev {
>         const char              *fw_info;
>         struct dentry           *debugfs;
>
> +#ifdef CONFIG_DEV_COREDUMP
> +       struct hci_devcoredump  dump;
> +#endif
> +
>         struct device           dev;
>
>         struct rfkill           *rfkill;
> @@ -1495,6 +1500,15 @@ static inline void hci_set_aosp_capable(struct hci_dev *hdev)
>  #endif
>  }
>
> +static inline void hci_devcoredump_setup(struct hci_dev *hdev)
> +{
> +#ifdef CONFIG_DEV_COREDUMP
> +       INIT_WORK(&hdev->dump.dump_rx, hci_devcoredump_rx);
> +       INIT_DELAYED_WORK(&hdev->dump.dump_timeout, hci_devcoredump_timeout);
> +       skb_queue_head_init(&hdev->dump.dump_q);
> +#endif
> +}
> +
>  int hci_dev_open(__u16 dev);
>  int hci_dev_close(__u16 dev);
>  int hci_dev_do_close(struct hci_dev *hdev);
> diff --git a/net/bluetooth/Makefile b/net/bluetooth/Makefile
> index 0e7b7db42750..141ac1fda0bf 100644
> --- a/net/bluetooth/Makefile
> +++ b/net/bluetooth/Makefile
> @@ -17,6 +17,8 @@ bluetooth-y := af_bluetooth.o hci_core.o hci_conn.o hci_event.o mgmt.o \
>         ecdh_helper.o hci_request.o mgmt_util.o mgmt_config.o hci_codec.o \
>         eir.o hci_sync.o
>
> +bluetooth-$(CONFIG_DEV_COREDUMP) += coredump.o
> +
>  bluetooth-$(CONFIG_BT_BREDR) += sco.o
>  bluetooth-$(CONFIG_BT_LE) += iso.o
>  bluetooth-$(CONFIG_BT_HS) += a2mp.o amp.o
> diff --git a/net/bluetooth/coredump.c b/net/bluetooth/coredump.c
> new file mode 100644
> index 000000000000..ce9e36f77323
> --- /dev/null
> +++ b/net/bluetooth/coredump.c
> @@ -0,0 +1,515 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2022 Google Corporation
> + */
> +
> +#include <linux/devcoredump.h>
> +
> +#include <net/bluetooth/bluetooth.h>
> +#include <net/bluetooth/hci_core.h>
> +
> +enum hci_devcoredump_pkt_type {
> +       HCI_DEVCOREDUMP_PKT_INIT,
> +       HCI_DEVCOREDUMP_PKT_SKB,
> +       HCI_DEVCOREDUMP_PKT_PATTERN,
> +       HCI_DEVCOREDUMP_PKT_COMPLETE,
> +       HCI_DEVCOREDUMP_PKT_ABORT,
> +};
> +
> +struct hci_devcoredump_skb_cb {
> +       u16 pkt_type;
> +};
> +
> +struct hci_devcoredump_skb_pattern {
> +       u8 pattern;
> +       u32 len;
> +} __packed;
> +
> +#define hci_dmp_cb(skb)        ((struct hci_devcoredump_skb_cb *)((skb)->cb))
> +
> +#define MAX_DEVCOREDUMP_HDR_SIZE       512     /* bytes */

Please add a comment where this header size comes from or perhaps we
do want this to come from the driver itself since the dump itself is
vendor specific?

> +static int hci_devcoredump_update_hdr_state(char *buf, size_t size, int state)
> +{
> +       if (!buf)
> +               return 0;
> +
> +       return snprintf(buf, size, "Bluetooth devcoredump\nState: %d\n", state);
> +}
> +
> +/* Call with hci_dev_lock only. */
> +static int hci_devcoredump_update_state(struct hci_dev *hdev, int state)
> +{
> +       hdev->dump.state = state;
> +
> +       return hci_devcoredump_update_hdr_state(hdev->dump.head,
> +                                               hdev->dump.alloc_size, state);
> +}
> +
> +static int hci_devcoredump_mkheader(struct hci_dev *hdev, char *buf,
> +                                   size_t buf_size)
> +{
> +       char *ptr = buf;
> +       size_t rem = buf_size;
> +       size_t read = 0;
> +
> +       read = hci_devcoredump_update_hdr_state(ptr, rem, HCI_DEVCOREDUMP_IDLE);
> +       read += 1; /* update_hdr_state adds \0 at the end upon state rewrite */
> +       rem -= read;
> +       ptr += read;
> +
> +       if (hdev->dump.dmp_hdr) {
> +               /* dmp_hdr() should return number of bytes written */
> +               read = hdev->dump.dmp_hdr(hdev, ptr, rem);
> +               rem -= read;
> +               ptr += read;
> +       }
> +
> +       read = snprintf(ptr, rem, "--- Start dump ---\n");

Are we injecting data into the dump? I thought this would be
completely vendor specific.

> +       rem -= read;
> +       ptr += read;
> +
> +       return buf_size - rem;

Can't we use the skb functions to allocate the header space?

> +}
> +
> +/* Do not call with hci_dev_lock since this calls driver code. */
> +static void hci_devcoredump_notify(struct hci_dev *hdev, int state)
> +{
> +       if (hdev->dump.notify_change)
> +               hdev->dump.notify_change(hdev, state);
> +}
> +
> +/* Call with hci_dev_lock only. */
> +void hci_devcoredump_reset(struct hci_dev *hdev)
> +{
> +       hdev->dump.head = NULL;
> +       hdev->dump.tail = NULL;
> +       hdev->dump.alloc_size = 0;
> +
> +       hci_devcoredump_update_state(hdev, HCI_DEVCOREDUMP_IDLE);
> +
> +       cancel_delayed_work(&hdev->dump.dump_timeout);
> +       skb_queue_purge(&hdev->dump.dump_q);
> +}
> +
> +/* Call with hci_dev_lock only. */
> +static void hci_devcoredump_free(struct hci_dev *hdev)
> +{
> +       if (hdev->dump.head)
> +               vfree(hdev->dump.head);
> +
> +       hci_devcoredump_reset(hdev);
> +}
> +
> +/* Call with hci_dev_lock only. */
> +static int hci_devcoredump_alloc(struct hci_dev *hdev, u32 size)
> +{
> +       hdev->dump.head = vmalloc(size);
> +       if (!hdev->dump.head)
> +               return -ENOMEM;
> +
> +       hdev->dump.alloc_size = size;
> +       hdev->dump.tail = hdev->dump.head;
> +       hdev->dump.end = hdev->dump.head + size;
> +
> +       hci_devcoredump_update_state(hdev, HCI_DEVCOREDUMP_IDLE);
> +
> +       return 0;
> +}
> +
> +/* Call with hci_dev_lock only. */
> +static bool hci_devcoredump_copy(struct hci_dev *hdev, char *buf, u32 size)
> +{
> +       if (hdev->dump.tail + size > hdev->dump.end)
> +               return false;
> +
> +       memcpy(hdev->dump.tail, buf, size);
> +       hdev->dump.tail += size;
> +
> +       return true;
> +}
> +
> +/* Call with hci_dev_lock only. */
> +static bool hci_devcoredump_memset(struct hci_dev *hdev, u8 pattern, u32 len)
> +{
> +       if (hdev->dump.tail + len > hdev->dump.end)
> +               return false;
> +
> +       memset(hdev->dump.tail, pattern, len);
> +       hdev->dump.tail += len;
> +
> +       return true;
> +}
> +
> +/* Call with hci_dev_lock only. */
> +static int hci_devcoredump_prepare(struct hci_dev *hdev, u32 dump_size)
> +{
> +       char *dump_hdr;
> +       int dump_hdr_size;
> +       u32 size;
> +       int err = 0;
> +
> +       dump_hdr = vmalloc(MAX_DEVCOREDUMP_HDR_SIZE);
> +       if (!dump_hdr) {
> +               err = -ENOMEM;
> +               goto hdr_free;
> +       }
> +
> +       dump_hdr_size = hci_devcoredump_mkheader(hdev, dump_hdr,
> +                                                MAX_DEVCOREDUMP_HDR_SIZE);
> +       size = dump_hdr_size + dump_size;
> +
> +       if (hci_devcoredump_alloc(hdev, size)) {
> +               err = -ENOMEM;
> +               goto hdr_free;
> +       }
> +
> +       /* Insert the device header */
> +       if (!hci_devcoredump_copy(hdev, dump_hdr, dump_hdr_size)) {
> +               bt_dev_err(hdev, "Failed to insert header");
> +               hci_devcoredump_free(hdev);
> +
> +               err = -ENOMEM;
> +               goto hdr_free;
> +       }
> +
> +hdr_free:
> +       if (dump_hdr)
> +               vfree(dump_hdr);
> +
> +       return err;
> +}
> +
> +/* Bluetooth devcoredump state machine.
> + *
> + * Devcoredump states:
> + *
> + *      HCI_DEVCOREDUMP_IDLE: The default state.
> + *
> + *      HCI_DEVCOREDUMP_ACTIVE: A devcoredump will be in this state once it has
> + *              been initialized using hci_devcoredump_init(). Once active, the
> + *              driver can append data using hci_devcoredump_append() or insert
> + *              a pattern using hci_devcoredump_append_pattern().
> + *
> + *      HCI_DEVCOREDUMP_DONE: Once the dump collection is complete, the drive
> + *              can signal the completion using hci_devcoredump_complete(). A
> + *              devcoredump is generated indicating the completion event and
> + *              then the state machine is reset to the default state.
> + *
> + *      HCI_DEVCOREDUMP_ABORT: The driver can cancel ongoing dump collection in
> + *              case of any error using hci_devcoredump_abort(). A devcoredump
> + *              is still generated with the available data indicating the abort
> + *              event and then the state machine is reset to the default state.
> + *
> + *      HCI_DEVCOREDUMP_TIMEOUT: A timeout timer for HCI_DEVCOREDUMP_TIMEOUT sec
> + *              is started during devcoredump initialization. Once the timeout
> + *              occurs, the driver is notified, a devcoredump is generated with
> + *              the available data indicating the timeout event and then the
> + *              state machine is reset to the default state.
> + *
> + * The driver must register using hci_devcoredump_register() before using the
> + * hci devcoredump APIs.
> + */
> +void hci_devcoredump_rx(struct work_struct *work)
> +{
> +       struct hci_dev *hdev = container_of(work, struct hci_dev, dump.dump_rx);
> +       struct sk_buff *skb;
> +       struct hci_devcoredump_skb_pattern *pattern;
> +       u32 dump_size;
> +       int start_state;
> +
> +#define DBG_UNEXPECTED_STATE() \
> +               bt_dev_dbg(hdev, \
> +                          "Unexpected packet (%d) for state (%d). ", \
> +                          hci_dmp_cb(skb)->pkt_type, hdev->dump.state)
> +
> +       while ((skb = skb_dequeue(&hdev->dump.dump_q))) {
> +               hci_dev_lock(hdev);
> +               start_state = hdev->dump.state;
> +
> +               switch (hci_dmp_cb(skb)->pkt_type) {
> +               case HCI_DEVCOREDUMP_PKT_INIT:
> +                       if (hdev->dump.state != HCI_DEVCOREDUMP_IDLE) {
> +                               DBG_UNEXPECTED_STATE();
> +                               goto loop_continue;
> +                       }
> +
> +                       if (skb->len != sizeof(dump_size)) {
> +                               bt_dev_dbg(hdev, "Invalid dump init pkt");
> +                               goto loop_continue;
> +                       }
> +
> +                       dump_size = *((u32 *)skb->data);
> +                       if (!dump_size) {
> +                               bt_dev_err(hdev, "Zero size dump init pkt");
> +                               goto loop_continue;
> +                       }
> +
> +                       if (hci_devcoredump_prepare(hdev, dump_size)) {
> +                               bt_dev_err(hdev, "Failed to prepare for dump");
> +                               goto loop_continue;
> +                       }
> +
> +                       hci_devcoredump_update_state(hdev,
> +                                                    HCI_DEVCOREDUMP_ACTIVE);
> +                       queue_delayed_work(hdev->workqueue,
> +                                          &hdev->dump.dump_timeout,
> +                                          DEVCOREDUMP_TIMEOUT);
> +                       break;
> +
> +               case HCI_DEVCOREDUMP_PKT_SKB:
> +                       if (hdev->dump.state != HCI_DEVCOREDUMP_ACTIVE) {
> +                               DBG_UNEXPECTED_STATE();
> +                               goto loop_continue;
> +                       }
> +
> +                       if (!hci_devcoredump_copy(hdev, skb->data, skb->len))
> +                               bt_dev_dbg(hdev, "Failed to insert skb");
> +                       break;
> +
> +               case HCI_DEVCOREDUMP_PKT_PATTERN:
> +                       if (hdev->dump.state != HCI_DEVCOREDUMP_ACTIVE) {
> +                               DBG_UNEXPECTED_STATE();
> +                               goto loop_continue;
> +                       }
> +
> +                       if (skb->len != sizeof(*pattern)) {
> +                               bt_dev_dbg(hdev, "Invalid pattern skb");
> +                               goto loop_continue;
> +                       }
> +
> +                       pattern = (void *)skb->data;
> +
> +                       if (!hci_devcoredump_memset(hdev, pattern->pattern,
> +                                                   pattern->len))
> +                               bt_dev_dbg(hdev, "Failed to set pattern");
> +                       break;
> +
> +               case HCI_DEVCOREDUMP_PKT_COMPLETE:
> +                       if (hdev->dump.state != HCI_DEVCOREDUMP_ACTIVE) {
> +                               DBG_UNEXPECTED_STATE();
> +                               goto loop_continue;
> +                       }
> +
> +                       hci_devcoredump_update_state(hdev,
> +                                                    HCI_DEVCOREDUMP_DONE);
> +                       dump_size = hdev->dump.tail - hdev->dump.head;
> +
> +                       bt_dev_info(hdev,
> +                                   "Devcoredump complete with size %u "
> +                                   "(expect %zu)",
> +                                   dump_size, hdev->dump.alloc_size);
> +
> +                       dev_coredumpv(&hdev->dev, hdev->dump.head, dump_size,
> +                                     GFP_KERNEL);
> +                       break;
> +
> +               case HCI_DEVCOREDUMP_PKT_ABORT:
> +                       if (hdev->dump.state != HCI_DEVCOREDUMP_ACTIVE) {
> +                               DBG_UNEXPECTED_STATE();
> +                               goto loop_continue;
> +                       }
> +
> +                       hci_devcoredump_update_state(hdev,
> +                                                    HCI_DEVCOREDUMP_ABORT);
> +                       dump_size = hdev->dump.tail - hdev->dump.head;
> +
> +                       bt_dev_info(hdev,
> +                                   "Devcoredump aborted with size %u "
> +                                   "(expect %zu)",
> +                                   dump_size, hdev->dump.alloc_size);
> +
> +                       /* Emit a devcoredump with the available data */
> +                       dev_coredumpv(&hdev->dev, hdev->dump.head, dump_size,
> +                                     GFP_KERNEL);
> +                       break;
> +
> +               default:
> +                       bt_dev_dbg(hdev,
> +                                  "Unknown packet (%d) for state (%d). ",
> +                                  hci_dmp_cb(skb)->pkt_type, hdev->dump.state);
> +                       break;
> +               }
> +
> +loop_continue:
> +               kfree_skb(skb);
> +               hci_dev_unlock(hdev);
> +
> +               if (start_state != hdev->dump.state)
> +                       hci_devcoredump_notify(hdev, hdev->dump.state);
> +
> +               hci_dev_lock(hdev);
> +               if (hdev->dump.state == HCI_DEVCOREDUMP_DONE ||
> +                   hdev->dump.state == HCI_DEVCOREDUMP_ABORT)
> +                       hci_devcoredump_reset(hdev);
> +               hci_dev_unlock(hdev);
> +       }
> +}
> +EXPORT_SYMBOL(hci_devcoredump_rx);
> +
> +void hci_devcoredump_timeout(struct work_struct *work)
> +{
> +       struct hci_dev *hdev = container_of(work, struct hci_dev,
> +                                           dump.dump_timeout.work);
> +       u32 dump_size;
> +
> +       hci_devcoredump_notify(hdev, HCI_DEVCOREDUMP_TIMEOUT);
> +
> +       hci_dev_lock(hdev);
> +
> +       cancel_work_sync(&hdev->dump.dump_rx);
> +
> +       hci_devcoredump_update_state(hdev, HCI_DEVCOREDUMP_TIMEOUT);
> +       dump_size = hdev->dump.tail - hdev->dump.head;
> +       bt_dev_info(hdev, "Devcoredump timeout with size %u (expect %zu)",
> +                   dump_size, hdev->dump.alloc_size);
> +
> +       /* Emit a devcoredump with the available data */
> +       dev_coredumpv(&hdev->dev, hdev->dump.head, dump_size, GFP_KERNEL);
> +
> +       hci_devcoredump_reset(hdev);
> +
> +       hci_dev_unlock(hdev);
> +}
> +EXPORT_SYMBOL(hci_devcoredump_timeout);
> +
> +int hci_devcoredump_register(struct hci_dev *hdev, coredump_t coredump,
> +                            dmp_hdr_t dmp_hdr, notify_change_t notify_change)
> +{
> +       /* Driver must implement coredump() and dmp_hdr() functions for
> +        * bluetooth devcoredump. The coredump() should trigger a coredump
> +        * event on the controller when the device's coredump sysfs entry is
> +        * written to. The dmp_hdr() should create a dump header to identify
> +        * the controller/fw/driver info.
> +        */
> +       if (!coredump || !dmp_hdr)
> +               return -EINVAL;
> +
> +       hci_dev_lock(hdev);
> +       hdev->dump.coredump = coredump;
> +       hdev->dump.dmp_hdr = dmp_hdr;
> +       hdev->dump.notify_change = notify_change;
> +       hdev->dump.supported = true;
> +       hci_dev_unlock(hdev);
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL(hci_devcoredump_register);
> +
> +static inline bool hci_devcoredump_enabled(struct hci_dev *hdev)
> +{
> +       return hdev->dump.supported;
> +}
> +
> +int hci_devcoredump_init(struct hci_dev *hdev, u32 dmp_size)
> +{
> +       struct sk_buff *skb = NULL;
> +
> +       if (!hci_devcoredump_enabled(hdev))
> +               return -EOPNOTSUPP;
> +
> +       skb = alloc_skb(sizeof(dmp_size), GFP_ATOMIC);
> +       if (!skb) {
> +               bt_dev_err(hdev, "Failed to allocate devcoredump init");
> +               return -ENOMEM;
> +       }
> +
> +       hci_dmp_cb(skb)->pkt_type = HCI_DEVCOREDUMP_PKT_INIT;
> +       skb_put_data(skb, &dmp_size, sizeof(dmp_size));
> +
> +       skb_queue_tail(&hdev->dump.dump_q, skb);
> +       queue_work(hdev->workqueue, &hdev->dump.dump_rx);
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL(hci_devcoredump_init);
> +
> +int hci_devcoredump_append(struct hci_dev *hdev, struct sk_buff *skb)
> +{
> +       if (!skb)
> +               return -ENOMEM;
> +
> +       if (!hci_devcoredump_enabled(hdev)) {
> +               kfree_skb(skb);
> +               return -EOPNOTSUPP;
> +       }
> +
> +       hci_dmp_cb(skb)->pkt_type = HCI_DEVCOREDUMP_PKT_SKB;
> +
> +       skb_queue_tail(&hdev->dump.dump_q, skb);
> +       queue_work(hdev->workqueue, &hdev->dump.dump_rx);
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL(hci_devcoredump_append);
> +
> +int hci_devcoredump_append_pattern(struct hci_dev *hdev, u8 pattern, u32 len)
> +{
> +       struct hci_devcoredump_skb_pattern p;
> +       struct sk_buff *skb = NULL;
> +
> +       if (!hci_devcoredump_enabled(hdev))
> +               return -EOPNOTSUPP;
> +
> +       skb = alloc_skb(sizeof(p), GFP_ATOMIC);
> +       if (!skb) {
> +               bt_dev_err(hdev, "Failed to allocate devcoredump pattern");
> +               return -ENOMEM;
> +       }
> +
> +       p.pattern = pattern;
> +       p.len = len;
> +
> +       hci_dmp_cb(skb)->pkt_type = HCI_DEVCOREDUMP_PKT_PATTERN;
> +       skb_put_data(skb, &p, sizeof(p));
> +
> +       skb_queue_tail(&hdev->dump.dump_q, skb);
> +       queue_work(hdev->workqueue, &hdev->dump.dump_rx);
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL(hci_devcoredump_append_pattern);
> +
> +int hci_devcoredump_complete(struct hci_dev *hdev)
> +{
> +       struct sk_buff *skb = NULL;
> +
> +       if (!hci_devcoredump_enabled(hdev))
> +               return -EOPNOTSUPP;
> +
> +       skb = alloc_skb(0, GFP_ATOMIC);
> +       if (!skb) {
> +               bt_dev_err(hdev, "Failed to allocate devcoredump complete");
> +               return -ENOMEM;
> +       }
> +
> +       hci_dmp_cb(skb)->pkt_type = HCI_DEVCOREDUMP_PKT_COMPLETE;
> +
> +       skb_queue_tail(&hdev->dump.dump_q, skb);
> +       queue_work(hdev->workqueue, &hdev->dump.dump_rx);
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL(hci_devcoredump_complete);
> +
> +int hci_devcoredump_abort(struct hci_dev *hdev)
> +{
> +       struct sk_buff *skb = NULL;
> +
> +       if (!hci_devcoredump_enabled(hdev))
> +               return -EOPNOTSUPP;
> +
> +       skb = alloc_skb(0, GFP_ATOMIC);
> +       if (!skb) {
> +               bt_dev_err(hdev, "Failed to allocate devcoredump abort");
> +               return -ENOMEM;
> +       }
> +
> +       hci_dmp_cb(skb)->pkt_type = HCI_DEVCOREDUMP_PKT_ABORT;
> +
> +       skb_queue_tail(&hdev->dump.dump_q, skb);
> +       queue_work(hdev->workqueue, &hdev->dump.dump_rx);
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL(hci_devcoredump_abort);
> diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> index 66c7cdba0d32..1da32df77c21 100644
> --- a/net/bluetooth/hci_core.c
> +++ b/net/bluetooth/hci_core.c
> @@ -2545,6 +2545,8 @@ struct hci_dev *hci_alloc_dev_priv(int sizeof_priv)
>         hci_init_sysfs(hdev);
>         discovery_init(hdev);
>
> +       hci_devcoredump_setup(hdev);
> +
>         return hdev;
>  }
>  EXPORT_SYMBOL(hci_alloc_dev_priv);
> diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
> index 422f7c6911d9..026f7c85e512 100644
> --- a/net/bluetooth/hci_sync.c
> +++ b/net/bluetooth/hci_sync.c
> @@ -4658,6 +4658,8 @@ int hci_dev_open_sync(struct hci_dev *hdev)
>                 goto done;
>         }
>
> +       hci_devcoredump_reset(hdev);
> +
>         set_bit(HCI_RUNNING, &hdev->flags);
>         hci_sock_dev_event(hdev, HCI_DEV_OPEN);
>
> --
> 2.37.3.998.g577e59143f-goog
>


-- 
Luiz Augusto von Dentz
