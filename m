Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA04C3C1C2D
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 01:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbhGHXjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 19:39:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbhGHXjS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 19:39:18 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A346C061574
        for <netdev@vger.kernel.org>; Thu,  8 Jul 2021 16:36:36 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id oj11-20020a17090b4d8bb029017338c124dcso2343191pjb.0
        for <netdev@vger.kernel.org>; Thu, 08 Jul 2021 16:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nrUF2fPXq862xgT7E2gc4ere6fLCl8E++7ytcPTDtto=;
        b=UqDNZ3vWp2VwGAT408NjTdqtbQPhahvj4kp7lYjfgShSIrrQXKxvQJWRwAivQe0/BZ
         UxumHTTpnwvBuEf1t4jON7TWMbCcCsVp8OL1bvifWXWpDbrQ+RjR3MSZAyzKD1N50Drp
         pGgJLS1GxiYfsnd/urF2vBKrG9s3vQeokclGZA71IVTPcDv3haA0Wx6C8mXn6kQ/7EkY
         +aHW1ZnpPMIBFqGp4YETT9Bv0YzriSag/FTPH4y8qDBmw8ebjL4ncF7hmcCoAxrtUMgf
         nOtfX6JfWOv+lhKxpJIXCAb3I3WHMtLoHSf/pGCg+85xoVtkmBP/4n5NargsHUOlouAI
         jD+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nrUF2fPXq862xgT7E2gc4ere6fLCl8E++7ytcPTDtto=;
        b=ZSAaqjHMsMqtvxRRNulPknJuWs/C73q7879EqFMBL+rq+Uzu66uWBO2Gxt13S762tX
         ZC3zrv0hPvnt5AWDKDvylSiNZT1P8j4HbB3hxF/2/dN8LVvUD7P71Z3fSZdPN1j9qIyK
         qG0ynVRk+yaNPIOB4N2Y23TLlrkYOqzpGUfk/0Cz4HJ6ttbJo5mXioQDzodMQNQgOHJp
         psD5zF/OzWhSna0WoUiCeLzeIL9M2aABIWX+YXDXDeZTFMJd8NtYBB2u1fJnax2LCXeD
         Ah5VR+2Ha2r5GfQESBIuyaz64hZ8AYmpGIO14YWUlp5lSAwuuqwzvdBrPyqjCsDotMQW
         GNBQ==
X-Gm-Message-State: AOAM5335hqt1akHir1bkJNdeyZ4AgnM6nQaxpKXvfBtRTr6okZBNP10O
        vktQvswjElqKisalIxtuz63bOUGVHBKKh1sC8CN1zA==
X-Google-Smtp-Source: ABdhPJwUDTlNIceOc8NQa9h/YJSRXs6WzcJFlVlfI20KHM9KnnBPj9dtBFnXhtFrhoLEa9dsduHxccl5/SSrey6XtUk=
X-Received: by 2002:a17:90a:ae0c:: with SMTP id t12mr7115552pjq.149.1625787395636;
 Thu, 08 Jul 2021 16:36:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210707204249.3046665-1-sathyanarayanan.kuppuswamy@linux.intel.com>
 <20210707204249.3046665-6-sathyanarayanan.kuppuswamy@linux.intel.com>
In-Reply-To: <20210707204249.3046665-6-sathyanarayanan.kuppuswamy@linux.intel.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Thu, 8 Jul 2021 16:36:24 -0700
Message-ID: <CAPcyv4h8SaVL_QGLv1DT0JuoyKmSBvxJQw0aamMuzarexaU7VA@mail.gmail.com>
Subject: Re: [PATCH v2 5/6] platform/x86: intel_tdx_attest: Add TDX Guest
 attestation interface driver
To:     Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <mgross@linux.intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Peter H Anvin <hpa@zytor.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Kirill Shutemov <kirill.shutemov@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Kuppuswamy Sathyanarayanan <knsathya@kernel.org>,
        X86 ML <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org, bpf@vger.kernel.org,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 7, 2021 at 1:43 PM Kuppuswamy Sathyanarayanan
<sathyanarayanan.kuppuswamy@linux.intel.com> wrote:
>
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
>   2. TD guest shares the TDREPORT with TD host via GetQuote hypercall
>      which is used by the host to generate a quote via quoting
>      enclave (QE).
>   3. Quote generation completion notification is sent to TD OS via
>      callback interrupt vector configured by TD using
>      SetupEventNotifyInterrupt hypercall.
>   4. After receiving the generated TDQUOTE, a remote verifier can be
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
> blob, and then output another blob. It was considered to use a sysfs
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
>  drivers/platform/x86/Kconfig            |   9 ++
>  drivers/platform/x86/Makefile           |   1 +
>  drivers/platform/x86/intel_tdx_attest.c | 171 ++++++++++++++++++++++++
>  include/uapi/misc/tdx.h                 |  37 +++++
>  4 files changed, 218 insertions(+)
>  create mode 100644 drivers/platform/x86/intel_tdx_attest.c
>  create mode 100644 include/uapi/misc/tdx.h
>
> diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
> index 60592fb88e7a..7d01c473aef6 100644
> --- a/drivers/platform/x86/Kconfig
> +++ b/drivers/platform/x86/Kconfig
> @@ -1301,6 +1301,15 @@ config INTEL_SCU_IPC_UTIL
>           low level access for debug work and updating the firmware. Say
>           N unless you will be doing this on an Intel MID platform.
>
> +config INTEL_TDX_ATTESTATION
> +       tristate "Intel TDX attestation driver"
> +       depends on INTEL_TDX_GUEST
> +       help
> +         The TDX attestation driver provides IOCTL or MMAP interfaces to
> +         the user to request TDREPORT from the TDX module or request quote
> +         from VMM. It is mainly used to get secure disk decryption keys from
> +         the key server.
> +
>  config INTEL_TELEMETRY
>         tristate "Intel SoC Telemetry Driver"
>         depends on X86_64
> diff --git a/drivers/platform/x86/Makefile b/drivers/platform/x86/Makefile
> index dcc8cdb95b4d..83439990ae47 100644
> --- a/drivers/platform/x86/Makefile
> +++ b/drivers/platform/x86/Makefile
> @@ -138,6 +138,7 @@ obj-$(CONFIG_INTEL_SCU_PCI)         += intel_scu_pcidrv.o
>  obj-$(CONFIG_INTEL_SCU_PLATFORM)       += intel_scu_pltdrv.o
>  obj-$(CONFIG_INTEL_SCU_WDT)            += intel_scu_wdt.o
>  obj-$(CONFIG_INTEL_SCU_IPC_UTIL)       += intel_scu_ipcutil.o
> +obj-$(CONFIG_INTEL_TDX_ATTESTATION)    += intel_tdx_attest.o
>  obj-$(CONFIG_INTEL_TELEMETRY)          += intel_telemetry_core.o \
>                                            intel_telemetry_pltdrv.o \
>                                            intel_telemetry_debugfs.o
> diff --git a/drivers/platform/x86/intel_tdx_attest.c b/drivers/platform/x86/intel_tdx_attest.c
> new file mode 100644
> index 000000000000..a0225d053851
> --- /dev/null
> +++ b/drivers/platform/x86/intel_tdx_attest.c
> @@ -0,0 +1,171 @@
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
> +#include <linux/io.h>
> +#include <asm/apic.h>
> +#include <asm/tdx.h>
> +#include <asm/irq_vectors.h>
> +#include <uapi/misc/tdx.h>
> +
> +#define VERSION                                "1.0"

Individual module versions are typically useless as the kernel version
is sufficient.

> +
> +/* Used in Quote memory allocation */
> +#define QUOTE_SIZE                     (2 * PAGE_SIZE)
> +
> +/* Mutex to synchronize attestation requests */
> +static DEFINE_MUTEX(attestation_lock);
> +/* Completion object to track attestation status */
> +static DECLARE_COMPLETION(attestation_done);
> +
> +static void attestation_callback_handler(void)
> +{
> +       complete(&attestation_done);
> +}
> +
> +static long tdg_attest_ioctl(struct file *file, unsigned int cmd,
> +                            unsigned long arg)
> +{
> +       u64 data = virt_to_phys(file->private_data);
> +       void __user *argp = (void __user *)arg;
> +       u8 *reportdata;
> +       long ret = 0;
> +
> +       mutex_lock(&attestation_lock);
> +
> +       reportdata = kzalloc(TDX_TDREPORT_LEN, GFP_KERNEL);
> +       if (!reportdata) {
> +               mutex_unlock(&attestation_lock);
> +               return -ENOMEM;
> +       }
> +
> +       switch (cmd) {
> +       case TDX_CMD_GET_TDREPORT:
> +               if (copy_from_user(reportdata, argp, TDX_REPORT_DATA_LEN)) {
> +                       ret = -EFAULT;
> +                       break;
> +               }
> +
> +               /* Generate TDREPORT_STRUCT */
> +               if (tdx_mcall_tdreport(data, virt_to_phys(reportdata))) {
> +                       ret = -EIO;
> +                       break;
> +               }
> +
> +               if (copy_to_user(argp, file->private_data, TDX_TDREPORT_LEN))
> +                       ret = -EFAULT;
> +               break;
> +       case TDX_CMD_GEN_QUOTE:
> +               if (copy_from_user(reportdata, argp, TDX_REPORT_DATA_LEN)) {
> +                       ret = -EFAULT;
> +                       break;
> +               }
> +
> +               /* Generate TDREPORT_STRUCT */
> +               if (tdx_mcall_tdreport(data, virt_to_phys(reportdata))) {
> +                       ret = -EIO;
> +                       break;
> +               }
> +
> +               ret = set_memory_decrypted((unsigned long)file->private_data,
> +                                          1UL << get_order(QUOTE_SIZE));
> +               if (ret)
> +                       break;
> +
> +               /* Submit GetQuote Request */
> +               if (tdx_hcall_get_quote(data)) {
> +                       ret = -EIO;
> +                       goto done;
> +               }
> +
> +               /* Wait for attestation completion */
> +               wait_for_completion_interruptible(&attestation_done);
> +
> +               if (copy_to_user(argp, file->private_data, QUOTE_SIZE))
> +                       ret = -EFAULT;
> +done:
> +               ret = set_memory_encrypted((unsigned long)file->private_data,
> +                                          1UL << get_order(QUOTE_SIZE));

This wants a get_nr_pages() helper.

> +
> +               break;
> +       case TDX_CMD_GET_QUOTE_SIZE:
> +               if (put_user(QUOTE_SIZE, (u64 __user *)argp))
> +                       ret = -EFAULT;
> +
> +               break;
> +       default:
> +               pr_err("cmd %d not supported\n", cmd);
> +               break;
> +       }
> +
> +       mutex_unlock(&attestation_lock);
> +
> +       kfree(reportdata);
> +
> +       return ret;
> +}
> +
> +static int tdg_attest_open(struct inode *inode, struct file *file)
> +{
> +       /*
> +        * Currently tdg_event_notify_handler is only used in attestation
> +        * driver. But, WRITE_ONCE is used as benign data race notice.
> +        */
> +       WRITE_ONCE(tdg_event_notify_handler, attestation_callback_handler);

Why is this ioctl not part of the driver that registered the interrupt
handler for this callback in the first instance? I've never seen this
style of cross-driver communication before.

> +
> +       file->private_data = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
> +                                                     get_order(QUOTE_SIZE));

Why does this driver abandon all semblance of type-safety and use
->private_data directly? This also seems an easy way to consume
memory, just keep opening this device over and over again.

AFAICS this buffer is only used ephemerally. I see no reason it needs
to be allocated once per open file. Unless you need several threads to
be running the attestation process in parallel just allocate a single
buffer at module init (statically defined or on the heap) and use a
lock to enforce only one user of this buffer at a time. That would
also solve your direct-map fracturing problem.

All that said, this new user ABI for passing blobs in and out of the
kernel is something that the keyutils API already does. Did you
consider add_key() / request_key() for this case? That would also be
the natural path for the end step of requesting the drive decrypt key.
I.e. a chain of key payloads starting with establishing the
attestation blob.
