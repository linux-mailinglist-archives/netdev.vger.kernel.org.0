Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF2343F27E
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 00:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbhJ1WQQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 18:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231322AbhJ1WQP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 18:16:15 -0400
Received: from mail-ua1-x929.google.com (mail-ua1-x929.google.com [IPv6:2607:f8b0:4864:20::929])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02D8CC061570;
        Thu, 28 Oct 2021 15:13:48 -0700 (PDT)
Received: by mail-ua1-x929.google.com with SMTP id q13so14506967uaq.2;
        Thu, 28 Oct 2021 15:13:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OZwn3eXuvWv7lMEKRx3mWcKBqrug9ReClOP6MHvgXXo=;
        b=ncBwZyaDsRgBz2HNsnLFFT54p9rGXB1Z1lXnxnoKfOMf3POT5WAEVMfCIC9Aud49yG
         VEuaOfKviK7i0iS+WMtDqtEooKrux50TPvQI/VNRV9aiccWOLpgWL0VgdJHsE6F5na6g
         BYJ6MU+0FCEdJSeu+tL/iARZ4UrpAP7Rd94WA+xHNrB9m19lZWFLYlDrZSDoRXhJV8TK
         mxxZUP8GVxVL5H3b8BfCc12ayUsA6X6Wk+N4Qtm/7oBIuGc61CFfw4uW06fB8siNcpLL
         7Ijltqx4ZcwkkBRPPuOmNrd1TmI52J8ekafRFfYO//Mg1DxWSIOwWvzwjuYZ6ge4QITE
         FDAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OZwn3eXuvWv7lMEKRx3mWcKBqrug9ReClOP6MHvgXXo=;
        b=iEC/LiBhiado2tzjThQXnq4DqLRdhdDqt5hGJI62OhG+swI/Wzd/hgY0W9eHOYwkIc
         KKWI8R0ZeuDwhsPmF85XUfFgNyPTqrPlYsHoYx/lvfNPUZvC94LdIppFUUnUb/V+bdAe
         shux0BwaGCnjt0nu/DODfclEXwk9cocGoTuAoCwQ2jkaHabFCyEKnfBnxmL+2XzkDaso
         zNt2/5II8O17sGkyR3UH+PsBQs6v90PFiuKXaAlnbTRViRjlFdcrRH19m7YoWn8AKL3L
         7jxNKC1/qEaDrgKoFGJnZU63O4N6aHtCkspn9PiZTOMt9gbhN4WhMOK9O5qqlinRS/6K
         3QGg==
X-Gm-Message-State: AOAM532m4oL3Rvr8MUBY178XD3CzfC21PxyzBri4qyNBKV4OIqaU8Y/K
        ELjzz3JBoTw7IsnEef8tvVcQqawe3lq2ttmsKxo=
X-Google-Smtp-Source: ABdhPJw1zwmPqg/5ONAp6N8wLZJFTVyKdFFRxu5c7HNLQ7mlWQiiTYaHQQKdsd8lkm9W35GbYKYDQcxZQX5V+zk1Ffo=
X-Received: by 2002:ab0:2b13:: with SMTP id e19mr7889657uar.3.1635459227002;
 Thu, 28 Oct 2021 15:13:47 -0700 (PDT)
MIME-Version: 1.0
References: <20211028191723.1.I94a358fc5abdb596412a2e22dd2b73b71f56fa82@changeid>
In-Reply-To: <20211028191723.1.I94a358fc5abdb596412a2e22dd2b73b71f56fa82@changeid>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Thu, 28 Oct 2021 15:13:36 -0700
Message-ID: <CABBYNZKyJ7wJC5HcYy24LayrysywqjcRpAkMtHmm7=UrfucV4Q@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: Fix removing adv when processing cmd complete
To:     Archie Pusaka <apusaka@google.com>
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Sonny Sasaka <sonnysasaka@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Archie,

On Thu, Oct 28, 2021 at 4:17 AM Archie Pusaka <apusaka@google.com> wrote:
>
> From: Archie Pusaka <apusaka@chromium.org>
>
> If we remove one instance of adv using Set Extended Adv Enable, there
> is a possibility of issue occurs when processing the Command Complete
> event. Especially, the adv_info might not be found since we already
> remove it in hci_req_clear_adv_instance() -> hci_remove_adv_instance().
> If that's the case, we will mistakenly proceed to remove all adv
> instances instead of just one single instance.
>
> This patch fixes the issue by checking the content of the HCI command
> instead of checking whether the adv_info is found.
>
> Signed-off-by: Archie Pusaka <apusaka@chromium.org>
> Reviewed-by: Sonny Sasaka <sonnysasaka@chromium.org>
>
> ---
>
>  net/bluetooth/hci_event.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> index 3cba2bbefcd6..894670419a27 100644
> --- a/net/bluetooth/hci_event.c
> +++ b/net/bluetooth/hci_event.c
> @@ -1326,8 +1326,10 @@ static void hci_cc_le_set_ext_adv_enable(struct hci_dev *hdev,
>                                            &conn->le_conn_timeout,
>                                            conn->conn_timeout);
>         } else {
> -               if (adv) {
> -                       adv->enabled = false;
> +               if (cp->num_of_sets) {
> +                       if (adv)
> +                               adv->enabled = false;
> +
>                         /* If just one instance was disabled check if there are
>                          * any other instance enabled before clearing HCI_LE_ADV
>                          */
> --
> 2.33.0.1079.g6e70778dc9-goog

Applied, thanks.

-- 
Luiz Augusto von Dentz
