Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4EF61791A5
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 14:44:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729499AbgCDNoq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 08:44:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:57922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726275AbgCDNoq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 08:44:46 -0500
Received: from localhost (173-25-83-245.client.mchsi.com [173.25.83.245])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E8A52166E;
        Wed,  4 Mar 2020 13:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583329485;
        bh=jdTUtZCeADw4iFzCvLuSOdsEnfJb9E0SIWAQY6oL210=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=sty86VgjWMYbLJNmBzBXyiSMF/i3BdVPFIxs11zNEI6cgDn8K87vzpw5fHgdUq+dz
         +XyL0uG0QmUwVedBDhYOWwShe/8e7SkMsRfEz8dAA6+/+Dd4NfpF0lLLIpIfRXa1U9
         DCjV7Kpo3yeFsYZWF2kEQjvt8ATA4sML11v2Ctk8=
Date:   Wed, 4 Mar 2020 07:44:44 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Clemens Ladisch <clemens@ladisch.de>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH v4 09/10] PCI: pci-bridge-emul: Use new constant
 PCI_STATUS_ERROR_BITS
Message-ID: <20200304134444.GA198415@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <04851614-b906-2b1b-f937-189c3c210880@gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 29, 2020 at 11:28:18PM +0100, Heiner Kallweit wrote:
> Use new constant PCI_STATUS_ERROR_BITS to simplify the code.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

> ---
>  drivers/pci/pci-bridge-emul.c | 14 ++------------
>  1 file changed, 2 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/pci/pci-bridge-emul.c b/drivers/pci/pci-bridge-emul.c
> index fffa77093..4f4f54bc7 100644
> --- a/drivers/pci/pci-bridge-emul.c
> +++ b/drivers/pci/pci-bridge-emul.c
> @@ -50,12 +50,7 @@ static const struct pci_bridge_reg_behavior pci_regs_behavior[] = {
>  		       (PCI_STATUS_CAP_LIST | PCI_STATUS_66MHZ |
>  			PCI_STATUS_FAST_BACK | PCI_STATUS_DEVSEL_MASK) << 16),
>  		.rsvd = GENMASK(15, 10) | ((BIT(6) | GENMASK(3, 0)) << 16),
> -		.w1c = (PCI_STATUS_PARITY |
> -			PCI_STATUS_SIG_TARGET_ABORT |
> -			PCI_STATUS_REC_TARGET_ABORT |
> -			PCI_STATUS_REC_MASTER_ABORT |
> -			PCI_STATUS_SIG_SYSTEM_ERROR |
> -			PCI_STATUS_DETECTED_PARITY) << 16,
> +		.w1c = PCI_STATUS_ERROR_BITS << 16,
>  	},
>  	[PCI_CLASS_REVISION / 4] = { .ro = ~0 },
>  
> @@ -100,12 +95,7 @@ static const struct pci_bridge_reg_behavior pci_regs_behavior[] = {
>  			 PCI_STATUS_DEVSEL_MASK) << 16) |
>  		       GENMASK(11, 8) | GENMASK(3, 0)),
>  
> -		.w1c = (PCI_STATUS_PARITY |
> -			PCI_STATUS_SIG_TARGET_ABORT |
> -			PCI_STATUS_REC_TARGET_ABORT |
> -			PCI_STATUS_REC_MASTER_ABORT |
> -			PCI_STATUS_SIG_SYSTEM_ERROR |
> -			PCI_STATUS_DETECTED_PARITY) << 16,
> +		.w1c = PCI_STATUS_ERROR_BITS << 16,
>  
>  		.rsvd = ((BIT(6) | GENMASK(4, 0)) << 16),
>  	},
> -- 
> 2.25.1
> 
> 
