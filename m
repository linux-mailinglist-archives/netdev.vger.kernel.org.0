Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC66453EDDC
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 20:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231592AbiFFS1t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 14:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231269AbiFFS1q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 14:27:46 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D91353E05
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 11:27:44 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id o68so11508717qkf.13
        for <netdev@vger.kernel.org>; Mon, 06 Jun 2022 11:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J380jdF/ieu9cZkkbsOGiWk1KtiScqYXh68+x84xO1U=;
        b=KRU2FQlR9Ts6sUAIZXfil6mvcY7o6TcZx0MMUWmXKphrz4HGGcNwjzVb2wEdHggTZs
         qKSSpSoO63RXpp4JZNehk/p1HvO80p7M6qZqZQcRMJfD6fp8symEelduGP8uaYv2aZdE
         gRK14Rm/jGjoB30hPqe3f0PzVgZDGyYDXP1mY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J380jdF/ieu9cZkkbsOGiWk1KtiScqYXh68+x84xO1U=;
        b=105FDrTWoBc23LgIhCQXpkwbLWtmmHLmBD55nlZyPsf/7bwW4UPvmQFK+4B4cs2h/v
         zWTknX5wwnp2q8mMtkpQzZ9u12fdlzFyjvwkBboXPC+8Axkbxkld0JrlCxJ/m8E7Fqb0
         njvZgsD8rCV/we5/XOeSkpT6T70QMQuZhCJbAsF6tD7FaVr3ZCKokAblYRDhZoExwNyR
         ZRz+QMiZLTCJ8PFWatM2M3hclwLlOmoXv0mwbVutYLz90s4AgqgLO0OkiH7m44vGuUf1
         nV1UXXhzwTf0f1YCCgx40ZnomWo4n9r/BlxgDUwXUU8FTIjfu/DkQCDWjwxJVEMN/+0r
         sQPg==
X-Gm-Message-State: AOAM530034uBLSMdkfJglJYZD5hHrdmU89BOILO6QF2h66tasT1/PvY6
        ECJR735lnKKu2QxgVKp4QUm39RfobyK94PVPL0fEcQ==
X-Google-Smtp-Source: ABdhPJwIabZL7mcBY+lmnzLIZ8jcLxsQvEW4br9vFf2+vaEYmF5rcOzefcPkaYgC5t/nuN2aeb+Hlz67pD2Sf30fvJ8=
X-Received: by 2002:a05:620a:600a:b0:6a6:c6ac:c5e5 with SMTP id
 dw10-20020a05620a600a00b006a6c6acc5e5mr2695336qkb.286.1654540063651; Mon, 06
 Jun 2022 11:27:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220606134807.4102807-1-yangyingliang@huawei.com>
In-Reply-To: <20220606134807.4102807-1-yangyingliang@huawei.com>
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Date:   Mon, 6 Jun 2022 11:27:32 -0700
Message-ID: <CANFp7mUdv+SGTvvi+FqVESz_CuWdOfbP4dXFXLkCxPW9TPgrpg@mail.gmail.com>
Subject: Re: [PATCH -next] Bluetooth: hci_core: Fix error return code in hci_register_dev()
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, marcel@holtmann.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 6, 2022 at 6:38 AM Yang Yingliang <yangyingliang@huawei.com> wrote:
>
> If hci_register_suspend_notifier() fails, it should return error
> code in hci_register_dev().
>
> Fixes: d6bb2a91f95b ("Bluetooth: Unregister suspend with userchannel")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  net/bluetooth/hci_core.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> index a4b4b3b927f2..dbddf891a4a9 100644
> --- a/net/bluetooth/hci_core.c
> +++ b/net/bluetooth/hci_core.c
> @@ -2646,7 +2646,8 @@ int hci_register_dev(struct hci_dev *hdev)
>         hci_sock_dev_event(hdev, HCI_DEV_REG);
>         hci_dev_hold(hdev);
>
> -       if (hci_register_suspend_notifier(hdev))
> +       error = hci_register_suspend_notifier(hdev);
> +       if (error)
>                 goto err_wqueue;
>
>         queue_work(hdev->req_workqueue, &hdev->power_on);
> --
> 2.25.1
>

Ah, I missed this. Good catch!

Acked-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
