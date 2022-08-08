Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48E6F58CF25
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 22:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244354AbiHHUb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 16:31:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235732AbiHHUb6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 16:31:58 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C617D101CF;
        Mon,  8 Aug 2022 13:31:54 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id uj29so18779694ejc.0;
        Mon, 08 Aug 2022 13:31:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zBXmaPCVMLZZykpy+uTUBaFhT6YqekGzMMKrnO5HYms=;
        b=MkdgIzJtrQKFYLEmnwnEVpH9YougA+RMr1tJW1lnJYRdpXSv/w14esVwL/od2bKal6
         TGHf+OJw01wDPqHexEYKZeyZpTXBmZr5xx9pwAGBiS5H4sf2GwK/0AnYF7/B+NRi6B10
         P9pritKsk9yeKedQ0N6TnGHaUtVcyaSzu39cVyVBJ+qdZ8n5a2JKBaojRjDosB/iFBOz
         F1drH5sCr29fOp64nVYgICmKehKzJQ5p4+K55jQje8o1gZ3flYNK3Uq+2jSshVoNrfoK
         E2Sn/KayPz4ACpblqmTpcKWzPijHEvdL8CigPFrEGeC3kKksv1WTz5EarwfdaPGCw2gU
         VKLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zBXmaPCVMLZZykpy+uTUBaFhT6YqekGzMMKrnO5HYms=;
        b=wLo+xvgFyxveifoz2SIbMogkYgYM8ac/vHJI7TnAmN7IfIHuGvGyexYKXyhF0w5lJl
         xG5qPOUhZkG2ludBHmPyIbsRMOlri+cqkcJynl/qw6+TqFqChy1HJiE+Z4gY9MrKB/8T
         KI46JhckJFUBX1waUbO5OJfyrBnvC90DgcVyfXntgvclzuwrBB0ltFuPdJZDkwAbVxCW
         yROkrpPr/Kb/WUdFEiWRqb0xO2pGZeWYCxRYRefaBq+0t61MjTpNtqBl8sqi2X6n5J9h
         dS7PAmL0SOveayjkdrJFOvb2Sp8oclKdf+Xs0m/QdsxDNX7KcfASL37kUhL9kByQhC18
         OP/A==
X-Gm-Message-State: ACgBeo1BZEABCVlZUA8crtag5MLL9tjFH5gZcM24Ju+hNhaTP6G0gPdO
        h67h+QTkuh7Rbj22cx38Q7Rq87Lj834RtNb8YA0=
X-Google-Smtp-Source: AA6agR6dkGPfMDF41pFFwh0B5Drxynt1hbbwo5PJlm8b1L3J9Mq8N4XRWeZcW5cYn1BxApgAEkN8z3e7DE1staGVImw=
X-Received: by 2002:a17:907:a408:b0:730:f106:e692 with SMTP id
 sg8-20020a170907a40800b00730f106e692mr11683604ejc.132.1659990713286; Mon, 08
 Aug 2022 13:31:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220808110315.1.I5a39052e33f6f3c7406f53b0304a32ccf9f340fa@changeid>
In-Reply-To: <20220808110315.1.I5a39052e33f6f3c7406f53b0304a32ccf9f340fa@changeid>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Mon, 8 Aug 2022 13:31:41 -0700
Message-ID: <CABBYNZJf_6SmRD0tUUUfxfpZOksL-=5jLN8+5c4cZcQB6J-xbg@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: Ignore cmd_timeout with HCI_USER_CHANNEL
To:     Abhishek Pandit-Subedi <abhishekpandit@google.com>
Cc:     "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Abhishek,

On Mon, Aug 8, 2022 at 11:04 AM Abhishek Pandit-Subedi
<abhishekpandit@google.com> wrote:
>
> From: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
>
> When using HCI_USER_CHANNEL, hci traffic is expected to be handled by
> userspace entirely. However, it is still possible (and sometimes
> desirable) to be able to send commands to the controller directly. In
> such cases, the kernel command timeout shouldn't do any error handling.
>
> Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> ---
> This was tested by running a userchannel stack and sending commands via
> hcitool cmd on an Intel AX200 controller. Without this change, each
> command sent via hcitool would result in hci_cmd_timeout being called
> and after 5 commands, the controller would reset.
>
> Hcitool continues working here because it marks the socket as
> promiscuous and gets a copy of all traffic while the socket is open (and
> does filtering in userspace).

There is something not quite right here, if you have a controller
using user_channel (addr.hci_channel = HCI_CHANNEL_USER) it probably
shouldn't even accept to be opened again by the likes of hcitool which
uses HCI_CHANNEL_RAW as it can cause conflicts. If you really need a
test tool that does send the command while in HCI_CHANNEL_USER then it
must be send on that mode but I wouldn't do it with hcitool anyway as
that is deprecated and this exercise seem to revolve to a entire stack
on top of HCI_USER_CHANNEL then you shall use tools of that stack and
mix with BlueZ userspace tools.

> Tested on Chromebook with 5.4 kernel with patch (and applied cleanly on
> bluetooth-next).
>
>  net/bluetooth/hci_core.c | 26 +++++++++++++++++---------
>  1 file changed, 17 insertions(+), 9 deletions(-)
>
> diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> index b3a5a3cc9372..c9a15f6633f7 100644
> --- a/net/bluetooth/hci_core.c
> +++ b/net/bluetooth/hci_core.c
> @@ -1481,17 +1481,25 @@ static void hci_cmd_timeout(struct work_struct *work)
>         struct hci_dev *hdev = container_of(work, struct hci_dev,
>                                             cmd_timer.work);
>
> -       if (hdev->sent_cmd) {
> -               struct hci_command_hdr *sent = (void *) hdev->sent_cmd->data;
> -               u16 opcode = __le16_to_cpu(sent->opcode);
> +       /* Don't trigger the timeout behavior if it happens while we're in
> +        * userchannel mode. Userspace is responsible for handling any command
> +        * timeouts.
> +        */
> +       if (!(hci_dev_test_flag(hdev, HCI_USER_CHANNEL) &&
> +             test_bit(HCI_UP, &hdev->flags))) {
> +               if (hdev->sent_cmd) {
> +                       struct hci_command_hdr *sent =
> +                               (void *)hdev->sent_cmd->data;
> +                       u16 opcode = __le16_to_cpu(sent->opcode);
>
> -               bt_dev_err(hdev, "command 0x%4.4x tx timeout", opcode);
> -       } else {
> -               bt_dev_err(hdev, "command tx timeout");
> -       }
> +                       bt_dev_err(hdev, "command 0x%4.4x tx timeout", opcode);
> +               } else {
> +                       bt_dev_err(hdev, "command tx timeout");
> +               }
>
> -       if (hdev->cmd_timeout)
> -               hdev->cmd_timeout(hdev);
> +               if (hdev->cmd_timeout)
> +                       hdev->cmd_timeout(hdev);
> +       }

I wonder why hci_cmd_timeout is even active if the controller is in
HCI_USER_CHANNEL mode, that sounds like a bug already.

>         atomic_set(&hdev->cmd_cnt, 1);
>         queue_work(hdev->workqueue, &hdev->cmd_work);
> --
> 2.37.1.559.g78731f0fdb-goog
>


-- 
Luiz Augusto von Dentz
