Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 528CF29CAE2
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 22:04:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1831903AbgJ0VED (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 17:04:03 -0400
Received: from mail-ua1-f67.google.com ([209.85.222.67]:45480 "EHLO
        mail-ua1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1831899AbgJ0VEC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 17:04:02 -0400
Received: by mail-ua1-f67.google.com with SMTP id r9so892962uat.12
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 14:04:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vDNUWG0CCAnI3/on8IU6/S5zmNaXv0vHa0ORBBe1kWM=;
        b=KeWMd4gTFJ9eHYAhHVe2NPACQcU79GrdCOj9bGwxQdFtUHpDxd/oHItRsTJlHKmvCP
         ugKjI6QsWk21IfGnqh14LWbQMPwxNMVq2hMBEzagLTExqkAS85+NaIzzzpIWbX6RO61x
         A6zgzVYT0et+/OdflYTNsD4S36LLBzGuSKAfr/fWyeb445od6QNoaR4XapWqCI/2U18v
         Xtbl15GulaX/gZ1LpOzDqW20PU51XUzyxynnhYi+sHg//x3KIoaKhGa0I1RLwqVG6VCj
         yQgao27O5kJL7yy3bMrJB83ux7h/pGej/w8jTw9lpwIUgCtR8oq9aPz3HzDDBf2PQ1Pi
         CMxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vDNUWG0CCAnI3/on8IU6/S5zmNaXv0vHa0ORBBe1kWM=;
        b=p4y2ICcXSqkOpbyPFTFeZZgto8/+eXrsSdvEywn+KwGlcSobF0C9Okk9QKZfeTXycq
         xoj4B30tLLZetAE5f9T7fP9p14zxxed/ckQrxIGwzzW0iDTOBbQWPGd8wuoJmVfAjKPM
         0fGSQ9O69rESNm4nWskYpe1jse1jsRS4MYmMpynZC1BiI40WwyaEwY5X68WOFUIPY8rJ
         jEpGbEic8yDLZ5A5M/joWmHEtYswIdEV6Qqebu/F1LqoOBJ0bd8nGxEwRdVKo9Q/14CL
         P1pcQzw/qUMLVgpuomkYFjH5oaIKtDjtUcD1/Cvg0CggMx/LnrmZmFIHrl46xhIISI6z
         eTlA==
X-Gm-Message-State: AOAM532Y2SiE5YHzHhdRYgALYgGgAhhb8sr8+JzslumdU8XDjrN6S4bZ
        +ssSWXHD2oXmu9trLSN0bP4Xhd9nUYg=
X-Google-Smtp-Source: ABdhPJzq4YECavL3cc4lO0M/7YPxsgXEVSzxf3Vj+eCAFYM7DQS8bFdaqs5BxxNxYsbASzGB15mrMQ==
X-Received: by 2002:ab0:6f8e:: with SMTP id f14mr2791303uav.119.1603832639279;
        Tue, 27 Oct 2020 14:03:59 -0700 (PDT)
Received: from mail-ua1-f47.google.com (mail-ua1-f47.google.com. [209.85.222.47])
        by smtp.gmail.com with ESMTPSA id r18sm300420vsq.15.2020.10.27.14.03.56
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Oct 2020 14:03:57 -0700 (PDT)
Received: by mail-ua1-f47.google.com with SMTP id b34so900886uab.8
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 14:03:56 -0700 (PDT)
X-Received: by 2002:ab0:5447:: with SMTP id o7mr2895661uaa.37.1603832635805;
 Tue, 27 Oct 2020 14:03:55 -0700 (PDT)
MIME-Version: 1.0
References: <1603787977-6975-1-git-send-email-loic.poulain@linaro.org>
In-Reply-To: <1603787977-6975-1-git-send-email-loic.poulain@linaro.org>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 27 Oct 2020 17:03:18 -0400
X-Gmail-Original-Message-ID: <CA+FuTScQC_4Xnpv=_yTmDbwyEv-1Ao3hSX189+7QVPBNhv=A=A@mail.gmail.com>
Message-ID: <CA+FuTScQC_4Xnpv=_yTmDbwyEv-1Ao3hSX189+7QVPBNhv=A=A@mail.gmail.com>
Subject: Re: [PATCH v7 1/2] bus: mhi: Add mhi_queue_is_full function
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        manivannan.sadhasivam@linaro.org, hemantk@codeaurora.org,
        Network Development <netdev@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, jhugo@codeaurora.org,
        bbhatt@codeaurora.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 27, 2020 at 4:33 AM Loic Poulain <loic.poulain@linaro.org> wrote:
>
> This function can be used by client driver to determine whether it's
> possible to queue new elements in a channel ring.
>
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> ---
>  v1->v5: not part of the series
>  v6: Add this commit, used for stopping TX queue
>  v7: no change
>
>  drivers/bus/mhi/core/main.c | 15 +++++++++++++--
>  include/linux/mhi.h         |  7 +++++++
>  2 files changed, 20 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/bus/mhi/core/main.c b/drivers/bus/mhi/core/main.c
> index a588eac..44aa11f 100644
> --- a/drivers/bus/mhi/core/main.c
> +++ b/drivers/bus/mhi/core/main.c
> @@ -943,8 +943,8 @@ void mhi_ctrl_ev_task(unsigned long data)
>         }
>  }
>
> -static bool mhi_is_ring_full(struct mhi_controller *mhi_cntrl,
> -                            struct mhi_ring *ring)
> +static inline bool mhi_is_ring_full(struct mhi_controller *mhi_cntrl,
> +                                   struct mhi_ring *ring)

The compiler can decide whether to inline or not.

>  {
>         void *tmp = ring->wp + ring->el_size;
>
> @@ -1173,6 +1173,17 @@ int mhi_queue_buf(struct mhi_device *mhi_dev, enum dma_data_direction dir,
>  }
>  EXPORT_SYM
