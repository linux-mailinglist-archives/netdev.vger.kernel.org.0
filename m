Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE5D843D0A0
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 20:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243531AbhJ0SZZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 14:25:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243523AbhJ0SZT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 14:25:19 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F443C0613B9
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 11:22:53 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id c28so3312923qtv.11
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 11:22:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V9N5C8SGb7U5wdMZ58rdvN1GPz0ZxsaF/5pC41Q62sE=;
        b=FQVRt63dmGzxcOIe6TYyIX4Vu9tje2LGd9fxy8cyXIUBWKQwtlTDLHo7hmIBdrrDgI
         ETEQ2EZ34R5jo6WeXHhUcp0qigiPu3E8JkuaemsjFQyLD/RQS4u7bHF4Gwj+g3v2PuhP
         cFjBpa+zovyyDe1er6eRmuezXlUrm3uFS55+Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V9N5C8SGb7U5wdMZ58rdvN1GPz0ZxsaF/5pC41Q62sE=;
        b=oR82p4G7UJ2cY3DJ3DJmUMGRWkugT491XImJcBrxYru9A89JHGIjUDzfSe94FXjPgF
         cgUhhax/Yw+O1rM3mJMzRg7WJwmxQzsv40xS29HxbJ308ohzWohOKZg6R6B1+r8w3v1u
         gxzAwdgXcGpNR9ONUn3rVzlLBVRj/r4O5rY7YkeuKCTtrQW/35eeZkRsSbOCHSjZ1pVa
         y4Nc6tUXdxXBF3nOdA2JfJzEc6RtqkVT8TmXN3hdGx7MTaQ7LbqI6Y6IENa9uOhVafVQ
         JAy8ymT90h2oclJG/TTa9lUbB9+LXXvU9IzJfylJIg+rQPXlqdlZmo6vlBlCGmLZStKy
         0OKw==
X-Gm-Message-State: AOAM531OzUDdifdldMcDCXbP8taTpBaIBI4pPDqzHhVBLgR93fVthwO8
        2vfDX9N+8Azyqd1rfj4O+dGDRR/HIKDUJg==
X-Google-Smtp-Source: ABdhPJwo6ibiSs5dePtgVQ5+2cMaJlehlejF4W/26ZqPTRB6g3owDnNhGhrKwG6pQt/rc62UeYY/hQ==
X-Received: by 2002:a05:622a:118b:: with SMTP id m11mr33571210qtk.67.1635358972197;
        Wed, 27 Oct 2021 11:22:52 -0700 (PDT)
Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com. [209.85.219.172])
        by smtp.gmail.com with ESMTPSA id g12sm474843qtb.3.2021.10.27.11.22.50
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Oct 2021 11:22:51 -0700 (PDT)
Received: by mail-yb1-f172.google.com with SMTP id m63so8563442ybf.7
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 11:22:50 -0700 (PDT)
X-Received: by 2002:a25:c344:: with SMTP id t65mr35272097ybf.409.1635358970358;
 Wed, 27 Oct 2021 11:22:50 -0700 (PDT)
MIME-Version: 1.0
References: <20211027080819.6675-1-johan@kernel.org> <20211027080819.6675-4-johan@kernel.org>
In-Reply-To: <20211027080819.6675-4-johan@kernel.org>
From:   Brian Norris <briannorris@chromium.org>
Date:   Wed, 27 Oct 2021 11:22:39 -0700
X-Gmail-Original-Message-ID: <CA+ASDXMYbP3jQPeOpDDktHgp4X81AH41cgiLFgz-YHVPyZO1sw@mail.gmail.com>
Message-ID: <CA+ASDXMYbP3jQPeOpDDktHgp4X81AH41cgiLFgz-YHVPyZO1sw@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] mwifiex: fix division by zero in fw download path
To:     Johan Hovold <johan@kernel.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Amitkumar Karwar <akarwar@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 27, 2021 at 1:12 AM Johan Hovold <johan@kernel.org> wrote:
> --- a/drivers/net/wireless/marvell/mwifiex/usb.c
> +++ b/drivers/net/wireless/marvell/mwifiex/usb.c
> @@ -505,6 +505,22 @@ static int mwifiex_usb_probe(struct usb_interface *intf,
>                 }
>         }
>
> +       switch (card->usb_boot_state) {
> +       case USB8XXX_FW_DNLD:
> +               /* Reject broken descriptors. */
> +               if (!card->rx_cmd_ep || !card->tx_cmd_ep)
> +                       return -ENODEV;

^^ These two conditions are applicable to USB8XXX_FW_READY too, right?

> +               if (card->bulk_out_maxpktsize == 0)
> +                       return -ENODEV;
> +               break;
> +       case USB8XXX_FW_READY:
> +               /* Assume the driver can handle missing endpoints for now. */
> +               break;
> +       default:
> +               WARN_ON(1);
> +               return -ENODEV;
> +       }
> +

Anyway, looks pretty good, thanks:

Reviewed-by: Brian Norris <briannorris@chromium.org>
