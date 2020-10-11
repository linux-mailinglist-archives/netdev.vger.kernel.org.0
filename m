Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72DE028A967
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 20:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbgJKSiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 14:38:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbgJKSiN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 14:38:13 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31CF6C0613CE
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 11:38:13 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id f8so7922497vsl.3
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 11:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/LE5+6X44Ua2bvmzUcaKfhMsht1eiuM/FlyTObIJojA=;
        b=PJ2GRWYt81lzLhvYB2TcbhTZLHq1zgnXFVPb45QhgZbLCGR6qi9PjP7BPvbcGYbN57
         /ct8nsW5Fl9cKSIhDkcfxUjZ+OHrKJCqwga+j8iNXXDqz6G+cCsr1+eQLDcg9XbxDJLr
         JhXn/du2kEA5AQTSEjmQAXameh7vMkbMESYcZjhbPfsrnl3W2HjegQN4BMpSiH9YkHYj
         RO/birE2JMFGAfKhmIC7XPjO5Pv1IHQapMCrGyyiEOk2SGenkgn2LcqkWojVi2Jo6Viy
         QXMHInvDBrL6WMjFoyc+29r14CHC5SY4wSh9NuEy3vaRmuFQEiEFjBMHuh6Ydj0E/jWb
         hvRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/LE5+6X44Ua2bvmzUcaKfhMsht1eiuM/FlyTObIJojA=;
        b=IqBFoUuMu8Tvo4Qg2z1VZoRVz9/IQKJzClFhW+c+Ix9Qs2c8FAI2f7oy3wRdCyoRpT
         2pBjXdOaY+xH3V/TB9sDUvgtH+tumJX1DddM1jDvDvhaFCNY6xHGAyYDeV3u3K/Kz4Tt
         +EYcRTBEsPvdNxx203GrJAB44QoN16UxX1yn3bwbe2W/OGUiB3yDI3210kH/Pppzh3js
         7PONqRGftgyMTfnDjl+Q4r9Kqi8qc3MAbbNWTpgB65bCLht0E5W71a/exD43r9kHP7yr
         FZrAebExmBjQQGLiA/yCCRxAIwQv/oLDLH2SFo+FTdf9RyXa9jDots2zfdFP+WNtS1OU
         jN/g==
X-Gm-Message-State: AOAM5306Xga2iLj7XGvW42RKoc3vsx+jvzNbOR96EoeRVlfv/xfJ/lEp
        r+HGNLBZy8euwQz6KZ7gLZ4iaU/HWn8=
X-Google-Smtp-Source: ABdhPJyTGIXNpQIu1PR2MWLUeb3wz3xK34GpG4a2eF5AnN4OaB1+ZQwrOmThZ+Z4HoZ6q73Kykd6sw==
X-Received: by 2002:a67:e3c1:: with SMTP id k1mr13423759vsm.29.1602441491675;
        Sun, 11 Oct 2020 11:38:11 -0700 (PDT)
Received: from mail-vk1-f175.google.com (mail-vk1-f175.google.com. [209.85.221.175])
        by smtp.gmail.com with ESMTPSA id h10sm1917500vke.46.2020.10.11.11.38.10
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Oct 2020 11:38:10 -0700 (PDT)
Received: by mail-vk1-f175.google.com with SMTP id z10so3350206vkn.0
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 11:38:10 -0700 (PDT)
X-Received: by 2002:a1f:ae85:: with SMTP id x127mr8696215vke.8.1602441489893;
 Sun, 11 Oct 2020 11:38:09 -0700 (PDT)
MIME-Version: 1.0
References: <20201011113955.19511-1-vvidic@valentin-vidic.from.hr>
In-Reply-To: <20201011113955.19511-1-vvidic@valentin-vidic.from.hr>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 11 Oct 2020 14:37:33 -0400
X-Gmail-Original-Message-ID: <CA+FuTScdX+kN_XHJiY9YCst6JTQHZ0g28XYakhcK92Oo2Kp5vw@mail.gmail.com>
Message-ID: <CA+FuTScdX+kN_XHJiY9YCst6JTQHZ0g28XYakhcK92Oo2Kp5vw@mail.gmail.com>
Subject: Re: [PATCH] net: korina: free array used for rx/tx descriptors
To:     Valentin Vidic <vvidic@valentin-vidic.from.hr>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Philip Rischel <rischelp@idt.com>,
        Felix Fietkau <nbd@openwrt.org>,
        Florian Fainelli <florian@openwrt.org>,
        Roman Yeryomin <roman@advem.lv>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@kernel.org>,
        Martin Habets <mhabets@solarflare.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 11, 2020 at 7:46 AM Valentin Vidic
<vvidic@valentin-vidic.from.hr> wrote:
>
> Memory was not freed when driver is unloaded from the kernel.
>
> Signed-off-by: Valentin Vidic <vvidic@valentin-vidic.from.hr>

Makes sense.

Fixes: ef11291bcd5f ("Add support the Korina (IDT RC32434) Ethernet MAC")

Slightly off-topic, but I don't fully fathom what goes on with this
pointer straight after the initial kmalloc.

        lp->td_ring = (struct dma_desc *)KSEG1ADDR(lp->td_ring);

> ---
>  drivers/net/ethernet/korina.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/ethernet/korina.c b/drivers/net/ethernet/korina.c
> index 03e034918d14..99146145f020 100644
> --- a/drivers/net/ethernet/korina.c
> +++ b/drivers/net/ethernet/korina.c
> @@ -1133,6 +1133,7 @@ static int korina_remove(struct platform_device *pdev)
>         iounmap(lp->eth_regs);
>         iounmap(lp->rx_dma_regs);
>         iounmap(lp->tx_dma_regs);
> +       kfree(lp->td_ring);
>
>         unregister_netdev(bif->dev);
>         free_netdev(bif->dev);

In general it is nice to release in reverse of acquire. But the driver
already does not follow this practice.
