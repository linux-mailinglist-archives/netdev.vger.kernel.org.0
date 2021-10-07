Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E18C64256AF
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 17:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241503AbhJGPhB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 11:37:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240520AbhJGPhA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 11:37:00 -0400
Received: from mail-vk1-xa30.google.com (mail-vk1-xa30.google.com [IPv6:2607:f8b0:4864:20::a30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77C94C061570;
        Thu,  7 Oct 2021 08:35:06 -0700 (PDT)
Received: by mail-vk1-xa30.google.com with SMTP id f126so2888528vke.3;
        Thu, 07 Oct 2021 08:35:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5WTwD94+ipaG7RqJCNvBFP/gG3VXHYRXybq3iqV1vuc=;
        b=JBOE4EIayLAPajB661c2z4LOE+SKukrHAlI9kulPa4FWkp+Tt+evWFMU+mwneaHUzg
         ZVHXnRTycZ/+oZWamQFwuVanHt9qRtBMswvQqE6rs+oXq7sfSrP0EUZzuG5DdckTWdjj
         XCCxKAOXHYLoTvbNk79Tp7EC0Mou5AajxnLiG9E5XV3wrFiNugtqngrOsqj78h073cr8
         708qU49wPuq8x0GCkliVMsunSVtfaGys6EPCfoLJcfnvqFd76nXIZtRJ1gzc1a/m1H9p
         EoTKdhBqPjMrKOOoFzoPoqEJP9ZWKlSeybc0ITibKJ4OSs5mJA/ao5WrqYQY2OpSZtRx
         vtzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5WTwD94+ipaG7RqJCNvBFP/gG3VXHYRXybq3iqV1vuc=;
        b=X2f8d6HfpciWvygMxBIIGDEW9bp0lXVGYqzyaFRFUcthSlH1iV8NV2qUXi7vhFRDBQ
         BS0s9MGhZ09UqFBZ3qLlrI4nBxqZlchmsbYMgIIe7Sz79Jm3G3asI7K+4csroETAF9fD
         OOb3fXv+xTwqV2TBLde4NPzH6ip1WAUXkveYmJx3i2mvQ7PjldjRXco98T1fL2BMr+ZM
         YphbmgUN2oh9+K8NEGPJEOCV6dRBj0REBKnnmqWNSO5zNSt0VUSMLW3I6ktE5vi54Wvp
         y83YepqdM3fyPWZpDg6noEmVz61W3gPql7Ax1OylXVNbYUo9qdOvU4Y2jCExMT0qKWv1
         dk4A==
X-Gm-Message-State: AOAM530OGPqiHR43I8HGb3ykOwkhmTCgaA1qwpP6f+heDzAvMbPTcaFD
        iAnfwrNTYuTtIgVy//PhmMp2rSMOXKJYhaNOm8Y=
X-Google-Smtp-Source: ABdhPJyJkU1px/SqrNn9EgIlLEPMrUrHsbE2jjtiKp9ZcRfrdi8Y/zBG8aZjxC1QttkNWaqkjBvs3N0570liXgYFhF4=
X-Received: by 2002:a1f:a9c4:: with SMTP id s187mr4383115vke.9.1633620905609;
 Thu, 07 Oct 2021 08:35:05 -0700 (PDT)
MIME-Version: 1.0
References: <20211007111713.12207-1-colin.king@canonical.com>
In-Reply-To: <20211007111713.12207-1-colin.king@canonical.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Thu, 7 Oct 2021 08:34:54 -0700
Message-ID: <CABBYNZKzVtyZ_qO8pvenSLFRdm9aumxD_-Src4VG3UHQa8y+1w@mail.gmail.com>
Subject: Re: [PATCH][next] Bluetooth: use bitmap_empty to check if a bitmap
 has any bits set
To:     Colin King <colin.king@canonical.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Colin,

On Thu, Oct 7, 2021 at 4:17 AM Colin King <colin.king@canonical.com> wrote:
>
> From: Colin Ian King <colin.king@canonical.com>
>
> The check to see if any tasks are left checks if bitmap array is zero
> rather than using the appropriate bitmap helper functions to check the
> bits in the array. Fix this by using bitmap_empty on the bitmap.
>
> Addresses-Coverity: (" Array compared against 0")
> Fixes: 912730b52552 ("Bluetooth: Fix wake up suspend_wait_q prematurely")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  net/bluetooth/hci_request.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
> index 209f4fe17237..bad3b9c895ba 100644
> --- a/net/bluetooth/hci_request.c
> +++ b/net/bluetooth/hci_request.c
> @@ -1108,7 +1108,7 @@ static void suspend_req_complete(struct hci_dev *hdev, u8 status, u16 opcode)
>         clear_bit(SUSPEND_SET_ADV_FILTER, hdev->suspend_tasks);
>
>         /* Wake up only if there are no tasks left */
> -       if (!hdev->suspend_tasks)
> +       if (!bitmap_empty(hdev->suspend_tasks, __SUSPEND_NUM_TASKS))
>                 wake_up(&hdev->suspend_wait_q);
>  }
>
> --
> 2.32.0

I was going to revert this change since it appears wake_up does
actually check the wake condition there is no premature wake up after
all.

-- 
Luiz Augusto von Dentz
