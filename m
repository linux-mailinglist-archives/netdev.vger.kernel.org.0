Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 983C26265FE
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 01:21:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234547AbiKLAVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 19:21:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234004AbiKLAVu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 19:21:50 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C031B326F9;
        Fri, 11 Nov 2022 16:21:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668212509; x=1699748509;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=j1lAUzMwl/IGPrbGdS61ib0IEbELaXeyWascY1TXhxo=;
  b=Ugre5rkE3FlJ3XxuWlarXoyItNnZipTMO4CFEsg6EPPrGrEGttw4LTaw
   BjAkbE13fq71CpIJfHLCVdPWarD4HyFP+N4ZqBa5BXMxrkeX2aRJmcuHm
   WSiBjNphklaQsL4CRr563oIO846cHe3xHe2mAjsbVOy1MJpZ9T+XL32Ya
   UwVLprgfZRzNnzpSypvYSFU45oaeJtlmmijz42XreTwQ0mXGy1YFoFjAA
   M03Zl4SfrBl8iX5HCz6PIjfmuG+CtFSR+n+riNnbeb6pc1AlxF178t8FS
   GE0JQyUKLcsu1EP578/JRt4ws25sjqs0YP5QmzwyH6XaYy7hpNqz/dnaY
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10528"; a="397977633"
X-IronPort-AV: E=Sophos;i="5.96,157,1665471600"; 
   d="scan'208";a="397977633"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2022 16:21:49 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10528"; a="726928308"
X-IronPort-AV: E=Sophos;i="5.96,157,1665471600"; 
   d="scan'208";a="726928308"
Received: from nmpoonaw-mobl1.amr.corp.intel.com (HELO [10.252.134.46]) ([10.252.134.46])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2022 16:21:47 -0800
Message-ID: <50a8517d-328e-2178-e98c-4b160456e092@intel.com>
Date:   Fri, 11 Nov 2022 16:21:45 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v2 02/12] x86/ioapic: Gate decrypted mapping on
 cc_platform_has() attribute
Content-Language: en-US
To:     Michael Kelley <mikelley@microsoft.com>, hpa@zytor.com,
        kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, luto@kernel.org, peterz@infradead.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lpieralisi@kernel.org, robh@kernel.org,
        kw@linux.com, bhelgaas@google.com, arnd@arndb.de,
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
References: <1668147701-4583-1-git-send-email-mikelley@microsoft.com>
 <1668147701-4583-3-git-send-email-mikelley@microsoft.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <1668147701-4583-3-git-send-email-mikelley@microsoft.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/10/22 22:21, Michael Kelley wrote:
>  	 * Ensure fixmaps for IOAPIC MMIO respect memory encryption pgprot
>  	 * bits, just like normal ioremap():
>  	 */
> -	flags = pgprot_decrypted(flags);
> +	if (!cc_platform_has(CC_ATTR_HAS_PARAVISOR))
> +		flags = pgprot_decrypted(flags);

This begs the question whether *all* paravisors will want to avoid a
decrypted ioapic mapping.  Is this _fundamental_ to paravisors, or it is
an implementation detail of this _individual_ paravisor?
