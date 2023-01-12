Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88D1866743A
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 15:04:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234004AbjALOEA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 09:04:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234697AbjALODn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 09:03:43 -0500
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEB2D532AC;
        Thu, 12 Jan 2023 06:03:39 -0800 (PST)
Received: by mail-wm1-f44.google.com with SMTP id m8-20020a05600c3b0800b003d96f801c48so16636083wms.0;
        Thu, 12 Jan 2023 06:03:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i3Z/l312HDGa8/vxCVX5Bvnphzfpdnx1DzW2sgn2w3w=;
        b=v80kbZiV7gUQK3JkihkyW0n0zmacdGefviOzKmistHUr6t5Su7EgMGMeg1BW9nJo7n
         FZiosCHJETey/iPopc58wHbqBYezWpJELXgAqbHpk80faXsXqxJmR8iQCp0P/mE1D3VB
         sRsXRIhjziR1ItYxAj5fYIkLZMQwu3nAvei1tVXXrm7w34DqLRpFBRD9u4IsvqfF16yr
         P+l0MUO8NR+5qO9PcGBFYyKvYs449ZVd5VHpDOT3SZx83uw4RMjvoLQSIVgT+9GVGq1C
         /HGDAi1kNtAw+JWayk2Qd/44RBexkoK0duELVRiHISLfrvZ+XJmCSxBWj8z5uZcNXfTE
         zLSg==
X-Gm-Message-State: AFqh2ko85HwjjU8mAXNHbdbB9HCM7hH50UnMQMFJdiW5j2V1ujoG8kQw
        7pIsQ2avsfX4HUGF480zwx4=
X-Google-Smtp-Source: AMrXdXvSq19ZKhD7XOusPuFTaVJTAHVinLgrUB+UQu5hH5s7XUOSBwHw7yRRNmdQxULBGKzHgvC0tw==
X-Received: by 2002:a05:600c:3509:b0:3c6:e60f:3f6f with SMTP id h9-20020a05600c350900b003c6e60f3f6fmr54630895wmq.38.1673532218180;
        Thu, 12 Jan 2023 06:03:38 -0800 (PST)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id y6-20020a1c4b06000000b003da119d7251sm2673448wma.21.2023.01.12.06.03.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 06:03:37 -0800 (PST)
Date:   Thu, 12 Jan 2023 14:03:35 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Michael Kelley <mikelley@microsoft.com>, wei.liu@kernel.org,
        hpa@zytor.com, kys@microsoft.com, haiyangz@microsoft.com,
        decui@microsoft.com, luto@kernel.org, peterz@infradead.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lpieralisi@kernel.org, robh@kernel.org,
        kw@linux.com, bhelgaas@google.com, arnd@arndb.de,
        hch@infradead.org, m.szyprowski@samsung.com, robin.murphy@arm.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com, tglx@linutronix.de,
        mingo@redhat.com, dave.hansen@linux.intel.com,
        Tianyu.Lan@microsoft.com, kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, dan.j.williams@intel.com,
        jane.chu@oracle.com, seanjc@google.com, tony.luck@intel.com,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-arch@vger.kernel.org,
        iommu@lists.linux.dev
Subject: Re: [Patch v4 00/13] Add PCI pass-thru support to Hyper-V
 Confidential VMs
Message-ID: <Y8ATN9mPCx6P4vB6@liuwe-devbox-debian-v2>
References: <1669951831-4180-1-git-send-email-mikelley@microsoft.com>
 <Y7xhLCgCq0MOsqxH@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7xhLCgCq0MOsqxH@zn.tnic>
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 09, 2023 at 07:47:08PM +0100, Borislav Petkov wrote:
> On Thu, Dec 01, 2022 at 07:30:18PM -0800, Michael Kelley wrote:
> > This patch series adds support for PCI pass-thru devices to Hyper-V
> > Confidential VMs (also called "Isolation VMs"). But in preparation, it
> > first changes how private (encrypted) vs. shared (decrypted) memory is
> > handled in Hyper-V SEV-SNP guest VMs. The new approach builds on the
> > confidential computing (coco) mechanisms introduced in the 5.19 kernel
> > for TDX support and significantly reduces the amount of Hyper-V specific
> > code. Furthermore, with this new approach a proposed RFC patch set for
> > generic DMA layer functionality[1] is no longer necessary.
> 
> In any case, this is starting to get ready - how do we merge this?
> 
> I apply the x86 bits and give Wei an immutable branch to add the rest of the
> HyperV stuff ontop?

I can take all the patches if that's easier for you. I don't think
anyone else is depending on the x86 patches in this series.

Giving me an immutable branch works too.

Thanks,
Wei.

> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette
