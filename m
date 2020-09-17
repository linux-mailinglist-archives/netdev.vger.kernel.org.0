Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0268426E73D
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 23:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726409AbgIQVQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 17:16:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726022AbgIQVQL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 17:16:11 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19CFAC061351;
        Thu, 17 Sep 2020 14:16:11 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id x14so4168885oic.9;
        Thu, 17 Sep 2020 14:16:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AsrYKbcsJijPEVDhNCGN3B0ZQvVsWmRif4gtcVM+Ig8=;
        b=FtUH6ig8YVS7H8bq0navRcZiYF49TxzPX9fRzW7JKIGPgQLl2EM8/yhiD5j44bQ5N3
         8KxclSLs7LhUcRssHDeyWFLIYh/uUBJpKkgAU36525ji5vAeQzRB2FNDpU416v06C7O9
         r6h2rNPcrVHuP+G36S31dawRBJH6qkk/R0P9ZfpLNtlslHwcOGxepemxn5QBrd5j/zSm
         Plw7DpGnqv3XvZFroop5Ggan5mCF3sjgN5rFNIjFUXQKcpRYC7LPZbdygTtB3TUgeK87
         Q5B0imxW6aNeVDmtvxlylz6TgcmnDq4LT0ys5o+2dYDdPm52aKc5S8w5FjKpqktuSPv0
         QhtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AsrYKbcsJijPEVDhNCGN3B0ZQvVsWmRif4gtcVM+Ig8=;
        b=Ch6/oOMXUDydS65yn08UX0gPfm4UMLWtOPJiAHJvxhHvX7rhxoeIer+acGEVQHXlN8
         i+k/+NGGfX4wdipLa61K91Jm9lmaYbAOmUNIn7xR4NuFHhTf26N+7zBTQvIX/a1qpGZd
         uNulk190FtSDLgxfrU6xXz7virIPKiAiQ4RPnLCob0EHvpJIf8Z5R2Od2xfJpL50pUjX
         K/JH4IYDZe69ycD28KWGfiZ/C/P8suPJRMCub6hG8hPVcD1XHbHJkN5JXStyP8cteD/I
         EhFzNBtrZcoj3+N5rFu181pf5rEP+1xTtjsB4ELhR4wZNioVxvTtk2S1ZNt46+BXsbkl
         7hsA==
X-Gm-Message-State: AOAM5304z7F2dsfkTbJDPkWqqqQnUxQXQGKYl3Yqm5ame1K3fkEE2O4b
        yl/fF1SCYt7WQxu9+1RuqW8cwMK1eHX5saFEDZk=
X-Google-Smtp-Source: ABdhPJwgDDnl5tN43fme5AYZxwAY7UH2LIKkocXlWvtrFI5ouRKFJxpFRz92OcU3mU5hG8H7yUd4lgTV6f3PMlvsUpc=
X-Received: by 2002:aca:1b01:: with SMTP id b1mr7789495oib.137.1600377370438;
 Thu, 17 Sep 2020 14:16:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200917164632.BlueZ.v2.1.I27ef2a783d8920c147458639f3fa91b69f6fd9ea@changeid>
In-Reply-To: <20200917164632.BlueZ.v2.1.I27ef2a783d8920c147458639f3fa91b69f6fd9ea@changeid>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Thu, 17 Sep 2020 14:15:59 -0700
Message-ID: <CABBYNZJv2-GAsfOrUVjb+ZcTQz5TJBDvuCjFzMQm=N7_F0VYPg@mail.gmail.com>
Subject: Re: [BlueZ PATCH v2 1/6] Bluetooth: Update Adv monitor count upon removal
To:     Howard Chung <howardchung@google.com>
Cc:     "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Manish Mandlik <mmandlik@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        Alain Michaud <alainm@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Howard,

On Thu, Sep 17, 2020 at 1:47 AM Howard Chung <howardchung@google.com> wrote:
>
> From: Miao-chen Chou <mcchou@chromium.org>
>
> This fixes the count of Adv monitor upon monitor removal.
>
> The following test was performed.
> - Start two btmgmt consoles, issue a btmgmt advmon-remove command on one
> console and observe a MGMT_EV_ADV_MONITOR_REMOVED event on the other.
>
> Signed-off-by: Miao-chen Chou <mcchou@chromium.org>
> Signed-off-by: Howard Chung <howardchung@google.com>
> Reviewed-by: Alain Michaud <alainm@chromium.org>
> ---
>
> Changes in v2:
> - delete 'case 0x001c' in mgmt_config.c
>
>  net/bluetooth/hci_core.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> index 8a2645a833013..f30a1f5950e15 100644
> --- a/net/bluetooth/hci_core.c
> +++ b/net/bluetooth/hci_core.c
> @@ -3061,6 +3061,7 @@ static int free_adv_monitor(int id, void *ptr, void *data)
>
>         idr_remove(&hdev->adv_monitors_idr, monitor->handle);
>         hci_free_adv_monitor(monitor);
> +       hdev->adv_monitors_cnt--;
>
>         return 0;
>  }
> @@ -3077,6 +3078,7 @@ int hci_remove_adv_monitor(struct hci_dev *hdev, u16 handle)
>
>                 idr_remove(&hdev->adv_monitors_idr, monitor->handle);
>                 hci_free_adv_monitor(monitor);
> +               hdev->adv_monitors_cnt--;
>         } else {
>                 /* Remove all monitors if handle is 0. */
>                 idr_for_each(&hdev->adv_monitors_idr, &free_adv_monitor, hdev);
> --
> 2.28.0.618.gf4bc123cb7-goog

This looks like a kernel patch so you shouldn't be prefixing it with
BlueZ as it might confuse CI.

-- 
Luiz Augusto von Dentz
