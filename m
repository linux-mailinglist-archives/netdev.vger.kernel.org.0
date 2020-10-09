Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C465B289058
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 19:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390224AbgJIR4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 13:56:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731500AbgJIR4A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 13:56:00 -0400
Received: from mail-ua1-x92a.google.com (mail-ua1-x92a.google.com [IPv6:2607:f8b0:4864:20::92a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52274C0613D2
        for <netdev@vger.kernel.org>; Fri,  9 Oct 2020 10:56:00 -0700 (PDT)
Received: by mail-ua1-x92a.google.com with SMTP id j20so1624707uaq.6
        for <netdev@vger.kernel.org>; Fri, 09 Oct 2020 10:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4EzsdGNNfSAfz4k6bDinfNA5n0ZTG1dhP6+No1OZWwE=;
        b=PHo8nVMJzmb13Dp63bbt44Dn2eYYlmU6Selw+7LkC/9Txd7X7rb/VMg/fWP1AtSb3T
         B17aZSlIoKwEaMmdAnHs+nV0Z2Eed3HWBSPoskwd6dZYd5NvtmSHzRojr16vcQ8lcxu5
         ylTI6V7Jh4PeKkeTM6gToR5+onSimrcmA7TXqf9/VksB9hyb1k9TtQXDrEdYQIwKnoFu
         hw9AOoEa4Y9bI5xeqOHEbACAxlEWi+mOqC7T1OXGIX3wHNt6h9BbN5ZR4f7+QYuRRrTr
         LZe8dilZbbbcPR0PJeMDL3ITQr5YhYc+GCMzX/M7xF9Pdjb9Q0UhTs5LyJFc4dmR+tuU
         RqUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4EzsdGNNfSAfz4k6bDinfNA5n0ZTG1dhP6+No1OZWwE=;
        b=etb/8ojFk3nTL+B4Dt+lgC2WH9gvYzX6uAUZeQDMsRDYTH20ATSQA4YxuJQCgwSo/o
         aaLXYp8mp9eGdwxj+W8Ts2BQk2U8KBYiP1dsNi8+Nk4sVtG0St+rulB9KwP50wcK9aVq
         G0Sp6L6D+is6C86aG6Zijm0clhfylRJtJABb6Tbpkv12sRczyks96KNmQ8+OZl8iX0qU
         Fo+fgUpXf7zInC6m0Dwvz05pbRCzYbjefoCQGfspTHjWNz6w7ivfsUd9+2fcslansTf+
         zlU/xUJbJYAWkMQwJ30r4WQ7HNzCj0Sb3e9/tquElfINt5l8xWjC16omwq9FUZDL55SP
         mV1g==
X-Gm-Message-State: AOAM530zl6QmyPshzzD5jAg9le6hWdITyg0E1jsLqP7E1/RSD781WS4T
        Tt+dzxgjmYQp8hh3yLaCQnGfwkI5Mn4=
X-Google-Smtp-Source: ABdhPJwX1njCC5JJWKnWRUP7nEYo4nNCEPk5OQIMGzq336XhQhriVVXULBvjuwXHFLm2diFwvBEJvg==
X-Received: by 2002:a9f:35e3:: with SMTP id u32mr8385013uad.99.1602266158391;
        Fri, 09 Oct 2020 10:55:58 -0700 (PDT)
Received: from mail-vs1-f41.google.com (mail-vs1-f41.google.com. [209.85.217.41])
        by smtp.gmail.com with ESMTPSA id l23sm1491809uap.7.2020.10.09.10.55.56
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Oct 2020 10:55:57 -0700 (PDT)
Received: by mail-vs1-f41.google.com with SMTP id v23so2843256vsp.6
        for <netdev@vger.kernel.org>; Fri, 09 Oct 2020 10:55:56 -0700 (PDT)
X-Received: by 2002:a67:8a8a:: with SMTP id m132mr8336519vsd.14.1602266156311;
 Fri, 09 Oct 2020 10:55:56 -0700 (PDT)
MIME-Version: 1.0
References: <20201007231050.1438704-1-anthony.l.nguyen@intel.com> <20201007231050.1438704-2-anthony.l.nguyen@intel.com>
In-Reply-To: <20201007231050.1438704-2-anthony.l.nguyen@intel.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 9 Oct 2020 13:55:19 -0400
X-Gmail-Original-Message-ID: <CA+FuTSc8eBgQcYTH4hzv_+BkxYLnWgogRcV-sep=kxiOrWkBFQ@mail.gmail.com>
Message-ID: <CA+FuTSc8eBgQcYTH4hzv_+BkxYLnWgogRcV-sep=kxiOrWkBFQ@mail.gmail.com>
Subject: Re: [net-next 1/3] i40e: Allow changing FEC settings on X722 if
 supported by FW
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jaroslaw Gawin <jaroslawx.gawin@intel.com>,
        Network Development <netdev@vger.kernel.org>,
        nhorman@redhat.com, sassmann@redhat.com,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 7, 2020 at 7:11 PM Tony Nguyen <anthony.l.nguyen@intel.com> wrote:
>
> From: Jaroslaw Gawin <jaroslawx.gawin@intel.com>
>
> Starting with API version 1.10 firmware for X722 devices has ability
> to change FEC settings in PHY. Code added in this patch allows
> changing FEC settings if the capability flag indicates the device
> supports this feature.
>
> Signed-off-by: Jaroslaw Gawin <jaroslawx.gawin@intel.com>
> Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
> Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
> Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>

Acked-by: Willem de Bruijn <willemb@google.com>

(for netdrv)

> @@ -1484,11 +1485,18 @@ static int i40e_set_fec_param(struct net_device *netdev,
>         int err = 0;
>
>         if (hw->device_id != I40E_DEV_ID_25G_SFP28 &&
> -           hw->device_id != I40E_DEV_ID_25G_B) {
> +           hw->device_id != I40E_DEV_ID_25G_B &&
> +           hw->device_id != I40E_DEV_ID_KX_X722) {
>                 err = -EPERM;
>                 goto done;
>         }
>
> +       if (hw->mac.type == I40E_MAC_X722 &&
> +           !(hw->flags & I40E_HW_FLAG_X722_FEC_REQUEST_CAPABLE)) {
> +               netdev_err(netdev, "Setting FEC encoding not supported by firmware. Please update the NVM image.\n");
> +               return -EINVAL;
> +       }
> +

no need to respin for this, but this early return is inconsistent with
other error paths in the function. Label done is not needed at all,
could convert them all.
