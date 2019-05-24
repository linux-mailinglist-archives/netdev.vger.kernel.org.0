Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E449229D8C
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 19:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731979AbfEXRyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 13:54:11 -0400
Received: from mail-vs1-f68.google.com ([209.85.217.68]:40137 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbfEXRyL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 13:54:11 -0400
Received: by mail-vs1-f68.google.com with SMTP id c24so6396017vsp.7;
        Fri, 24 May 2019 10:54:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=z/GiW9YkKP3qylPckCwFQzVR25kk7Ib6EX6x6dIKwWY=;
        b=dpjVyjFq+TRJtqkLPUE5puUr3vkNMM/zUwEXNQ81LFDh07pAI60TXaj7OkiPMtkFOS
         iV462lc72G4/dL4seUCt4FrtE/JDeqObHt7ba/tWHzOfi9+3u7jk01MQnE91zASKuRR/
         L1zmCQGqTbX46t9pyz/ejsbRJCYikuBKGcOwOSFjumHIstxknfdO7RASj2lwK4lGGlJr
         GN0am1EMMxcpuOVwtBAul6/F2SeKt+414zVgTdykwu9XzovRIJQ7ylE1jnFHaLQhu0UD
         FZqq4iCD8HL9HXjPNShoUo+oH6ebvxXAH6LCl/sQRXNadqdr6uZyNRWBesyZp4lHV//s
         iL3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=z/GiW9YkKP3qylPckCwFQzVR25kk7Ib6EX6x6dIKwWY=;
        b=k8ckdxTXaGDHWmBCTyp1YJnsykq67DuMNS2WbFylNPo/dLXTCEpoIuW3bbr6LUFuEJ
         VIrxcTCi3aKiKaM7rgnWA1foMuN+xyPVeyBPcmA6zU5cwCumwdyBHWxUJk8eyxi5LYT4
         cg/fxAIlxE3nPhxfNQojcQqozVKNz3DODEXZjWYFQBFfQKelyHI1+5drmSMYaab906rY
         o5wxDTK5HC8a3xVBP6tMNXq07AVicWf+mtCHU07zTUiGeaxYVn6EV4LRcQNwqhRTiY+L
         ND4lg32Xf/1YapISLNZCN0fpFqpxH8rbtJzHwNQf/GGKNMF4qRKFf5DJf2O98Ea/jMJa
         iQGw==
X-Gm-Message-State: APjAAAXxRQTHC18ECN39v7zqwXz2mbWvcwhU6lpcud4b15xI13Hg1rnT
        3SHkdjQ0f2rnhS55i8v8uNw=
X-Google-Smtp-Source: APXvYqx2FtFxLzeAVdjsO+APUeOuwrh1AIJiq7GeETKG+Fsc8hIpj5f7udh3JFVWICgM0bMtD64k4A==
X-Received: by 2002:a67:eb8b:: with SMTP id e11mr25080730vso.115.1558720449839;
        Fri, 24 May 2019 10:54:09 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id c71sm1322139vke.19.2019.05.24.10.54.08
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 24 May 2019 10:54:08 -0700 (PDT)
Date:   Fri, 24 May 2019 13:54:07 -0400
Message-ID: <20190524135407.GB17138@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rasmus Villemoes <Rasmus.Villemoes@prevas.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/5] net: dsa: mv88e6xxx: introduce support for two
 chips using direct smi addressing
In-Reply-To: <20190524085921.11108-2-rasmus.villemoes@prevas.dk>
References: <20190501193126.19196-1-rasmus.villemoes@prevas.dk>
 <20190524085921.11108-1-rasmus.villemoes@prevas.dk>
 <20190524085921.11108-2-rasmus.villemoes@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rasmus,

On Fri, 24 May 2019 09:00:24 +0000, Rasmus Villemoes <rasmus.villemoes@prevas.dk> wrote:
> The 88e6250 (as well as 6220, 6071, 6070, 6020) do not support
> multi-chip (indirect) addressing. However, one can still have two of
> them on the same mdio bus, since the device only uses 16 of the 32
> possible addresses, either addresses 0x00-0x0F or 0x10-0x1F depending
> on the ADDR4 pin at reset [since ADDR4 is internally pulled high, the
> latter is the default].
> 
> In order to prepare for supporting the 88e6250 and friends, introduce
> mv88e6xxx_info::dual_chip to allow having a non-zero sw_addr while
> still using direct addressing.
> 
> Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
> ---
>  drivers/net/dsa/mv88e6xxx/chip.h |  6 ++++++
>  drivers/net/dsa/mv88e6xxx/smi.c  | 25 ++++++++++++++++++++++++-
>  2 files changed, 30 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
> index faa3fa889f19..74777c3bc313 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.h
> +++ b/drivers/net/dsa/mv88e6xxx/chip.h
> @@ -112,6 +112,12 @@ struct mv88e6xxx_info {
>  	 * when it is non-zero, and use indirect access to internal registers.
>  	 */
>  	bool multi_chip;
> +	/* Dual-chip Addressing Mode
> +	 * Some chips respond to only half of the 32 SMI addresses,
> +	 * allowing two to coexist on the same SMI interface.
> +	 */
> +	bool dual_chip;
> +
>  	enum dsa_tag_protocol tag_protocol;
>  
>  	/* Mask for FromPort and ToPort value of PortVec used in ATU Move
> diff --git a/drivers/net/dsa/mv88e6xxx/smi.c b/drivers/net/dsa/mv88e6xxx/smi.c
> index 96f7d2685bdc..1151b5b493ea 100644
> --- a/drivers/net/dsa/mv88e6xxx/smi.c
> +++ b/drivers/net/dsa/mv88e6xxx/smi.c
> @@ -24,6 +24,10 @@
>   * When ADDR is non-zero, the chip uses Multi-chip Addressing Mode, allowing
>   * multiple devices to share the SMI interface. In this mode it responds to only
>   * 2 registers, used to indirectly access the internal SMI devices.
> + *
> + * Some chips use a different scheme: Only the ADDR4 pin is used for
> + * configuration, and the device responds to 16 of the 32 SMI
> + * addresses, allowing two to coexist on the same SMI interface.
>   */
>  
>  static int mv88e6xxx_smi_direct_read(struct mv88e6xxx_chip *chip,
> @@ -76,6 +80,23 @@ static const struct mv88e6xxx_bus_ops mv88e6xxx_smi_direct_ops = {
>  	.write = mv88e6xxx_smi_direct_write,
>  };
>  
> +static int mv88e6xxx_smi_dual_direct_read(struct mv88e6xxx_chip *chip,
> +					  int dev, int reg, u16 *data)
> +{
> +	return mv88e6xxx_smi_direct_read(chip, dev + chip->sw_addr, reg, data);

Using chip->sw_addr + dev seems more idiomatic to me than dev + chip->sw_addr.

> +}
> +
> +static int mv88e6xxx_smi_dual_direct_write(struct mv88e6xxx_chip *chip,
> +					   int dev, int reg, u16 data)
> +{
> +	return mv88e6xxx_smi_direct_write(chip, dev + chip->sw_addr, reg, data);
> +}
> +
> +static const struct mv88e6xxx_bus_ops mv88e6xxx_smi_dual_direct_ops = {
> +	.read = mv88e6xxx_smi_dual_direct_read,
> +	.write = mv88e6xxx_smi_dual_direct_write,
> +};
> +
>  /* Offset 0x00: SMI Command Register
>   * Offset 0x01: SMI Data Register
>   */
> @@ -144,7 +165,9 @@ static const struct mv88e6xxx_bus_ops mv88e6xxx_smi_indirect_ops = {
>  int mv88e6xxx_smi_init(struct mv88e6xxx_chip *chip,
>  		       struct mii_bus *bus, int sw_addr)
>  {
> -	if (sw_addr == 0)
> +	if (chip->info->dual_chip)
> +		chip->smi_ops = &mv88e6xxx_smi_dual_direct_ops;
> +	else if (sw_addr == 0)
>  		chip->smi_ops = &mv88e6xxx_smi_direct_ops;
>  	else if (chip->info->multi_chip)
>  		chip->smi_ops = &mv88e6xxx_smi_indirect_ops;

Please submit respins (v2, v3, and so on) as independent threads,
not as a reply to the previous version.

Otherwise this looks good to me:

Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>

Thanks,
Vivien
