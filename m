Return-Path: <netdev+bounces-8649-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DB2F97250CA
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 01:27:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 77DAA281044
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 23:27:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C18934D62;
	Tue,  6 Jun 2023 23:27:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6778E7E4
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 23:27:29 +0000 (UTC)
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 048D61706;
	Tue,  6 Jun 2023 16:27:26 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id 38308e7fff4ca-2b1b66a8fd5so55053651fa.0;
        Tue, 06 Jun 2023 16:27:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686094044; x=1688686044;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6Q+L+L9DLQME3Ovcj68Z2TW5sWtJPin3tlzVXFqoVd8=;
        b=i/TRs+EuZInOTWVUZ9V3lmopzuCEErjeBhqrVgLmqc+y0YKwvTsvaId5Xpy1uKYxlc
         qfRTheDiYhOlw04JeoKv6CV3GmrOHpntaSwlrJkPKRncrdeTSaio7Rx0rg7lyP6geD7y
         E3lVHZDobTw2TsQw1/acVSuQ1O0h+rmwLQbomk/sYchQJJ3jjyPC84ro0z2mun9yJFXk
         1iHopXIIL9GHE21EcwLwVaccIFhAmFIiNWshwupAPuIuHnho4EusDwju7nLn/Q8vbc7u
         I4+clKQ1Aq1XpG58MecOrcpzZGqXXb7pVkcjgso7PMr1V4Beqfe8UaOxP6yqOI8dg0rg
         qL9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686094044; x=1688686044;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6Q+L+L9DLQME3Ovcj68Z2TW5sWtJPin3tlzVXFqoVd8=;
        b=FgeMS/nRb6j0ZhBhZUK6srKSq+Sf5+NjEEwS8P0F678DwlfwZNwNPgVLz/V5VaCz9V
         ZF6egniAeiQsh89Yzh8eMmwjHmkDk+imw+R04hyey/ekq0UQR6ydHWUQ3beusPW0Nmyb
         xSDnT7HlB9V2H/lFhLCgUPsdDdk1sZQD83bevxeMsSidTvfjX79BC9EFSQVqF0psFiFH
         pBf249T/pHLMaTh/3095eb6mbvOs4rr4SNRT2D8qlOoScfGePipeOTFr8cE+fT68hh7x
         P4QfSZvLbuOLpOUCAm5PROHsb7xqBh0mnAlKQVYcJbC/sgLm3szxP++7wG4A08LXxIu7
         K0aw==
X-Gm-Message-State: AC+VfDyzWOpnnPkXAmBqGKQV5pNMLWPUfi0+C1u1pAzhXPNWByup8KoL
	lVHqWHMnpZjqORYLViDBPA1iHpI6pQST5cDukz4=
X-Google-Smtp-Source: ACHHUZ6p3o9/+8IApPlSGGqvmlRp/B4UpJVznLGe6PwCeEnAGxvYLaQvxOr1R67/CI9gjsnXbrCcByILKIOGohdyFVI=
X-Received: by 2002:a2e:4949:0:b0:2b2:a0:e7fd with SMTP id b9-20020a2e4949000000b002b200a0e7fdmr92735ljd.32.1686094043817;
 Tue, 06 Jun 2023 16:27:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230518113021.30431-1-hildawu@realtek.com>
In-Reply-To: <20230518113021.30431-1-hildawu@realtek.com>
From: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date: Tue, 6 Jun 2023 16:27:11 -0700
Message-ID: <CABBYNZ+xD9gxcjQWJ0r5ehCmu-GDunu-isOVq_vQHCN6uDMheA@mail.gmail.com>
Subject: Re: [PATCH v4] Bluetooth: msft: Extended monitor tracking by address filter
To: hildawu@realtek.com
Cc: marcel@holtmann.org, johan.hedberg@gmail.com, davem@davemloft.net, 
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, 
	linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, apusaka@chromium.org, mmandlik@google.com, 
	yinghsu@chromium.org, simon.horman@corigine.com, max.chou@realtek.com, 
	alex_lu@realsil.com.cn, kidman@realtek.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Hilda,

On Thu, May 18, 2023 at 4:30=E2=80=AFAM <hildawu@realtek.com> wrote:
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
> Changes in v4:
> - Follow suggested, modification include allocate an address_filter
>   cb and pass to hci_cmd_sync_queue, etc.
>
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
>  net/bluetooth/msft.c        | 412 ++++++++++++++++++++++++++++++++++--
>  3 files changed, 410 insertions(+), 15 deletions(-)
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

I'm a little unsure how to interpret these comments above, usually
quirks are used when a driver has some broken feature, or deviates
from the specification, in this case it seems you guys have added an
extension on top of MSFT vendor commands? Or are there updates to the
MSFT vendor commands specification?

Anyway it would be great if we can get the decoding support for these
commands and an example of how they can be used, in fact one long
standing gap is to write proper testing to mgmt-tester since the
emulator already supports MSFT vendor commands, that way our CI can
validate this sort of changes don't break anything.

>  };
>
>  /* HCI device flags */
> diff --git a/net/bluetooth/msft.c b/net/bluetooth/msft.c
> index bf5cee48916c..59a995bd4bcc 100644
> --- a/net/bluetooth/msft.c
> +++ b/net/bluetooth/msft.c
> @@ -91,6 +91,33 @@ struct msft_ev_le_monitor_device {
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
> +enum monitor_addr_filter_state {
> +       AF_STATE_IDLE,
> +       AF_STATE_ADDING,
> +       AF_STATE_ADDED,
> +       AF_STATE_REMOVING,
> +};
> +
> +#define MSFT_MONITOR_ADVERTISEMENT_TYPE_ADDR   0x04
> +struct msft_monitor_addr_filter_data {
> +       __u8     msft_handle;
> +       __u8     pattern_handle; /* address filters pertain to */
> +       __u16    mgmt_handle;
> +       int      state;
> +       __s8     rssi_high;
> +       __s8     rssi_low;
> +       __u8     rssi_low_interval;
> +       __u8     rssi_sampling_period;
> +       __u8     addr_type;
> +       bdaddr_t bdaddr;
>         struct list_head list;
>  };
>
> @@ -99,9 +126,12 @@ struct msft_data {
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
> @@ -180,6 +210,24 @@ static struct msft_monitor_advertisement_handle_data=
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
> @@ -240,6 +288,7 @@ static int msft_le_monitor_advertisement_cb(struct hc=
i_dev *hdev, u16 opcode,
>
>         handle_data->mgmt_handle =3D monitor->handle;
>         handle_data->msft_handle =3D rp->handle;
> +       handle_data->cond_type   =3D MSFT_MONITOR_ADVERTISEMENT_TYPE_PATT=
ERN;
>         INIT_LIST_HEAD(&handle_data->list);
>         list_add(&handle_data->list, &msft->handle_map);
>
> @@ -254,6 +303,70 @@ static int msft_le_monitor_advertisement_cb(struct h=
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
> +               /* Keep the address filter and let
> +                * msft_add_address_filter_sync() remove and free the add=
ress
> +                * filter.
> +                */
> +               if (address_filter->state =3D=3D AF_STATE_ADDING) {
> +                       address_filter->state =3D AF_STATE_REMOVING;
> +                       continue;
> +               }
> +
> +               /* Keep the address filter and let
> +                * msft_cancel_address_filter_sync() remove and free the =
address
> +                * filter
> +                */
> +               if (address_filter->state =3D=3D AF_STATE_REMOVING)
> +                       continue;
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
> +               bt_dev_dbg(hdev, "MSFT: Canceled device %pMR address filt=
er",
> +                          &address_filter->bdaddr);
> +
> +               kfree(address_filter);
> +       }
> +}
> +
>  static int msft_le_cancel_monitor_advertisement_cb(struct hci_dev *hdev,
>                                                    u16 opcode,
>                                                    struct adv_monitor *mo=
nitor,
> @@ -263,6 +376,7 @@ static int msft_le_cancel_monitor_advertisement_cb(st=
ruct hci_dev *hdev,
>         struct msft_monitor_advertisement_handle_data *handle_data;
>         struct msft_data *msft =3D hdev->msft_data;
>         int status =3D 0;
> +       u8 msft_handle;
>
>         rp =3D (struct msft_rp_le_cancel_monitor_advertisement *)skb->dat=
a;
>         if (skb->len < sizeof(*rp)) {
> @@ -293,11 +407,17 @@ static int msft_le_cancel_monitor_advertisement_cb(=
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
> @@ -394,12 +514,14 @@ static int msft_add_monitor_sync(struct hci_dev *hd=
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
> @@ -436,16 +558,31 @@ static int msft_add_monitor_sync(struct hci_dev *hd=
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
> @@ -538,6 +675,7 @@ void msft_do_close(struct hci_dev *hdev)
>  {
>         struct msft_data *msft =3D hdev->msft_data;
>         struct msft_monitor_advertisement_handle_data *handle_data, *tmp;
> +       struct msft_monitor_addr_filter_data *address_filter, *n;
>         struct adv_monitor *monitor;
>
>         if (!msft)
> @@ -559,6 +697,14 @@ void msft_do_close(struct hci_dev *hdev)
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
> @@ -568,6 +714,49 @@ void msft_do_close(struct hci_dev *hdev)
>         hci_dev_unlock(hdev);
>  }
>
> +static int msft_cancel_address_filter_sync(struct hci_dev *hdev, void *d=
ata)
> +{
> +       struct msft_monitor_addr_filter_data *address_filter =3D data;
> +       struct msft_cp_le_cancel_monitor_advertisement cp;
> +       struct msft_data *msft =3D hdev->msft_data;
> +       struct sk_buff *skb;
> +       int err =3D 0;
> +
> +       if (!msft) {
> +               bt_dev_err(hdev, "MSFT: msft data is freed");
> +               return -EINVAL;
> +       }
> +
> +       /* The address filter has been removed by hci dev close */
> +       if (!test_bit(HCI_UP, &hdev->flags))
> +               return 0;
> +
> +       mutex_lock(&msft->filter_lock);
> +       list_del(&address_filter->list);
> +       mutex_unlock(&msft->filter_lock);
> +
> +       cp.sub_opcode =3D MSFT_OP_LE_CANCEL_MONITOR_ADVERTISEMENT;
> +       cp.handle =3D address_filter->msft_handle;
> +
> +       skb =3D __hci_cmd_sync(hdev, hdev->msft_opcode, sizeof(cp), &cp,
> +                            HCI_CMD_TIMEOUT);
> +       if (IS_ERR_OR_NULL(skb)) {
> +               bt_dev_err(hdev, "MSFT: Failed to cancel address (%pMR) f=
ilter",
> +                          &address_filter->bdaddr);
> +               err =3D EIO;
> +               goto done;
> +       }
> +       kfree_skb(skb);
> +
> +       bt_dev_dbg(hdev, "MSFT: Canceled device %pMR address filter",
> +                  &address_filter->bdaddr);
> +
> +done:
> +       kfree(address_filter);
> +
> +       return err;
> +}
> +
>  void msft_register(struct hci_dev *hdev)
>  {
>         struct msft_data *msft =3D NULL;
> @@ -581,7 +770,9 @@ void msft_register(struct hci_dev *hdev)
>         }
>
>         INIT_LIST_HEAD(&msft->handle_map);
> +       INIT_LIST_HEAD(&msft->address_filters);
>         hdev->msft_data =3D msft;
> +       mutex_init(&msft->filter_lock);
>  }
>
>  void msft_unregister(struct hci_dev *hdev)
> @@ -596,6 +787,7 @@ void msft_unregister(struct hci_dev *hdev)
>         hdev->msft_data =3D NULL;
>
>         kfree(msft->evt_prefix);
> +       mutex_destroy(&msft->filter_lock);
>         kfree(msft);
>  }
>
> @@ -645,11 +837,149 @@ static void *msft_skb_pull(struct hci_dev *hdev, s=
truct sk_buff *skb,
>         return data;
>  }
>
> +static int msft_add_address_filter_sync(struct hci_dev *hdev, void *data=
)
> +{
> +       struct msft_monitor_addr_filter_data *address_filter =3D data;
> +       struct msft_rp_le_monitor_advertisement *rp;
> +       struct msft_cp_le_monitor_advertisement *cp;
> +       struct msft_data *msft =3D hdev->msft_data;
> +       struct sk_buff *skb =3D NULL;
> +       bool remove =3D false;
> +       size_t size;
> +
> +       if (!msft) {
> +               bt_dev_err(hdev, "MSFT: msft data is freed");
> +               return -EINVAL;
> +       }
> +
> +       /* The address filter has been removed by hci dev close */
> +       if (!test_bit(HCI_UP, &hdev->flags))
> +               return -ENODEV;
> +
> +       /* We are safe to use the address filter from now on.
> +        * msft_monitor_device_evt() wouldn't delete this filter because =
it's
> +        * not been added by now.
> +        * And all other functions that requiring hci_req_sync_lock would=
n't
> +        * touch this filter before this func completes because it's prot=
ected
> +        * by hci_req_sync_lock.
> +        */
> +
> +       if (address_filter->state =3D=3D AF_STATE_REMOVING) {
> +               mutex_lock(&msft->filter_lock);
> +               list_del(&address_filter->list);
> +               mutex_unlock(&msft->filter_lock);
> +               kfree(address_filter);
> +               return 0;
> +       }
> +
> +       size =3D sizeof(*cp) +
> +              sizeof(address_filter->addr_type) +
> +              sizeof(address_filter->bdaddr);
> +       cp =3D kzalloc(size, GFP_KERNEL);
> +       if (!cp) {
> +               bt_dev_err(hdev, "MSFT: Alloc cmd param err");
> +               remove =3D true;
> +               goto done;
> +       }
> +       cp->sub_opcode           =3D MSFT_OP_LE_MONITOR_ADVERTISEMENT;
> +       cp->rssi_high            =3D address_filter->rssi_high;
> +       cp->rssi_low             =3D address_filter->rssi_low;
> +       cp->rssi_low_interval    =3D address_filter->rssi_low_interval;
> +       cp->rssi_sampling_period =3D address_filter->rssi_sampling_period=
;
> +       cp->cond_type            =3D MSFT_MONITOR_ADVERTISEMENT_TYPE_ADDR=
;
> +       cp->data[0]              =3D address_filter->addr_type;
> +       memcpy(&cp->data[1], &address_filter->bdaddr,
> +              sizeof(address_filter->bdaddr));
> +
> +       skb =3D __hci_cmd_sync(hdev, hdev->msft_opcode, size, cp,
> +                            HCI_CMD_TIMEOUT);
> +       if (IS_ERR_OR_NULL(skb)) {
> +               bt_dev_err(hdev, "Failed to enable address %pMR filter",
> +                          &address_filter->bdaddr);
> +               skb =3D NULL;
> +               remove =3D true;
> +               goto done;
> +       }
> +
> +       rp =3D skb_pull_data(skb, sizeof(*rp));
> +       if (!rp || rp->sub_opcode !=3D MSFT_OP_LE_MONITOR_ADVERTISEMENT |=
|
> +           rp->status)
> +               remove =3D true;
> +
> +done:
> +       mutex_lock(&msft->filter_lock);
> +
> +       if (remove) {
> +               bt_dev_warn(hdev, "MSFT: Remove address (%pMR) filter",
> +                           &address_filter->bdaddr);
> +               list_del(&address_filter->list);
> +               kfree(address_filter);
> +       } else {
> +               address_filter->state =3D AF_STATE_ADDED;
> +               address_filter->msft_handle =3D rp->handle;
> +               bt_dev_dbg(hdev, "MSFT: Address %pMR filter enabled",
> +                          &address_filter->bdaddr);
> +       }
> +       mutex_unlock(&msft->filter_lock);
> +
> +       kfree_skb(skb);
> +
> +       return 0;
> +}
> +
> +/* This function requires the caller holds msft->filter_lock */
> +static struct msft_monitor_addr_filter_data *msft_add_address_filter
> +               (struct hci_dev *hdev, u8 addr_type, bdaddr_t *bdaddr,
> +                struct msft_monitor_advertisement_handle_data *handle_da=
ta)
> +{
> +       struct msft_monitor_addr_filter_data *address_filter =3D NULL;
> +       struct msft_data *msft =3D hdev->msft_data;
> +       int err;
> +
> +       address_filter =3D kzalloc(sizeof(*address_filter), GFP_KERNEL);
> +       if (!address_filter)
> +               return NULL;
> +
> +       address_filter->state             =3D AF_STATE_ADDING;
> +       address_filter->msft_handle       =3D 0xff;
> +       address_filter->pattern_handle    =3D handle_data->msft_handle;
> +       address_filter->mgmt_handle       =3D handle_data->mgmt_handle;
> +       address_filter->rssi_high         =3D handle_data->rssi_high;
> +       address_filter->rssi_low          =3D handle_data->rssi_low;
> +       address_filter->rssi_low_interval =3D handle_data->rssi_low_inter=
val;
> +       address_filter->rssi_sampling_period =3D handle_data->rssi_sampli=
ng_period;
> +       address_filter->addr_type            =3D addr_type;
> +       bacpy(&address_filter->bdaddr, bdaddr);
> +
> +       /* With the above AF_STATE_ADDING, duplicated address filter can =
be
> +        * avoided when receiving monitor device event (found/lost) frequ=
ently
> +        * for the same device.
> +        */
> +       list_add_tail(&address_filter->list, &msft->address_filters);
> +
> +       err =3D hci_cmd_sync_queue(hdev, msft_add_address_filter_sync,
> +                                address_filter, NULL);
> +       if (err < 0) {
> +               bt_dev_err(hdev, "MSFT: Add address %pMR filter err", bda=
ddr);
> +               list_del(&address_filter->list);
> +               kfree(address_filter);
> +               return NULL;
> +       }
> +
> +       bt_dev_dbg(hdev, "MSFT: Add device %pMR address filter",
> +                  &address_filter->bdaddr);
> +
> +       return address_filter;
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
> @@ -662,9 +992,53 @@ static void msft_monitor_device_evt(struct hci_dev *=
hdev, struct sk_buff *skb)
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
> +               if (n->state =3D=3D AF_STATE_ADDED &&
> +                   n->msft_handle =3D=3D ev->monitor_handle) {
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
> @@ -681,12 +1055,18 @@ static void msft_monitor_device_evt(struct hci_dev=
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
> +               if (address_filter && address_filter->state =3D=3D AF_STA=
TE_ADDED) {
> +                       address_filter->state =3D AF_STATE_REMOVING;
> +                       hci_cmd_sync_queue(hdev,
> +                                          msft_cancel_address_filter_syn=
c,
> +                                          address_filter,
> +                                          NULL);
> +               }
> +               msft_device_lost(hdev, &ev->bdaddr, addr_type, mgmt_handl=
e);
> +       }
>  }
>
>  void msft_vendor_evt(struct hci_dev *hdev, void *data, struct sk_buff *s=
kb)
> @@ -724,7 +1104,9 @@ void msft_vendor_evt(struct hci_dev *hdev, void *dat=
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

