Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29B16468A75
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 12:16:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233159AbhLELTy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 06:19:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233086AbhLELTy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Dec 2021 06:19:54 -0500
Received: from mail-ua1-x934.google.com (mail-ua1-x934.google.com [IPv6:2607:f8b0:4864:20::934])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7880C061714
        for <netdev@vger.kernel.org>; Sun,  5 Dec 2021 03:16:26 -0800 (PST)
Received: by mail-ua1-x934.google.com with SMTP id p37so14137709uae.8
        for <netdev@vger.kernel.org>; Sun, 05 Dec 2021 03:16:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vTVzab+mnJ1NqAkoAj8gfjEEvaFmokoFBqRGGKD4ywM=;
        b=KxmxzaCalREomfhk/+zeFJV1qPOX9HQYlmCv4hhFPCS++0MSfUUiykohwbLxCiRdiW
         aYBo2x0S4hLSo5/EUdICH4YnN9esd9jlhUlB5gSsSZrep5gcv+PbcpSTF5pRsa7hPI9m
         qdlvnwTkEBPfst9q8DtdB/5KdZKZeiT7Mi10U7J5gJ69m5SnHGZrCaLU6r+V3xWtgc0z
         zRcctd9YOvf1TDQdZwnIU/tLrx82RQaettgmhghw2pmSvHoJpgbhHsD9ONqgnyqgXjTr
         +lsjXUiqBaf9LPW4l1iWLzFs+umfv62lfNf1seOvpq/7DPnir7ppHsyCwY0o6WagEpV7
         UeRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vTVzab+mnJ1NqAkoAj8gfjEEvaFmokoFBqRGGKD4ywM=;
        b=Q2haStLjB46+QxZMhh7l2GyjbuKaoadJdxrHcD46eIuvm77raJtV7UjGKxga8lcgb/
         I99oD7nYM/dxpJGb1QTMLKr7kKQtPakqjXfH3jSluwuzofA+7fdNkXsL+5LoLkWrQJOq
         3bsfQfpswQNg69Q1X6tjxNxL0DrJ3PIv/B+CjyVP5sm9ABNOvuoZ0ODq3mRNHxfw4xo7
         h37kg4TNPEQiZseh+zv/p/b8XPqwFaLUDAoyc5Kq3T3ULxMk1TEhRABEn7oRQezM4CoQ
         gx2YNISyZCnWYhYLVnmEPKRROp+Qs/tkR3BNnzmGd1fHaVnT1trJDCjh7VRoNcSIxoyw
         WAEg==
X-Gm-Message-State: AOAM531OJ/nzV+c8dcBkdiDK3+aEBH033hhqvFuQ2tjN/gvaYTiYEM9F
        ucE398DhpAs2zQKKZtJS5YuSuU5+ekCMRYBG8i26Aa4TAjPseQ==
X-Google-Smtp-Source: ABdhPJwSF3MdlkkF5LXu6OQvbapPDWOQ6TmvxVm9YSz5GNL//ZSsd2c7/cUMFrhdKMUPQZ/mdiXQSbap6OXFhgJasvQ=
X-Received: by 2002:ab0:614c:: with SMTP id w12mr32924024uan.45.1638702986102;
 Sun, 05 Dec 2021 03:16:26 -0800 (PST)
MIME-Version: 1.0
References: <20211205065528.1613881-1-m.chetan.kumar@linux.intel.com> <20211205065528.1613881-3-m.chetan.kumar@linux.intel.com>
In-Reply-To: <20211205065528.1613881-3-m.chetan.kumar@linux.intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Sun, 5 Dec 2021 14:16:14 +0300
Message-ID: <CAHNKnsQTLENdyrOA7wXWUCMBD2pYY-Vn9DocqcvtNFsmhZZjcw@mail.gmail.com>
Subject: Re: [PATCH net-next 2/7] net: wwan: iosm: set tx queue len
To:     M Chetan Kumar <m.chetan.kumar@linux.intel.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        krishna.c.sudi@intel.com,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello M Chetan Kumar,

On Sun, Dec 5, 2021 at 9:47 AM M Chetan Kumar
<m.chetan.kumar@linux.intel.com> wrote:
> Set wwan net dev tx queue len to 1000.
>
> Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
> ---
>  drivers/net/wwan/iosm/iosm_ipc_wwan.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wwan/iosm/iosm_ipc_wwan.c b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
> index b571d9cedba4..e3fb926d2248 100644
> --- a/drivers/net/wwan/iosm/iosm_ipc_wwan.c
> +++ b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
> @@ -18,6 +18,7 @@
>  #define IOSM_IP_TYPE_IPV6 0x60
>
>  #define IOSM_IF_ID_PAYLOAD 2
> +#define IOSM_QDISC_QUEUE_LEN 1000

Is this 1000 something special for the IOSM driver? If you need just
an approximate value for the queue length, then consider using the
common DEFAULT_TX_QUEUE_LEN macro, please.

>  /**
>   * struct iosm_netdev_priv - netdev WWAN driver specific private data
> @@ -159,7 +160,7 @@ static void ipc_wwan_setup(struct net_device *iosm_dev)
>  {
>         iosm_dev->header_ops = NULL;
>         iosm_dev->hard_header_len = 0;
> -       iosm_dev->priv_flags |= IFF_NO_QUEUE;
> +       iosm_dev->tx_queue_len = IOSM_QDISC_QUEUE_LEN;
>
>         iosm_dev->type = ARPHRD_NONE;
>         iosm_dev->mtu = ETH_DATA_LEN;

-- 
Sergey
