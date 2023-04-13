Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ECEB6E0377
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 03:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbjDMBFc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 21:05:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjDMBFb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 21:05:31 -0400
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED3334C2E;
        Wed, 12 Apr 2023 18:05:30 -0700 (PDT)
Received: by mail-wm1-f48.google.com with SMTP id j16so143455wms.0;
        Wed, 12 Apr 2023 18:05:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681347929; x=1683939929;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7UkmFhtjxWacnMCiO0oQv3pNqPctVfrO7QeMfZUAp/o=;
        b=WXfUXfu106fH1coxexnbiajCnnD+MntT0bTDc9g/xygvsVK+fe2CfPs9wSradk9jgA
         a5opeeGQL5MOGDvDVfi8pg7qZjrfo/nQZmlT8wXy0RDAVN+BiiZQhJY/T6Pxt4gCbvTT
         85EVAtLdjCOlls9TsGTwUTt3KLdwzsbqkaQOGWAec2JTi+xZIkN33+Ldt+l+poSWu5gC
         pJ+lTIWDnQGwnf0R1+vPOYigWHJy+A6RP5Q/nAauh5LhpmYAynkaNuRGIlozvtqyJu0o
         RaxF7zhlf0PDVg86+m1sl1PQ1H4tqTooNUn3ZG0oLKvy1W1s/KqS5Am3sdQpHRG3SpBR
         kSMQ==
X-Gm-Message-State: AAQBX9deoecpwRnzQyXDvDovKudAbl1z8Dtx4nqC/IjR77o35CS0L81Q
        etip6SCeShsmqsT0oOQIZ0Q=
X-Google-Smtp-Source: AKy350bDDKhpd8MexEw/4tmaBStYzgn6bVDTaN7FSwiN/JqKxJOEBlxdeUeD/HykCmrarjBMVB1+fw==
X-Received: by 2002:a1c:7701:0:b0:3f0:80cf:f2d5 with SMTP id t1-20020a1c7701000000b003f080cff2d5mr48283wmi.11.1681347929308;
        Wed, 12 Apr 2023 18:05:29 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id p8-20020a05600c468800b003f09563445asm4128817wmo.0.2023.04.12.18.05.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 18:05:28 -0700 (PDT)
Date:   Thu, 13 Apr 2023 01:05:24 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Michael Kelley <mikelley@microsoft.com>
Cc:     hpa@zytor.com, kys@microsoft.com, haiyangz@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, luto@kernel.org,
        peterz@infradead.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lpieralisi@kernel.org,
        robh@kernel.org, kw@linux.com, bhelgaas@google.com, arnd@arndb.de,
        hch@lst.de, m.szyprowski@samsung.com, robin.murphy@arm.com,
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
Subject: Re: [PATCH v7 00/12] Add PCI pass-thru support to Hyper-V
 Confidential VMs
Message-ID: <ZDdVVJ2P+sJaUgtV@liuwe-devbox-debian-v2>
References: <1679838727-87310-1-git-send-email-mikelley@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1679838727-87310-1-git-send-email-mikelley@microsoft.com>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 26, 2023 at 06:51:55AM -0700, Michael Kelley wrote:
[...]
> 
> Michael Kelley (12):
>   x86/ioremap: Add hypervisor callback for private MMIO mapping in coco VM
>   x86/hyperv: Reorder code to facilitate future work
>   Drivers: hv: Explicitly request decrypted in vmap_pfn() calls
>   x86/mm: Handle decryption/re-encryption of bss_decrypted consistently
>   init: Call mem_encrypt_init() after Hyper-V hypercall init is done
>   x86/hyperv: Change vTOM handling to use standard coco mechanisms
>   swiotlb: Remove bounce buffer remapping for Hyper-V
>   Drivers: hv: vmbus: Remove second mapping of VMBus monitor pages
>   Drivers: hv: vmbus: Remove second way of mapping ring buffers
>   hv_netvsc: Remove second mapping of send and recv buffers
>   Drivers: hv: Don't remap addresses that are above shared_gpa_boundary
>   PCI: hv: Enable PCI pass-thru devices in Confidential VMs

I merged the first 6 from tip/x86/sev and then the rest directly to
hyperv-next.

The hv_netvsc patch did not apply cleanly, but that was easy to fix.

Please check hyperv-next is what you expected.

Thanks,
Wei.
