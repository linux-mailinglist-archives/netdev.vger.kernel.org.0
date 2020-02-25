Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF6816B736
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 02:35:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728719AbgBYBfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 20:35:00 -0500
Received: from mail-vs1-f66.google.com ([209.85.217.66]:40425 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728011AbgBYBfA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 20:35:00 -0500
Received: by mail-vs1-f66.google.com with SMTP id c18so6985597vsq.7
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 17:34:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XvbopwCF9mmo8OGNCSjhGDMkBahDz5BZ+asKUlhTYZA=;
        b=d3qBxLkkQKBffrrYpQqjOfPul0BCOX5LkqmU+vnztHjTT4FVLQEwOcfsr4+UiX9vVJ
         BUl9qJLVhATZ5cGirePb6WkDrQVdREkv4EMomOLXaCRGfBTA6kw+HiIIzNhWxlNVrPKU
         m/gvyTIjy/BWsc6wB4n9sQwmOTGAgEDsskmv8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XvbopwCF9mmo8OGNCSjhGDMkBahDz5BZ+asKUlhTYZA=;
        b=i1L2oXF2X0Zg3zRhllryY+Jt0qjvepqcbwORE9BAk5advtOwgOFlf4SdcLqF0I0Coz
         QGdFkpYzgi+lvb8LNNy5s2QCYSdw++ddypN4FaqeUnjcxdHRu0Mv2M2U3098up/ZcoFe
         aFDjS8e64wDUb/pGWb28cPKx/AnwjTn2/YHPDtAi8A2DykqWcSAKOQpzUMnfDvZayCsW
         SO2yHr6fwrmR1qpqwXRL7XmRT6W0hZNWbAeoCTW2RBEIuPsI++8svGy1/eEWAT4YYmH5
         n1MaD9AiwIGnUHrMqEiTxBplQz1MpDKBdxKwfrnImMC9m/tEqEq6uL+WkKg1oLOpOmAk
         yDnQ==
X-Gm-Message-State: APjAAAVxVRBDJrG0RIDseIkBOfbVISm3IrBeM8TSQ4joax7iVMwUeoO7
        rk8LjLyEy3aEFoJikeuKe7lM30io60h4kitg4Nv5Hg==
X-Google-Smtp-Source: APXvYqwj++UMCeh3XQCSqWC6OoNtBiIOWXW/gh6glTMjVsSGcrp1jrbKj/II7rje4gpIBvRg97EAG9UqmCB23TF5yLI=
X-Received: by 2002:a67:2dd6:: with SMTP id t205mr30321975vst.71.1582594498280;
 Mon, 24 Feb 2020 17:34:58 -0800 (PST)
MIME-Version: 1.0
References: <20200225000036.156250-1-abhishekpandit@chromium.org> <20200224160019.RFC.v3.1.I797e2f4cb824299043e771f3ab9cef86ee09f4db@changeid>
In-Reply-To: <20200224160019.RFC.v3.1.I797e2f4cb824299043e771f3ab9cef86ee09f4db@changeid>
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Date:   Mon, 24 Feb 2020 17:34:47 -0800
Message-ID: <CANFp7mUehaCSR2W3mXpq2s80YLJVfO2U8D_N+sRzJ2pMZQw1UA@mail.gmail.com>
Subject: Re: [RFC PATCH v3 1/5] Bluetooth: Add mgmt op set_wake_capable
To:     Marcel Holtmann <marcel@holtmann.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Alain Michaud <alainm@chromium.org>
Cc:     Bluez mailing list <linux-bluetooth@vger.kernel.org>,
        ChromeOS Bluetooth Upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I seem to have forgotten to update the series changes here. In series
3, I added a wakeable property to le_conn_param so that the wakeable
list is only used for BR/EDR as requested in the previous revision.

On Mon, Feb 24, 2020 at 4:00 PM Abhishek Pandit-Subedi
<abhishekpandit@chromium.org> wrote:
>
> When the system is suspended, only some connected Bluetooth devices
> cause user input that should wake the system (mostly HID devices). Add
> a list to keep track of devices that can wake the system and add
> a management API to let userspace tell the kernel whether a device is
> wake capable or not. For LE devices, the wakeable property is added to
> the connection parameter and can only be modified after calling
> add_device.
>
> Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> ---
>
> Changes in v3: None
> Changes in v2: None
>
>  include/net/bluetooth/hci_core.h |  2 ++
>  include/net/bluetooth/mgmt.h     |  7 +++++
>  net/bluetooth/hci_core.c         |  1 +
>  net/bluetooth/mgmt.c             | 51 ++++++++++++++++++++++++++++++++
>  4 files changed, 61 insertions(+)
>
> diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
> index dcc0dc6e2624..9d9ada5bc9d4 100644
> --- a/include/net/bluetooth/hci_core.h
> +++ b/include/net/bluetooth/hci_core.h
> @@ -394,6 +394,7 @@ struct hci_dev {
>         struct list_head        mgmt_pending;
>         struct list_head        blacklist;
>         struct list_head        whitelist;
> +       struct list_head        wakeable;
>         struct list_head        uuids;
>         struct list_head        link_keys;
>         struct list_head        long_term_keys;
> @@ -575,6 +576,7 @@ struct hci_conn_params {
>
>         struct hci_conn *conn;
>         bool explicit_connect;
> +       bool wakeable;
>  };
>
>  extern struct list_head hci_dev_list;
> diff --git a/include/net/bluetooth/mgmt.h b/include/net/bluetooth/mgmt.h
> index a90666af05bd..283ba5320bdb 100644
> --- a/include/net/bluetooth/mgmt.h
> +++ b/include/net/bluetooth/mgmt.h
> @@ -671,6 +671,13 @@ struct mgmt_cp_set_blocked_keys {
>  } __packed;
>  #define MGMT_OP_SET_BLOCKED_KEYS_SIZE 2
>
> +#define MGMT_OP_SET_WAKE_CAPABLE       0x0047
> +#define MGMT_SET_WAKE_CAPABLE_SIZE     8
> +struct mgmt_cp_set_wake_capable {
> +       struct mgmt_addr_info addr;
> +       u8 wake_capable;
> +} __packed;
> +
>  #define MGMT_EV_CMD_COMPLETE           0x0001
>  struct mgmt_ev_cmd_complete {
>         __le16  opcode;
> diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> index cbbc34a006d1..2fceaf76644a 100644
> --- a/net/bluetooth/hci_core.c
> +++ b/net/bluetooth/hci_core.c
> @@ -3299,6 +3299,7 @@ struct hci_dev *hci_alloc_dev(void)
>         INIT_LIST_HEAD(&hdev->mgmt_pending);
>         INIT_LIST_HEAD(&hdev->blacklist);
>         INIT_LIST_HEAD(&hdev->whitelist);
> +       INIT_LIST_HEAD(&hdev->wakeable);
>         INIT_LIST_HEAD(&hdev->uuids);
>         INIT_LIST_HEAD(&hdev->link_keys);
>         INIT_LIST_HEAD(&hdev->long_term_keys);
> diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
> index 3074363c68df..9a873097000b 100644
> --- a/net/bluetooth/mgmt.c
> +++ b/net/bluetooth/mgmt.c
> @@ -107,6 +107,7 @@ static const u16 mgmt_commands[] = {
>         MGMT_OP_READ_EXT_INFO,
>         MGMT_OP_SET_APPEARANCE,
>         MGMT_OP_SET_BLOCKED_KEYS,
> +       MGMT_OP_SET_WAKE_CAPABLE,
>  };
>
>  static const u16 mgmt_events[] = {
> @@ -4663,6 +4664,48 @@ static int set_fast_connectable(struct sock *sk, struct hci_dev *hdev,
>         return err;
>  }
>
> +static int set_wake_capable(struct sock *sk, struct hci_dev *hdev, void *data,
> +                           u16 len)
> +{
> +       struct mgmt_cp_set_wake_capable *cp = data;
> +       struct hci_conn_params *params;
> +       int err;
> +       u8 status = MGMT_STATUS_FAILED;
> +       u8 addr_type = cp->addr.type == BDADDR_BREDR ?
> +                              cp->addr.type :
> +                              le_addr_type(cp->addr.type);
> +
> +       BT_DBG("Set wake capable %pMR (type 0x%x) = 0x%x\n", &cp->addr.bdaddr,
> +              addr_type, cp->wake_capable);
> +
> +       if (cp->addr.type == BDADDR_BREDR) {
> +               if (cp->wake_capable)
> +                       err = hci_bdaddr_list_add(&hdev->wakeable,
> +                                                 &cp->addr.bdaddr, addr_type);
> +               else
> +                       err = hci_bdaddr_list_del(&hdev->wakeable,
> +                                                 &cp->addr.bdaddr, addr_type);
> +
> +               if (!err || err == -EEXIST || err == -ENOENT)
> +                       status = MGMT_STATUS_SUCCESS;
> +
> +               goto done;
> +       }
> +
> +       /* Add wakeable param to le connection parameters */
> +       params = hci_conn_params_lookup(hdev, &cp->addr.bdaddr, addr_type);
> +       if (params) {
> +               params->wakeable = cp->wake_capable;
> +               status = MGMT_STATUS_SUCCESS;
> +       }
> +
> +done:
> +       err = mgmt_cmd_complete(sk, hdev->id, MGMT_OP_SET_WAKE_CAPABLE, status,
> +                               cp, sizeof(*cp));
> +
> +       return err;
> +}
> +
>  static void set_bredr_complete(struct hci_dev *hdev, u8 status, u16 opcode)
>  {
>         struct mgmt_pending_cmd *cmd;
> @@ -5791,6 +5834,13 @@ static int remove_device(struct sock *sk, struct hci_dev *hdev,
>                         err = hci_bdaddr_list_del(&hdev->whitelist,
>                                                   &cp->addr.bdaddr,
>                                                   cp->addr.type);
> +
> +                       /* Don't check result since it either succeeds or device
> +                        * wasn't there (not wakeable or invalid params as
> +                        * covered by deleting from whitelist).
> +                        */
> +                       hci_bdaddr_list_del(&hdev->wakeable, &cp->addr.bdaddr,
> +                                           cp->addr.type);
>                         if (err) {
>                                 err = mgmt_cmd_complete(sk, hdev->id,
>                                                         MGMT_OP_REMOVE_DEVICE,
> @@ -6990,6 +7040,7 @@ static const struct hci_mgmt_handler mgmt_handlers[] = {
>         { set_phy_configuration,   MGMT_SET_PHY_CONFIGURATION_SIZE },
>         { set_blocked_keys,        MGMT_OP_SET_BLOCKED_KEYS_SIZE,
>                                                 HCI_MGMT_VAR_LEN },
> +       { set_wake_capable,        MGMT_SET_WAKE_CAPABLE_SIZE },
>  };
>
>  void mgmt_index_added(struct hci_dev *hdev)
> --
> 2.25.0.265.gbab2e86ba0-goog
>
