Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57EAD4D5093
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 18:33:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245014AbiCJRbp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 12:31:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236035AbiCJRbo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 12:31:44 -0500
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DDBCF32B6;
        Thu, 10 Mar 2022 09:30:43 -0800 (PST)
Received: by mail-vs1-xe36.google.com with SMTP id v62so6796686vsv.1;
        Thu, 10 Mar 2022 09:30:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kKv9p8ykc5d2ocj7ReSJuSuri2exBdglIdzEyvs2e3Y=;
        b=CwHCW2iavwpF6S7Yi6aHLObRzx1aWxE/oHa540V+jFaR+IFHdSvAoPtyQm6IclPdxC
         4fUJEue4mLHmhgpJG4wRn2MkXJoC2SOs0Hd/4dZmkylkQHl+heHUWkez3pDaCKAmR/kc
         R66WBeP4+c5Gi5JhHkOhlRBkLtpso5L6+Ce41UjJLGqcXBokvof2MZ/beLwWwkS/O8Om
         YXdg1zEM5htXzRbm8eyImJowLMGHVtr3gFGG0MnVsQsYk3qemfTUkf8ieJcQF/tCNGAm
         EFJJpXwBilvent1vIwOCTq00kcV0wEpPqZfsBS4dArWvUfXBmBbZtpsAlx5ARf3RBCWO
         2N1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kKv9p8ykc5d2ocj7ReSJuSuri2exBdglIdzEyvs2e3Y=;
        b=XJ/6w46yMF4lorFdekVrNfBmCRZhp0ytsIgx0DxuuQu5zqOMYI1998vH8DcLrziR6/
         HmD14rkA3SZKEzVmBe9tj+pVBb7N2J14IeOaQuPqbZZpqWZORlgQrEdP6yHlxyh4l1xK
         o1tuZMaepRvXEXlkarfBhidaVmDE9KKrcvRNqpNP/fxhQXZN0EFvYUoloCucoCVOqiqC
         HcPHhPiTfDIO3pYDH78nQUNBckOHjHVCLVo+yBsmII9/ydLNNWrYvLPFokf0Z8m4Gnpn
         dhmTG1hQrrWbae+us7bjtk82jkZrMZzPolO2jMwyeHzBKbTKkqGpDXT+Vpl72Szg5D1t
         7GFw==
X-Gm-Message-State: AOAM533l0tiTufUYzQiDlVxWJbCQvW4Xln0W/EP0hYdnumcnyXBLf8pV
        UZHqDoxfNrVGJG8+gOx78F+TSAT3NrEAGmgVBMpcY2kuxU4d3A==
X-Google-Smtp-Source: ABdhPJyOj4XzeA0yQQrkN8F+JpFhq9HzMs/delrS0VDyUvCBjUeaqSw6SIhIJwbZwO4UUsG8c3k46wAEQv+/0hckrOk=
X-Received: by 2002:a67:ee94:0:b0:320:c162:2bea with SMTP id
 n20-20020a67ee94000000b00320c1622beamr3487575vsp.34.1646933442525; Thu, 10
 Mar 2022 09:30:42 -0800 (PST)
MIME-Version: 1.0
References: <20220310045535.224450-1-jeremy.linton@arm.com>
In-Reply-To: <20220310045535.224450-1-jeremy.linton@arm.com>
From:   Peter Robinson <pbrobinson@gmail.com>
Date:   Thu, 10 Mar 2022 17:30:31 +0000
Message-ID: <CALeDE9OjSAV0Mas7NPJfFQ5SW6ZJV8HgyvZyVnE_LZK2tkPOmQ@mail.gmail.com>
Subject: Re: [PATCH] net: bcmgenet: Don't claim WOL when its not available
To:     Jeremy Linton <jeremy.linton@arm.com>
Cc:     netdev@vger.kernel.org, opendmb@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org,
        bcm-kernel-feedback-list@broadcom.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 10, 2022 at 4:55 AM Jeremy Linton <jeremy.linton@arm.com> wrote:
>
> Some of the bcmgenet platforms don't correctly support WOL, yet
> ethtool returns:
>
> "Supports Wake-on: gsf"
>
> which is false.
>
> Ideally if there isn't a wol_irq, or there is something else that
> keeps the device from being able to wakeup it should display:
>
> "Supports Wake-on: d"
>
> This patch checks whether the device can wakup, before using the
> hard-coded supported flags. This corrects the ethtool reporting, as
> well as the WOL configuration because ethtool verifies that the mode
> is supported before attempting it.
>
> Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
Tested-by: Peter Robinson <pbrobinson@gmail.com>

This fixes the reporting of the WOL capabilities on the Raspberry Pi 4.

> ---
>  drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
> index e31a5a397f11..f55d9d9c01a8 100644
> --- a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
> +++ b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
> @@ -40,6 +40,13 @@
>  void bcmgenet_get_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
>  {
>         struct bcmgenet_priv *priv = netdev_priv(dev);
> +       struct device *kdev = &priv->pdev->dev;
> +
> +       if (!device_can_wakeup(kdev)) {
> +               wol->supported = 0;
> +               wol->wolopts = 0;
> +               return;
> +       }
>
>         wol->supported = WAKE_MAGIC | WAKE_MAGICSECURE | WAKE_FILTER;
>         wol->wolopts = priv->wolopts;
> --
> 2.35.1
>
