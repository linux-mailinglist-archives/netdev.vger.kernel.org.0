Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC9C60DC80
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 09:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233349AbiJZHva (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 03:51:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233358AbiJZHvZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 03:51:25 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 668E9753BA
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 00:51:22 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id j15so14421766wrq.3
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 00:51:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bJlF3tCG/wZxfdmf6SsZBHKBsQhIMrnOBLhbvVajAzQ=;
        b=g6J1B0IXFXFrkkf5tBJrRM6YbOxziAOMjTYfcmakcbBQKGxe+IY/BAqM1f2Tx6qz3+
         wJ0HO9VUdVMwi+3JsVax681xQmTidsb7E/PzKK4S90Gfv08nxsPGwXKkxUd/ZGwXQlUr
         B+U+2P7NIj28rTz8q31J6zN7r/x5Q7lfNLJsbK01tY8f1/aFZ/PdI2GvIHRtVBJd3WyL
         rmoaUydIirszyuPwPRyy7l9TiWVnvlezQ02M7dvKO0MhXSxUB99GUkUXHqRVr2STEcVw
         NpXSYxBRFTnUGN4BVjaXaEEVuePxTAfyi75YYjo5LftE6C3BEZ41uKPTy5UeR0lgy2e9
         1+0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bJlF3tCG/wZxfdmf6SsZBHKBsQhIMrnOBLhbvVajAzQ=;
        b=Y8zRNnJVJC+w4KxcQ0rZXrfVyzSLKhfGCNvUKClHrrCiZY2C92nCllDenMn7FqOG7G
         mn2i04ILfGjyjRDHbSc+YMwaP0p5HHoy7n7/k54Q+lNY3cLkPOhLH8OHQlxa3CcGkC4c
         Ac2D/alcpq2ZZq4lOBYgRIpvkHOkvKEaKx1/dDMoNYUQiXBDf6oGFQMGDhgydXYfrCTA
         xGUAoqsDzOAd8g/FW/DnJsK0UpC01e2BWC6254mzlxSW5noCYgMWbPH3IcJ5Ao0XNNSB
         W2FzwpNhdNcKWyu6mfLMHr9Mu+1kY7otZ4WvvKn47g58eLeoKjA0CO1ELdElt2xJTFL9
         oi5g==
X-Gm-Message-State: ACrzQf38+icQWYRiSiqcG8URXNrL4gEj54YK4oBB+4i5luUJwEUAY5iI
        hwx0DzsRiR03cqfFXhJfmQ3W0lxlZPAWCXlzqSppNA==
X-Google-Smtp-Source: AMsMyM5BijXAGUfA6IW8XHWvQvpR8GY5/DhxGpgMLozZpcTUF96lK1Z7arSkMRJ6Y0RRd6cfJh+dq7df0GQb31M/Nt4=
X-Received: by 2002:a05:6000:885:b0:236:547e:438e with SMTP id
 ca5-20020a056000088500b00236547e438emr17388165wrb.183.1666770680801; Wed, 26
 Oct 2022 00:51:20 -0700 (PDT)
MIME-Version: 1.0
References: <20221026020200.29222-1-zhaoping.shu@mediatek.com>
In-Reply-To: <20221026020200.29222-1-zhaoping.shu@mediatek.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Wed, 26 Oct 2022 09:50:44 +0200
Message-ID: <CAMZdPi-bAw293XWBQL0wZS-nO_COD=ZOBduBVicof87HyEmS3w@mail.gmail.com>
Subject: Re: [PATCH net v1] net: wwan: iosm: fix memory leak in ipc_wwan_dellink
To:     "zhaoping.shu" <zhaoping.shu@mediatek.com>
Cc:     m.chetan.kumar@intel.com, linuxwwan@intel.com,
        ryazanov.s.a@gmail.com, johannes@sipsolutions.net,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, srv_heupstream@mediatek.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        haijun.liu@mediatek.com, xiayu.zhang@mediatek.com,
        lambert.wang@mediatek.com, "hw . he" <hw.he@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Zhaoping,

On Wed, 26 Oct 2022 at 04:02, zhaoping.shu <zhaoping.shu@mediatek.com> wrote:
>
> From: hw.he <hw.he@mediatek.com>
>
> IOSM driver registers network device without setting the
> needs_free_netdev flag, and does NOT call free_netdev() when
> unregisters network device, which causes a memory leak.
>
> This patch sets needs_free_netdev to true when registers
> network device, which makes netdev subsystem call free_netdev()
> automatically after unregister_netdevice().
>
> Signed-off-by: hw.he <hw.he@mediatek.com>
> Signed-off-by: zhaoping.shu <zhaoping.shu@mediatek.com>

Could you please add a corresponding 'fixes' tag.

> ---
>  drivers/net/wwan/iosm/iosm_ipc_wwan.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/wwan/iosm/iosm_ipc_wwan.c b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
> index 2f1f8b5d5b59..0108d8d01ff2 100644
> --- a/drivers/net/wwan/iosm/iosm_ipc_wwan.c
> +++ b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
> @@ -168,6 +168,7 @@ static void ipc_wwan_setup(struct net_device *iosm_dev)
>         iosm_dev->max_mtu = ETH_MAX_MTU;
>
>         iosm_dev->flags = IFF_POINTOPOINT | IFF_NOARP;
> +       iosm_dev->needs_free_netdev = true;

Look like we have the same problem in mhi_wwan_mbim driver, would you
be able to submit a change for it as well?
