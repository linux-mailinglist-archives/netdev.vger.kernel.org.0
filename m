Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 481C035412B
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 12:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241203AbhDEKWr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 06:22:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232322AbhDEKWq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 06:22:46 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C91DC061756
        for <netdev@vger.kernel.org>; Mon,  5 Apr 2021 03:22:40 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id l76so7839569pga.6
        for <netdev@vger.kernel.org>; Mon, 05 Apr 2021 03:22:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JjgwIjAp85WETxxoLIiGI4oB1jKd53gUCV9N8DoHoVo=;
        b=HK2iVnuNeYbiSGk/CpIB26Ey5gvjKZRle1JQkDy/zQo4RG2G3EHSfnUbJbeF2sW7Vt
         np0W9wUxkSMXuvlgL4wNOgEXTP8UeUHTUzX6YN3lIzWvtHvUKZdPakY8jC67r696cLtU
         9bBfBeOrv8KN8+hghSUTcbAL1a3tQ2lsDpgSAlTtROeEGE77umBa0NyibbmbkiVNqSaT
         U7fUOvTA/jZy0p1/JP3xmOCEvWelHy/Q65CAqtmHWniZ4fdZ+8W3Ro+47KY8DPt050uE
         RZeevE4BxqmxOZ1s5BSvvh2lBLuPT+9wcmz32pGp1ww1yeZulmBIIi/c2Wiqw3HLPO8u
         zwtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JjgwIjAp85WETxxoLIiGI4oB1jKd53gUCV9N8DoHoVo=;
        b=PQJioywrA+QaVagno27WMOcsm6hJAnqGA5iYOR0/GzVqIpE6VZN4aU3ckUU6rsXS4Z
         psL2TjZkJFaE75kC1GXKbDUJDAFmsa58N7O2FGc/8K55hPQzOfM2yXrtaNq66gm894+w
         fyadnzGJX9ANANmkfJDLkBojG1nNCmiiSfwDzAsvLCIWsQ/jGc1RWnYSuj/R9hHKwGyI
         JcTxuSDJdfh8dKHsgLiWC+fNqzYYksOfElgTJXhWy8hc5RDl2DgHpADGKif5Tc21YuQr
         HkpbkXBhVV/sLc7WjXGVXNgbKOGjofUG3/3thBU7SErr5qU4tZ+BEikumgKgUC2yYVY4
         JkQw==
X-Gm-Message-State: AOAM533JiEa2xCtnq+wTu3r36QWmiBrioC2drjRYcHHPv2xt3fTxSSi6
        AqKPp2EHcGPeFPYnlvCvdaW2IAsVe2N1BwrFhboBfA==
X-Google-Smtp-Source: ABdhPJxgf7FHvJvQJlQDJS7/bpeWe7CTfuF4tOMun1coUKie4kyPusS8tK5yZZJFAZ/zRyRM5Xa5a6xDqe8OW7ayfpo=
X-Received: by 2002:a62:7a09:0:b029:1f1:5cf4:3fd7 with SMTP id
 v9-20020a627a090000b02901f15cf43fd7mr22427429pfc.66.1617618160049; Mon, 05
 Apr 2021 03:22:40 -0700 (PDT)
MIME-Version: 1.0
References: <1617616369-27305-1-git-send-email-loic.poulain@linaro.org> <1617616369-27305-2-git-send-email-loic.poulain@linaro.org>
In-Reply-To: <1617616369-27305-2-git-send-email-loic.poulain@linaro.org>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Mon, 5 Apr 2021 12:30:50 +0200
Message-ID: <CAMZdPi-b0diW-80QhXLen0UJVHYQH_qixnZ+he_wWaoFxW5Dxg@mail.gmail.com>
Subject: Re: [PATCH net-next v9 2/2] net: Add Qcom WWAN control driver
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Aleksander Morgado <aleksander@aleksander.es>,
        open list <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 5 Apr 2021 at 11:44, Loic Poulain <loic.poulain@linaro.org> wrote:
>
> The MHI WWWAN control driver allows MHI QCOM-based modems to expose
> different modem control protocols/ports via the WWAN framework, so that
> userspace modem tools or daemon (e.g. ModemManager) can control WWAN
> config and state (APN config, SMS, provider selection...). A QCOM-based
> modem can expose one or several of the following protocols:
> - AT: Well known AT commands interactive protocol (microcom, minicom...)
> - MBIM: Mobile Broadband Interface Model (libmbim, mbimcli)
> - QMI: QCOM MSM/Modem Interface (libqmi, qmicli)
> - QCDM: QCOM Modem diagnostic interface (libqcdm)
> - FIREHOSE: XML-based protocol for Modem firmware management
>         (qmi-firmware-update)
>
> Note that this patch is mostly a rework of the earlier MHI UCI
> tentative that was a generic interface for accessing MHI bus from
> userspace. As suggested, this new version is WWAN specific and is
> dedicated to only expose channels used for controlling a modem, and
> for which related opensource userpace support exist.
>
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> ---
>  v2: update copyright (2021)
>  v3: Move driver to dedicated drivers/net/wwan directory
>  v4: Rework to use wwan framework instead of self cdev management
>  v5: Fix errors/typos in Kconfig
>  v6: - Move to new wwan interface, No need dedicated call to wwan_dev_create
>      - Cleanup code (remove legacy from mhi_uci, unused defines/vars...)
>      - Remove useless write_lock mutex
>      - Add mhi_wwan_wait_writable and mhi_wwan_wait_dlqueue_lock_irq helpers
>      - Rework locking
>      - Add MHI_WWAN_TX_FULL flag
>      - Add support for NONBLOCK read/write
>  v7: Fix change log (mixed up 1/2 and 2/2)
>  v8: - Implement wwan_port_ops instead of fops
>      - Remove all obsolete elements (kref, lock, waitqueues)
>      - Add tracking of RX buffer budget
>      - Use WWAN TX flow control function to stop TX when MHI queue is full
>  v9: - Add proper locking for rx_budget + rx_refill scheduling
>      - Fix cocci errors (use-after-free, ERR_CAST)
>
[...]
> +static int mhi_wwan_ctrl_probe(struct mhi_device *mhi_dev,
> +                              const struct mhi_device_id *id)
> +{
> +       struct mhi_controller *cntrl = mhi_dev->mhi_cntrl;
> +       struct mhi_wwan_dev *mhiwwan;
> +       struct wwan_port *port;
> +
> +       mhiwwan = kzalloc(sizeof(*mhiwwan), GFP_KERNEL);
> +       if (!mhiwwan)
> +               return -ENOMEM;
> +
> +       mhiwwan->mhi_dev = mhi_dev;
> +       mhiwwan->mtu = MHI_WWAN_MAX_MTU;
> +       INIT_WORK(&mhiwwan->rx_refill, mhi_wwan_ctrl_refill_work);
> +       spin_lock_init(&mhiwwan->tx_lock);
> +       spin_lock_init(&mhiwwan->rx_lock);
> +
> +       if (mhi_dev->dl_chan)
> +               set_bit(MHI_WWAN_DL_CAP, &mhiwwan->flags);
> +       if (mhi_dev->ul_chan)
> +               set_bit(MHI_WWAN_UL_CAP, &mhiwwan->flags);
> +
> +       dev_set_drvdata(&mhi_dev->dev, mhiwwan);
> +
> +       /* Register as a wwan port, id->driver_data contains wwan port type */
> +       port = wwan_create_port(&cntrl->mhi_dev->dev, id->driver_data,
> +                               &wwan_pops, mhiwwan);
> +       if (IS_ERR(mhiwwan->wwan_port)) {

Should obviously be IS_ERR(port)... but waiting for comments on the
series before resubmitting.


> +               kfree(mhiwwan);
> +               return PTR_ERR(port);
> +       }
> +
> +       mhiwwan->wwan_port = port;
> +
> +       return 0;
> +};
