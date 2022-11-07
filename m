Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAF5462015F
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 22:42:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233527AbiKGVl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 16:41:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233587AbiKGVl4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 16:41:56 -0500
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2362727DE1;
        Mon,  7 Nov 2022 13:41:55 -0800 (PST)
Received: by mail-qt1-x833.google.com with SMTP id w4so7741695qts.0;
        Mon, 07 Nov 2022 13:41:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mhEhlO9BLGKEY6Yqi7hGqFOIYTu5QOOEtbbHam2qFJM=;
        b=RnM1+DkcFQ6UXJxAOxtAuPhnVR9BbQiDX6ZgETnxOGAF0OlGJ5m5AazkqVx6AYI/SK
         8fOthChr5nvVBcCL4vXEujC5S2Z3x/8pGARexjgdvsDoYjfN1ZgSZUoyjE7MH+Ta+Anx
         2i3ZXjVLmPV0o2tzsd/X1LOMoDoknuAG+XENX/EAxkBBrs0m8HBrPA82Tf36ry5oTLch
         OQP/s4QP6h//oA/78gJSRpjKTvuEl4OFx7Y7yW0ngkpFEKkvHia5mvlUsImWS7GU/u90
         YK61GpWpDEAGp/9hLU2JR5aD/RWBIL5hUh56J9O7xmI9oFybriip0xZZ+fD6YXZnLXv8
         B0eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mhEhlO9BLGKEY6Yqi7hGqFOIYTu5QOOEtbbHam2qFJM=;
        b=5cq/trRb+okTkR3FL2v7jT0KumerI7u72Kp5Zx6CfYhJzau9XSJoGrndTyFeurRHl+
         qVTQG384x7Hn5n31kRb2w5IL4YSTTp/BuK14fd5R+Dhl1J3qCUEkZsBFBQdqmfcuk09O
         fIzky6uCvgu0kGy0Bwcdskgw9O64dzb02FoUvopphEyI9wd+UJ1ZkD9RYwXiEM/ch3LB
         zu27d0heFn4XmLTKNiqmcAsUQl131V7zRHcLIx2u0HtDFDPS7PvaxaR/MoiWbv3N1aNo
         O0piGL0WZWTC4BhdK/mkD87Q6sCtrK2mw3e8imQ+WS+TOg24EcPsk7OunKON2ISP8+UR
         GdTA==
X-Gm-Message-State: ACrzQf3IWR5Sa5U+Vd7nsuKFhv89k0/6nMG61s7kEMuVenNqQjHA+IQM
        zM43G71E937OxokwvmAkm4I=
X-Google-Smtp-Source: AMsMyM6FdPpyofjZ5SSntkGBumh4HKwAeGeJKmMimsoW1bcBh45XGtgSOOLxRbjTq9vCjAE29AA6zA==
X-Received: by 2002:ac8:44cc:0:b0:3a5:6d4e:5370 with SMTP id b12-20020ac844cc000000b003a56d4e5370mr13549586qto.536.1667857314129;
        Mon, 07 Nov 2022 13:41:54 -0800 (PST)
Received: from auth1-smtp.messagingengine.com (auth1-smtp.messagingengine.com. [66.111.4.227])
        by smtp.gmail.com with ESMTPSA id bm22-20020a05620a199600b006bb2cd2f6d1sm7659519qkb.127.2022.11.07.13.41.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 13:41:53 -0800 (PST)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailauth.nyi.internal (Postfix) with ESMTP id A2B3727C0054;
        Mon,  7 Nov 2022 16:41:52 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 07 Nov 2022 16:41:52 -0500
X-ME-Sender: <xms:nntpY-oqhvTD9lA8nYyeukDNV09Tqz5jOGdu-MoaOqN9lMMYTv71ww>
    <xme:nntpY8qdXGtP5-tC7LLEFsWTk-s59BYt7vC7dJ79YjnA-G9Tg7f55xl0DX1WSw5vD
    0ErUlqKEjnXQDy6sA>
X-ME-Received: <xmr:nntpYzMDy4Xrjzfsw7JEnIvamP65HayLo8ic4JfdeT8bnvjuw-98MJrI-f3q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrvdekgdduhedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehoqhhu
    nhcuhfgvnhhguceosghoqhhunhdrfhgvnhhgsehgmhgrihhlrdgtohhmqeenucggtffrrg
    htthgvrhhnpefhtedvgfdtueekvdekieetieetjeeihedvteehuddujedvkedtkeefgedv
    vdehtdenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomhepsghoqhhunhdomhgvshhmthhprghuthhh
    phgvrhhsohhnrghlihhthidqieelvdeghedtieegqddujeejkeehheehvddqsghoqhhunh
    drfhgvnhhgpeepghhmrghilhdrtghomhesfhhigihmvgdrnhgrmhgv
X-ME-Proxy: <xmx:nntpY96aN862kjNdJaCbBNslrA8nN5cwDSINSlmEp86JOLC3Ln_D9g>
    <xmx:nntpY94ovEe1Ol98OTc3xfXp-u_MLdRji-ez9MRHXpljfTe0cau52w>
    <xmx:nntpY9h2Y0lb8MZf4FDo_2Q7fW-RPIIrbZwCS4PAO2yyHiKGspu-cQ>
    <xmx:oHtpY67iiuZm17eC1_sLbC5Mk4ZJQEl3bwUPOnxWMc6bG1OSmM5k0E8L09s>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 7 Nov 2022 16:41:49 -0500 (EST)
Date:   Mon, 7 Nov 2022 13:41:48 -0800
From:   Boqun Feng <boqun.feng@gmail.com>
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
Subject: Re: [PATCH 12/12] PCI: hv: Enable PCI pass-thru devices in
 Confidential VMs
Message-ID: <Y2l7nJ3l1jeOebGG@Boquns-Mac-mini.local>
References: <1666288635-72591-1-git-send-email-mikelley@microsoft.com>
 <1666288635-72591-13-git-send-email-mikelley@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1666288635-72591-13-git-send-email-mikelley@microsoft.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 20, 2022 at 10:57:15AM -0700, Michael Kelley wrote:
> For PCI pass-thru devices in a Confidential VM, Hyper-V requires
> that PCI config space be accessed via hypercalls.  In normal VMs,
> config space accesses are trapped to the Hyper-V host and emulated.
> But in a confidential VM, the host can't access guest memory to
> decode the instruction for emulation, so an explicit hypercall must
> be used.
> 
> Update the PCI config space access functions to use the hypercalls
> when such use is indicated by Hyper-V flags.  Also, set the flag to
> allow the Hyper-V PCI driver to be loaded and used in a Confidential
> VM (a.k.a., "Isolation VM").  The driver has previously been hardened
> against a malicious Hyper-V host[1].
> 
> [1] https://lore.kernel.org/all/20220511223207.3386-2-parri.andrea@gmail.com/
> 
> Co-developed-by: Dexuan Cui <decui@microsoft.com>
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> Signed-off-by: Michael Kelley <mikelley@microsoft.com>
> ---
>  drivers/hv/channel_mgmt.c           |   2 +-
>  drivers/pci/controller/pci-hyperv.c | 153 +++++++++++++++++++++---------------
>  2 files changed, 92 insertions(+), 63 deletions(-)
> 
> diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
> index 5b12040..c0f9ac2 100644
> --- a/drivers/hv/channel_mgmt.c
> +++ b/drivers/hv/channel_mgmt.c
> @@ -67,7 +67,7 @@
>  	{ .dev_type = HV_PCIE,
>  	  HV_PCIE_GUID,
>  	  .perf_device = false,
> -	  .allowed_in_isolated = false,
> +	  .allowed_in_isolated = true,
>  	},
>  
>  	/* Synthetic Frame Buffer */
> diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/pci-hyperv.c
> index 02ebf3e..9873296 100644
> --- a/drivers/pci/controller/pci-hyperv.c
> +++ b/drivers/pci/controller/pci-hyperv.c
> @@ -514,6 +514,7 @@ struct hv_pcibus_device {
>  
>  	/* Highest slot of child device with resources allocated */
>  	int wslot_res_allocated;
> +	bool use_calls; /* Use hypercalls to access mmio cfg space */
>  
>  	/* hypercall arg, must not cross page boundary */
>  	struct hv_retarget_device_interrupt retarget_msi_interrupt_params;
> @@ -1134,8 +1135,9 @@ static void hv_pci_write_mmio(phys_addr_t gpa, int size, u32 val)
>  static void _hv_pcifront_read_config(struct hv_pci_dev *hpdev, int where,
>  				     int size, u32 *val)
>  {
> +	struct hv_pcibus_device *hbus = hpdev->hbus;
> +	int offset = where + CFG_PAGE_OFFSET;
>  	unsigned long flags;
> -	void __iomem *addr = hpdev->hbus->cfg_addr + CFG_PAGE_OFFSET + where;
>  
>  	/*
>  	 * If the attempt is to read the IDs or the ROM BAR, simulate that.
> @@ -1163,56 +1165,74 @@ static void _hv_pcifront_read_config(struct hv_pci_dev *hpdev, int where,
>  		 */
>  		*val = 0;
>  	} else if (where + size <= CFG_PAGE_SIZE) {
> -		spin_lock_irqsave(&hpdev->hbus->config_lock, flags);
> -		/* Choose the function to be read. (See comment above) */
> -		writel(hpdev->desc.win_slot.slot, hpdev->hbus->cfg_addr);
> -		/* Make sure the function was chosen before we start reading. */
> -		mb();
> -		/* Read from that function's config space. */
> -		switch (size) {
> -		case 1:
> -			*val = readb(addr);
> -			break;
> -		case 2:
> -			*val = readw(addr);
> -			break;
> -		default:
> -			*val = readl(addr);
> -			break;
> +
> +		spin_lock_irqsave(&hbus->config_lock, flags);
> +		if (hbus->use_calls) {
> +			phys_addr_t addr = hbus->mem_config->start + offset;
> +
> +			hv_pci_write_mmio(hbus->mem_config->start, 4,
> +						hpdev->desc.win_slot.slot);
> +			hv_pci_read_mmio(addr, size, val);
> +		} else {
> +			void __iomem *addr = hbus->cfg_addr + offset;
> +
> +			/* Choose the function to be read. (See comment above) */
> +			writel(hpdev->desc.win_slot.slot, hbus->cfg_addr);
> +			/* Make sure the function was chosen before reading. */
> +			mb();
> +			/* Read from that function's config space. */
> +			switch (size) {
> +			case 1:
> +				*val = readb(addr);
> +				break;
> +			case 2:
> +				*val = readw(addr);
> +				break;
> +			default:
> +				*val = readl(addr);
> +				break;
> +			}

An mb() is missing here?

>  		}
> -		/*
> -		 * Make sure the read was done before we release the spinlock
> -		 * allowing consecutive reads/writes.
> -		 */
> -		mb();
> -		spin_unlock_irqrestore(&hpdev->hbus->config_lock, flags);
> +		spin_unlock_irqrestore(&hbus->config_lock, flags);
>  	} else {
> -		dev_err(&hpdev->hbus->hdev->device,
> +		dev_err(&hbus->hdev->device,
>  			"Attempt to read beyond a function's config space.\n");
>  	}
>  }
>  
>  static u16 hv_pcifront_get_vendor_id(struct hv_pci_dev *hpdev)
>  {
> +	struct hv_pcibus_device *hbus = hpdev->hbus;
> +	u32 val;
>  	u16 ret;
>  	unsigned long flags;
> -	void __iomem *addr = hpdev->hbus->cfg_addr + CFG_PAGE_OFFSET +
> -			     PCI_VENDOR_ID;
>  
> -	spin_lock_irqsave(&hpdev->hbus->config_lock, flags);
> +	spin_lock_irqsave(&hbus->config_lock, flags);
>  
> -	/* Choose the function to be read. (See comment above) */
> -	writel(hpdev->desc.win_slot.slot, hpdev->hbus->cfg_addr);
> -	/* Make sure the function was chosen before we start reading. */
> -	mb();
> -	/* Read from that function's config space. */
> -	ret = readw(addr);
> -	/*
> -	 * mb() is not required here, because the spin_unlock_irqrestore()
> -	 * is a barrier.
> -	 */
> +	if (hbus->use_calls) {
> +		phys_addr_t addr = hbus->mem_config->start +
> +					 CFG_PAGE_OFFSET + PCI_VENDOR_ID;
> +
> +		hv_pci_write_mmio(hbus->mem_config->start, 4,
> +					hpdev->desc.win_slot.slot);
> +		hv_pci_read_mmio(addr, 2, &val);
> +		ret = val;  /* Truncates to 16 bits */
> +	} else {
> +		void __iomem *addr = hbus->cfg_addr + CFG_PAGE_OFFSET +
> +					     PCI_VENDOR_ID;
> +		/* Choose the function to be read. (See comment above) */
> +		writel(hpdev->desc.win_slot.slot, hbus->cfg_addr);
> +		/* Make sure the function was chosen before we start reading. */
> +		mb();
> +		/* Read from that function's config space. */
> +		ret = readw(addr);
> +		/*
> +		 * mb() is not required here, because the
> +		 * spin_unlock_irqrestore() is a barrier.
> +		 */
> +	}
>  
> -	spin_unlock_irqrestore(&hpdev->hbus->config_lock, flags);
> +	spin_unlock_irqrestore(&hbus->config_lock, flags);
>  
>  	return ret;
>  }
> @@ -1227,38 +1247,45 @@ static u16 hv_pcifront_get_vendor_id(struct hv_pci_dev *hpdev)
>  static void _hv_pcifront_write_config(struct hv_pci_dev *hpdev, int where,
>  				      int size, u32 val)
>  {
> +	struct hv_pcibus_device *hbus = hpdev->hbus;
> +	int offset = where + CFG_PAGE_OFFSET;
>  	unsigned long flags;
> -	void __iomem *addr = hpdev->hbus->cfg_addr + CFG_PAGE_OFFSET + where;
>  
>  	if (where >= PCI_SUBSYSTEM_VENDOR_ID &&
>  	    where + size <= PCI_CAPABILITY_LIST) {
>  		/* SSIDs and ROM BARs are read-only */
>  	} else if (where >= PCI_COMMAND && where + size <= CFG_PAGE_SIZE) {
> -		spin_lock_irqsave(&hpdev->hbus->config_lock, flags);
> -		/* Choose the function to be written. (See comment above) */
> -		writel(hpdev->desc.win_slot.slot, hpdev->hbus->cfg_addr);
> -		/* Make sure the function was chosen before we start writing. */
> -		wmb();
> -		/* Write to that function's config space. */
> -		switch (size) {
> -		case 1:
> -			writeb(val, addr);
> -			break;
> -		case 2:
> -			writew(val, addr);
> -			break;
> -		default:
> -			writel(val, addr);
> -			break;
> +		spin_lock_irqsave(&hbus->config_lock, flags);
> +
> +		if (hbus->use_calls) {
> +			phys_addr_t addr = hbus->mem_config->start + offset;
> +
> +			hv_pci_write_mmio(hbus->mem_config->start, 4,
> +						hpdev->desc.win_slot.slot);
> +			hv_pci_write_mmio(addr, size, val);
> +		} else {
> +			void __iomem *addr = hbus->cfg_addr + offset;
> +
> +			/* Choose the function to write. (See comment above) */
> +			writel(hpdev->desc.win_slot.slot, hbus->cfg_addr);
> +			/* Make sure the function was chosen before writing. */
> +			wmb();
> +			/* Write to that function's config space. */
> +			switch (size) {
> +			case 1:
> +				writeb(val, addr);
> +				break;
> +			case 2:
> +				writew(val, addr);
> +				break;
> +			default:
> +				writel(val, addr);
> +				break;
> +			}

Ditto, an mb() is needed here to align with the old code.

With these fixed, feel free to add

Reviewed-by: Boqun Feng <boqun.feng@gmail.com>

Regards,
BOqun

>  		}
> -		/*
> -		 * Make sure the write was done before we release the spinlock
> -		 * allowing consecutive reads/writes.
> -		 */
> -		mb();
> -		spin_unlock_irqrestore(&hpdev->hbus->config_lock, flags);
> +		spin_unlock_irqrestore(&hbus->config_lock, flags);
>  	} else {
> -		dev_err(&hpdev->hbus->hdev->device,
> +		dev_err(&hbus->hdev->device,
>  			"Attempt to write beyond a function's config space.\n");
>  	}
>  }
> @@ -3568,6 +3595,7 @@ static int hv_pci_probe(struct hv_device *hdev,
>  	hbus->bridge->domain_nr = dom;
>  #ifdef CONFIG_X86
>  	hbus->sysdata.domain = dom;
> +	hbus->use_calls = !!(ms_hyperv.hints & HV_X64_USE_MMIO_HYPERCALLS);
>  #elif defined(CONFIG_ARM64)
>  	/*
>  	 * Set the PCI bus parent to be the corresponding VMbus
> @@ -3577,6 +3605,7 @@ static int hv_pci_probe(struct hv_device *hdev,
>  	 * information to devices created on the bus.
>  	 */
>  	hbus->sysdata.parent = hdev->device.parent;
> +	hbus->use_calls = false;
>  #endif
>  
>  	hbus->hdev = hdev;
> -- 
> 1.8.3.1
> 
> 
