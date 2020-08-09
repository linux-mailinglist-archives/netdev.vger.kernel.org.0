Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A803323FD6E
	for <lists+netdev@lfdr.de>; Sun,  9 Aug 2020 10:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726209AbgHIIsu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Aug 2020 04:48:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726012AbgHIIst (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Aug 2020 04:48:49 -0400
Received: from mail-ua1-x944.google.com (mail-ua1-x944.google.com [IPv6:2607:f8b0:4864:20::944])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58451C061A27
        for <netdev@vger.kernel.org>; Sun,  9 Aug 2020 01:48:49 -0700 (PDT)
Received: by mail-ua1-x944.google.com with SMTP id u15so1625891uau.10
        for <netdev@vger.kernel.org>; Sun, 09 Aug 2020 01:48:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GKI56+bDaX14CCr0kM6K85vrY7pTEhw0ASbGvetXsUY=;
        b=PvIFeFiDyWS1xZmw3w/29x+ATXIEqrfaERQ5aQWzR1x+gOyXFF4sJIJVlcjSljlZde
         TPAKbtYU83qY38G65Xda9O3mLX3FJT4pL5VLgi1TiPcSAUOhwHcL2cv3Pv2LEKtHhj7c
         3vLOBdUjtzzXf7tu/Q+vkDVU4uIcHTT35/2v+xB/FwJqqJPhMK30zAlYOvS/BlNH84Zr
         Qm/dQeVmm6H+1U3qbm7x2KMcyETgSpgr9rxRurDfc4fLjHZ7K9okCeNAEylzNwRET+Dq
         deaEeF6M/eX73zVSUg+7iTfbhM1tUkEnzVNsTY5Jclv0ye0YvFuRr3k1rLLWmKw2I433
         sPNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GKI56+bDaX14CCr0kM6K85vrY7pTEhw0ASbGvetXsUY=;
        b=jCsfoMfJkNLmNxBs9LF0ryHdbfocU710Y/5p8yny9elMrndVZLf+ABVfDGQxUB5TDk
         6aydGXItBLl7g5F0T4GqcTjQg5DwXzquNeN0Zr2a2aS6OzuZDNYu7S2/AdL+eZKD9QrH
         EtCvuOFI8tXs8l6GgbF5nlImPQwP4jmMqtTYwG4XZ0/FZZ614vlq2SNa+3pqUACjRUrk
         sCq19PdFiWfXh+Kp6APoXVF6/CEIeBsLY7LIK1dFBvHlJEJmAZUkbzWU6PzMLhlk1INv
         0QTY/sP9Yq5zD8mHeLdyc5PV1AHusOe80mlwoBYv+SGo7L5V3u4t1b+yVo326HaAjgHR
         7n0w==
X-Gm-Message-State: AOAM533YY03t+OxJ4ax1mckPU1oj8WT+//v+r3T21yezLiQ584XkwFo2
        aKn39mvsyeUD20LH/yOONBFVjtcT97Y=
X-Google-Smtp-Source: ABdhPJyIqKV+fIzGPeh/qC6yCZL37+E68isUkZfdKNl0ISk6zL74J9ESd8bZgUuzwLzRStZSVQzigw==
X-Received: by 2002:a9f:2e0d:: with SMTP id t13mr15526243uaj.69.1596962926642;
        Sun, 09 Aug 2020 01:48:46 -0700 (PDT)
Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com. [209.85.217.42])
        by smtp.gmail.com with ESMTPSA id y6sm3435056vke.35.2020.08.09.01.48.44
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Aug 2020 01:48:45 -0700 (PDT)
Received: by mail-vs1-f42.google.com with SMTP id a1so2821323vsp.4
        for <netdev@vger.kernel.org>; Sun, 09 Aug 2020 01:48:44 -0700 (PDT)
X-Received: by 2002:a67:fdc4:: with SMTP id l4mr16028144vsq.51.1596962924152;
 Sun, 09 Aug 2020 01:48:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200808175251.582781-1-xie.he.0141@gmail.com>
In-Reply-To: <20200808175251.582781-1-xie.he.0141@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 9 Aug 2020 10:48:07 +0200
X-Gmail-Original-Message-ID: <CA+FuTSfxWhq0pxEGPtOMjFUB7-4Vax6XMGsLL++28LwSOU5b3g@mail.gmail.com>
Message-ID: <CA+FuTSfxWhq0pxEGPtOMjFUB7-4Vax6XMGsLL++28LwSOU5b3g@mail.gmail.com>
Subject: Re: [PATCH net] drivers/net/wan/lapbether: Added needed_tailroom
To:     Xie He <xie.he.0141@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Martin Schiller <ms@dev.tdt.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 8, 2020 at 7:53 PM Xie He <xie.he.0141@gmail.com> wrote:
>
> The underlying Ethernet device may request necessary tailroom to be
> allocated by setting needed_tailroom. This driver should also set
> needed_tailroom to request the tailroom needed by the underlying
> Ethernet device to be allocated.
>
> Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> Cc: Martin Schiller <ms@dev.tdt.de>
> Signed-off-by: Xie He <xie.he.0141@gmail.com>
> ---
>  drivers/net/wan/lapbether.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/wan/lapbether.c b/drivers/net/wan/lapbether.c
> index 1ea15f2123ed..cc297ea9c6ec 100644
> --- a/drivers/net/wan/lapbether.c
> +++ b/drivers/net/wan/lapbether.c
> @@ -340,6 +340,7 @@ static int lapbeth_new_device(struct net_device *dev)
>          */
>         ndev->needed_headroom = -1 + 3 + 2 + dev->hard_header_len
>                                            + dev->needed_headroom;
> +       ndev->needed_tailroom = dev->needed_tailroom;

Does this solve an actual observed bug?

In many ways lapbeth is similar to tunnel devices. This is not common.
