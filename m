Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83117606897
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 21:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbiJTTEd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 15:04:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiJTTEa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 15:04:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C34D12A86;
        Thu, 20 Oct 2022 12:04:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC58761CDB;
        Thu, 20 Oct 2022 19:04:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9294C433D6;
        Thu, 20 Oct 2022 19:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666292667;
        bh=HR30xac7/0YN9/YwEhlF6z4rb2w90/XCBJ4nOHc4JoI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=Pb2vN61GH6AyB/9TndECIzbx7fKtS3d7yJ6Tb8Sfw/uoqPO4ByAHO17ZJfegVtIlD
         rSfJOBKQhzM7LxnxtlktqClL1O/tRD4Ae1ht9n4dho7mwAklUAy5PzzGb7JAjwluLZ
         n8ze8fw/7wasYn87KfWwq/K43u3Y7nA/3f9/A2Dhbl31HAo7n2sLJ04aaEiO+GcoiJ
         xalfYfmUaAmFChDgmY+R4NsQuEfVyHGmwAe/ONKqoXXwb5Q+uOfiaKPtzOtqgkQEam
         GD2o4GPtlYujTfy26V/xxzMKExgwEHN5f4O6pR7YED1It55IYIb48cVFDT60Ey8f7U
         9T2TPD4p35uOA==
Date:   Thu, 20 Oct 2022 14:04:25 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Michael Kelley <mikelley@microsoft.com>
Cc:     hpa@zytor.com, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
        luto@kernel.org, peterz@infradead.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        lpieralisi@kernel.org, robh@kernel.org, kw@linux.com,
        bhelgaas@google.com, arnd@arndb.de, hch@infradead.org,
        m.szyprowski@samsung.com, robin.murphy@arm.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        Tianyu.Lan@microsoft.com, kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, dan.j.williams@intel.com,
        jane.chu@oracle.com, seanjc@google.com, tony.luck@intel.com,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-arch@vger.kernel.org,
        iommu@lists.linux.dev
Subject: Re: [PATCH 11/12] PCI: hv: Add hypercalls to read/write MMIO space
Message-ID: <20221020190425.GA139674@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1666288635-72591-12-git-send-email-mikelley@microsoft.com>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 20, 2022 at 10:57:14AM -0700, Michael Kelley wrote:
> To support PCI pass-thru devices in Confidential VMs, Hyper-V
> has added hypercalls to read and write MMIO space. Add the
> appropriate definitions to hyperv-tlfs.h and implement
> functions to make the hypercalls. These functions are used
> in a subsequent patch.
> 
> Co-developed-by: Dexuan Cui <decui@microsoft.com>
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> Signed-off-by: Michael Kelley <mikelley@microsoft.com>
> ---
>  arch/x86/include/asm/hyperv-tlfs.h  |  3 ++
>  drivers/pci/controller/pci-hyperv.c | 62 +++++++++++++++++++++++++++++++++++++
>  include/asm-generic/hyperv-tlfs.h   | 22 +++++++++++++
>  3 files changed, 87 insertions(+)
> 
> diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
> index 3089ec3..f769b9d 100644
> --- a/arch/x86/include/asm/hyperv-tlfs.h
> +++ b/arch/x86/include/asm/hyperv-tlfs.h
> @@ -117,6 +117,9 @@
>  /* Recommend using enlightened VMCS */
>  #define HV_X64_ENLIGHTENED_VMCS_RECOMMENDED		BIT(14)
>  
> +/* Use hypercalls for MMIO config space access */
> +#define HV_X64_USE_MMIO_HYPERCALLS			BIT(21)
> +
>  /*
>   * CPU management features identification.
>   * These are HYPERV_CPUID_CPU_MANAGEMENT_FEATURES.EAX bits.
> diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/pci-hyperv.c
> index e7c6f66..02ebf3e 100644
> --- a/drivers/pci/controller/pci-hyperv.c
> +++ b/drivers/pci/controller/pci-hyperv.c
> @@ -1054,6 +1054,68 @@ static int wslot_to_devfn(u32 wslot)
>  	return PCI_DEVFN(slot_no.bits.dev, slot_no.bits.func);
>  }
>  
> +static void hv_pci_read_mmio(phys_addr_t gpa, int size, u32 *val)
> +{
> +	struct hv_mmio_read_input *in;
> +	struct hv_mmio_read_output *out;
> +	u64 ret;
> +
> +	/*
> +	 * Must be called with interrupts disabled so it is safe
> +	 * to use the per-cpu input argument page.  Use it for
> +	 * both input and output.
> +	 */
> +	in = *this_cpu_ptr(hyperv_pcpu_input_arg);
> +	out = *this_cpu_ptr(hyperv_pcpu_input_arg) + sizeof(*in);
> +	in->gpa = gpa;
> +	in->size = size;
> +
> +	ret = hv_do_hypercall(HVCALL_MMIO_READ, in, out);
> +	if (hv_result_success(ret)) {
> +		switch (size) {
> +		case 1:
> +			*val = *(u8 *)(out->data);
> +			break;
> +		case 2:
> +			*val = *(u16 *)(out->data);
> +			break;
> +		default:
> +			*val = *(u32 *)(out->data);
> +			break;
> +		}
> +	} else
> +		pr_err("MMIO read hypercall failed with status %llx\n", ret);

Too bad there's not more information to give the user/administrator
here.  Seeing "MMIO read hypercall failed with status -5" in the log
doesn't give many clues about where to look or who to notify.  I don't
know what's even feasible, but driver name, device, address (gpa),
size would all be possibilities.

Bjorn
