Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A92D362DFAB
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 16:21:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240505AbiKQPVk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 10:21:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240648AbiKQPUw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 10:20:52 -0500
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52A927990C;
        Thu, 17 Nov 2022 07:17:10 -0800 (PST)
Received: by mail-wm1-f43.google.com with SMTP id t4so1594391wmj.5;
        Thu, 17 Nov 2022 07:17:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QqLoz4WimLaZOBWkpHa++cXKf6tUCOzTWtaNskWwH9g=;
        b=i5g+VeGE+d7rY1AeqrFIQtYVRpDlQhNScnfUz+PDNhG3clVb7g2B2vcrN73dqwPQqA
         M0zOLmJl+fdkq1LdCNBOsMNpcMVinn8dlLuzO5H1EFgCAq4VDkj09cOmmbICGsTMAfBm
         zyWLuxjkz/BmFxlI6zJAj2EgCLXcvkFkvNX0ko9rW+kNjTenRsERcWGMrndsLLjI66bA
         7f9tbSRRy0vMhjPbBQOO9q5ZExbMTrFlr6J7TKfmWrrIOQppOIrGbB0A7m+0OD1whZUv
         EseLWuIQLYQb3R7me5WRFEnpRRmDPICxkRoLvUO6ymYeHy/SsdESpwELG7K79TlqO83f
         Q09Q==
X-Gm-Message-State: ANoB5pkpfC2yNj4fYuZAVJI2X9VQVlCgdbK2OwoMVbvRN32pU0Feokff
        BYqj3+44oEVIr9zOLvtjlH4=
X-Google-Smtp-Source: AA0mqf4oG8m5KQtZr4PdyBvld3lNlzCDl2hvGtjp3UPoMMz/kfHo1COZJFNOrwcAjA/0XDq2/6W6ew==
X-Received: by 2002:a05:600c:220b:b0:3cf:f747:71f with SMTP id z11-20020a05600c220b00b003cff747071fmr3969071wml.147.1668698206322;
        Thu, 17 Nov 2022 07:16:46 -0800 (PST)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id g17-20020a05600c4ed100b003c701c12a17sm6914886wmq.12.2022.11.17.07.16.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 07:16:45 -0800 (PST)
Date:   Thu, 17 Nov 2022 15:16:38 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Michael Kelley <mikelley@microsoft.com>
Cc:     hpa@zytor.com, kys@microsoft.com, haiyangz@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, luto@kernel.org,
        peterz@infradead.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lpieralisi@kernel.org,
        robh@kernel.org, kw@linux.com, bhelgaas@google.com, arnd@arndb.de,
        hch@infradead.org, m.szyprowski@samsung.com, robin.murphy@arm.com,
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
Subject: Re: [Patch v3 13/14] PCI: hv: Add hypercalls to read/write MMIO space
Message-ID: <Y3ZQVpkS0Hr4LsI2@liuwe-devbox-debian-v2>
References: <1668624097-14884-1-git-send-email-mikelley@microsoft.com>
 <1668624097-14884-14-git-send-email-mikelley@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1668624097-14884-14-git-send-email-mikelley@microsoft.com>
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 16, 2022 at 10:41:36AM -0800, Michael Kelley wrote:
[...]
>  
> +static void hv_pci_read_mmio(struct device *dev, phys_addr_t gpa, int size, u32 *val)
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

Perhaps adding something along this line?

	WARN_ON(!irqs_disabled());

I can fold this in if you agree.

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
> +		dev_err(dev, "MMIO read hypercall error %llx addr %llx size %d\n",
> +				ret, gpa, size);
> +}
> +
> +static void hv_pci_write_mmio(struct device *dev, phys_addr_t gpa, int size, u32 val)
> +{
> +	struct hv_mmio_write_input *in;
> +	u64 ret;
> +
> +	/*
> +	 * Must be called with interrupts disabled so it is safe
> +	 * to use the per-cpu input argument memory.
> +	 */

Ditto.

Thanks,
Wei.
