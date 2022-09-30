Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 959F85F130E
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 21:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232077AbiI3T53 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 15:57:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiI3T51 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 15:57:27 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 423261B86A9;
        Fri, 30 Sep 2022 12:57:24 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id c7so5839372ljm.12;
        Fri, 30 Sep 2022 12:57:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=fnVXnzhRgA3xxnZY3E86H1+uNtkA70sJykTTKNdQrdw=;
        b=AKFyaNilLLDPUgRgJLUD19Xh7RwT598pgF4ZaQg7C9Doqiyg2ekQHyFp2BpRV905/i
         y20iny+/5UexbjfoQHhrLC3RLU0SXXXYjfKPqA43yex44HBdWW+e1dYJ3hZa85yruN4l
         lxMbY2ax1vINTeIvDQlD8PPV8dVFRyachEeFTXcFn0vGXXvub8HA990y0ZtBQeeAWnxg
         moGY8oNq95iAXDJX+KhO3YpQtJA78TGW54LZJ0aYHvmOHjXgY1/cWDIVpEbqxMdWNvLJ
         Uyl+VuDNNFklyQTjRSG1b6qjDdVIgliUjKz5NJvRRG6lxZ5flKyhVjoc8kRL+65oFxGI
         ZR5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=fnVXnzhRgA3xxnZY3E86H1+uNtkA70sJykTTKNdQrdw=;
        b=oqqGhVTVgTC8RCMdBAh/zaiqGkZIFALL+zki2hPi5MlGkAxRv9l6+8zlZD60C5C1Wr
         N70OXb1REeiBfHh8BkKk+wlHjWJ7B/LieN2vS0jqGHa0uBsx0xm/QhHRAZT/37Nb4TLm
         z9BwS56yy16CtjDttGQGOsO4IsIlBhl8ARFYn+64HZWyxV3vQw1+QvD24/je7pX2XJKY
         kAKTOtDy8iEyzZD3QegPigmk3pk+eInElF++KpS6fXWQt3AfSGajaWRPrYoW6Zlme53z
         8qarKQ2y+4cMPB4KoAdo52h5EH0g1AdKLm2LuztVgC+t7wh2uh2CuryG80MwfYsZkrME
         s8Cw==
X-Gm-Message-State: ACrzQf0Vtl7JfON26/gWM2P5ZhY5f1EQIzDU36snnr0ZnJx2wdjswx73
        xl6gS2TRKqqu+S4RJc90luQJknG4d//+VRMPrBw=
X-Google-Smtp-Source: AMsMyM5MiKH9ttzlx23uHzDux1ij1EHrNi6/96bVWDBzI0FeCznAvU4wr65PPjIGpwTQBHrwPdjaJV2guLDKkybk8HI=
X-Received: by 2002:a05:651c:1547:b0:26c:7d5a:5350 with SMTP id
 y7-20020a05651c154700b0026c7d5a5350mr3521795ljp.293.1664567842909; Fri, 30
 Sep 2022 12:57:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220930140655.2723164-1-ajye_huang@compal.corp-partner.google.com>
In-Reply-To: <20220930140655.2723164-1-ajye_huang@compal.corp-partner.google.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Fri, 30 Sep 2022 12:57:10 -0700
Message-ID: <CABBYNZJZcgQ+VsPu68-14=EQGxxZ1VpHth37uO_NnGm+SsOnbw@mail.gmail.com>
Subject: Re: [PATCH v1] bluetooth: Fix the bluetooth icon status after running
 hciconfig hci0 up
To:     Ajye Huang <ajye_huang@compal.corp-partner.google.com>
Cc:     linux-kernel@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
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

Hi Ajye,

On Fri, Sep 30, 2022 at 7:07 AM Ajye Huang
<ajye_huang@compal.corp-partner.google.com> wrote:
>
> When "hciconfig hci0 up" command is used to bluetooth ON, but
> the bluetooth UI icon in settings still not be turned ON.
>
> Refer to commit 2ff13894cfb8 ("Bluetooth: Perform HCI update for power on synchronously")
> Add back mgmt_power_on(hdev, ret) into function hci_dev_do_open(struct hci_dev *hdev)
> in hci_core.c
>
> Signed-off-by: Ajye Huang <ajye_huang@compal.corp-partner.google.com>
> ---
>  net/bluetooth/hci_core.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> index 0540555b3704..5061845c8fc2 100644
> --- a/net/bluetooth/hci_core.c
> +++ b/net/bluetooth/hci_core.c
> @@ -481,6 +481,7 @@ static int hci_dev_do_open(struct hci_dev *hdev)
>         hci_req_sync_lock(hdev);
>
>         ret = hci_dev_open_sync(hdev);
> +       mgmt_power_on(hdev, ret);
>
>         hci_req_sync_unlock(hdev);
>         return ret;
> --
> 2.25.1


I believe the culprit is actually the following change:

git show cf75ad8b41d2a:

@@ -1489,8 +1488,7 @@ static int hci_dev_do_open(struct hci_dev *hdev)
                    !hci_dev_test_flag(hdev, HCI_USER_CHANNEL) &&
                    hci_dev_test_flag(hdev, HCI_MGMT) &&
                    hdev->dev_type == HCI_PRIMARY) {
-                       ret = __hci_req_hci_power_on(hdev);
-                       mgmt_power_on(hdev, ret);
+                       ret = hci_powered_update_sync(hdev);

So we should probably restore mgmt_power_on above.

-- 
Luiz Augusto von Dentz
