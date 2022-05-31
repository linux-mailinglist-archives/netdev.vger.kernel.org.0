Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13190538D77
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 11:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243414AbiEaJIE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 05:08:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234760AbiEaJIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 05:08:02 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA88954FBE
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 02:07:59 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id c15-20020a9d684f000000b0060b097c71ecso9154133oto.10
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 02:07:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RWsthZPxNDA39U3KIC6LMsBvLuzLbrfSrlsINFHYDcI=;
        b=GIYO75yR6RxABAavORON5hxUzN4kdiuq7iHSEQU+CYmSKkkfZ8vjYY7xX1gDRJoG5K
         WA75V3DNHdz/zDQXyHEiAH5srFHNeIsH2HYfdJMpQ9w1XsbSWECD8ZOulAam5RJpg6fY
         NhnvWk26PwIEleos7OZzKK8rR2pvXqVteUll6hvklGGoXj/S6IspbIDwpd+Ift+Vybjb
         wEeXzYj5OjZ94nZYdMK7gyTFAIti2MtbG/oejv+cr+8XhQ/mazoM4Ro7zRM68pWVz+zM
         YKZuF6uX6UrEUrH0DkPcfa89zq0xmnpzrmr6a9G0wxvHQdCMY77aNgspIxpSuNWyDxRN
         sSTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RWsthZPxNDA39U3KIC6LMsBvLuzLbrfSrlsINFHYDcI=;
        b=ITrTkxiDAgN0EGAeNf07x8AE+UXUXzUjY4U/9rX/bfMBQNmpkYV3jKbQaQKSnbIRUT
         zF7FN/BigCba19n+rmQudjtMu0RXmyG8dqSt4aLh4rqF9aGCizCbtL6rLrEwPm+uWpXD
         iB8GthUZ/oepAn3wU+gRJ1tkV7VFmCpjfeV6ZadVVjYPlw7x5rfY0zaYR1Gxcv7wPLAR
         OG1d517SVZX47OArlnLgV+CMHEaZQ7xA7IuXSWR68iDwsQjJVcUivaqxDl4zVld/WJHM
         Q8ZeidpQe5raSD/nMB5y2pj7Q+tvK2BFIIzJFDOXNm39MaUaZqTCfpn0+KM1czvaJNTY
         rSuA==
X-Gm-Message-State: AOAM530CBuq/0A2i2lkYFBgzOn55R9iLB/ug69j9KkD8UgitOgguA2n5
        SwaCGcUf3rcF+y4Bp0q3NKAb+YCO0BMVQJmfFl2tpQ==
X-Google-Smtp-Source: ABdhPJxVvTrJGlPKkgE3ckW+2BAEYRKazdCH8wFipcEpTVtbBTK4iTzPHd32UxIZGi3IQCROhrDqUirCGPDwLhTbJs0=
X-Received: by 2002:a9d:6f1a:0:b0:60b:20fd:ca75 with SMTP id
 n26-20020a9d6f1a000000b0060b20fdca75mr13961134otq.126.1653988078875; Tue, 31
 May 2022 02:07:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220517094532.2729049-1-poprdi@google.com>
In-Reply-To: <20220517094532.2729049-1-poprdi@google.com>
From:   =?UTF-8?Q?Tam=C3=A1s_Koczka?= <poprdi@google.com>
Date:   Tue, 31 May 2022 11:07:47 +0200
Message-ID: <CAPUC6bKo6EdacUVAWaJp+_Z_sEztnv96Li6zLpm-UR=2rZth-w@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: Collect kcov coverage from hci_rx_work
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Andy Nguyen <theflow@google.com>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Aleksandr Nogikh <nogikh@google.com>,
        Dmitry Vyukov <dvyukov@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Everyone,

Thank you for reviewing the patch - I hope everything is going well.

Please feel free to ask me if you need any more information regarding it!

Thank you,
Tamas

On Tue, May 17, 2022 at 11:45 AM Tamas Koczka <poprdi@google.com> wrote:
>
> Annotate hci_rx_work() with kcov_remote_start() and kcov_remote_stop()
> calls, so remote KCOV coverage is collected while processing the rx_q
> queue which is the main incoming Bluetooth packet queue.
>
> Coverage is associated with the thread which created the packet skb.
>
> Signed-off-by: Tamas Koczka <poprdi@google.com>
> ---
>  net/bluetooth/hci_core.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> index 45c2dd2e1590..703722031b8d 100644
> --- a/net/bluetooth/hci_core.c
> +++ b/net/bluetooth/hci_core.c
> @@ -29,6 +29,7 @@
>  #include <linux/rfkill.h>
>  #include <linux/debugfs.h>
>  #include <linux/crypto.h>
> +#include <linux/kcov.h>
>  #include <linux/property.h>
>  #include <linux/suspend.h>
>  #include <linux/wait.h>
> @@ -3780,7 +3781,9 @@ static void hci_rx_work(struct work_struct *work)
>
>         BT_DBG("%s", hdev->name);
>
> -       while ((skb = skb_dequeue(&hdev->rx_q))) {
> +       for (; (skb = skb_dequeue(&hdev->rx_q)); kcov_remote_stop()) {
> +               kcov_remote_start_common(skb_get_kcov_handle(skb));
> +
>                 /* Send copy to monitor */
>                 hci_send_to_monitor(hdev, skb);
>
> --
> 2.36.0.550.gb090851708-goog
>
