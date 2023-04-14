Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 739A46E2B72
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 23:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbjDNVDl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 17:03:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230028AbjDNVDk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 17:03:40 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5EF14692;
        Fri, 14 Apr 2023 14:03:31 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id 38308e7fff4ca-2a775754f45so484471fa.0;
        Fri, 14 Apr 2023 14:03:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681506210; x=1684098210;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GT9tr8XGQgAm7n2qI4BxpVEnyKJx/Syv1KSUwwIoqzQ=;
        b=CyfMsc3UbO8SchajKo/oKFDDeYJT3p7Lk8jRwDbov0P5mmS4I5K/uy/yElMseFUDTu
         vzAb7wxk3pEqbq5KnVYpBpVUogaizqqMSJ/9j0NSNdfMn+zNON4bjqQDp/ekYdqwZCbK
         tGBP2ZP6FLs1+PUW3t9b5hWQXtwkRp5j0N9BmiKgviPrXMeDUWN16qLJx2GzgNsIkgoa
         FwVA+Ff2wP6YPDB5eRauR1btnm7h5Z158I4QKZetGQRfEKZu1M2OsxtcPLSZNa6Z3r8J
         u2Fbz9dvXCXzS6fPgyXvSSQ1M0i5j8NFvu0zu3Z4jHzDLeKvWRrp5vYBE3sVdUzxWXXV
         rhww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681506210; x=1684098210;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GT9tr8XGQgAm7n2qI4BxpVEnyKJx/Syv1KSUwwIoqzQ=;
        b=gGKbaq4K7alASO5JoTp032UWezRw577joOVyHf3TL/spbE4cKJZeROSP+Io7wStiTk
         lQhT0CQUz9hIW2KP4jHejhe3jGI3n9dH94HXFSYXf+ppCiRbm5Skm1oBIY+9fZjEqEVa
         SNkcB+AyxQtFBSuPjzmf56/xi5IRvTCl7NJJyZWHVbV5LotuaNKEwPX5oxylWS/qv+Fz
         1pb++e2owTrsG4S1a8bAqD6BkJSBPcZKdCCHLbAc0WGBNVzMfM5gZ3rmZLCaFczrx75k
         GIT0ONNUAhmz+NVWhSGNhDyNYIBB3OS0gME6dk4o2LkDCKLdaqwPSJ+nnMwyd0dPUWEX
         wt6A==
X-Gm-Message-State: AAQBX9dyybnar/vOg+3Y22gRpqPuzPU/DAubxiLQeLaCUEZFM5cZ3Rmz
        dxoDBuFS0knBUGfYgytrn3ewteoCcE6W+tzF0EY=
X-Google-Smtp-Source: AKy350bCm4QxuUeiE6LWsB9GzlGclQjWtY7/Rj/iUb07fwNLnWyzmq8PihARcS7XugjsPCUN0NEXJCBFGnI3VmJDF3U=
X-Received: by 2002:a05:6512:76:b0:4e0:39f3:5b9a with SMTP id
 i22-20020a056512007600b004e039f35b9amr57107lfo.13.1681506209925; Fri, 14 Apr
 2023 14:03:29 -0700 (PDT)
MIME-Version: 1.0
References: <1681213778-31754-1-git-send-email-quic_zijuhu@quicinc.com>
In-Reply-To: <1681213778-31754-1-git-send-email-quic_zijuhu@quicinc.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Fri, 14 Apr 2023 14:03:17 -0700
Message-ID: <CABBYNZLJGmSaL1J0VSRU7vhTU-gyeqMndWxgwS2=d4-Bywfjxg@mail.gmail.com>
Subject: Re: [PATCH v1] Bluetooth: Optimize devcoredump API hci_devcd_init()
To:     Zijun Hu <quic_zijuhu@quicinc.com>
Cc:     marcel@holtmann.org, johan.hedberg@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, abhishekpandit@chromium.org
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

Hi Zijun,

On Tue, Apr 11, 2023 at 4:49=E2=80=AFAM Zijun Hu <quic_zijuhu@quicinc.com> =
wrote:
>
> API hci_devcd_init() stores u32 type to memory without specific byte
> order, let us store with little endian in order to be loaded and
> parsed by devcoredump core rightly.

This looks like a fix if devcoredump expects little endian, so I'd
suggest rephrasing to state it in the subject line, also add the Fixes
tag for the commit that introduces this problem.

> Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
> ---
>  net/bluetooth/coredump.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
>
> diff --git a/net/bluetooth/coredump.c b/net/bluetooth/coredump.c
> index 08fa98505454..d2d2624ec708 100644
> --- a/net/bluetooth/coredump.c
> +++ b/net/bluetooth/coredump.c
> @@ -5,6 +5,7 @@
>
>  #include <linux/devcoredump.h>
>
> +#include <asm/unaligned.h>
>  #include <net/bluetooth/bluetooth.h>
>  #include <net/bluetooth/hci_core.h>
>
> @@ -180,25 +181,25 @@ static int hci_devcd_prepare(struct hci_dev *hdev, =
u32 dump_size)
>
>  static void hci_devcd_handle_pkt_init(struct hci_dev *hdev, struct sk_bu=
ff *skb)
>  {
> -       u32 *dump_size;
> +       u32 dump_size;
>
>         if (hdev->dump.state !=3D HCI_DEVCOREDUMP_IDLE) {
>                 DBG_UNEXPECTED_STATE();
>                 return;
>         }
>
> -       if (skb->len !=3D sizeof(*dump_size)) {
> +       if (skb->len !=3D sizeof(dump_size)) {
>                 bt_dev_dbg(hdev, "Invalid dump init pkt");
>                 return;
>         }
>
> -       dump_size =3D skb_pull_data(skb, sizeof(*dump_size));
> -       if (!*dump_size) {
> +       dump_size =3D get_unaligned_le32(skb_pull_data(skb, 4));
> +       if (!dump_size) {
>                 bt_dev_err(hdev, "Zero size dump init pkt");
>                 return;
>         }
>
> -       if (hci_devcd_prepare(hdev, *dump_size)) {
> +       if (hci_devcd_prepare(hdev, dump_size)) {
>                 bt_dev_err(hdev, "Failed to prepare for dump");
>                 return;
>         }
> @@ -441,7 +442,7 @@ int hci_devcd_init(struct hci_dev *hdev, u32 dump_siz=
e)
>                 return -ENOMEM;
>
>         hci_dmp_cb(skb)->pkt_type =3D HCI_DEVCOREDUMP_PKT_INIT;
> -       skb_put_data(skb, &dump_size, sizeof(dump_size));
> +       put_unaligned_le32(dump_size, skb_put(skb, 4));
>
>         skb_queue_tail(&hdev->dump.dump_q, skb);
>         queue_work(hdev->workqueue, &hdev->dump.dump_rx);
> --
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum=
, a Linux Foundation Collaborative Project
>


--=20
Luiz Augusto von Dentz
