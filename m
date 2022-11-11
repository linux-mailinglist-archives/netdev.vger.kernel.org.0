Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 498CD625FC3
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 17:45:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233688AbiKKQo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 11:44:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232004AbiKKQo6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 11:44:58 -0500
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C041383B9D;
        Fri, 11 Nov 2022 08:44:56 -0800 (PST)
Received: by mail-wm1-f50.google.com with SMTP id v7so3255062wmn.0;
        Fri, 11 Nov 2022 08:44:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UXPe6WX8jBjWxRwy3pL5D2Wep2saGki4oUGtlWeziig=;
        b=lCAoP1Xr5XxJfhkEbEfYwx3rNXiF+zamx73gXcE8fPixkZwSpQkuVadYOWqQGYv4dM
         nE/EFknjTL1dUkLl/U4yztZEPqcXsIa+t6BfqCay7G6xFw5hcCiSdFrLFrxRho8Hg5pJ
         HG+llqempdKortXC3zYpmNyHGNp4fsaDAiauJi/u3bewOPhy7oOuWbUwTQ3hFmmO1FBL
         NzD6HCaLhtYINLn93/QEwZaYBbGFwvh38Dw3mrPjybAi825onInryicSt0erAimwJy5q
         oPKsv9rd/XA0A4cd27puSIthLPZANZJ2fH7dDIJI6GhY+iFNgo32RdITlTRarRebTrKx
         asYA==
X-Gm-Message-State: ANoB5png+VSceECWlN8gGcltmG6A8oYUM/uQjvA7Ry9jMUk388+Eii5/
        tzKI2YS44omaBjQhsZ5Ncls=
X-Google-Smtp-Source: AA0mqf5Sn0xQORHJpQN6R8VYO4G2A2ivXDMnYvQDhL1ytehzwGpbrmIn369cEycyw74wQAil/XuM7w==
X-Received: by 2002:a05:600c:2195:b0:3cf:6c2f:950c with SMTP id e21-20020a05600c219500b003cf6c2f950cmr1893974wme.146.1668185095259;
        Fri, 11 Nov 2022 08:44:55 -0800 (PST)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id c2-20020a5d4cc2000000b0023655e51c14sm2282939wrt.32.2022.11.11.08.44.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Nov 2022 08:44:54 -0800 (PST)
Date:   Fri, 11 Nov 2022 16:44:52 +0000
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
Subject: Re: [PATCH v2 00/12] Drivers: hv: Add PCI pass-thru support to
 Hyper-V Confidential VMs
Message-ID: <Y258BO8ohVtVZvSH@liuwe-devbox-debian-v2>
References: <1668147701-4583-1-git-send-email-mikelley@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1668147701-4583-1-git-send-email-mikelley@microsoft.com>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 10, 2022 at 10:21:29PM -0800, Michael Kelley wrote:
[...]
> Patch Organization
> ==================
> Patch 1 fixes a bug in __ioremap_caller() that affects the
> existing Hyper-V code after the change to treat the vTOM bit as
> a protection flag. Fixing the bug allows the old code to continue
> to run until later patches in the series remove or update it.
> This sequencing avoids the need to enable the new approach and
> remove the old code in a single large patch.
> 
> Patch 2 handles the I/O APIC quirk by defining a new CC_ATTR enum
> member that is set only when running on Hyper-V.

I'm waiting for x86 maintainers acks on these two patches before merging
this series.

Thanks,
Wei.
