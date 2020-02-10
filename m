Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE2B81583DB
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 20:43:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727523AbgBJTnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 14:43:05 -0500
Received: from bmailout2.hostsharing.net ([83.223.78.240]:42477 "EHLO
        bmailout2.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727003AbgBJTnE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Feb 2020 14:43:04 -0500
X-Greylist: delayed 443 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Feb 2020 14:43:04 EST
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by bmailout2.hostsharing.net (Postfix) with ESMTPS id 84E052800A291;
        Mon, 10 Feb 2020 20:35:40 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 56A3E22805F; Mon, 10 Feb 2020 20:35:40 +0100 (CET)
Date:   Mon, 10 Feb 2020 20:35:40 +0100
From:   Lukas Wunner <lukas@wunner.de>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH 2/3] net: ks8851-ml: Fix 16-bit data access
Message-ID: <20200210193540.2nfui5gbistqszcm@wunner.de>
References: <20200210184139.342716-1-marex@denx.de>
 <20200210184139.342716-2-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200210184139.342716-2-marex@denx.de>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 10, 2020 at 07:41:38PM +0100, Marek Vasut wrote:
> The packet data written to and read from Micrel KSZ8851-16MLLI must be
> byte-swapped in 16-bit mode, add this byte-swapping.
[...]
> -		*wptr++ = (u16)ioread16(ks->hw_addr);
> +		*wptr++ = swab16(ioread16(ks->hw_addr));

Um, doesn't this depend on the endianness of the CPU architecture?
I'd expect be16_to_cpu() or le16_to_cpu() here instead of swab16().

Thanks,

Lukas
