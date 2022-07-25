Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1BEA58075A
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 00:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235959AbiGYW2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 18:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237021AbiGYW2p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 18:28:45 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36C2D255AD;
        Mon, 25 Jul 2022 15:28:44 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id c12so8345512ede.3;
        Mon, 25 Jul 2022 15:28:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s5F5bTPmIWsgz/PHUFTiPwn7ArH62vLQlD0Ro1hOzT8=;
        b=EYVKVy9GR8tIisHmLoKIAUDGdhGTgA+V+O8Z1DMo3OCm/8lIX+f2pBj5Fg2PBSooVF
         VzXhmo5+5SRh+gS/j/TCjZm9g3wuPPfIJR/lHwPjJL/VEagtHu4Dj8nzh2Yo4SFJGt3q
         zAUrZThxpZhnqya/xFcQ4ZsSQixW2/qBTznI3inG+qxqjP1qimuGWnkE5ilwBjyN3+/y
         raASv3WxXlCYKvPPX5tYi45XmgelBIcFRlQ0HkBw+VCjLX907GaOeSAK/FU3cnRM4b9W
         MPdErn+DQYwABxF4eRq6GZgzE3ovur6veftazbNX8N0e8zULCGOPcg3f8KMdCnw0nJuq
         TVHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s5F5bTPmIWsgz/PHUFTiPwn7ArH62vLQlD0Ro1hOzT8=;
        b=sP+54nMD81yYcOMQuGpRqWintABlzDRcMesavl3I5iFmQMlSdzYeadGPvN5mIQqygq
         aa+2d8s4VD700HGOk5ckr+ulKjj5JbExyeBnGuiPJ0UUNKmDNLMwqHN/I8d3Ui7kWOmL
         e6KR6t45hI7U6JqErsi5+nuGw4CZAAJHXMoNgRnWfnSZmvNpIvjy4uMYBY1Kd95u3s97
         lA8BPU6viHRrt22jCAgz1RvPu1T9IFAVy8zk0ABzXaMfjq3XxalAfN2FKwHQoyYBTmZr
         wBdtwfskFhvd8DB1MaA+Y57rFbZ6zQ77eVVaBFUzZZ1dzpNO8lwmZ82T5cBaGqPV3Wro
         xdpA==
X-Gm-Message-State: AJIora/VUpFaMZVQvlXAwXoTTOvhT2csd25Z1943Q4Lz+mW5qAFP7FgZ
        LBgzfIrrttKIAiEHKskuYvYL1gNuHGSuyH8huP4=
X-Google-Smtp-Source: AGRyM1tyT5tOI9pZi4I45uufPdEI2vvTki7s66xiQ+IU6rwz2Xy9oHm51p5RXCfq5CLrCpa0+X/RHhv6nZlPcKRiYtg=
X-Received: by 2002:a05:6402:5412:b0:435:5997:ccb5 with SMTP id
 ev18-20020a056402541200b004355997ccb5mr14756047edb.167.1658788122613; Mon, 25
 Jul 2022 15:28:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220725135026.1.Ia18502557c4ba9ba7cd2d1da2bae3aeb71b37e4e@changeid>
In-Reply-To: <20220725135026.1.Ia18502557c4ba9ba7cd2d1da2bae3aeb71b37e4e@changeid>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Mon, 25 Jul 2022 15:28:31 -0700
Message-ID: <CABBYNZLWUM4JJjm5H=f7szt_7bgSFcAknk4AcVUmO5iPJzQVcQ@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: Always set event mask on suspend
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
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Abhishek,

On Mon, Jul 25, 2022 at 1:50 PM Abhishek Pandit-Subedi
<abhishekpandit@google.com> wrote:
>
> From: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
>
> When suspending, always set the event mask once disconnects are
> successful. Otherwise, if wakeup is disallowed, the event mask is not
> set before suspend continues and can result in an early wakeup.
>

Please include the commit hash it fixes, also it may be a good idea to
tag it for stable as well.

> Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> ---
> Observed on ChromeOS as follows:
>
> < HCI Command: Disconnect (0x01|0x0006) plen 3
>         Handle: 256
>         Reason: Remote Device Terminated due to Power Off (0x15)
> > HCI Event: Command Status (0x0f) plen 4
>       Disconnect (0x01|0x0006) ncmd 1
>         Status: Success (0x00)
> @ MGMT Event: Device Disconnected (0x000c) plen 8
>         BR/EDR Address: 04:52:C7:C3:65:B5 (Bose Corporation)
>         Reason: Connection terminated by local host for suspend (0x05)
> @ MGMT Event: Controller Suspended (0x002d) plen 1
>         Suspend state: Disconnected and not scanning (1)
> > HCI Event: Disconnect Complete (0x05) plen 4
>         Status: Success (0x00)
>         Handle: 256
>         Reason: Connection Terminated By Local Host (0x16)
>
> The expectation is that we should see Set Event Mask before completing
> the suspend so that the `Disconnect Complete` doesn't wake us up.
>
>
>  net/bluetooth/hci_sync.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
> index 148ce629a59f..e6d804b82b67 100644
> --- a/net/bluetooth/hci_sync.c
> +++ b/net/bluetooth/hci_sync.c
> @@ -5297,6 +5297,9 @@ int hci_suspend_sync(struct hci_dev *hdev)
>                 return err;
>         }
>
> +       /* Update event mask so only the allowed event can wakeup the host */
> +       hci_set_event_mask_sync(hdev);
> +
>         /* Only configure accept list if disconnect succeeded and wake
>          * isn't being prevented.
>          */
> @@ -5308,9 +5311,6 @@ int hci_suspend_sync(struct hci_dev *hdev)
>         /* Unpause to take care of updating scanning params */
>         hdev->scanning_paused = false;
>
> -       /* Update event mask so only the allowed event can wakeup the host */
> -       hci_set_event_mask_sync(hdev);
> -
>         /* Enable event filter for paired devices */
>         hci_update_event_filter_sync(hdev);
>
> --
> 2.37.1.359.gd136c6c3e2-goog
>


-- 
Luiz Augusto von Dentz
