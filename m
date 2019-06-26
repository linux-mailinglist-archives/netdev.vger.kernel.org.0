Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 733D9574B3
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 01:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbfFZXIi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 19:08:38 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:32824 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726396AbfFZXIh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 19:08:37 -0400
Received: by mail-qt1-f196.google.com with SMTP id w40so484292qtk.0
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 16:08:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=EBGW/f2TqYrxqntxYAr/NKthNvtE1HU86AB/A8lzzxc=;
        b=xKVzgplAMkMINYShQDbyA/q2N+XvXrPxsvyVAmFfTWLh51K1LxRrO/j/I2t5mq5xiK
         Rel37zJe7XZfskWVyrJ80R5wRrLyUSB0tWSfwRPYWNDDosGhV07/W80inYz/RCZnR4MG
         MKWCAX/Aa4kSKORPvChFhk6sSuY2Mt9xbaJgStBmt4CQR4njGd5HveqS7KzQj02Tq3l/
         gk9pc0fSfdp9kySuq6btLPsp2RiYPsJlzhbwtkwYr1zmkoIrrX/++nxu0bRGs1nDfqUx
         2Gr8HBHCCZIVhjRK3yMQucHiyMmC7bQ8oz32p5ZpseVKMGCPjtk9NBM6bRB44n78B2s1
         +xrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=EBGW/f2TqYrxqntxYAr/NKthNvtE1HU86AB/A8lzzxc=;
        b=tFF8F3r1FmGx8Gzrr7bJOV0sk+Hllw0BkDnY270XtLmPJo4OW0TYXbfW2TuPIKDioD
         hPFVICA2QvXFyWJQAPvq24tNMDHzCub0rOx/rA6+yXxvawml8CIFLQM5oJlepMmREiSW
         GvnhuPlhGPQ2ve04hEr4aLAu4PerV/tNjk6hVGh9DOQ8DpuOEguN4/RqAcRiAx/EE3GT
         yYu/gId9EJEQxAiDqQ8pyTWtNwirQGawkFxgqg2yf7xGUiwChHeUj/1YmTNRGE60EzK8
         61n1BcK0GBJ1JcuJ2ukSLhJTtpD9bckDIucfGUSX+32HjdpQqdsXFfMlpbk4KgJjUQ4O
         SFBQ==
X-Gm-Message-State: APjAAAVVTJmuYq1J/GUv0CfjJ87f09AF4BusOPfK5EVNow5zt982OSjA
        RcFB5dDH7P1bweAQ+Cx/IMYXNg==
X-Google-Smtp-Source: APXvYqxA3+qrCvsl9uhuLnLWMc3tBDyOBs60ID96M8eVblK9I0/viR/t+cCGMTU7M3PKhuWOumOmFA==
X-Received: by 2002:ac8:37b8:: with SMTP id d53mr375046qtc.227.1561590516730;
        Wed, 26 Jun 2019 16:08:36 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id o54sm144183qtb.63.2019.06.26.16.08.35
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 26 Jun 2019 16:08:36 -0700 (PDT)
Date:   Wed, 26 Jun 2019 16:08:32 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Catherine Sullivan <csully@google.com>
Cc:     netdev@vger.kernel.org, Sagi Shahar <sagis@google.com>,
        Jon Olson <jonolson@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Luigi Rizzo <lrizzo@google.com>
Subject: Re: [net-next 1/4] gve: Add basic driver framework for Compute
 Engine Virtual NIC
Message-ID: <20190626160832.3f191a53@cakuba.netronome.com>
In-Reply-To: <20190626185251.205687-2-csully@google.com>
References: <20190626185251.205687-1-csully@google.com>
        <20190626185251.205687-2-csully@google.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Jun 2019 11:52:48 -0700, Catherine Sullivan wrote:
> Add a driver framework for the Compute Engine Virtual NIC that will be
> available in the future.
> 
> At this point the only functionality is loading the driver.
> 
> Signed-off-by: Catherine Sullivan <csully@google.com>
> Signed-off-by: Sagi Shahar <sagis@google.com>
> Signed-off-by: Jon Olson <jonolson@google.com>
> Acked-by: Willem de Bruijn <willemb@google.com>
> Reviewed-by: Luigi Rizzo <lrizzo@google.com>
> ---

> +if NET_VENDOR_GOOGLE
> +
> +config GVE
> +	tristate "Google Virtual NIC (gVNIC) support"
> +	depends on (PCI_MSI && X86)

We usually prefer for drivers not to depend on the platform unless
really necessary, but IDK how that applies to the curious new world 
of NICs nobody can buy :)

> +	help
> +	  This driver supports Google Virtual NIC (gVNIC)"
> +
> +	  To compile this driver as a module, choose M here.
> +	  The module will be called gve.
> +
> +endif #NET_VENDOR_GOOGLE

> +void gve_adminq_release(struct gve_priv *priv)
> +{
> +	int i;
> +
> +	/* Tell the device the adminq is leaving */
> +	writel(0x0, &priv->reg_bar0->adminq_pfn);
> +	for (i = 0; i < GVE_MAX_ADMINQ_RELEASE_CHECK; i++) {
> +		if (!readl(&priv->reg_bar0->adminq_pfn)) {
> +			gve_clear_device_rings_ok(priv);
> +			gve_clear_device_resources_ok(priv);
> +			gve_clear_admin_queue_ok(priv);
> +			return;
> +		}
> +		msleep(GVE_ADMINQ_SLEEP_LEN);
> +	}
> +	/* If this is reached the device is unrecoverable and still holding
> +	 * memory. Anything other than a BUG risks memory corruption.
> +	 */
> +	WARN(1, "Unrecoverable platform error!");
> +	BUG();

Please don't add BUG()s to the kernel.  You're probably better off
spinning for ever in the loop above.  Also if there is an IOMMU in 
the way the device won't be able to mess with the memory.

> +}
> +

> diff --git a/drivers/net/ethernet/google/gve/gve_size_assert.h b/drivers/net/ethernet/google/gve/gve_size_assert.h
> new file mode 100644
> index 000000000000..a58422d4f16e
> --- /dev/null
> +++ b/drivers/net/ethernet/google/gve/gve_size_assert.h
> @@ -0,0 +1,15 @@
> +/* SPDX-License-Identifier: (GPL-2.0 OR MIT)
> + * Google virtual Ethernet (gve) driver
> + *
> + * Copyright (C) 2015-2019 Google, Inc.
> + */
> +
> +#ifndef _GVE_ASSERT_H_
> +#define _GVE_ASSERT_H_
> +#define GVE_ASSERT_SIZE(tag, type, size) \
> +	static void gve_assert_size_ ## type(void) __attribute__((used)); \
> +	static inline void gve_assert_size_ ## type(void) \
> +	{ \
> +		BUILD_BUG_ON(sizeof(tag type) != (size)); \
> +	}
> +#endif /* _GVE_ASSERT_H_ */

Please use static_assert() directly in your struct size checks.
