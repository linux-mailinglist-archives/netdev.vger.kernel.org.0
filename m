Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE9C641FA92
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 11:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232662AbhJBJVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Oct 2021 05:21:02 -0400
Received: from mail-vk1-f171.google.com ([209.85.221.171]:38775 "EHLO
        mail-vk1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232611AbhJBJU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Oct 2021 05:20:58 -0400
Received: by mail-vk1-f171.google.com with SMTP id g15so5469598vke.5
        for <netdev@vger.kernel.org>; Sat, 02 Oct 2021 02:19:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x+xYE8hczlO6GFnDveXBiRxByg4CFjvmx5N3gLcK3ic=;
        b=QCpgd7w3tPrk7jddbl1i79U8g4iLXaKokO22yUgWln7TcisddFKKRUfebkqu33iGZ8
         nJUVxDzGg8a0/gztMvJ4TdnTXQNtHXOCagJxDHYE0Ur2jva1SFEtmB/7Q2PXc3Osi29b
         QrS78ARgAwFRw3ugoJWNALrZ4VIHcRBPqeA23nD9sIxkYaPBG49w44hniKZtpu2ZLgQF
         pA1ntQ/WgoEItXzf5cV/J/kim/zu0KjrPvLrypcXI3BVol4ZXXRPBpx9VW0n7EVIjUtU
         iSwO7H0U2WhWamBwTM60R1P8Tr1sGJeXWq8x5mWMXVTu8kTcJKg07bWpgE6N2MFnRhRG
         r+Zg==
X-Gm-Message-State: AOAM530ObPdlymDDlxcEvmUeVVVUszm6wT8Af5Dbu2RGWQaA9xe0NbdA
        eS7dUPPgPSMn/dPfcmANNf+4Uqu1ci8riTRshHI=
X-Google-Smtp-Source: ABdhPJwcOdFmtRf0gkHzfZgpjXe/xFEruOKZ49Kymm8VmXyF5sO6oaNWBSQVsNwTDMHXSX07vsIGfcSGECzgtDSlD8w=
X-Received: by 2002:a1f:1841:: with SMTP id 62mr10464590vky.26.1633166352464;
 Sat, 02 Oct 2021 02:19:12 -0700 (PDT)
MIME-Version: 1.0
References: <20211001213228.1735079-1-kuba@kernel.org> <20211001213228.1735079-2-kuba@kernel.org>
In-Reply-To: <20211001213228.1735079-2-kuba@kernel.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Sat, 2 Oct 2021 11:19:01 +0200
Message-ID: <CAMuHMdXaq=7bkL6Vx5CHve2mLTifa48y3-4KO2tdjAp3fQ-9Nw@mail.gmail.com>
Subject: Re: [PATCH net-next 01/11] arch: use eth_hw_addr_set()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        linux-m68k <linux-m68k@lists.linux-m68k.org>,
        Chris Zankel <chris@zankel.net>,
        Max Filippov <jcmvbkbc@gmail.com>,
        "open list:TENSILICA XTENSA PORT (xtensa)" 
        <linux-xtensa@linux-xtensa.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 1, 2021 at 11:32 PM Jakub Kicinski <kuba@kernel.org> wrote:
> Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
> of VLANs...") introduced a rbtree for faster Ethernet address look
> up. To maintain netdev->dev_addr in this tree we need to make all
> the writes to it got through appropriate helpers.
>
> Convert misc arch drivers from memcpy(... ETH_ADDR) to eth_hw_addr_set():
>
>   @@
>   expression dev, np;
>   @@
>   - memcpy(dev->dev_addr, np, ETH_ALEN)
>   + eth_hw_addr_set(dev, np)
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

>  arch/m68k/emu/nfeth.c               | 2 +-

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
