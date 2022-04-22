Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A04E350BC36
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 17:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234345AbiDVP63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 11:58:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234340AbiDVP62 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 11:58:28 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9BA15DA3C
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 08:55:34 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id i27so17190578ejd.9
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 08:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1XObRTGFx3W5KvM54MXqeosL66iBkhIfe3YSCSzX+jg=;
        b=WhHn7XzDUqQJhC0u5OE24YdCQ5b1TYm2ROQlL/D5N7DTBpbmzzhL5MjM2/VA6rO6o+
         +8SlNTE4r/yE45yPuGbWUOk0BzwJIKamqiQe4ba4NY22aydGqNPSKvl9QzkZrHRMfF0L
         oXLIRbPC12JzzMZPtGins69ORiKWTCpEnY6OI1FBuLeVvsvbASOhGRlwdfbbYoj2tZvd
         /rMa5hZYyKBupk/49XkNqzH55gjGOe/8jUNvSkjfcDc84o2WWESxx0WYvOwwT7HQ6d7u
         So5eRyHRU6dwKAOu+0IW7c+ZUmEBrc9m3cRPPO+EQt2sAzmx7PvCVCviVlhDCxSxjvV1
         EjUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1XObRTGFx3W5KvM54MXqeosL66iBkhIfe3YSCSzX+jg=;
        b=YYcSlCZ2LkAdf82mgb/wMSKV8Uxsdrs8LBN9Bu+qLV3oV+a+HFMdkMfq6a/4ih4pqo
         kaPWsoJtXUlWjPQ4oKBPKOpSXW53FHGuVGHO8fqq2dHI+jzYt3MgzbmBpaMHyuqlNAUX
         kXRQi3yUFJ8NEbqdIeiK5zHH6aEXqOwxoWkjD3VjD9UBfo8thY//y7eYavCbSfd1emQL
         JF7ClIi+gqk/dNWbD4xb7WRLDd/14XfYAVA/TukJJev513opq1yYhymf2EfaeTfU398J
         lkZBwEhVcwxsOaRnxhmYjrVG8J3QikXQ6a0LQelas3OpSLWu95vmb74teq0f4SB6GAcV
         FpjQ==
X-Gm-Message-State: AOAM532Nxtdp/dRSlKUDGOY+XQObTg4kk2hSBm/JU9zXfp/Uy0kFEdwi
        p4mzZBCb69f7llrVnxBoQg67uN8XEidxaUd5CKg=
X-Google-Smtp-Source: ABdhPJzZFxKnt/dJhw4I86lg4kjxNshGGi36qgywDYB21rQrg8RGjdhcI8GoVG3Kz2zfeESNWdnlU/pSfZeBxCOAM6o=
X-Received: by 2002:a17:906:c147:b0:6df:f047:1677 with SMTP id
 dp7-20020a170906c14700b006dff0471677mr4765323ejc.4.1650642933330; Fri, 22 Apr
 2022 08:55:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220422152612.GA510015@francesco-nb.int.toradex.com>
In-Reply-To: <20220422152612.GA510015@francesco-nb.int.toradex.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Fri, 22 Apr 2022 12:55:22 -0300
Message-ID: <CAOMZO5B6nBH_fFGsg+EKZGTOqqTjztvpGNNCJ0wpbcTq+2vPDA@mail.gmail.com>
Subject: Re: FEC MDIO read timeout on linkup
To:     Francesco Dolcini <francesco.dolcini@toradex.com>
Cc:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        netdev <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Tim Harvey <tharvey@gateworks.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Francesco,

On Fri, Apr 22, 2022 at 12:26 PM Francesco Dolcini
<francesco.dolcini@toradex.com> wrote:
>
> Hello all,
> I have been recently trying to debug an issue with FEC driver erroring
> a MDIO read timeout during linkup [0]. At the beginning I was working
> with an old 5.4 kernel, but today I tried with the current master
> (5.18.0-rc3-00080-gd569e86915b7) and the issue is just there.
>
> I'm also aware of the old discussions on the topic and I tried to
> increase the timeout without success (even if I'm not sure is relevant
> with the newer polling solution).
>
> The issue was reproduced on an apalis-imx6 that has a KSZ9131
> ethernet connected to the FEC MAC.
>
> No load on the machine, 4 cores just idling during my test.
>
> What I can see from the code is that the timeout is coming from
> net/phy/micrel.c:kszphy_handle_interrupt().

For debugging purposes, could you try not to describe the Ethernet PHY
irq pin inside imx6qdl-apalis.dtsi?

Looking at its pinctrl, I don't see it has pull-up enabled. Is there
an external pull-up
on the KSZ9131 pin?
