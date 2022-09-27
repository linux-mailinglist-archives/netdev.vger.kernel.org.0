Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE6F5EB61D
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 02:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbiI0AKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 20:10:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiI0AKt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 20:10:49 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD169A1D2F;
        Mon, 26 Sep 2022 17:10:47 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id d42so13432217lfv.0;
        Mon, 26 Sep 2022 17:10:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=IUJ883vXpIy8HsSMOZN5r8Aa/v8we/1OUC9VvaE/vgg=;
        b=kdKOfVJjqcfbjmysbn8RvscGiIHxfnNSdIs/2eWi+aYJZeiV14hDxAtKmUV9CUTIn5
         Y+pImzu5BSsDPFmCaB2u/67WiDF58Hi/te8MS2eWoxZIZj2tafwR7ZBH8I3dJZ0iGger
         Cock4M9KkcCk7UhfsmKTfNOMXbs5YbAL4xmsbZTEfF1wi3GJS3BKTEaVSupek2epMyNR
         3MGPPPRpCQSeUoDWBs4cOQNTPezP2FgvvgPK0ncL2pqaINu80v748yDhogEkH8I5ntBl
         axRAW4zXq4+YWV1ici67mjtAQXxnp8OWFDJ7a3a13N0tcRYtwIZiZyufXYpZJ+CeD1sb
         T+mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=IUJ883vXpIy8HsSMOZN5r8Aa/v8we/1OUC9VvaE/vgg=;
        b=zk2Kn8f4iOFJXOKDX+cEuTn/JfLyGhU/hS8UJwPP2dYhFUzub3vtjAti6rjDWjl3+p
         e3KMgFEltBqOXj1DkooChNF/BiewLxdSBoZJEhm8LLDgDyyeHMMAl6nru0lbhI4xMpHP
         mtQYU8bUL9IylND1Xt7zjeKnUNvmpIs00BwxVG4qgsJ3m8kQ2G9jNW2SOgTgKV/ba3SQ
         gOITxExqbkNT0YrTzbJQNzQbLbB76yDFXxvqW/UtC+2EZBiKxKeZQGQXy6auRcHOK5ex
         yVqloiRbMB2RgcktwC+PmO+sMau8BFqHtlbW+sL5YtbbSi1EILqUqx7/quT6W/dm1/U9
         O5jQ==
X-Gm-Message-State: ACrzQf3qQtuhoveLD2wy50/XnM28aD1tPBxRjAID/0hvsf04V8FtaAff
        Kt9XJkZsysZAklhtjcoM8bykbLjzRL/ae/eijn8=
X-Google-Smtp-Source: AMsMyM5t2yMQz8YtpKBdLJnPDLccM1eNIwYgD1UwuR8cz1Q6SJGukjwtllwx6Lx4SuqcfIbmuGo049BDiixWKIsTf14=
X-Received: by 2002:a05:6512:b97:b0:497:5c43:2d61 with SMTP id
 b23-20020a0565120b9700b004975c432d61mr9093348lfv.251.1664237445949; Mon, 26
 Sep 2022 17:10:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220926164358.v2.1.Ic8eabc8ed89a07c3d52726dd017539069faac6c4@changeid>
In-Reply-To: <20220926164358.v2.1.Ic8eabc8ed89a07c3d52726dd017539069faac6c4@changeid>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Mon, 26 Sep 2022 17:10:34 -0700
Message-ID: <CABBYNZJNrnmw6uUwQekqz1zQnG++kAHDqGfHJOxO082g+1Y1kw@mail.gmail.com>
Subject: Re: [PATCH v2] Bluetooth: Call shutdown for HCI_USER_CHANNEL
To:     Abhishek Pandit-Subedi <abhishekpandit@google.com>
Cc:     linux-bluetooth@vger.kernel.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
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

Hi Abhishek,

On Mon, Sep 26, 2022 at 4:44 PM Abhishek Pandit-Subedi
<abhishekpandit@google.com> wrote:
>
> From: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
>
> Some drivers depend on shutdown being called for proper operation.
> Unset HCI_USER_CHANNEL and call the full close routine since shutdown is
> complementary to setup.
>
> Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> ---
>
> Using hci_qca, we can get the controller into a bad state simply by
> trying to bind to userchannel twice (open+bind+close, then open+bind).
> Without running the shutdown routine, the device seems to get into a bad
> state. A similar bug also occurs with btmtksdio (using MT7921).
>
> This change properly runs the shutdown routine, which should be
> complementary to setup. The reason it unsets the HCI_USER_CHANNEL flag
> is that some drivers have complex operations in their shutdown routine
> (including sending hci packets) and we need to support the normal data
> path for them (including cmd_timeout + recovery mechanisms).
>
> Note for v2: I've gotten a chance to test this on more devices
> and figure out why it wasn't working before in v1. I found two problems:
> I had a signal pending (SIGTERM) that was messing things up in the
> socket release function and the HCI_USER_CHANNEL flag was preventing
> hci_sync from operating properly during shutdown on Intel chipsets
> (which use the sync functions to send a reset command + other commands
> sometimes).
>
> This was tested with hci_qca (QCA6174-A-3), btmtksdio (MT7921-SDIO)
> and btusb (with AX200).
>
>
> Changes in v2:
> - Clear HCI_USER_CHANNEL flag at start of close and restore at end.
> - Add comment explaning why we need to clear flag and run shutdown.
>
>  net/bluetooth/hci_sync.c | 19 ++++++++++++++++---
>  1 file changed, 16 insertions(+), 3 deletions(-)
>
> diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
> index 422f7c6911d9..f9591fcefb8d 100644
> --- a/net/bluetooth/hci_sync.c
> +++ b/net/bluetooth/hci_sync.c
> @@ -4731,9 +4731,18 @@ int hci_dev_close_sync(struct hci_dev *hdev)
>  {
>         bool auto_off;
>         int err = 0;
> +       bool was_userchannel;
>
>         bt_dev_dbg(hdev, "");
>
> +       /* Similar to how we first do setup and then set the exclusive access
> +        * bit for userspace, we must first unset userchannel and then clean up.
> +        * Otherwise, the kernel can't properly use the hci channel to clean up
> +        * the controller (some shutdown routines require sending additional
> +        * commands to the controller for example).
> +        */
> +       was_userchannel = hci_dev_test_and_clear_flag(hdev, HCI_USER_CHANNEL);
> +
>         cancel_delayed_work(&hdev->power_off);
>         cancel_delayed_work(&hdev->ncmd_timer);
>         cancel_delayed_work(&hdev->le_scan_disable);
> @@ -4747,7 +4756,6 @@ int hci_dev_close_sync(struct hci_dev *hdev)
>         }
>
>         if (!hci_dev_test_flag(hdev, HCI_UNREGISTER) &&
> -           !hci_dev_test_flag(hdev, HCI_USER_CHANNEL) &&
>             test_bit(HCI_UP, &hdev->flags)) {
>                 /* Execute vendor specific shutdown routine */
>                 if (hdev->shutdown)

I guess the idea here is that shutdown can be run without the
HCI_USER_CHANNEL flag since the hdev is closing we don't expect any
traffic from socket/user channel? In that case I'd probably suggest
having this on its own function e.g. hci_dev_shutdown which can have
the logic of resetting the flag and restoring at the end. Also it is
probably a good idea to have some test mimicking this behavior on
userchan-tester so we do not accidentally break it.

> @@ -4756,6 +4764,8 @@ int hci_dev_close_sync(struct hci_dev *hdev)
>
>         if (!test_and_clear_bit(HCI_UP, &hdev->flags)) {
>                 cancel_delayed_work_sync(&hdev->cmd_timer);
> +               if (was_userchannel)
> +                       hci_dev_set_flag(hdev, HCI_USER_CHANNEL);
>                 return err;
>         }
>
> @@ -4795,7 +4805,7 @@ int hci_dev_close_sync(struct hci_dev *hdev)
>         auto_off = hci_dev_test_and_clear_flag(hdev, HCI_AUTO_OFF);
>
>         if (!auto_off && hdev->dev_type == HCI_PRIMARY &&
> -           !hci_dev_test_flag(hdev, HCI_USER_CHANNEL) &&
> +           !was_userchannel &&
>             hci_dev_test_flag(hdev, HCI_MGMT))
>                 __mgmt_power_off(hdev);
>
> @@ -4808,7 +4818,7 @@ int hci_dev_close_sync(struct hci_dev *hdev)
>
>         hci_sock_dev_event(hdev, HCI_DEV_DOWN);
>
> -       if (!hci_dev_test_flag(hdev, HCI_USER_CHANNEL)) {
> +       if (!was_userchannel)
>                 aosp_do_close(hdev);
>                 msft_do_close(hdev);
>         }
> @@ -4858,6 +4868,9 @@ int hci_dev_close_sync(struct hci_dev *hdev)
>         memset(hdev->dev_class, 0, sizeof(hdev->dev_class));
>         bacpy(&hdev->random_addr, BDADDR_ANY);
>
> +       if (was_userchannel)
> +               hci_dev_set_flag(hdev, HCI_USER_CHANNEL);
> +
>         hci_dev_put(hdev);
>         return err;
>  }
> --
> 2.37.3.998.g577e59143f-goog
>


-- 
Luiz Augusto von Dentz
