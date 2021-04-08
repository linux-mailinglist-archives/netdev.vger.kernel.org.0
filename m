Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2004235899F
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 18:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232286AbhDHQYO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 12:24:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232047AbhDHQYJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 12:24:09 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 473E9C061760;
        Thu,  8 Apr 2021 09:23:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=AFfer5nA26vf2QhXPl0xRFldwbSt+kQxskqMltJ5ujY=; b=T+CS7hAQwrzXLr7DC7xKUtgNAj
        NAuJfIvc8Ct36WBz7p8JksXccppFJScpMmvdKqVkn7S4YiwaZJyN+zne3EPGlYiPcowntLJkJSjIr
        0dlRtmPcdd8+3UYL+FKWIlWOoK9G+ew2QbbLn48+uHliiVkjUDXkect50RlGFRp9qOad2Hsu4hjZC
        P/BnqEIpkR1NM6qVufkMhrt6rptbzZrqBiT4c31lqvIAnqTmqGkTqNRBwUlAuQjyLRnvvhXlK/6pm
        T5aEz915uWNe47BTadf/Uth0T2TrhWd7jsBfIke08Pj9Q3rtAbVuQw8hL2pq0Rqnspv1puDSq5anU
        LDwppypg==;
Received: from [2601:1c0:6280:3f0::e0e1]
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lUXQt-00GVPg-IH; Thu, 08 Apr 2021 16:23:16 +0000
Subject: Re: [PATCH v2 net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
To:     decui@microsoft.com, davem@davemloft.net, kuba@kernel.org,
        kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, liuwe@microsoft.com, netdev@vger.kernel.org,
        leon@kernel.org, andrew@lunn.ch, bernd@petrovitsch.priv.at
Cc:     linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org
References: <20210408091543.22369-1-decui@microsoft.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <a44419b3-8ae9-ae42-f1fc-24e308499263@infradead.org>
Date:   Thu, 8 Apr 2021 09:22:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210408091543.22369-1-decui@microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/8/21 2:15 AM, Dexuan Cui wrote:
> diff --git a/drivers/net/ethernet/microsoft/Kconfig b/drivers/net/ethernet/microsoft/Kconfig
> new file mode 100644
> index 000000000000..12ef6b581566
> --- /dev/null
> +++ b/drivers/net/ethernet/microsoft/Kconfig
> @@ -0,0 +1,30 @@
> +#
> +# Microsoft Azure network device configuration
> +#
> +
> +config NET_VENDOR_MICROSOFT
> +	bool "Microsoft Azure Network Device"

Seems to me that should be generalized, more like:

	bool "Microsoft Network Devices"


> +	default y
> +	help
> +	  If you have a network (Ethernet) device belonging to this class, say Y.
> +
> +	  Note that the answer to this question doesn't directly affect the
> +	  kernel: saying N will just cause the configurator to skip the
> +	  question about Microsoft Azure network device. If you say Y, you

	           about Microsoft networking devices.

> +	  will be asked for your specific device in the following question.
> +
> +if NET_VENDOR_MICROSOFT
> +
> +config MICROSOFT_MANA
> +	tristate "Microsoft Azure Network Adapter (MANA) support"
> +	default m

Please drop the default m. We don't randomly add drivers to be built.

Or leave this as is and change NET_VENDOR_MICROSOFT to be default n.


> +	depends on PCI_MSI && X86_64
> +	select PCI_HYPERV
> +	help
> +	  This driver supports Microsoft Azure Network Adapter (MANA).
> +	  So far, the driver is only validated on X86_64.

validated how?


> +
> +	  To compile this driver as a module, choose M here.
> +	  The module will be called mana.
> +
> +endif #NET_VENDOR_MICROSOFT


thanks.
-- 
~Randy

