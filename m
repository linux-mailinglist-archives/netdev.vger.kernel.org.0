Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C18D56F1D70
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 19:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346361AbjD1RaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 13:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346308AbjD1RaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 13:30:22 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA9482735;
        Fri, 28 Apr 2023 10:29:49 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id 38308e7fff4ca-2a7ac8a2c8bso98428831fa.3;
        Fri, 28 Apr 2023 10:29:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682702988; x=1685294988;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rmbw99f1eKnBG7X13o9gTV7gBak3jkqwbI2e+wPfQvU=;
        b=QqPRNTupNuhzLReBRh8TA9og4PnhShu/QxDmnfes/QCyOit5Y5SV2jgKzQeyKL/LC4
         OWAAb6wHNLti7ayThIfqVrX6p5vzsLJeI4EBh2LuFr5LQ50eW9KaAA+F3HjkocyIj2Ea
         +K1t+cXxXtWMit0JZKHnFfC5sXFXw81nC4pVW0D/efde+cNDEhC/IIih70LvozK7SB6r
         7Q6jsWEy5mjGqG6dxK2zD0Z6cmQhkOpmvg4Bz8ENRB+hzzbHiQYSmy4Vb265D325/Nw2
         Nb1l+pC8fafZVvAzXH4hZnWvJH+xD/b49DqajtCibdkraprNvSpbtEJdPk+09jKr0XC3
         kGlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682702988; x=1685294988;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Rmbw99f1eKnBG7X13o9gTV7gBak3jkqwbI2e+wPfQvU=;
        b=da8TKRi9MH3fSwRn4ohpI+QPy45yLdOGjjhiy38RFRGbuFJmfl+Gr0bB5ipTlFDkzv
         ThHPh2AIUykU2HlIRTqcGJcln6YF2OlnzFbldH0tETKjmxXY7hNWlqIvZYjYSXfvlD5s
         Iz0A1DM09YmgCUrd1Z8HpQaJUY2Xh7qO8V2Yr+Y4fmczTFsXQUHdid7fFamGDECVzIBm
         y6s4g/xhQDJBa2nCjpwUjbzldpmsUHQNKjh1i4HnCOAOsCsLxruLfiWZa6uMzH5DwHxi
         WIzgbJpvO77Lhht/7CgPOD21RRobIN7n0u19Zm6wwJ5q0nZh1/hxtiU5dpsTQnpy/nID
         gENA==
X-Gm-Message-State: AC+VfDzZI2UbkQU2kjnbTyfJwQJgnS2qh9G9EQjlr6rZKf7t4qFdDT8A
        fRaaob3c59sgHlGJFnZhYIgaP3kVUaAeyZfoGws=
X-Google-Smtp-Source: ACHHUZ71qe+Xzo8QXfU+X5rhNjiIrIbh4AI6P9ZUORx5TM2AgHVsZiz9MpLQRDHnMnJTRpns07HZe37QTtEnMR9uC24=
X-Received: by 2002:a2e:9ad8:0:b0:2a7:79e6:1630 with SMTP id
 p24-20020a2e9ad8000000b002a779e61630mr1757501ljj.25.1682702987813; Fri, 28
 Apr 2023 10:29:47 -0700 (PDT)
MIME-Version: 1.0
References: <20230424091857.3652-1-hildawu@realtek.com>
In-Reply-To: <20230424091857.3652-1-hildawu@realtek.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Fri, 28 Apr 2023 10:29:35 -0700
Message-ID: <CABBYNZK+SjUg19LXKp8B5sz_W2G-MW1yUPfCwN_2mo1Fjbm-nA@mail.gmail.com>
Subject: Re: [PATCH v3] Bluetooth: msft: Extended monitor tracking by address filter
To:     hildawu@realtek.com
Cc:     marcel@holtmann.org, johan.hedberg@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, apusaka@chromium.org,
        mmandlik@google.com, yinghsu@chromium.org,
        simon.horman@corigine.com, max.chou@realtek.com,
        alex_lu@realsil.com.cn, kidman@realtek.com
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

Hi Hilda,

On Mon, Apr 24, 2023 at 2:19=E2=80=AFAM <hildawu@realtek.com> wrote:
>
> From: Hilda Wu <hildawu@realtek.com>
>
> Since limited tracking device per condition, this feature is to support
> tracking multiple devices concurrently.
> When a pattern monitor detects the device, this feature issues an address
> monitor for tracking that device. Let pattern monitor can keep monitor
> new devices.
> This feature adds an address filter when receiving a LE monitor device
> event which monitor handle is for a pattern, and the controller started
> monitoring the device. And this feature also has cancelled the monitor
> advertisement from address filters when receiving a LE monitor device
> event when the controller stopped monitoring the device specified by an
> address and monitor handle.
>
> Signed-off-by: Alex Lu <alex_lu@realsil.com.cn>
> Signed-off-by: Hilda Wu <hildawu@realtek.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> ---
> Changes in v3:
> - Added flag for the feature.
> - Modified debug message level.
> - Follow suggested, using reverse xmas tree in new code.
>
> Changes in v2:
> - Fixed build bot warning, removed un-used parameter.
> - Follow suggested, adjust for readability and idiomatic, modified
>   error case, etc.
> ---
> ---
>  drivers/bluetooth/btrtl.c   |   4 +
>  include/net/bluetooth/hci.h |   9 +
>  net/bluetooth/msft.c        | 496 ++++++++++++++++++++++++++++++++++--
>  3 files changed, 494 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/bluetooth/btrtl.c b/drivers/bluetooth/btrtl.c
> index 2915c82d719d..846e0a60cd8d 100644
> --- a/drivers/bluetooth/btrtl.c
> +++ b/drivers/bluetooth/btrtl.c
> @@ -1180,6 +1180,10 @@ void btrtl_set_quirks(struct hci_dev *hdev, struct=
 btrtl_device_info *btrtl_dev)
>                 if (btrtl_dev->project_id =3D=3D CHIP_ID_8852C)
>                         btrealtek_set_flag(hdev, REALTEK_ALT6_CONTINUOUS_=
TX_CHIP);
>
> +               if (btrtl_dev->project_id =3D=3D CHIP_ID_8852A ||
> +                   btrtl_dev->project_id =3D=3D CHIP_ID_8852C)
> +                       set_bit(HCI_QUIRK_MSFT_EXT_MAF_SUPPORTED, &hdev->=
quirks);
> +
>                 hci_set_aosp_capable(hdev);
>                 break;
>         default:
> diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
> index 07df96c47ef4..48d8068a5a18 100644
> --- a/include/net/bluetooth/hci.h
> +++ b/include/net/bluetooth/hci.h
> @@ -309,6 +309,15 @@ enum {
>          * to support it.
>          */
>         HCI_QUIRK_BROKEN_SET_RPA_TIMEOUT,
> +
> +       /* When this quirk is set, extended monitor tracking by address f=
ilter
> +        * (MAF) is supported by the driver since limited tracking device=
 per
> +        * condition, this feature is to support tracking multiple device=
s
> +        * concurrently, a driver flag is use to convey this support.
> +        *
> +        * This quirk must be set before hci_register_dev is called.
> +        */
> +       HCI_QUIRK_MSFT_EXT_MAF_SUPPORTED,
>  };
>
>  /* HCI device flags */
> diff --git a/net/bluetooth/msft.c b/net/bluetooth/msft.c
> index bf5cee48916c..37d489f84eba 100644
> --- a/net/bluetooth/msft.c
> +++ b/net/bluetooth/msft.c
> @@ -91,17 +91,48 @@ struct msft_ev_le_monitor_device {
>  struct msft_monitor_advertisement_handle_data {
>         __u8  msft_handle;
>         __u16 mgmt_handle;
> +       __s8 rssi_high;
> +       __s8 rssi_low;
> +       __u8 rssi_low_interval;
> +       __u8 rssi_sampling_period;
> +       __u8 cond_type;
> +       struct list_head list;
> +};
> +
> +#define MSFT_MONITOR_ADVERTISEMENT_TYPE_ADDR   0x04
> +struct msft_monitor_addr_filter_data {
> +       __u8     msft_handle;
> +       __u8     pattern_handle; /* address filters pertain to */
> +       __u16    mgmt_handle;
> +       bool     active;
> +       __s8     rssi_high;
> +       __s8     rssi_low;
> +       __u8     rssi_low_interval;
> +       __u8     rssi_sampling_period;
> +       __u8     addr_type;
> +       bdaddr_t bdaddr;
>         struct list_head list;
>  };
>
> +struct addr_filter_skb_cb {
> +       u8       pattern_handle;
> +       u8       addr_type;
> +       bdaddr_t bdaddr;
> +};
> +
> +#define addr_filter_cb(skb) ((struct addr_filter_skb_cb *)((skb)->cb))
> +
>  struct msft_data {
>         __u64 features;
>         __u8  evt_prefix_len;
>         __u8  *evt_prefix;
>         struct list_head handle_map;
> +       struct list_head address_filters;
>         __u8 resuming;
>         __u8 suspending;
>         __u8 filter_enabled;
> +       /* To synchronize add/remove address filter and monitor device ev=
ent.*/
> +       struct mutex filter_lock;
>  };
>
>  bool msft_monitor_supported(struct hci_dev *hdev)
> @@ -180,6 +211,24 @@ static struct msft_monitor_advertisement_handle_data=
 *msft_find_handle_data
>         return NULL;
>  }
>
> +/* This function requires the caller holds msft->filter_lock */
> +static struct msft_monitor_addr_filter_data *msft_find_address_data
> +                       (struct hci_dev *hdev, u8 addr_type, bdaddr_t *ad=
dr,
> +                        u8 pattern_handle)
> +{
> +       struct msft_monitor_addr_filter_data *entry;
> +       struct msft_data *msft =3D hdev->msft_data;
> +
> +       list_for_each_entry(entry, &msft->address_filters, list) {
> +               if (entry->pattern_handle =3D=3D pattern_handle &&
> +                   addr_type =3D=3D entry->addr_type &&
> +                   !bacmp(addr, &entry->bdaddr))
> +                       return entry;
> +       }
> +
> +       return NULL;
> +}
> +
>  /* This function requires the caller holds hdev->lock */
>  static int msft_monitor_device_del(struct hci_dev *hdev, __u16 mgmt_hand=
le,
>                                    bdaddr_t *bdaddr, __u8 addr_type,
> @@ -240,6 +289,7 @@ static int msft_le_monitor_advertisement_cb(struct hc=
i_dev *hdev, u16 opcode,
>
>         handle_data->mgmt_handle =3D monitor->handle;
>         handle_data->msft_handle =3D rp->handle;
> +       handle_data->cond_type   =3D MSFT_MONITOR_ADVERTISEMENT_TYPE_PATT=
ERN;
>         INIT_LIST_HEAD(&handle_data->list);
>         list_add(&handle_data->list, &msft->handle_map);
>
> @@ -254,6 +304,62 @@ static int msft_le_monitor_advertisement_cb(struct h=
ci_dev *hdev, u16 opcode,
>         return status;
>  }
>
> +/* This function requires the caller holds hci_req_sync_lock */
> +static void msft_remove_addr_filters_sync(struct hci_dev *hdev, u8 handl=
e)
> +{
> +       struct msft_monitor_addr_filter_data *address_filter, *n;
> +       struct msft_cp_le_cancel_monitor_advertisement cp;
> +       struct msft_data *msft =3D hdev->msft_data;
> +       struct list_head head;
> +       struct sk_buff *skb;
> +
> +       INIT_LIST_HEAD(&head);
> +
> +       /* Cancel all corresponding address monitors */
> +       mutex_lock(&msft->filter_lock);
> +
> +       list_for_each_entry_safe(address_filter, n, &msft->address_filter=
s,
> +                                list) {
> +               if (address_filter->pattern_handle !=3D handle)
> +                       continue;
> +
> +               list_del(&address_filter->list);
> +
> +               /* If the address_filter was added but haven't been enabl=
ed,
> +                * just free it.
> +                */
> +               if (!address_filter->active) {
> +                       kfree(address_filter);
> +                       continue;
> +               }
> +
> +               list_add_tail(&address_filter->list, &head);
> +       }
> +
> +       mutex_unlock(&msft->filter_lock);
> +
> +       list_for_each_entry_safe(address_filter, n, &head, list) {
> +               list_del(&address_filter->list);
> +
> +               cp.sub_opcode =3D MSFT_OP_LE_CANCEL_MONITOR_ADVERTISEMENT=
;
> +               cp.handle =3D address_filter->msft_handle;
> +
> +               skb =3D __hci_cmd_sync(hdev, hdev->msft_opcode, sizeof(cp=
), &cp,
> +                                    HCI_CMD_TIMEOUT);
> +               if (IS_ERR_OR_NULL(skb)) {
> +                       kfree(address_filter);
> +                       continue;
> +               }
> +
> +               kfree_skb(skb);
> +
> +               bt_dev_info(hdev, "MSFT: Canceled device %pMR address fil=
ter",
> +                           &address_filter->bdaddr);
> +
> +               kfree(address_filter);
> +       }
> +}
> +
>  static int msft_le_cancel_monitor_advertisement_cb(struct hci_dev *hdev,
>                                                    u16 opcode,
>                                                    struct adv_monitor *mo=
nitor,
> @@ -263,6 +369,7 @@ static int msft_le_cancel_monitor_advertisement_cb(st=
ruct hci_dev *hdev,
>         struct msft_monitor_advertisement_handle_data *handle_data;
>         struct msft_data *msft =3D hdev->msft_data;
>         int status =3D 0;
> +       u8 msft_handle;
>
>         rp =3D (struct msft_rp_le_cancel_monitor_advertisement *)skb->dat=
a;
>         if (skb->len < sizeof(*rp)) {
> @@ -293,11 +400,17 @@ static int msft_le_cancel_monitor_advertisement_cb(=
struct hci_dev *hdev,
>                                                 NULL, 0, false);
>                 }
>
> +               msft_handle =3D handle_data->msft_handle;
> +
>                 list_del(&handle_data->list);
>                 kfree(handle_data);
> -       }
>
> -       hci_dev_unlock(hdev);
> +               hci_dev_unlock(hdev);
> +
> +               msft_remove_addr_filters_sync(hdev, msft_handle);
> +       } else {
> +               hci_dev_unlock(hdev);
> +       }
>
>  done:
>         return status;
> @@ -394,12 +507,14 @@ static int msft_add_monitor_sync(struct hci_dev *hd=
ev,
>  {
>         struct msft_cp_le_monitor_advertisement *cp;
>         struct msft_le_monitor_advertisement_pattern_data *pattern_data;
> +       struct msft_monitor_advertisement_handle_data *handle_data;
>         struct msft_le_monitor_advertisement_pattern *pattern;
>         struct adv_pattern *entry;
>         size_t total_size =3D sizeof(*cp) + sizeof(*pattern_data);
>         ptrdiff_t offset =3D 0;
>         u8 pattern_count =3D 0;
>         struct sk_buff *skb;
> +       int err;
>
>         if (!msft_monitor_pattern_valid(monitor))
>                 return -EINVAL;
> @@ -436,16 +551,31 @@ static int msft_add_monitor_sync(struct hci_dev *hd=
ev,
>
>         skb =3D __hci_cmd_sync(hdev, hdev->msft_opcode, total_size, cp,
>                              HCI_CMD_TIMEOUT);
> -       kfree(cp);
>
>         if (IS_ERR_OR_NULL(skb)) {
> -               if (!skb)
> -                       return -EIO;
> -               return PTR_ERR(skb);
> +               err =3D PTR_ERR(skb);
> +               goto out_free;
>         }
>
> -       return msft_le_monitor_advertisement_cb(hdev, hdev->msft_opcode,
> -                                               monitor, skb);
> +       err =3D msft_le_monitor_advertisement_cb(hdev, hdev->msft_opcode,
> +                                              monitor, skb);
> +       if (err)
> +               goto out_free;
> +
> +       handle_data =3D msft_find_handle_data(hdev, monitor->handle, true=
);
> +       if (!handle_data) {
> +               err =3D -ENODATA;
> +               goto out_free;
> +       }
> +
> +       handle_data->rssi_high  =3D cp->rssi_high;
> +       handle_data->rssi_low   =3D cp->rssi_low;
> +       handle_data->rssi_low_interval    =3D cp->rssi_low_interval;
> +       handle_data->rssi_sampling_period =3D cp->rssi_sampling_period;
> +
> +out_free:
> +       kfree(cp);
> +       return err;
>  }
>
>  /* This function requires the caller holds hci_req_sync_lock */
> @@ -538,6 +668,7 @@ void msft_do_close(struct hci_dev *hdev)
>  {
>         struct msft_data *msft =3D hdev->msft_data;
>         struct msft_monitor_advertisement_handle_data *handle_data, *tmp;
> +       struct msft_monitor_addr_filter_data *address_filter, *n;
>         struct adv_monitor *monitor;
>
>         if (!msft)
> @@ -559,6 +690,14 @@ void msft_do_close(struct hci_dev *hdev)
>                 kfree(handle_data);
>         }
>
> +       mutex_lock(&msft->filter_lock);
> +       list_for_each_entry_safe(address_filter, n, &msft->address_filter=
s,
> +                                list) {
> +               list_del(&address_filter->list);
> +               kfree(address_filter);
> +       }
> +       mutex_unlock(&msft->filter_lock);
> +
>         hci_dev_lock(hdev);
>
>         /* Clear any devices that are being monitored and notify device l=
ost */
> @@ -568,6 +707,58 @@ void msft_do_close(struct hci_dev *hdev)
>         hci_dev_unlock(hdev);
>  }
>
> +static int msft_cancel_address_filter_sync(struct hci_dev *hdev, void *d=
ata)
> +{
> +       struct msft_monitor_addr_filter_data *address_filter =3D NULL;

I would suggest passing the filter as data instead of having to lookup
on the callback.

> +       struct msft_cp_le_cancel_monitor_advertisement cp;
> +       struct msft_data *msft =3D hdev->msft_data;
> +       struct sk_buff *nskb;
> +       u8 handle =3D PTR_ERR(data);
> +
> +       if (!msft) {
> +               bt_dev_err(hdev, "MSFT: msft data is freed");
> +               return -EINVAL;
> +       }
> +
> +       mutex_lock(&msft->filter_lock);
> +
> +       list_for_each_entry(address_filter, &msft->address_filters, list)=
 {
> +               if (address_filter->active &&
> +                   handle =3D=3D address_filter->msft_handle) {
> +                       break;
> +               }
> +       }
> +       if (!address_filter) {
> +               bt_dev_warn(hdev, "MSFT: No active addr filter (%u) to ca=
ncel",
> +                           handle);
> +               mutex_unlock(&msft->filter_lock);
> +               return -ENODEV;
> +       }
> +       list_del(&address_filter->list);
> +
> +       mutex_unlock(&msft->filter_lock);
> +
> +       cp.sub_opcode =3D MSFT_OP_LE_CANCEL_MONITOR_ADVERTISEMENT;
> +       cp.handle =3D address_filter->msft_handle;
> +
> +       nskb =3D __hci_cmd_sync(hdev, hdev->msft_opcode, sizeof(cp), &cp,
> +                             HCI_CMD_TIMEOUT);
> +       if (IS_ERR_OR_NULL(nskb)) {
> +               bt_dev_err(hdev, "MSFT: Failed to cancel address (%pMR) f=
ilter",
> +                          &address_filter->bdaddr);
> +               kfree(address_filter);
> +               return -EIO;
> +       }
> +       kfree_skb(nskb);
> +
> +       bt_dev_dbg(hdev, "MSFT: Canceled device %pMR address filter",
> +                  &address_filter->bdaddr);
> +
> +       kfree(address_filter);
> +
> +       return 0;
> +}
> +
>  void msft_register(struct hci_dev *hdev)
>  {
>         struct msft_data *msft =3D NULL;
> @@ -581,7 +772,9 @@ void msft_register(struct hci_dev *hdev)
>         }
>
>         INIT_LIST_HEAD(&msft->handle_map);
> +       INIT_LIST_HEAD(&msft->address_filters);
>         hdev->msft_data =3D msft;
> +       mutex_init(&msft->filter_lock);
>  }
>
>  void msft_unregister(struct hci_dev *hdev)
> @@ -596,6 +789,7 @@ void msft_unregister(struct hci_dev *hdev)
>         hdev->msft_data =3D NULL;
>
>         kfree(msft->evt_prefix);
> +       mutex_destroy(&msft->filter_lock);
>         kfree(msft);
>  }
>
> @@ -645,11 +839,234 @@ static void *msft_skb_pull(struct hci_dev *hdev, s=
truct sk_buff *skb,
>         return data;
>  }
>
> +static int msft_add_address_filter_sync(struct hci_dev *hdev, void *data=
)
> +{
> +       struct msft_monitor_addr_filter_data *address_filter =3D NULL;
> +       struct msft_rp_le_monitor_advertisement *rp;
> +       struct msft_data *msft =3D hdev->msft_data;
> +       struct sk_buff *skb =3D data;
> +       struct sk_buff *nskb;
> +       bool remove =3D false;
> +       int err;
> +
> +       if (!msft) {
> +               bt_dev_err(hdev, "MSFT: msft data is freed");
> +               err =3D -EINVAL;
> +               goto error;
> +       }
> +
> +       mutex_lock(&msft->filter_lock);
> +
> +       address_filter =3D msft_find_address_data(hdev,
> +                                               addr_filter_cb(skb)->addr=
_type,
> +                                               &addr_filter_cb(skb)->bda=
ddr,
> +                                               addr_filter_cb(skb)->patt=
ern_handle);
> +       mutex_unlock(&msft->filter_lock);
> +       if (!address_filter) {
> +               bt_dev_warn(hdev, "MSFT: No address (%pMR) filter to enab=
le",
> +                           &addr_filter_cb(skb)->bdaddr);
> +               err =3D -ENODEV;
> +               goto error;
> +       }
> +
> +send_cmd:
> +       nskb =3D __hci_cmd_sync(hdev, hdev->msft_opcode, skb->len, skb->d=
ata,
> +                             HCI_CMD_TIMEOUT);
> +       if (IS_ERR_OR_NULL(nskb)) {
> +               bt_dev_err(hdev, "Failed to enable address %pMR filter",
> +                          &address_filter->bdaddr);
> +               nskb =3D NULL;
> +               remove =3D true;
> +               goto done;
> +       }
> +
> +       rp =3D (struct msft_rp_le_monitor_advertisement *)nskb->data;

For this sort of checks there is skb_pull_data, I also I don't think
you need to cast since the return is void *.

> +       if (nskb->len < sizeof(*rp) ||
> +           rp->sub_opcode !=3D MSFT_OP_LE_MONITOR_ADVERTISEMENT) {
> +               remove =3D true;
> +               goto done;
> +       }

This sort of policy below doesn't belong in the kernel since it is
much harder to change if necessary, instead we shall signal the error
back to userspace which will then take care of rotating the filters,
etc.

> +       /* If Controller's memory capacity exceeded, cancel the first add=
ress
> +        * filter in the msft->address_filters, then try to add the new a=
ddress
> +        * filter.
> +        */
> +       if (rp->status =3D=3D HCI_ERROR_MEMORY_EXCEEDED) {
> +               struct msft_cp_le_cancel_monitor_advertisement cp;
> +               struct msft_monitor_addr_filter_data *n;
> +               u8 addr_type =3D 0xff;
> +
> +               mutex_lock(&msft->filter_lock);
> +
> +               /* If the current address filter is the first one in
> +                * msft->address_filters, it means no active address filt=
er in
> +                * Controller.
> +                */
> +               if (list_is_first(&address_filter->list,
> +                                 &msft->address_filters)) {
> +                       mutex_unlock(&msft->filter_lock);
> +                       bt_dev_err(hdev, "Memory capacity exceeded");
> +                       remove =3D true;
> +                       goto done;
> +               }
> +
> +               n =3D list_first_entry(&msft->address_filters,
> +                                    struct msft_monitor_addr_filter_data=
,
> +                                    list);
> +               list_del(&n->list);
> +
> +               mutex_unlock(&msft->filter_lock);
> +
> +               cp.sub_opcode =3D MSFT_OP_LE_CANCEL_MONITOR_ADVERTISEMENT=
;
> +               cp.handle =3D n->msft_handle;
> +
> +               nskb =3D __hci_cmd_sync(hdev, hdev->msft_opcode, sizeof(c=
p), &cp,
> +                                     HCI_CMD_TIMEOUT);
> +               if (IS_ERR_OR_NULL(nskb)) {
> +                       bt_dev_err(hdev, "MSFT: Failed to cancel filter (=
%pMR)",
> +                                  &n->bdaddr);
> +                       kfree(n);
> +                       remove =3D true;
> +                       goto done;
> +               }
> +
> +               /* Fake a device lost event after canceling the correspon=
ding
> +                * address filter.
> +                */
> +               hci_dev_lock(hdev);
> +
> +               switch (n->addr_type) {
> +               case ADDR_LE_DEV_PUBLIC:
> +                       addr_type =3D BDADDR_LE_PUBLIC;
> +                       break;
> +
> +               case ADDR_LE_DEV_RANDOM:
> +                       addr_type =3D BDADDR_LE_RANDOM;
> +                       break;
> +
> +               default:
> +                       bt_dev_err(hdev, "MSFT unknown addr type 0x%02x",
> +                                  n->addr_type);
> +                       break;
> +               }
> +
> +               msft_device_lost(hdev, &n->bdaddr, addr_type,
> +                                n->mgmt_handle);
> +               hci_dev_unlock(hdev);
> +
> +               kfree(n);
> +               kfree_skb(nskb);
> +               goto send_cmd;
> +       } else if (rp->status) {
> +               bt_dev_err(hdev, "Enable address filter err (status 0x%02=
x)",
> +                          rp->status);
> +               remove =3D true;
> +       }
> +
> +done:
> +       kfree_skb(skb);
> +
> +       mutex_lock(&msft->filter_lock);
> +
> +       /* Be careful about address_filter that is not protected by the
> +        * filter_lock while the above __hci_cmd_sync() is running.
> +        */
> +       if (remove) {
> +               bt_dev_warn(hdev, "MSFT: Remove address (%pMR) filter",
> +                           &address_filter->bdaddr);
> +               list_del(&address_filter->list);
> +               kfree(address_filter);
> +       } else {
> +               address_filter->active =3D true;
> +               address_filter->msft_handle =3D rp->handle;
> +               bt_dev_dbg(hdev, "MSFT: Address %pMR filter enabled",
> +                          &address_filter->bdaddr);
> +       }
> +
> +       mutex_unlock(&msft->filter_lock);
> +
> +       kfree_skb(nskb);
> +
> +       return 0;
> +error:
> +       kfree_skb(skb);
> +       return err;
> +}
> +
> +/* This function requires the caller holds msft->filter_lock */
> +static struct msft_monitor_addr_filter_data *msft_add_address_filter
> +               (struct hci_dev *hdev, u8 addr_type, bdaddr_t *bdaddr,
> +                struct msft_monitor_advertisement_handle_data *handle_da=
ta)
> +{
> +       struct msft_monitor_addr_filter_data *address_filter =3D NULL;
> +       struct msft_cp_le_monitor_advertisement *cp;
> +       struct msft_data *msft =3D hdev->msft_data;
> +       struct sk_buff *skb;
> +       size_t size;
> +       int err;
> +
> +       size =3D sizeof(*cp) + sizeof(addr_type) + sizeof(*bdaddr);
> +       skb =3D alloc_skb(size, GFP_KERNEL);
> +       if (!skb) {
> +               bt_dev_err(hdev, "MSFT: alloc skb err in device evt");
> +               return NULL;
> +       }
> +
> +       cp =3D skb_put(skb, sizeof(*cp));
> +       cp->sub_opcode      =3D MSFT_OP_LE_MONITOR_ADVERTISEMENT;
> +       cp->rssi_high       =3D handle_data->rssi_high;
> +       cp->rssi_low        =3D handle_data->rssi_low;
> +       cp->rssi_low_interval    =3D handle_data->rssi_low_interval;
> +       cp->rssi_sampling_period =3D handle_data->rssi_sampling_period;
> +       cp->cond_type       =3D MSFT_MONITOR_ADVERTISEMENT_TYPE_ADDR;
> +       skb_put_u8(skb, addr_type);
> +       skb_put_data(skb, bdaddr, sizeof(*bdaddr));
> +
> +       address_filter =3D kzalloc(sizeof(*address_filter), GFP_KERNEL);
> +       if (!address_filter)
> +               goto err_skb;
> +
> +       address_filter->active               =3D false;
> +       address_filter->msft_handle          =3D 0xff;
> +       address_filter->pattern_handle       =3D handle_data->msft_handle=
;
> +       address_filter->mgmt_handle          =3D handle_data->mgmt_handle=
;
> +       address_filter->rssi_high            =3D cp->rssi_high;
> +       address_filter->rssi_low             =3D cp->rssi_low;
> +       address_filter->rssi_low_interval    =3D cp->rssi_low_interval;
> +       address_filter->rssi_sampling_period =3D cp->rssi_sampling_period=
;
> +       address_filter->addr_type            =3D addr_type;
> +       bacpy(&address_filter->bdaddr, bdaddr);
> +       list_add_tail(&address_filter->list, &msft->address_filters);

What about we don't add to the list until it is active?

> +
> +       addr_filter_cb(skb)->pattern_handle =3D address_filter->pattern_h=
andle;
> +       addr_filter_cb(skb)->addr_type =3D addr_type;
> +       bacpy(&addr_filter_cb(skb)->bdaddr, bdaddr);

Instead of the skb I would pass the data instead, you probably don't
really need the skb custom data since it is only used for looking up
the filter but if you pass as callback data that resolve itself, also
you can construct the parameters using a stack variable.

> +       err =3D hci_cmd_sync_queue(hdev, msft_add_address_filter_sync, sk=
b, NULL);
> +       if (err < 0) {
> +               bt_dev_err(hdev, "MSFT: Add address %pMR filter err", bda=
ddr);
> +               list_del(&address_filter->list);
> +               kfree(address_filter);
> +               goto err_skb;
> +       }
> +
> +       bt_dev_dbg(hdev, "MSFT: Add device %pMR address filter",
> +                  &address_filter->bdaddr);
> +
> +       return address_filter;
> +err_skb:
> +       kfree_skb(skb);
> +       return NULL;
> +}
> +
>  /* This function requires the caller holds hdev->lock */
>  static void msft_monitor_device_evt(struct hci_dev *hdev, struct sk_buff=
 *skb)
>  {
> +       struct msft_monitor_addr_filter_data *n, *address_filter =3D NULL=
;
>         struct msft_ev_le_monitor_device *ev;
>         struct msft_monitor_advertisement_handle_data *handle_data;
> +       struct msft_data *msft =3D hdev->msft_data;
> +       u16 mgmt_handle =3D 0xffff;
>         u8 addr_type;
>
>         ev =3D msft_skb_pull(hdev, skb, MSFT_EV_LE_MONITOR_DEVICE, sizeof=
(*ev));
> @@ -662,9 +1079,52 @@ static void msft_monitor_device_evt(struct hci_dev =
*hdev, struct sk_buff *skb)
>                    ev->monitor_state, &ev->bdaddr);
>
>         handle_data =3D msft_find_handle_data(hdev, ev->monitor_handle, f=
alse);
> -       if (!handle_data)
> +
> +       if (!test_bit(HCI_QUIRK_MSFT_EXT_MAF_SUPPORTED, &hdev->quirks)) {
> +               if (!handle_data)
> +                       return;
> +               mgmt_handle =3D handle_data->mgmt_handle;
> +               goto report_state;
> +       }
> +
> +       if (handle_data) {
> +               /* Don't report any device found/lost event from pattern
> +                * monitors. Pattern monitor always has its address filte=
rs for
> +                * tracking devices.
> +                */
> +
> +               address_filter =3D msft_find_address_data(hdev, ev->addr_=
type,
> +                                                       &ev->bdaddr,
> +                                                       handle_data->msft=
_handle);
> +               if (address_filter)
> +                       return;
> +
> +               if (ev->monitor_state && handle_data->cond_type =3D=3D
> +                               MSFT_MONITOR_ADVERTISEMENT_TYPE_PATTERN)
> +                       msft_add_address_filter(hdev, ev->addr_type,
> +                                               &ev->bdaddr, handle_data)=
;
> +
>                 return;
> +       }
>
> +       /* This device event is not from pattern monitor.
> +        * Report it if there is a corresponding address_filter for it.
> +        */
> +       list_for_each_entry(n, &msft->address_filters, list) {
> +               if (n->active && n->msft_handle =3D=3D ev->monitor_handle=
) {
> +                       mgmt_handle =3D n->mgmt_handle;
> +                       address_filter =3D n;
> +                       break;
> +               }
> +       }
> +
> +       if (!address_filter) {
> +               bt_dev_warn(hdev, "MSFT: Unexpected device event %pMR, %u=
, %u",
> +                           &ev->bdaddr, ev->monitor_handle, ev->monitor_=
state);
> +               return;
> +       }
> +
> +report_state:
>         switch (ev->addr_type) {
>         case ADDR_LE_DEV_PUBLIC:
>                 addr_type =3D BDADDR_LE_PUBLIC;
> @@ -681,12 +1141,16 @@ static void msft_monitor_device_evt(struct hci_dev=
 *hdev, struct sk_buff *skb)
>                 return;
>         }
>
> -       if (ev->monitor_state)
> -               msft_device_found(hdev, &ev->bdaddr, addr_type,
> -                                 handle_data->mgmt_handle);
> -       else
> -               msft_device_lost(hdev, &ev->bdaddr, addr_type,
> -                                handle_data->mgmt_handle);
> +       if (ev->monitor_state) {
> +               msft_device_found(hdev, &ev->bdaddr, addr_type, mgmt_hand=
le);
> +       } else {
> +               if (address_filter && address_filter->active)
> +                       hci_cmd_sync_queue(hdev,
> +                                          msft_cancel_address_filter_syn=
c,
> +                                          ERR_PTR(address_filter->msft_h=
andle),
> +                                          NULL);
> +               msft_device_lost(hdev, &ev->bdaddr, addr_type, mgmt_handl=
e);
> +       }
>  }
>
>  void msft_vendor_evt(struct hci_dev *hdev, void *data, struct sk_buff *s=
kb)
> @@ -724,7 +1188,9 @@ void msft_vendor_evt(struct hci_dev *hdev, void *dat=
a, struct sk_buff *skb)
>
>         switch (*evt) {
>         case MSFT_EV_LE_MONITOR_DEVICE:
> +               mutex_lock(&msft->filter_lock);
>                 msft_monitor_device_evt(hdev, skb);
> +               mutex_unlock(&msft->filter_lock);
>                 break;
>
>         default:
> --
> 2.17.1
>


--=20
Luiz Augusto von Dentz
