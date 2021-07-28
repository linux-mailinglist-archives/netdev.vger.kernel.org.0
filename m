Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8283D88D9
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 09:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234793AbhG1Hat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 03:30:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51996 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233386AbhG1Has (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 03:30:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627457446;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SRjnjdMuqaRLPlBJge7OUEIBVRiZnSvX4Fcwy4DB6+E=;
        b=Bmv9DZxl8xknE+f3vM5Q+a6/nRIcAlZmhuFD4zJ3bhb4k4WSHLW31MMMMpfEMAlvw5Mzrd
        XFTrx0GO8XjYoFXP21EZLGfNhjgJTrOoUrvGpRkFFaupq3oM6dFc98Ke/mZhP8/4K0N8Y4
        JyiUZFpUSOqLJ4gSep02xBg5J1R2UBc=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-397-bktGZRtoNBezLKgs8WSxOg-1; Wed, 28 Jul 2021 03:30:45 -0400
X-MC-Unique: bktGZRtoNBezLKgs8WSxOg-1
Received: by mail-ed1-f71.google.com with SMTP id de5-20020a0564023085b02903bb92fd182eso822178edb.8
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 00:30:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SRjnjdMuqaRLPlBJge7OUEIBVRiZnSvX4Fcwy4DB6+E=;
        b=U9vDoAbsznDHYrydg8vdFygSp5yzGWc5v9ZHJzmVqzf85+ZdtgLlsuXjUg3r43vlFe
         8YBXzsyw+wFSdBO5Vh9s+1vMVxZtmKz/uT01qsFgAUhY/+dyLVYGv2rTFF/ebgup2VvI
         5Tkhee2UXvzKT980BcXrpMs3FX1I6igVLuDPPTCMs3KIB/b+3nOgWaW1NjBw+J4yWES9
         fFOsHJlyqlWeNYzCYmkHY9cEaqeiCwtVchEm7izVqRRm0MHgVowh7x20xbQWvHVxBMot
         McwPQt2ioDsGjuD2Nuk2v5kvhNappJ4JTTnF2z/F9o+pHpMr+qxCnS1JQpuJKmTMMPUW
         0scQ==
X-Gm-Message-State: AOAM5338DHkQgGXIzseXgUtlT01tFH/fyhZIVVbPHi6xYvTHF4FWRdXx
        HWa2U+43T+mcwdNNihy7eFArGSugD/m+OchOOxTpO9Hg6Buwh4Ck1fMi5d+/QnoWlT+S5zH+o9y
        NElXhc6bo4DLzHSSAZFwt71ziif5xUzRXDAETpz997cghZE7xblSdAa+Y0hT9UbYp2x0f
X-Received: by 2002:a17:906:7050:: with SMTP id r16mr19296421ejj.397.1627457443855;
        Wed, 28 Jul 2021 00:30:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxAIOz0VsrgF6lKMSUFPftB1KGD1JfG9sJ0zcc+XNcr2YNKWVKynV46ZwNkeXneNaTv/xbQMw==
X-Received: by 2002:a17:906:7050:: with SMTP id r16mr19296404ejj.397.1627457443605;
        Wed, 28 Jul 2021 00:30:43 -0700 (PDT)
Received: from x1.localdomain (2001-1c00-0c1e-bf00-1054-9d19-e0f0-8214.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:1054:9d19:e0f0:8214])
        by smtp.gmail.com with ESMTPSA id e7sm1694356ejt.80.2021.07.28.00.30.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jul 2021 00:30:43 -0700 (PDT)
Subject: Re: [PATCH v3 5/6] platform/x86: intel_tdx_attest: Add TDX Guest
 attestation interface driver
To:     Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Mark Gross <mgross@linux.intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Peter H Anvin <hpa@zytor.com>, Dave Hansen <dave.hansen@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Kirill Shutemov <kirill.shutemov@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Kuppuswamy Sathyanarayanan <knsathya@kernel.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org
References: <20210720045552.2124688-1-sathyanarayanan.kuppuswamy@linux.intel.com>
 <20210720045552.2124688-6-sathyanarayanan.kuppuswamy@linux.intel.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <e7bda09b-48ce-d593-a308-75a9cc31c139@redhat.com>
Date:   Wed, 28 Jul 2021 09:30:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210720045552.2124688-6-sathyanarayanan.kuppuswamy@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 7/20/21 6:55 AM, Kuppuswamy Sathyanarayanan wrote:
> TDX guest supports encrypted disk as root or secondary drives.
> Decryption keys required to access such drives are usually maintained
> by 3rd party key servers. Attestation is required by 3rd party key
> servers to get the key for an encrypted disk volume, or possibly other
> encrypted services. Attestation is used to prove to the key server that
> the TD guest is running in a valid TD and the kernel and virtual BIOS
> and other environment are secure.
> 
> During the boot process various components before the kernel accumulate
> hashes in the TDX module, which can then combined into a report. This
> would typically include a hash of the bios, bios configuration, boot
> loader, command line, kernel, initrd.  After checking the hashes the
> key server will securely release the keys.
> 
> The actual details of the attestation protocol depend on the particular
> key server configuration, but some parts are common and need to
> communicate with the TDX module.
> 
> This communication is implemented in the attestation driver.
> 
> The supported steps are:
> 
>   1. TD guest generates the TDREPORT that contains version information
>      about the Intel TDX module, measurement of the TD, along with a
>      TD-specified nonce.
>   2. TD guest shares the TDREPORT with TD host via GetQuote hypercall
>      which is used by the host to generate a quote via quoting
>      enclave (QE).
>   3. Quote generation completion notification is sent to TD OS via
>      callback interrupt vector configured by TD using
>      SetupEventNotifyInterrupt hypercall.
>   4. After receiving the generated TDQUOTE, a remote verifier can be
>      used to verify the quote and confirm the trustworthiness of the
>      TD.
> 
> Attestation agent uses IOCTLs implemented by the attestation driver to
> complete the various steps of the attestation process.
> 
> Also note that, explicit access permissions are not enforced in this
> driver because the quote and measurements are not a secret. However
> the access permissions of the device node can be used to set any
> desired access policy. The udev default is usually root access
> only.
> 
> TDX_CMD_GEN_QUOTE IOCTL can be used to create an computation on the
> host, but TDX assumes that the host is able to deal with malicious
> guest flooding it anyways.
> 
> The interaction with the TDX module is like a RPM protocol here. There
> are several operations (get tdreport, get quote) that need to input a
> blob, and then output another blob. It was considered to use a sysfs
> interface for this, but it doesn't fit well into the standard sysfs
> model for configuring values. It would be possible to do read/write on
> files, but it would need multiple file descriptors, which would be
> somewhat messy. ioctls seems to be the best fitting and simplest model
> here. There is one ioctl per operation, that takes the input blob and
> returns the output blob, and as well as auxiliary ioctls to return the
> blob lengths. The ioctls are documented in the header file. 
> 
> Reviewed-by: Tony Luck <tony.luck@intel.com>
> Reviewed-by: Andi Kleen <ak@linux.intel.com>
> Signed-off-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
> ---
> 
> Changes since v2:
>  * Removed MMIO reference in Kconfig help text.
>  * Added support for GetQuote completion timeout.
>  * Moved quote and report data memory allocation logic to module init code.
>  * Removed tdg_attest_open() and tdg_attest_release().
>  * Removed MODULE_VERSION as per Dan's suggestion.
>  * Added check for put_user() return value in TDX_CMD_GET_QUOTE_SIZE case.
>  * Modified TDX_CMD_GEN_QUOTE IOCTL to depend on TDREPORT data instead of
>    report data.
>  * Added tdg_attest_init() and tdg_attest_exit().
>  * Instead of using set_memory_{de/en}crypted() for sharing/unsharing guest
>    pages, modified the driver to use dma_alloc APIs.
> 
>  drivers/platform/x86/Kconfig            |   9 +
>  drivers/platform/x86/Makefile           |   1 +
>  drivers/platform/x86/intel_tdx_attest.c | 208 ++++++++++++++++++++++++
>  include/uapi/misc/tdx.h                 |  37 +++++
>  4 files changed, 255 insertions(+)
>  create mode 100644 drivers/platform/x86/intel_tdx_attest.c

Starting with 5.14-rc1 we have a new drivers/platform/x86/intel
directory and we are slowly moving all Intel drivers there since
there were too much files directly under drivers/platform/x86.

For the next version please put this under drivers/platform/x86/intel.

Also the cover letter misses any information about how this is planned
to get merged even though this patch-set touches multiple sub-systems.

I believe it is best for the entire set to be picked up by the tip tree,
here is my ack for this:

Acked-by: Hans de Goede <hdegoede@redhat.com>

Note this will lead to conflicts in drivers/platform/x86/intel/Kconfig and
drivers/platform/x86//intel/Makefile as more and more Intel code is being
moved there, but those should be trivial to resolve.

Regards,

Hans




>  create mode 100644 include/uapi/misc/tdx.h
> 
> diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
> index 7d385c3b2239..1eee29b76fd1 100644
> --- a/drivers/platform/x86/Kconfig
> +++ b/drivers/platform/x86/Kconfig
> @@ -1294,6 +1294,15 @@ config INTEL_SCU_IPC_UTIL
>  	  low level access for debug work and updating the firmware. Say
>  	  N unless you will be doing this on an Intel MID platform.
>  
> +config INTEL_TDX_ATTESTATION
> +	tristate "Intel TDX attestation driver"
> +	depends on INTEL_TDX_GUEST
> +	help
> +	  The TDX attestation driver provides IOCTL interfaces to the user to
> +	  request TDREPORT from the TDX module or request quote from the VMM
> +	  or to get quote buffer size. It is mainly used to get secure disk
> +	  decryption keys from the key server.
> +
>  config INTEL_TELEMETRY
>  	tristate "Intel SoC Telemetry Driver"
>  	depends on X86_64
> diff --git a/drivers/platform/x86/Makefile b/drivers/platform/x86/Makefile
> index 7ee369aab10d..b5a5834e3f52 100644
> --- a/drivers/platform/x86/Makefile
> +++ b/drivers/platform/x86/Makefile
> @@ -138,6 +138,7 @@ obj-$(CONFIG_INTEL_SCU_PCI)		+= intel_scu_pcidrv.o
>  obj-$(CONFIG_INTEL_SCU_PLATFORM)	+= intel_scu_pltdrv.o
>  obj-$(CONFIG_INTEL_SCU_WDT)		+= intel_scu_wdt.o
>  obj-$(CONFIG_INTEL_SCU_IPC_UTIL)	+= intel_scu_ipcutil.o
> +obj-$(CONFIG_INTEL_TDX_ATTESTATION)	+= intel_tdx_attest.o
>  obj-$(CONFIG_INTEL_TELEMETRY)		+= intel_telemetry_core.o \
>  					   intel_telemetry_pltdrv.o \
>  					   intel_telemetry_debugfs.o
> diff --git a/drivers/platform/x86/intel_tdx_attest.c b/drivers/platform/x86/intel_tdx_attest.c
> new file mode 100644
> index 000000000000..b9656ccca540
> --- /dev/null
> +++ b/drivers/platform/x86/intel_tdx_attest.c
> @@ -0,0 +1,208 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * intel_tdx_attest.c - TDX guest attestation interface driver.
> + *
> + * Implements user interface to trigger attestation process and
> + * read the TD Quote result.
> + *
> + * Copyright (C) 2020 Intel Corporation
> + *
> + * Author:
> + *     Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
> + */
> +
> +#define pr_fmt(fmt) "x86/tdx: attest: " fmt
> +
> +#include <linux/module.h>
> +#include <linux/miscdevice.h>
> +#include <linux/uaccess.h>
> +#include <linux/fs.h>
> +#include <linux/mm.h>
> +#include <linux/slab.h>
> +#include <linux/set_memory.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/jiffies.h>
> +#include <linux/io.h>
> +#include <asm/apic.h>
> +#include <asm/tdx.h>
> +#include <asm/irq_vectors.h>
> +#include <uapi/misc/tdx.h>
> +
> +/* Used in Quote memory allocation */
> +#define QUOTE_SIZE			(2 * PAGE_SIZE)
> +/* Get Quote timeout in msec */
> +#define GET_QUOTE_TIMEOUT		(5000)
> +
> +/* Mutex to synchronize attestation requests */
> +static DEFINE_MUTEX(attestation_lock);
> +/* Completion object to track attestation status */
> +static DECLARE_COMPLETION(attestation_done);
> +/* Buffer used to copy report data in attestation handler */
> +static u8 report_data[TDX_REPORT_DATA_LEN];
> +/* Data pointer used to get TD Quote data in attestation handler */
> +static void *tdquote_data;
> +/* Data pointer used to get TDREPORT data in attestation handler */
> +static void *tdreport_data;
> +/* DMA handle used to allocate and free tdquote DMA buffer */
> +dma_addr_t tdquote_dma_handle;
> +
> +static void attestation_callback_handler(void)
> +{
> +	complete(&attestation_done);
> +}
> +
> +static long tdg_attest_ioctl(struct file *file, unsigned int cmd,
> +			     unsigned long arg)
> +{
> +	void __user *argp = (void __user *)arg;
> +	long ret = 0;
> +
> +	mutex_lock(&attestation_lock);
> +
> +	switch (cmd) {
> +	case TDX_CMD_GET_TDREPORT:
> +		if (copy_from_user(report_data, argp, TDX_REPORT_DATA_LEN)) {
> +			ret = -EFAULT;
> +			break;
> +		}
> +
> +		/* Generate TDREPORT_STRUCT */
> +		if (tdx_mcall_tdreport(virt_to_phys(tdreport_data),
> +				       virt_to_phys(report_data))) {
> +			ret = -EIO;
> +			break;
> +		}
> +
> +		if (copy_to_user(argp, tdreport_data, TDX_TDREPORT_LEN))
> +			ret = -EFAULT;
> +		break;
> +	case TDX_CMD_GEN_QUOTE:
> +		/* Copy TDREPORT data from user buffer */
> +		if (copy_from_user(tdquote_data, argp, TDX_TDREPORT_LEN)) {
> +			ret = -EFAULT;
> +			break;
> +		}
> +
> +		/* Submit GetQuote Request */
> +		if (tdx_hcall_get_quote(virt_to_phys(tdquote_data))) {
> +			ret = -EIO;
> +			break;
> +		}
> +
> +		/* Wait for attestation completion */
> +		ret = wait_for_completion_interruptible_timeout(
> +				&attestation_done,
> +				msecs_to_jiffies(GET_QUOTE_TIMEOUT));
> +		if (ret <= 0) {
> +			ret = -EIO;
> +			break;
> +		}
> +
> +		if (copy_to_user(argp, tdquote_data, QUOTE_SIZE))
> +			ret = -EFAULT;
> +
> +		break;
> +	case TDX_CMD_GET_QUOTE_SIZE:
> +		ret = put_user(QUOTE_SIZE, (u64 __user *)argp);
> +		break;
> +	default:
> +		pr_err("cmd %d not supported\n", cmd);
> +		break;
> +	}
> +
> +	mutex_unlock(&attestation_lock);
> +
> +	return ret;
> +}
> +
> +static const struct file_operations tdg_attest_fops = {
> +	.owner		= THIS_MODULE,
> +	.unlocked_ioctl	= tdg_attest_ioctl,
> +	.llseek		= no_llseek,
> +};
> +
> +static struct miscdevice tdg_attest_device = {
> +	.minor          = MISC_DYNAMIC_MINOR,
> +	.name           = "tdx-attest",
> +	.fops           = &tdg_attest_fops,
> +};
> +
> +static int __init tdg_attest_init(void)
> +{
> +	dma_addr_t handle;
> +	long ret = 0;
> +
> +	ret = misc_register(&tdg_attest_device);
> +	if (ret) {
> +		pr_err("misc device registration failed\n");
> +		return ret;
> +	}
> +
> +	tdreport_data = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, 0);
> +	if (!tdreport_data) {
> +		ret = -ENOMEM;
> +		goto failed;
> +	}
> +
> +	ret = dma_set_coherent_mask(tdg_attest_device.this_device,
> +				    DMA_BIT_MASK(64));
> +	if (ret) {
> +		pr_err("dma set coherent mask failed\n");
> +		goto failed;
> +	}
> +
> +	/* Allocate DMA buffer to get TDQUOTE data from the VMM */
> +	tdquote_data = dma_alloc_coherent(tdg_attest_device.this_device,
> +					  QUOTE_SIZE, &handle,
> +					  GFP_KERNEL | __GFP_ZERO);
> +	if (!tdquote_data) {
> +		ret = -ENOMEM;
> +		goto failed;
> +	}
> +
> +	tdquote_dma_handle =  handle;
> +
> +	/*
> +	 * Currently tdg_event_notify_handler is only used in attestation
> +	 * driver. But, WRITE_ONCE is used as benign data race notice.
> +	 */
> +	WRITE_ONCE(tdg_event_notify_handler, attestation_callback_handler);
> +
> +	pr_debug("module initialization success\n");
> +
> +	return 0;
> +
> +failed:
> +	if (tdreport_data)
> +		free_pages((unsigned long)tdreport_data, 0);
> +
> +	misc_deregister(&tdg_attest_device);
> +
> +	pr_debug("module initialization failed\n");
> +
> +	return ret;
> +}
> +
> +static void __exit tdg_attest_exit(void)
> +{
> +	mutex_lock(&attestation_lock);
> +
> +	dma_free_coherent(tdg_attest_device.this_device, QUOTE_SIZE,
> +			  tdquote_data, tdquote_dma_handle);
> +	free_pages((unsigned long)tdreport_data, 0);
> +	misc_deregister(&tdg_attest_device);
> +	/*
> +	 * Currently tdg_event_notify_handler is only used in attestation
> +	 * driver. But, WRITE_ONCE is used as benign data race notice.
> +	 */
> +	WRITE_ONCE(tdg_event_notify_handler, NULL);
> +	mutex_unlock(&attestation_lock);
> +	pr_debug("module is successfully removed\n");
> +}
> +
> +module_init(tdg_attest_init);
> +module_exit(tdg_attest_exit);
> +
> +MODULE_AUTHOR("Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>");
> +MODULE_DESCRIPTION("TDX attestation driver");
> +MODULE_LICENSE("GPL");
> diff --git a/include/uapi/misc/tdx.h b/include/uapi/misc/tdx.h
> new file mode 100644
> index 000000000000..da4b3866ea1b
> --- /dev/null
> +++ b/include/uapi/misc/tdx.h
> @@ -0,0 +1,37 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +#ifndef _UAPI_MISC_TDX_H
> +#define _UAPI_MISC_TDX_H
> +
> +#include <linux/types.h>
> +#include <linux/ioctl.h>
> +
> +/* Input report data length for TDX_CMD_GET_TDREPORT IOCTL request */
> +#define TDX_REPORT_DATA_LEN		64
> +
> +/* Output TD report data length after TDX_CMD_GET_TDREPORT IOCTL execution */
> +#define TDX_TDREPORT_LEN		1024
> +
> +/*
> + * TDX_CMD_GET_TDREPORT IOCTL is used to get TDREPORT data from the TDX
> + * Module. Users should pass report data of size TDX_REPORT_DATA_LEN bytes
> + * via user input buffer of size TDX_TDREPORT_LEN. Once IOCTL is successful
> + * TDREPORT data is copied to the user buffer.
> + */
> +#define TDX_CMD_GET_TDREPORT		_IOWR('T', 0x01, __u64)
> +
> +/*
> + * TDX_CMD_GEN_QUOTE IOCTL is used to request TD QUOTE from the VMM. User
> + * should pass TD report data of size TDX_TDREPORT_LEN bytes via user input
> + * buffer of quote size. Once IOCTL is successful quote data is copied back to
> + * the user buffer.
> + */
> +#define TDX_CMD_GEN_QUOTE		_IOR('T', 0x02, __u64)
> +
> +/*
> + * TDX_CMD_GET_QUOTE_SIZE IOCTL is used to get the TD Quote size info in bytes.
> + * This will be used for determining the input buffer allocation size when
> + * using TDX_CMD_GEN_QUOTE IOCTL.
> + */
> +#define TDX_CMD_GET_QUOTE_SIZE		_IOR('T', 0x03, __u64)
> +
> +#endif /* _UAPI_MISC_TDX_H */
> 

