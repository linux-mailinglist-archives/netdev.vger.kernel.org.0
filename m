Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4043D3869
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 12:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231732AbhGWJcy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 05:32:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231467AbhGWJcx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 05:32:53 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21FC7C061575;
        Fri, 23 Jul 2021 03:13:27 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id o5so2983416ejy.2;
        Fri, 23 Jul 2021 03:13:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kYd4tdoQiz4/cRNtVUAlMn2ymN1e93EFk9P+Ltuhf9k=;
        b=TzP7UyRdTNkHrN1Cr45t3NYE1K+zPDAQLLNeeXSJFDf2lqoWTyGzxLQXMztJX7a/Ho
         OLfTn7MuqlaL/QTVJqBG5HEKKH/XxuJ21OjFriCwdM/eGagQnVxJDUIZXBzhVnXeZJ3W
         UwYM48yBXBA09JJkcinGTGV9AkK1bLA+t971eLWBYKvHMMl/DcCsTd80/mdKfccSnemB
         S8nFTwTNFcQrOXJRycr/lhWvFO7b6ACXUiHO0Puo3E34j/Z7BeZSK07OTZ04H1ixJ7/F
         +uZdNCAu2hvnmpEXs0YT/5TF33XU22/1z3uwoeC3K6YtSvzrshNkPo3CSqlxc4RUcH+y
         HbTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kYd4tdoQiz4/cRNtVUAlMn2ymN1e93EFk9P+Ltuhf9k=;
        b=UF1ke0Yh9GTG48aoOURNbM/8/Ab6tDa9PTaGOxYkcARrKvm31FB1PkQB92q9r9Y570
         veTV1vScTX8+BZi/NPK3dqCBXcdvvxtx1XW62yLHa9q2db6z8eAfpEIuhdsamTylAOom
         muGUYYspYMjfEy1tjqyyNQmX9xwYuDMT8T/ReqNa++8sszLiXdRqatRWBapq/EtqsSFD
         LCJvoei45n2k+G17X/T0iuUWnRZJ2PBljdqVAZBsjAzk69wLbO0padRSFU6Wz9sOnmEw
         uNfK5Lpa99tTgMn7Q3wVCT5TwJ50aY3EC/ePADjXQCPzZlRnQnEZwpFlM2y0cQ4YvJKj
         OsdQ==
X-Gm-Message-State: AOAM530msk7Mc1TXOx/Ep9Jt6/lj8BUZogeE0UUePe2ZR0es3oG2xiEj
        88zVJxdvFHv/w4/8eieuybimDoL5tzV8gLBfAIo=
X-Google-Smtp-Source: ABdhPJwIDBa8CF35dl6+LfDYt0rwlFb+BZqMuVLZEPgmBCnv6atPMS30kv5BgT4qR4HVQHHLIBdekFQDd7iTgMMLKfw=
X-Received: by 2002:a17:906:9b1:: with SMTP id q17mr3898362eje.546.1627035205650;
 Fri, 23 Jul 2021 03:13:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210709084351.2087311-1-mudongliangabcd@gmail.com>
In-Reply-To: <20210709084351.2087311-1-mudongliangabcd@gmail.com>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Fri, 23 Jul 2021 18:12:59 +0800
Message-ID: <CAD-N9QVHp9XMxn6GjVqnPjuMrCJ8vnFjxAVtgjGM82Erv=MKQw@mail.gmail.com>
Subject: Re: [PATCH] ath9k: hif_usb: fix memory leak in ath9k_hif_usb_firmware_cb
To:     ath9k-devel@qca.qualcomm.com, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Brooke Basile <brookebasile@gmail.com>
Cc:     syzbot+6692c72009680f7c4eb2@syzkaller.appspotmail.com,
        linux-wireless@vger.kernel.org,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 9, 2021 at 4:44 PM Dongliang Mu <mudongliangabcd@gmail.com> wrote:
>
> The commit 03fb92a432ea ("ath9k: hif_usb: fix race condition between
> usb_get_urb() and usb_kill_anchored_urbs()") adds three usb_get_urb
> in ath9k_hif_usb_dealloc_tx_urbs and usb_free_urb.
>
> Fix this bug by adding corresponding usb_free_urb in
> ath9k_hif_usb_dealloc_tx_urbs other and hif_usb_stop.
>

Any idea about this patch?

> Reported-by: syzbot+6692c72009680f7c4eb2@syzkaller.appspotmail.com
> Fixes: 03fb92a432ea ("ath9k: hif_usb: fix race condition between usb_get_urb() and usb_kill_anchored_urbs()")
> Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
> ---
>  drivers/net/wireless/ath/ath9k/hif_usb.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
> index 860da13bfb6a..bda91ff3289b 100644
> --- a/drivers/net/wireless/ath/ath9k/hif_usb.c
> +++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
> @@ -457,6 +457,7 @@ static void hif_usb_stop(void *hif_handle)
>                 usb_kill_urb(tx_buf->urb);
>                 list_del(&tx_buf->list);
>                 usb_free_urb(tx_buf->urb);
> +               usb_free_urb(tx_buf->urb);
>                 kfree(tx_buf->buf);
>                 kfree(tx_buf);
>                 spin_lock_irqsave(&hif_dev->tx.tx_lock, flags);
> @@ -779,6 +780,7 @@ static void ath9k_hif_usb_dealloc_tx_urbs(struct hif_device_usb *hif_dev)
>                 usb_kill_urb(tx_buf->urb);
>                 list_del(&tx_buf->list);
>                 usb_free_urb(tx_buf->urb);
> +               usb_free_urb(tx_buf->urb);
>                 kfree(tx_buf->buf);
>                 kfree(tx_buf);
>                 spin_lock_irqsave(&hif_dev->tx.tx_lock, flags);
> @@ -797,6 +799,7 @@ static void ath9k_hif_usb_dealloc_tx_urbs(struct hif_device_usb *hif_dev)
>                 usb_kill_urb(tx_buf->urb);
>                 list_del(&tx_buf->list);
>                 usb_free_urb(tx_buf->urb);
> +               usb_free_urb(tx_buf->urb);
>                 kfree(tx_buf->buf);
>                 kfree(tx_buf);
>                 spin_lock_irqsave(&hif_dev->tx.tx_lock, flags);
> --
> 2.25.1
>
