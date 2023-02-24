Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 367C66A2358
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 22:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbjBXVCt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 16:02:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbjBXVCs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 16:02:48 -0500
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18FED6C1BB;
        Fri, 24 Feb 2023 13:02:43 -0800 (PST)
Received: by mail-lj1-x22a.google.com with SMTP id z42so330805ljq.13;
        Fri, 24 Feb 2023 13:02:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NpU6Up7UETnz2pq7XODHJtt7I8JyxfECBCleg5aQwhA=;
        b=VV68wjkn34smib3jRhbgOS33PIw0pmvD26s7XN8aA6hz48MMaRaiRMSg9qv/bc7WWs
         3fryFBwjEL0DgzIBnLmfBiRUAOn/ounnUIyc28XCUtOdNN93chILZs52Jcbqx5SubwDL
         DQW51+SBF1XtIDk4YFRme9ilpN3ZqePPzYEMhNF2ViKOsEPyxAYiJFoogtMN3JQJP/pu
         WswvdQDyouLy3JEhKhW1f70E1ax4pKsdbuplYr4vko6Hy0Y2Tz7VTUVI0oTFpFidNnO5
         TMD5VqGf2GQZdPRkaepkw4Pak6dChROYSlv778NtbVes9e+7SKR21XRe2/UloV+n5y67
         Cr7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NpU6Up7UETnz2pq7XODHJtt7I8JyxfECBCleg5aQwhA=;
        b=VbLtcKbWPi77rcICIoOZyyDy4ma3P6cpdWpJOkzcc2O+pMpFxIUF8KXlwTBVkUHFOA
         +VSMamaHVtqf9tR4tPfZ8peRRC7NhHP5O8Qt9uDPTqvm+qGD3DvPSv59odosNl3CWXWt
         2ByZ+eUzCELadO90xjJECXWJ/O1/q3cpjheLV0oGMAkPSNCKHRmNfUAds72RKwJd0zB9
         ddciO5sWr7v8p7bETExECypPC0QEnKBLMobk2r3iatdPjvgeFRBf/AJH/xP+Rzp6Asp8
         W6WgvWfT9gNJlwiq8HN6ojUEPlrwRe+ZP1h66pghn4uXGKMtCJQ1oI+KscI9Ioj4HNOV
         c3sg==
X-Gm-Message-State: AO0yUKWj7/5A8Yt5bUV6f28fjEe9goDKt1mrsD7N9KgpS2+1wwZCKgU7
        +6feMGrnCEiRRMW4dD0+ghxeh4kV0ePe8MYGvbR/tj5O
X-Google-Smtp-Source: AK7set9lmy/zCl8t654Ss8iB8nL2WUL20jRdweYZStegtHEmzIVzTg6WtpF7doXrzl2iW9qFNzRaQAMIjv0F2w17qow=
X-Received: by 2002:a05:651c:48b:b0:293:5bfa:314f with SMTP id
 s11-20020a05651c048b00b002935bfa314fmr5342231ljc.9.1677272560990; Fri, 24 Feb
 2023 13:02:40 -0800 (PST)
MIME-Version: 1.0
References: <20230224195313.1877313-1-jiangzp@google.com> <20230224115310.kernel.v2.1.If0578b001c1f12567f2ebcac5856507f1adee745@changeid>
In-Reply-To: <20230224115310.kernel.v2.1.If0578b001c1f12567f2ebcac5856507f1adee745@changeid>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Fri, 24 Feb 2023 13:02:29 -0800
Message-ID: <CABBYNZ+yVWssa09NB+ahp-N87sLXRqYF58-GJK-Vx8jn-Sa5Uw@mail.gmail.com>
Subject: Re: [kernel PATCH v2 1/1] Bluetooth: hci_sync: clear workqueue before
 clear mgmt cmd
To:     Zhengping Jiang <jiangzp@google.com>
Cc:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        mmandlik@google.com, chromeos-bluetooth-upstreaming@chromium.org,
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

On Fri, Feb 24, 2023 at 11:53 AM Zhengping Jiang <jiangzp@google.com> wrote:
>
> Clear cmd_sync_work queue before clearing the mgmt cmd list to avoid
> racing conditions which cause use-after-free.
>
> When powering off the adapter, the mgmt cmd list will be cleared. If a
> work is queued in the cmd_sync_work queue at the same time, it will
> cause the risk of use-after-free, as the cmd pointer is not checked
> before use.
>
> Signed-off-by: Zhengping Jiang <jiangzp@google.com>
> ---
>
> Changes in v2:
> - Add function to clear the queue without stop the timer
>
> Changes in v1:
> - Clear cmd_sync_work queue before clearing the mgmt cmd list
>
>  net/bluetooth/hci_sync.c | 21 ++++++++++++++++++++-
>  1 file changed, 20 insertions(+), 1 deletion(-)
>
> diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
> index 117eedb6f709..b70365dfff0c 100644
> --- a/net/bluetooth/hci_sync.c
> +++ b/net/bluetooth/hci_sync.c
> @@ -636,6 +636,23 @@ void hci_cmd_sync_init(struct hci_dev *hdev)
>         INIT_DELAYED_WORK(&hdev->adv_instance_expire, adv_timeout_expire);
>  }
>
> +static void hci_pend_cmd_sync_clear(struct hci_dev *hdev)
> +{
> +       struct hci_cmd_sync_work_entry *entry, *tmp;
> +
> +       mutex_lock(&hdev->cmd_sync_work_lock);
> +       list_for_each_entry_safe(entry, tmp, &hdev->cmd_sync_work_list, list) {
> +               if (entry->destroy) {
> +                       hci_req_sync_lock(hdev);
> +                       entry->destroy(hdev, entry->data, -ECANCELED);
> +                       hci_req_sync_unlock(hdev);
> +               }
> +               list_del(&entry->list);
> +               kfree(entry);
> +       }
> +       mutex_unlock(&hdev->cmd_sync_work_lock);
> +}
> +
>  void hci_cmd_sync_clear(struct hci_dev *hdev)
>  {
>         struct hci_cmd_sync_work_entry *entry, *tmp;
> @@ -4842,8 +4859,10 @@ int hci_dev_close_sync(struct hci_dev *hdev)
>
>         if (!auto_off && hdev->dev_type == HCI_PRIMARY &&
>             !hci_dev_test_flag(hdev, HCI_USER_CHANNEL) &&
> -           hci_dev_test_flag(hdev, HCI_MGMT))
> +           hci_dev_test_flag(hdev, HCI_MGMT)) {
> +               hci_pend_cmd_sync_clear(hdev);

Any particular reason why you are not using hci_cmd_sync_clear
instead? We also may want to move the clearing logic to
hci_dev_close_sync since it should be equivalent to
hci_request_cancel_all.

>                 __mgmt_power_off(hdev);
> +       }
>
>         hci_inquiry_cache_flush(hdev);
>         hci_pend_le_actions_clear(hdev);
> --
> 2.39.2.722.g9855ee24e9-goog
>


-- 
Luiz Augusto von Dentz
