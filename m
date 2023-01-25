Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BEC167BF5D
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 22:56:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbjAYV4v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 16:56:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjAYVzO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 16:55:14 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ED522696;
        Wed, 25 Jan 2023 13:55:13 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id f34so97324lfv.10;
        Wed, 25 Jan 2023 13:55:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=SZV5K/HfAKQARdyuwKteZTtvAS263iCJ28CNRNH2rEI=;
        b=P1uBVP4tRSwhHrmjFoDdb1BM1wxpmqooN5zuTeh+N796tEtOVLgN/hkMY7x0vKkCl8
         K23jsOFwI9S/92KJkjkquYFzAVgFkwSg6DLhkYtWr2pYAkZkHW+Oaq3JMEoubwn1H5zn
         3qjKzCuzXDWLL97vKfBCd+RRPBWxWdjJtbdrdwNjaaDVDxjB59kGCV+yXwZKfaMMuCfS
         Xza3PL1P6gKZo3KedqGoW8lb3AJf0OmEUzRPlzASkABbFC4xpKSZvucNTejXv1nT8R9d
         +jSexKCnlpDsgYc+SCgoy9aeJHmnaLMdMSVhc9JAi31g+u62huGWX6np0gSGiAq2R5Hq
         SsmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SZV5K/HfAKQARdyuwKteZTtvAS263iCJ28CNRNH2rEI=;
        b=RRa1et9Z1BgKzAtJamhnwrC9Mbr4Af5urU5Jn6FEP31W4B1hwTk3ZZlEPIumNCdlVV
         vopuNkMXz4YhpagAUEbwqlh8jcARLGfMeKSiLxiO/Ey2nUEIufWBLlbu//e8xs/Wx5vC
         eIx98uGfEkCjKVZ1a+io39UdwekPG8SWiTTwb91nYPx7k5T875EwtgNkjuzAzT4leg86
         /68zgMaBbsMd9xDhK4zaSzJ/vAV/7/5kg8w7CLU/tbBlvhxCgS6fno9mwSHLcBYR8zoa
         Rt9p2zsYXG/eZS+xDQSms0ZdkFyXMFBkz+LBxEGcEoJ6V0q2MPsQ8MAgtezMSB+hr31s
         sRtg==
X-Gm-Message-State: AFqh2kqcBcq+keGAomMAYy6DmBg8peI4McKpk25ogS/KqkOT8fcB3Xim
        gfvctcGfMRKxmqBk5Q9ZxEmvnTu5Z9R+pRMSPM8=
X-Google-Smtp-Source: AMrXdXssXQCtaRxBOu8LyVHz7f7VKYZwTN75dhQo/hX/fF52WubYSdWJxDQ2AO63ToUf3rSWi2Wq/aTYRBzBzpBFcyc=
X-Received: by 2002:a19:5211:0:b0:4bd:5210:bd97 with SMTP id
 m17-20020a195211000000b004bd5210bd97mr1863086lfb.25.1674683711267; Wed, 25
 Jan 2023 13:55:11 -0800 (PST)
MIME-Version: 1.0
References: <20230125211210.552679-1-jiangzp@google.com> <20230125131159.kernel.v1.1.Id80089feef7af8846cc6f8182eddc5d7a0ac4ea7@changeid>
In-Reply-To: <20230125131159.kernel.v1.1.Id80089feef7af8846cc6f8182eddc5d7a0ac4ea7@changeid>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Wed, 25 Jan 2023 13:54:59 -0800
Message-ID: <CABBYNZJ8U4F_Bs5H9Xh5DbEcPOWHx3V43q3oA2GeTwTu8wt5ow@mail.gmail.com>
Subject: Re: [kernel PATCH v1 1/1] Bluetooth: Don't send HCI commands to
 remove adv if adapter is off
To:     Zhengping Jiang <jiangzp@google.com>
Cc:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        chromeos-bluetooth-upstreaming@chromium.org,
        Archie Pusaka <apusaka@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
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

Hi Zhengping,

On Wed, Jan 25, 2023 at 1:12 PM Zhengping Jiang <jiangzp@google.com> wrote:
>
> From: Archie Pusaka <apusaka@chromium.org>
>
> Mark the advertisement as disabled when powering off the adapter
> without removing the advertisement, so they can be correctly
> re-enabled when adapter is powered on again.
>
> When adapter is off and user requested to remove advertisement,
> a HCI command will be issued. This causes the command to timeout
> and trigger GPIO reset.

Please include the btmon portion when the issue occurs.

> Therefore, immediately remove the advertisement without sending
> any HCI commands.
>
> Note that the above scenario only happens with extended advertisement
> (i.e. not using software rotation), because on the SW rotation
> scenario, we just wait until the rotation timer runs out before
> sending the HCI command. Since the timer is inactive when adapter is
> off, no HCI commands are sent.
>
> Signed-off-by: Archie Pusaka <apusaka@chromium.org>
> Signed-off-by: Zhengping Jiang <jiangzp@google.com>
>
> ---
>
> Changes in v1:
> - Mark the advertisement as disabled instead of clearing it.
> - Remove the advertisement without sending HCI command if the adapter is off.

Perhaps we should split these into 2 separated changes then, on top of
it it perhaps would be a good idea to implement a test in mgmt-tester
to check the correct behavior.

>  net/bluetooth/hci_sync.c | 57 +++++++++++++++++++++++++++++++++++++---
>  1 file changed, 53 insertions(+), 4 deletions(-)
>
> diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
> index 117eedb6f709..08da68a30acc 100644
> --- a/net/bluetooth/hci_sync.c
> +++ b/net/bluetooth/hci_sync.c
> @@ -1591,6 +1591,16 @@ int hci_remove_ext_adv_instance_sync(struct hci_dev *hdev, u8 instance,
>         if (!ext_adv_capable(hdev))
>                 return 0;
>
> +       /* When adapter is off, remove adv without sending HCI commands */
> +       if (!hdev_is_powered(hdev)) {
> +               hci_dev_lock(hdev);
> +               err = hci_remove_adv_instance(hdev, instance);
> +               if (!err)
> +                       mgmt_advertising_removed(sk, hdev, instance);

This code above is duplicated in a few places so we might as well have
it as a separate function e.g. hci_remove_adv

> +               hci_dev_unlock(hdev);
> +               return err;
> +       }
> +
>         err = hci_disable_ext_adv_instance_sync(hdev, instance);
>         if (err)
>                 return err;
> @@ -1772,6 +1782,23 @@ int hci_schedule_adv_instance_sync(struct hci_dev *hdev, u8 instance,
>         return hci_start_adv_sync(hdev, instance);
>  }
>
> +static void hci_clear_ext_adv_ins_during_power_off(struct hci_dev *hdev,
> +                                                  struct sock *sk)
> +{
> +       struct adv_info *adv, *n;
> +       int err;
> +
> +       hci_dev_lock(hdev);
> +       list_for_each_entry_safe(adv, n, &hdev->adv_instances, list) {
> +               u8 instance = adv->instance;
> +
> +               err = hci_remove_adv_instance(hdev, instance);
> +               if (!err)
> +                       mgmt_advertising_removed(sk, hdev, instance);

Then just call hci_remove_adv.

> +       }
> +       hci_dev_unlock(hdev);
> +}
> +
>  static int hci_clear_adv_sets_sync(struct hci_dev *hdev, struct sock *sk)
>  {
>         int err;
> @@ -1779,6 +1806,12 @@ static int hci_clear_adv_sets_sync(struct hci_dev *hdev, struct sock *sk)
>         if (!ext_adv_capable(hdev))
>                 return 0;
>
> +       /* When adapter is off, remove adv without sending HCI commands */
> +       if (!hdev_is_powered(hdev)) {
> +               hci_clear_ext_adv_ins_during_power_off(hdev, sk);

Use the remove to describe the action e.g. hci_remove_all_adv.

> +               return 0;
> +       }
> +
>         /* Disable instance 0x00 to disable all instances */
>         err = hci_disable_ext_adv_instance_sync(hdev, 0x00);
>         if (err)
> @@ -5177,9 +5210,27 @@ static int hci_disconnect_all_sync(struct hci_dev *hdev, u8 reason)
>         return 0;
>  }
>
> +static void hci_disable_ext_advertising_temporarily(struct hci_dev *hdev)
> +{
> +       struct adv_info *adv, *n;
> +
> +       if (!ext_adv_capable(hdev))
> +               return;
> +
> +       hci_dev_lock(hdev);
> +
> +       list_for_each_entry_safe(adv, n, &hdev->adv_instances, list)
> +               adv->enabled = false;
> +
> +       hci_dev_clear_flag(hdev, HCI_LE_ADV);
> +
> +       hci_dev_unlock(hdev);
> +}
> +
>  /* This function perform power off HCI command sequence as follows:
>   *
> - * Clear Advertising
> + * Disable Advertising Instances. Do not clear adv instances so advertising
> + * can be re-enabled on power on.
>   * Stop Discovery
>   * Disconnect all connections
>   * hci_dev_close_sync
> @@ -5199,9 +5250,7 @@ static int hci_power_off_sync(struct hci_dev *hdev)
>                         return err;
>         }
>
> -       err = hci_clear_adv_sync(hdev, NULL, false);
> -       if (err)
> -               return err;
> +       hci_disable_ext_advertising_temporarily(hdev);

Something like hci_disable_all_adv sounds better here.

>
>         err = hci_stop_discovery_sync(hdev);
>         if (err)
> --
> 2.39.1.456.gfc5497dd1b-goog
>


-- 
Luiz Augusto von Dentz
