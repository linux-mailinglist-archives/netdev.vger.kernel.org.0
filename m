Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F662666222
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 18:39:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232411AbjAKRjJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 12:39:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239541AbjAKRif (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 12:38:35 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67EE96573
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 09:38:23 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id w1so15828207wrt.8
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 09:38:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=adxRRdSFK1oDlMN9+g7iUQ5+erm/E8wEY+S20rDclo4=;
        b=Ojf5IsMySBRC3WslOJd5ShwoEwGV/CwyCCfuTfqgHG8lqDUX6n3KjUUrgRyOT3Cf+F
         cKAfjWRaoJYKzztz/ygdvBDk/4UjMAxaMtTANKiIa1/Fve8ygM+ntOxARHXYavSKnbXF
         vjrQzsxeVrfpg0eAUwY+fGZPeqBlHQQRWQ5xs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=adxRRdSFK1oDlMN9+g7iUQ5+erm/E8wEY+S20rDclo4=;
        b=fhi+XkOuD6AxVuL+Zo3tRv+RwVEd7iw2KWKTSEYn88WbKQbofjzE9g3JdNJPEmYZ9S
         jg808z+E/W0ZrI/I9I2Rs6T96s9FElOyE42o2u08Hm0Uv47/FsL/EDN794WsNmgIWQwx
         DHM/Hcc21aY6KY0LikJijt7RtxP1mNTip88Q5bJMamBChvYv7mqeLn8UK73r6SalpQbS
         Ut0xCFiBt1bU08dTfB2bQXyC0Hpm+CdM9Gg3TABMvKJhDN0yxPov9qFYCgYOnERn5sh/
         DB8TlV1tPlFfdzF6KKKQJvt3nirnTQKDukWE4JiCUkLxQS5CHWg9CLXZE4GRitH0JkSF
         NAYQ==
X-Gm-Message-State: AFqh2kqEktaSyt7tPV45pb11VtGktEK7f6h0W5Ey+NkOx6HAy5kyIcs3
        3udeKJRQrhbZ30LKgGHvuYEHN1QPdH4hrPouoPZJSQ==
X-Google-Smtp-Source: AMrXdXuOeVpQDCUqLxUrp+tlSIuydrCS7sCQd2/buXk57/+gGcw6IRQYS++14/3YaUgHqkm7eIbIrY6HrLLLrkqxxyQ=
X-Received: by 2002:a05:6000:705:b0:273:7d1b:7334 with SMTP id
 bs5-20020a056000070500b002737d1b7334mr1538554wrb.340.1673458702047; Wed, 11
 Jan 2023 09:38:22 -0800 (PST)
MIME-Version: 1.0
References: <20230111125855.19020-1-lukas.bulwahn@gmail.com>
In-Reply-To: <20230111125855.19020-1-lukas.bulwahn@gmail.com>
From:   Dimitris Michailidis <d.michailidis@fungible.com>
Date:   Wed, 11 Jan 2023 09:38:08 -0800
Message-ID: <CAOkoqZniMk+hcemy9JhTxerd_9ypbXd=SDBE1yGLoCDYB2RNWg@mail.gmail.com>
Subject: Re: [PATCH] net: remove redundant config PCI dependency for some
 network driver configs
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     Dimitris Michailidis <dmichail@fungible.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Simon Horman <simon.horman@corigine.com>,
        oss-drivers@corigine.com, "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 11, 2023 at 4:59 AM Lukas Bulwahn <lukas.bulwahn@gmail.com> wrote:
>
> While reviewing dependencies in some Kconfig files, I noticed the redundant
> dependency "depends on PCI && PCI_MSI". The config PCI_MSI has always,
> since its introduction, been dependent on the config PCI. So, it is
> sufficient to just depend on PCI_MSI, and know that the dependency on PCI
> is implicitly implied.
>
> Reduce the dependencies of some network driver configs.
> No functional change and effective change of Kconfig dependendencies.
>
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> ---
>  drivers/net/ethernet/freescale/enetc/Kconfig | 4 ++--
>  drivers/net/ethernet/fungible/funeth/Kconfig | 2 +-
>  drivers/net/ethernet/netronome/Kconfig       | 2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)

For funeth part:

Acked-by: Dimitris Michailidis <dmichail@fungible.com>
