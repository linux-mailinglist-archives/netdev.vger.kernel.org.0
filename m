Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2574FFE0D
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 20:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237788AbiDMSnL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 14:43:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237789AbiDMSmd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 14:42:33 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E935223BDF;
        Wed, 13 Apr 2022 11:40:09 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id u19so5138278lff.4;
        Wed, 13 Apr 2022 11:40:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MDR0Fg5QWdm585RNYBMjB04jwb3sFn/V9jLMN5lDMUg=;
        b=qrBrDzqcreAYaA733LjFmIOK2n07pxS+7vJhMVpAV9lIvaHwH1/RSpbglSH7Rs+nhZ
         hsySkF0Jdh19E697WXVher4+6h1ri0/kHlH+qAWio6s0wmRuJXZPaTDuIHsdQwqPgwEI
         P5EaKCmSyp1lOhGFRsu3WUU4IcXObg9bGQRK31GJMj7Es9/RX0T3Zk64VC2yPdA8qdlR
         /u9PdpOGPWyXR59OUo9591/KdaKdq05N1kdDphnR+kED47LbNsnSZgwFqfcJnoW3uN12
         CUYVaf5TdZGJqOcSauYebjYfCj8EUSIrpCSEmNRVZqWIorQKnhjjwItyKF0ga8mWSAMS
         rXYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MDR0Fg5QWdm585RNYBMjB04jwb3sFn/V9jLMN5lDMUg=;
        b=We6A2OHgDQpdNBt62LyvQjbviEhEP4qdkroepkQjPqvxHp+ta5SM8pZQFkufEwuJM5
         JNb2u8+TL7TKhbQO5om1Wt5NuiYlSMkaoJQoSoOEuTGHRm4UYlJPYldI2+J0YE0eW1WM
         WllqNI3yGRXwcipZKmUnkt/YriCyx8xyprhqB/iTqxG/cUDdospnvayn0V58WhJdlZyA
         8yN1/jLFxdM/+dky79qdmDb0yvlvr2Axu62ku7bqEgWUBvY/Tt3kaEFyz8TakDjzKgHC
         0ZshPbQwWxtQtwZvl3qTho9VvCAyrpxzEOShG0VCKz/B/90DBpcZaBGz/qYBjRmH31g8
         olcQ==
X-Gm-Message-State: AOAM530zg/SyOf0S1ukbY0svwHw8mBXpiKifRsdOxopP7j+OpNGngpWQ
        72KunqN6h6m0zsgFmxwpdvd63uQBXA209NPix9Q=
X-Google-Smtp-Source: ABdhPJzeDf8ZH88L1WhbR/Mu5T8Lqhxe2UylQed//0u6hSOwi+wreW2FAIestF0SpDXLY2GNqmfovwCNVNTp3HN5FU8=
X-Received: by 2002:ac2:41c4:0:b0:445:9a7c:b76f with SMTP id
 d4-20020ac241c4000000b004459a7cb76fmr28407987lfi.497.1649875208069; Wed, 13
 Apr 2022 11:40:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220409062449.3752252-1-zheyuma97@gmail.com>
In-Reply-To: <20220409062449.3752252-1-zheyuma97@gmail.com>
From:   Stanislav Yakovlev <stas.yakovlev@gmail.com>
Date:   Wed, 13 Apr 2022 14:39:54 -0400
Message-ID: <CA++WF2Np7Bk_qT68Uc3mrC38mN5p3fm9eVT7VA8NoX6=es2r2w@mail.gmail.com>
Subject: Re: [PATCH] wireless: ipw2x00: Refine the error handling of ipw2100_pci_init_one()
To:     Zheyu Ma <zheyuma97@gmail.com>
Cc:     kvalo@kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, pabeni@redhat.com,
        wireless <linux-wireless@vger.kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Sat, 9 Apr 2022 at 02:25, Zheyu Ma <zheyuma97@gmail.com> wrote:
>
> The driver should release resources in reverse order, i.e., the
> resources requested first should be released last, and the driver
> should adjust the order of error handling code by this rule.
>
> Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
> ---
>  drivers/net/wireless/intel/ipw2x00/ipw2100.c | 34 +++++++++-----------
>  1 file changed, 16 insertions(+), 18 deletions(-)
>
[Skipped]

> @@ -6306,9 +6303,13 @@ static int ipw2100_pci_init_one(struct pci_dev *pci_dev,
>  out:
>         return err;
>
> -      fail_unlock:
> +fail_unlock:
>         mutex_unlock(&priv->action_mutex);
> -      fail:
> +fail:
> +       pci_release_regions(pci_dev);
> +fail_disable:
> +       pci_disable_device(pci_dev);
We can't move these functions before the following block.

> +fail_dev:
>         if (dev) {
>                 if (registered >= 2)
>                         unregister_netdev(dev);
This block continues with a function call to ipw2100_hw_stop_adapter
which assumes that device is still accessible via pci bus.

> @@ -6334,11 +6335,8 @@ static int ipw2100_pci_init_one(struct pci_dev *pci_dev,
>
>                 free_libipw(dev, 0);
>         }
> -
> +fail_iounmap:
>         pci_iounmap(pci_dev, ioaddr);
> -
> -       pci_release_regions(pci_dev);
> -       pci_disable_device(pci_dev);
>         goto out;
>  }
>
> --
> 2.25.1
>

Stanislav.
