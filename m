Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16C854A69AE
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 02:42:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243717AbiBBBmC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 20:42:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243698AbiBBBmB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 20:42:01 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77D45C061714;
        Tue,  1 Feb 2022 17:42:01 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id i10so56403260ybt.10;
        Tue, 01 Feb 2022 17:42:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g3cCUGw9Aasr1NffsEVOTgPPhaaTzLEkx4KOsPROzp4=;
        b=bBzrGZGAo53x2UKH9ZcXRora0v2jv6suVu1fzRrsLRuzjWQJIhIIhdtrsQTVX08kqb
         0k6XN3xKVcul19IHApcpFKQELImtx13t8Zh5tcfUeaW2E4LIhTWhd0tvErAwdQfYAjnp
         wC30urwIeSdfCtJYq8w/X/6WWsJ0vc5/thFgJQ/8PmJ1Rb//XaBE9/DA8pRZTnUmUegX
         lX/9R97csJK5xGn4SGIq1QUHppxEg7kMzM8omhav4mNDg+mM38y3fvZMO1U8k+fIOQxC
         wbCQsTRy/Xr0klhLOb8wjrk2rPdLcmhuSm6KSbdW9jVhYS9tJ+VT/aBZZwZoYGXOii/e
         UReQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g3cCUGw9Aasr1NffsEVOTgPPhaaTzLEkx4KOsPROzp4=;
        b=7BEWf/ALK9Fdk33fmg68oClELcw2hmFIVygnfF2NJzD25JmUcp8iS9HEc3E3CZ0Zz3
         Wm9b6irmBJqTlXhU6VdMK/CCERRhsP47g19vzYxpQ+VJ6OR0Gsgugt0lJ5P0AMTNTEzg
         lU14kxEBZ4fA4jbvRTpnxSGcZrDTnZjkazBAMchW2GmkYAAIl7Iyx+Wql5pE0mHA6nEu
         g2wGIme7ua31UPCmWXYvv4x5smFKfTKSSiddJ/m1RyKqXpZcyE+h1Hyagh4VMFk7dtbd
         fsAXGxUdEk/zFQwizyNAka2uadbUko+hY09enz3pJpkpicLtzrD3qICMdcGBdy3R+uoT
         Nn2g==
X-Gm-Message-State: AOAM532y8G6gzvKQMYBxHKGZU1JI9m2GRa6cHcRyhYYvwCl9mUSImgZM
        jXUN3IYF3fxAgaMg8o5MaUOOF4QE0JwoI38YjSg=
X-Google-Smtp-Source: ABdhPJzH2m9KzyLud9H5ox7F67JPKPrulRokA3MwfEDdBHR5yiGUZan8rx4B6ygjDYGJvKvLK7S7t7iKINzopjQmOls=
X-Received: by 2002:a25:3415:: with SMTP id b21mr38879927yba.573.1643766120349;
 Tue, 01 Feb 2022 17:42:00 -0800 (PST)
MIME-Version: 1.0
References: <20220201201033.1332733-1-rad@semihalf.com> <20220201201033.1332733-2-rad@semihalf.com>
In-Reply-To: <20220201201033.1332733-2-rad@semihalf.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Tue, 1 Feb 2022 17:41:49 -0800
Message-ID: <CABBYNZ+EuHHP9CfxROX8ZzSi-ae4rNgne39kmH=iDv8nK0RRpg@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] Bluetooth: Fix skb allocation in
 mgmt_remote_name() & mgmt_device_connected()
To:     Radoslaw Biernacki <rad@semihalf.com>
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        upstream@semihalf.com, Angela Czubak <acz@semihalf.com>,
        Marek Maslanka <mm@semihalf.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Radoslaw,

On Tue, Feb 1, 2022 at 12:10 PM Radoslaw Biernacki <rad@semihalf.com> wrote:
>
> This patch fixes skb allocation, as lack of space for ev might push skb
> tail beyond its end.
> Also introduce eir_precalc_len() that can be used instead of magic
> numbers for similar eir operations on skb.
>
> Fixes: cf1bce1de7eeb ("Bluetooth: mgmt: Make use of mgmt_send_event_skb in MGMT_EV_DEVICE_FOUND")
> Fixes: e96741437ef0a ("Bluetooth: mgmt: Make use of mgmt_send_event_skb in MGMT_EV_DEVICE_CONNECTED")
> Signed-off-by: Angela Czubak <acz@semihalf.com>
> Signed-off-by: Marek Maslanka <mm@semihalf.com>
> Signed-off-by: Radoslaw Biernacki <rad@semihalf.com>
> ---
>  net/bluetooth/eir.h  |  5 +++++
>  net/bluetooth/mgmt.c | 18 ++++++++----------
>  2 files changed, 13 insertions(+), 10 deletions(-)
>
> diff --git a/net/bluetooth/eir.h b/net/bluetooth/eir.h
> index 05e2e917fc25..e5876751f07e 100644
> --- a/net/bluetooth/eir.h
> +++ b/net/bluetooth/eir.h
> @@ -15,6 +15,11 @@ u8 eir_create_scan_rsp(struct hci_dev *hdev, u8 instance, u8 *ptr);
>  u8 eir_append_local_name(struct hci_dev *hdev, u8 *eir, u8 ad_len);
>  u8 eir_append_appearance(struct hci_dev *hdev, u8 *ptr, u8 ad_len);
>
> +static inline u16 eir_precalc_len(u8 data_len)
> +{
> +       return sizeof(u8) * 2 + data_len;
> +}
> +
>  static inline u16 eir_append_data(u8 *eir, u16 eir_len, u8 type,
>                                   u8 *data, u8 data_len)
>  {
> diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
> index 5dd684e0b259..43ca228104ce 100644
> --- a/net/bluetooth/mgmt.c
> +++ b/net/bluetooth/mgmt.c
> @@ -9061,12 +9061,14 @@ void mgmt_device_connected(struct hci_dev *hdev, struct hci_conn *conn,
>         u16 eir_len = 0;
>         u32 flags = 0;
>
> +       /* allocate buff for LE or BR/EDR adv */
>         if (conn->le_adv_data_len > 0)
>                 skb = mgmt_alloc_skb(hdev, MGMT_EV_DEVICE_CONNECTED,
> -                                    conn->le_adv_data_len);
> +                                    sizeof(*ev) + conn->le_adv_data_len);
>         else
>                 skb = mgmt_alloc_skb(hdev, MGMT_EV_DEVICE_CONNECTED,
> -                                    2 + name_len + 5);
> +                                    sizeof(*ev) + (name ? eir_precalc_len(name_len) : 0) +
> +                                    eir_precalc_len(sizeof(conn->dev_class)));
>
>         ev = skb_put(skb, sizeof(*ev));
>         bacpy(&ev->addr.bdaddr, &conn->dst);
> @@ -9785,13 +9787,11 @@ void mgmt_remote_name(struct hci_dev *hdev, bdaddr_t *bdaddr, u8 link_type,
>  {
>         struct sk_buff *skb;
>         struct mgmt_ev_device_found *ev;
> -       u16 eir_len;
> -       u32 flags;
> +       u16 eir_len = 0;
> +       u32 flags = 0;
>
> -       if (name_len)
> -               skb = mgmt_alloc_skb(hdev, MGMT_EV_DEVICE_FOUND, 2 + name_len);
> -       else
> -               skb = mgmt_alloc_skb(hdev, MGMT_EV_DEVICE_FOUND, 0);
> +       skb = mgmt_alloc_skb(hdev, MGMT_EV_DEVICE_FOUND,
> +                            sizeof(*ev) + (name ? eir_precalc_len(name_len) : 0));
>
>         ev = skb_put(skb, sizeof(*ev));
>         bacpy(&ev->addr.bdaddr, bdaddr);
> @@ -9801,10 +9801,8 @@ void mgmt_remote_name(struct hci_dev *hdev, bdaddr_t *bdaddr, u8 link_type,
>         if (name) {
>                 eir_len = eir_append_data(ev->eir, 0, EIR_NAME_COMPLETE, name,
>                                           name_len);
> -               flags = 0;
>                 skb_put(skb, eir_len);
>         } else {
> -               eir_len = 0;
>                 flags = MGMT_DEV_FOUND_NAME_REQUEST_FAILED;
>         }
>
> --
> 2.35.0.rc2.247.g8bbb082509-goog
>

Applied, thanks.


-- 
Luiz Augusto von Dentz
