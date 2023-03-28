Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44B426CCB33
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 22:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbjC1UHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 16:07:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjC1UHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 16:07:08 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 870A713E;
        Tue, 28 Mar 2023 13:07:05 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id e21so13829718ljn.7;
        Tue, 28 Mar 2023 13:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680034024;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r/qL/eYL7NDJ3rNvzL2+dN5+HVTyz0fZuDmioSu/SiA=;
        b=VKVbxfBZmkvI3fn3ih54sGW7R4IVjKZjzsrMnNxHJtdAypS+GaUE39wteMD/ahxzYH
         vq8+sy73iEzSORJRRNfuAE9Mr16gWkHzJv1a6POy3fkqDqf+9sIgDuuf7S55qqrlpLLZ
         qN+t8uAshuUXhkgIg+r+tWAV3K81jNJJYcRMExx8kC21Jhl7pmHvbOXj7QoN+r30fe6a
         dqZOPyjVWwe93q6/9OBLzdEZBNAf8tw2dqa0jKC2bDDOEP0vPAAYtrTnQQ/PVQf7Sxr2
         42A02nh4va7uaoASEUaKoAXEaLZ2Oc9lNlrlkFUERhPSw9TYGmjAuAqXfkLjJgx0xeek
         pM+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680034024;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r/qL/eYL7NDJ3rNvzL2+dN5+HVTyz0fZuDmioSu/SiA=;
        b=akkub9irWw2n0YgLWOAFncMKOJJk+aBtPLGxhOT9YPi90599sI9M3BIirdMEZwe1cK
         Fr3BdLxcx0GHWuAsWD4XXD1vqylzkXEJVabODXO7LXLT7vVwpCdO0nZStp5wzGTCWHRI
         bQLMqyk7yFgxdCDF+dPpDp+qBTAoo8rpya0wlSJMs/IU0udDiFWMt/3j+hbKcTRkNT7D
         qNz4B2O5JTcZe/do3SoswFyRZzVOLvgHjXzu1JQzbpNf9VKGuodesAKGIN/f5xfhuqio
         BtWYWl3oOGerFQXosA4QCsB1FNsjdPk7E/WUcfCwkoKeTqkVZ8q2dCXf+NjvcS228Lg1
         j/aA==
X-Gm-Message-State: AO0yUKWbO2r7gwdfxfpGv/4hZdDgoSJAdu3URRGHvsja2HxDA9tsuYYC
        ZGAN8H0mkZt3uHJ28LZ/aWYnbOc5SgVZgFDV/6s=
X-Google-Smtp-Source: AK7set9jkRGDtzWju8WUkUKZJyk5rKLWuv6gzvBv5Oh+OpQbmUMgG9fOZo9mVVoNdfNXI7GGL7fxHefmLpVR4LEASLI=
X-Received: by 2002:a2e:2a84:0:b0:293:4ba5:f626 with SMTP id
 q126-20020a2e2a84000000b002934ba5f626mr10427321ljq.2.1680034023171; Tue, 28
 Mar 2023 13:07:03 -0700 (PDT)
MIME-Version: 1.0
References: <20230328094207.v11.1.I9b4e4818bab450657b19cda3497d363c9baa616e@changeid>
In-Reply-To: <20230328094207.v11.1.I9b4e4818bab450657b19cda3497d363c9baa616e@changeid>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Tue, 28 Mar 2023 13:06:51 -0700
Message-ID: <CABBYNZKmSo_sbuh2cEypi_m5coM0W=M=bdpdTi41PXQOWHBfSA@mail.gmail.com>
Subject: Re: [PATCH v11 1/4] Bluetooth: Add support for hci devcoredump
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
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Manish,

On Tue, Mar 28, 2023 at 9:42=E2=80=AFAM Manish Mandlik <mmandlik@google.com=
> wrote:
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
> Changes in v11:
> - Fix formatting/indentation
>
> Changes in v10:
> - Fix compiler warnings
>
> Changes in v9:
> - Use scnprintf instead of snprintf
> - Remove unnecessary out-of-memory logs
> - Add a function for each devcoredump state
> - Use skb_pull_data whenever possible
> - Rename hci_devcoredump_*() to hci_devcd_*()
>
> Changes in v8:
> - Update hci_devcoredump_mkheader() and .dmp_hdr() to use skb
>
> Changes in v6:
> - Remove #ifdef from .c and move to function in .h as per suggestion
> - Remove coredump_enabled from hci_devcoredump struct since the sysfs
>   flag related change has been abandoned
>
> Changes in v5:
> - No changes in v5
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
>  include/net/bluetooth/coredump.h | 112 +++++++
>  include/net/bluetooth/hci_core.h |  14 +
>  net/bluetooth/Makefile           |   2 +
>  net/bluetooth/coredump.c         | 525 +++++++++++++++++++++++++++++++
>  net/bluetooth/hci_core.c         |   1 +
>  net/bluetooth/hci_sync.c         |   2 +
>  6 files changed, 656 insertions(+)
>  create mode 100644 include/net/bluetooth/coredump.h
>  create mode 100644 net/bluetooth/coredump.c
>
> diff --git a/include/net/bluetooth/coredump.h b/include/net/bluetooth/cor=
edump.h
> new file mode 100644
> index 000000000000..331e27e3f24c
> --- /dev/null
> +++ b/include/net/bluetooth/coredump.h
> @@ -0,0 +1,112 @@
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
> +typedef void (*dmp_hdr_t)(struct hci_dev *hdev, struct sk_buff *skb);
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
> +void hci_devcd_reset(struct hci_dev *hdev);
> +void hci_devcd_rx(struct work_struct *work);
> +void hci_devcd_timeout(struct work_struct *work);
> +
> +int hci_devcd_register(struct hci_dev *hdev, coredump_t coredump,
> +                      dmp_hdr_t dmp_hdr, notify_change_t notify_change);
> +int hci_devcd_init(struct hci_dev *hdev, u32 dump_size);
> +int hci_devcd_append(struct hci_dev *hdev, struct sk_buff *skb);
> +int hci_devcd_append_pattern(struct hci_dev *hdev, u8 pattern, u32 len);
> +int hci_devcd_complete(struct hci_dev *hdev);
> +int hci_devcd_abort(struct hci_dev *hdev);
> +
> +#else
> +
> +static inline void hci_devcd_reset(struct hci_dev *hdev) {}
> +static inline void hci_devcd_rx(struct work_struct *work) {}
> +static inline void hci_devcd_timeout(struct work_struct *work) {}
> +
> +static inline int hci_devcd_register(struct hci_dev *hdev, coredump_t co=
redump,
> +                                    dmp_hdr_t dmp_hdr,
> +                                    notify_change_t notify_change)
> +{
> +       return -EOPNOTSUPP;
> +}
> +
> +static inline int hci_devcd_init(struct hci_dev *hdev, u32 dump_size)
> +{
> +       return -EOPNOTSUPP;
> +}
> +
> +static inline int hci_devcd_append(struct hci_dev *hdev, struct sk_buff =
*skb)
> +{
> +       return -EOPNOTSUPP;
> +}
> +
> +static inline int hci_devcd_append_pattern(struct hci_dev *hdev,
> +                                          u8 pattern, u32 len)
> +{
> +       return -EOPNOTSUPP;
> +}
> +
> +static inline int hci_devcd_complete(struct hci_dev *hdev)
> +{
> +       return -EOPNOTSUPP;
> +}
> +
> +static inline int hci_devcd_abort(struct hci_dev *hdev)
> +{
> +       return -EOPNOTSUPP;
> +}
> +
> +#endif /* CONFIG_DEV_COREDUMP */
> +
> +#endif /* __COREDUMP_H */
> diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci=
_core.h
> index 9488671c1219..300aaac84adf 100644
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
> @@ -1496,6 +1501,15 @@ static inline void hci_set_aosp_capable(struct hci=
_dev *hdev)
>  #endif
>  }
>
> +static inline void hci_devcd_setup(struct hci_dev *hdev)
> +{
> +#ifdef CONFIG_DEV_COREDUMP
> +       INIT_WORK(&hdev->dump.dump_rx, hci_devcd_rx);
> +       INIT_DELAYED_WORK(&hdev->dump.dump_timeout, hci_devcd_timeout);
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
> @@ -17,6 +17,8 @@ bluetooth-y :=3D af_bluetooth.o hci_core.o hci_conn.o h=
ci_event.o mgmt.o \
>         ecdh_helper.o hci_request.o mgmt_util.o mgmt_config.o hci_codec.o=
 \
>         eir.o hci_sync.o
>
> +bluetooth-$(CONFIG_DEV_COREDUMP) +=3D coredump.o
> +
>  bluetooth-$(CONFIG_BT_BREDR) +=3D sco.o
>  bluetooth-$(CONFIG_BT_LE) +=3D iso.o
>  bluetooth-$(CONFIG_BT_HS) +=3D a2mp.o amp.o
> diff --git a/net/bluetooth/coredump.c b/net/bluetooth/coredump.c
> new file mode 100644
> index 000000000000..fb5545c16636
> --- /dev/null
> +++ b/net/bluetooth/coredump.c
> @@ -0,0 +1,525 @@
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
> +#define hci_dmp_cb(skb)        ((struct hci_devcoredump_skb_cb *)((skb)-=
>cb))
> +
> +#define DBG_UNEXPECTED_STATE() \
> +       bt_dev_dbg(hdev, \
> +                  "Unexpected packet (%d) for state (%d). ", \
> +                  hci_dmp_cb(skb)->pkt_type, hdev->dump.state)
> +
> +#define MAX_DEVCOREDUMP_HDR_SIZE       512     /* bytes */
> +
> +static int hci_devcd_update_hdr_state(char *buf, size_t size, int state)
> +{
> +       int len =3D 0;
> +
> +       if (!buf)
> +               return 0;
> +
> +       len =3D scnprintf(buf, size, "Bluetooth devcoredump\nState: %d\n"=
, state);
> +
> +       return len + 1; /* scnprintf adds \0 at the end upon state rewrit=
e */
> +}
> +
> +/* Call with hci_dev_lock only. */
> +static int hci_devcd_update_state(struct hci_dev *hdev, int state)
> +{
> +       bt_dev_dbg(hdev, "Updating devcoredump state from %d to %d.",
> +                  hdev->dump.state, state);
> +
> +       hdev->dump.state =3D state;
> +
> +       return hci_devcd_update_hdr_state(hdev->dump.head,
> +                                         hdev->dump.alloc_size, state);
> +}
> +
> +static int hci_devcd_mkheader(struct hci_dev *hdev, struct sk_buff *skb)
> +{
> +       char dump_start[] =3D "--- Start dump ---\n";
> +       char hdr[80];
> +       int hdr_len;
> +
> +       hdr_len =3D hci_devcd_update_hdr_state(hdr, sizeof(hdr),
> +                                            HCI_DEVCOREDUMP_IDLE);
> +       skb_put_data(skb, hdr, hdr_len);
> +
> +       if (hdev->dump.dmp_hdr)
> +               hdev->dump.dmp_hdr(hdev, skb);
> +
> +       skb_put_data(skb, dump_start, strlen(dump_start));
> +
> +       return skb->len;
> +}
> +
> +/* Do not call with hci_dev_lock since this calls driver code. */
> +static void hci_devcd_notify(struct hci_dev *hdev, int state)
> +{
> +       if (hdev->dump.notify_change)
> +               hdev->dump.notify_change(hdev, state);
> +}
> +
> +/* Call with hci_dev_lock only. */
> +void hci_devcd_reset(struct hci_dev *hdev)
> +{
> +       hdev->dump.head =3D NULL;
> +       hdev->dump.tail =3D NULL;
> +       hdev->dump.alloc_size =3D 0;
> +
> +       hci_devcd_update_state(hdev, HCI_DEVCOREDUMP_IDLE);
> +
> +       cancel_delayed_work(&hdev->dump.dump_timeout);
> +       skb_queue_purge(&hdev->dump.dump_q);
> +}
> +
> +/* Call with hci_dev_lock only. */
> +static void hci_devcd_free(struct hci_dev *hdev)
> +{
> +       if (hdev->dump.head)
> +               vfree(hdev->dump.head);
> +
> +       hci_devcd_reset(hdev);
> +}
> +
> +/* Call with hci_dev_lock only. */
> +static int hci_devcd_alloc(struct hci_dev *hdev, u32 size)
> +{
> +       hdev->dump.head =3D vmalloc(size);
> +       if (!hdev->dump.head)
> +               return -ENOMEM;
> +
> +       hdev->dump.alloc_size =3D size;
> +       hdev->dump.tail =3D hdev->dump.head;
> +       hdev->dump.end =3D hdev->dump.head + size;
> +
> +       hci_devcd_update_state(hdev, HCI_DEVCOREDUMP_IDLE);
> +
> +       return 0;
> +}
> +
> +/* Call with hci_dev_lock only. */
> +static bool hci_devcd_copy(struct hci_dev *hdev, char *buf, u32 size)
> +{
> +       if (hdev->dump.tail + size > hdev->dump.end)
> +               return false;
> +
> +       memcpy(hdev->dump.tail, buf, size);
> +       hdev->dump.tail +=3D size;
> +
> +       return true;
> +}
> +
> +/* Call with hci_dev_lock only. */
> +static bool hci_devcd_memset(struct hci_dev *hdev, u8 pattern, u32 len)
> +{
> +       if (hdev->dump.tail + len > hdev->dump.end)
> +               return false;
> +
> +       memset(hdev->dump.tail, pattern, len);
> +       hdev->dump.tail +=3D len;
> +
> +       return true;
> +}
> +
> +/* Call with hci_dev_lock only. */
> +static int hci_devcd_prepare(struct hci_dev *hdev, u32 dump_size)
> +{
> +       struct sk_buff *skb;
> +       int dump_hdr_size;
> +       int err =3D 0;
> +
> +       skb =3D alloc_skb(MAX_DEVCOREDUMP_HDR_SIZE, GFP_ATOMIC);
> +       if (!skb)
> +               return -ENOMEM;
> +
> +       dump_hdr_size =3D hci_devcd_mkheader(hdev, skb);
> +
> +       if (hci_devcd_alloc(hdev, dump_hdr_size + dump_size)) {
> +               err =3D -ENOMEM;
> +               goto hdr_free;
> +       }
> +
> +       /* Insert the device header */
> +       if (!hci_devcd_copy(hdev, skb->data, skb->len)) {
> +               bt_dev_err(hdev, "Failed to insert header");
> +               hci_devcd_free(hdev);
> +
> +               err =3D -ENOMEM;
> +               goto hdr_free;
> +       }
> +
> +hdr_free:
> +       kfree_skb(skb);
> +
> +       return err;
> +}
> +
> +static void hci_devcd_handle_pkt_init(struct hci_dev *hdev, struct sk_bu=
ff *skb)
> +{
> +       u32 *dump_size;
> +
> +       if (hdev->dump.state !=3D HCI_DEVCOREDUMP_IDLE) {
> +               DBG_UNEXPECTED_STATE();
> +               return;
> +       }
> +
> +       if (skb->len !=3D sizeof(*dump_size)) {
> +               bt_dev_dbg(hdev, "Invalid dump init pkt");
> +               return;
> +       }
> +
> +       dump_size =3D skb_pull_data(skb, sizeof(*dump_size));
> +       if (!*dump_size) {
> +               bt_dev_err(hdev, "Zero size dump init pkt");
> +               return;
> +       }
> +
> +       if (hci_devcd_prepare(hdev, *dump_size)) {
> +               bt_dev_err(hdev, "Failed to prepare for dump");
> +               return;
> +       }
> +
> +       hci_devcd_update_state(hdev, HCI_DEVCOREDUMP_ACTIVE);
> +       queue_delayed_work(hdev->workqueue, &hdev->dump.dump_timeout,
> +                          DEVCOREDUMP_TIMEOUT);
> +}
> +
> +static void hci_devcd_handle_pkt_skb(struct hci_dev *hdev, struct sk_buf=
f *skb)
> +{
> +       if (hdev->dump.state !=3D HCI_DEVCOREDUMP_ACTIVE) {
> +               DBG_UNEXPECTED_STATE();
> +               return;
> +       }
> +
> +       if (!hci_devcd_copy(hdev, skb->data, skb->len))
> +               bt_dev_dbg(hdev, "Failed to insert skb");
> +}
> +
> +static void hci_devcd_handle_pkt_pattern(struct hci_dev *hdev,
> +                                        struct sk_buff *skb)
> +{
> +       struct hci_devcoredump_skb_pattern *pattern;
> +
> +       if (hdev->dump.state !=3D HCI_DEVCOREDUMP_ACTIVE) {
> +               DBG_UNEXPECTED_STATE();
> +               return;
> +       }
> +
> +       if (skb->len !=3D sizeof(*pattern)) {
> +               bt_dev_dbg(hdev, "Invalid pattern skb");
> +               return;
> +       }
> +
> +       pattern =3D skb_pull_data(skb, sizeof(*pattern));
> +
> +       if (!hci_devcd_memset(hdev, pattern->pattern, pattern->len))
> +               bt_dev_dbg(hdev, "Failed to set pattern");
> +}
> +
> +static void hci_devcd_handle_pkt_complete(struct hci_dev *hdev,
> +                                         struct sk_buff *skb)
> +{
> +       u32 dump_size;
> +
> +       if (hdev->dump.state !=3D HCI_DEVCOREDUMP_ACTIVE) {
> +               DBG_UNEXPECTED_STATE();
> +               return;
> +       }
> +
> +       hci_devcd_update_state(hdev, HCI_DEVCOREDUMP_DONE);
> +       dump_size =3D hdev->dump.tail - hdev->dump.head;
> +
> +       bt_dev_info(hdev, "Devcoredump complete with size %u (expect %zu)=
",
> +                   dump_size, hdev->dump.alloc_size);
> +
> +       dev_coredumpv(&hdev->dev, hdev->dump.head, dump_size, GFP_KERNEL)=
;
> +}
> +
> +static void hci_devcd_handle_pkt_abort(struct hci_dev *hdev,
> +                                      struct sk_buff *skb)
> +{
> +       u32 dump_size;
> +
> +       if (hdev->dump.state !=3D HCI_DEVCOREDUMP_ACTIVE) {
> +               DBG_UNEXPECTED_STATE();
> +               return;
> +       }
> +
> +       hci_devcd_update_state(hdev, HCI_DEVCOREDUMP_ABORT);
> +       dump_size =3D hdev->dump.tail - hdev->dump.head;
> +
> +       bt_dev_info(hdev, "Devcoredump aborted with size %u (expect %zu)"=
,
> +                   dump_size, hdev->dump.alloc_size);
> +
> +       /* Emit a devcoredump with the available data */
> +       dev_coredumpv(&hdev->dev, hdev->dump.head, dump_size, GFP_KERNEL)=
;
> +}
> +
> +/* Bluetooth devcoredump state machine.
> + *
> + * Devcoredump states:
> + *
> + *      HCI_DEVCOREDUMP_IDLE: The default state.
> + *
> + *      HCI_DEVCOREDUMP_ACTIVE: A devcoredump will be in this state once=
 it has
> + *              been initialized using hci_devcd_init(). Once active, th=
e driver
> + *              can append data using hci_devcd_append() or insert a pat=
tern
> + *              using hci_devcd_append_pattern().
> + *
> + *      HCI_DEVCOREDUMP_DONE: Once the dump collection is complete, the =
drive
> + *              can signal the completion using hci_devcd_complete(). A
> + *              devcoredump is generated indicating the completion event=
 and
> + *              then the state machine is reset to the default state.
> + *
> + *      HCI_DEVCOREDUMP_ABORT: The driver can cancel ongoing dump collec=
tion in
> + *              case of any error using hci_devcd_abort(). A devcoredump=
 is
> + *              still generated with the available data indicating the a=
bort
> + *              event and then the state machine is reset to the default=
 state.
> + *
> + *      HCI_DEVCOREDUMP_TIMEOUT: A timeout timer for HCI_DEVCOREDUMP_TIM=
EOUT sec
> + *              is started during devcoredump initialization. Once the t=
imeout
> + *              occurs, the driver is notified, a devcoredump is generat=
ed with
> + *              the available data indicating the timeout event and then=
 the
> + *              state machine is reset to the default state.
> + *
> + * The driver must register using hci_devcd_register() before using the =
hci
> + * devcoredump APIs.
> + */
> +void hci_devcd_rx(struct work_struct *work)
> +{
> +       struct hci_dev *hdev =3D container_of(work, struct hci_dev, dump.=
dump_rx);
> +       struct sk_buff *skb;
> +       int start_state;
> +
> +       while ((skb =3D skb_dequeue(&hdev->dump.dump_q))) {
> +               hci_dev_lock(hdev);
> +               start_state =3D hdev->dump.state;
> +
> +               switch (hci_dmp_cb(skb)->pkt_type) {
> +               case HCI_DEVCOREDUMP_PKT_INIT:
> +                       hci_devcd_handle_pkt_init(hdev, skb);
> +                       break;
> +
> +               case HCI_DEVCOREDUMP_PKT_SKB:
> +                       hci_devcd_handle_pkt_skb(hdev, skb);
> +                       break;
> +
> +               case HCI_DEVCOREDUMP_PKT_PATTERN:
> +                       hci_devcd_handle_pkt_pattern(hdev, skb);
> +                       break;
> +
> +               case HCI_DEVCOREDUMP_PKT_COMPLETE:
> +                       hci_devcd_handle_pkt_complete(hdev, skb);
> +                       break;
> +
> +               case HCI_DEVCOREDUMP_PKT_ABORT:
> +                       hci_devcd_handle_pkt_abort(hdev, skb);
> +                       break;
> +
> +               default:
> +                       bt_dev_dbg(hdev, "Unknown packet (%d) for state (=
%d). ",
> +                                  hci_dmp_cb(skb)->pkt_type, hdev->dump.=
state);
> +                       break;
> +               }
> +
> +               hci_dev_unlock(hdev);
> +               kfree_skb(skb);
> +
> +               /* Notify the driver about any state changes before reset=
ting
> +                * the state machine
> +                */
> +               if (start_state !=3D hdev->dump.state)
> +                       hci_devcd_notify(hdev, hdev->dump.state);
> +
> +               /* Reset the state machine if the devcoredump is complete=
 */
> +               hci_dev_lock(hdev);
> +               if (hdev->dump.state =3D=3D HCI_DEVCOREDUMP_DONE ||
> +                   hdev->dump.state =3D=3D HCI_DEVCOREDUMP_ABORT)
> +                       hci_devcd_reset(hdev);
> +               hci_dev_unlock(hdev);
> +       }
> +}
> +EXPORT_SYMBOL(hci_devcd_rx);
> +
> +void hci_devcd_timeout(struct work_struct *work)
> +{
> +       struct hci_dev *hdev =3D container_of(work, struct hci_dev,
> +                                           dump.dump_timeout.work);
> +       u32 dump_size;
> +
> +       hci_devcd_notify(hdev, HCI_DEVCOREDUMP_TIMEOUT);
> +
> +       hci_dev_lock(hdev);
> +
> +       cancel_work_sync(&hdev->dump.dump_rx);

Sorry I haven't realized this sooner, but the calls to
cancel_work_sync may resume hci_devcd_rx which in turn will attempt to
acquire hci_dev_lock causing a deadlock so you might need to switch to
cancel_work.

> +
> +       hci_devcd_update_state(hdev, HCI_DEVCOREDUMP_TIMEOUT);

Since you are updating the state above I guess hci_devcd_rx should be
able to detect it had timeout, you should probably add a some code
that checks for HCI_DEVCOREDUMP_TIMEOUT and then bails out, that said
it would be great to that emulates a timeout as well to check if this
wouldn't cause deadlocks.

> +       dump_size =3D hdev->dump.tail - hdev->dump.head;
> +       bt_dev_info(hdev, "Devcoredump timeout with size %u (expect %zu)"=
,
> +                   dump_size, hdev->dump.alloc_size);
> +
> +       /* Emit a devcoredump with the available data */
> +       dev_coredumpv(&hdev->dev, hdev->dump.head, dump_size, GFP_KERNEL)=
;
> +
> +       hci_devcd_reset(hdev);
> +
> +       hci_dev_unlock(hdev);
> +}
> +EXPORT_SYMBOL(hci_devcd_timeout);
> +
> +int hci_devcd_register(struct hci_dev *hdev, coredump_t coredump,
> +                      dmp_hdr_t dmp_hdr, notify_change_t notify_change)
> +{
> +       /* Driver must implement coredump() and dmp_hdr() functions for
> +        * bluetooth devcoredump. The coredump() should trigger a coredum=
p
> +        * event on the controller when the device's coredump sysfs entry=
 is
> +        * written to. The dmp_hdr() should create a dump header to ident=
ify
> +        * the controller/fw/driver info.
> +        */
> +       if (!coredump || !dmp_hdr)
> +               return -EINVAL;
> +
> +       hci_dev_lock(hdev);
> +       hdev->dump.coredump =3D coredump;
> +       hdev->dump.dmp_hdr =3D dmp_hdr;
> +       hdev->dump.notify_change =3D notify_change;
> +       hdev->dump.supported =3D true;
> +       hci_dev_unlock(hdev);
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL(hci_devcd_register);
> +
> +static inline bool hci_devcd_enabled(struct hci_dev *hdev)
> +{
> +       return hdev->dump.supported;
> +}
> +
> +int hci_devcd_init(struct hci_dev *hdev, u32 dump_size)
> +{
> +       struct sk_buff *skb;
> +
> +       if (!hci_devcd_enabled(hdev))
> +               return -EOPNOTSUPP;
> +
> +       skb =3D alloc_skb(sizeof(dump_size), GFP_ATOMIC);
> +       if (!skb)
> +               return -ENOMEM;
> +
> +       hci_dmp_cb(skb)->pkt_type =3D HCI_DEVCOREDUMP_PKT_INIT;
> +       skb_put_data(skb, &dump_size, sizeof(dump_size));
> +
> +       skb_queue_tail(&hdev->dump.dump_q, skb);
> +       queue_work(hdev->workqueue, &hdev->dump.dump_rx);
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL(hci_devcd_init);
> +
> +int hci_devcd_append(struct hci_dev *hdev, struct sk_buff *skb)
> +{
> +       if (!skb)
> +               return -ENOMEM;
> +
> +       if (!hci_devcd_enabled(hdev)) {
> +               kfree_skb(skb);
> +               return -EOPNOTSUPP;
> +       }
> +
> +       hci_dmp_cb(skb)->pkt_type =3D HCI_DEVCOREDUMP_PKT_SKB;
> +
> +       skb_queue_tail(&hdev->dump.dump_q, skb);
> +       queue_work(hdev->workqueue, &hdev->dump.dump_rx);
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL(hci_devcd_append);
> +
> +int hci_devcd_append_pattern(struct hci_dev *hdev, u8 pattern, u32 len)
> +{
> +       struct hci_devcoredump_skb_pattern p;
> +       struct sk_buff *skb;
> +
> +       if (!hci_devcd_enabled(hdev))
> +               return -EOPNOTSUPP;
> +
> +       skb =3D alloc_skb(sizeof(p), GFP_ATOMIC);
> +       if (!skb)
> +               return -ENOMEM;
> +
> +       p.pattern =3D pattern;
> +       p.len =3D len;
> +
> +       hci_dmp_cb(skb)->pkt_type =3D HCI_DEVCOREDUMP_PKT_PATTERN;
> +       skb_put_data(skb, &p, sizeof(p));
> +
> +       skb_queue_tail(&hdev->dump.dump_q, skb);
> +       queue_work(hdev->workqueue, &hdev->dump.dump_rx);
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL(hci_devcd_append_pattern);
> +
> +int hci_devcd_complete(struct hci_dev *hdev)
> +{
> +       struct sk_buff *skb;
> +
> +       if (!hci_devcd_enabled(hdev))
> +               return -EOPNOTSUPP;
> +
> +       skb =3D alloc_skb(0, GFP_ATOMIC);
> +       if (!skb)
> +               return -ENOMEM;
> +
> +       hci_dmp_cb(skb)->pkt_type =3D HCI_DEVCOREDUMP_PKT_COMPLETE;
> +
> +       skb_queue_tail(&hdev->dump.dump_q, skb);
> +       queue_work(hdev->workqueue, &hdev->dump.dump_rx);
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL(hci_devcd_complete);
> +
> +int hci_devcd_abort(struct hci_dev *hdev)
> +{
> +       struct sk_buff *skb;
> +
> +       if (!hci_devcd_enabled(hdev))
> +               return -EOPNOTSUPP;
> +
> +       skb =3D alloc_skb(0, GFP_ATOMIC);
> +       if (!skb)
> +               return -ENOMEM;
> +
> +       hci_dmp_cb(skb)->pkt_type =3D HCI_DEVCOREDUMP_PKT_ABORT;
> +
> +       skb_queue_tail(&hdev->dump.dump_q, skb);
> +       queue_work(hdev->workqueue, &hdev->dump.dump_rx);
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL(hci_devcd_abort);
> diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> index 334e308451f5..393b317ae68f 100644
> --- a/net/bluetooth/hci_core.c
> +++ b/net/bluetooth/hci_core.c
> @@ -2544,6 +2544,7 @@ struct hci_dev *hci_alloc_dev_priv(int sizeof_priv)
>         INIT_DELAYED_WORK(&hdev->cmd_timer, hci_cmd_timeout);
>         INIT_DELAYED_WORK(&hdev->ncmd_timer, hci_ncmd_timeout);
>
> +       hci_devcd_setup(hdev);
>         hci_request_setup(hdev);
>
>         hci_init_sysfs(hdev);
> diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
> index 561a519a11bd..2448423912fd 100644
> --- a/net/bluetooth/hci_sync.c
> +++ b/net/bluetooth/hci_sync.c
> @@ -4722,6 +4722,8 @@ int hci_dev_open_sync(struct hci_dev *hdev)
>                 goto done;
>         }
>
> +       hci_devcd_reset(hdev);
> +
>         set_bit(HCI_RUNNING, &hdev->flags);
>         hci_sock_dev_event(hdev, HCI_DEV_OPEN);
>
> --
> 2.40.0.348.gf938b09366-goog
>


--=20
Luiz Augusto von Dentz
