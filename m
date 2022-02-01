Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC264A659F
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 21:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbiBAUZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 15:25:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbiBAUZI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 15:25:08 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BB46C061714;
        Tue,  1 Feb 2022 12:25:08 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id c19so25738562ybf.2;
        Tue, 01 Feb 2022 12:25:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NQxBh7W6WQoopd/1GYZljiEFB/ShqPgFHLn5gnNvn8Y=;
        b=eef4eipwpvsL3TFJxxFdmb4L8ZoICrM8iScWq6tOGrxMFYvddvijvxioe1BqimVZjF
         zTxsmOqEWVCWAY9+ljLnftiZEr3qB6atVvG5B6HoLzXW9gcPBgXLSQxYllXa0qwvFBJ2
         3Bgbwo3aF32NYbRzzZ7Twm7RLSpxWMSDOoFAVz01CTJbYtAb03oXc6CiMms5Sv/eX+4X
         vO/IBz1JFEcwD+l02ewZnypRgup2+Va27nOIN8/FplZmyMtqy1nrLlz/p0nyRsphwJrK
         29YI3Ovhcvrh6GkZKwLJLrKxMsb0WTfUzfk6shVmqBJfWny8lYNQkGC3sGqeXvNcRUv0
         9abA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NQxBh7W6WQoopd/1GYZljiEFB/ShqPgFHLn5gnNvn8Y=;
        b=F+SEbEloE90L80+VA3g0o5g2a1f4db0JABHAkBBzNJIsyyEqYQApOoo17hJ47RFvBR
         DZ/zmnJYLTxDs6DQ5LzDMWly0MvRUaEOJwm2r0dUyV5EpBEcoav+zf3FMjMheVwMwaRL
         mPva5QQ6Mk5s/GPJtgSxcovs8tSdW8XFZ+Z333IqU2NKeIgCow0Z3qSzLM9VNQyPTTke
         jMbhlzw/0QhanZY9F6TVUXEi3aUub5m424hE7BcPvX6/vc9DoT+UJCvUJLIBNOPPLQXe
         uzbulDG9KZnp2WQzYv9aUDaR8a4IsSkWHG1IYTRd6xC9homSqz2iOJIxrbw2aXWgdo8P
         VDUQ==
X-Gm-Message-State: AOAM5308wqNOZjk2sk9Ei0VG9biwLJdvp47ICzCOwFSleS1XiJsaLBrL
        kZ2Hly6HzdGaNHSr9Xs94PIr1KTkD8S2cz9WVhg=
X-Google-Smtp-Source: ABdhPJzc9Eqbhc8KooDpwUj/fmwXhyfk2NIiX2gE3LH5W4yJw1W0sv5950Z38giEOj+JUOPs3+zTNJgZcQX4aHD/gUo=
X-Received: by 2002:a25:cccb:: with SMTP id l194mr37620366ybf.752.1643747107364;
 Tue, 01 Feb 2022 12:25:07 -0800 (PST)
MIME-Version: 1.0
References: <20220201174256.1690515-1-trix@redhat.com>
In-Reply-To: <20220201174256.1690515-1-trix@redhat.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Tue, 1 Feb 2022 12:24:56 -0800
Message-ID: <CABBYNZJx0Yye2f7ZE7d0WeZ6QQTQGUDHhqeobWZHE3PZGmG72A@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: hci_sync: fix undefined return of hci_disconnect_all_sync()
To:     trix@redhat.com
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, nathan@kernel.org,
        ndesaulniers@google.com,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tom,

On Tue, Feb 1, 2022 at 9:43 AM <trix@redhat.com> wrote:
>
> From: Tom Rix <trix@redhat.com>
>
> clang static analysis reports this problem
> hci_sync.c:4428:2: warning: Undefined or garbage value
>   returned to caller
>         return err;
>         ^~~~~~~~~~
>
> If there are no connections this function is a noop but
> err is never set and a false error could be reported.
> Return 0 as other hci_* functions do.
>
> Fixes: 182ee45da083 ("Bluetooth: hci_sync: Rework hci_suspend_notifier")
> Signed-off-by: Tom Rix <trix@redhat.com>
> ---
>  net/bluetooth/hci_sync.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
> index 6e71aa6b6feae..9327737da6003 100644
> --- a/net/bluetooth/hci_sync.c
> +++ b/net/bluetooth/hci_sync.c
> @@ -4425,7 +4425,7 @@ static int hci_disconnect_all_sync(struct hci_dev *hdev, u8 reason)
>                         return err;
>         }
>
> -       return err;
> +       return 0;
>  }
>
>  /* This function perform power off HCI command sequence as follows:
> --
> 2.26.3

Applied, thanks.

-- 
Luiz Augusto von Dentz
