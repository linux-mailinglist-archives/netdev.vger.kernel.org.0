Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 844386AF5B6
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 20:32:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234225AbjCGTcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 14:32:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234073AbjCGTb7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 14:31:59 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EFCD1701
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 11:17:48 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id l1so13182358wry.12
        for <netdev@vger.kernel.org>; Tue, 07 Mar 2023 11:17:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google; t=1678216667;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7A/wHf8rLFLg2M6IudGVUnZF3qCIETvLpC0EZVBRNmU=;
        b=fbuZjhtEie3YMm0sAWYQLqW+T7mrDWApDa9oij8qxYaFfka02AFnpeLytiBV++lb0c
         m3oU/7xQo9srAoCU/3W6b/DeSRbDmcigZYBBsKE57Oj7hjI6n5fFeVnuUW6r60h1X1iE
         5UnBtd5y0flkQSSpBs+gbepm4aH3LKsRKvvuo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678216667;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7A/wHf8rLFLg2M6IudGVUnZF3qCIETvLpC0EZVBRNmU=;
        b=bkoIej4LW83I2/kltcjvhDeWxbkkP0h863ESkABqrv2t/Znx8NQ2oEfBN70aI843M9
         vj4c8TakSQu8iqUKpl6Hx0I/Nh8R2WeS7emB1HyOX5pOBQDNJOzCoYda/DvLnNjnJ4cD
         JjaOnEiHQzVn4Cn6vDANsiszGJx12I6AFjHioKTNN5K+s2zPuDhNNikYenCdhb/sreGt
         YyMq6iPU/sQP+6tNs9WPNQAYDyEsectIZA0xoXY/g6kWHQtIuqAfGHivB6GSscaZ3/fO
         3W+iy2X/YWVxGfh6LJlwzugWDtxp8DOFYPLktCwfAaYitv63ucpT+cgqO+QlLDOt5jIV
         lOJw==
X-Gm-Message-State: AO0yUKVhKGbFEpUHtq9jy3bJv66G24DH+qNtjmfcQgBDnyaTwUrzlKnd
        9rTzMxkT3XlU2g2KMOA7JcE6XY97d69UqD+qPVWC8Q==
X-Google-Smtp-Source: AK7set9pgNSz7WH116QGTVpuvH9rjQzc7tPS0bI7v+40cc8sKDEUJVnhglebu2IaIhjlnqCYt+AaMKua+KTFvwbsAc4=
X-Received: by 2002:a5d:660f:0:b0:2c7:d7c:7c4 with SMTP id n15-20020a5d660f000000b002c70d7c07c4mr3389807wru.6.1678216667042;
 Tue, 07 Mar 2023 11:17:47 -0800 (PST)
MIME-Version: 1.0
References: <20230307181940.868828-1-helgaas@kernel.org> <20230307181940.868828-8-helgaas@kernel.org>
In-Reply-To: <20230307181940.868828-8-helgaas@kernel.org>
From:   Dimitris Michailidis <d.michailidis@fungible.com>
Date:   Tue, 7 Mar 2023 11:17:33 -0800
Message-ID: <CAOkoqZkAHOUODq8yWvmcchDWQLB0zwPQ-0SjAsgWNn9eGWyWTw@mail.gmail.com>
Subject: Re: [PATCH 07/28] net/fungible: Drop redundant pci_enable_pcie_error_reporting()
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Dimitris Michailidis <dmichail@fungible.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 7, 2023 at 10:20=E2=80=AFAM Bjorn Helgaas <helgaas@kernel.org> =
wrote:
>
> From: Bjorn Helgaas <bhelgaas@google.com>
>
> pci_enable_pcie_error_reporting() enables the device to send ERR_*
> Messages.  Since f26e58bf6f54 ("PCI/AER: Enable error reporting when AER =
is
> native"), the PCI core does this for all devices during enumeration, so t=
he
> driver doesn't need to do it itself.
>
> Remove the redundant pci_enable_pcie_error_reporting() call from the
> driver.  Also remove the corresponding pci_disable_pcie_error_reporting()
> from the driver .remove() path.
>
> Note that this only controls ERR_* Messages from the device.  An ERR_*
> Message may cause the Root Port to generate an interrupt, depending on th=
e
> AER Root Error Command register managed by the AER service driver.
>
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Dimitris Michailidis <dmichail@fungible.com>

Acked-by: Dimitris Michailidis <dmichail@fungible.com>

> ---
>  drivers/net/ethernet/fungible/funcore/fun_dev.c | 5 -----
>  1 file changed, 5 deletions(-)
>
> diff --git a/drivers/net/ethernet/fungible/funcore/fun_dev.c b/drivers/ne=
t/ethernet/fungible/funcore/fun_dev.c
> index fb5120d90f26..3680f83feba2 100644
> --- a/drivers/net/ethernet/fungible/funcore/fun_dev.c
> +++ b/drivers/net/ethernet/fungible/funcore/fun_dev.c
> @@ -1,6 +1,5 @@
>  // SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
>
> -#include <linux/aer.h>
>  #include <linux/bitmap.h>
>  #include <linux/delay.h>
>  #include <linux/interrupt.h>
> @@ -748,7 +747,6 @@ void fun_dev_disable(struct fun_dev *fdev)
>         pci_free_irq_vectors(pdev);
>
>         pci_clear_master(pdev);
> -       pci_disable_pcie_error_reporting(pdev);
>         pci_disable_device(pdev);
>
>         fun_unmap_bars(fdev);
> @@ -781,8 +779,6 @@ int fun_dev_enable(struct fun_dev *fdev, struct pci_d=
ev *pdev,
>                 goto unmap;
>         }
>
> -       pci_enable_pcie_error_reporting(pdev);
> -
>         rc =3D sanitize_dev(fdev);
>         if (rc)
>                 goto disable_dev;
> @@ -830,7 +826,6 @@ int fun_dev_enable(struct fun_dev *fdev, struct pci_d=
ev *pdev,
>  free_irqs:
>         pci_free_irq_vectors(pdev);
>  disable_dev:
> -       pci_disable_pcie_error_reporting(pdev);
>         pci_disable_device(pdev);
>  unmap:
>         fun_unmap_bars(fdev);
> --
> 2.25.1
>
