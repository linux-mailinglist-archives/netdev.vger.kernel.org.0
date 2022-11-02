Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61A8161634E
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 14:03:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbiKBNDy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 09:03:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231236AbiKBNDv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 09:03:51 -0400
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDC3D1A052;
        Wed,  2 Nov 2022 06:03:50 -0700 (PDT)
Received: by mail-wm1-f54.google.com with SMTP id c3-20020a1c3503000000b003bd21e3dd7aso1250685wma.1;
        Wed, 02 Nov 2022 06:03:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J7wkCq3JYYjQNWqmOzs/TGkUKvgq+3hRmudTaSmEqPs=;
        b=XwQRABqRLMpxNtweQA7HLIzdDmpCX3HTFZtxdbdmE4O7BWTRFTdIW2y8jSrYx6ZuCt
         f+zy8LpZB3/MnZ8JlpZrnR8v6X0jCXGOCsm3Yr7LNlsJAco7xirnxKqzklia9egpV7ns
         f4OL8oyWI8QuqxDbjObzGW4lKCebg9K82FBiLPziuNWgs/W6hnQEhKl9A3EJlzWZkzS3
         nQ3egEAK5GI/hz869crd1m2mB82Y3NvjfUGxNKP4+vNGXFlJd+25CiB3IEoGHnRmIill
         RTtNB7BkH64EcQKTkxa1sC7zjVSgfTcaPLs3xMK1LsWzaltA7+DayBFGzN+nmi+L4v0t
         BK5A==
X-Gm-Message-State: ACrzQf355X1ULixKmSj/KBCQRnUdIQMfuB5MyKQfvynUXjFdIfYS0ewr
        ji3QrbRke7/yyeubr8EFdZU=
X-Google-Smtp-Source: AMsMyM5urS48hBL/wzVvS7zFzNQklaqqSmOGIMX6FChyURbZf69XiCWLf0csz6XJ5vyEJ9FlJC3Q7A==
X-Received: by 2002:a1c:4b0f:0:b0:3cf:7bdd:e00b with SMTP id y15-20020a1c4b0f000000b003cf7bdde00bmr7064625wma.110.1667394229311;
        Wed, 02 Nov 2022 06:03:49 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id q9-20020adfdfc9000000b002366d1cc198sm13262890wrn.41.2022.11.02.06.03.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 06:03:48 -0700 (PDT)
Date:   Wed, 2 Nov 2022 13:03:42 +0000
From:   Wei Liu <wei.liu@kernel.org>
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
Subject: Re: [PATCH 02/12] x86/ioapic: Gate decrypted mapping on
 cc_platform_has() attribute
Message-ID: <Y2Jqrr54LfKqHu1n@liuwe-devbox-debian-v2>
References: <1666288635-72591-1-git-send-email-mikelley@microsoft.com>
 <1666288635-72591-3-git-send-email-mikelley@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1666288635-72591-3-git-send-email-mikelley@microsoft.com>
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 20, 2022 at 10:57:05AM -0700, Michael Kelley wrote:
> Current code always maps the IOAPIC as shared (decrypted) in a
> confidential VM. But Hyper-V guest VMs on AMD SEV-SNP with vTOM
> enabled use a paravisor running in VMPL0 to emulate the IOAPIC.
> In such a case, the IOAPIC must be accessed as private (encrypted).
> 
> Fix this by gating the IOAPIC decrypted mapping on a new
> cc_platform_has() attribute that a subsequent patch in the series
> will set only for Hyper-V guests. The new attribute is named
> somewhat generically because similar paravisor emulation cases
> may arise in the future.
> 
> Signed-off-by: Michael Kelley <mikelley@microsoft.com>

Reviewed-by: Wei Liu <wei.liu@kernel.org>

> ---
>  arch/x86/kernel/apic/io_apic.c |  3 ++-
>  include/linux/cc_platform.h    | 13 +++++++++++++
>  2 files changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index a868b76..d2c1bf7 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -2686,7 +2686,8 @@ static void io_apic_set_fixmap(enum fixed_addresses idx, phys_addr_t phys)
>  	 * Ensure fixmaps for IOAPIC MMIO respect memory encryption pgprot
>  	 * bits, just like normal ioremap():
>  	 */
> -	flags = pgprot_decrypted(flags);
> +	if (!cc_platform_has(CC_ATTR_HAS_PARAVISOR))
> +		flags = pgprot_decrypted(flags);
>  
>  	__set_fixmap(idx, phys, flags);
>  }
> diff --git a/include/linux/cc_platform.h b/include/linux/cc_platform.h
> index cb0d6cd..b6c4a79 100644
> --- a/include/linux/cc_platform.h
> +++ b/include/linux/cc_platform.h
> @@ -90,6 +90,19 @@ enum cc_attr {
>  	 * Examples include TDX Guest.
>  	 */
>  	CC_ATTR_HOTPLUG_DISABLED,
> +
> +	/**
> +	 * @CC_ATTR_HAS_PARAVISOR: Guest VM is running with a paravisor
> +	 *
> +	 * The platform/OS is running as a guest/virtual machine with
> +	 * a paravisor in VMPL0. Having a paravisor affects things
> +	 * like whether the I/O APIC is emulated and operates in the
> +	 * encrypted or decrypted portion of the guest physical address
> +	 * space.
> +	 *
> +	 * Examples include Hyper-V SEV-SNP guests using vTOM.
> +	 */
> +	CC_ATTR_HAS_PARAVISOR,
>  };
>  
>  #ifdef CONFIG_ARCH_HAS_CC_PLATFORM
> -- 
> 1.8.3.1
> 
