Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3D423FB674
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 14:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236780AbhH3Mul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 08:50:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236764AbhH3Muk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 08:50:40 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CA78C061575;
        Mon, 30 Aug 2021 05:49:46 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id fs6so9402412pjb.4;
        Mon, 30 Aug 2021 05:49:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=RBa6XNcbe4ciTI3q+7e6ZHUg6UZgMEgwHfZfyY6RHE8=;
        b=RbuuaXgZdVejw9R0ZYT7ymT15yDRi0AGA3s6fyI/6kZV+oAQ5NIOS7osvI7TeKHxx2
         orHBDXE02J34qEA8uONT22Ih2Wuw7WP83FzCzvVvtSR+VtK0gLF4HWotGc2e75YaPAXb
         0IvzYM4O0dmo+ZyCWmxWrggr+QS+a0V3ZMPvuyzjFzrdI3TFz8c4D78t9SjFiygc33st
         IsDu3aCe3lJtrIqQY0ozF3zZ+ilLOOl+QjMFA83CBXhsXRYSARAy15gngtW+ArwdK/KW
         PbqJjpE86Pv7UuR/KPput7vAOV08LYOvvp1adXx1vTwzMgNMu8O7/QNZQk6RCR0TmzG5
         BnYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=RBa6XNcbe4ciTI3q+7e6ZHUg6UZgMEgwHfZfyY6RHE8=;
        b=K2GxL9Mw9jf8oFV5NOv68t4tXodSavVV6kv7ofEH0uoN2w4w02qiuhZuWe7heK3M7Z
         tBxZp6Ghqupdp/RzSTVtJcY/enPaLjX33aj7JdUiFVjwpQSMdDjmHmINFqD/UlOyqhCx
         HU7Tqp+YSizIr74WZ9D6NEkHx0iLh2QxcjkSxWG1fytDp0rq9KOSGPJp+69bu7bBWX/e
         H8NwqaLIqh7edN8+422Mq9NZwgMyFtL3GeOuMdE/VI9iHVJLWkxwtcvX81XF1sTlFAqq
         KpomV0XC+6EOZH4LuC5K4kRwn90hhx+ek1hrbdpu8pAqQRMRqN1yiq6nEUAh/gW4pGVf
         fzog==
X-Gm-Message-State: AOAM530ZWkbKF5qCtmWpK6KBkuLWFzuQkpYy4pshGYa5xDNJ3D+G+4rb
        CqN7a5vNAatreTXuSDYLdeCr5/2JJGeNaTfem0g=
X-Google-Smtp-Source: ABdhPJzlagPfk+4rGPg3hrq6YFcqGyr6ThU2PHxTPXyomt5BdcUT47bJylEVd8JAum6mmpkmJxqDL70MUp3Sgt4KLMg=
X-Received: by 2002:a17:90a:6502:: with SMTP id i2mr39415492pjj.129.1630327786006;
 Mon, 30 Aug 2021 05:49:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210830123704.221494-1-verdre@v0yd.nl> <20210830123704.221494-2-verdre@v0yd.nl>
In-Reply-To: <20210830123704.221494-2-verdre@v0yd.nl>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Mon, 30 Aug 2021 15:49:09 +0300
Message-ID: <CAHp75VeAKs=nFw4E20etKc3C_Cszyz9AqN=mLsum7F-BdVK5Rg@mail.gmail.com>
Subject: Re: [PATCH 1/2] mwifiex: Use non-posted PCI register writes
To:     =?UTF-8?Q?Jonas_Dre=C3=9Fler?= <verdre@v0yd.nl>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 30, 2021 at 3:38 PM Jonas Dre=C3=9Fler <verdre@v0yd.nl> wrote:
>
> On the 88W8897 card it's very important the TX ring write pointer is
> updated correctly to its new value before setting the TX ready
> interrupt, otherwise the firmware appears to crash (probably because
> it's trying to DMA-read from the wrong place).
>
> Since PCI uses "posted writes" when writing to a register, it's not
> guaranteed that a write will happen immediately. That means the pointer
> might be outdated when setting the TX ready interrupt, leading to
> firmware crashes especially when ASPM L1 and L1 substates are enabled
> (because of the higher link latency, the write will probably take
> longer).
>
> So fix those firmware crashes by always forcing non-posted writes. We do
> that by simply reading back the register after writing it, just as a lot
> of other drivers do.
>
> There are two reproducers that are fixed with this patch:
>
> 1) During rx/tx traffic and with ASPM L1 substates enabled (the enabled
> substates are platform dependent), the firmware crashes and eventually a
> command timeout appears in the logs. That crash is fixed by using a
> non-posted write in mwifiex_pcie_send_data().
>
> 2) When sending lots of commands to the card, waking it up from sleep in
> very quick intervals, the firmware eventually crashes. That crash
> appears to be fixed by some other non-posted write included here.

Thanks for all this work!

Nevertheless, do we have any commits that may be a good candidate to
be in the Fixes tag here?

> Signed-off-by: Jonas Dre=C3=9Fler <verdre@v0yd.nl>
> ---
>  drivers/net/wireless/marvell/mwifiex/pcie.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wi=
reless/marvell/mwifiex/pcie.c
> index c6ccce426b49..bfd6e135ed99 100644
> --- a/drivers/net/wireless/marvell/mwifiex/pcie.c
> +++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
> @@ -237,6 +237,12 @@ static int mwifiex_write_reg(struct mwifiex_adapter =
*adapter, int reg, u32 data)
>
>         iowrite32(data, card->pci_mmap1 + reg);
>
> +       /* Do a read-back, which makes the write non-posted, ensuring the
> +        * completion before returning.

> +        * The firmware of the 88W8897 card is buggy and this avoids cras=
hes.

Any firmware version reference? Would be nice to have just for the
sake of record.

> +        */
> +       ioread32(card->pci_mmap1 + reg);
> +
>         return 0;
>  }


--=20
With Best Regards,
Andy Shevchenko
