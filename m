Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F721466576
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 15:39:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358615AbhLBOnN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 09:43:13 -0500
Received: from mail-wr1-f53.google.com ([209.85.221.53]:33539 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241837AbhLBOnM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 09:43:12 -0500
Received: by mail-wr1-f53.google.com with SMTP id d24so60233514wra.0;
        Thu, 02 Dec 2021 06:39:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=72a6A507OnldVCWrhDSc/GY7lKjxc4B5WRBxEFXAJ3U=;
        b=OvOwn9o4CByWmhPJ6wX9eFJKNYc/jeBMoH23FBpyvULTTIUpsPm646poAlYTzMsijD
         tl/Cn/vT6+tfc8IbpPA4WaXi6QTHju9OnhUgIoA4nPpenooFO+eX1NYQvVFIGE0f3eUp
         Bl1wRUNsrLV//Aj0imQev2p1Xbk2GDf7Dwsbs1TkUWfbWMKMLHQs9XeFEi2cwoaNH/TP
         RRutqs6PaqZcxqJplPHsyeUn8cQ4U5PjZfZdHku0VgX9r7dpkD38mKgAfmw/OoGLHo9Q
         o2fvp8u0m5ugxWq1L3UoXXW+3vXdQIuQvgVcwKfNWt0SqQnce69oIcAm+CwsF2vwvgLS
         OXvw==
X-Gm-Message-State: AOAM531BgqktD2QcGGCTBXdPyWblVdklHCblii1t/aXZAsIYEeFwzZGH
        o6113nZRJtpX2mP5hsE0Byk=
X-Google-Smtp-Source: ABdhPJxPzdtd3RdqIbFdq4J+qJfyoes2s3XiUvAs4cyVDgX4hcthvPCvHGkt6Ry5P/1NlIy3ec+13w==
X-Received: by 2002:adf:d4c2:: with SMTP id w2mr14815368wrk.225.1638455988303;
        Thu, 02 Dec 2021 06:39:48 -0800 (PST)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id z5sm2876037wmp.26.2021.12.02.06.39.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 06:39:47 -0800 (PST)
Date:   Thu, 2 Dec 2021 14:39:46 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Tianyu Lan <ltykernel@gmail.com>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, jgross@suse.com,
        sstabellini@kernel.org, boris.ostrovsky@oracle.com,
        joro@8bytes.org, will@kernel.org, davem@davemloft.net,
        kuba@kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com,
        arnd@arndb.de, hch@infradead.org, m.szyprowski@samsung.com,
        robin.murphy@arm.com, Tianyu.Lan@microsoft.com,
        thomas.lendacky@amd.com, xen-devel@lists.xenproject.org,
        michael.h.kelley@microsoft.com, iommu@lists.linux-foundation.org,
        linux-arch@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com, brijesh.singh@amd.com,
        konrad.wilk@oracle.com, hch@lst.de, parri.andrea@gmail.com,
        dave.hansen@intel.com
Subject: Re: [PATCH V3 2/5] x86/hyper-v: Add hyperv Isolation VM check in the
 cc_platform_has()
Message-ID: <20211202143946.7o7ncwcjq3t6xcrq@liuwe-devbox-debian-v2>
References: <20211201160257.1003912-1-ltykernel@gmail.com>
 <20211201160257.1003912-3-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211201160257.1003912-3-ltykernel@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 01, 2021 at 11:02:53AM -0500, Tianyu Lan wrote:
> From: Tianyu Lan <Tianyu.Lan@microsoft.com>
> 
> Hyper-V provides Isolation VM which has memory encrypt support. Add
> hyperv_cc_platform_has() and return true for check of GUEST_MEM_ENCRYPT
> attribute.
> 
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> ---
>  arch/x86/kernel/cc_platform.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/arch/x86/kernel/cc_platform.c b/arch/x86/kernel/cc_platform.c
> index 03bb2f343ddb..f3bb0431f5c5 100644
> --- a/arch/x86/kernel/cc_platform.c
> +++ b/arch/x86/kernel/cc_platform.c
> @@ -11,6 +11,7 @@
>  #include <linux/cc_platform.h>
>  #include <linux/mem_encrypt.h>
>  
> +#include <asm/mshyperv.h>
>  #include <asm/processor.h>
>  
>  static bool __maybe_unused intel_cc_platform_has(enum cc_attr attr)
> @@ -58,9 +59,23 @@ static bool amd_cc_platform_has(enum cc_attr attr)
>  #endif
>  }
>  
> +static bool hyperv_cc_platform_has(enum cc_attr attr)
> +{
> +#ifdef CONFIG_HYPERV
> +	if (attr == CC_ATTR_GUEST_MEM_ENCRYPT)
> +		return true;
> +	else
> +		return false;

This can be simplified as

	return attr == CC_ATTR_GUEST_MEM_ENCRYPT;


Wei.
