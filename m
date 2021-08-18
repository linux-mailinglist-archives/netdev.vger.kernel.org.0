Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDD143F08B7
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 18:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbhHRQI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 12:08:27 -0400
Received: from ale.deltatee.com ([204.191.154.188]:54198 "EHLO
        ale.deltatee.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbhHRQI0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 12:08:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:MIME-Version:Date:
        Message-ID:From:References:Cc:To:content-disposition;
        bh=CDm4i4hwwrEGLoygLnIUbGFhDR61f58uuviY8Rqvqis=; b=gaUFIZeu4t5laVHZig7TFyAtzO
        qe9BVj6lqRpa9C+ID8lUpWLPlL2s1k9opX3QgzUQ3RPNC3Q8l+3e0rimDS+kzs/BK8j4PXy/zZlCp
        bjiO/VjnY/OHx906RphxMOaJ3PBfF3hf79tG9W8rVCYAKzw7cJmTv7wezTgLb+qgt+k91ByIa1Nos
        JrRGytM7cAwPBHz1mBkuXwTbbtfxpZnxnM9AlrYhIVJ4sjSwwUKe2WNn5F1V6vpkShkJGd4znEryu
        A2FmTvAyvL+PqRH6Vkw+vjFZ2IqXWx0q+9d0AyKIdd5/VrSS6+eSWrxO+C1E9m+tsLVGzCW4wFWQp
        4UA+ElOQ==;
Received: from s0106a84e3fe8c3f3.cg.shawcable.net ([24.64.144.200] helo=[192.168.0.10])
        by ale.deltatee.com with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <logang@deltatee.com>)
        id 1mGO6G-0001Ud-Cp; Wed, 18 Aug 2021 10:07:37 -0600
To:     Dongdong Liu <liudongdong3@huawei.com>, helgaas@kernel.org,
        hch@infradead.org, kw@linux.com, leon@kernel.org,
        linux-pci@vger.kernel.org, rajur@chelsio.com,
        hverkuil-cisco@xs4all.nl
Cc:     linux-media@vger.kernel.org, netdev@vger.kernel.org
References: <1629291717-38564-1-git-send-email-liudongdong3@huawei.com>
 <1629291717-38564-7-git-send-email-liudongdong3@huawei.com>
From:   Logan Gunthorpe <logang@deltatee.com>
Message-ID: <a097d255-85e4-cab8-c9be-c1b9af9dcaf5@deltatee.com>
Date:   Wed, 18 Aug 2021 10:07:29 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <1629291717-38564-7-git-send-email-liudongdong3@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 24.64.144.200
X-SA-Exim-Rcpt-To: netdev@vger.kernel.org, linux-media@vger.kernel.org, hverkuil-cisco@xs4all.nl, rajur@chelsio.com, linux-pci@vger.kernel.org, leon@kernel.org, kw@linux.com, hch@infradead.org, helgaas@kernel.org, liudongdong3@huawei.com
X-SA-Exim-Mail-From: logang@deltatee.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on ale.deltatee.com
X-Spam-Level: 
X-Spam-Status: No, score=-10.9 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        GREYLIST_ISWHITE,NICE_REPLY_A autolearn=ham autolearn_force=no
        version=3.4.2
Subject: Re: [PATCH V8 6/8] PCI/P2PDMA: Add a 10-Bit Tag check in P2PDMA
X-SA-Exim-Version: 4.2.1 (built Wed, 08 May 2019 21:11:16 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-08-18 7:01 a.m., Dongdong Liu wrote:
> Add a 10-Bit Tag check in the P2PDMA code to ensure that a device with
> 10-Bit Tag Requester doesn't interact with a device that does not
> support 10-Bit Tag Completer. Before that happens, the kernel should
> emit a warning.
> 
> "echo 0 > /sys/bus/pci/devices/.../10bit_tag" to disable 10-Bit Tag
> Requester for PF device.
> 
> "echo 0 > /sys/bus/pci/devices/.../sriov_vf_10bit_tag_ctl" to disable
> 10-Bit Tag Requester for VF device.
> 
> Signed-off-by: Dongdong Liu <liudongdong3@huawei.com>

Looks good to me, thanks.

Reviewed-by: Logan Gunthorpe <logang@deltatee.com>

> ---
>  drivers/pci/p2pdma.c | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 48 insertions(+)
> 
> diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
> index 50cdde3..2b9c2c9 100644
> --- a/drivers/pci/p2pdma.c
> +++ b/drivers/pci/p2pdma.c
> @@ -19,6 +19,7 @@
>  #include <linux/random.h>
>  #include <linux/seq_buf.h>
>  #include <linux/xarray.h>
> +#include "pci.h"
>  
>  enum pci_p2pdma_map_type {
>  	PCI_P2PDMA_MAP_UNKNOWN = 0,
> @@ -410,6 +411,50 @@ static unsigned long map_types_idx(struct pci_dev *client)
>  		(client->bus->number << 8) | client->devfn;
>  }
>  
> +static bool pci_10bit_tags_unsupported(struct pci_dev *a,
> +				       struct pci_dev *b,
> +				       bool verbose)
> +{
> +	bool req;
> +	bool comp;
> +	u16 ctl;
> +	const char *str = "10bit_tag";
> +
> +	if (a->is_virtfn) {
> +#ifdef CONFIG_PCI_IOV
> +		req = !!(a->physfn->sriov->ctrl &
> +			 PCI_SRIOV_CTRL_VF_10BIT_TAG_REQ_EN);
> +#endif
> +	} else {
> +		pcie_capability_read_word(a, PCI_EXP_DEVCTL2, &ctl);
> +		req = !!(ctl & PCI_EXP_DEVCTL2_10BIT_TAG_REQ_EN);
> +	}
> +
> +	comp = !!(b->pcie_devcap2 & PCI_EXP_DEVCAP2_10BIT_TAG_COMP);
> +
> +	/* 10-bit tags not enabled on requester */
> +	if (!req)
> +		return false;
> +
> +	 /* Completer can handle anything */
> +	if (comp)
> +		return false;
> +
> +	if (!verbose)
> +		return true;
> +
> +	pci_warn(a, "cannot be used for peer-to-peer DMA as 10-Bit Tag Requester enable is set for this device, but peer device (%s) does not support the 10-Bit Tag Completer\n",
> +		 pci_name(b));
> +
> +	if (a->is_virtfn)
> +		str = "sriov_vf_10bit_tag_ctl";
> +
> +	pci_warn(a, "to disable 10-Bit Tag Requester for this device, echo 0 > /sys/bus/pci/devices/%s/%s\n",
> +		 pci_name(a), str);
> +
> +	return true;
> +}
> +
>  /*
>   * Calculate the P2PDMA mapping type and distance between two PCI devices.
>   *
> @@ -532,6 +577,9 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
>  		map_type = PCI_P2PDMA_MAP_NOT_SUPPORTED;
>  	}
>  done:
> +	if (pci_10bit_tags_unsupported(client, provider, verbose))
> +		map_type = PCI_P2PDMA_MAP_NOT_SUPPORTED;
> +
>  	rcu_read_lock();
>  	p2pdma = rcu_dereference(provider->p2pdma);
>  	if (p2pdma)
> 
