Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 504945BCCFA
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 15:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbiISNW0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 09:22:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbiISNWW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 09:22:22 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 764B3247
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 06:22:21 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id q9so17633593pgq.8
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 06:22:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=XBEHv8ghKU0ZkmO5aCePvI4i1EV0Le+oBtd2vt+taKo=;
        b=vBLtC+xCcV3zfXN2PeQHL6+pSEHW7C9jVtTYHon/W+wS7M/1zwQlZyiKlB2wyB4AV/
         BM+sH2Kbisj+Hlx+yuhsB9a0GcwKjTm1u8cyEwMYBoCzJhGoRKniGeXx4PzB9NTCOlkk
         ssSM4AwZn5iuSTBW7NplxwMyhxn69mBU2ZpBvrcZz5PBweV0qzIgt3SRloqgDClQ8C08
         +P/Itd4sjzjoKvBJ/ep4uKoeYgFF1sy7zKdwfXb8AbGD52YDWHY0Of13br7vlpnI8bFt
         9ZuqYlTtrVO1KJ3Qql+Q3GFnbGB6cWkB5/v0Q8Ps9JahGaXL089DgmB2AzCK117msMi4
         TMKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=XBEHv8ghKU0ZkmO5aCePvI4i1EV0Le+oBtd2vt+taKo=;
        b=dkY1AZKkjsC6VPJSw+YG7j+y+qgndiaDodQk96Fb94lyZl/U1c58cinPhmw67qhO9U
         wLp3idIElaubjp0U3MjHcrjGji7V1TTdLrTjlPwqj8NaASMN6P2evaFHO1D8hwnPF5ek
         R0hMi0VuS4TGVX9ondiHdmAJ1ICncgjFi1c+1FybRTqGUOz8W7vhFw5Xki1PDnJ4gL0E
         4SyIcoeHyEHfPhXWrAulC8imCp/RKr9LyjiDkQ4gfxfDv8JhwD9OXC3bIGYm05bekjds
         RERNA9KlX/Jl7rCA3xYTjDZNhx+NdWxdNpveOi0FIeJc49Wmjso+huRXybVQlfyVzf4h
         QF/w==
X-Gm-Message-State: ACrzQf06y430e9aX8Pd/+A1yzpPm3uM8hY/LVsJtXAqOGW6liWMGHidA
        APqw2Rm+6t8P5Npb4a2hddXUhvwbbT4Ds1eOMrxPlA==
X-Google-Smtp-Source: AMsMyM7VRhI9YdnRfz62PSK+fwQI96gHMYVt7kSw4Jq7YAX+9r8gA7/qgJwaA0Oh8DMDBFaKZlmma0A4PRjaKOz8uhU=
X-Received: by 2002:a63:e07:0:b0:429:8604:d9ad with SMTP id
 d7-20020a630e07000000b004298604d9admr15417800pgl.586.1663593740890; Mon, 19
 Sep 2022 06:22:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220916144329.243368-1-fabio.porcedda@gmail.com> <20220916144329.243368-2-fabio.porcedda@gmail.com>
In-Reply-To: <20220916144329.243368-2-fabio.porcedda@gmail.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Mon, 19 Sep 2022 15:21:44 +0200
Message-ID: <CAMZdPi-hHph8Kuyq5Y-yAMt7BNHpLODnrEuC_zo2s64QCqrbGA@mail.gmail.com>
Subject: Re: [PATCH 1/2] net: wwan: mhi_wwan_ctrl: Add DUN2 to have a
 secondary AT port
To:     Fabio Porcedda <fabio.porcedda@gmail.com>
Cc:     mhi@lists.linux.dev, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, mani@kernel.org, ryazanov.s.a@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, dnlplm@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 16 Sept 2022 at 16:43, Fabio Porcedda <fabio.porcedda@gmail.com> wrote:
>
> In order to have a secondary AT port add "DUN2".
>
> Signed-off-by: Fabio Porcedda <fabio.porcedda@gmail.com>

Reviewed-by: Loic Poulain <loic.poulain@linaro.org>

> ---
>  drivers/net/wwan/mhi_wwan_ctrl.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/wwan/mhi_wwan_ctrl.c b/drivers/net/wwan/mhi_wwan_ctrl.c
> index e4d0f696687f..f7ca52353f40 100644
> --- a/drivers/net/wwan/mhi_wwan_ctrl.c
> +++ b/drivers/net/wwan/mhi_wwan_ctrl.c
> @@ -258,6 +258,7 @@ static void mhi_wwan_ctrl_remove(struct mhi_device *mhi_dev)
>
>  static const struct mhi_device_id mhi_wwan_ctrl_match_table[] = {
>         { .chan = "DUN", .driver_data = WWAN_PORT_AT },
> +       { .chan = "DUN2", .driver_data = WWAN_PORT_AT },
>         { .chan = "MBIM", .driver_data = WWAN_PORT_MBIM },
>         { .chan = "QMI", .driver_data = WWAN_PORT_QMI },
>         { .chan = "DIAG", .driver_data = WWAN_PORT_QCDM },
> --
> 2.37.3
>
