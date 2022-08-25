Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBC885A0E55
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 12:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241032AbiHYKrw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 06:47:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241268AbiHYKrk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 06:47:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D7B4A6C70
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 03:47:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661424453;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mFna6utbrG+DnBYAyWKPA54NfqGLHGxmD6wmlN5x9/c=;
        b=fvc4wjcodYuGS+BJXEy6oLsvaLFnFrsAKdyBd+SNmpVkzS9eMI3KCp/LoRNEL7lrr5HEsI
        jyemT8zDqHnL1C0ZEEEfD1aFDdOYAfF2dgBdxtDblrmAWinOct9cpWwSF8tfhNQtcZF8/N
        yLuJVhrarzb9VAWugiG190dFHBpPQy4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-614-QTLBx3KcNb6f3KTtgaupKg-1; Thu, 25 Aug 2022 06:47:31 -0400
X-MC-Unique: QTLBx3KcNb6f3KTtgaupKg-1
Received: by mail-wr1-f72.google.com with SMTP id v19-20020adf8b53000000b00225728573e6so777884wra.21
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 03:47:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc;
        bh=mFna6utbrG+DnBYAyWKPA54NfqGLHGxmD6wmlN5x9/c=;
        b=dwHVGMYMoRxGvroaPO7O3eONicYFMdEFOTEkClwQp5bFw/agAPWXv8AZHW7SJfHIrc
         zgv3SXSpSpSPNoD3lwnXIrPau+Tsx3LIkDbi66lLvu2ou139StFBZljdd6njChrnwJAC
         xU5Jz/oTqKNZKzdG1algirTOyobhBYBIFeTe+XpdTqv1c/N0eL/PAkZKNCzV2UTl9GHW
         6tmZIVTRtS7nFoXK4qp6qouD6ARiSNNp/tY4OR+qSNHwpFEPAZQibMv6IMl43sgQNr4i
         ISBYt7UbNPFnGZF8Ov1pZpZLlr5kQVHdG+FEUlv8q6WobDxTn+49980GI0lOeDfYGJkP
         KBpw==
X-Gm-Message-State: ACgBeo0NuF+2eY+dWQOAwNrY9eUzqD7mivRmbntFIMT9cpul+lfif/TT
        Qirq4VGCqo3h65zs0hg25de6lCVwSgPS+Xn5ExblSUTfLkv65OfrJT1lkoEQlaQAH7QXUsQx0wx
        B7HM8+yi0Kke8YUw6
X-Received: by 2002:a05:600c:1c9a:b0:3a6:1c85:7a0c with SMTP id k26-20020a05600c1c9a00b003a61c857a0cmr1830416wms.155.1661424450372;
        Thu, 25 Aug 2022 03:47:30 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7jw2TjyC5Rddwvp+FhFhwU6pouE1rU8OTJNS3IrOEeKT02+AV6aHkUFE85i6diP2XwOApXNg==
X-Received: by 2002:a05:600c:1c9a:b0:3a6:1c85:7a0c with SMTP id k26-20020a05600c1c9a00b003a61c857a0cmr1830406wms.155.1661424450105;
        Thu, 25 Aug 2022 03:47:30 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-97-176.dyn.eolo.it. [146.241.97.176])
        by smtp.gmail.com with ESMTPSA id e3-20020a5d5943000000b002207a5d8db3sm2565956wri.73.2022.08.25.03.47.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 03:47:29 -0700 (PDT)
Message-ID: <6c4f300b92cc863fe61b122d04944358d9018f65.camel@redhat.com>
Subject: Re: [PATCH net-next v2] net: ngbe: Add build support for ngbe
From:   Paolo Abeni <pabeni@redhat.com>
To:     Mengyuan Lou <mengyuanlou@net-swift.com>, netdev@vger.kernel.org
Cc:     jiawenwu@trustnetic.com
Date:   Thu, 25 Aug 2022 12:47:28 +0200
In-Reply-To: <20220823113133.72306-1-mengyuanlou@net-swift.com>
References: <20220823113133.72306-1-mengyuanlou@net-swift.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Tue, 2022-08-23 at 19:31 +0800, Mengyuan Lou wrote:
> Add build options and guidance doc.
> Initialize pci device access for Wangxun Gigabit Ethernet devices.
> 
> Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
> Change log:
> v2: address comments:
> 	Jakub Kicinski: The length of the '=====' lines needs to be the same as the length of the text.

Your SoB tag should be the last line in the commit message, please re-
submit moving the changelog after the '---' marker.

> ---
>  .../device_drivers/ethernet/index.rst         |   1 +
>  .../device_drivers/ethernet/wangxun/ngbe.rst  |  14 ++
>  MAINTAINERS                                   |   4 +-
>  drivers/net/ethernet/wangxun/Kconfig          |  13 ++
>  drivers/net/ethernet/wangxun/Makefile         |   1 +
>  drivers/net/ethernet/wangxun/ngbe/Makefile    |   9 +
>  drivers/net/ethernet/wangxun/ngbe/ngbe.h      |  24 +++
>  drivers/net/ethernet/wangxun/ngbe/ngbe_main.c | 173 ++++++++++++++++++
>  drivers/net/ethernet/wangxun/ngbe/ngbe_type.h |  50 +++++
>  9 files changed, 288 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/networking/device_drivers/ethernet/wangxun/ngbe.rst
>  create mode 100644 drivers/net/ethernet/wangxun/ngbe/Makefile
>  create mode 100644 drivers/net/ethernet/wangxun/ngbe/ngbe.h
>  create mode 100644 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
>  create mode 100644 drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
> 
> diff --git a/Documentation/networking/device_drivers/ethernet/index.rst b/Documentation/networking/device_drivers/ethernet/index.rst
> index 7f1777173abb..5196905582c5 100644
> --- a/Documentation/networking/device_drivers/ethernet/index.rst
> +++ b/Documentation/networking/device_drivers/ethernet/index.rst
> @@ -52,6 +52,7 @@ Contents:
>     ti/tlan
>     toshiba/spider_net
>     wangxun/txgbe
> +   wangxun/ngbe
>  
>  .. only::  subproject and html
>  
> diff --git a/Documentation/networking/device_drivers/ethernet/wangxun/ngbe.rst b/Documentation/networking/device_drivers/ethernet/wangxun/ngbe.rst
> new file mode 100644
> index 000000000000..43a02f9943e1
> --- /dev/null
> +++ b/Documentation/networking/device_drivers/ethernet/wangxun/ngbe.rst
> @@ -0,0 +1,14 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +=============================================================
> +Linux Base Driver for WangXun(R) Gigabit PCI Express Adapters
> +=============================================================
> +
> +WangXun Gigabit Linux driver.
> +Copyright (c) 2019 - 2022 Beijing WangXun Technology Co., Ltd.
> +
> +Support
> +=======
> + If you have problems with the software or hardware, please contact our
> + customer support team via email at nic-support@net-swift.com or check our website
> + at https://www.net-swift.com
> diff --git a/MAINTAINERS b/MAINTAINERS
> index f2d64020399b..4e7ced47a255 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -21834,9 +21834,11 @@ F:	drivers/input/tablet/wacom_serial4.c
>  
>  WANGXUN ETHERNET DRIVER
>  M:	Jiawen Wu <jiawenwu@trustnetic.com>
> +M:	Mengyuan Lou <mengyuanlou@net-swift.com>
> +W:	https://www.net-swift.com
>  L:	netdev@vger.kernel.org
>  S:	Maintained
> -F:	Documentation/networking/device_drivers/ethernet/wangxun/txgbe.rst
> +F:	Documentation/networking/device_drivers/ethernet/wangxun/*
>  F:	drivers/net/ethernet/wangxun/
>  
>  WATCHDOG DEVICE DRIVERS
> diff --git a/drivers/net/ethernet/wangxun/Kconfig b/drivers/net/ethernet/wangxun/Kconfig
> index b4a4fa0a58f8..f5d43d8c9629 100644
> --- a/drivers/net/ethernet/wangxun/Kconfig
> +++ b/drivers/net/ethernet/wangxun/Kconfig
> @@ -16,6 +16,19 @@ config NET_VENDOR_WANGXUN
>  
>  if NET_VENDOR_WANGXUN
>  
> +config NGBE
> +	tristate "Wangxun(R) GbE PCI Express adapters support"
> +	depends on PCI
> +	help
> +	  This driver supports Wangxun(R) GbE PCI Express family of
> +	  adapters.
> +
> +	  More specific information on configuring the driver is in
> +	  <file:Documentation/networking/device_drivers/ethernet/wangxun/ngbe.rst>.
> +
> +	  To compile this driver as a module, choose M here. The module
> +	  will be called ngbe.
> +
>  config TXGBE
>  	tristate "Wangxun(R) 10GbE PCI Express adapters support"
>  	depends on PCI
> diff --git a/drivers/net/ethernet/wangxun/Makefile b/drivers/net/ethernet/wangxun/Makefile
> index c34db1bead25..1193b4f738b8 100644
> --- a/drivers/net/ethernet/wangxun/Makefile
> +++ b/drivers/net/ethernet/wangxun/Makefile
> @@ -4,3 +4,4 @@
>  #
>  
>  obj-$(CONFIG_TXGBE) += txgbe/
> +obj-$(CONFIG_TXGBE) += ngbe/
> diff --git a/drivers/net/ethernet/wangxun/ngbe/Makefile b/drivers/net/ethernet/wangxun/ngbe/Makefile
> new file mode 100644
> index 000000000000..0baf75907496
> --- /dev/null
> +++ b/drivers/net/ethernet/wangxun/ngbe/Makefile
> @@ -0,0 +1,9 @@
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2019 - 2022 Beijing WangXun Technology Co., Ltd.
> +#
> +# Makefile for the Wangxun(R) GbE PCI Express ethernet driver
> +#
> +
> +obj-$(CONFIG_NGBE) += ngbe.o
> +
> +ngbe-objs := ngbe_main.o
> diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe.h b/drivers/net/ethernet/wangxun/ngbe/ngbe.h
> new file mode 100644
> index 000000000000..f5fa6e5238cc
> --- /dev/null
> +++ b/drivers/net/ethernet/wangxun/ngbe/ngbe.h
> @@ -0,0 +1,24 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright (c) 2019 - 2022 Beijing WangXun Technology Co., Ltd. */
> +
> +#ifndef _NGBE_H_
> +#define _NGBE_H_
> +
> +#include "ngbe_type.h"
> +
> +#define NGBE_MAX_FDIR_INDICES		7
> +
> +#define NGBE_MAX_RX_QUEUES		(NGBE_MAX_FDIR_INDICES + 1)
> +#define NGBE_MAX_TX_QUEUES		(NGBE_MAX_FDIR_INDICES + 1)
> +
> +/* board specific private data structure */
> +struct ngbe_adapter {
> +	u8 __iomem *io_addr;    /* Mainly for iounmap use */
> +	/* OS defined structs */
> +	struct net_device *netdev;
> +	struct pci_dev *pdev;
> +};
> +
> +extern char ngbe_driver_name[];
> +
> +#endif /* _NGBE_H_ */
> diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
> new file mode 100644
> index 000000000000..ba3a80e5c303
> --- /dev/null
> +++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
> @@ -0,0 +1,173 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2019 - 2022 Beijing WangXun Technology Co., Ltd. */
> +
> +#include <linux/types.h>
> +#include <linux/module.h>
> +#include <linux/pci.h>
> +#include <linux/netdevice.h>
> +#include <linux/string.h>
> +#include <linux/aer.h>
> +#include <linux/etherdevice.h>

Note that this is triggering a large amount of sparse warning on PW,
but that is likely caused by a sparse bug. Running locally with an
up2date sparse version, such warnings go away


Cheers,

Paolo

